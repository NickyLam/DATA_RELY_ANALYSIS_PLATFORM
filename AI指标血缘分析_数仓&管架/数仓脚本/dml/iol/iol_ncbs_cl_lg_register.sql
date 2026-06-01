/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cl_lg_register
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_cl_lg_register_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cl_lg_register
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_lg_register_op purge;
drop table ${iol_schema}.ncbs_cl_lg_register_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_lg_register_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_lg_register where 0=1;

create table ${iol_schema}.ncbs_cl_lg_register_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cl_lg_register where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_lg_register_cl(
            ccy -- 币种
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,acct_exec -- 银行客户经理编号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,compensate_status -- 保函赔付状态
            ,lg_no -- 保函编号
            ,lg_status -- 保函状态
            ,terminal_id -- 交易终端编号
            ,last_change_date -- 最后修改日期
            ,lg_end_date -- 保函终止日期
            ,lg_start_date -- 保函起始日期
            ,new_lg_end_date -- 新保函终止日期
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
            ,collat_value -- 押品账面价值
            ,contract_ccy -- 保函合同币种
            ,counterparty_branch -- 反担机构
            ,lg_amt -- 保函金额
            ,lg_branch -- 担保机构
            ,lg_compensate_balance -- 剩余赔付金额
            ,mortgage_contract_no -- 抵押合同编号
            ,open_branch -- 开立机构
            ,org_restraint_amt -- 保函原始冻结金额
            ,orig_loan_amt -- 贷款签约合同金额
            ,pri_plty_abs -- 垫款固定罚息利率
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_no -- 人行清算账户
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_prod_type -- 结算账户产品类型
            ,tran_branch -- 核心交易机构编号
            ,beneficiary_is_inner -- 受益人账号是否本行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_lg_register_op(
            ccy -- 币种
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,acct_exec -- 银行客户经理编号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,compensate_status -- 保函赔付状态
            ,lg_no -- 保函编号
            ,lg_status -- 保函状态
            ,terminal_id -- 交易终端编号
            ,last_change_date -- 最后修改日期
            ,lg_end_date -- 保函终止日期
            ,lg_start_date -- 保函起始日期
            ,new_lg_end_date -- 新保函终止日期
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
            ,collat_value -- 押品账面价值
            ,contract_ccy -- 保函合同币种
            ,counterparty_branch -- 反担机构
            ,lg_amt -- 保函金额
            ,lg_branch -- 担保机构
            ,lg_compensate_balance -- 剩余赔付金额
            ,mortgage_contract_no -- 抵押合同编号
            ,open_branch -- 开立机构
            ,org_restraint_amt -- 保函原始冻结金额
            ,orig_loan_amt -- 贷款签约合同金额
            ,pri_plty_abs -- 垫款固定罚息利率
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_no -- 人行清算账户
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_prod_type -- 结算账户产品类型
            ,tran_branch -- 核心交易机构编号
            ,beneficiary_is_inner -- 受益人账号是否本行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.contract_no, o.contract_no) as contract_no -- 合同编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.profit_center, o.profit_center) as profit_center -- 利润中心
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.user_id, o.user_id) as user_id -- 交易柜员编号
    ,nvl(n.acct_exec, o.acct_exec) as acct_exec -- 银行客户经理编号
    ,nvl(n.cmisloan_no, o.cmisloan_no) as cmisloan_no -- 客户借据编号
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.compensate_status, o.compensate_status) as compensate_status -- 保函赔付状态
    ,nvl(n.lg_no, o.lg_no) as lg_no -- 保函编号
    ,nvl(n.lg_status, o.lg_status) as lg_status -- 保函状态
    ,nvl(n.terminal_id, o.terminal_id) as terminal_id -- 交易终端编号
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.lg_end_date, o.lg_end_date) as lg_end_date -- 保函终止日期
    ,nvl(n.lg_start_date, o.lg_start_date) as lg_start_date -- 保函起始日期
    ,nvl(n.new_lg_end_date, o.new_lg_end_date) as new_lg_end_date -- 新保函终止日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.advanced_acct_no, o.advanced_acct_no) as advanced_acct_no -- 垫款贷款账号
    ,nvl(n.advanced_amt, o.advanced_amt) as advanced_amt -- 保函垫款金额
    ,nvl(n.apply_client_no, o.apply_client_no) as apply_client_no -- 申请者客户号
    ,nvl(n.appr_user_id, o.appr_user_id) as appr_user_id -- 复核柜员
    ,nvl(n.auth_user_id, o.auth_user_id) as auth_user_id -- 授权柜员
    ,nvl(n.back_acct_ccy, o.back_acct_ccy) as back_acct_ccy -- 备款账号币种
    ,nvl(n.back_acct_no, o.back_acct_no) as back_acct_no -- 备款入账账号
    ,nvl(n.back_acct_seq_no, o.back_acct_seq_no) as back_acct_seq_no -- 备款账户序列号
    ,nvl(n.back_prod_type, o.back_prod_type) as back_prod_type -- 备款账号产品类型
    ,nvl(n.beneficiary_acct_no, o.beneficiary_acct_no) as beneficiary_acct_no -- 保函受益人账号
    ,nvl(n.beneficiary_address, o.beneficiary_address) as beneficiary_address -- 受益人住址
    ,nvl(n.beneficiary_document_id, o.beneficiary_document_id) as beneficiary_document_id -- 受益人证件号
    ,nvl(n.beneficiary_document_type, o.beneficiary_document_type) as beneficiary_document_type -- 受益人证件类型
    ,nvl(n.beneficiary_name, o.beneficiary_name) as beneficiary_name -- 受益人名称
    ,nvl(n.collat_value, o.collat_value) as collat_value -- 押品账面价值
    ,nvl(n.contract_ccy, o.contract_ccy) as contract_ccy -- 保函合同币种
    ,nvl(n.counterparty_branch, o.counterparty_branch) as counterparty_branch -- 反担机构
    ,nvl(n.lg_amt, o.lg_amt) as lg_amt -- 保函金额
    ,nvl(n.lg_branch, o.lg_branch) as lg_branch -- 担保机构
    ,nvl(n.lg_compensate_balance, o.lg_compensate_balance) as lg_compensate_balance -- 剩余赔付金额
    ,nvl(n.mortgage_contract_no, o.mortgage_contract_no) as mortgage_contract_no -- 抵押合同编号
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 开立机构
    ,nvl(n.org_restraint_amt, o.org_restraint_amt) as org_restraint_amt -- 保函原始冻结金额
    ,nvl(n.orig_loan_amt, o.orig_loan_amt) as orig_loan_amt -- 贷款签约合同金额
    ,nvl(n.pri_plty_abs, o.pri_plty_abs) as pri_plty_abs -- 垫款固定罚息利率
    ,nvl(n.settle_acct_ccy, o.settle_acct_ccy) as settle_acct_ccy -- 结算账户币种
    ,nvl(n.settle_acct_no, o.settle_acct_no) as settle_acct_no -- 人行清算账户
    ,nvl(n.settle_acct_seq_no, o.settle_acct_seq_no) as settle_acct_seq_no -- 结算账户序号
    ,nvl(n.settle_prod_type, o.settle_prod_type) as settle_prod_type -- 结算账户产品类型
    ,nvl(n.tran_branch, o.tran_branch) as tran_branch -- 核心交易机构编号
    ,nvl(n.beneficiary_is_inner, o.beneficiary_is_inner) as beneficiary_is_inner -- 受益人账号是否本行
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cl_lg_register_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cl_lg_register where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.ccy <> n.ccy
        or o.client_no <> n.client_no
        or o.contract_no <> n.contract_no
        or o.prod_type <> n.prod_type
        or o.profit_center <> n.profit_center
        or o.remark <> n.remark
        or o.user_id <> n.user_id
        or o.acct_exec <> n.acct_exec
        or o.cmisloan_no <> n.cmisloan_no
        or o.company <> n.company
        or o.compensate_status <> n.compensate_status
        or o.lg_no <> n.lg_no
        or o.lg_status <> n.lg_status
        or o.terminal_id <> n.terminal_id
        or o.last_change_date <> n.last_change_date
        or o.lg_end_date <> n.lg_end_date
        or o.lg_start_date <> n.lg_start_date
        or o.new_lg_end_date <> n.new_lg_end_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.advanced_acct_no <> n.advanced_acct_no
        or o.advanced_amt <> n.advanced_amt
        or o.apply_client_no <> n.apply_client_no
        or o.appr_user_id <> n.appr_user_id
        or o.auth_user_id <> n.auth_user_id
        or o.back_acct_ccy <> n.back_acct_ccy
        or o.back_acct_no <> n.back_acct_no
        or o.back_acct_seq_no <> n.back_acct_seq_no
        or o.back_prod_type <> n.back_prod_type
        or o.beneficiary_acct_no <> n.beneficiary_acct_no
        or o.beneficiary_address <> n.beneficiary_address
        or o.beneficiary_document_id <> n.beneficiary_document_id
        or o.beneficiary_document_type <> n.beneficiary_document_type
        or o.beneficiary_name <> n.beneficiary_name
        or o.collat_value <> n.collat_value
        or o.contract_ccy <> n.contract_ccy
        or o.counterparty_branch <> n.counterparty_branch
        or o.lg_amt <> n.lg_amt
        or o.lg_branch <> n.lg_branch
        or o.lg_compensate_balance <> n.lg_compensate_balance
        or o.mortgage_contract_no <> n.mortgage_contract_no
        or o.open_branch <> n.open_branch
        or o.org_restraint_amt <> n.org_restraint_amt
        or o.orig_loan_amt <> n.orig_loan_amt
        or o.pri_plty_abs <> n.pri_plty_abs
        or o.settle_acct_ccy <> n.settle_acct_ccy
        or o.settle_acct_no <> n.settle_acct_no
        or o.settle_acct_seq_no <> n.settle_acct_seq_no
        or o.settle_prod_type <> n.settle_prod_type
        or o.tran_branch <> n.tran_branch
        or o.beneficiary_is_inner <> n.beneficiary_is_inner
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cl_lg_register_cl(
            ccy -- 币种
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,acct_exec -- 银行客户经理编号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,compensate_status -- 保函赔付状态
            ,lg_no -- 保函编号
            ,lg_status -- 保函状态
            ,terminal_id -- 交易终端编号
            ,last_change_date -- 最后修改日期
            ,lg_end_date -- 保函终止日期
            ,lg_start_date -- 保函起始日期
            ,new_lg_end_date -- 新保函终止日期
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
            ,collat_value -- 押品账面价值
            ,contract_ccy -- 保函合同币种
            ,counterparty_branch -- 反担机构
            ,lg_amt -- 保函金额
            ,lg_branch -- 担保机构
            ,lg_compensate_balance -- 剩余赔付金额
            ,mortgage_contract_no -- 抵押合同编号
            ,open_branch -- 开立机构
            ,org_restraint_amt -- 保函原始冻结金额
            ,orig_loan_amt -- 贷款签约合同金额
            ,pri_plty_abs -- 垫款固定罚息利率
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_no -- 人行清算账户
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_prod_type -- 结算账户产品类型
            ,tran_branch -- 核心交易机构编号
            ,beneficiary_is_inner -- 受益人账号是否本行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cl_lg_register_op(
            ccy -- 币种
            ,client_no -- 客户编号
            ,contract_no -- 合同编号
            ,internal_key -- 账户内部键值
            ,prod_type -- 产品编号
            ,profit_center -- 利润中心
            ,remark -- 备注
            ,user_id -- 交易柜员编号
            ,acct_exec -- 银行客户经理编号
            ,cmisloan_no -- 客户借据编号
            ,company -- 法人
            ,compensate_status -- 保函赔付状态
            ,lg_no -- 保函编号
            ,lg_status -- 保函状态
            ,terminal_id -- 交易终端编号
            ,last_change_date -- 最后修改日期
            ,lg_end_date -- 保函终止日期
            ,lg_start_date -- 保函起始日期
            ,new_lg_end_date -- 新保函终止日期
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
            ,collat_value -- 押品账面价值
            ,contract_ccy -- 保函合同币种
            ,counterparty_branch -- 反担机构
            ,lg_amt -- 保函金额
            ,lg_branch -- 担保机构
            ,lg_compensate_balance -- 剩余赔付金额
            ,mortgage_contract_no -- 抵押合同编号
            ,open_branch -- 开立机构
            ,org_restraint_amt -- 保函原始冻结金额
            ,orig_loan_amt -- 贷款签约合同金额
            ,pri_plty_abs -- 垫款固定罚息利率
            ,settle_acct_ccy -- 结算账户币种
            ,settle_acct_no -- 人行清算账户
            ,settle_acct_seq_no -- 结算账户序号
            ,settle_prod_type -- 结算账户产品类型
            ,tran_branch -- 核心交易机构编号
            ,beneficiary_is_inner -- 受益人账号是否本行
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.client_no -- 客户编号
    ,o.contract_no -- 合同编号
    ,o.internal_key -- 账户内部键值
    ,o.prod_type -- 产品编号
    ,o.profit_center -- 利润中心
    ,o.remark -- 备注
    ,o.user_id -- 交易柜员编号
    ,o.acct_exec -- 银行客户经理编号
    ,o.cmisloan_no -- 客户借据编号
    ,o.company -- 法人
    ,o.compensate_status -- 保函赔付状态
    ,o.lg_no -- 保函编号
    ,o.lg_status -- 保函状态
    ,o.terminal_id -- 交易终端编号
    ,o.last_change_date -- 最后修改日期
    ,o.lg_end_date -- 保函终止日期
    ,o.lg_start_date -- 保函起始日期
    ,o.new_lg_end_date -- 新保函终止日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.advanced_acct_no -- 垫款贷款账号
    ,o.advanced_amt -- 保函垫款金额
    ,o.apply_client_no -- 申请者客户号
    ,o.appr_user_id -- 复核柜员
    ,o.auth_user_id -- 授权柜员
    ,o.back_acct_ccy -- 备款账号币种
    ,o.back_acct_no -- 备款入账账号
    ,o.back_acct_seq_no -- 备款账户序列号
    ,o.back_prod_type -- 备款账号产品类型
    ,o.beneficiary_acct_no -- 保函受益人账号
    ,o.beneficiary_address -- 受益人住址
    ,o.beneficiary_document_id -- 受益人证件号
    ,o.beneficiary_document_type -- 受益人证件类型
    ,o.beneficiary_name -- 受益人名称
    ,o.collat_value -- 押品账面价值
    ,o.contract_ccy -- 保函合同币种
    ,o.counterparty_branch -- 反担机构
    ,o.lg_amt -- 保函金额
    ,o.lg_branch -- 担保机构
    ,o.lg_compensate_balance -- 剩余赔付金额
    ,o.mortgage_contract_no -- 抵押合同编号
    ,o.open_branch -- 开立机构
    ,o.org_restraint_amt -- 保函原始冻结金额
    ,o.orig_loan_amt -- 贷款签约合同金额
    ,o.pri_plty_abs -- 垫款固定罚息利率
    ,o.settle_acct_ccy -- 结算账户币种
    ,o.settle_acct_no -- 人行清算账户
    ,o.settle_acct_seq_no -- 结算账户序号
    ,o.settle_prod_type -- 结算账户产品类型
    ,o.tran_branch -- 核心交易机构编号
    ,o.beneficiary_is_inner -- 受益人账号是否本行
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_cl_lg_register_bk o
    left join ${iol_schema}.ncbs_cl_lg_register_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cl_lg_register_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cl_lg_register;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cl_lg_register') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cl_lg_register drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cl_lg_register add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cl_lg_register exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cl_lg_register_cl;
alter table ${iol_schema}.ncbs_cl_lg_register exchange partition p_20991231 with table ${iol_schema}.ncbs_cl_lg_register_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cl_lg_register to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cl_lg_register_op purge;
drop table ${iol_schema}.ncbs_cl_lg_register_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cl_lg_register_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cl_lg_register',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
