/*
Purpose:    支付业务交易量D层-业务分析实时表(WD040101):数据来源于统一支付、银联
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔5分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20210118
Logs:

*/
set timing on
-- 0.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 1;

-- 0.2 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${idl_schema}.mbar_wd040101_${batch_date}_tm purge ;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mbar_wd040101_${batch_date}_tm
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
AND    index_no ='WD040101'
ORDER  BY sum_end_time,index_no;

 CURSOR CUR_TABLE_LIST IS
   SELECT TABLE_NAME
   			FROM ALL_TABLES
  WHERE TABLE_NAME LIKE UPPER('mbar_wd040101_%')
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
 AND    index_no ='WD040101';
 
COMMIT;

-- 2.1 insert into realtime table

INSERT /*+ append */
INTO ${idl_schema}.mbar_wd040101_${batch_date}_tm
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
                       FROM   mcyy_realtime_run_log
                       WHERE  etl_dt = to_date('${batch_date}'
                                              ,'yyyymmdd')
                       AND    index_no = 'WD040101'
                       AND    run_sts = 1)),
    tmp_initza_data AS
    --1、89开头的虚拟机构，数据归纳到总行
    --2、800001营运管理部，数据归到总行
    --3、xx分行营运管理部，数据归到分行
     (SELECT SUM(t1.sum_count) AS account_sum
            ,(CASE
                 WHEN substr(t1.org_no
                            ,1
                            ,2) = '89'
                      OR t1.org_no = '800001' THEN
                  '800'
                 WHEN t1.org_no LIKE '%001'
                      AND substr(t1.org_no
                                ,1
                                ,2) != '89'
                      AND t1.org_no != '800001' THEN
                  substr(t1.org_no
                        ,1
                        ,3)
                 ELSE
                  t1.org_no
             END) AS account_branch_id
      FROM   tmp_run_log
      LEFT   JOIN (
                  --银联
                  SELECT t1.brnnbr AS org_no --交易机构号
                         ,COUNT(1) AS sum_count --业务笔数
                         ,to_date(substr(trn_time
                                        ,1
                                        ,12)
                                 ,'yyyymmddhh24mi') AS from_date
                  FROM   ${msl_schema}.msl_mpcs_a50ubcardjour t1
                  WHERE  t1.status IN ('1'
                                      ,'2'
                                      ,'9')
                  AND    substr(t1.trncd
                               ,7
                               ,1) <> 'C'
                  AND    t1.channels IS NOT NULL
                  AND    substr(trn_time
                               ,1
                               ,8) = '${batch_date}'
                  --and substr(trn_time,1,12) >  to_char(sysdate-5/(24 * 60),'yyyymmddHH24MI')
                  GROUP  BY t1.brnnbr
                            ,to_date(substr(trn_time
                                           ,1
                                           ,12)
                                    ,'yyyymmddhh24mi')
                  UNION ALL
                  --统一支付
                  
                  /*SELECT t1.product_store_id AS org_no --交易机构号
                        ,COUNT(DISTINCT t1.order_id) AS sum_count --业务笔数
                         --,SUM(t1.amount) AS sum_amount --业务金额
                        ,t1.created_tx_stamp AS from_date
                  FROM   ${msl_schema}.msl_upps_order_header t1
                  WHERE  t1.status_id = 'ORDER_COMPLETED'
                  AND    t1.created_tx_stamp >= trunc(SYSDATE)
                  AND    t1.created_tx_stamp <= trunc(SYSDATE) + 1
                  GROUP  BY t1.product_store_id, t1.created_tx_stamp
                  UNION ALL
                  SELECT t2.trans_org_no AS org_no --交易机构号
                        ,COUNT(DISTINCT global_no) AS sum_count --业务笔数
                         --,SUM(amount) AS sum_amount --业务金额
                        ,t2.create_time AS from_date
                  FROM   ${msl_schema}.msl_upps_t_txn_credit t2
                  WHERE  t2.status = 'SUCCESS'
                  AND    t2.trade_type = 'TRANSFER'
                  AND    t2.create_time >= trunc(SYSDATE)
                  AND    t2.create_time <= trunc(SYSDATE) + 1
                  GROUP  BY t2.trans_org_no, t2.create_time
                  */
                  --新一代改造后，原统一支付改为从支付产品化出数
                  SELECT t1.trans_org_no AS org_no --交易机构号
      						,COUNT(DISTINCT t1.global_no) AS sum_count --业务笔数
      						,t1.create_time AS from_date
  								FROM ${msl_schema}.msl_ppps_t_txn_debit t1
 										WHERE t1.STATUS = 'SUCCESS' AND trunc(t1.create_time) = to_date('${batch_date}','yyyymmdd')
 										GROUP BY t1.trans_org_no,t1.create_time
									UNION ALL
									SELECT t2.trans_org_no AS org_no --交易机构号
      						,COUNT(DISTINCT global_no) AS sum_count --业务笔数
      						,t2.create_time AS from_date
  								FROM ${msl_schema}.msl_ppps_t_txn_credit t2
 										WHERE t2.status = 'SUCCESS' AND t2.trade_type = 'TRANSFER' AND trunc(t2.create_time) = to_date('${batch_date}','yyyymmdd')
 										GROUP BY t2.trans_org_no ,t2.create_time
 									) t1
      ON     t1.from_date >= to_date(tmp_run_log.sum_start_time
                                    ,'yyyymmdd hh24:mi:ss')
      AND    t1.from_date < to_date(tmp_run_log.sum_end_time
                                   ,'yyyymmdd hh24:mi:ss')
      WHERE  t1.from_date IS NOT NULL
      GROUP  BY (CASE
                    WHEN substr(t1.org_no
                               ,1
                               ,2) = '89'
                         OR t1.org_no = '800001' THEN
                     '800'
                    WHEN t1.org_no LIKE '%001'
                         AND substr(t1.org_no
                                   ,1
                                   ,2) != '89'
                         AND t1.org_no != '800001' THEN
                     substr(t1.org_no
                           ,1
                           ,3)
                    ELSE
                     t1.org_no
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
            ,decode(substr(sum_end_time
                          ,11
                          ,2) * 60 + substr(sum_end_time
                                           ,14
                                           ,2)
                   ,0
                   ,0
                   ,round((coalesce(t4.accu_index_value_d
                                   ,0) + CASE
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
                          END) /
                          (substr(sum_end_time
                                 ,11
                                 ,2) * 60 + substr(sum_end_time
                                                   ,14
                                                   ,2))
                         ,6)) AS index_value_avg --均值 
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
      ON     'WD040101' = t3.index_no_mcs
      LEFT   JOIN tmp_run_log t5
      ON     t5.index_no = t3.index_no
      LEFT   JOIN ${idl_schema}.mcyy_bu_analysis_realtime t4 --上一个频度表
      ON     t4.org_no = t1.org_no
      AND    t4.index_no = t3.index_no
      AND    t4.sum_time =
             to_date(t5.sum_end_time
                     ,'yyyymmdd hh24:mi:ss') - t5.frequency / (24 * 60))
    SELECT mcyy_bu_analysis_realtime_temp.etl_dt --数据日期
          ,mcyy_bu_analysis_realtime_temp.index_no --指标编码
          ,mcyy_bu_analysis_realtime_temp.index_name --指标名称
          ,mcyy_bu_analysis_realtime_temp.org_no --机构编码
          ,mcyy_bu_analysis_realtime_temp.org_name --机构名称
          ,mcyy_bu_analysis_realtime_temp.super_org_no --上级机构编码
          ,mcyy_bu_analysis_realtime_temp.sum_time --统计时点
          ,mcyy_bu_analysis_realtime_temp.index_value --指标时点值
          ,mcyy_bu_analysis_realtime_temp.accu_index_value_d --当日累计
          ,mcyy_bu_analysis_realtime_temp.index_value_avg --均值
          ,mcyy_bu_analysis_realtime_temp.unit --单位
          ,mcyy_bu_analysis_realtime_temp.frequency --频度
          ,mcyy_bu_analysis_realtime_temp.measure_no --度量编号
          ,mcyy_bu_analysis_realtime_temp.index_measure --度量名称
          ,to_timestamp('${batch_timestamp}'
                       ,'yyyy-mm-dd hh24:mi:ss.ff6') AS etl_timestamp --ETL处理时间戳
          ,mcyy_bu_analysis_realtime_temp.hours_total -- 小时合计
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
                  ,index_value_avg --均值
            FROM   temp_now_data) mcyy_bu_analysis_realtime_temp;

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
        AND    index_no ='WD040101';

COMMIT;

insert into ${idl_schema}.mcyy_bu_analysis_realtime
select * from ${idl_schema}.mbar_wd040101_${batch_date}_tm 
where sum_time = to_date(REC_RUN_LOGS.sum_end_time,'yyyymmdd hh24:mi:ss');

commit;
END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mcyy_bu_analysis_realtime_wd040101出错' || SQLERRM);
    
END;

/
--3.1 drop tmp tables
drop table ${idl_schema}.mbar_wd040101_${batch_date}_tm purge;
       

            
