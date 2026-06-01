/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifms_tbprdbankacc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifms_tbprdbankacc
whenever sqlerror continue none;
drop table ${iol_schema}.ifms_tbprdbankacc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbprdbankacc(
    ta_code varchar2(18) -- TA代码
    ,prd_code varchar2(32) -- 产品代码
    ,bank_no varchar2(32) -- 银行代码:租户编号(多租户模式用)
    ,open_bank_ver varchar2(48) -- 验资户开户行
    ,open_bank_up varchar2(48) -- 注册登记账户开户行
    ,bank_acc_up varchar2(48) -- 上账银行账号
    ,bank_acc_down varchar2(48) -- 下账银行账号
    ,bank_acc_ver varchar2(48) -- 募集验资账户
    ,asso_code varchar2(30) -- 关联代码:基金公司产品代码
    ,square_way varchar2(2) -- 结算方式:[K_JSFS] 全额或净额
    ,bank_name varchar2(250) -- 银行名称:托管银行名称
    ,branch_name varchar2(250) -- 分支机构名称:托管机构名称
    ,prd_name varchar2(375) -- 产品名称:外部产品名称
    ,bank_acc_up_name varchar2(250) -- 上账银行账号名称
    ,bank_acc_down_name varchar2(250) -- 下账银行账号名称
    ,bank_acc_ver_name varchar2(250) -- 募集验资户账户名称
    ,reserve1 varchar2(375) -- 保留字段1:募集验资账户支付系统编号(募集期)
    ,reserve2 varchar2(375) -- 保留字段2:注册登记账户支付系统编号(申购期)
    ,debit_account varchar2(32) -- 认申购账号
    ,crebit_account varchar2(32) -- 赎回账号
    ,client_type varchar2(1) -- 客户类型:K_KHLX 0-机构 1-个人
    ,realred_crebit_account varchar2(32) -- 实时赎回垫资账号
    ,income_account varchar2(32) -- 收益兑付账号
    ,pay_way varchar2(32) -- 支付方式
    ,charge_account varchar2(32) -- 手续费分配账号
    ,open_bank_down varchar2(32) -- 兑付资金账户开户行
    ,open_bank_ver_name varchar2(250) -- 验资户开户行名称
    ,open_bank_up_name varchar2(250) -- 注册登记账户开户行名称
    ,open_bank_down_name varchar2(250) -- 兑付资金账户开户行名称
    ,realred_crebit_account_name varchar2(250) -- 实时赎回垫资账号名称:实时赎回垫资账号名称
    ,debit_account_name varchar2(250) -- 认申购账号名称:认申购账号名称
    ,crebit_account_name varchar2(250) -- 赎回账号名称:赎回账号名称
    ,income_account_name varchar2(250) -- 收益兑付账号名称:收益兑付账号名称
    ,off_bal_account varchar2(20) -- 表外账户:表外账户,记录表外账
    ,charge_account_name varchar2(256) -- 手续费分配账号名称
    ,transfer_fee_acc varchar2(32) -- 转让手续费账号:转让业务如收取转让手续时，需要将转让手续费转入此账号
    ,transfer_fee_acc_name varchar2(256) -- 转让手续费账号名称
    ,service_fee_acc varchar2(32) -- 服务费账号
    ,service_fee_acc_name varchar2(256) -- 服务费账号名称
    ,out_bank_no varchar2(9) -- 外部银行代码:归集账号的银行编号
    ,out_bank_name varchar2(250) -- 转出/外部银行名称:归集账号的银行名称
    ,spno varchar2(16) -- 联行号:归集账号的联行号
    ,debit_account_in_old varchar2(32) -- 直销银行理财认申购归集账号(开立在传统核心系统)
    ,debit_account_in_new varchar2(32) -- 直销银行理财认申购归集账号(开立在直销银行系统
    ,crebit_account_in_old varchar2(32) -- 直销银行赎回账号(开立在传统核心系统)
    ,crebit_account_in_new varchar2(32) -- 直销银行赎回账号(开立在直销银行系统)
    ,crebit_middle_account varchar2(32) -- 赎回过渡账户
    ,crebit_middle_account_name varchar2(250) -- 赎回过渡账户名称
    ,debit_middle_account varchar2(32) -- 认申购过渡账号
    ,debit_middle_account_name varchar2(250) -- 认申购过渡账户名称
    ,digital_wallet_bank varchar2(9) -- 数字钱包开立机构
    ,advance_account varchar2(128) -- 垫资账户
    ,advance_account_name varchar2(250) -- 垫资账户名称
    ,draw_interacc varchar2(32) -- 垫资中间账号
    ,draw_interacc_name varchar2(250) -- 垫资中间户账户名称
    ,draw_interacc_bank_name varchar2(250) -- 垫资中间户开户行名称
    ,draw_interacc_bank_organ varchar2(16) -- 垫资中间户开户行机构编号
    ,failed_payment_account varchar2(32) -- 入账失败挂账账户
    ,issuer_clear_bank_name varchar2(250) -- 发行机构清算行名
    ,issuer_clear_account varchar2(250) -- 发行机构认申购清算账号
    ,expense_account varchar2(32) -- 费用账号
    ,pooling_account varchar2(32) -- 行内归集账户
    ,pooling_account_name varchar2(256) -- 行内归集账户名称
    ,suspend_account varchar2(128) -- 挂账账号
    ,suspend_account_name varchar2(256) -- 挂账账号名称
    ,suspend_acc_open_bank varchar2(128) -- 挂账账号开户行
    ,suspend_acc_open_bank_cnaps varchar2(256) -- 挂账账号开户行联行号
    ,suspend_out_bank_no varchar2(128) -- 挂账账号银行编号
    ,failed_payment_account_name varchar2(32) -- 入账失败挂账账户户名
    ,open_bank_realred_crebit varchar2(32) -- 实时赎回垫资账号开户行
    ,open_bank_realred_crebit_name varchar2(250) -- 实时赎回垫资账号开户行名称
    ,crebit_account_branch varchar2(32) -- 赎回账号开户行号
    ,crebit_account_branch_name varchar2(60) -- 赎回账号开户行名称
    ,debit_account_branch varchar2(32) -- 认申购账号开户行号
    ,debit_account_branch_name varchar2(60) -- 认申购账号开户行名称
    ,remit_mid_account varchar2(32) -- 汇出待转户账户
    ,apply_middle_account varchar2(32) -- 垫资请款过渡账户
    ,remit_mid_account_name varchar2(250) -- 汇出待转户账户名称
    ,apply_middle_account_name varchar2(250) -- 垫资请款过渡账户名称
    ,remit_mid_account_branch varchar2(32) -- 汇出待转户账户开户行号
    ,remit_mid_account_branch_name varchar2(60) -- 汇出待转户账户开户行名称
    ,apply_from_account varchar2(32) -- 请款来账账号
    ,apply_from_account_name varchar2(250) -- 请款来账账号名称
    ,refund_account varchar2(32) -- 退款账号
    ,refund_account_name varchar2(250) -- 退款账号名称
    ,bank_acc_down_sys_no varchar2(250) -- 资金兑付账户支付系统编号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.ifms_tbprdbankacc to ${iml_schema};
grant select on ${iol_schema}.ifms_tbprdbankacc to ${icl_schema};
grant select on ${iol_schema}.ifms_tbprdbankacc to ${idl_schema};
grant select on ${iol_schema}.ifms_tbprdbankacc to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifms_tbprdbankacc is '产品账号表';
comment on column ${iol_schema}.ifms_tbprdbankacc.ta_code is 'TA代码';
comment on column ${iol_schema}.ifms_tbprdbankacc.prd_code is '产品代码';
comment on column ${iol_schema}.ifms_tbprdbankacc.bank_no is '银行代码:租户编号(多租户模式用)';
comment on column ${iol_schema}.ifms_tbprdbankacc.open_bank_ver is '验资户开户行';
comment on column ${iol_schema}.ifms_tbprdbankacc.open_bank_up is '注册登记账户开户行';
comment on column ${iol_schema}.ifms_tbprdbankacc.bank_acc_up is '上账银行账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.bank_acc_down is '下账银行账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.bank_acc_ver is '募集验资账户';
comment on column ${iol_schema}.ifms_tbprdbankacc.asso_code is '关联代码:基金公司产品代码';
comment on column ${iol_schema}.ifms_tbprdbankacc.square_way is '结算方式:[K_JSFS] 全额或净额';
comment on column ${iol_schema}.ifms_tbprdbankacc.bank_name is '银行名称:托管银行名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.branch_name is '分支机构名称:托管机构名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.prd_name is '产品名称:外部产品名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.bank_acc_up_name is '上账银行账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.bank_acc_down_name is '下账银行账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.bank_acc_ver_name is '募集验资户账户名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.reserve1 is '保留字段1:募集验资账户支付系统编号(募集期)';
comment on column ${iol_schema}.ifms_tbprdbankacc.reserve2 is '保留字段2:注册登记账户支付系统编号(申购期)';
comment on column ${iol_schema}.ifms_tbprdbankacc.debit_account is '认申购账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.crebit_account is '赎回账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.client_type is '客户类型:K_KHLX 0-机构 1-个人';
comment on column ${iol_schema}.ifms_tbprdbankacc.realred_crebit_account is '实时赎回垫资账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.income_account is '收益兑付账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.pay_way is '支付方式';
comment on column ${iol_schema}.ifms_tbprdbankacc.charge_account is '手续费分配账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.open_bank_down is '兑付资金账户开户行';
comment on column ${iol_schema}.ifms_tbprdbankacc.open_bank_ver_name is '验资户开户行名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.open_bank_up_name is '注册登记账户开户行名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.open_bank_down_name is '兑付资金账户开户行名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.realred_crebit_account_name is '实时赎回垫资账号名称:实时赎回垫资账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.debit_account_name is '认申购账号名称:认申购账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.crebit_account_name is '赎回账号名称:赎回账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.income_account_name is '收益兑付账号名称:收益兑付账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.off_bal_account is '表外账户:表外账户,记录表外账';
comment on column ${iol_schema}.ifms_tbprdbankacc.charge_account_name is '手续费分配账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.transfer_fee_acc is '转让手续费账号:转让业务如收取转让手续时，需要将转让手续费转入此账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.transfer_fee_acc_name is '转让手续费账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.service_fee_acc is '服务费账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.service_fee_acc_name is '服务费账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.out_bank_no is '外部银行代码:归集账号的银行编号';
comment on column ${iol_schema}.ifms_tbprdbankacc.out_bank_name is '转出/外部银行名称:归集账号的银行名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.spno is '联行号:归集账号的联行号';
comment on column ${iol_schema}.ifms_tbprdbankacc.debit_account_in_old is '直销银行理财认申购归集账号(开立在传统核心系统)';
comment on column ${iol_schema}.ifms_tbprdbankacc.debit_account_in_new is '直销银行理财认申购归集账号(开立在直销银行系统';
comment on column ${iol_schema}.ifms_tbprdbankacc.crebit_account_in_old is '直销银行赎回账号(开立在传统核心系统)';
comment on column ${iol_schema}.ifms_tbprdbankacc.crebit_account_in_new is '直销银行赎回账号(开立在直销银行系统)';
comment on column ${iol_schema}.ifms_tbprdbankacc.crebit_middle_account is '赎回过渡账户';
comment on column ${iol_schema}.ifms_tbprdbankacc.crebit_middle_account_name is '赎回过渡账户名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.debit_middle_account is '认申购过渡账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.debit_middle_account_name is '认申购过渡账户名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.digital_wallet_bank is '数字钱包开立机构';
comment on column ${iol_schema}.ifms_tbprdbankacc.advance_account is '垫资账户';
comment on column ${iol_schema}.ifms_tbprdbankacc.advance_account_name is '垫资账户名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.draw_interacc is '垫资中间账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.draw_interacc_name is '垫资中间户账户名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.draw_interacc_bank_name is '垫资中间户开户行名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.draw_interacc_bank_organ is '垫资中间户开户行机构编号';
comment on column ${iol_schema}.ifms_tbprdbankacc.failed_payment_account is '入账失败挂账账户';
comment on column ${iol_schema}.ifms_tbprdbankacc.issuer_clear_bank_name is '发行机构清算行名';
comment on column ${iol_schema}.ifms_tbprdbankacc.issuer_clear_account is '发行机构认申购清算账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.expense_account is '费用账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.pooling_account is '行内归集账户';
comment on column ${iol_schema}.ifms_tbprdbankacc.pooling_account_name is '行内归集账户名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.suspend_account is '挂账账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.suspend_account_name is '挂账账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.suspend_acc_open_bank is '挂账账号开户行';
comment on column ${iol_schema}.ifms_tbprdbankacc.suspend_acc_open_bank_cnaps is '挂账账号开户行联行号';
comment on column ${iol_schema}.ifms_tbprdbankacc.suspend_out_bank_no is '挂账账号银行编号';
comment on column ${iol_schema}.ifms_tbprdbankacc.failed_payment_account_name is '入账失败挂账账户户名';
comment on column ${iol_schema}.ifms_tbprdbankacc.open_bank_realred_crebit is '实时赎回垫资账号开户行';
comment on column ${iol_schema}.ifms_tbprdbankacc.open_bank_realred_crebit_name is '实时赎回垫资账号开户行名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.crebit_account_branch is '赎回账号开户行号';
comment on column ${iol_schema}.ifms_tbprdbankacc.crebit_account_branch_name is '赎回账号开户行名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.debit_account_branch is '认申购账号开户行号';
comment on column ${iol_schema}.ifms_tbprdbankacc.debit_account_branch_name is '认申购账号开户行名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.remit_mid_account is '汇出待转户账户';
comment on column ${iol_schema}.ifms_tbprdbankacc.apply_middle_account is '垫资请款过渡账户';
comment on column ${iol_schema}.ifms_tbprdbankacc.remit_mid_account_name is '汇出待转户账户名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.apply_middle_account_name is '垫资请款过渡账户名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.remit_mid_account_branch is '汇出待转户账户开户行号';
comment on column ${iol_schema}.ifms_tbprdbankacc.remit_mid_account_branch_name is '汇出待转户账户开户行名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.apply_from_account is '请款来账账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.apply_from_account_name is '请款来账账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.refund_account is '退款账号';
comment on column ${iol_schema}.ifms_tbprdbankacc.refund_account_name is '退款账号名称';
comment on column ${iol_schema}.ifms_tbprdbankacc.bank_acc_down_sys_no is '资金兑付账户支付系统编号';
comment on column ${iol_schema}.ifms_tbprdbankacc.start_dt is '开始时间';
comment on column ${iol_schema}.ifms_tbprdbankacc.end_dt is '结束时间';
comment on column ${iol_schema}.ifms_tbprdbankacc.id_mark is '增删标志';
comment on column ${iol_schema}.ifms_tbprdbankacc.etl_timestamp is 'ETL处理时间戳';
