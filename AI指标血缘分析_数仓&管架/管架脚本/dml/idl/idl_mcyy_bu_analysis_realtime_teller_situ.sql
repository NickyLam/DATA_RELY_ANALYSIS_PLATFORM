/*
Purpose:    柜员考勤情况实时统计
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔5分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20210719
Logs:

-- 生成的IDL层表 ：mcyy_bu_analysis_realtime
-- 以下为依赖了上游的表 (OGG实时表):


生成指标列表

1	WD010401		实时在线人员
2	WD010402		实时离线人员
3	WD010403		实时离线次数
4	WD010404		实时工作总时长
5	WD010405		实时在线交易时长
6	WD010406		实时在线空闲时长
7	WD010407		实时离柜时长

*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 0.2 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.mbar_teller_situ_${batch_date}_tm purge ;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mbar_teller_situ_${batch_date}_tm
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.mcyy_bu_analysis_realtime
where 0=1;

set serveroutput on 
DECLARE
	CURSOR  CUR_RUN_LOGS IS 
	SELECT log_id
      ,index_no
      ,sum_start_time
      ,sum_end_time
      ,(CASE
           WHEN run_sts = '1' THEN
            '补跑'
           ELSE
            '正常'
       END) AS run_flag --批次类型判断
FROM   mcyy_realtime_run_log
WHERE  etl_dt = to_date('${batch_date}' ,'yyyymmdd')
AND    ((run_sts = 0) --正常批次                     
      OR run_sts = 1 AND to_char(SYSDATE,'HH24MM') -
      to_char(start_time,'HH24MM') >= 5) --补跑批次
AND    to_date(sum_end_time,'yyyy-mm-dd hh24:mi:ss') <= SYSDATE
--AND    index_no in('WD010401','WD010402','WD010403','WD010404','WD010405','WD010406','WD010407')
AND    index_no in('WD010401')
ORDER  BY sum_end_time,index_no;

 CURSOR CUR_TABLE_LIST IS
   SELECT TABLE_NAME
   			FROM ALL_TABLES
  WHERE TABLE_NAME LIKE UPPER('mbar_teller_situ_%')
  AND TABLE_NAME NOT LIKE ('%${batch_date}%');
    v_sql       VARCHAR2(4000);
    V_TABLE_NAME VARCHAR2(200);
BEGIN
  --删除因脚本异常退出未删除的临时表
  OPEN CUR_TABLE_LIST;
  LOOP
    FETCH CUR_TABLE_LIST
      INTO V_TABLE_NAME;
    EXIT WHEN CUR_TABLE_LIST%NOTFOUND;
    IF CUR_TABLE_LIST%ROWCOUNT > 0 THEN
      v_sql := 'drop table ' || V_TABLE_NAME;
      EXECUTE IMMEDIATE v_sql;
    END IF;
  END LOOP;
  CLOSE CUR_TABLE_LIST;
  
       FOR REC_RUN_LOGS IN CUR_RUN_LOGS LOOP

-- 1.1 update log table

UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1:运行中
SET    run_sts = 1, start_time = SYSDATE
WHERE  log_id LIKE
       substr(rec_run_logs.log_id
             ,1
             ,8) || '%' || substr(rec_run_logs.log_id
                                 ,17
                                 ,4)
AND    index_no in('WD010401','WD010402','WD010403','WD010404','WD010405','WD010406','WD010407')
 ;
COMMIT;


-- 2.1 insert into realtime table
--WD010401		实时在线人员
--插入支行下具体设备数据
INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010401'
                        AND run_sts = 1)),
  tmp_initza_data AS
  --20220726新一代改造 柜面替换为智能网点
   /*(SELECT distinct p1.teller_no     as dev_no,
                    p1.teller_name   as dev_name,
                    p1.teller_zoneno as org_no,
                    null             as bu_type
      FROM ${msl_schema}.msl_ncts_teller_info p1
      LEFT JOIN ${msl_schema}.msl_ncts_teller_login p2
        ON p2.login_teller = p1.teller_no
     INNER JOIN ${itl_schema}.itl_edw_mpcs_cpmtstaff p3
        ON p1.teller_no = p3.staffno
       AND p3.tlrtype = 'C'
       AND p3.staffno IS NOT NULL
      INNER JOIN msl_cbss_kub_wkst p4
       ON P4.CURTUS=P3.STAFFNO
       AND P4.CURTUS IS NOT NULL
       --只取这8个岗位的：分行对账员、分行集中作业柜员岗、分行集中作业授权岗、柜员岗、核心验印岗、数字银行营运柜员岗、委派经理岗、业务查询员
       AND P4.WKTPCD IN ('2013','2020','2012','3010','2032','3014','3011','1023','2023')
     WHERE p1.teller_userst IN ('U', 'O')
       AND (p2.logout_date = ${batch_date} OR p2.login_date = ${batch_date})
       AND p2.login_status = '0'),*/
     --20220808自分析
    /*(SELECT distinct t1.usernum as dev_no
               ,t1.SURNAME || '' || t1.username as dev_name
               ,t1.branchnum as org_no
               ,null as bu_type
  FROM msl_nibs_IB_UPM_USER_INFO T1
  LEFT JOIN (SELECT USERNUM
                   ,regtype
                   ,row_number() over(partition by USERNUM order by regtime desc) AS RN
               FROM MSL_NIBS_IB_UPM_USERLOGIN_LOG
              WHERE DATEREG = ${batch_date} AND LOGINSTATE = '1') T2 --取柜员当日最新登录状态
    ON T1.USERNUM = T2.USERNUM
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON T1.USERNUM = T3.TELLER_ID AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 INNER JOIN msl_nibs_IB_UPM_POST_RLT T4
    ON T1.usernum = T4.usernum
 WHERE T1.userstatus IN ('U', 'O') AND
      --只取这8个岗位的：分行对账员、分行集中作业柜员岗、分行集中作业授权岗、柜员岗、核心验印岗、数字银行营运柜员岗、委派经理岗、业务查询员
       T4.postnum IN ('2013'
                     ,'2020'
                     ,'2012'
                     ,'3010'
                     ,'2032'
                     ,'3014'
                     ,'3011'
                     ,'1023'
                     ,'2023') AND T2.RN = '1' AND T2.REGTYPE = '1'
),*/
        (
        SELECT u.usernum as dev_no
      ,u.SURNAME || '' || u.username as dev_name
      ,u.branchnum as org_no
      ,null    as bu_type
  FROM msl_nibs_IB_UPM_USER_INFO u
 INNER JOIN msl_nibs_IB_UPM_POST_RLT r
    ON u.usernum = r.usernum
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON u.USERNUM = T3.TELLER_ID 
    AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 WHERE u.userstatus = 'O' AND
       r.postnum IN ('2013'
                    ,'2020'
                    ,'2012'
                    ,'3010'
                    ,'2032'
                    ,'3014'
                    ,'3011'
                    ,'1023'
                    ,'2023')
        ),
  temp_dev_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t2.dev_no AS org_no, --设备编码
           t2.dev_name AS org_name, --设备名称 等同于设备编码
           t2.org_no AS super_org_no --设备所在机构号为上级机构号             
          ,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t2.bu_type AS bu_type --业务类型
          ,
           1 AS accu_index_value_d --当日
          ,
           1 AS hours_total --小时合计
    
      FROM ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT JOIN tmp_initza_data t2
        ON t1.org_no = t2.org_no
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010401' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no
     WHERE length(t1.super_org_no) = 3 --只关联支行      
    )
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010401'
                        AND run_sts = 1)),
  --根据设备数据汇总成支行待查数据
  temp_sum_data AS
   (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d,
           t2.super_org_no org_no,
           t2.bu_type
      FROM tmp_run_log t1
     INNER JOIN mbar_teller_situ_${batch_date}_tm t2
        ON t2.index_no = t1.index_no
       AND t2.sum_time = to_date(t1.sum_end_time, 'yyyymmdd hh24:mi:ss')
     WHERE t2.etl_dt = t1.etl_dt
     GROUP BY t2.super_org_no, t2.bu_type),
  temp_org_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t1.org_no AS org_no, --机构编码
           t1.org_name AS org_name --机构名称
          ,
           t1.super_org_no AS super_org_no,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t1.bu_type AS bu_type --业务类型
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS accu_index_value_d --当日
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
    
      FROM (SELECT *
              FROM mcyy_orga_para org_tab,
                   (SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM mcyy_index_define t1
                      LEFT JOIN mcyy_dim_index t2
                        ON t1.index_no = t2.index_no
                      LEFT JOIN mcyy_dim_define t3
                        ON t2.dim_class = t3.dim_class
                       AND t3.dim_class_name IS NOT NULL
                     WHERE t1.index_no = 'WD010401') dim_tab) t1 -- 机构树表
      LEFT JOIN temp_sum_data t2
        ON t2.org_no = t1.org_no
       AND nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010401' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no)
  
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_org_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--WD010402		实时离线人员
--插入支行下具体设备数据
INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010402'
                        AND run_sts = 1)),
  tmp_initza_data AS
   (
   /*SELECT distinct p1.teller_no     as dev_no,
                    p1.teller_name   as dev_name,
                    p1.teller_zoneno as org_no,
                    null             as bu_type
      FROM ${msl_schema}.msl_ncts_teller_info p1
      LEFT JOIN ${msl_schema}.msl_ncts_teller_login p2
        ON p2.login_teller = p1.teller_no
       AND (p2.logout_date = ${batch_date} OR p2.login_date = ${batch_date})
       AND p2.login_status = '1'
     INNER JOIN ${itl_schema}.itl_edw_mpcs_cpmtstaff p3
        ON p1.teller_no = p3.staffno
       AND p3.tlrtype = 'C'
       AND p3.staffno IS NOT NULL
       INNER JOIN msl_cbss_kub_wkst p4
       ON P4.CURTUS=P3.STAFFNO
       AND P4.CURTUS IS NOT NULL
       --只取这8个岗位的：分行对账员、分行集中作业柜员岗、分行集中作业授权岗、柜员岗、核心验印岗、数字银行营运柜员岗、委派经理岗、业务查询员
       AND P4.WKTPCD IN ('2013','2020','2012','3010','2032','3014','3011','1023','2023')
     WHERE p1.teller_userst IN ('U', 'O')
     --同一个柜员，要么在线要么离线
       AND NOT EXISTS (SELECT 1 FROM ${msl_schema}.msl_ncts_teller_login p2 
                         WHERE p2.login_teller = p1.teller_no
                          AND (p2.logout_date = ${batch_date} OR p2.login_date = ${batch_date})
                          AND p2.login_status = '0')*/
   --登出柜员
   /*SELECT distinct t1.usernum as dev_no
               ,t1.SURNAME || '' || t1.username as dev_name
               ,t1.branchnum as org_no
               ,null as bu_type
  FROM msl_nibs_IB_UPM_USER_INFO T1
  LEFT JOIN (SELECT USERNUM
                   ,regtype
                   ,row_number() over(partition by USERNUM order by regtime desc) AS RN
               FROM MSL_NIBS_IB_UPM_USERLOGIN_LOG
              WHERE DATEREG = ${batch_date} AND LOGINSTATE = '1') T2 --取柜员当日最新登录状态
    ON T1.USERNUM = T2.USERNUM
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON T1.USERNUM = T3.TELLER_ID AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 INNER JOIN msl_nibs_IB_UPM_POST_RLT T4
    ON T1.usernum = T4.usernum
 WHERE T1.userstatus IN ('U', 'O') AND
      --只取这8个岗位的：分行对账员、分行集中作业柜员岗、分行集中作业授权岗、柜员岗、核心验印岗、数字银行营运柜员岗、委派经理岗、业务查询员
       T4.postnum IN ('2013'
                     ,'2020'
                     ,'2012'
                     ,'3010'
                     ,'2032'
                     ,'3014'
                     ,'3011'
                     ,'1023'
                     ,'2023') AND T2.RN = '1' AND T2.REGTYPE = '0'
     --无登录记录柜员
     UNION ALL
     SELECT distinct t1.usernum as dev_no
               ,t1.SURNAME || '' || t1.username as dev_name
               ,t1.branchnum as org_no
               ,null as bu_type
  FROM msl_nibs_IB_UPM_USER_INFO T1
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON T1.USERNUM = T3.TELLER_ID AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 INNER JOIN msl_nibs_IB_UPM_POST_RLT T4
    ON T1.usernum = T4.usernum
 WHERE T1.userstatus IN ('U', 'O') AND
      --只取这8个岗位的：分行对账员、分行集中作业柜员岗、分行集中作业授权岗、柜员岗、核心验印岗、数字银行营运柜员岗、委派经理岗、业务查询员
       T4.postnum IN ('2013'
                     ,'2020'
                     ,'2012'
                     ,'3010'
                     ,'2032'
                     ,'3014'
                     ,'3011'
                     ,'1023'
                     ,'2023') 
     AND NOT EXISTS (SELECT 1 FROM MSL_NIBS_IB_UPM_USERLOGIN_LOG p2 
                         WHERE p2.USERNUM = T1.USERNUM
                          AND  p2.DATEREG = ${batch_date})*/
    SELECT u.usernum as dev_no
      ,u.SURNAME || '' || u.username as dev_name
      ,u.branchnum as org_no
      ,null    as bu_type
  FROM msl_nibs_IB_UPM_USER_INFO u
 INNER JOIN msl_nibs_IB_UPM_POST_RLT r
    ON u.usernum = r.usernum
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON u.USERNUM = T3.TELLER_ID 
    AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 WHERE u.userstatus = 'U' AND
       r.postnum IN ('2013'
                    ,'2020'
                    ,'2012'
                    ,'3010'
                    ,'2032'
                    ,'3014'
                    ,'3011'
                    ,'1023'
                    ,'2023')
      ),
  temp_dev_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t2.dev_no AS org_no, --设备编码
           t2.dev_name AS org_name, --设备名称 等同于设备编码
           t2.org_no AS super_org_no --设备所在机构号为上级机构号             
          ,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t2.bu_type AS bu_type --业务类型
          ,
           1 AS accu_index_value_d --当日
          ,
           1 AS hours_total --小时合计
    
      FROM ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT JOIN tmp_initza_data t2
        ON t1.org_no = t2.org_no
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010402' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no
     WHERE length(t1.super_org_no) = 3 --只关联支行      
    )
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010402'
                        AND run_sts = 1)),
  --根据设备数据汇总成支行待查数据
  temp_sum_data AS
   (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d,
           t2.super_org_no org_no,
           t2.bu_type
      FROM tmp_run_log t1
     INNER JOIN mbar_teller_situ_${batch_date}_tm t2
        ON t2.index_no = t1.index_no
       AND t2.sum_time = to_date(t1.sum_end_time, 'yyyymmdd hh24:mi:ss')
     WHERE t2.etl_dt = t1.etl_dt
     GROUP BY t2.super_org_no, t2.bu_type),
  temp_org_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t1.org_no AS org_no, --机构编码
           t1.org_name AS org_name --机构名称
          ,
           t1.super_org_no AS super_org_no,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t1.bu_type AS bu_type --业务类型
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS accu_index_value_d --当日
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
    
      FROM (SELECT *
              FROM mcyy_orga_para org_tab,
                   (SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM mcyy_index_define t1
                      LEFT JOIN mcyy_dim_index t2
                        ON t1.index_no = t2.index_no
                      LEFT JOIN mcyy_dim_define t3
                        ON t2.dim_class = t3.dim_class
                       AND t3.dim_class_name IS NOT NULL
                     WHERE t1.index_no = 'WD010402') dim_tab) t1 -- 机构树表
      LEFT JOIN temp_sum_data t2
        ON t2.org_no = t1.org_no
       AND nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010402' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no)
  
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_org_data) mcyy_bu_analysis_realtime_temp;

