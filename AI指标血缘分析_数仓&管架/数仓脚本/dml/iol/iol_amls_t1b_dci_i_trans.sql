/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amls_t1b_dci_i_trans
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amls_t1b_dci_i_trans_ex purge;
alter table ${iol_schema}.amls_t1b_dci_i_trans add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.amls_t1b_dci_i_trans;

-- 2.3 insert data to ex table
create table ${iol_schema}.amls_t1b_dci_i_trans_ex nologging
compress
as
select * from ${iol_schema}.amls_t1b_dci_i_trans where 0=1;

insert /*+ append */ into ${iol_schema}.amls_t1b_dci_i_trans_ex(
    cust_id -- 客户号
    ,trans_count -- 交易笔数（笔）
    ,trans_sum_amt -- 交易金额（元）
    ,count_c -- 转入笔数（笔）
    ,sum_c_amt -- 转入金额（元）
    ,count_d -- 转出笔数（笔）
    ,sum_d_amt -- 转出金额（元）
    ,c_opp_name_1 -- 转入交易对手1
    ,c_opp_name_amt_1 -- 转入对手1涉及金额
    ,c_opp_name_2 -- 转入交易对手2
    ,c_opp_name_amt_2 -- 转入对手2涉及金额
    ,c_opp_name_3 -- 转入交易对手3
    ,c_opp_name_amt_3 -- 转入交易对手3涉及金额
    ,c_opp_name_4 -- 转入交易对手4
    ,c_opp_name_amt_4 -- 转入对手4涉及金额
    ,c_opp_name_5 -- 转入交易对手5
    ,c_opp_name_amt_5 -- 转入对手5涉及金额
    ,d_opp_name_1 -- 转出交易对手1
    ,d_opp_name_amt_1 -- 转出对手1涉及金额
    ,d_opp_name_2 -- 转出交易对手2
    ,d_opp_name_amt_2 -- 转出对手2涉及金额
    ,d_opp_name_3 -- 转出交易对手3
    ,d_opp_name_amt_3 -- 转出交易对手3涉及金额
    ,d_opp_name_4 -- 转出交易对手4
    ,d_opp_name_amt_4 -- 转出对手4涉及金额
    ,d_opp_name_5 -- 转出交易对手5
    ,d_opp_name_amt_5 -- 转出对手5涉及金额
    ,begin_dt -- 开始日期
    ,end_dt -- 结束日期
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    cust_id -- 客户号
    ,trans_count -- 交易笔数（笔）
    ,trans_sum_amt -- 交易金额（元）
    ,count_c -- 转入笔数（笔）
    ,sum_c_amt -- 转入金额（元）
    ,count_d -- 转出笔数（笔）
    ,sum_d_amt -- 转出金额（元）
    ,c_opp_name_1 -- 转入交易对手1
    ,c_opp_name_amt_1 -- 转入对手1涉及金额
    ,c_opp_name_2 -- 转入交易对手2
    ,c_opp_name_amt_2 -- 转入对手2涉及金额
    ,c_opp_name_3 -- 转入交易对手3
    ,c_opp_name_amt_3 -- 转入交易对手3涉及金额
    ,c_opp_name_4 -- 转入交易对手4
    ,c_opp_name_amt_4 -- 转入对手4涉及金额
    ,c_opp_name_5 -- 转入交易对手5
    ,c_opp_name_amt_5 -- 转入对手5涉及金额
    ,d_opp_name_1 -- 转出交易对手1
    ,d_opp_name_amt_1 -- 转出对手1涉及金额
    ,d_opp_name_2 -- 转出交易对手2
    ,d_opp_name_amt_2 -- 转出对手2涉及金额
    ,d_opp_name_3 -- 转出交易对手3
    ,d_opp_name_amt_3 -- 转出交易对手3涉及金额
    ,d_opp_name_4 -- 转出交易对手4
    ,d_opp_name_amt_4 -- 转出对手4涉及金额
    ,d_opp_name_5 -- 转出交易对手5
    ,d_opp_name_amt_5 -- 转出对手5涉及金额
    ,begin_dt -- 开始日期
    ,end_dt -- 结束日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.amls_t1b_dci_i_trans
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.amls_t1b_dci_i_trans exchange partition p_${batch_date} with table ${iol_schema}.amls_t1b_dci_i_trans_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amls_t1b_dci_i_trans to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.amls_t1b_dci_i_trans_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amls_t1b_dci_i_trans',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);