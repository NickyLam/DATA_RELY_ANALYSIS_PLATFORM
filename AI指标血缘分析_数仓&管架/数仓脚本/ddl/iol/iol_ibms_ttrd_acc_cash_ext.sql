/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ibms_ttrd_acc_cash_ext
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ibms_ttrd_acc_cash_ext
whenever sqlerror continue none;
drop table ${iol_schema}.ibms_ttrd_acc_cash_ext purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_acc_cash_ext(
    accid varchar2(30) -- 账户代码
    ,accname varchar2(180) -- 账户名称
    ,markets varchar2(150) -- 交易市场
    ,exhacc varchar2(75) -- 交易所账户
    ,password varchar2(75) -- 账户密码
    ,status number(22) -- 0：创建中, 11：已启用,  22：停用中  3：已停用
    ,currency varchar2(5) -- 币种
    ,dn_ratio number(31,4) -- 等待补充
    ,threshold number(31,4) -- 等待补充
    ,large_pay_accno varchar2(75) -- 大额支付行号
    ,rate number(10,6) -- 利率
    ,bank_code varchar2(75) -- 开户银行行号
    ,bank_name varchar2(383) -- 开户银行名称
    ,open_date varchar2(15) -- 开户时间
    ,is_dvp varchar2(2) -- 1 是 0 否
    ,customer_id varchar2(45) -- 客户（交易对手）编码
    ,customer_name varchar2(150) -- 客户（交易对手）名称
    ,inner_accid varchar2(30) -- 内部资金账号id
    ,enabled varchar2(2) -- 启用--等待补充
    ,hands_bank_code varchar2(45) -- 农信银行号
    ,coupontype varchar2(15) -- 计息方式
    ,accounttype varchar2(2) -- 1-普通 2-保证金 3-特种
    ,inner_code varchar2(45) -- 内部账号
    ,oldinst_id varchar2(45) -- 记账机构
    ,inner_accname varchar2(180) -- 内部账名称
    ,payment_freq varchar2(9) -- 付息频率
    ,rate_def_id number(11,0) -- 利率定义id
    ,update_user varchar2(150) -- 更新者
    ,update_time varchar2(30) -- 更新时间
    ,create_time varchar2(30) -- 创建日期
    ,invest_type number(22) -- 0自有资产（自营业务）、1客户资产（代客、理财）
    ,pay_month number(22) -- 支付月份
    ,pay_day number(22) -- 支付日期
    ,i_id number(22) -- 机构号
    ,coupon number(10,6) -- 利率
    ,close_date varchar2(30) -- 销户时间
    ,p_type varchar2(30) -- 产品分类
    ,p_class varchar2(150) -- 产品类型
    ,subj_code varchar2(75) -- 科目号
    ,swift_code varchar2(150) -- swift_code
    ,mid_bank_acct_code varchar2(75) -- 中间行账号
    ,mid_bank_name varchar2(75) -- 中间行名称
    ,mid_swift_code varchar2(75) -- 中间行swift代码
    ,use_cash_acc number(1,0) -- swift报文是否含账号
    ,bank_legal_person_name varchar2(225) -- 开户行法人名称
    ,branch_bank_number varchar2(135) -- 存款行网点行号
    ,account_nature varchar2(225) -- 账户性质
    ,account_attribute varchar2(225) -- 账户属性
    ,cross_border_acc varchar2(48) -- 跨境同业往来账户
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
grant select on ${iol_schema}.ibms_ttrd_acc_cash_ext to ${iml_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_cash_ext to ${icl_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_cash_ext to ${idl_schema};
grant select on ${iol_schema}.ibms_ttrd_acc_cash_ext to ${iel_schema};

-- comment
comment on table ${iol_schema}.ibms_ttrd_acc_cash_ext is '一级资金账户表';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.accid is '账户代码';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.accname is '账户名称';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.markets is '交易市场';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.exhacc is '交易所账户';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.password is '账户密码';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.status is '0：创建中, 11：已启用,  22：停用中  3：已停用';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.currency is '币种';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.dn_ratio is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.threshold is '等待补充';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.large_pay_accno is '大额支付行号';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.rate is '利率';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.bank_code is '开户银行行号';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.bank_name is '开户银行名称';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.open_date is '开户时间';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.is_dvp is '1 是 0 否';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.customer_id is '客户（交易对手）编码';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.customer_name is '客户（交易对手）名称';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.inner_accid is '内部资金账号id';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.enabled is '启用--等待补充';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.hands_bank_code is '农信银行号';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.coupontype is '计息方式';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.accounttype is '1-普通 2-保证金 3-特种';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.inner_code is '内部账号';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.oldinst_id is '记账机构';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.inner_accname is '内部账名称';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.payment_freq is '付息频率';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.rate_def_id is '利率定义id';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.update_user is '更新者';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.update_time is '更新时间';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.create_time is '创建日期';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.invest_type is '0自有资产（自营业务）、1客户资产（代客、理财）';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.pay_month is '支付月份';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.pay_day is '支付日期';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.i_id is '机构号';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.coupon is '利率';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.close_date is '销户时间';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.p_type is '产品分类';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.p_class is '产品类型';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.subj_code is '科目号';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.swift_code is 'swift_code';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.mid_bank_acct_code is '中间行账号';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.mid_bank_name is '中间行名称';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.mid_swift_code is '中间行swift代码';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.use_cash_acc is 'swift报文是否含账号';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.bank_legal_person_name is '开户行法人名称';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.branch_bank_number is '存款行网点行号';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.account_nature is '账户性质';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.account_attribute is '账户属性';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.cross_border_acc is '跨境同业往来账户';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.start_dt is '开始时间';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.end_dt is '结束时间';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.id_mark is '增删标志';
comment on column ${iol_schema}.ibms_ttrd_acc_cash_ext.etl_timestamp is 'ETL处理时间戳';