COMMIT;


--WD010403		实时离线次数
--插入支行下具体设备数据
INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010403'
                        AND run_sts = 1)),
  tmp_initza_data AS
   (
   /*SELECT p1.teller_no as dev_no,
       p1.teller_name as dev_name,
       p1.teller_zoneno as org_no,
       null as bu_type,
       count(1) as index_value
  FROM msl_ncts_teller_info p1
  LEFT JOIN msl_ncts_teller_login p2
    ON p2.login_teller = p1.teller_no
   AND (p2.logout_date = ${batch_date} OR p2.login_date = ${batch_date})
   AND p2.login_status = '1'
 INNER JOIN itl_edw_mpcs_cpmtstaff p3
    ON p1.teller_no = p3.staffno
   AND p3.tlrtype = 'C'
   AND p3.staffno IS NOT NULL
   INNER JOIN msl_cbss_kub_wkst p4
       ON P4.CURTUS=P3.STAFFNO
       AND P4.CURTUS IS NOT NULL
       --只取这8个岗位的：分行对账员、分行集中作业柜员岗、分行集中作业授权岗、柜员岗、核心验印岗、数字银行营运柜员岗、委派经理岗、业务查询员
       AND P4.WKTPCD IN ('2013','2020','2012','3010','2032','3014','3011','1023','2023')
 WHERE p1.teller_userst IN ('U', 'O')
 group by p1.teller_no, p1.teller_name, p1.teller_zoneno*/
 
      SELECT distinct t1.usernum as dev_no
               ,t1.SURNAME || '' || t1.username as dev_name
               ,t1.branchnum as org_no
               ,null as bu_type
               ,count(1) as index_value
  FROM msl_nibs_IB_UPM_USER_INFO T1
  	INNER JOIN MSL_NIBS_IB_UPM_USERLOGIN_LOG T2
    ON T1.USERNUM = T2.USERNUM
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON T1.USERNUM = T3.TELLER_ID AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 INNER JOIN msl_nibs_IB_UPM_POST_RLT T4
    ON T1.usernum = T4.usernum
 WHERE T4.postnum IN ('2013'
                     ,'2020'
                     ,'2012'
                     ,'3010'
                     ,'2032'
                     ,'3014'
                     ,'3011'
                     ,'1023'
                     ,'2023') AND t2.DATEREG = ${batch_date}  and t2.REGTYPE = '0'
 group by t1.usernum, t1.SURNAME || '' || t1.username, t1.branchnum

      ),
  temp_dev_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t2.dev_no AS org_no, --设备编码
           t2.dev_name AS org_name, --设备名称 等同于设备编码
           t2.org_no AS super_org_no --设备所在机构号为上级机构号             
          ,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t2.bu_type AS bu_type --业务类型
          ,
           t2.index_value AS accu_index_value_d --当日
          ,
           1 AS hours_total --小时合计
    
      FROM ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT JOIN tmp_initza_data t2
        ON t1.org_no = t2.org_no
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010403' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no
     WHERE length(t1.super_org_no) = 3 --只关联支行      
    )
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010403'
                        AND run_sts = 1)),
  --根据设备数据汇总成支行待查数据
  temp_sum_data AS
   (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d,
           t2.super_org_no org_no,
           t2.bu_type
      FROM tmp_run_log t1
     INNER JOIN mbar_teller_situ_${batch_date}_tm t2
        ON t2.index_no = t1.index_no
       AND t2.sum_time = to_date(t1.sum_end_time, 'yyyymmdd hh24:mi:ss')
     WHERE t2.etl_dt = t1.etl_dt
     GROUP BY t2.super_org_no, t2.bu_type),
  temp_org_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t1.org_no AS org_no, --机构编码
           t1.org_name AS org_name --机构名称
          ,
           t1.super_org_no AS super_org_no,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t1.bu_type AS bu_type --业务类型
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS accu_index_value_d --当日
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
    
      FROM (SELECT *
              FROM mcyy_orga_para org_tab,
                   (SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM mcyy_index_define t1
                      LEFT JOIN mcyy_dim_index t2
                        ON t1.index_no = t2.index_no
                      LEFT JOIN mcyy_dim_define t3
                        ON t2.dim_class = t3.dim_class
                       AND t3.dim_class_name IS NOT NULL
                     WHERE t1.index_no = 'WD010403') dim_tab) t1 -- 机构树表
      LEFT JOIN temp_sum_data t2
        ON t2.org_no = t1.org_no
       AND nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010403' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no)
  
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_org_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--WD010404		实时工作总时长
--插入支行下具体设备数据
INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010404'
                        AND run_sts = 1)),
  tmp_initza_data AS
   (
   /*SELECT           p1.teller_no     as dev_no,
                    p1.teller_name   as dev_name,
                    p1.teller_zoneno as org_no,
                    null             as bu_type,
                    nvl(round(to_number(to_date(SUBSTR(MAX(P5.sum_END_time), 11, 8), 'hh24:mi:ss') -
                           to_date(MIN(p2.login_time), 'hh24:mi:ss')) * 24 * 60),
           0) AS index_value 
      FROM ${msl_schema}.msl_ncts_teller_info p1
      LEFT JOIN ${msl_schema}.msl_ncts_teller_login p2
        ON p2.login_teller = p1.teller_no
        AND (p2.logout_date = ${batch_date} OR p2.login_date = ${batch_date})
     INNER JOIN ${itl_schema}.itl_edw_mpcs_cpmtstaff p3
        ON p1.teller_no = p3.staffno
       AND p3.tlrtype = 'C'
       AND p3.staffno IS NOT NULL
       INNER JOIN msl_cbss_kub_wkst p4
       ON P4.CURTUS=P3.STAFFNO
       AND P4.CURTUS IS NOT NULL
       --只取这8个岗位的：分行对账员、分行集中作业柜员岗、分行集中作业授权岗、柜员岗、核心验印岗、数字银行营运柜员岗、委派经理岗、业务查询员
       AND P4.WKTPCD IN ('2013','2020','2012','3010','2032','3014','3011','1023','2023')
       LEFT JOIN tmp_run_log P5
       ON P5.etl_dt=to_date('${batch_date}', 'yyyymmdd')
     WHERE p1.teller_userst IN ('U', 'O') 
     and  p2.login_status IN ('1','0')    
      group by p1.teller_no, p1.teller_name, p1.teller_zoneno*/
      SELECT w.USERNUM as dev_no
      ,u.SURNAME || '' || u.username as dev_name
      ,w.BRANCHNUM as org_no
      ,null             as bu_type
      ,ROUND(w.TOTALTIMESECOND/60) as index_value
  FROM MSL_nibs_IB_UPM_USER_WORKTIME w
 INNER JOIN MSL_nibs_IB_UPM_USER_INFO u
    ON w.usernum = u.usernum
 INNER JOIN MSL_nibs_IB_UPM_POST_RLT r
    ON w.usernum = r.usernum
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON u.USERNUM = T3.TELLER_ID 
    AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 WHERE w.LOGINDATESTR =${batch_date} AND
       r.postnum IN ('2013'
                    ,'2020'
                    ,'2012'
                    ,'3010'
                    ,'2032'
                    ,'3014'
                    ,'3011'
                    ,'1023'
                    ,'2023')
       ),
  temp_dev_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t2.dev_no AS org_no, --设备编码
           t2.dev_name AS org_name, --设备名称 等同于设备编码
           t2.org_no AS super_org_no --设备所在机构号为上级机构号             
          ,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t2.bu_type AS bu_type --业务类型
          ,
           t2.index_value AS accu_index_value_d --当日
          ,
           1 AS hours_total --小时合计
    
      FROM ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT JOIN tmp_initza_data t2
        ON t1.org_no = t2.org_no
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010404' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no
     WHERE length(t1.super_org_no) = 3 --只关联支行      
    )
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010404'
                        AND run_sts = 1)),
  --根据设备数据汇总成支行待查数据
  temp_sum_data AS
   (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d,
           t2.super_org_no org_no,
           t2.bu_type
      FROM tmp_run_log t1
     INNER JOIN mbar_teller_situ_${batch_date}_tm t2
        ON t2.index_no = t1.index_no
       AND t2.sum_time = to_date(t1.sum_end_time, 'yyyymmdd hh24:mi:ss')
     WHERE t2.etl_dt = t1.etl_dt
     GROUP BY t2.super_org_no, t2.bu_type),
  temp_org_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t1.org_no AS org_no, --机构编码
           t1.org_name AS org_name --机构名称
          ,
           t1.super_org_no AS super_org_no,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t1.bu_type AS bu_type --业务类型
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS accu_index_value_d --当日
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
    
      FROM (SELECT *
              FROM mcyy_orga_para org_tab,
                   (SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM mcyy_index_define t1
                      LEFT JOIN mcyy_dim_index t2
                        ON t1.index_no = t2.index_no
                      LEFT JOIN mcyy_dim_define t3
                        ON t2.dim_class = t3.dim_class
                       AND t3.dim_class_name IS NOT NULL
                     WHERE t1.index_no = 'WD010404') dim_tab) t1 -- 机构树表
      LEFT JOIN temp_sum_data t2
        ON t2.org_no = t1.org_no
       AND nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010404' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no)
  
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_org_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--WD010405		实时交易时长
--插入支行下具体设备数据
INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010405'
                        AND run_sts = 1)),
   /* transtimstab as (SELECT t3.tran_opt_no AS teller_no
          ,SUM(round(to_number(to_date(t3.tran_end_time
                                      ,'hh24:mi:ss') -
                               to_date(t3.proc_tran_start_tm
                                      ,'hh24:mi:ss')) * 24 * 60
                    ,2)) AS onl_tran_duran
          ,to_date(MIN(t3.tran_time)
                  ,'hh24:mi:ss') AS td_fir_tran_tm
          ,to_date(MAX(t3.tran_end_time)
                  ,'hh24:mi:ss') AS td_final_tran_tm
    FROM   (SELECT t2.tran_opt_no
                  ,t2.tran_time --原交易开始时间
                  ,t2.break
                  ,(CASE
                       WHEN t2.break = '2' --在同一时间内发生的交易,取上一交易结束时间作为本次交易开始时间
                        THEN
                        lag(t2.tran_end_time)
                        over(PARTITION BY t2.tran_opt_no ORDER BY
                             t2.tran_time ASC)
                       ELSE
                        t2.tran_time
                   END) AS proc_tran_start_tm --处理交易开始时间
                  ,t2.tran_end_time --原交易结束时间
            FROM   (SELECT t1.tran_opt_no
                          ,t1.tran_time
                          ,t1.tran_end_time
                          ,(CASE
                               WHEN t1.tran_time > MAX(t1.tran_end_time) --1.不在同一时间内发生的交易
                                over(PARTITION BY t1.tran_opt_no ORDER BY
                                         t1.tran_time
                                        ,t1.tran_end_time
                                         rows BETWEEN unbounded
                                         preceding
                                         AND 1 preceding) THEN
                                1
                               WHEN t1.tran_end_time >= MAX(t1.tran_end_time) --2、在同一时间内发生的交易
                                over(PARTITION BY t1.tran_opt_no ORDER BY
                                         t1.tran_time
                                        ,t1.tran_end_time
                                         rows BETWEEN unbounded
                                         preceding
                                         AND 1 preceding) THEN
                                2
                               ELSE
                                0
                           END) break
                          ,dense_rank() over(PARTITION BY t1.tran_opt_no ORDER BY t1.tran_time, t1.tran_end_time) rk
                    FROM   msl_ncts_ab_transdtl t1
                    WHERE  t1.tran_date = ${batch_date}) t2
            WHERE  (t2.break <> '0' OR t2.rk = 1) --RK排序当日第一笔交易不过滤
            ORDER  BY t2.tran_time) t3
    GROUP  BY t3.tran_opt_no),*/
  tmp_initza_data AS
   (
   /*SELECT  p1.teller_no     as dev_no,
                    p1.teller_name   as dev_name,
                    p1.teller_zoneno as org_no,
                    null             as bu_type,
                    round(max(p4.onl_tran_duran)) AS index_value 
      FROM ${msl_schema}.msl_ncts_teller_info p1
      LEFT JOIN ${msl_schema}.msl_ncts_teller_login p2
        ON p2.login_teller = p1.teller_no
        AND (p2.logout_date = ${batch_date} OR p2.login_date = ${batch_date})
     INNER JOIN ${itl_schema}.itl_edw_mpcs_cpmtstaff p3
        ON p1.teller_no = p3.staffno
       AND p3.tlrtype = 'C'
       AND p3.staffno IS NOT NULL
       INNER JOIN msl_cbss_kub_wkst p5
       on P5.CURTUS=P3.STAFFNO
       AND P5.CURTUS IS NOT NULL
       --只取这8个岗位的：分行对账员、分行集中作业柜员岗、分行集中作业授权岗、柜员岗、核心验印岗、数字银行营运柜员岗、委派经理岗、业务查询员
       AND P5.WKTPCD IN ('2013','2020','2012','3010','2032','3014','3011','1023','2023')
      left join transtimstab p4
       ON  p4.teller_no = p1.teller_no    
     WHERE p1.teller_userst IN ('U', 'O')    
     and  p2.login_status IN ('1','0') 
     group by   p1.teller_no   ,
                    p1.teller_name  ,
                    p1.teller_zoneno*/
       SELECT w.USERNUM as dev_no
      ,u.SURNAME || '' || u.username as dev_name
      ,w.BRANCHNUM as org_no
      ,null             as bu_type
      ,ROUND(w.TRANTIMESECOND/60) as index_value
  FROM MSL_nibs_IB_UPM_USER_WORKTIME w
 INNER JOIN MSL_nibs_IB_UPM_USER_INFO u
    ON w.usernum = u.usernum
 INNER JOIN MSL_nibs_IB_UPM_POST_RLT r
    ON w.usernum = r.usernum
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON u.USERNUM = T3.TELLER_ID 
    AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 WHERE w.LOGINDATESTR =${batch_date} AND
       r.postnum IN ('2013'
                    ,'2020'
                    ,'2012'
                    ,'3010'
                    ,'2032'
                    ,'3014'
                    ,'3011'
                    ,'1023'
                    ,'2023')
       ),
  temp_dev_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t2.dev_no AS org_no, --设备编码
           t2.dev_name AS org_name, --设备名称 等同于设备编码
           t2.org_no AS super_org_no --设备所在机构号为上级机构号             
          ,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t2.bu_type AS bu_type --业务类型
          ,
           t2.index_value AS accu_index_value_d --当日
          ,
           1 AS hours_total --小时合计
    
      FROM ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT JOIN tmp_initza_data t2
        ON t1.org_no = t2.org_no
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010405' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no
     WHERE length(t1.super_org_no) = 3 --只关联支行      
    )
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010405'
                        AND run_sts = 1)),
  --根据设备数据汇总成支行待查数据
  temp_sum_data AS
   (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d,
           t2.super_org_no org_no,
           t2.bu_type
      FROM tmp_run_log t1
     INNER JOIN mbar_teller_situ_${batch_date}_tm t2
        ON t2.index_no = t1.index_no
       AND t2.sum_time = to_date(t1.sum_end_time, 'yyyymmdd hh24:mi:ss')
     WHERE t2.etl_dt = t1.etl_dt
     GROUP BY t2.super_org_no, t2.bu_type),
  temp_org_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t1.org_no AS org_no, --机构编码
           t1.org_name AS org_name --机构名称
          ,
           t1.super_org_no AS super_org_no,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t1.bu_type AS bu_type --业务类型
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS accu_index_value_d --当日
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
    
      FROM (SELECT *
              FROM mcyy_orga_para org_tab,
                   (SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM mcyy_index_define t1
                      LEFT JOIN mcyy_dim_index t2
                        ON t1.index_no = t2.index_no
                      LEFT JOIN mcyy_dim_define t3
                        ON t2.dim_class = t3.dim_class
                       AND t3.dim_class_name IS NOT NULL
                     WHERE t1.index_no = 'WD010405') dim_tab) t1 -- 机构树表
      LEFT JOIN temp_sum_data t2
        ON t2.org_no = t1.org_no
       AND nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010405' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no)
  
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_org_data) mcyy_bu_analysis_realtime_temp;

