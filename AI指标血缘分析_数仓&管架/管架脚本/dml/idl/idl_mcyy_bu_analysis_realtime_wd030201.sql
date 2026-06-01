/*
Purpose:    个人开户数D层-业务分析实时表(WD030201):数据来源于核心系统（CBSS）,包括电子账户（IATS）
Author:     Sunline/郑沛隆
Usage:      由ETL调度配置，每隔5分钟从${idl_schema}.mcyy_realtime_run_log获取时间点对业务表进行关联准实时统计
Createdate: 20210112
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
drop table ${idl_schema}.mbar_wd030201_${batch_date}_tm purge ;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.mbar_wd030201_${batch_date}_tm
compress ${option_switch} for query high
as
select
    *
from ${idl_schema}.mcyy_bu_analysis_realtime
where 0=1;

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
      to_char(start_time,'HH24MM') >= 5) --补跑批次
AND    to_date(sum_end_time,'yyyy-mm-dd hh24:mi:ss') <= SYSDATE
AND    index_no ='WD030201'
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
 AND    index_no ='WD030201';
 
COMMIT;

-- 2.1 insert into realtime table

INSERT /*+ append */
INTO ${idl_schema}.mbar_wd030201_${batch_date}_tm
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
                       AND    index_no = 'WD030201'
                       AND    run_sts = 1)),
    tmp_initza_data AS
    --1、89开头的虚拟机构，数据归纳到总行
    --2、800001营运管理部，数据归到总行
    --3、xx分行营运管理部，数据归到分行    
     (SELECT SUM(t1.index_value) AS account_sum
             
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
      LEFT   JOIN(
      --个人实时开户，统计口径：I、II、III类户（核心业务系统、个人电子账户系统（或企业级综合账户体系）），只统计新开立账户数（换卡的不算），定期只统计开立定期母户（开立定期子户不算）
      --不含个人借记卡下定期户、大额存单
      select t2.acct_branch as org_no
      ,count(distinct t2.base_acct_no) as index_value
      ,to_date(substr(t1.tran_timestamp, 1, 19), 'yyyy-mm-dd hh24:mi:ss') as from_date
  from msl_ncbs_rb_open_close_reg t1 --核心开销户明细
  left join msl_ncbs_rb_acct t2 --核心账户表
on t1.base_acct_no = t2.base_acct_no
   and t1.tran_date = t2.orig_acct_open_date
 where t1.tran_date = to_date('${batch_date}', 'yyyymmdd')
       and t1.reg_type = '1' --开户
       and t2.acct_ccy = 'CNY'
       and t2.individual_flag = 'Y' --对私
       and not exists
 (select 1
          from msl_ncbs_cd_card_chg t3
         where t3.tran_date = to_date('${batch_date}', 'yyyymmdd')
               and t3.new_card_no = t1.card_no)
       and ((t2.acct_nature = '21001' and t2.prod_type = '101010100001' and t2.reason_code not like '2002%' and t2.acct_class = '1') or
       (t2.acct_nature = '21001' and t2.acct_class in ('2', '3')) or (t2.acct_seq_no = '1' and (t2.prod_type = '101020100002' or t2.prod_type = '101020100009' or
       t2.prod_type = '101020200001') and t2.acct_type = 'T' and t2.reason_code not like '2002%'))
 group by t2.acct_branch
         ,to_date(substr(t1.tran_timestamp, 1, 19), 'yyyy-mm-dd hh24:mi:ss')) t1
  ON     t1.from_date >= to_date(tmp_run_log.sum_start_time
                                    ,'yyyymmdd hh24:mi:ss')
      AND    t1.from_date < to_date(tmp_run_log.sum_end_time
                                   ,'yyyymmdd hh24:mi:ss')
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
      ON     'WD030201' = t3.index_no_mcs
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
                  ,accu_index_value_d 
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
        AND    index_no ='WD030201';

COMMIT;

insert into ${idl_schema}.mcyy_bu_analysis_realtime
select * from ${idl_schema}.mbar_wd030201_${batch_date}_tm 
where sum_time = to_date(REC_RUN_LOGS.sum_end_time,'yyyymmdd hh24:mi:ss');

commit;
END LOOP;        
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        dbms_output.put_line('循环执行实时脚本idl_mcyy_bu_analysis_realtime_wd030201出错' || SQLERRM);
    
END;

/
--3.1 drop tmp tables
drop table ${idl_schema}.mbar_wd030201_${batch_date}_tm purge;
       