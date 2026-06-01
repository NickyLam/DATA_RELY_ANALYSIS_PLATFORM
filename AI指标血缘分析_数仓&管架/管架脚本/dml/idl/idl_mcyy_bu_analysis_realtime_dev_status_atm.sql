/*
Purpose:    ATM设备运行情况-业务分析实时表(WD041012):数据来源于自助设备系统
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔5分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20210714
Logs:

-- 生成的IDL层表 ：mcyy_bu_analysis_realtime
-- 以下为依赖了上游的表 (OGG实时表):
msl_atms_dev_status_table
msl_atms_dev_base_info
msl_atms_dev_catalog_table
msl_atms_dev_responsor_table
msl_atms_bank_manager_persion

生成指标列表
1	WD041011	网点作业	ATM/CRS设备运行情况(优化）		故障设备数量		
2	WD041010	网点作业	ATM/CRS设备运行情况(优化）		正常设备数量		    		
3	WD041012	网点作业	ATM/CRS设备运行情况(优化）		自助设备数量汇总		

*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 0.2 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.mbar_dev_status_atm_${batch_date}_tm purge ;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mbar_dev_status_atm_${batch_date}_tm
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
--AND    index_no in('WD041011','WD041010','WD041012')
AND    index_no in('WD041011')
ORDER  BY sum_end_time,index_no;

BEGIN
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
 AND    index_no in('WD041011','WD041010','WD041012');
COMMIT;


-- 2.1 insert into realtime table
--WD041012 自助设备数量汇总
--插入支行下具体设备数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_dev_status_atm_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,employee --员工名称，主要用于存放支行下设备的管理人员
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
                       AND    index_no = 'WD041012'
                       AND    run_sts = 1)),
    tmp_initza_data AS
    --1、89开头的虚拟机构，数据归纳到总行
    --2、800001营运管理部，数据归到总行
     (SELECT (CASE
                 WHEN substr(t2.org_no
                            ,1
                            ,2) = '89'
                      OR t2.org_no = '800001' THEN
                  '000000'
                 ELSE
                  t2.org_no
             END) AS org_no
            ,COUNT(DISTINCT t1.dev_no) AS index_value
            ,t1.dev_no AS dev_no
            ,t5.name AS manager_name
             --设备运行情况 SBYXQK 码值转换
            ,FUN_CODE_CONV(t1.dev_run_status,'WD041012') AS bu_type
            ,to_date(status_last_time
                    ,'yyyymmdd hh24:mi:ss') AS last_time
      FROM   msl_atms_dev_status_table t1
      LEFT   JOIN msl_atms_dev_base_info t2
      ON     t2.no = t1.dev_no
      LEFT   JOIN msl_atms_dev_catalog_table t3
      ON     t2.dev_catalog = t3.no
      LEFT   JOIN (SELECT d.dev_no, listagg(o.name,',') as name 
                  FROM   msl_atms_dev_responsor_table d, msl_atms_bank_manager_persion o
                  WHERE  to_char(d.RESPONSER_NO) = o.no
                  AND    d.catalog = 1
                  AND    d.grade = 1
                  group by d.dev_no) t5
      ON     t5.dev_no = t1.dev_no
      WHERE  t3.name IN ('ATM','CDM','CRS')
      AND    t2.operate_status != '3'
      AND    t2.status <> '0' --不含注销设备
      AND    substr(status_last_time
                   ,1
                   ,8) = '${batch_date}'
      /*AND    to_date(status_last_time
                    ,'yyyymmdd hh24:mi:ss') <
             (SELECT to_date(tmp_run_log.sum_end_time
                             ,'yyyymmdd hh24:mi:ss')
               FROM   tmp_run_log)*/
      GROUP  BY t1.dev_no
               ,t5.name
               ,t1.dev_run_status
               ,to_date(status_last_time
                       ,'yyyymmdd hh24:mi:ss')
               ,(CASE
                    WHEN substr(t2.org_no
                               ,1
                               ,2) = '89'
                         OR t2.org_no = '800001' THEN
                     '000000'
                    ELSE
                     t2.org_no
                END)),
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
             t2.dev_no AS org_no
            , --设备编码
             t2.dev_no AS org_name
            , --设备名称 等同于设备编码
             t2.org_no AS super_org_no
            , --设备所在机构号为上级机构号  
             t2.manager_name AS employee --机具管理人员              
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t2.bu_type AS bu_type --业务类型
            ,1 AS accu_index_value_d --当日
            ,1 AS hours_total --小时合计

      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.org_no
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD041012' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND    T2.BU_TYPE IS NOT NULL
      
      )
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.employee --员工名称，主要用于存放支行下设备的管理人员
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
                  ,employee --员工名称，主要用于存放支行下设备的管理人员
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total--小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_dev_status_atm_${batch_date}_tm
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
                       AND    index_no = 'WD041012'
                       AND    run_sts = 1)),
    --根据设备数据汇总成支行待查数据
    temp_sum_data AS
     (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d
            ,t2.super_org_no org_no
            ,t2.bu_type
      FROM   tmp_run_log t1
      INNER  JOIN mbar_dev_status_atm_${batch_date}_tm t2
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
                      WHERE  t1.index_no = 'WD041012') dim_tab) t1 -- 机构树表
      LEFT   JOIN temp_sum_data t2
      ON     t2.org_no = t1.org_no
      AND    t2.bu_type = t1.bu_type
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD041012' = t3.index_no_mcs
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



