/*
Purpose:    STM各交易时长-业务分析实时表(WD040804、WD040807、WD040808):数据来源于自助设备系统
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔1小时从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20210425
Logs:
20230518更新说明：
智能网点不会区分客户操作时长和柜员授权时长了，只有一个交易时长的概念。

-- 生成的IDL层表 ：mcyy_bu_analysis_realtime
-- 以下为依赖了上游的表 :
--新一代前 20230502后弃用
msl_atms_stm_business_detail_info_table
--新一代后切换启用
msl_nibs_ib_log_business_log

*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 0.2 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied

whenever sqlerror continue none ;

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
      to_char(start_time,'HH24MM') >= 60) --补跑批次
AND    to_date(sum_end_time,'yyyy-mm-dd hh24:mi:ss') <= SYSDATE
AND    index_no in('WD040804')
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
--AND  index_no IN ('WD040804','WD040807','WD040808');
AND  index_no ='WD040804';
COMMIT;

-- 2.1 insert into realtime table
--第一组 STM交易全流程时长
--插入支行下具体设备数据

INSERT /*+ append */
INTO ${idl_schema}.mcyy_bu_analysis_realtime
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,BU_TYPE --业务品种
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
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
                       AND    index_no = 'WD040804'
                       AND    run_sts = 1)),
    tmp_initza_data AS
    --1、89开头的虚拟机构，数据归纳到总行
    --2、800001营运管理部，数据归到总行
     /*(SELECT (CASE
                 WHEN substr(t.org_no
                            ,1
                            ,2) = '89'
                      OR t.org_no = '800001' THEN
                  '000000'
                 ELSE
                  t.org_no
             END) AS org_no
            ,SUM(round(to_number(to_date(t.mission_end_time
                                        ,'hh24:mi:ss') -
                                 to_date(t.create_time
                                        ,'hh24:mi:ss')) * 24 * 60)) /
             COUNT(1) AS sum_time         
            ,t.terminal_id AS dev_no
      			,fun_CODE_CONV(T.BUSINESS_NAME,'WD040804') AS BU_TYPE
      FROM   msl_atms_stm_business_detail_info_table t
      INNER  JOIN tmp_run_log t1
      ON     to_date(REPLACE(t.business_date
                            ,'-') || ' ' || t.create_time
                    ,'yyyymmdd hh24:mi:ss') >=
             to_date(t1.sum_start_time
                    ,'yyyymmdd hh24:mi:ss')
      AND    to_date(REPLACE(t.business_date
                            ,'-') || ' ' || t.create_time
                    ,'yyyymmdd hh24:mi:ss') <
             to_date(t1.sum_end_time
                     ,'yyyymmdd hh24:mi:ss')
      WHERE  t.business_status = '1'
      AND    REPLACE(t.business_date
                    ,'-') = '${batch_date}'
      AND    length(t.create_time) = 8
      GROUP  BY t.terminal_id, t.org_no,T.BUSINESS_NAME),*/
      (SELECT (CASE
                 WHEN substr(t.TX_ORG_NUM
                            ,1
                            ,2) = '89'
                      OR t.TX_ORG_NUM = '800001' THEN
                  '000000'
                 ELSE
                  t.TX_ORG_NUM
             END) AS org_no
            ,SUM(T.HANDLETIME) /COUNT(1) AS sum_time         
            ,t.OIDINFO AS dev_no
      			,null AS BU_TYPE
      FROM   msl_nibs_ib_log_business_log t
      INNER  JOIN tmp_run_log t1
      ON     t.CHANNELTIME >=to_date(t1.sum_start_time,'yyyymmdd hh24:mi:ss')
      AND    t.CHANNELTIME <to_date(t1.sum_end_time,'yyyymmdd hh24:mi:ss')
      WHERE  t.app_num = 'SS-STM'
      AND    t.CHANNELDATE = to_date('${batch_date}','yyyymmdd')
      GROUP  BY t.OIDINFO, t.TX_ORG_NUM),
    temp_dev_data AS
     (SELECT t5.etl_dt--数据日期
            ,to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time --统计时点
            , t3.index_no AS index_no --指标编码
            , t3.index_name_mcs AS index_name--指标名称
            ,t2.bu_type AS BU_TYPE --业务品种
            ,t2.dev_no AS org_no --设备编码
            , t2.dev_no AS org_name --设备名称 等同于设备编码
            , t2.org_no AS super_org_no --设备所在机构号为上级机构号  
            , t3.unit --单位
            ,t5.frequency AS frequency--频度
            , NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t2.sum_time AS accu_index_value_d --当日
            ,t2.sum_time AS hours_total --小时合计
      
      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.org_no
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD040804' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND    t2.org_no IS NOT NULL)
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务品种
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
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
                  ,bu_type --业务品种
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
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
INTO ${idl_schema}.mcyy_bu_analysis_realtime
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
                       AND    index_no = 'WD040804'
                       AND    run_sts = 1)),
    --根据设备数据汇总成支行待查数据
    temp_sum_data AS
     (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d
            ,t2.super_org_no org_no
            ,t2.bu_type
      FROM   tmp_run_log t1
      INNER  JOIN mcyy_bu_analysis_realtime t2
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
            ,null AS bu_type --业务类型
            ,(CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.accu_index_value_d
                              ,0)) over(PARTITION BY t2.bu_type)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.accu_index_value_d
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3)
                                       ,t2.bu_type)
                 ELSE
                  coalesce(t2.accu_index_value_d
                          ,0)
             END) AS accu_index_value_d --当日
            ,(CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.accu_index_value_d
                              ,0)) over(PARTITION BY t2.bu_type)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.accu_index_value_d
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3)
                                       ,t2.bu_type)
                 ELSE
                  coalesce(t2.accu_index_value_d
                          ,0)
             END) AS hours_total --小时合计 由于是全设备每小时刷新，所以小时合计即等于当日合计
      
      /*FROM   (SELECT *
              FROM   mcyy_orga_para org_tab
                    ,(SELECT t1.index_no, t3.dim_class || dim_no AS bu_type
                      FROM   mcyy_index_define t1
                      LEFT   JOIN mcyy_dim_index t2
                      ON     t1.index_no = t2.index_no
                      LEFT   JOIN mcyy_dim_define t3
                      ON     t2.dim_class = t3.dim_class
                      AND    t3.dim_class_name IS NOT NULL
                      WHERE  t1.index_no = 'WD040804') dim_tab) t1 -- 机构树表*/
      FROM      mcyy_orga_para   t1 -- 机构树表
      LEFT   JOIN temp_sum_data t2
      ON     t2.org_no = t1.org_no
      --AND    t2.bu_type = t1.bu_type
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD040804' = t3.index_no_mcs
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
WHERE  log_id = (SELECT MAX(log_id)
                 FROM   ${idl_schema}.mcyy_realtime_run_log
                 WHERE  etl_dt = to_date('${batch_date}'
                                        ,'yyyymmdd')
                 AND    index_no = 'WD040804'
                 AND    run_sts = 1
                 AND    start_time IS NOT NULL
                 AND    end_time IS NULL)

