/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lhwd_business_contract
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lhwd_business_contract
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lhwd_business_contract purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lhwd_business_contract(
    serialno varchar2(30) -- 流水号
    ,baserialno varchar2(64) -- 授信编号
    ,relacontractno varchar2(64) -- 关联合同编号
    ,artificialno varchar2(300) -- 文本合同编号
    ,applyno varchar2(64) -- 全局流水号（第三方）
    ,businessmodel varchar2(64) -- 业务模式（第三方）
    ,customerid varchar2(16) -- 客户编号
    ,customername varchar2(200) -- 客户名称
    ,businessflag varchar2(6) -- 合同标志
    ,currency varchar2(3) -- 币种
    ,businesssum number(24,6) -- 合同金额
    ,putoutsum number(24,6) -- 合同放款金额
    ,balance number(24,6) -- 合同余额
    ,availableamount number(24,6) -- 合同可用金额
    ,occupyamount number(24,6) -- 合同占用金额
    ,putoutdate date -- 合同放款日期
    ,productid varchar2(32) -- 产品编号（行内）
    ,productno varchar2(32) -- 产品编号（第三方）
    ,termmonth number(38,0) -- 期限(月)
    ,termday number(38,0) -- 期限(天)
    ,startdate date -- 合同开始日期
    ,maturity date -- 合同到期日期
    ,iscycle varchar2(5) -- 循环标志
    ,vouchtype varchar2(1) -- 担保方式
    ,repaytype varchar2(4) -- 还款方式
    ,paymenttype varchar2(36) -- 支付方式
    ,nationalindustrytype varchar2(32) -- 贷款投向行业
    ,loanusetype varchar2(32) -- 贷款用途
    ,repaycycle varchar2(32) -- 还款周期
    ,graceperiod varchar2(10) -- 宽限期
    ,baseratetype varchar2(4) -- 基准利率类型
    ,baserate number(15,8) -- 基准利率
    ,executerate number(24,8) -- 执行利率
    ,rateadjusttype varchar2(4) -- 执行利率调整方式
    ,rateadjustfrequency varchar2(32) -- 执行利率调整周期
    ,floatrange number(15,8) -- 执行利率浮动点差BP
    ,overduerate number(15,8) -- 逾期利率
    ,overdueratefloattype varchar2(72) -- 逾期利率浮动方式
    ,overdueratefloatvalue number(24,8) -- 逾期利率浮动比例（%）
    ,bankreservephone varchar2(16) -- 银行卡预留手机号
    ,paymentaccountno varchar2(64) -- 入账账户
    ,paymentaccountname varchar2(500) -- 入账账户名
    ,paymentaccountbankname varchar2(500) -- 入账账户开户机构
    ,paymentaccounttype varchar2(64) -- 入账账户类型
    ,repayaccountno varchar2(64) -- 还款账号
    ,repayaccounttype varchar2(64) -- 还款账户类型
    ,repayaccountname varchar2(500) -- 还款账户名
    ,repayaccountbankname varchar2(500) -- 还款账户开户机构
    ,putoutorgid varchar2(64) -- 出账机构编号(核心机构)
    ,status varchar2(48) -- 合同状态
    ,approvestatus varchar2(32) -- 审批状态
    ,bankcontriratio number(24,6) -- 银行出资比例
    ,creditchannel varchar2(32) -- 授信渠道
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新机构
    ,updatedate date -- 更新时间
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
grant select on ${iol_schema}.icms_lhwd_business_contract to ${iml_schema};
grant select on ${iol_schema}.icms_lhwd_business_contract to ${icl_schema};
grant select on ${iol_schema}.icms_lhwd_business_contract to ${idl_schema};
grant select on ${iol_schema}.icms_lhwd_business_contract to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lhwd_business_contract is '联合网贷合同表';
comment on column ${iol_schema}.icms_lhwd_business_contract.serialno is '流水号';
comment on column ${iol_schema}.icms_lhwd_business_contract.baserialno is '授信编号';
comment on column ${iol_schema}.icms_lhwd_business_contract.relacontractno is '关联合同编号';
comment on column ${iol_schema}.icms_lhwd_business_contract.artificialno is '文本合同编号';
comment on column ${iol_schema}.icms_lhwd_business_contract.applyno is '全局流水号（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_contract.businessmodel is '业务模式（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_contract.customerid is '客户编号';
comment on column ${iol_schema}.icms_lhwd_business_contract.customername is '客户名称';
comment on column ${iol_schema}.icms_lhwd_business_contract.businessflag is '合同标志';
comment on column ${iol_schema}.icms_lhwd_business_contract.currency is '币种';
comment on column ${iol_schema}.icms_lhwd_business_contract.businesssum is '合同金额';
comment on column ${iol_schema}.icms_lhwd_business_contract.putoutsum is '合同放款金额';
comment on column ${iol_schema}.icms_lhwd_business_contract.balance is '合同余额';
comment on column ${iol_schema}.icms_lhwd_business_contract.availableamount is '合同可用金额';
comment on column ${iol_schema}.icms_lhwd_business_contract.occupyamount is '合同占用金额';
comment on column ${iol_schema}.icms_lhwd_business_contract.putoutdate is '合同放款日期';
comment on column ${iol_schema}.icms_lhwd_business_contract.productid is '产品编号（行内）';
comment on column ${iol_schema}.icms_lhwd_business_contract.productno is '产品编号（第三方）';
comment on column ${iol_schema}.icms_lhwd_business_contract.termmonth is '期限(月)';
comment on column ${iol_schema}.icms_lhwd_business_contract.termday is '期限(天)';
comment on column ${iol_schema}.icms_lhwd_business_contract.startdate is '合同开始日期';
comment on column ${iol_schema}.icms_lhwd_business_contract.maturity is '合同到期日期';
comment on column ${iol_schema}.icms_lhwd_business_contract.iscycle is '循环标志';
comment on column ${iol_schema}.icms_lhwd_business_contract.vouchtype is '担保方式';
comment on column ${iol_schema}.icms_lhwd_business_contract.repaytype is '还款方式';
comment on column ${iol_schema}.icms_lhwd_business_contract.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_lhwd_business_contract.nationalindustrytype is '贷款投向行业';
comment on column ${iol_schema}.icms_lhwd_business_contract.loanusetype is '贷款用途';
comment on column ${iol_schema}.icms_lhwd_business_contract.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_lhwd_business_contract.graceperiod is '宽限期';
comment on column ${iol_schema}.icms_lhwd_business_contract.baseratetype is '基准利率类型';
comment on column ${iol_schema}.icms_lhwd_business_contract.baserate is '基准利率';
comment on column ${iol_schema}.icms_lhwd_business_contract.executerate is '执行利率';
comment on column ${iol_schema}.icms_lhwd_business_contract.rateadjusttype is '执行利率调整方式';
comment on column ${iol_schema}.icms_lhwd_business_contract.rateadjustfrequency is '执行利率调整周期';
comment on column ${iol_schema}.icms_lhwd_business_contract.floatrange is '执行利率浮动点差BP';
comment on column ${iol_schema}.icms_lhwd_business_contract.overduerate is '逾期利率';
comment on column ${iol_schema}.icms_lhwd_business_contract.overdueratefloattype is '逾期利率浮动方式';
comment on column ${iol_schema}.icms_lhwd_business_contract.overdueratefloatvalue is '逾期利率浮动比例（%）';
comment on column ${iol_schema}.icms_lhwd_business_contract.bankreservephone is '银行卡预留手机号';
comment on column ${iol_schema}.icms_lhwd_business_contract.paymentaccountno is '入账账户';
comment on column ${iol_schema}.icms_lhwd_business_contract.paymentaccountname is '入账账户名';
comment on column ${iol_schema}.icms_lhwd_business_contract.paymentaccountbankname is '入账账户开户机构';
comment on column ${iol_schema}.icms_lhwd_business_contract.paymentaccounttype is '入账账户类型';
comment on column ${iol_schema}.icms_lhwd_business_contract.repayaccountno is '还款账号';
comment on column ${iol_schema}.icms_lhwd_business_contract.repayaccounttype is '还款账户类型';
comment on column ${iol_schema}.icms_lhwd_business_contract.repayaccountname is '还款账户名';
comment on column ${iol_schema}.icms_lhwd_business_contract.repayaccountbankname is '还款账户开户机构';
comment on column ${iol_schema}.icms_lhwd_business_contract.putoutorgid is '出账机构编号(核心机构)';
comment on column ${iol_schema}.icms_lhwd_business_contract.status is '合同状态';
comment on column ${iol_schema}.icms_lhwd_business_contract.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_lhwd_business_contract.bankcontriratio is '银行出资比例';
comment on column ${iol_schema}.icms_lhwd_business_contract.creditchannel is '授信渠道';
comment on column ${iol_schema}.icms_lhwd_business_contract.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lhwd_business_contract.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lhwd_business_contract.inputdate is '登记日期';
comment on column ${iol_schema}.icms_lhwd_business_contract.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lhwd_business_contract.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lhwd_business_contract.updatedate is '更新时间';
comment on column ${iol_schema}.icms_lhwd_business_contract.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lhwd_business_contract.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lhwd_business_contract.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lhwd_business_contract.etl_timestamp is 'ETL处理时间戳';
