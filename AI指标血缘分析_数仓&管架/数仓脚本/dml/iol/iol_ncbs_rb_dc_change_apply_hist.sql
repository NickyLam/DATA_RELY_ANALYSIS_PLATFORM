/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_dc_change_apply_hist
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
drop table ${iol_schema}.ncbs_rb_dc_change_apply_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_dc_change_apply_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_dc_change_apply_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_dc_change_apply_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_dc_change_apply_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_dc_change_apply_hist_ex(
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,res_seq_no -- 限制编号
    ,stage_code -- 期次代码
    ,last_change_date -- 最后修改日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,dep_keep_days -- 存款天数
    ,int_rem_days -- 计息剩余天数
    ,trf_total_settle_amt -- 转让总对价
    ,trf_end_date -- 转让到期日
    ,direction_trf_flag -- 是否定期转让
    ,order_start_date -- 挂单起始日期
    ,trf_in_fee_amt -- 转入费用
    ,order_end_date -- 挂单结束日期
    ,trf_pri_amt -- 转让本金金额
    ,trf_command -- 转让口令
    ,trf_rate -- 转让利率
    ,trf_type -- 转让类型
    ,trf_status -- 转让状态
    ,beneficiary_client_no -- 受益人客户号
    ,trf_no -- 转让号
    ,trf_date -- 转让日期
    ,beneficiary_profit_rate -- 受让人收益率
    ,trf_out_fee_amt -- 转出费用
    ,prod_type -- 产品编号|产品编号
    ,settle_acct_seq_no -- 结算账户序号|结算账户序号
    ,settle_base_acct_no -- 结算账号|结算账号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,base_acct_no -- 交易账号/卡号
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,internal_key -- 账户内部键值
    ,user_id -- 交易柜员编号
    ,company -- 法人
    ,res_seq_no -- 限制编号
    ,stage_code -- 期次代码
    ,last_change_date -- 最后修改日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,dep_keep_days -- 存款天数
    ,int_rem_days -- 计息剩余天数
    ,trf_total_settle_amt -- 转让总对价
    ,trf_end_date -- 转让到期日
    ,direction_trf_flag -- 是否定期转让
    ,order_start_date -- 挂单起始日期
    ,trf_in_fee_amt -- 转入费用
    ,order_end_date -- 挂单结束日期
    ,trf_pri_amt -- 转让本金金额
    ,trf_command -- 转让口令
    ,trf_rate -- 转让利率
    ,trf_type -- 转让类型
    ,trf_status -- 转让状态
    ,beneficiary_client_no -- 受益人客户号
    ,trf_no -- 转让号
    ,trf_date -- 转让日期
    ,beneficiary_profit_rate -- 受让人收益率
    ,trf_out_fee_amt -- 转出费用
    ,prod_type -- 产品编号|产品编号
    ,settle_acct_seq_no -- 结算账户序号|结算账户序号
    ,settle_base_acct_no -- 结算账号|结算账号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_dc_change_apply_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_dc_change_apply_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_dc_change_apply_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_dc_change_apply_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_dc_change_apply_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_dc_change_apply_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);