;
COMMIT;   
/*
         
--第二组 STM交易授权时长
--插入支行下具体设备数据
INSERT 
INTO ${idl_schema}.mcyy_bu_analysis_realtime
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,BU_TYPE --业务品种
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
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
                       AND    index_no = 'WD040807'
                       AND    run_sts = 1)),
    tmp_initza_data AS
    --1、89开头的虚拟机构，数据归纳到总行
    --2、800001营运管理部，数据归到总行
     (SELECT (CASE
                 WHEN substr(t.org_no
                            ,1
                            ,2) = '89'
                      OR t.org_no = '800001' THEN
                  '000000'
                 ELSE
                  t.org_no
             END) AS org_no
            ,SUM(round(to_number(to_date(t.auth_end_time
                                        ,'hh24:mi:ss') -
                                 to_date(t.auth_processing_time
                                        ,'hh24:mi:ss')) * 24 * 60)) /
             COUNT(CASE
                                WHEN t.auth_processing_time IS NOT NULL THEN
                                 1
                                ELSE
                                 NULL
                            END) AS auth_time
            ,t.terminal_id AS dev_no
      			 			,fun_CODE_CONV(T.BUSINESS_NAME,'WD040804') AS BU_TYPE
      FROM   msl_atms_stm_business_detail_info_table t
      INNER  JOIN tmp_run_log t1
      ON     to_date(REPLACE(t.business_date
                            ,'-') || ' ' || t.create_time
                    ,'yyyymmdd hh24:mi:ss') >=
             to_date(t1.sum_start_time
                    ,'yyyymmdd hh24:mi:ss')
      AND    to_date(REPLACE(t.business_date
                            ,'-') || ' ' || t.create_time
                    ,'yyyymmdd hh24:mi:ss') <
             to_date(t1.sum_end_time
                     ,'yyyymmdd hh24:mi:ss')
      WHERE  t.business_status = '1'
      AND    REPLACE(t.business_date
                    ,'-') = '${batch_date}'
      AND    length(t.create_time) = 8
      GROUP  BY t.terminal_id, t.org_no,T.BUSINESS_NAME),
    temp_dev_data AS
     (SELECT t5.etl_dt--数据日期
            ,to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time --统计时点
            , t3.index_no AS index_no --指标编码
            , t3.index_name_mcs AS index_name--指标名称
            ,t2.bu_type AS BU_TYPE --业务品种
            ,t2.dev_no AS org_no --设备编码
            , t2.dev_no AS org_name --设备名称 等同于设备编码
            , t2.org_no AS super_org_no --设备所在机构号为上级机构号  
            , t3.unit --单位
            ,t5.frequency AS frequency--频度
            , NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t2.auth_time AS accu_index_value_d --当日
            ,t2.auth_time AS hours_total --小时合计
      
      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.org_no
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD040807' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND    t2.org_no IS NOT NULL)
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务品种
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
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
                  ,bu_type --业务品种
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
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

INSERT 
INTO ${idl_schema}.mcyy_bu_analysis_realtime
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
                       AND    index_no = 'WD040807'
                       AND    run_sts = 1)),
    --根据设备数据汇总成支行待查数据
    temp_sum_data AS
     (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d
            ,t2.super_org_no org_no
            ,t2.bu_type
      FROM   tmp_run_log t1
      INNER  JOIN mcyy_bu_analysis_realtime t2
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
                              ,0)) over(PARTITION BY t1.bu_type)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.accu_index_value_d
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3)
                                       ,t1.bu_type)
                 ELSE
                  coalesce(t2.accu_index_value_d
                          ,0)
             END) AS accu_index_value_d --当日
            ,(CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.accu_index_value_d
                              ,0)) over(PARTITION BY t1.bu_type)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.accu_index_value_d
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3)
                                       ,t1.bu_type)
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
                      WHERE  t1.index_no = 'WD040807') dim_tab) t1 -- 机构树表
     -- FROM      mcyy_orga_para   t1 -- 机构树表
      LEFT   JOIN temp_sum_data t2
      ON     t2.org_no = t1.org_no
      AND    t2.bu_type = t1.bu_type
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD040807' = t3.index_no_mcs
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
WHERE  log_id = (SELECT MAX(log_id)
                 FROM   ${idl_schema}.mcyy_realtime_run_log
                 WHERE  etl_dt = to_date('${batch_date}'
                                        ,'yyyymmdd')
                 AND    index_no = 'WD040807'
                 AND    run_sts = 1
                 AND    start_time IS NOT NULL
                 AND    end_time IS NULL)

;
COMMIT;         
--第三组 STM交易客户操作时长
--插入支行下具体设备数据

INSERT 
INTO ${idl_schema}.mcyy_bu_analysis_realtime
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,BU_TYPE --业务品种
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
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
                       AND    index_no = 'WD040808'
                       AND    run_sts = 1)),
    tmp_initza_data AS
    --1、89开头的虚拟机构，数据归纳到总行
    --2、800001营运管理部，数据归到总行
     (SELECT (CASE
                 WHEN substr(t.org_no
                            ,1
                            ,2) = '89'
                      OR t.org_no = '800001' THEN
                  '000000'
                 ELSE
                  t.org_no
             END) AS org_no
           ,SUM(round(to_number(to_date(t.mission_end_time
                                        ,'hh24:mi:ss') -
                                 to_date(t.create_time
                                        ,'hh24:mi:ss')) * 24 * 60)) /
             COUNT(1) AS sum_time
            ,SUM(round(to_number(to_date(t.auth_end_time
                                        ,'hh24:mi:ss') -
                                 to_date(t.auth_processing_time
                                        ,'hh24:mi:ss')) * 24 * 60)) /
             COUNT(CASE
                                WHEN t.auth_processing_time IS NOT NULL THEN
                                1
                                ELSE
                                 NULL
                            END) AS auth_time
            ,t.terminal_id AS dev_no
      			 			,fun_CODE_CONV(T.BUSINESS_NAME,'WD040804') AS BU_TYPE
      FROM   msl_atms_stm_business_detail_info_table t
      INNER  JOIN tmp_run_log t1
      ON     to_date(REPLACE(t.business_date
                            ,'-') || ' ' || t.create_time
                    ,'yyyymmdd hh24:mi:ss') >=
             to_date(t1.sum_start_time
                    ,'yyyymmdd hh24:mi:ss')
      AND    to_date(REPLACE(t.business_date
                            ,'-') || ' ' || t.create_time
                    ,'yyyymmdd hh24:mi:ss') <
             to_date(t1.sum_end_time
                     ,'yyyymmdd hh24:mi:ss')
      WHERE  t.business_status = '1'
      AND    REPLACE(t.business_date
                    ,'-') = '${batch_date}'
      AND    length(t.create_time) = 8
      GROUP  BY t.terminal_id, t.org_no,T.BUSINESS_NAME),
    temp_dev_data AS
     (SELECT t5.etl_dt--数据日期
            ,to_date(t5.sum_end_time
                    ,'yyyymmdd hh24:mi:ss') AS sum_time --统计时点
            , t3.index_no AS index_no --指标编码
            , t3.index_name_mcs AS index_name--指标名称
            ,t2.bu_type AS BU_TYPE --业务品种
            ,t2.dev_no AS org_no --设备编码
            , t2.dev_no AS org_name --设备名称 等同于设备编码
            , t2.org_no AS super_org_no --设备所在机构号为上级机构号  
            , t3.unit --单位
            ,t5.frequency AS frequency--频度
            , NULL measure_no --- 度量编号
            ,t3.index_measure -- 度量名称
            ,t2.sum_time-coalesce(T2.auth_time,0) AS accu_index_value_d --当日
            ,t2.sum_time-coalesce(T2.auth_time,0) AS hours_total --小时合计
      
      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.org_no
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD040808' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no
      WHERE  length(t1.super_org_no) = 3 --只关联支行
      AND    t2.org_no IS NOT NULL)
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.bu_type --业务品种
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
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
                  ,bu_type --业务品种
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
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

INSERT 
INTO ${idl_schema}.mcyy_bu_analysis_realtime
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
                       AND    index_no = 'WD040808'
                       AND    run_sts = 1)),
    --根据设备数据汇总成支行待查数据
    temp_sum_data AS
     (SELECT SUM(t2.accu_index_value_d) AS accu_index_value_d
            ,t2.super_org_no org_no
            ,t2.bu_type
      FROM   tmp_run_log t1
      INNER  JOIN mcyy_bu_analysis_realtime t2
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
                              ,0)) over(PARTITION BY t1.bu_type)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.accu_index_value_d
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3)
                                       ,t1.bu_type)
                 ELSE
                  coalesce(t2.accu_index_value_d
                          ,0)
             END) AS accu_index_value_d --当日
            ,(CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.accu_index_value_d
                              ,0)) over(PARTITION BY t1.bu_type)
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.accu_index_value_d
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3)
                                       ,t1.bu_type)
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
                      WHERE  t1.index_no = 'WD040808') dim_tab) t1 -- 机构树表
     -- FROM      mcyy_orga_para   t1 -- 机构树表
      LEFT   JOIN temp_sum_data t2
      ON     t2.org_no = t1.org_no
      AND    t2.bu_type = t1.bu_type
      INNER  JOIN mcyy_index_define t3 --指标定义表
      ON     'WD040808' = t3.index_no_mcs
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
*/

UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1的结束时间
SET    run_sts = 2, end_time = SYSDATE
WHERE  log_id LIKE
       substr(rec_run_logs.log_id
             ,1
             ,8) || '%' || substr(rec_run_logs.log_id
                                 ,17
                                 ,4)
--AND  index_no IN ('WD040804','WD040807','WD040808');
AND  index_no ='WD040804';
COMMIT;

END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mcyy_bu_analysis_realtime_tran_duran出错' || SQLERRM);
    
END;


/