COMMIT;


--WD010406		实时在线空闲时长
--插入支行下具体设备数据
INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010406'
                        AND run_sts = 1)),
   /* transtimstab as (SELECT t3.tran_opt_no AS teller_no
          ,SUM(round(to_number(to_date(t3.tran_end_time
                                      ,'hh24:mi:ss') -
                               to_date(t3.proc_tran_start_tm
                                      ,'hh24:mi:ss')) * 24 * 60
                    ,2)) AS onl_tran_duran
          ,to_date(MIN(t3.tran_time)
                  ,'hh24:mi:ss') AS td_fir_tran_tm
          ,to_date(MAX(t3.tran_end_time)
                  ,'hh24:mi:ss') AS td_final_tran_tm
    FROM   (SELECT t2.tran_opt_no
                  ,t2.tran_time --原交易开始时间
                  ,t2.break
                  ,(CASE
                       WHEN t2.break = '2' --在同一时间内发生的交易,取上一交易结束时间作为本次交易开始时间
                        THEN
                        lag(t2.tran_end_time)
                        over(PARTITION BY t2.tran_opt_no ORDER BY
                             t2.tran_time ASC)
                       ELSE
                        t2.tran_time
                   END) AS proc_tran_start_tm --处理交易开始时间
                  ,t2.tran_end_time --原交易结束时间
            FROM   (SELECT t1.tran_opt_no
                          ,t1.tran_time
                          ,t1.tran_end_time
                          ,(CASE
                               WHEN t1.tran_time > MAX(t1.tran_end_time) --1.不在同一时间内发生的交易
                                over(PARTITION BY t1.tran_opt_no ORDER BY
                                         t1.tran_time
                                        ,t1.tran_end_time
                                         rows BETWEEN unbounded
                                         preceding
                                         AND 1 preceding) THEN
                                1
                               WHEN t1.tran_end_time >= MAX(t1.tran_end_time) --2、在同一时间内发生的交易
                                over(PARTITION BY t1.tran_opt_no ORDER BY
                                         t1.tran_time
                                        ,t1.tran_end_time
                                         rows BETWEEN unbounded
                                         preceding
                                         AND 1 preceding) THEN
                                2
                               ELSE
                                0
                           END) break
                          ,dense_rank() over(PARTITION BY t1.tran_opt_no ORDER BY t1.tran_time, t1.tran_end_time) rk
                    FROM   msl_ncts_ab_transdtl t1
                    WHERE  t1.tran_date = ${batch_date}) t2
            WHERE  (t2.break <> '0' OR t2.rk = 1) --RK排序当日第一笔交易不过滤
            ORDER  BY t2.tran_time) t3
    GROUP  BY t3.tran_opt_no),*/
  tmp_initza_data AS
   (
   /*SELECT  p1.teller_no     as dev_no,
                    p1.teller_name   as dev_name,
                    p1.teller_zoneno as org_no,
                    null             as bu_type,
                    SUM(round(to_number(nvl(to_date(p2.logout_time
                                      ,'hh24:mi:ss'),to_date(SUBSTR(P6.sum_END_time, 11, 8), 'hh24:mi:ss')) -
                               to_date(p2.login_time
                                      ,'hh24:mi:ss')) * 24 * 60)) -
                  nvl(round(max(p4.onl_tran_duran)),0)  AS index_value 
      FROM ${msl_schema}.msl_ncts_teller_info p1
      LEFT JOIN ${msl_schema}.msl_ncts_teller_login p2
        ON p2.login_teller = p1.teller_no
        AND (p2.logout_date = ${batch_date} OR p2.login_date = ${batch_date})
     INNER JOIN ${itl_schema}.itl_edw_mpcs_cpmtstaff p3
        ON p1.teller_no = p3.staffno
       AND p3.tlrtype = 'C'
       AND p3.staffno IS NOT NULL
       INNER JOIN msl_cbss_kub_wkst p5
       on P5.CURTUS=P3.STAFFNO
       AND P5.CURTUS IS NOT NULL
       --只取这8个岗位的：分行对账员、分行集中作业柜员岗、分行集中作业授权岗、柜员岗、核心验印岗、数字银行营运柜员岗、委派经理岗、业务查询员
       AND P5.WKTPCD IN ('2013','2020','2012','3010','2032','3014','3011','1023','2023')
      left join transtimstab p4
       ON  p4.teller_no = p1.teller_no  
        LEFT JOIN tmp_run_log P6
       ON P6.etl_dt=to_date('${batch_date}', 'yyyymmdd')
     WHERE p1.teller_userst IN ('U', 'O')  
     and  p2.login_status IN ('1','0') 
     group by     p1.teller_no    ,
                    p1.teller_name  ,
                    p1.teller_zoneno */
    SELECT w.USERNUM as dev_no
      ,u.SURNAME || '' || u.username as dev_name
      ,w.BRANCHNUM as org_no
      ,null             as bu_type
      ,ROUND(w.ONLINELEISURESECOND/60) as index_value
  FROM MSL_nibs_IB_UPM_USER_WORKTIME w
 INNER JOIN MSL_nibs_IB_UPM_USER_INFO u
    ON w.usernum = u.usernum
 INNER JOIN MSL_nibs_IB_UPM_POST_RLT r
    ON w.usernum = r.usernum
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON u.USERNUM = T3.TELLER_ID 
    AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 WHERE w.LOGINDATESTR =${batch_date} AND
       r.postnum IN ('2013'
                    ,'2020'
                    ,'2012'
                    ,'3010'
                    ,'2032'
                    ,'3014'
                    ,'3011'
                    ,'1023'
                    ,'2023')
       ),
  temp_dev_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t2.dev_no AS org_no, --设备编码
           t2.dev_name AS org_name, --设备名称 等同于设备编码
           t2.org_no AS super_org_no --设备所在机构号为上级机构号             
          ,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t2.bu_type AS bu_type --业务类型
          ,
           t2.index_value AS accu_index_value_d --当日
          ,
           1 AS hours_total --小时合计
    
      FROM ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT JOIN tmp_initza_data t2
        ON t1.org_no = t2.org_no
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010406' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no
     WHERE length(t1.super_org_no) = 3 --只关联支行      
    )
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010406'
                        AND run_sts = 1)),
  --根据设备数据汇总成支行待查数据
  temp_sum_data AS
   (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d,
           t2.super_org_no org_no,
           t2.bu_type
      FROM tmp_run_log t1
     INNER JOIN mbar_teller_situ_${batch_date}_tm t2
        ON t2.index_no = t1.index_no
       AND t2.sum_time = to_date(t1.sum_end_time, 'yyyymmdd hh24:mi:ss')
     WHERE t2.etl_dt = t1.etl_dt
     GROUP BY t2.super_org_no, t2.bu_type),
  temp_org_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t1.org_no AS org_no, --机构编码
           t1.org_name AS org_name --机构名称
          ,
           t1.super_org_no AS super_org_no,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t1.bu_type AS bu_type --业务类型
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS accu_index_value_d --当日
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
    
      FROM (SELECT *
              FROM mcyy_orga_para org_tab,
                   (SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM mcyy_index_define t1
                      LEFT JOIN mcyy_dim_index t2
                        ON t1.index_no = t2.index_no
                      LEFT JOIN mcyy_dim_define t3
                        ON t2.dim_class = t3.dim_class
                       AND t3.dim_class_name IS NOT NULL
                     WHERE t1.index_no = 'WD010406') dim_tab) t1 -- 机构树表
      LEFT JOIN temp_sum_data t2
        ON t2.org_no = t1.org_no
       AND nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010406' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no)
  
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_org_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--WD010407		实时离柜时长
--插入支行下具体设备数据
INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010407'
                        AND run_sts = 1)),
    /*transtimstab as (SELECT t3.tran_opt_no AS teller_no
          ,SUM(round(to_number(to_date(t3.tran_end_time
                                      ,'hh24:mi:ss') -
                               to_date(t3.proc_tran_start_tm
                                      ,'hh24:mi:ss')) * 24 * 60
                    ,2)) AS onl_tran_duran
          ,to_date(MIN(t3.tran_time)
                  ,'hh24:mi:ss') AS td_fir_tran_tm
          ,to_date(MAX(t3.tran_end_time)
                  ,'hh24:mi:ss') AS td_final_tran_tm
    FROM   (SELECT t2.tran_opt_no
                  ,t2.tran_time --原交易开始时间
                  ,t2.break
                  ,(CASE
                       WHEN t2.break = '2' --在同一时间内发生的交易,取上一交易结束时间作为本次交易开始时间
                        THEN
                        lag(t2.tran_end_time)
                        over(PARTITION BY t2.tran_opt_no ORDER BY
                             t2.tran_time ASC)
                       ELSE
                        t2.tran_time
                   END) AS proc_tran_start_tm --处理交易开始时间
                  ,t2.tran_end_time --原交易结束时间
            FROM   (SELECT t1.tran_opt_no
                          ,t1.tran_time
                          ,t1.tran_end_time
                          ,(CASE
                               WHEN t1.tran_time > MAX(t1.tran_end_time) --1.不在同一时间内发生的交易
                                over(PARTITION BY t1.tran_opt_no ORDER BY
                                         t1.tran_time
                                        ,t1.tran_end_time
                                         rows BETWEEN unbounded
                                         preceding
                                         AND 1 preceding) THEN
                                1
                               WHEN t1.tran_end_time >= MAX(t1.tran_end_time) --2、在同一时间内发生的交易
                                over(PARTITION BY t1.tran_opt_no ORDER BY
                                         t1.tran_time
                                        ,t1.tran_end_time
                                         rows BETWEEN unbounded
                                         preceding
                                         AND 1 preceding) THEN
                                2
                               ELSE
                                0
                           END) break
                          ,dense_rank() over(PARTITION BY t1.tran_opt_no ORDER BY t1.tran_time, t1.tran_end_time) rk
                    FROM   msl_ncts_ab_transdtl t1
                    WHERE  t1.tran_date = ${batch_date}) t2
            WHERE  (t2.break <> '0' OR t2.rk = 1) --RK排序当日第一笔交易不过滤
            ORDER  BY t2.tran_time) t3
    GROUP  BY t3.tran_opt_no),*/
  tmp_initza_data AS
   (
   /*SELECT  p1.teller_no     as dev_no,
                    p1.teller_name   as dev_name,
                    p1.teller_zoneno as org_no,
                    null             as bu_type,
                    nvl(round(to_number(to_date(SUBSTR(MAX(P6.sum_END_time), 11, 8), 'hh24:mi:ss') -
                           to_date(MIN(p2.login_time), 'hh24:mi:ss')) * 24 * 60),
           0)-SUM(round(to_number(nvl(to_date(p2.logout_time
                                      ,'hh24:mi:ss'),to_date(SUBSTR(P6.sum_END_time, 11, 8), 'hh24:mi:ss')) -
                               to_date(p2.login_time
                                      ,'hh24:mi:ss')) * 24 * 60))  AS index_value 
      FROM ${msl_schema}.msl_ncts_teller_info p1
      LEFT JOIN ${msl_schema}.msl_ncts_teller_login p2
        ON p2.login_teller = p1.teller_no
        AND (p2.logout_date = ${batch_date} OR p2.login_date = ${batch_date})
     INNER JOIN ${itl_schema}.itl_edw_mpcs_cpmtstaff p3
        ON p1.teller_no = p3.staffno
       AND p3.tlrtype = 'C'
       AND p3.staffno IS NOT NULL
       INNER JOIN msl_cbss_kub_wkst p5
       on P5.CURTUS=P3.STAFFNO
       AND P5.CURTUS IS NOT NULL
       --只取这8个岗位的：分行对账员、分行集中作业柜员岗、分行集中作业授权岗、柜员岗、核心验印岗、数字银行营运柜员岗、委派经理岗、业务查询员
       AND P5.WKTPCD IN ('2013','2020','2012','3010','2032','3014','3011','1023','2023')
      left join transtimstab p4
       ON  p4.teller_no = p1.teller_no  
        LEFT JOIN tmp_run_log P6
       ON P6.etl_dt=to_date('${batch_date}', 'yyyymmdd')  
     WHERE p1.teller_userst IN ('U', 'O') 
     and  p2.login_status IN ('1','0') 
        group by     p1.teller_no    ,
                    p1.teller_name  ,
                    p1.teller_zoneno   */
      SELECT w.USERNUM as dev_no
      ,u.SURNAME || '' || u.username as dev_name
      ,w.BRANCHNUM as org_no
      ,null             as bu_type
      ,ROUND(w.LEVELTIMESECOND/60) as index_value
  FROM MSL_nibs_IB_UPM_USER_WORKTIME w
 INNER JOIN MSL_nibs_IB_UPM_USER_INFO u
    ON w.usernum = u.usernum
 INNER JOIN MSL_nibs_IB_UPM_POST_RLT r
    ON w.usernum = r.usernum
 INNER JOIN ITL_EDW_CMM_TELLER_INFO T3
    ON u.USERNUM = T3.TELLER_ID 
    AND T3.TELLER_TYPE_CD = 'TELLER_USER'
 WHERE w.LOGINDATESTR =${batch_date} AND
       r.postnum IN ('2013'
                    ,'2020'
                    ,'2012'
                    ,'3010'
                    ,'2032'
                    ,'3014'
                    ,'3011'
                    ,'1023'
                    ,'2023')   
       ),
  temp_dev_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t2.dev_no AS org_no, --设备编码
           t2.dev_name AS org_name, --设备名称 等同于设备编码
           t2.org_no AS super_org_no --设备所在机构号为上级机构号             
          ,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t2.bu_type AS bu_type --业务类型
          ,
           t2.index_value AS accu_index_value_d --当日
          ,
           1 AS hours_total --小时合计
    
      FROM ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT JOIN tmp_initza_data t2
        ON t1.org_no = t2.org_no
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010407' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no
     WHERE length(t1.super_org_no) = 3 --只关联支行      
    )
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_teller_situ_${batch_date}_tm
  (etl_dt --数据日期
  ,
   index_no --指标编码
  ,
   index_name --指标名称
  ,
   org_no --机构编码
  ,
   org_name --机构名称
  ,
   super_org_no --上级机构编码
  ,
   bu_type --业务类型
  ,
   sum_time --统计时点
  ,
   accu_index_value_d --当日累计
  ,
   hours_total -- 小时合计
  ,
   unit --单位
  ,
   frequency --频度
  ,
   measure_no --度量编号
  ,
   index_measure --度量名称
  ,
   etl_timestamp --etl处理时间戳
   )
  WITH tmp_run_log AS
   (SELECT etl_dt, --数据日期
           sum_frequency AS frequency, --频度
           sum_start_time, --统计开始时点
           sum_end_time, --统计结束时点
           index_no --指标编号
      FROM ${idl_schema}.mcyy_realtime_run_log
     WHERE log_id = (SELECT MAX(log_id)
                       FROM ${idl_schema}.mcyy_realtime_run_log
                      WHERE etl_dt = to_date('${batch_date}', 'yyyymmdd')
                        AND index_no = 'WD010407'
                        AND run_sts = 1)),
  --根据设备数据汇总成支行待查数据
  temp_sum_data AS
   (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d,
           t2.super_org_no org_no,
           t2.bu_type
      FROM tmp_run_log t1
     INNER JOIN mbar_teller_situ_${batch_date}_tm t2
        ON t2.index_no = t1.index_no
       AND t2.sum_time = to_date(t1.sum_end_time, 'yyyymmdd hh24:mi:ss')
     WHERE t2.etl_dt = t1.etl_dt
     GROUP BY t2.super_org_no, t2.bu_type),
  temp_org_data AS
   (SELECT t5.etl_dt, --数据日期
           to_date(t5.sum_end_time, 'yyyymmdd hh24:mi:ss') AS sum_time, --统计时点
           t3.index_no AS index_no, --指标编码
           t3.index_name_mcs AS index_name, --指标名称
           t1.org_no AS org_no, --机构编码
           t1.org_name AS org_name --机构名称
          ,
           t1.super_org_no AS super_org_no,
           t3.unit --单位
          ,
           t5.frequency AS frequency, --频度
           NULL measure_no --- 度量编号
          ,
           t3.index_measure -- 度量名称
          ,
           t1.bu_type AS bu_type --业务类型
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS accu_index_value_d --当日
          ,
           (CASE
             WHEN t1.org_no = '000000' THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY T1.BU_TYPE)
             WHEN length(t1.org_no) = 3 THEN
              SUM(coalesce(t2.accu_index_value_d, 0))
              over(PARTITION BY substr(t1.org_no, 1, 3), T1.BU_TYPE)
             ELSE
              coalesce(t2.accu_index_value_d, 0)
           END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
    
      FROM (SELECT *
              FROM mcyy_orga_para org_tab,
                   (SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM mcyy_index_define t1
                      LEFT JOIN mcyy_dim_index t2
                        ON t1.index_no = t2.index_no
                      LEFT JOIN mcyy_dim_define t3
                        ON t2.dim_class = t3.dim_class
                       AND t3.dim_class_name IS NOT NULL
                     WHERE t1.index_no = 'WD010407') dim_tab) t1 -- 机构树表
      LEFT JOIN temp_sum_data t2
        ON t2.org_no = t1.org_no
       AND nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
     INNER JOIN mcyy_index_define t3 --指标定义表
        ON 'WD010407' = t3.index_no_mcs
      LEFT JOIN tmp_run_log t5
        ON t5.index_no = t3.index_no)
  
  SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
        ,
         mcyy_bu_analysis_realtime_temp.index_no --指标编码
        ,
         mcyy_bu_analysis_realtime_temp.index_name --指标名称
        ,
         mcyy_bu_analysis_realtime_temp.org_no --机构编码
        ,
         mcyy_bu_analysis_realtime_temp.org_name --机构名称
        ,
         mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
        ,
         mcyy_bu_analysis_realtime_temp.bu_type --业务类型
        ,
         mcyy_bu_analysis_realtime_temp.sum_time --统计时点
        ,
         mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
        ,
         mcyy_bu_analysis_realtime_temp.hours_total --小时合计
        ,
         mcyy_bu_analysis_realtime_temp.unit --单位
        ,
         mcyy_bu_analysis_realtime_temp.frequency --频度
        ,
         mcyy_bu_analysis_realtime_temp.measure_no --度量编号
        ,
         mcyy_bu_analysis_realtime_temp.index_measure --度量名称
        ,
         to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM (SELECT etl_dt --数据日期
                ,
                 index_no --指标编码
                ,
                 index_name --指标名称
                ,
                 org_no --机构编码
                ,
                 org_name --机构名称
                ,
                 super_org_no --上级机构编码
                ,
                 bu_type --业务类型
                ,
                 sum_time --统计时点
                ,
                 accu_index_value_d --当日累计
                ,
                 hours_total --小时合计
                ,
                 unit --单位
                ,
                 frequency --频度
                ,
                 measure_no --度量编号
                ,
                 index_measure --度量名称
            FROM temp_org_data) mcyy_bu_analysis_realtime_temp;

COMMIT;


-- 2.2 update log table 

UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1的结束时间
SET    run_sts = 2, end_time = SYSDATE
WHERE  log_id LIKE
       substr(rec_run_logs.log_id
             ,1
             ,8) || '%' || substr(rec_run_logs.log_id
                                 ,17
                                 ,4)
AND    index_no in('WD010401','WD010402','WD010403','WD010404','WD010405','WD010406','WD010407');

COMMIT;

END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mcyy_bu_analysis_realtime_teller_situ出错' || SQLERRM);
    
END;


/

-- 3.1 insert into table
whenever sqlerror exit sql.sqlcode;

insert into ${idl_schema}.mcyy_bu_analysis_realtime
select * from ${idl_schema}.mbar_teller_situ_${batch_date}_tm;

commit;
--3.2 drop tmp tables
drop table ${idl_schema}.mbar_teller_situ_${batch_date}_tm purge;  