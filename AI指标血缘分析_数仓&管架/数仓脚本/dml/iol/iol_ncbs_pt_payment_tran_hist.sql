/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_pt_payment_tran_hist
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
drop table ${iol_schema}.ncbs_pt_payment_tran_hist_ex purge;
alter table ${iol_schema}.ncbs_pt_payment_tran_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_pt_payment_tran_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_pt_payment_tran_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_pt_payment_tran_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_pt_payment_tran_hist_ex(
    acct_name -- 账户名称
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,acct_payment_status -- 账户支付状态
    ,acgl_flag -- 记账种类
    ,bill_no -- 票据号码
    ,bill_type -- 票据种类
    ,channel_seq_no -- 全局流水号
    ,channel_sub_seq_no -- 渠道子流水号
    ,collate_batch_no -- 对账批号
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,direction -- 来往账类型
    ,entry_success_flag -- 入账成功标识
    ,hang_status -- 挂账状态
    ,pt_operate_type -- 支付操作类型
    ,res_seq_no -- 限制编号
    ,ret_code -- 状态码
    ,ret_msg -- 服务状态描述
    ,seq_no -- 序号
    ,settle_no -- 结算编号
    ,settle_step -- 记账步骤
    ,trusted_pay_no -- 受托支付编号
    ,channel -- 渠道
    ,collate_date -- 对账日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,contra_acct_name -- 对手账号名称
    ,contra_base_acct_no -- 交易对手账号
    ,fee_amt -- 费用金额
    ,orig_reference -- 源交易参考号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_name -- 账户名称
    ,base_acct_no -- 交易账号/卡号
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,doc_type -- 凭证类型
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,voucher_no -- 凭证号码
    ,acct_payment_status -- 账户支付状态
    ,acgl_flag -- 记账种类
    ,bill_no -- 票据号码
    ,bill_type -- 票据种类
    ,channel_seq_no -- 全局流水号
    ,channel_sub_seq_no -- 渠道子流水号
    ,collate_batch_no -- 对账批号
    ,company -- 法人
    ,cr_dr_ind -- 借贷标志
    ,direction -- 来往账类型
    ,entry_success_flag -- 入账成功标识
    ,hang_status -- 挂账状态
    ,pt_operate_type -- 支付操作类型
    ,res_seq_no -- 限制编号
    ,ret_code -- 状态码
    ,ret_msg -- 服务状态描述
    ,seq_no -- 序号
    ,settle_no -- 结算编号
    ,settle_step -- 记账步骤
    ,trusted_pay_no -- 受托支付编号
    ,channel -- 渠道
    ,collate_date -- 对账日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,contra_acct_name -- 对手账号名称
    ,contra_base_acct_no -- 交易对手账号
    ,fee_amt -- 费用金额
    ,orig_reference -- 源交易参考号
    ,oth_bank_code -- 对方银行代码
    ,oth_bank_name -- 对方银行名称
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_pt_payment_tran_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_pt_payment_tran_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_pt_payment_tran_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_pt_payment_tran_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_pt_payment_tran_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_pt_payment_tran_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);