--WD041010 正常设备数量
--插入支行下具体设备数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_dev_status_atm_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,employee --员工名称，主要用于存放支行下设备的管理人员
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
                       AND    index_no = 'WD041012'
                       AND    run_sts = 1)),
    tmp_initza_data AS
    --1、89开头的虚拟机构，数据归纳到总行
    --2、800001营运管理部，数据归到总行
     (SELECT (CASE
                 WHEN substr(t2.org_no
                            ,1
                            ,2) = '89'
                      OR t2.org_no = '800001' THEN
                  '000000'
                 ELSE
                  t2.org_no
             END) AS org_no
            ,COUNT(DISTINCT t1.dev_no) AS index_value
            ,t1.dev_no AS dev_no
            ,t5.name AS manager_name
             --设备运行情况 SBYXQK 码值转换
            ,FUN_CODE_CONV(t1.dev_run_status,'WD041012') AS bu_type
            ,to_date(status_last_time
                    ,'yyyymmdd hh24:mi:ss') AS last_time
      FROM   msl_atms_dev_status_table t1
      LEFT   JOIN msl_atms_dev_base_info t2
      ON     t2.no = t1.dev_no
      LEFT   JOIN msl_atms_dev_catalog_table t3
      ON     t2.dev_catalog = t3.no
      LEFT   JOIN (SELECT d.dev_no, listagg(o.name,',') as name 
                  FROM   msl_atms_dev_responsor_table d, msl_atms_bank_manager_persion o
                  WHERE  to_char(d.RESPONSER_NO) = o.no
                  AND    d.catalog = 1
                  AND    d.grade = 1
                  group by d.dev_no) t5
      ON     t5.dev_no = t1.dev_no
      WHERE  t3.name IN ('ATM','CDM','CRS')
      AND    t2.operate_status != '3'
      AND    t2.status <> '0' --不含注销设备
      AND    substr(status_last_time
                   ,1
                   ,8) = '${batch_date}'
      /*AND    to_date(status_last_time
                    ,'yyyymmdd hh24:mi:ss') <
             (SELECT to_date(tmp_run_log.sum_end_time
                             ,'yyyymmdd hh24:mi:ss')
               FROM   tmp_run_log)*/
      and t1.dev_run_status ='HEALTHY'
      GROUP  BY t1.dev_no
               ,t5.name
               ,t1.dev_run_status
               ,to_date(status_last_time
                       ,'yyyymmdd hh24:mi:ss')
               ,(CASE
                    WHEN substr(t2.org_no
                               ,1
                               ,2) = '89'
                         OR t2.org_no = '800001' THEN
                     '000000'
                    ELSE
                     t2.org_no
                END)),
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
             t2.dev_no AS org_no
            , --设备编码
             t2.dev_no AS org_name
            , --设备名称 等同于设备编码
             t2.org_no AS super_org_no
            , --设备所在机构号为上级机构号  
             t2.manager_name AS employee --机具管理人员              
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t2.bu_type AS bu_type --业务类型
            ,1 AS accu_index_value_d --当日
            ,1 AS hours_total --小时合计

      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.org_no
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD041010' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = 'WD041012'
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND    T2.BU_TYPE IS NOT NULL
      
      )
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.employee --员工名称，主要用于存放支行下设备的管理人员
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
                  ,employee --员工名称，主要用于存放支行下设备的管理人员
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total--小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_dev_status_atm_${batch_date}_tm
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
                       AND    index_no = 'WD041012'
                       AND    run_sts = 1)),
    --根据设备数据汇总成支行待查数据
    temp_sum_data AS
     (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d
            ,t2.super_org_no org_no
            ,t2.bu_type
      FROM   tmp_run_log t1
      INNER  JOIN mbar_dev_status_atm_${batch_date}_tm t2
      ON     t2.index_no = 'WD041010'
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
        AND    t3.dim_class || dim_no = 'SBYXQK001'
        WHERE  t1.index_no = 'WD041012') dim_tab) t1 -- 机构树表
      LEFT   JOIN temp_sum_data t2
      ON     t2.org_no = t1.org_no
      AND    t2.bu_type = t1.bu_type
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD041010' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = 'WD041012')
      
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

