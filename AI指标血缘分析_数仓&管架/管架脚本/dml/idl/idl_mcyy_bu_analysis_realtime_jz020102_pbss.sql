/*
Purpose:    流程银行已处理任务数JZ020102-D层业务分析表:数据来源于流程银行SCPS
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔5分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20210112
Logs:

-- 生成的IDL层表 ：mcyy_bu_analysis_realtime
-- 以下为依赖了上游的表 :
-- MSL_SCPS_BP_TRANSLIST_TB    --业务流水表
-- 以下为依赖的参数表 :
-- mcyy_index_define           -- 指标表清单
-- mcyy_orga_para                   -- 总分支机构表
-- mcyy_realtime_run_log       --准实时跑数计划日志表

*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 1;

-- 0.2 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.mbar_jz020102_${batch_date}_tm purge ;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mbar_jz020102_${batch_date}_tm
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
AND    index_no ='JZ020102'
ORDER  BY sum_end_time,index_no;

 CURSOR CUR_TABLE_LIST IS
   SELECT TABLE_NAME
   			FROM ALL_TABLES
  WHERE TABLE_NAME LIKE UPPER('mbar_jz020102_%')
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
 AND    index_no ='JZ020102';
COMMIT;

-- 2.1 insert into realtime table

INSERT /*+ append */
INTO ${idl_schema}.mbar_jz020102_${batch_date}_tm
    (etl_dt --数据日期
    ,index_no --指标编码
    ,index_name --指标名称
    ,org_no --机构编码
    ,org_name --机构名称
    ,super_org_no --上级机构编码
    ,sum_time --统计时点
    ,index_value --指标时点值
    ,accu_index_value_d --当日累计
    ,index_value_avg --均值
    ,unit --单位
    ,frequency --频度
    ,measure_no --度量编号
    ,index_measure --度量名称
    ,etl_timestamp --etl处理时间戳
    ,hours_total -- 小时合计
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
                       AND    index_no = 'JZ020102'
                       AND    run_sts = 1)),
    tmp_initza_data AS
    --1、89开头的虚拟机构，数据归纳到总行
    --2、800001营运管理部，数据归到总行
    --3、xx分行营运管理部，数据归到分行
    
     (SELECT (CASE
                 WHEN substr(a.begin_orgno
                            ,1
                            ,2) = '89'
                      OR a.begin_orgno = '800001' THEN
                  '800'
                 WHEN a.begin_orgno LIKE '%001'
                      AND substr(a.begin_orgno
                                ,1
                                ,2) != '89'
                      AND a.begin_orgno != '800001' THEN
                  substr(a.begin_orgno
                        ,1
                        ,3)
                 ELSE
                  a.begin_orgno
             END) AS task_branch_id
            ,COUNT(DISTINCT a.task_id) AS totaltask 
     FROM  ${msl_schema}.msl_scps_bp_translist_tb a
      LEFT JOIN ${msl_schema}.msl_scps_workitem B
				ON B.priname = A.task_id
                  WHERE  a.trans_date = to_date('${batch_date}'
                                            ,'yyyymmdd')
                  and    b.appid ='1001' --流程银行已处理任务数
  		and to_date(to_char(a.trans_date,'yyyymmdd') || ' ' || a.trans_time
                                   ,'yyyymmdd hh24:mi:ss') < (select to_date(tmp_run_log.sum_end_time
                                   ,'yyyymmdd hh24:mi:ss') from tmp_run_log)
  		and a.task_state  in ('02','03','05')
      GROUP  BY (CASE
                 WHEN substr(a.begin_orgno
                            ,1
                            ,2) = '89'
                      OR a.begin_orgno = '800001' THEN
                  '800'
                 WHEN a.begin_orgno LIKE '%001'
                      AND substr(a.begin_orgno
                                ,1
                                ,2) != '89'
                      AND a.begin_orgno != '800001' THEN
                  substr(a.begin_orgno
                        ,1
                        ,3)
                 ELSE
                  a.begin_orgno
             END)),
    
    temp_now_data AS
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
             t1.org_name AS org_name
            , --机构名称
             t1.super_org_no AS super_org_no
            , --上级机构编码,
             CASE
                 WHEN t1.org_no = '000000' THEN
                  SUM(coalesce(t2.totaltask
                              ,0)) over()
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.totaltask
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3))
                 ELSE
                  coalesce(t2.totaltask
                          ,0)
             END AS accu_index_value_d --当日累计
             
            ,t3.unit --单位
             
            ,t5.frequency AS frequency --频度
             
            ,'001' AS measure_no
            , --- 度量编号
             t3.index_measure -- 度量名称
      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.task_branch_id
      INNER  JOIN ${idl_schema}.mcyy_index_define t3 --指标定义表
      ON     'JZ020102' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no)
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,NULL --指标时点值
          ,mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
          ,NULL index_value_avg --均值
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --ETL处理时间戳
          ,NULL -- 小时合计
    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,sum_time --统计时点                  
                  ,accu_index_value_d --当日累计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
            
            FROM   temp_now_data) mcyy_bu_analysis_realtime_temp;

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
            AND    index_no ='JZ020102';

COMMIT;

END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mcyy_bu_analysis_realtime_jz020102_pbss出错' || SQLERRM);
    
END;


/

-- 3.1 insert into table
whenever sqlerror exit sql.sqlcode;

insert into ${idl_schema}.mcyy_bu_analysis_realtime
select * from ${idl_schema}.mbar_jz020102_${batch_date}_tm;

commit;
--3.2 drop tmp tables
drop table ${idl_schema}.mbar_jz020102_${batch_date}_tm purge;


