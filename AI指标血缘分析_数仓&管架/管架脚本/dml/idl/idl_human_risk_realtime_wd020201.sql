/*
Purpose:    客流量时间段分布D层-人员风险分析实时表(WD020201):数据来源于智能网点
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔30分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20210425
-- 以下为依赖了上游的表 :
MSL_NIBS_CQ_QM_QUEUESERIAL_LOG(OGG实时表)
Logs:

*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 0.2 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied

whenever sqlerror continue none;

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
      to_char(start_time,'HH24MM') >= 30) --补跑批次
AND    to_date(sum_end_time,'yyyy-mm-dd hh24:mi:ss') <= SYSDATE
AND    index_no ='WD020201'
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
 AND    index_no ='WD020201';
 
COMMIT;

-- 2.1 insert into realtime table

INSERT /*+ append */
INTO ${idl_schema}.mcyy_human_risk_realtime
    (
     
     etl_dt --数据日期       
    ,index_no --指标编码   
    ,index_name --指标名称    
    ,org_no --机构编码     
    ,org_name --机构名称   
    ,super_org_no --上级机构编码 
    ,sum_time --统计时点    
    ,index_value --指标时点值  
    ,accu_index_value_d --当日累计
    ,unit --单位    
    ,frequency --频度 
    ,measure_no --度量编号    
    ,index_measure --度量名称
    ,etl_timestamp --etl处理时间戳
    ,hours_total -- 小时合计  
    ,rate_up_hour --比上小时  
     
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
                       AND    index_no = 'WD020201'
                       AND    run_sts = 1)),
    tmp_initza_data AS
    --1、89开头的虚拟机构，数据归纳到总行
    --2、800001营运管理部，数据归到总行
    --20210425 增加XX分行营运管理部 /*3、xx分行营运管理部，数据归到分行  */
     (SELECT SUM(t1.index_value) AS account_sum
             
            ,(CASE
                 WHEN substr(t1.org_no
                            ,1
                            ,2) = '89'
                      OR t1.org_no = '800001' THEN
                  '000000'
                 ELSE
                  t1.org_no
             END) AS account_branch_id
      FROM   tmp_run_log
      LEFT   JOIN (SELECT BRNO AS org_no
      										,count(1) AS index_value
      										,to_date(WORKDATE || ' ' || to_char(QUEUEGETTIME, 'hh24:mi:ss')
              						,'yyyymmdd hh24:mi:ss') from_date
 									 FROM mcs.MSL_NIBS_CQ_QM_QUEUESERIAL_LOG
 										WHERE WORKDATE = '${batch_date}'
 									GROUP BY BRNO,to_date(WORKDATE || ' ' || to_char(QUEUEGETTIME, 'hh24:mi:ss'),'yyyymmdd hh24:mi:ss')                 
                  ) t1
      ON     t1.from_date >= to_date(tmp_run_log.sum_start_time
                                    ,'yyyymmdd hh24:mi:ss')
      AND    t1.from_date < to_date(tmp_run_log.sum_end_time
                                   ,'yyyymmdd hh24:mi:ss')
      GROUP  BY (CASE
                    WHEN substr(t1.org_no
                               ,1
                               ,2) = '89'
                         OR t1.org_no = '800001' THEN
                     '000000'
                    ELSE
                     t1.org_no
                END)
      
      ),
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
                  SUM(coalesce(t2.account_sum
                              ,0)) over()
                 WHEN length(t1.org_no) = 3 THEN
                  SUM(coalesce(t2.account_sum
                              ,0)) over(PARTITION BY substr(t1.org_no
                                              ,1
                                              ,3))
                 ELSE
                  coalesce(t2.account_sum
                          ,0)
             END AS index_value
            , --指标时点值
             
             coalesce(t4.accu_index_value_d
                     ,0) + (CASE
                                WHEN t1.org_no = '000000' THEN
                                 SUM(coalesce(t2.account_sum
                                             ,0)) over()
                                WHEN length(t1.org_no) = 3 THEN
                                 SUM(coalesce(t2.account_sum
                                             ,0)) over(PARTITION BY substr(t1.org_no
                                                             ,1
                                                             ,3))
                                ELSE
                                 coalesce(t2.account_sum
                                         ,0)
                            END)
             
             AS accu_index_value_d --当日累计
            ,CASE
                 WHEN to_char(to_date(t5.sum_start_time
                                     ,'yyyymmdd hh24:mi:ss')
                             ,('mi')) = '00' THEN
                  decode(length(t1.super_org_no)
                        ,'1'
                        ,SUM(coalesce(t2.account_sum
                                     ,0)) over()
                        ,'3'
                        ,coalesce(t2.account_sum
                                 ,0)
                        ,'6'
                        ,SUM(coalesce(t2.account_sum
                                     ,0)) over(PARTITION BY substr(t1.org_no
                                    ,1
                                    ,3)))
             
                 ELSE
                  coalesce(t4.hours_total
                          ,0) +
                  (decode(length(t1.super_org_no)
                         ,'1'
                         ,SUM(coalesce(t2.account_sum
                                      ,0)) over()
                         ,'3'
                         ,coalesce(t2.account_sum
                                  ,0)
                         ,'6'
                         ,SUM(coalesce(t2.account_sum
                                      ,0)) over(PARTITION BY substr(t1.org_no
                                     ,1
                                     ,3))))
             END AS hours_total --小时合计
            ,(CASE
                 WHEN to_char(to_date(t5.sum_start_time
                                     ,'yyyymmdd hh24:mi:ss')
                             ,('mi')) = '00' THEN
                 
                  (decode(length(t1.super_org_no)
                         ,'1'
                         ,SUM(coalesce(t2.account_sum
                                      ,0)) over()
                         ,'3'
                         ,coalesce(t2.account_sum
                                  ,0)
                         ,'6'
                         ,SUM(coalesce(t2.account_sum
                                      ,0)) over(PARTITION BY substr(t1.org_no
                                     ,1
                                     ,3)))) -
                  coalesce(t6.hours_total
                          ,0)
             
                 ELSE
                  coalesce(t4.hours_total
                          ,0) +
                  (decode(length(t1.super_org_no)
                         ,'1'
                         ,SUM(coalesce(t2.account_sum
                                      ,0)) over()
                         ,'3'
                         ,coalesce(t2.account_sum
                                  ,0)
                         ,'6'
                         ,SUM(coalesce(t2.account_sum
                                      ,0)) over(PARTITION BY substr(t1.org_no
                                     ,1
                                     ,3)))) -
                  coalesce(t6.hours_total
                          ,0)
             END) AS rate_up_hour --比上小时
            ,t3.unit
            , --单位
             t5.frequency AS frequency
            , --频度
             NULL measure_no
            , --- 度量编号
             t3.index_measure -- 度量名称
      FROM   ${idl_schema}.mcyy_orga_para t1 -- 机构树表
      LEFT   JOIN tmp_initza_data t2
      ON     t1.org_no = t2.account_branch_id
      INNER  JOIN ${idl_schema}.mcyy_index_define t3 --指标定义表
      ON     'WD020201' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no
      LEFT   JOIN ${idl_schema}.mcyy_human_risk_realtime t4 --上一个频度表
      ON     t4.org_no = t1.org_no
      AND    t4.index_no = t3.index_no
      AND    t4.sum_time =
             to_date(t5.sum_end_time
                     ,'yyyymmdd hh24:mi:ss') - t5.frequency / (24 * 60)
      
      LEFT   JOIN ${idl_schema}.mcyy_human_risk_realtime t6 --上一个小时
      ON     t6.org_no = t1.org_no
      AND    t6.index_no = t3.index_no
      AND    t6.sum_time = (CASE
                 WHEN to_char(to_date(t5.sum_end_time
                                     ,'yyyymmdd hh24:mi:ss')
                             ,'HH24MI') = '1730' THEN
                  to_date(t5.sum_end_time
                         ,'yyyymmdd hh24:mi:ss') - t5.frequency / (24 * 60)
                 ELSE
                  to_date(t5.sum_end_time
                         ,'yyyymmdd hh24:mi:ss') -
                  (t5.frequency / (24 * 60) * 2)
             END))
    SELECT mcyy_human_risk_realtime_temp.etl_dt --数据日期
          ,mcyy_human_risk_realtime_temp.index_no --指标编码
          ,mcyy_human_risk_realtime_temp.index_name --指标名称
          ,mcyy_human_risk_realtime_temp.org_no --机构编码
          ,mcyy_human_risk_realtime_temp.org_name --机构名称
          ,mcyy_human_risk_realtime_temp.super_org_no --上级机构编码
          ,mcyy_human_risk_realtime_temp.sum_time --统计时点
          ,mcyy_human_risk_realtime_temp.index_value --指标时点值
          ,mcyy_human_risk_realtime_temp.accu_index_value_d --当日累计
          ,mcyy_human_risk_realtime_temp.unit --单位
          ,mcyy_human_risk_realtime_temp.frequency --频度
          ,mcyy_human_risk_realtime_temp.measure_no --度量编号
          ,mcyy_human_risk_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --ETL处理时间戳
          ,mcyy_human_risk_realtime_temp.hours_total -- 小时合计
          ,mcyy_human_risk_realtime_temp.rate_up_hour --比上小时
    
    FROM   (SELECT etl_dt --数据日期
                  ,index_no --指标编码
                  ,index_name --指标名称
                  ,org_no --机构编码
                  ,org_name --机构名称
                  ,super_org_no --上级机构编码
                  ,sum_time --统计时点
                  ,index_value --指标时点值
                  ,accu_index_value_d --当日累计
                  ,unit --单位
                  ,frequency --频度
                  ,measure_no --度量编号
                  ,index_measure --度量名称
                  ,hours_total -- 小时合计 
                  ,rate_up_hour --比上小时
            FROM   temp_now_data) mcyy_human_risk_realtime_temp;

COMMIT;
-- 3.1 updater log table 

-- 2.2 update log table 

UPDATE ${idl_schema}.mcyy_realtime_run_log --更新当前计划的运行状态为1的结束时间
SET    run_sts = 2, end_time = SYSDATE
WHERE  log_id LIKE
       substr(rec_run_logs.log_id
             ,1
             ,8) || '%' || substr(rec_run_logs.log_id
                                 ,17
                                 ,4)
        AND    index_no ='WD020201';

COMMIT;

END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mcyy_human_risk_realtime_wd020201出错' || SQLERRM);
    
END;

/
            