--WD041011 故障设备数量
--插入支行下具体设备数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_dev_status_atm_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,employee --员工名称，主要用于存放支行下设备的管理人员
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
                       AND    index_no = 'WD041012'
                       AND    run_sts = 1)),
    tmp_initza_data AS
    --1、89开头的虚拟机构，数据归纳到总行
    --2、800001营运管理部，数据归到总行
     (SELECT (CASE
                 WHEN substr(t2.org_no
                            ,1
                            ,2) = '89'
                      OR t2.org_no = '800001' THEN
                  '000000'
                 ELSE
                  t2.org_no
             END) AS org_no
            ,COUNT(DISTINCT t1.dev_no) AS index_value
            ,t1.dev_no AS dev_no
            ,t5.name AS manager_name
             --设备运行情况 SBYXQK 码值转换
            ,FUN_CODE_CONV(t1.dev_run_status,'WD041012') AS bu_type
            ,to_date(status_last_time
                    ,'yyyymmdd hh24:mi:ss') AS last_time
      FROM   msl_atms_dev_status_table t1
      LEFT   JOIN msl_atms_dev_base_info t2
      ON     t2.no = t1.dev_no
      LEFT   JOIN msl_atms_dev_catalog_table t3
      ON     t2.dev_catalog = t3.no
      LEFT   JOIN (SELECT d.dev_no, listagg(o.name,',') as name 
                  FROM   msl_atms_dev_responsor_table d, msl_atms_bank_manager_persion o
                  WHERE  to_char(d.RESPONSER_NO) = o.no
                  AND    d.catalog = 1
                  AND    d.grade = 1
                  group by d.dev_no) t5
      ON     t5.dev_no = t1.dev_no
      WHERE  t3.name IN ('ATM','CDM','CRS')
      AND    t2.operate_status != '3'
      AND    t2.status <> '0' --不含注销设备
      AND    substr(status_last_time
                   ,1
                   ,8) = '${batch_date}'
      /*AND    to_date(status_last_time
                    ,'yyyymmdd hh24:mi:ss') <
             (SELECT to_date(tmp_run_log.sum_end_time
                             ,'yyyymmdd hh24:mi:ss')
               FROM   tmp_run_log)*/
      and t1.dev_run_status !='HEALTHY'
      GROUP  BY t1.dev_no
               ,t5.name
               ,t1.dev_run_status
               ,to_date(status_last_time
                       ,'yyyymmdd hh24:mi:ss')
               ,(CASE
                    WHEN substr(t2.org_no
                               ,1
                               ,2) = '89'
                         OR t2.org_no = '800001' THEN
                     '000000'
                    ELSE
                     t2.org_no
                END)),
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
             t2.dev_no AS org_no
            , --设备编码
             t2.dev_no AS org_name
            , --设备名称 等同于设备编码
             t2.org_no AS super_org_no
            , --设备所在机构号为上级机构号  
             t2.manager_name AS employee --机具管理人员              
            ,t3.unit --单位
            ,t5.frequency AS frequency
            , --频度
             NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t2.bu_type AS bu_type --业务类型
            ,1 AS accu_index_value_d --当日
            ,1 AS hours_total --小时合计

      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.org_no
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD041011' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = 'WD041012'
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND    T2.BU_TYPE IS NOT NULL
      
      )
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.employee --员工名称，主要用于存放支行下设备的管理人员
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
                  ,employee --员工名称，主要用于存放支行下设备的管理人员
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d --当日累计
                  ,hours_total--小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            FROM   temp_dev_data) mcyy_bu_analysis_realtime_temp;

