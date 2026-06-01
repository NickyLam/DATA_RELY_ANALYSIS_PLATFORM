/*
Purpose:    现金库存余额-业务实时分析实时表
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔5分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20210714
Logs:

-- 生成的IDL层表 ：mcyy_bu_analysis_realtime
-- 以下为依赖了上游的表 :
MSL_NCBS_TB_TAILBOX
MSL_NCBS_TB_CASH_BALANCE
ITL_EDW_CMM_TELLER_INFO
生成指标列表
1	WD050101	现金库存余额监控	现金库存余额  人民币现金箱余额
2	WD050102	现金库存余额监控	现金库存余额	港币现金箱余额 		
3	WD050103	现金库存余额监控	现金库存余额	澳元现金箱余额
4	WD050104	现金库存余额监控	现金库存余额	美元现金箱余额

*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 0.2 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm purge ;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm
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
--AND    index_no in('WD050101','WD050102','WD050103','WD050104')
AND    index_no in('WD050101')
ORDER  BY sum_end_time,index_no;

   CURSOR CUR_TABLE_LIST IS
   SELECT TABLE_NAME
   			FROM ALL_TABLES
  WHERE TABLE_NAME LIKE UPPER('mbar_cash_invtry_bal_%')
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
 AND    index_no in('WD050101','WD050102','WD050103','WD050104');
COMMIT;


-- 2.1 insert into realtime table
--WD050101 人民币现金箱余额
--插入支行下现金钱箱数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
    ,bu_type --业务类型
    ,sum_time --统计时点
    ,accu_index_value_d --当日累计
    ,hours_total -- 小时合计
    ,unit --单位
    ,frequency --频度
    ,measure_no --度量编号
    ,index_measure --度量名称
    ,etl_timestamp --etl处理时间戳
     )
    WITH tmp_run_log AS
     (SELECT etl_dt
            , --数据日期
             sum_frequency AS frequency
            , --频度
             sum_start_time
            , --统计开始时点
             sum_end_time
            , --统计结束时点
             index_no --指标编号
      FROM   ${idl_schema}.mcyy_realtime_run_log
      WHERE  log_id = (SELECT MAX(log_id)
                       FROM   ${idl_schema}.mcyy_realtime_run_log
                       WHERE  etl_dt = to_date('${batch_date}'
                                              ,'yyyymmdd')
                       AND    index_no = 'WD050101'
                       AND    run_sts = 1)),
    tmp_initza_data AS
     ( select T1.BRANCH        AS SUPER_ORG_NO,
       T1.USER_ID       AS ORG_NO,
       T1.USER_ID       AS ORG_NAME, --界面显示用柜员号 20210826
       T2.CCY           AS CRCYCD,
       T2.AMOUNT  AS INDEX_VALUE,
       NULL             AS BU_TYPE
  		from MSL_NCBS_TB_TAILBOX T1
  			INNER JOIN MSL_NCBS_TB_CASH_BALANCE T2
    		ON T1.TAILBOX_ID = T2.TAILBOX_ID
   			LEFT JOIN ITL_EDW_CMM_TELLER_INFO T3
   			ON T1.USER_ID=T3.TELLER_ID
   			--AND T3.TELLER_TYPE_CD='TELLER_USER' 
 			where T1.TAILBOX_STATUS = 'Y'
   			AND T1.TAILBOX_PROPERTY <> 'V'
   			AND T2.CCY = 'CNY' 
   			AND T2.AMOUNT >0
      ),
    temp_dev_data AS
     (SELECT t5.etl_dt
            , --数据日期
             to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time
            , --统计时点
             t3.index_no AS index_no
            , --指标编码
             t3.index_name_mcs AS index_name
            , --指标名称
             t2.org_no AS org_no
            , --钱箱对应单位编号
             t2.org_name AS org_name
            , --钱箱类型+钱箱对应单位编号
             t2.super_org_no AS super_org_no
             --设备所在机构号为上级机构号  
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t2.bu_type AS bu_type --业务类型
            ,t2.index_value AS accu_index_value_d --当日
            ,NULL AS hours_total --小时合计
      
      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.super_org_no
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD050101' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      and t2.org_no is not null 
      )
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务类型
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
          ,mcyy_bu_analysis_realtime_temp.hours_total --小时合计
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total --小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;


--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
    ,bu_type --业务类型
    ,sum_time --统计时点
    ,accu_index_value_d --当日累计
    ,hours_total -- 小时合计
    ,unit --单位
    ,frequency --频度
    ,measure_no --度量编号
    ,index_measure --度量名称
    ,etl_timestamp --etl处理时间戳
     )
    WITH tmp_run_log AS
     (SELECT etl_dt
            , --数据日期
             sum_frequency AS frequency
            , --频度
             sum_start_time
            , --统计开始时点
             sum_end_time
            , --统计结束时点
             index_no --指标编号
      FROM   ${idl_schema}.mcyy_realtime_run_log
      WHERE  log_id = (SELECT MAX(log_id)
                       FROM   ${idl_schema}.mcyy_realtime_run_log
                       WHERE  etl_dt = to_date('${batch_date}'
                                              ,'yyyymmdd')
                       AND    index_no = 'WD050101'
                       AND    run_sts = 1)),
    --根据设备数据汇总成支行待查数据
    temp_sum_data AS
     (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d
            ,t2.super_org_no org_no
            ,t2.bu_type
      FROM   tmp_run_log t1
      INNER  JOIN mbar_cash_invtry_bal_${batch_date}_tm t2
      ON     t2.index_no = t1.index_no
      AND    t2.sum_time = to_date(t1.sum_end_time
                                  ,'yyyymmdd hh24:mi:ss')
      WHERE  t2.etl_dt = t1.etl_dt
      GROUP  BY t2.super_org_no, t2.bu_type),
    temp_org_data AS
     (SELECT t5.etl_dt
            , --数据日期
             to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time
            , --统计时点
             t3.index_no AS index_no
            , --指标编码
             t3.index_name_mcs AS index_name
            , --指标名称
             t1.org_no AS org_no
            , --机构编码
             t1.org_name AS org_name --机构名称
            ,t1.super_org_no AS super_org_no
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t1.bu_type AS bu_type --业务类型
            ,(CASE
                                WHEN t1.org_no = '000000' THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY T1.BU_TYPE)
                                WHEN length(t1.org_no) = 3 THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY substr(t1.org_no
                                                             ,1
                                                             ,3),T1.BU_TYPE)
                                ELSE
                                 coalesce(t2.accu_index_value_d
                                         ,0)
                            END) AS accu_index_value_d --当日
            ,(CASE
                                WHEN t1.org_no = '000000' THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY T1.BU_TYPE)
                                WHEN length(t1.org_no) = 3 THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY substr(t1.org_no
                                                             ,1
                                                             ,3),T1.BU_TYPE)
                                ELSE
                                 coalesce(t2.accu_index_value_d
                                         ,0)
                            END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
      
      FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      WHERE  t1.index_no = 'WD050101') dim_tab) t1 -- 机构树表
      LEFT   JOIN temp_sum_data t2
      ON     t2.org_no = t1.org_no
      AND    nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD050101' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no)
      
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务类型
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
          ,mcyy_bu_analysis_realtime_temp.hours_total --小时合计
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total --小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_org_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--	WD050102	港币现金箱余额 		

--插入支行下现金钱箱数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
    ,bu_type --业务类型
    ,sum_time --统计时点
    ,accu_index_value_d --当日累计
    ,hours_total -- 小时合计
    ,unit --单位
    ,frequency --频度
    ,measure_no --度量编号
    ,index_measure --度量名称
    ,etl_timestamp --etl处理时间戳
     )
    WITH tmp_run_log AS
     (SELECT etl_dt
            , --数据日期
             sum_frequency AS frequency
            , --频度
             sum_start_time
            , --统计开始时点
             sum_end_time
            , --统计结束时点
             index_no --指标编号
      FROM   ${idl_schema}.mcyy_realtime_run_log
      WHERE  log_id = (SELECT MAX(log_id)
                       FROM   ${idl_schema}.mcyy_realtime_run_log
                       WHERE  etl_dt = to_date('${batch_date}'
                                              ,'yyyymmdd')
                       AND    index_no = 'WD050102'
                       AND    run_sts = 1)),
    tmp_initza_data AS
     (select T1.BRANCH        AS SUPER_ORG_NO,
       T1.USER_ID       AS ORG_NO,
       T1.USER_ID       AS ORG_NAME, --界面显示用柜员号 20210826
       T2.CCY           AS CRCYCD,
       T2.AMOUNT  AS INDEX_VALUE,
       NULL             AS BU_TYPE
  		from MSL_NCBS_TB_TAILBOX T1
  			INNER JOIN MSL_NCBS_TB_CASH_BALANCE T2
    		ON T1.TAILBOX_ID = T2.TAILBOX_ID
   			LEFT JOIN ITL_EDW_CMM_TELLER_INFO T3
   			ON T1.USER_ID=T3.TELLER_ID
   			--AND T3.TELLER_TYPE_CD='TELLER_USER' 
 			where T1.TAILBOX_STATUS = 'Y'
   			AND T1.TAILBOX_PROPERTY <> 'V'
   			AND T2.CCY = 'HKD' 
   			AND T2.AMOUNT >0
      ),
    temp_dev_data AS
     (SELECT t5.etl_dt
            , --数据日期
             to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time
            , --统计时点
             t3.index_no AS index_no
            , --指标编码
             t3.index_name_mcs AS index_name
            , --指标名称
             t2.org_no AS org_no
            , --钱箱对应单位编号
             t2.org_name AS org_name
            , --钱箱类型+钱箱对应单位编号
             t2.super_org_no AS super_org_no
             --设备所在机构号为上级机构号  
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t2.bu_type AS bu_type --业务类型
            ,index_value AS accu_index_value_d --当日
            ,NULL AS hours_total --小时合计
      
      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.super_org_no
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD050102' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      and t2.org_no is not null 
      )
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务类型
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
          ,mcyy_bu_analysis_realtime_temp.hours_total --小时合计
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total --小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;


--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
    ,bu_type --业务类型
    ,sum_time --统计时点
    ,accu_index_value_d --当日累计
    ,hours_total -- 小时合计
    ,unit --单位
    ,frequency --频度
    ,measure_no --度量编号
    ,index_measure --度量名称
    ,etl_timestamp --etl处理时间戳
     )
    WITH tmp_run_log AS
     (SELECT etl_dt
            , --数据日期
             sum_frequency AS frequency
            , --频度
             sum_start_time
            , --统计开始时点
             sum_end_time
            , --统计结束时点
             index_no --指标编号
      FROM   ${idl_schema}.mcyy_realtime_run_log
      WHERE  log_id = (SELECT MAX(log_id)
                       FROM   ${idl_schema}.mcyy_realtime_run_log
                       WHERE  etl_dt = to_date('${batch_date}'
                                              ,'yyyymmdd')
                       AND    index_no = 'WD050102'
                       AND    run_sts = 1)),
    --根据设备数据汇总成支行待查数据
    temp_sum_data AS
     (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d
            ,t2.super_org_no org_no
            ,t2.bu_type
      FROM   tmp_run_log t1
      INNER  JOIN mbar_cash_invtry_bal_${batch_date}_tm t2
      ON     t2.index_no = t1.index_no
      AND    t2.sum_time = to_date(t1.sum_end_time
                                  ,'yyyymmdd hh24:mi:ss')
      WHERE  t2.etl_dt = t1.etl_dt
      GROUP  BY t2.super_org_no, t2.bu_type),
    temp_org_data AS
     (SELECT t5.etl_dt
            , --数据日期
             to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time
            , --统计时点
             t3.index_no AS index_no
            , --指标编码
             t3.index_name_mcs AS index_name
            , --指标名称
             t1.org_no AS org_no
            , --机构编码
             t1.org_name AS org_name --机构名称
            ,t1.super_org_no AS super_org_no
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t1.bu_type AS bu_type --业务类型
            ,(CASE
                                WHEN t1.org_no = '000000' THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY T1.BU_TYPE)
                                WHEN length(t1.org_no) = 3 THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY substr(t1.org_no
                                                             ,1
                                                             ,3),T1.BU_TYPE)
                                ELSE
                                 coalesce(t2.accu_index_value_d
                                         ,0)
                            END) AS accu_index_value_d --当日
            ,(CASE
                                WHEN t1.org_no = '000000' THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY T1.BU_TYPE)
                                WHEN length(t1.org_no) = 3 THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY substr(t1.org_no
                                                             ,1
                                                             ,3),T1.BU_TYPE)
                                ELSE
                                 coalesce(t2.accu_index_value_d
                                         ,0)
                            END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
      
      FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      WHERE  t1.index_no = 'WD050102') dim_tab) t1 -- 机构树表
      LEFT   JOIN temp_sum_data t2
      ON     t2.org_no = t1.org_no
      AND    nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD050102' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no)
      
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务类型
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
          ,mcyy_bu_analysis_realtime_temp.hours_total --小时合计
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total --小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_org_data) mcyy_bu_analysis_realtime_temp;

COMMIT;


--  WD050103	澳元现金箱余额

--插入支行下现金钱箱数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
    ,bu_type --业务类型
    ,sum_time --统计时点
    ,accu_index_value_d --当日累计
    ,hours_total -- 小时合计
    ,unit --单位
    ,frequency --频度
    ,measure_no --度量编号
    ,index_measure --度量名称
    ,etl_timestamp --etl处理时间戳
     )
    WITH tmp_run_log AS
     (SELECT etl_dt
            , --数据日期
             sum_frequency AS frequency
            , --频度
             sum_start_time
            , --统计开始时点
             sum_end_time
            , --统计结束时点
             index_no --指标编号
      FROM   ${idl_schema}.mcyy_realtime_run_log
      WHERE  log_id = (SELECT MAX(log_id)
                       FROM   ${idl_schema}.mcyy_realtime_run_log
                       WHERE  etl_dt = to_date('${batch_date}'
                                              ,'yyyymmdd')
                       AND    index_no = 'WD050103'
                       AND    run_sts = 1)),
    tmp_initza_data AS
     ( select T1.BRANCH        AS SUPER_ORG_NO,
       T1.USER_ID       AS ORG_NO,
       T1.USER_ID       AS ORG_NAME, --界面显示用柜员号 20210826
       T2.CCY           AS CRCYCD,
       T2.AMOUNT  AS INDEX_VALUE,
       NULL             AS BU_TYPE
  		from MSL_NCBS_TB_TAILBOX T1
  			INNER JOIN MSL_NCBS_TB_CASH_BALANCE T2
    		ON T1.TAILBOX_ID = T2.TAILBOX_ID
   			LEFT JOIN ITL_EDW_CMM_TELLER_INFO T3
   			ON T1.USER_ID=T3.TELLER_ID
   			--AND T3.TELLER_TYPE_CD='TELLER_USER' 
 			where T1.TAILBOX_STATUS = 'Y'
   			AND T1.TAILBOX_PROPERTY <> 'V'
   			AND T2.CCY = 'AUD' 
   			AND T2.AMOUNT >0
 				 ),
    temp_dev_data AS
     (SELECT t5.etl_dt
            , --数据日期
             to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time
            , --统计时点
             t3.index_no AS index_no
            , --指标编码
             t3.index_name_mcs AS index_name
            , --指标名称
             t2.org_no AS org_no
            , --钱箱对应单位编号
             t2.org_name AS org_name
            , --钱箱类型+钱箱对应单位编号
             t2.super_org_no AS super_org_no
             --设备所在机构号为上级机构号  
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t2.bu_type AS bu_type --业务类型
            ,index_value AS accu_index_value_d --当日
            ,NULL AS hours_total --小时合计
      
      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.super_org_no
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD050103' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      and t2.org_no is not null 
      )
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务类型
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
          ,mcyy_bu_analysis_realtime_temp.hours_total --小时合计
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total --小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;


--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
    ,bu_type --业务类型
    ,sum_time --统计时点
    ,accu_index_value_d --当日累计
    ,hours_total -- 小时合计
    ,unit --单位
    ,frequency --频度
    ,measure_no --度量编号
    ,index_measure --度量名称
    ,etl_timestamp --etl处理时间戳
     )
    WITH tmp_run_log AS
     (SELECT etl_dt
            , --数据日期
             sum_frequency AS frequency
            , --频度
             sum_start_time
            , --统计开始时点
             sum_end_time
            , --统计结束时点
             index_no --指标编号
      FROM   ${idl_schema}.mcyy_realtime_run_log
      WHERE  log_id = (SELECT MAX(log_id)
                       FROM   ${idl_schema}.mcyy_realtime_run_log
                       WHERE  etl_dt = to_date('${batch_date}'
                                              ,'yyyymmdd')
                       AND    index_no = 'WD050103'
                       AND    run_sts = 1)),
    --根据设备数据汇总成支行待查数据
    temp_sum_data AS
     (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d
            ,t2.super_org_no org_no
            ,t2.bu_type
      FROM   tmp_run_log t1
      INNER  JOIN mbar_cash_invtry_bal_${batch_date}_tm t2
      ON     t2.index_no = t1.index_no
      AND    t2.sum_time = to_date(t1.sum_end_time
                                  ,'yyyymmdd hh24:mi:ss')
      WHERE  t2.etl_dt = t1.etl_dt
      GROUP  BY t2.super_org_no, t2.bu_type),
    temp_org_data AS
     (SELECT t5.etl_dt
            , --数据日期
             to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time
            , --统计时点
             t3.index_no AS index_no
            , --指标编码
             t3.index_name_mcs AS index_name
            , --指标名称
             t1.org_no AS org_no
            , --机构编码
             t1.org_name AS org_name --机构名称
            ,t1.super_org_no AS super_org_no
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t1.bu_type AS bu_type --业务类型
            ,(CASE
                                WHEN t1.org_no = '000000' THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY T1.BU_TYPE)
                                WHEN length(t1.org_no) = 3 THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY substr(t1.org_no
                                                             ,1
                                                             ,3),T1.BU_TYPE)
                                ELSE
                                 coalesce(t2.accu_index_value_d
                                         ,0)
                            END) AS accu_index_value_d --当日
            ,(CASE
                                WHEN t1.org_no = '000000' THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY T1.BU_TYPE)
                                WHEN length(t1.org_no) = 3 THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY substr(t1.org_no
                                                             ,1
                                                             ,3),T1.BU_TYPE)
                                ELSE
                                 coalesce(t2.accu_index_value_d
                                         ,0)
                            END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
      
      FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      WHERE  t1.index_no = 'WD050103') dim_tab) t1 -- 机构树表
      LEFT   JOIN temp_sum_data t2
      ON     t2.org_no = t1.org_no
      AND    nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD050103' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no)
      
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务类型
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
          ,mcyy_bu_analysis_realtime_temp.hours_total --小时合计
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total --小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_org_data) mcyy_bu_analysis_realtime_temp;

COMMIT;


--	WD050104	美元现金箱余额

--插入支行下现金钱箱数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
    ,bu_type --业务类型
    ,sum_time --统计时点
    ,accu_index_value_d --当日累计
    ,hours_total -- 小时合计
    ,unit --单位
    ,frequency --频度
    ,measure_no --度量编号
    ,index_measure --度量名称
    ,etl_timestamp --etl处理时间戳
     )
    WITH tmp_run_log AS
     (SELECT etl_dt
            , --数据日期
             sum_frequency AS frequency
            , --频度
             sum_start_time
            , --统计开始时点
             sum_end_time
            , --统计结束时点
             index_no --指标编号
      FROM   ${idl_schema}.mcyy_realtime_run_log
      WHERE  log_id = (SELECT MAX(log_id)
                       FROM   ${idl_schema}.mcyy_realtime_run_log
                       WHERE  etl_dt = to_date('${batch_date}'
                                              ,'yyyymmdd')
                       AND    index_no = 'WD050104'
                       AND    run_sts = 1)),
    tmp_initza_data AS
     (
   select T1.BRANCH        AS SUPER_ORG_NO,
       T1.USER_ID       AS ORG_NO,
       T1.USER_ID       AS ORG_NAME, --界面显示用柜员号 20210826
       T2.CCY           AS CRCYCD,
       T2.AMOUNT  AS INDEX_VALUE,
       NULL             AS BU_TYPE
  		from MSL_NCBS_TB_TAILBOX T1
  			INNER JOIN MSL_NCBS_TB_CASH_BALANCE T2
    		ON T1.TAILBOX_ID = T2.TAILBOX_ID
   			LEFT JOIN ITL_EDW_CMM_TELLER_INFO T3
   			ON T1.USER_ID=T3.TELLER_ID
   			--AND T3.TELLER_TYPE_CD='TELLER_USER' 
 			where T1.TAILBOX_STATUS = 'Y'
   			AND T1.TAILBOX_PROPERTY <> 'V'
   			AND T2.CCY = 'USD' 
   			AND T2.AMOUNT >0
      ),
    temp_dev_data AS
     (SELECT t5.etl_dt
            , --数据日期
             to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time
            , --统计时点
             t3.index_no AS index_no
            , --指标编码
             t3.index_name_mcs AS index_name
            , --指标名称
             t2.org_no AS org_no
            , --钱箱对应单位编号
             t2.org_name AS org_name
            , --钱箱类型+钱箱对应单位编号
             t2.super_org_no AS super_org_no
             --设备所在机构号为上级机构号  
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t2.bu_type AS bu_type --业务类型
            ,index_value AS accu_index_value_d --当日
            ,NULL AS hours_total --小时合计
      
      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.super_org_no
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD050104' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      and t2.org_no is not null 
      )
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务类型
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
          ,mcyy_bu_analysis_realtime_temp.hours_total --小时合计
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total --小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;


--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
    ,bu_type --业务类型
    ,sum_time --统计时点
    ,accu_index_value_d --当日累计
    ,hours_total -- 小时合计
    ,unit --单位
    ,frequency --频度
    ,measure_no --度量编号
    ,index_measure --度量名称
    ,etl_timestamp --etl处理时间戳
     )
    WITH tmp_run_log AS
     (SELECT etl_dt
            , --数据日期
             sum_frequency AS frequency
            , --频度
             sum_start_time
            , --统计开始时点
             sum_end_time
            , --统计结束时点
             index_no --指标编号
      FROM   ${idl_schema}.mcyy_realtime_run_log
      WHERE  log_id = (SELECT MAX(log_id)
                       FROM   ${idl_schema}.mcyy_realtime_run_log
                       WHERE  etl_dt = to_date('${batch_date}'
                                              ,'yyyymmdd')
                       AND    index_no = 'WD050104'
                       AND    run_sts = 1)),
    --根据设备数据汇总成支行待查数据
    temp_sum_data AS
     (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d
            ,t2.super_org_no org_no
            ,t2.bu_type
      FROM   tmp_run_log t1
      INNER  JOIN mbar_cash_invtry_bal_${batch_date}_tm t2
      ON     t2.index_no = t1.index_no
      AND    t2.sum_time = to_date(t1.sum_end_time
                                  ,'yyyymmdd hh24:mi:ss')
      WHERE  t2.etl_dt = t1.etl_dt
      GROUP  BY t2.super_org_no, t2.bu_type),
    temp_org_data AS
     (SELECT t5.etl_dt
            , --数据日期
             to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time
            , --统计时点
             t3.index_no AS index_no
            , --指标编码
             t3.index_name_mcs AS index_name
            , --指标名称
             t1.org_no AS org_no
            , --机构编码
             t1.org_name AS org_name --机构名称
            ,t1.super_org_no AS super_org_no
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t1.bu_type AS bu_type --业务类型
            ,(CASE
                                WHEN t1.org_no = '000000' THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY T1.BU_TYPE)
                                WHEN length(t1.org_no) = 3 THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY substr(t1.org_no
                                                             ,1
                                                             ,3),T1.BU_TYPE)
                                ELSE
                                 coalesce(t2.accu_index_value_d
                                         ,0)
                            END) AS accu_index_value_d --当日
            ,(CASE
                                WHEN t1.org_no = '000000' THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY T1.BU_TYPE)
                                WHEN length(t1.org_no) = 3 THEN
                                 SUM(coalesce(t2.accu_index_value_d
                                             ,0)) over(PARTITION BY substr(t1.org_no
                                                             ,1
                                                             ,3),T1.BU_TYPE)
                                ELSE
                                 coalesce(t2.accu_index_value_d
                                         ,0)
                            END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
      
      FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      WHERE  t1.index_no = 'WD050104') dim_tab) t1 -- 机构树表
      LEFT   JOIN temp_sum_data t2
      ON     t2.org_no = t1.org_no
      AND    nvl(t2.bu_type,'null')=nvl(t1.bu_type,'null')
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD050104' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no)
      
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务类型
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
          ,mcyy_bu_analysis_realtime_temp.hours_total --小时合计
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total --小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_org_data) mcyy_bu_analysis_realtime_temp;

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
        AND    index_no in('WD050101','WD050102','WD050103','WD050104');

COMMIT;

END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mcyy_bu_analysis_realtime_cash_invtry_bal出错' || SQLERRM);
    
END;


/

-- 3.1 insert into table
whenever sqlerror exit sql.sqlcode;

insert into ${idl_schema}.mcyy_bu_analysis_realtime
select * from ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm;

commit;
--3.2 drop tmp tables
drop table ${idl_schema}.mbar_cash_invtry_bal_${batch_date}_tm purge;


