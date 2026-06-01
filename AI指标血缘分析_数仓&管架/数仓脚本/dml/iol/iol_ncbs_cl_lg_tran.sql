/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_lg_tran
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
drop table ${iol_schema}.ncbs_cl_lg_tran_ex purge;
alter table ${iol_schema}.ncbs_cl_lg_tran add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ncbs_cl_lg_tran truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ncbs_cl_lg_tran_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_lg_tran where 0=1;

insert /*+ append */ into ${iol_schema}.ncbs_cl_lg_tran_ex(
    ccy -- 币种
    ,client_no -- 客户编号
    ,contract_no -- 合同编号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,acct_exec -- 银行客户经理编号
    ,company -- 法人
    ,compensate_status -- 保函赔付状态
    ,counter -- 序号
    ,event_type -- 事件类型
    ,gl_posted_flag -- 过账标记
    ,lg_flag -- 保函标记
    ,lg_no -- 保函编号
    ,lg_status -- 保函状态
    ,narrative -- 摘要
    ,res_seq_no -- 限制编号
    ,reversed_flag -- 是否撤销标志
    ,terminal_id -- 交易终端编号
    ,tran_no -- 抵质押品交易序号
    ,verify_flag -- 是否核实后禁止
    ,lg_end_date -- 保函终止日期
    ,lg_start_date -- 保函起始日期
    ,new_lg_end_date -- 新保函终止日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,advanced_acct_no -- 垫款贷款账号
    ,advanced_amt -- 保函垫款金额
    ,apply_client_no -- 申请者客户号
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,back_acct_ccy -- 备款账号币种
    ,back_acct_no -- 备款入账账号
    ,back_acct_seq_no -- 备款账户序列号
    ,back_prod_type -- 备款账号产品类型
    ,beneficiary_acct_no -- 保函受益人账号
    ,beneficiary_address -- 受益人住址
    ,beneficiary_document_id -- 受益人证件号
    ,beneficiary_document_type -- 受益人证件类型
    ,beneficiary_name -- 受益人名称
    ,bond_acct_ccy -- 保证金账户币种
    ,bond_acct_no -- 保证金账号
    ,bond_acct_seq_no -- 保证金账户序号
    ,bond_prod_type -- 保证金账户产品类型
    ,collat_value -- 押品账面价值
    ,contract_ccy -- 保函合同币种
    ,counterparty_branch -- 反担机构
    ,lg_amt -- 保函金额
    ,lg_branch -- 担保机构
    ,lg_compensate_amt -- 保函赔付金额
    ,mortgage_contract_no -- 抵押合同编号
    ,open_branch -- 开立机构
    ,orig_loan_amt -- 贷款签约合同金额
    ,pri_plty_abs -- 垫款固定罚息利率
    ,restraint_amt -- 贷款止付金额
    ,restraint_per -- 止付比例
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_no -- 人行清算账户
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_prod_type -- 结算账户产品类型
    ,tran_branch -- 核心交易机构编号
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    ccy -- 币种
    ,client_no -- 客户编号
    ,contract_no -- 合同编号
    ,internal_key -- 账户内部键值
    ,prod_type -- 产品编号
    ,profit_center -- 利润中心
    ,reference -- 交易参考号
    ,remark -- 备注
    ,user_id -- 交易柜员编号
    ,acct_exec -- 银行客户经理编号
    ,company -- 法人
    ,compensate_status -- 保函赔付状态
    ,counter -- 序号
    ,event_type -- 事件类型
    ,gl_posted_flag -- 过账标记
    ,lg_flag -- 保函标记
    ,lg_no -- 保函编号
    ,lg_status -- 保函状态
    ,narrative -- 摘要
    ,res_seq_no -- 限制编号
    ,reversed_flag -- 是否撤销标志
    ,terminal_id -- 交易终端编号
    ,tran_no -- 抵质押品交易序号
    ,verify_flag -- 是否核实后禁止
    ,lg_end_date -- 保函终止日期
    ,lg_start_date -- 保函起始日期
    ,new_lg_end_date -- 新保函终止日期
    ,tran_date -- 交易日期
    ,tran_timestamp -- 交易时间戳
    ,advanced_acct_no -- 垫款贷款账号
    ,advanced_amt -- 保函垫款金额
    ,apply_client_no -- 申请者客户号
    ,appr_user_id -- 复核柜员
    ,auth_user_id -- 授权柜员
    ,back_acct_ccy -- 备款账号币种
    ,back_acct_no -- 备款入账账号
    ,back_acct_seq_no -- 备款账户序列号
    ,back_prod_type -- 备款账号产品类型
    ,beneficiary_acct_no -- 保函受益人账号
    ,beneficiary_address -- 受益人住址
    ,beneficiary_document_id -- 受益人证件号
    ,beneficiary_document_type -- 受益人证件类型
    ,beneficiary_name -- 受益人名称
    ,bond_acct_ccy -- 保证金账户币种
    ,bond_acct_no -- 保证金账号
    ,bond_acct_seq_no -- 保证金账户序号
    ,bond_prod_type -- 保证金账户产品类型
    ,collat_value -- 押品账面价值
    ,contract_ccy -- 保函合同币种
    ,counterparty_branch -- 反担机构
    ,lg_amt -- 保函金额
    ,lg_branch -- 担保机构
    ,lg_compensate_amt -- 保函赔付金额
    ,mortgage_contract_no -- 抵押合同编号
    ,open_branch -- 开立机构
    ,orig_loan_amt -- 贷款签约合同金额
    ,pri_plty_abs -- 垫款固定罚息利率
    ,restraint_amt -- 贷款止付金额
    ,restraint_per -- 止付比例
    ,settle_acct_ccy -- 结算账户币种
    ,settle_acct_no -- 人行清算账户
    ,settle_acct_seq_no -- 结算账户序号
    ,settle_prod_type -- 结算账户产品类型
    ,tran_branch -- 核心交易机构编号
    ,reaccount_cd -- 对账代码
    ,bus_seq_no -- 业务流水号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ncbs_cl_lg_tran
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ncbs_cl_lg_tran exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_lg_tran_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_lg_tran to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ncbs_cl_lg_tran_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_lg_tran',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);