COMMIT;

--根据设备数据汇总成总分支数据

INSERT /*+ append */
INTO ${idl_schema}.mbar_dev_status_atm_${batch_date}_tm
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
    ,RATIO_INDEX --故障设备占比
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
                       AND    index_no = 'WD041012'
                       AND    run_sts = 1)),
    --根据设备数据汇总成支行待查数据
    temp_sum_data AS
     (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d
            ,t2.super_org_no org_no
            ,t2.bu_type
            --,ratio_to_report(sum(t2.accu_index_value_d)) over(PARTITION BY t2.super_org_no,t2.bu_type) as RATIO_INDEX
      FROM   tmp_run_log t1
      INNER  JOIN mbar_dev_status_atm_${batch_date}_tm t2
      ON     t2.index_no = 'WD041011'
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
            --,t2.RATIO_INDEX
      FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      AND    t3.dim_class || dim_no <> 'SBYXQK001'
                      WHERE  t1.index_no = 'WD041012') dim_tab) t1 -- 机构树表
      LEFT   JOIN temp_sum_data t2
      ON     t2.org_no = t1.org_no
      AND    t2.bu_type = t1.bu_type
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD041011' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = 'WD041012')
      
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务类型
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,sum(mcyy_bu_analysis_realtime_temp.accu_index_value_d) --当日累计
          ,sum(mcyy_bu_analysis_realtime_temp.hours_total) --小时合计
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --etl处理时间戳
         , ratio_to_report(sum(mcyy_bu_analysis_realtime_temp.accu_index_value_d)) over(PARTITION BY mcyy_bu_analysis_realtime_temp.org_no,mcyy_bu_analysis_realtime_temp.index_no) as RATIO_INDEX --占比

    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,bu_type --业务类型
                  ,sum_time --统计时点
                  ,accu_index_value_d--当日累计
                  ,hours_total --小时合计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
									--,RATIO_INDEX
            FROM   temp_org_data) mcyy_bu_analysis_realtime_temp
            group by mcyy_bu_analysis_realtime_temp.etl_dt
            ,mcyy_bu_analysis_realtime_temp.index_no -- 指标编码
             ,mcyy_bu_analysis_realtime_temp.index_name -- 指标名称
             ,mcyy_bu_analysis_realtime_temp.org_no -- 机构编码
             ,mcyy_bu_analysis_realtime_temp.org_name -- 机构名称
             ,mcyy_bu_analysis_realtime_temp.super_org_no -- 上级机构编码
             ,mcyy_bu_analysis_realtime_temp.bu_type
             ,mcyy_bu_analysis_realtime_temp.sum_time
             ,mcyy_bu_analysis_realtime_temp.unit
             ,mcyy_bu_analysis_realtime_temp.frequency -- 频度
             ,mcyy_bu_analysis_realtime_temp.measure_no --- 度量编号
             ,mcyy_bu_analysis_realtime_temp.index_measure -- 度量名称
            ;

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
        AND    index_no in('WD041011','WD041010','WD041012');

COMMIT;

END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mcyy_bu_analysis_realtime_dev_status_atm出错' || SQLERRM);
    
END;


/

-- 3.1 insert into table
whenever sqlerror exit sql.sqlcode;

insert into ${idl_schema}.mcyy_bu_analysis_realtime
select * from ${idl_schema}.mbar_dev_status_atm_${batch_date}_tm;

commit;
--3.2 drop tmp tables
drop table ${idl_schema}.mbar_dev_status_atm_${batch_date}_tm purge;
