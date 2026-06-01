/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_cfck_info
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
drop table ${iol_schema}.ncbs_rb_cfck_info_ex purge;
alter table ${iol_schema}.ncbs_rb_cfck_info add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_rb_cfck_info truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_rb_cfck_info_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_cfck_info where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_rb_cfck_info_ex(
    base_acct_no -- 交易账号/卡号
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,reference -- 交易参考号
    ,bank_flag -- 是否为银行
    ,company -- 法人
    ,imp_seq_no -- 强制扣划序列号
    ,int_flag -- 是否扣划利息标志
    ,law_no -- 法律文书号
    ,narrative -- 摘要
    ,remain_amt_status -- 剩余金额处理状态
    ,source_type -- 渠道编号
    ,imp_date -- 扣划日期
    ,imp_time -- 扣划时间
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,actual_amt -- 实际金额
    ,cr_acct_name -- 贷方户名
    ,cr_acct_type -- 收款账户类型（行内账户）
    ,cr_bank_code -- 行号（他行账户）
    ,cr_bank_name -- 行名（他行账户）
    ,cr_base_acct_no -- 贷方账号
    ,imp_acct_no -- 扣划账号
    ,imp_acct_type -- 扣划账户类型
    ,imp_ccy -- 扣划币种
    ,imp_int -- 扣划金额的提前支取利息(预留)
    ,imp_internal_key -- 扣划账户主键
    ,imp_rate -- 扣划金额的提前支取利率(预留)
    ,impound_amt -- 扣划金额
    ,int_amt -- 利息金额
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,tran_internal_key -- 客户活期结算账户主键
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    base_acct_no -- 交易账号/卡号
    ,client_name -- 客户名称
    ,client_no -- 客户编号
    ,reference -- 交易参考号
    ,bank_flag -- 是否为银行
    ,company -- 法人
    ,imp_seq_no -- 强制扣划序列号
    ,int_flag -- 是否扣划利息标志
    ,law_no -- 法律文书号
    ,narrative -- 摘要
    ,remain_amt_status -- 剩余金额处理状态
    ,source_type -- 渠道编号
    ,imp_date -- 扣划日期
    ,imp_time -- 扣划时间
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,actual_amt -- 实际金额
    ,cr_acct_name -- 贷方户名
    ,cr_acct_type -- 收款账户类型（行内账户）
    ,cr_bank_code -- 行号（他行账户）
    ,cr_bank_name -- 行名（他行账户）
    ,cr_base_acct_no -- 贷方账号
    ,imp_acct_no -- 扣划账号
    ,imp_acct_type -- 扣划账户类型
    ,imp_ccy -- 扣划币种
    ,imp_int -- 扣划金额的提前支取利息(预留)
    ,imp_internal_key -- 扣划账户主键
    ,imp_rate -- 扣划金额的提前支取利率(预留)
    ,impound_amt -- 扣划金额
    ,int_amt -- 利息金额
    ,tran_amt -- 交易金额
    ,tran_branch -- 核心交易机构编号
    ,tran_internal_key -- 客户活期结算账户主键
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_rb_cfck_info
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_rb_cfck_info exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_cfck_info_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_cfck_info to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_rb_cfck_info_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_cfck_info',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);