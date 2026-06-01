/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbprdbankacc
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
create table ${iol_schema}.ifms_tbprdbankacc_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbprdbankacc
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbprdbankacc_op purge;
drop table ${iol_schema}.ifms_tbprdbankacc_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbprdbankacc_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbprdbankacc where 0=1;

create table ${iol_schema}.ifms_tbprdbankacc_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbprdbankacc where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbprdbankacc_cl(
            ta_code -- TA代码
            ,prd_code -- 产品代码
            ,bank_no -- 银行代码:租户编号(多租户模式用)
            ,open_bank_ver -- 验资户开户行
            ,open_bank_up -- 注册登记账户开户行
            ,bank_acc_up -- 上账银行账号
            ,bank_acc_down -- 下账银行账号
            ,bank_acc_ver -- 募集验资账户
            ,asso_code -- 关联代码:基金公司产品代码
            ,square_way -- 结算方式:[K_JSFS] 全额或净额
            ,bank_name -- 银行名称:托管银行名称
            ,branch_name -- 分支机构名称:托管机构名称
            ,prd_name -- 产品名称:外部产品名称
            ,bank_acc_up_name -- 上账银行账号名称
            ,bank_acc_down_name -- 下账银行账号名称
            ,bank_acc_ver_name -- 募集验资户账户名称
            ,reserve1 -- 保留字段1:募集验资账户支付系统编号(募集期)
            ,reserve2 -- 保留字段2:注册登记账户支付系统编号(申购期)
            ,debit_account -- 认申购账号
            ,crebit_account -- 赎回账号
            ,client_type -- 客户类型:K_KHLX 0-机构 1-个人
            ,realred_crebit_account -- 实时赎回垫资账号
            ,income_account -- 收益兑付账号
            ,pay_way -- 支付方式
            ,charge_account -- 手续费分配账号
            ,open_bank_down -- 兑付资金账户开户行
            ,open_bank_ver_name -- 验资户开户行名称
            ,open_bank_up_name -- 注册登记账户开户行名称
            ,open_bank_down_name -- 兑付资金账户开户行名称
            ,realred_crebit_account_name -- 实时赎回垫资账号名称:实时赎回垫资账号名称
            ,debit_account_name -- 认申购账号名称:认申购账号名称
            ,crebit_account_name -- 赎回账号名称:赎回账号名称
            ,income_account_name -- 收益兑付账号名称:收益兑付账号名称
            ,off_bal_account -- 表外账户:表外账户,记录表外账
            ,charge_account_name -- 手续费分配账号名称
            ,transfer_fee_acc -- 转让手续费账号:转让业务如收取转让手续时，需要将转让手续费转入此账号
            ,transfer_fee_acc_name -- 转让手续费账号名称
            ,service_fee_acc -- 服务费账号
            ,service_fee_acc_name -- 服务费账号名称
            ,out_bank_no -- 外部银行代码:归集账号的银行编号
            ,out_bank_name -- 转出/外部银行名称:归集账号的银行名称
            ,spno -- 联行号:归集账号的联行号
            ,debit_account_in_old -- 直销银行理财认申购归集账号(开立在传统核心系统)
            ,debit_account_in_new -- 直销银行理财认申购归集账号(开立在直销银行系统
            ,crebit_account_in_old -- 直销银行赎回账号(开立在传统核心系统)
            ,crebit_account_in_new -- 直销银行赎回账号(开立在直销银行系统)
            ,crebit_middle_account -- 赎回过渡账户
            ,crebit_middle_account_name -- 赎回过渡账户名称
            ,debit_middle_account -- 认申购过渡账号
            ,debit_middle_account_name -- 认申购过渡账户名称
            ,digital_wallet_bank -- 数字钱包开立机构
            ,advance_account -- 垫资账户
            ,advance_account_name -- 垫资账户名称
            ,draw_interacc -- 垫资中间账号
            ,draw_interacc_name -- 垫资中间户账户名称
            ,draw_interacc_bank_name -- 垫资中间户开户行名称
            ,draw_interacc_bank_organ -- 垫资中间户开户行机构编号
            ,failed_payment_account -- 入账失败挂账账户
            ,issuer_clear_bank_name -- 发行机构清算行名
            ,issuer_clear_account -- 发行机构认申购清算账号
            ,expense_account -- 费用账号
            ,pooling_account -- 行内归集账户
            ,pooling_account_name -- 行内归集账户名称
            ,suspend_account -- 挂账账号
            ,suspend_account_name -- 挂账账号名称
            ,suspend_acc_open_bank -- 挂账账号开户行
            ,suspend_acc_open_bank_cnaps -- 挂账账号开户行联行号
            ,suspend_out_bank_no -- 挂账账号银行编号
            ,failed_payment_account_name -- 入账失败挂账账户户名
            ,open_bank_realred_crebit -- 实时赎回垫资账号开户行
            ,open_bank_realred_crebit_name -- 实时赎回垫资账号开户行名称
            ,crebit_account_branch -- 赎回账号开户行号
            ,crebit_account_branch_name -- 赎回账号开户行名称
            ,debit_account_branch -- 认申购账号开户行号
            ,debit_account_branch_name -- 认申购账号开户行名称
            ,remit_mid_account -- 汇出待转户账户
            ,apply_middle_account -- 垫资请款过渡账户
            ,remit_mid_account_name -- 汇出待转户账户名称
            ,apply_middle_account_name -- 垫资请款过渡账户名称
            ,remit_mid_account_branch -- 汇出待转户账户开户行号
            ,remit_mid_account_branch_name -- 汇出待转户账户开户行名称
            ,apply_from_account -- 请款来账账号
            ,apply_from_account_name -- 请款来账账号名称
            ,refund_account -- 退款账号
            ,refund_account_name -- 退款账号名称
            ,bank_acc_down_sys_no -- 资金兑付账户支付系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbprdbankacc_op(
            ta_code -- TA代码
            ,prd_code -- 产品代码
            ,bank_no -- 银行代码:租户编号(多租户模式用)
            ,open_bank_ver -- 验资户开户行
            ,open_bank_up -- 注册登记账户开户行
            ,bank_acc_up -- 上账银行账号
            ,bank_acc_down -- 下账银行账号
            ,bank_acc_ver -- 募集验资账户
            ,asso_code -- 关联代码:基金公司产品代码
            ,square_way -- 结算方式:[K_JSFS] 全额或净额
            ,bank_name -- 银行名称:托管银行名称
            ,branch_name -- 分支机构名称:托管机构名称
            ,prd_name -- 产品名称:外部产品名称
            ,bank_acc_up_name -- 上账银行账号名称
            ,bank_acc_down_name -- 下账银行账号名称
            ,bank_acc_ver_name -- 募集验资户账户名称
            ,reserve1 -- 保留字段1:募集验资账户支付系统编号(募集期)
            ,reserve2 -- 保留字段2:注册登记账户支付系统编号(申购期)
            ,debit_account -- 认申购账号
            ,crebit_account -- 赎回账号
            ,client_type -- 客户类型:K_KHLX 0-机构 1-个人
            ,realred_crebit_account -- 实时赎回垫资账号
            ,income_account -- 收益兑付账号
            ,pay_way -- 支付方式
            ,charge_account -- 手续费分配账号
            ,open_bank_down -- 兑付资金账户开户行
            ,open_bank_ver_name -- 验资户开户行名称
            ,open_bank_up_name -- 注册登记账户开户行名称
            ,open_bank_down_name -- 兑付资金账户开户行名称
            ,realred_crebit_account_name -- 实时赎回垫资账号名称:实时赎回垫资账号名称
            ,debit_account_name -- 认申购账号名称:认申购账号名称
            ,crebit_account_name -- 赎回账号名称:赎回账号名称
            ,income_account_name -- 收益兑付账号名称:收益兑付账号名称
            ,off_bal_account -- 表外账户:表外账户,记录表外账
            ,charge_account_name -- 手续费分配账号名称
            ,transfer_fee_acc -- 转让手续费账号:转让业务如收取转让手续时，需要将转让手续费转入此账号
            ,transfer_fee_acc_name -- 转让手续费账号名称
            ,service_fee_acc -- 服务费账号
            ,service_fee_acc_name -- 服务费账号名称
            ,out_bank_no -- 外部银行代码:归集账号的银行编号
            ,out_bank_name -- 转出/外部银行名称:归集账号的银行名称
            ,spno -- 联行号:归集账号的联行号
            ,debit_account_in_old -- 直销银行理财认申购归集账号(开立在传统核心系统)
            ,debit_account_in_new -- 直销银行理财认申购归集账号(开立在直销银行系统
            ,crebit_account_in_old -- 直销银行赎回账号(开立在传统核心系统)
            ,crebit_account_in_new -- 直销银行赎回账号(开立在直销银行系统)
            ,crebit_middle_account -- 赎回过渡账户
            ,crebit_middle_account_name -- 赎回过渡账户名称
            ,debit_middle_account -- 认申购过渡账号
            ,debit_middle_account_name -- 认申购过渡账户名称
            ,digital_wallet_bank -- 数字钱包开立机构
            ,advance_account -- 垫资账户
            ,advance_account_name -- 垫资账户名称
            ,draw_interacc -- 垫资中间账号
            ,draw_interacc_name -- 垫资中间户账户名称
            ,draw_interacc_bank_name -- 垫资中间户开户行名称
            ,draw_interacc_bank_organ -- 垫资中间户开户行机构编号
            ,failed_payment_account -- 入账失败挂账账户
            ,issuer_clear_bank_name -- 发行机构清算行名
            ,issuer_clear_account -- 发行机构认申购清算账号
            ,expense_account -- 费用账号
            ,pooling_account -- 行内归集账户
            ,pooling_account_name -- 行内归集账户名称
            ,suspend_account -- 挂账账号
            ,suspend_account_name -- 挂账账号名称
            ,suspend_acc_open_bank -- 挂账账号开户行
            ,suspend_acc_open_bank_cnaps -- 挂账账号开户行联行号
            ,suspend_out_bank_no -- 挂账账号银行编号
            ,failed_payment_account_name -- 入账失败挂账账户户名
            ,open_bank_realred_crebit -- 实时赎回垫资账号开户行
            ,open_bank_realred_crebit_name -- 实时赎回垫资账号开户行名称
            ,crebit_account_branch -- 赎回账号开户行号
            ,crebit_account_branch_name -- 赎回账号开户行名称
            ,debit_account_branch -- 认申购账号开户行号
            ,debit_account_branch_name -- 认申购账号开户行名称
            ,remit_mid_account -- 汇出待转户账户
            ,apply_middle_account -- 垫资请款过渡账户
            ,remit_mid_account_name -- 汇出待转户账户名称
            ,apply_middle_account_name -- 垫资请款过渡账户名称
            ,remit_mid_account_branch -- 汇出待转户账户开户行号
            ,remit_mid_account_branch_name -- 汇出待转户账户开户行名称
            ,apply_from_account -- 请款来账账号
            ,apply_from_account_name -- 请款来账账号名称
            ,refund_account -- 退款账号
            ,refund_account_name -- 退款账号名称
            ,bank_acc_down_sys_no -- 资金兑付账户支付系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- TA代码
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行代码:租户编号(多租户模式用)
    ,nvl(n.open_bank_ver, o.open_bank_ver) as open_bank_ver -- 验资户开户行
    ,nvl(n.open_bank_up, o.open_bank_up) as open_bank_up -- 注册登记账户开户行
    ,nvl(n.bank_acc_up, o.bank_acc_up) as bank_acc_up -- 上账银行账号
    ,nvl(n.bank_acc_down, o.bank_acc_down) as bank_acc_down -- 下账银行账号
    ,nvl(n.bank_acc_ver, o.bank_acc_ver) as bank_acc_ver -- 募集验资账户
    ,nvl(n.asso_code, o.asso_code) as asso_code -- 关联代码:基金公司产品代码
    ,nvl(n.square_way, o.square_way) as square_way -- 结算方式:[K_JSFS] 全额或净额
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 银行名称:托管银行名称
    ,nvl(n.branch_name, o.branch_name) as branch_name -- 分支机构名称:托管机构名称
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 产品名称:外部产品名称
    ,nvl(n.bank_acc_up_name, o.bank_acc_up_name) as bank_acc_up_name -- 上账银行账号名称
    ,nvl(n.bank_acc_down_name, o.bank_acc_down_name) as bank_acc_down_name -- 下账银行账号名称
    ,nvl(n.bank_acc_ver_name, o.bank_acc_ver_name) as bank_acc_ver_name -- 募集验资户账户名称
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留字段1:募集验资账户支付系统编号(募集期)
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留字段2:注册登记账户支付系统编号(申购期)
    ,nvl(n.debit_account, o.debit_account) as debit_account -- 认申购账号
    ,nvl(n.crebit_account, o.crebit_account) as crebit_account -- 赎回账号
    ,nvl(n.client_type, o.client_type) as client_type -- 客户类型:K_KHLX 0-机构 1-个人
    ,nvl(n.realred_crebit_account, o.realred_crebit_account) as realred_crebit_account -- 实时赎回垫资账号
    ,nvl(n.income_account, o.income_account) as income_account -- 收益兑付账号
    ,nvl(n.pay_way, o.pay_way) as pay_way -- 支付方式
    ,nvl(n.charge_account, o.charge_account) as charge_account -- 手续费分配账号
    ,nvl(n.open_bank_down, o.open_bank_down) as open_bank_down -- 兑付资金账户开户行
    ,nvl(n.open_bank_ver_name, o.open_bank_ver_name) as open_bank_ver_name -- 验资户开户行名称
    ,nvl(n.open_bank_up_name, o.open_bank_up_name) as open_bank_up_name -- 注册登记账户开户行名称
    ,nvl(n.open_bank_down_name, o.open_bank_down_name) as open_bank_down_name -- 兑付资金账户开户行名称
    ,nvl(n.realred_crebit_account_name, o.realred_crebit_account_name) as realred_crebit_account_name -- 实时赎回垫资账号名称:实时赎回垫资账号名称
    ,nvl(n.debit_account_name, o.debit_account_name) as debit_account_name -- 认申购账号名称:认申购账号名称
    ,nvl(n.crebit_account_name, o.crebit_account_name) as crebit_account_name -- 赎回账号名称:赎回账号名称
    ,nvl(n.income_account_name, o.income_account_name) as income_account_name -- 收益兑付账号名称:收益兑付账号名称
    ,nvl(n.off_bal_account, o.off_bal_account) as off_bal_account -- 表外账户:表外账户,记录表外账
    ,nvl(n.charge_account_name, o.charge_account_name) as charge_account_name -- 手续费分配账号名称
    ,nvl(n.transfer_fee_acc, o.transfer_fee_acc) as transfer_fee_acc -- 转让手续费账号:转让业务如收取转让手续时，需要将转让手续费转入此账号
    ,nvl(n.transfer_fee_acc_name, o.transfer_fee_acc_name) as transfer_fee_acc_name -- 转让手续费账号名称
    ,nvl(n.service_fee_acc, o.service_fee_acc) as service_fee_acc -- 服务费账号
    ,nvl(n.service_fee_acc_name, o.service_fee_acc_name) as service_fee_acc_name -- 服务费账号名称
    ,nvl(n.out_bank_no, o.out_bank_no) as out_bank_no -- 外部银行代码:归集账号的银行编号
    ,nvl(n.out_bank_name, o.out_bank_name) as out_bank_name -- 转出/外部银行名称:归集账号的银行名称
    ,nvl(n.spno, o.spno) as spno -- 联行号:归集账号的联行号
    ,nvl(n.debit_account_in_old, o.debit_account_in_old) as debit_account_in_old -- 直销银行理财认申购归集账号(开立在传统核心系统)
    ,nvl(n.debit_account_in_new, o.debit_account_in_new) as debit_account_in_new -- 直销银行理财认申购归集账号(开立在直销银行系统
    ,nvl(n.crebit_account_in_old, o.crebit_account_in_old) as crebit_account_in_old -- 直销银行赎回账号(开立在传统核心系统)
    ,nvl(n.crebit_account_in_new, o.crebit_account_in_new) as crebit_account_in_new -- 直销银行赎回账号(开立在直销银行系统)
    ,nvl(n.crebit_middle_account, o.crebit_middle_account) as crebit_middle_account -- 赎回过渡账户
    ,nvl(n.crebit_middle_account_name, o.crebit_middle_account_name) as crebit_middle_account_name -- 赎回过渡账户名称
    ,nvl(n.debit_middle_account, o.debit_middle_account) as debit_middle_account -- 认申购过渡账号
    ,nvl(n.debit_middle_account_name, o.debit_middle_account_name) as debit_middle_account_name -- 认申购过渡账户名称
    ,nvl(n.digital_wallet_bank, o.digital_wallet_bank) as digital_wallet_bank -- 数字钱包开立机构
    ,nvl(n.advance_account, o.advance_account) as advance_account -- 垫资账户
    ,nvl(n.advance_account_name, o.advance_account_name) as advance_account_name -- 垫资账户名称
    ,nvl(n.draw_interacc, o.draw_interacc) as draw_interacc -- 垫资中间账号
    ,nvl(n.draw_interacc_name, o.draw_interacc_name) as draw_interacc_name -- 垫资中间户账户名称
    ,nvl(n.draw_interacc_bank_name, o.draw_interacc_bank_name) as draw_interacc_bank_name -- 垫资中间户开户行名称
    ,nvl(n.draw_interacc_bank_organ, o.draw_interacc_bank_organ) as draw_interacc_bank_organ -- 垫资中间户开户行机构编号
    ,nvl(n.failed_payment_account, o.failed_payment_account) as failed_payment_account -- 入账失败挂账账户
    ,nvl(n.issuer_clear_bank_name, o.issuer_clear_bank_name) as issuer_clear_bank_name -- 发行机构清算行名
    ,nvl(n.issuer_clear_account, o.issuer_clear_account) as issuer_clear_account -- 发行机构认申购清算账号
    ,nvl(n.expense_account, o.expense_account) as expense_account -- 费用账号
    ,nvl(n.pooling_account, o.pooling_account) as pooling_account -- 行内归集账户
    ,nvl(n.pooling_account_name, o.pooling_account_name) as pooling_account_name -- 行内归集账户名称
    ,nvl(n.suspend_account, o.suspend_account) as suspend_account -- 挂账账号
    ,nvl(n.suspend_account_name, o.suspend_account_name) as suspend_account_name -- 挂账账号名称
    ,nvl(n.suspend_acc_open_bank, o.suspend_acc_open_bank) as suspend_acc_open_bank -- 挂账账号开户行
    ,nvl(n.suspend_acc_open_bank_cnaps, o.suspend_acc_open_bank_cnaps) as suspend_acc_open_bank_cnaps -- 挂账账号开户行联行号
    ,nvl(n.suspend_out_bank_no, o.suspend_out_bank_no) as suspend_out_bank_no -- 挂账账号银行编号
    ,nvl(n.failed_payment_account_name, o.failed_payment_account_name) as failed_payment_account_name -- 入账失败挂账账户户名
    ,nvl(n.open_bank_realred_crebit, o.open_bank_realred_crebit) as open_bank_realred_crebit -- 实时赎回垫资账号开户行
    ,nvl(n.open_bank_realred_crebit_name, o.open_bank_realred_crebit_name) as open_bank_realred_crebit_name -- 实时赎回垫资账号开户行名称
    ,nvl(n.crebit_account_branch, o.crebit_account_branch) as crebit_account_branch -- 赎回账号开户行号
    ,nvl(n.crebit_account_branch_name, o.crebit_account_branch_name) as crebit_account_branch_name -- 赎回账号开户行名称
    ,nvl(n.debit_account_branch, o.debit_account_branch) as debit_account_branch -- 认申购账号开户行号
    ,nvl(n.debit_account_branch_name, o.debit_account_branch_name) as debit_account_branch_name -- 认申购账号开户行名称
    ,nvl(n.remit_mid_account, o.remit_mid_account) as remit_mid_account -- 汇出待转户账户
    ,nvl(n.apply_middle_account, o.apply_middle_account) as apply_middle_account -- 垫资请款过渡账户
    ,nvl(n.remit_mid_account_name, o.remit_mid_account_name) as remit_mid_account_name -- 汇出待转户账户名称
    ,nvl(n.apply_middle_account_name, o.apply_middle_account_name) as apply_middle_account_name -- 垫资请款过渡账户名称
    ,nvl(n.remit_mid_account_branch, o.remit_mid_account_branch) as remit_mid_account_branch -- 汇出待转户账户开户行号
    ,nvl(n.remit_mid_account_branch_name, o.remit_mid_account_branch_name) as remit_mid_account_branch_name -- 汇出待转户账户开户行名称
    ,nvl(n.apply_from_account, o.apply_from_account) as apply_from_account -- 请款来账账号
    ,nvl(n.apply_from_account_name, o.apply_from_account_name) as apply_from_account_name -- 请款来账账号名称
    ,nvl(n.refund_account, o.refund_account) as refund_account -- 退款账号
    ,nvl(n.refund_account_name, o.refund_account_name) as refund_account_name -- 退款账号名称
    ,nvl(n.bank_acc_down_sys_no, o.bank_acc_down_sys_no) as bank_acc_down_sys_no -- 资金兑付账户支付系统编号
    ,case when
            n.prd_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbprdbankacc_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbprdbankacc where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
where (
        o.prd_code is null
    )
    or (
        n.prd_code is null
    )
    or (
        o.ta_code <> n.ta_code
        or o.bank_no <> n.bank_no
        or o.open_bank_ver <> n.open_bank_ver
        or o.open_bank_up <> n.open_bank_up
        or o.bank_acc_up <> n.bank_acc_up
        or o.bank_acc_down <> n.bank_acc_down
        or o.bank_acc_ver <> n.bank_acc_ver
        or o.asso_code <> n.asso_code
        or o.square_way <> n.square_way
        or o.bank_name <> n.bank_name
        or o.branch_name <> n.branch_name
        or o.prd_name <> n.prd_name
        or o.bank_acc_up_name <> n.bank_acc_up_name
        or o.bank_acc_down_name <> n.bank_acc_down_name
        or o.bank_acc_ver_name <> n.bank_acc_ver_name
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.debit_account <> n.debit_account
        or o.crebit_account <> n.crebit_account
        or o.client_type <> n.client_type
        or o.realred_crebit_account <> n.realred_crebit_account
        or o.income_account <> n.income_account
        or o.pay_way <> n.pay_way
        or o.charge_account <> n.charge_account
        or o.open_bank_down <> n.open_bank_down
        or o.open_bank_ver_name <> n.open_bank_ver_name
        or o.open_bank_up_name <> n.open_bank_up_name
        or o.open_bank_down_name <> n.open_bank_down_name
        or o.realred_crebit_account_name <> n.realred_crebit_account_name
        or o.debit_account_name <> n.debit_account_name
        or o.crebit_account_name <> n.crebit_account_name
        or o.income_account_name <> n.income_account_name
        or o.off_bal_account <> n.off_bal_account
        or o.charge_account_name <> n.charge_account_name
        or o.transfer_fee_acc <> n.transfer_fee_acc
        or o.transfer_fee_acc_name <> n.transfer_fee_acc_name
        or o.service_fee_acc <> n.service_fee_acc
        or o.service_fee_acc_name <> n.service_fee_acc_name
        or o.out_bank_no <> n.out_bank_no
        or o.out_bank_name <> n.out_bank_name
        or o.spno <> n.spno
        or o.debit_account_in_old <> n.debit_account_in_old
        or o.debit_account_in_new <> n.debit_account_in_new
        or o.crebit_account_in_old <> n.crebit_account_in_old
        or o.crebit_account_in_new <> n.crebit_account_in_new
        or o.crebit_middle_account <> n.crebit_middle_account
        or o.crebit_middle_account_name <> n.crebit_middle_account_name
        or o.debit_middle_account <> n.debit_middle_account
        or o.debit_middle_account_name <> n.debit_middle_account_name
        or o.digital_wallet_bank <> n.digital_wallet_bank
        or o.advance_account <> n.advance_account
        or o.advance_account_name <> n.advance_account_name
        or o.draw_interacc <> n.draw_interacc
        or o.draw_interacc_name <> n.draw_interacc_name
        or o.draw_interacc_bank_name <> n.draw_interacc_bank_name
        or o.draw_interacc_bank_organ <> n.draw_interacc_bank_organ
        or o.failed_payment_account <> n.failed_payment_account
        or o.issuer_clear_bank_name <> n.issuer_clear_bank_name
        or o.issuer_clear_account <> n.issuer_clear_account
        or o.expense_account <> n.expense_account
        or o.pooling_account <> n.pooling_account
        or o.pooling_account_name <> n.pooling_account_name
        or o.suspend_account <> n.suspend_account
        or o.suspend_account_name <> n.suspend_account_name
        or o.suspend_acc_open_bank <> n.suspend_acc_open_bank
        or o.suspend_acc_open_bank_cnaps <> n.suspend_acc_open_bank_cnaps
        or o.suspend_out_bank_no <> n.suspend_out_bank_no
        or o.failed_payment_account_name <> n.failed_payment_account_name
        or o.open_bank_realred_crebit <> n.open_bank_realred_crebit
        or o.open_bank_realred_crebit_name <> n.open_bank_realred_crebit_name
        or o.crebit_account_branch <> n.crebit_account_branch
        or o.crebit_account_branch_name <> n.crebit_account_branch_name
        or o.debit_account_branch <> n.debit_account_branch
        or o.debit_account_branch_name <> n.debit_account_branch_name
        or o.remit_mid_account <> n.remit_mid_account
        or o.apply_middle_account <> n.apply_middle_account
        or o.remit_mid_account_name <> n.remit_mid_account_name
        or o.apply_middle_account_name <> n.apply_middle_account_name
        or o.remit_mid_account_branch <> n.remit_mid_account_branch
        or o.remit_mid_account_branch_name <> n.remit_mid_account_branch_name
        or o.apply_from_account <> n.apply_from_account
        or o.apply_from_account_name <> n.apply_from_account_name
        or o.refund_account <> n.refund_account
        or o.refund_account_name <> n.refund_account_name
        or o.bank_acc_down_sys_no <> n.bank_acc_down_sys_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbprdbankacc_cl(
            ta_code -- TA代码
            ,prd_code -- 产品代码
            ,bank_no -- 银行代码:租户编号(多租户模式用)
            ,open_bank_ver -- 验资户开户行
            ,open_bank_up -- 注册登记账户开户行
            ,bank_acc_up -- 上账银行账号
            ,bank_acc_down -- 下账银行账号
            ,bank_acc_ver -- 募集验资账户
            ,asso_code -- 关联代码:基金公司产品代码
            ,square_way -- 结算方式:[K_JSFS] 全额或净额
            ,bank_name -- 银行名称:托管银行名称
            ,branch_name -- 分支机构名称:托管机构名称
            ,prd_name -- 产品名称:外部产品名称
            ,bank_acc_up_name -- 上账银行账号名称
            ,bank_acc_down_name -- 下账银行账号名称
            ,bank_acc_ver_name -- 募集验资户账户名称
            ,reserve1 -- 保留字段1:募集验资账户支付系统编号(募集期)
            ,reserve2 -- 保留字段2:注册登记账户支付系统编号(申购期)
            ,debit_account -- 认申购账号
            ,crebit_account -- 赎回账号
            ,client_type -- 客户类型:K_KHLX 0-机构 1-个人
            ,realred_crebit_account -- 实时赎回垫资账号
            ,income_account -- 收益兑付账号
            ,pay_way -- 支付方式
            ,charge_account -- 手续费分配账号
            ,open_bank_down -- 兑付资金账户开户行
            ,open_bank_ver_name -- 验资户开户行名称
            ,open_bank_up_name -- 注册登记账户开户行名称
            ,open_bank_down_name -- 兑付资金账户开户行名称
            ,realred_crebit_account_name -- 实时赎回垫资账号名称:实时赎回垫资账号名称
            ,debit_account_name -- 认申购账号名称:认申购账号名称
            ,crebit_account_name -- 赎回账号名称:赎回账号名称
            ,income_account_name -- 收益兑付账号名称:收益兑付账号名称
            ,off_bal_account -- 表外账户:表外账户,记录表外账
            ,charge_account_name -- 手续费分配账号名称
            ,transfer_fee_acc -- 转让手续费账号:转让业务如收取转让手续时，需要将转让手续费转入此账号
            ,transfer_fee_acc_name -- 转让手续费账号名称
            ,service_fee_acc -- 服务费账号
            ,service_fee_acc_name -- 服务费账号名称
            ,out_bank_no -- 外部银行代码:归集账号的银行编号
            ,out_bank_name -- 转出/外部银行名称:归集账号的银行名称
            ,spno -- 联行号:归集账号的联行号
            ,debit_account_in_old -- 直销银行理财认申购归集账号(开立在传统核心系统)
            ,debit_account_in_new -- 直销银行理财认申购归集账号(开立在直销银行系统
            ,crebit_account_in_old -- 直销银行赎回账号(开立在传统核心系统)
            ,crebit_account_in_new -- 直销银行赎回账号(开立在直销银行系统)
            ,crebit_middle_account -- 赎回过渡账户
            ,crebit_middle_account_name -- 赎回过渡账户名称
            ,debit_middle_account -- 认申购过渡账号
            ,debit_middle_account_name -- 认申购过渡账户名称
            ,digital_wallet_bank -- 数字钱包开立机构
            ,advance_account -- 垫资账户
            ,advance_account_name -- 垫资账户名称
            ,draw_interacc -- 垫资中间账号
            ,draw_interacc_name -- 垫资中间户账户名称
            ,draw_interacc_bank_name -- 垫资中间户开户行名称
            ,draw_interacc_bank_organ -- 垫资中间户开户行机构编号
            ,failed_payment_account -- 入账失败挂账账户
            ,issuer_clear_bank_name -- 发行机构清算行名
            ,issuer_clear_account -- 发行机构认申购清算账号
            ,expense_account -- 费用账号
            ,pooling_account -- 行内归集账户
            ,pooling_account_name -- 行内归集账户名称
            ,suspend_account -- 挂账账号
            ,suspend_account_name -- 挂账账号名称
            ,suspend_acc_open_bank -- 挂账账号开户行
            ,suspend_acc_open_bank_cnaps -- 挂账账号开户行联行号
            ,suspend_out_bank_no -- 挂账账号银行编号
            ,failed_payment_account_name -- 入账失败挂账账户户名
            ,open_bank_realred_crebit -- 实时赎回垫资账号开户行
            ,open_bank_realred_crebit_name -- 实时赎回垫资账号开户行名称
            ,crebit_account_branch -- 赎回账号开户行号
            ,crebit_account_branch_name -- 赎回账号开户行名称
            ,debit_account_branch -- 认申购账号开户行号
            ,debit_account_branch_name -- 认申购账号开户行名称
            ,remit_mid_account -- 汇出待转户账户
            ,apply_middle_account -- 垫资请款过渡账户
            ,remit_mid_account_name -- 汇出待转户账户名称
            ,apply_middle_account_name -- 垫资请款过渡账户名称
            ,remit_mid_account_branch -- 汇出待转户账户开户行号
            ,remit_mid_account_branch_name -- 汇出待转户账户开户行名称
            ,apply_from_account -- 请款来账账号
            ,apply_from_account_name -- 请款来账账号名称
            ,refund_account -- 退款账号
            ,refund_account_name -- 退款账号名称
            ,bank_acc_down_sys_no -- 资金兑付账户支付系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbprdbankacc_op(
            ta_code -- TA代码
            ,prd_code -- 产品代码
            ,bank_no -- 银行代码:租户编号(多租户模式用)
            ,open_bank_ver -- 验资户开户行
            ,open_bank_up -- 注册登记账户开户行
            ,bank_acc_up -- 上账银行账号
            ,bank_acc_down -- 下账银行账号
            ,bank_acc_ver -- 募集验资账户
            ,asso_code -- 关联代码:基金公司产品代码
            ,square_way -- 结算方式:[K_JSFS] 全额或净额
            ,bank_name -- 银行名称:托管银行名称
            ,branch_name -- 分支机构名称:托管机构名称
            ,prd_name -- 产品名称:外部产品名称
            ,bank_acc_up_name -- 上账银行账号名称
            ,bank_acc_down_name -- 下账银行账号名称
            ,bank_acc_ver_name -- 募集验资户账户名称
            ,reserve1 -- 保留字段1:募集验资账户支付系统编号(募集期)
            ,reserve2 -- 保留字段2:注册登记账户支付系统编号(申购期)
            ,debit_account -- 认申购账号
            ,crebit_account -- 赎回账号
            ,client_type -- 客户类型:K_KHLX 0-机构 1-个人
            ,realred_crebit_account -- 实时赎回垫资账号
            ,income_account -- 收益兑付账号
            ,pay_way -- 支付方式
            ,charge_account -- 手续费分配账号
            ,open_bank_down -- 兑付资金账户开户行
            ,open_bank_ver_name -- 验资户开户行名称
            ,open_bank_up_name -- 注册登记账户开户行名称
            ,open_bank_down_name -- 兑付资金账户开户行名称
            ,realred_crebit_account_name -- 实时赎回垫资账号名称:实时赎回垫资账号名称
            ,debit_account_name -- 认申购账号名称:认申购账号名称
            ,crebit_account_name -- 赎回账号名称:赎回账号名称
            ,income_account_name -- 收益兑付账号名称:收益兑付账号名称
            ,off_bal_account -- 表外账户:表外账户,记录表外账
            ,charge_account_name -- 手续费分配账号名称
            ,transfer_fee_acc -- 转让手续费账号:转让业务如收取转让手续时，需要将转让手续费转入此账号
            ,transfer_fee_acc_name -- 转让手续费账号名称
            ,service_fee_acc -- 服务费账号
            ,service_fee_acc_name -- 服务费账号名称
            ,out_bank_no -- 外部银行代码:归集账号的银行编号
            ,out_bank_name -- 转出/外部银行名称:归集账号的银行名称
            ,spno -- 联行号:归集账号的联行号
            ,debit_account_in_old -- 直销银行理财认申购归集账号(开立在传统核心系统)
            ,debit_account_in_new -- 直销银行理财认申购归集账号(开立在直销银行系统
            ,crebit_account_in_old -- 直销银行赎回账号(开立在传统核心系统)
            ,crebit_account_in_new -- 直销银行赎回账号(开立在直销银行系统)
            ,crebit_middle_account -- 赎回过渡账户
            ,crebit_middle_account_name -- 赎回过渡账户名称
            ,debit_middle_account -- 认申购过渡账号
            ,debit_middle_account_name -- 认申购过渡账户名称
            ,digital_wallet_bank -- 数字钱包开立机构
            ,advance_account -- 垫资账户
            ,advance_account_name -- 垫资账户名称
            ,draw_interacc -- 垫资中间账号
            ,draw_interacc_name -- 垫资中间户账户名称
            ,draw_interacc_bank_name -- 垫资中间户开户行名称
            ,draw_interacc_bank_organ -- 垫资中间户开户行机构编号
            ,failed_payment_account -- 入账失败挂账账户
            ,issuer_clear_bank_name -- 发行机构清算行名
            ,issuer_clear_account -- 发行机构认申购清算账号
            ,expense_account -- 费用账号
            ,pooling_account -- 行内归集账户
            ,pooling_account_name -- 行内归集账户名称
            ,suspend_account -- 挂账账号
            ,suspend_account_name -- 挂账账号名称
            ,suspend_acc_open_bank -- 挂账账号开户行
            ,suspend_acc_open_bank_cnaps -- 挂账账号开户行联行号
            ,suspend_out_bank_no -- 挂账账号银行编号
            ,failed_payment_account_name -- 入账失败挂账账户户名
            ,open_bank_realred_crebit -- 实时赎回垫资账号开户行
            ,open_bank_realred_crebit_name -- 实时赎回垫资账号开户行名称
            ,crebit_account_branch -- 赎回账号开户行号
            ,crebit_account_branch_name -- 赎回账号开户行名称
            ,debit_account_branch -- 认申购账号开户行号
            ,debit_account_branch_name -- 认申购账号开户行名称
            ,remit_mid_account -- 汇出待转户账户
            ,apply_middle_account -- 垫资请款过渡账户
            ,remit_mid_account_name -- 汇出待转户账户名称
            ,apply_middle_account_name -- 垫资请款过渡账户名称
            ,remit_mid_account_branch -- 汇出待转户账户开户行号
            ,remit_mid_account_branch_name -- 汇出待转户账户开户行名称
            ,apply_from_account -- 请款来账账号
            ,apply_from_account_name -- 请款来账账号名称
            ,refund_account -- 退款账号
            ,refund_account_name -- 退款账号名称
            ,bank_acc_down_sys_no -- 资金兑付账户支付系统编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- TA代码
    ,o.prd_code -- 产品代码
    ,o.bank_no -- 银行代码:租户编号(多租户模式用)
    ,o.open_bank_ver -- 验资户开户行
    ,o.open_bank_up -- 注册登记账户开户行
    ,o.bank_acc_up -- 上账银行账号
    ,o.bank_acc_down -- 下账银行账号
    ,o.bank_acc_ver -- 募集验资账户
    ,o.asso_code -- 关联代码:基金公司产品代码
    ,o.square_way -- 结算方式:[K_JSFS] 全额或净额
    ,o.bank_name -- 银行名称:托管银行名称
    ,o.branch_name -- 分支机构名称:托管机构名称
    ,o.prd_name -- 产品名称:外部产品名称
    ,o.bank_acc_up_name -- 上账银行账号名称
    ,o.bank_acc_down_name -- 下账银行账号名称
    ,o.bank_acc_ver_name -- 募集验资户账户名称
    ,o.reserve1 -- 保留字段1:募集验资账户支付系统编号(募集期)
    ,o.reserve2 -- 保留字段2:注册登记账户支付系统编号(申购期)
    ,o.debit_account -- 认申购账号
    ,o.crebit_account -- 赎回账号
    ,o.client_type -- 客户类型:K_KHLX 0-机构 1-个人
    ,o.realred_crebit_account -- 实时赎回垫资账号
    ,o.income_account -- 收益兑付账号
    ,o.pay_way -- 支付方式
    ,o.charge_account -- 手续费分配账号
    ,o.open_bank_down -- 兑付资金账户开户行
    ,o.open_bank_ver_name -- 验资户开户行名称
    ,o.open_bank_up_name -- 注册登记账户开户行名称
    ,o.open_bank_down_name -- 兑付资金账户开户行名称
    ,o.realred_crebit_account_name -- 实时赎回垫资账号名称:实时赎回垫资账号名称
    ,o.debit_account_name -- 认申购账号名称:认申购账号名称
    ,o.crebit_account_name -- 赎回账号名称:赎回账号名称
    ,o.income_account_name -- 收益兑付账号名称:收益兑付账号名称
    ,o.off_bal_account -- 表外账户:表外账户,记录表外账
    ,o.charge_account_name -- 手续费分配账号名称
    ,o.transfer_fee_acc -- 转让手续费账号:转让业务如收取转让手续时，需要将转让手续费转入此账号
    ,o.transfer_fee_acc_name -- 转让手续费账号名称
    ,o.service_fee_acc -- 服务费账号
    ,o.service_fee_acc_name -- 服务费账号名称
    ,o.out_bank_no -- 外部银行代码:归集账号的银行编号
    ,o.out_bank_name -- 转出/外部银行名称:归集账号的银行名称
    ,o.spno -- 联行号:归集账号的联行号
    ,o.debit_account_in_old -- 直销银行理财认申购归集账号(开立在传统核心系统)
    ,o.debit_account_in_new -- 直销银行理财认申购归集账号(开立在直销银行系统
    ,o.crebit_account_in_old -- 直销银行赎回账号(开立在传统核心系统)
    ,o.crebit_account_in_new -- 直销银行赎回账号(开立在直销银行系统)
    ,o.crebit_middle_account -- 赎回过渡账户
    ,o.crebit_middle_account_name -- 赎回过渡账户名称
    ,o.debit_middle_account -- 认申购过渡账号
    ,o.debit_middle_account_name -- 认申购过渡账户名称
    ,o.digital_wallet_bank -- 数字钱包开立机构
    ,o.advance_account -- 垫资账户
    ,o.advance_account_name -- 垫资账户名称
    ,o.draw_interacc -- 垫资中间账号
    ,o.draw_interacc_name -- 垫资中间户账户名称
    ,o.draw_interacc_bank_name -- 垫资中间户开户行名称
    ,o.draw_interacc_bank_organ -- 垫资中间户开户行机构编号
    ,o.failed_payment_account -- 入账失败挂账账户
    ,o.issuer_clear_bank_name -- 发行机构清算行名
    ,o.issuer_clear_account -- 发行机构认申购清算账号
    ,o.expense_account -- 费用账号
    ,o.pooling_account -- 行内归集账户
    ,o.pooling_account_name -- 行内归集账户名称
    ,o.suspend_account -- 挂账账号
    ,o.suspend_account_name -- 挂账账号名称
    ,o.suspend_acc_open_bank -- 挂账账号开户行
    ,o.suspend_acc_open_bank_cnaps -- 挂账账号开户行联行号
    ,o.suspend_out_bank_no -- 挂账账号银行编号
    ,o.failed_payment_account_name -- 入账失败挂账账户户名
    ,o.open_bank_realred_crebit -- 实时赎回垫资账号开户行
    ,o.open_bank_realred_crebit_name -- 实时赎回垫资账号开户行名称
    ,o.crebit_account_branch -- 赎回账号开户行号
    ,o.crebit_account_branch_name -- 赎回账号开户行名称
    ,o.debit_account_branch -- 认申购账号开户行号
    ,o.debit_account_branch_name -- 认申购账号开户行名称
    ,o.remit_mid_account -- 汇出待转户账户
    ,o.apply_middle_account -- 垫资请款过渡账户
    ,o.remit_mid_account_name -- 汇出待转户账户名称
    ,o.apply_middle_account_name -- 垫资请款过渡账户名称
    ,o.remit_mid_account_branch -- 汇出待转户账户开户行号
    ,o.remit_mid_account_branch_name -- 汇出待转户账户开户行名称
    ,o.apply_from_account -- 请款来账账号
    ,o.apply_from_account_name -- 请款来账账号名称
    ,o.refund_account -- 退款账号
    ,o.refund_account_name -- 退款账号名称
    ,o.bank_acc_down_sys_no -- 资金兑付账户支付系统编号
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
from ${iol_schema}.ifms_tbprdbankacc_bk o
    left join ${iol_schema}.ifms_tbprdbankacc_op n
        on
            o.prd_code = n.prd_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbprdbankacc_cl d
        on
            o.prd_code = d.prd_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifms_tbprdbankacc;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifms_tbprdbankacc') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifms_tbprdbankacc drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifms_tbprdbankacc add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifms_tbprdbankacc exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbprdbankacc_cl;
alter table ${iol_schema}.ifms_tbprdbankacc exchange partition p_20991231 with table ${iol_schema}.ifms_tbprdbankacc_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbprdbankacc to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbprdbankacc_op purge;
drop table ${iol_schema}.ifms_tbprdbankacc_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbprdbankacc_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbprdbankacc',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
