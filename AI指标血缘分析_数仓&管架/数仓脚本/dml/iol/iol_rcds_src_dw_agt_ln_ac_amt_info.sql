/*
Purpose:    偏源模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rcds_src_dw_agt_ln_ac_amt_info
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
drop table ${iol_schema}.rcds_src_dw_agt_ln_ac_amt_info_ex purge;
alter table ${iol_schema}.rcds_src_dw_agt_ln_ac_amt_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table
whenever sqlerror exit sql.sqlcode;
truncate table ${iol_schema}.rcds_src_dw_agt_ln_ac_amt_info;

-- 2.3 insert data to ex table
create table ${iol_schema}.rcds_src_dw_agt_ln_ac_amt_info_ex nologging
compress
as
select * from ${iol_schema}.rcds_src_dw_agt_ln_ac_amt_info where 0=1;

insert /*+ append */ into ${iol_schema}.rcds_src_dw_agt_ln_ac_amt_info_ex(
    loan_acct_id -- 贷款账户编号
    ,etl_dt_ora -- 数据日期
    ,loan_total_term -- 贷款总期数
    ,loan_new_term -- 贷款目前期数
    ,ccy_cd -- 币种代码
    ,loan_total_bal -- 贷款余额
    ,loan_bal -- 正常本金余额
    ,day_accr_int -- 日应计利息
    ,paid_prcp -- 已偿还本金
    ,paid_int -- 已偿还利息
    ,paid_pnlt -- 已偿还罚息
    ,paid_compd_int -- 已偿还复利
    ,paid_cost -- 已偿还费用
    ,aggr_rcvable_int_amt -- 累计应收未收利息金额
    ,int_on_bs_bal -- 表内欠息余额
    ,int_off_bs_bal -- 表外欠息余额
    ,on_int -- 表内利息
    ,off_int -- 表外利息
    ,provn -- 准备金
    ,prev_adj_int_dt -- 上次调息日期
    ,next_adj_int_dt -- 下次调息日期
    ,next_stl_dt -- 下次结息日期
    ,actl_write_off_prcp -- 实核本金
    ,actl_write_off_int -- 实核利息
    ,rcva_acr_intr -- 应收应计利息
    ,rcva_owe_int -- 应收欠息
    ,rcva_accr_pnlt -- 应收应计罚息
    ,rcva_pnlt -- 应收罚息
    ,accr_cmpd_intr -- 应计复息
    ,rcva_cmpd_intr -- 应收复息
    ,dun_acr_intr -- 催收应计利息
    ,dun_owe_int -- 催收欠息
    ,dun_accr_pnlt -- 催收应计罚息
    ,dun_pnlt -- 催收罚息
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    loan_acct_id -- 贷款账户编号
    ,etl_dt_ora -- 数据日期
    ,loan_total_term -- 贷款总期数
    ,loan_new_term -- 贷款目前期数
    ,ccy_cd -- 币种代码
    ,loan_total_bal -- 贷款余额
    ,loan_bal -- 正常本金余额
    ,day_accr_int -- 日应计利息
    ,paid_prcp -- 已偿还本金
    ,paid_int -- 已偿还利息
    ,paid_pnlt -- 已偿还罚息
    ,paid_compd_int -- 已偿还复利
    ,paid_cost -- 已偿还费用
    ,aggr_rcvable_int_amt -- 累计应收未收利息金额
    ,int_on_bs_bal -- 表内欠息余额
    ,int_off_bs_bal -- 表外欠息余额
    ,on_int -- 表内利息
    ,off_int -- 表外利息
    ,provn -- 准备金
    ,prev_adj_int_dt -- 上次调息日期
    ,next_adj_int_dt -- 下次调息日期
    ,next_stl_dt -- 下次结息日期
    ,actl_write_off_prcp -- 实核本金
    ,actl_write_off_int -- 实核利息
    ,rcva_acr_intr -- 应收应计利息
    ,rcva_owe_int -- 应收欠息
    ,rcva_accr_pnlt -- 应收应计罚息
    ,rcva_pnlt -- 应收罚息
    ,accr_cmpd_intr -- 应计复息
    ,rcva_cmpd_intr -- 应收复息
    ,dun_acr_intr -- 催收应计利息
    ,dun_owe_int -- 催收欠息
    ,dun_accr_pnlt -- 催收应计罚息
    ,dun_pnlt -- 催收罚息
    ,data_src_cd -- 数据来源代码
    ,del_flg -- 删除标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.rcds_src_dw_agt_ln_ac_amt_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.rcds_src_dw_agt_ln_ac_amt_info exchange partition p_${batch_date} with table ${iol_schema}.rcds_src_dw_agt_ln_ac_amt_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rcds_src_dw_agt_ln_ac_amt_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.rcds_src_dw_agt_ln_ac_amt_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rcds_src_dw_agt_ln_ac_amt_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);