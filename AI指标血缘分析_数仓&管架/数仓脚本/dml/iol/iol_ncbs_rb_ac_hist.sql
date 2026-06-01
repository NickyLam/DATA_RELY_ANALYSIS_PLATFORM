/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_ac_hist
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
drop table ${iol_schema}.ncbs_rb_ac_hist_ex purge;
alter table ${iol_schema}.ncbs_rb_ac_hist add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_ac_hist truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_ac_hist_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_ac_hist where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_ac_hist_ex(
    acct_seq_no -- 账户子账号
    ,acct_status -- 账户状态
    ,amt_type -- 金额类型
    ,base_acct_no -- 交易账号/卡号
    ,business_unit -- 账套
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,client_type -- 客户类型
    ,gl_code -- 科目代码
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,acct_desc -- 账户描述
    ,bank_seq_no -- 银行交易序号
    ,company -- 法人
    ,event_type -- 事件类型
    ,gl_posted_flag -- 过账标记
    ,lender -- 贷款人
    ,narrative -- 摘要
    ,reversal_flag -- 交易是否已冲正
    ,seq_no -- 序号
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,accounting_status -- 核算状态
    ,reversal_date -- 冲正日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,charge_pay_flag -- 收入支出标识
    ,channel_seq_no -- 全局流水号|渠道流水号
    ,old_branch -- 变更前机构
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    acct_seq_no -- 账户子账号
    ,acct_status -- 账户状态
    ,amt_type -- 金额类型
    ,base_acct_no -- 交易账号/卡号
    ,business_unit -- 账套
    ,ccy -- 币种
    ,client_no -- 客户编号
    ,client_type -- 客户类型
    ,gl_code -- 科目代码
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,tran_type -- 交易类型
    ,user_id -- 交易柜员编号
    ,acct_desc -- 账户描述
    ,bank_seq_no -- 银行交易序号
    ,company -- 法人
    ,event_type -- 事件类型
    ,gl_posted_flag -- 过账标记
    ,lender -- 贷款人
    ,narrative -- 摘要
    ,reversal_flag -- 交易是否已冲正
    ,seq_no -- 序号
    ,source_module -- 源模块
    ,source_type -- 渠道编号
    ,accounting_status -- 核算状态
    ,reversal_date -- 冲正日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,acct_branch -- 开户机构编号
    ,acct_ccy -- 账户币种
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,charge_pay_flag -- 收入支出标识
    ,channel_seq_no -- 全局流水号|渠道流水号
    ,old_branch -- 变更前机构
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_ac_hist
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_ac_hist exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_ac_hist_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_ac_hist to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_ac_hist_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_ac_hist',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);