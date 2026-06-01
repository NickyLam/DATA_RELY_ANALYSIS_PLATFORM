/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rsts_src_dw_agt_loan_actl_repay
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
drop table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay_ex purge;
alter table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rsts_src_dw_agt_loan_actl_repay where 0=1;

insert /*+ append */ into ${iol_schema}.rsts_src_dw_agt_loan_actl_repay_ex(
    repay_seq_num -- 还款流水号
    ,loan_acct_id -- 贷款账户编号
    ,curr_term -- 当前期数
    ,repay_dt -- 还款日期
    ,etl_dt_ora -- 数据日期
    ,blng_pty_id -- 所属客户编号
    ,ccy_cd -- 币种代码
    ,curr_repay_prcp -- 当期还款本金
    ,curr_repay_int -- 当期还款利息
    ,curr_repay_pnlt -- 当期还款罚息
    ,curr_repay_compd_int -- 当期还款复利
    ,curr_repay_cost -- 当期还款费用
    ,curr_bal -- 当前余额
    ,adv_repay_flg -- 提前还款标志
    ,ovdue_repay_flg -- 逾期还款标志
    ,comp_repay_flg -- 代偿还款标志
    ,repay_acct_id -- 还款账户编号
    ,repay_chn_cd -- 还款渠道代码
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    repay_seq_num -- 还款流水号
    ,loan_acct_id -- 贷款账户编号
    ,curr_term -- 当前期数
    ,repay_dt -- 还款日期
    ,etl_dt_ora -- 数据日期
    ,blng_pty_id -- 所属客户编号
    ,ccy_cd -- 币种代码
    ,curr_repay_prcp -- 当期还款本金
    ,curr_repay_int -- 当期还款利息
    ,curr_repay_pnlt -- 当期还款罚息
    ,curr_repay_compd_int -- 当期还款复利
    ,curr_repay_cost -- 当期还款费用
    ,curr_bal -- 当前余额
    ,adv_repay_flg -- 提前还款标志
    ,ovdue_repay_flg -- 逾期还款标志
    ,comp_repay_flg -- 代偿还款标志
    ,repay_acct_id -- 还款账户编号
    ,repay_chn_cd -- 还款渠道代码
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rsts_src_dw_agt_loan_actl_repay
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay exchange partition p_${batch_date} with table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rsts_src_dw_agt_loan_actl_repay to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rsts_src_dw_agt_loan_actl_repay_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rsts_src_dw_agt_loan_actl_repay',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);