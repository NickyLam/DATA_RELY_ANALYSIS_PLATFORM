/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_zjbk_business_putout
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_zjbk_business_putout
whenever sqlerror continue none;
drop table ${iol_schema}.icms_zjbk_business_putout purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_business_putout(
    serialno varchar2(64) -- 流水号
    ,loanid varchar2(64) -- 借款流水号
    ,accountid varchar2(64) -- 授信ID
    ,mchid varchar2(32) -- 商户号
    ,appid varchar2(32) -- 商户应用ID
    ,orderno varchar2(64) -- 放款支付订单号
    ,tradetime varchar2(64) -- 放款发起时间
    ,finishtime varchar2(64) -- 放款完成时间
    ,status varchar2(64) -- 状态
    ,amount varchar2(64) -- 放款总金额
    ,currency varchar2(16) -- 字节币种
    ,cardid varchar2(32) -- 银行卡号
    ,accountname varchar2(200) -- 账户名称
    ,accounttype varchar2(64) -- 银行卡类型
    ,cnapscode varchar2(32) -- 联行号
    ,extinfo varchar2(4000) -- 其他信息
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,inputdate date -- 登记日期
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,tradeno varchar2(64) -- 抖音放款订单号
    ,contractserialno varchar2(64) -- 关联合同流水号
    ,currdate date -- 账务日期
    ,leader varchar2(32) -- 牵头方
    ,partner varchar2(32) -- 合作方
    ,customerid varchar2(16) -- 客户号
    ,customername varchar2(200) -- 客户名称
    ,certtype varchar2(32) -- 证件类型
    ,certid varchar2(128) -- 证件号码
    ,applydate date -- 申请日期
    ,startdate date -- 确认日期
    ,enddate date -- 到期日
    ,productid varchar2(32) -- 产品编号
    ,intrate number(24,6) -- 利率
    ,termmonth varchar2(10) -- 期限月
    ,usage varchar2(10) -- 用途
    ,repaytype varchar2(10) -- 还款方式
    ,repaycycle varchar2(10) -- 还款周期
    ,periods number(10,0) -- 总期数
    ,graceperiod number(10,0) -- 宽限期
    ,putoutstatus varchar2(10) -- 放款状态
    ,outloanchannelno varchar2(64) -- 平台订单号
    ,loanresptime varchar2(64) -- 支付返回成功时间
    ,counterpartyaccounttype varchar2(2) -- 交易对象账户类型
    ,counterpartyname varchar2(64) -- 交易对象开户机构
    ,counterpartyaccountno varchar2(64) -- 交易对象账号
    ,bankaccounttype varchar2(64) -- 银行卡类型
    ,bankphone varchar2(64) -- 放款账户手机号
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
grant select on ${iol_schema}.icms_zjbk_business_putout to ${iml_schema};
grant select on ${iol_schema}.icms_zjbk_business_putout to ${icl_schema};
grant select on ${iol_schema}.icms_zjbk_business_putout to ${idl_schema};
grant select on ${iol_schema}.icms_zjbk_business_putout to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_zjbk_business_putout is '字节出账放款表';
comment on column ${iol_schema}.icms_zjbk_business_putout.serialno is '流水号';
comment on column ${iol_schema}.icms_zjbk_business_putout.loanid is '借款流水号';
comment on column ${iol_schema}.icms_zjbk_business_putout.accountid is '授信ID';
comment on column ${iol_schema}.icms_zjbk_business_putout.mchid is '商户号';
comment on column ${iol_schema}.icms_zjbk_business_putout.appid is '商户应用ID';
comment on column ${iol_schema}.icms_zjbk_business_putout.orderno is '放款支付订单号';
comment on column ${iol_schema}.icms_zjbk_business_putout.tradetime is '放款发起时间';
comment on column ${iol_schema}.icms_zjbk_business_putout.finishtime is '放款完成时间';
comment on column ${iol_schema}.icms_zjbk_business_putout.status is '状态';
comment on column ${iol_schema}.icms_zjbk_business_putout.amount is '放款总金额';
comment on column ${iol_schema}.icms_zjbk_business_putout.currency is '字节币种';
comment on column ${iol_schema}.icms_zjbk_business_putout.cardid is '银行卡号';
comment on column ${iol_schema}.icms_zjbk_business_putout.accountname is '账户名称';
comment on column ${iol_schema}.icms_zjbk_business_putout.accounttype is '银行卡类型';
comment on column ${iol_schema}.icms_zjbk_business_putout.cnapscode is '联行号';
comment on column ${iol_schema}.icms_zjbk_business_putout.extinfo is '其他信息';
comment on column ${iol_schema}.icms_zjbk_business_putout.inputuserid is '登记人';
comment on column ${iol_schema}.icms_zjbk_business_putout.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_zjbk_business_putout.inputdate is '登记日期';
comment on column ${iol_schema}.icms_zjbk_business_putout.updateuserid is '更新人';
comment on column ${iol_schema}.icms_zjbk_business_putout.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_zjbk_business_putout.updatedate is '更新日期';
comment on column ${iol_schema}.icms_zjbk_business_putout.tradeno is '抖音放款订单号';
comment on column ${iol_schema}.icms_zjbk_business_putout.contractserialno is '关联合同流水号';
comment on column ${iol_schema}.icms_zjbk_business_putout.currdate is '账务日期';
comment on column ${iol_schema}.icms_zjbk_business_putout.leader is '牵头方';
comment on column ${iol_schema}.icms_zjbk_business_putout.partner is '合作方';
comment on column ${iol_schema}.icms_zjbk_business_putout.customerid is '客户号';
comment on column ${iol_schema}.icms_zjbk_business_putout.customername is '客户名称';
comment on column ${iol_schema}.icms_zjbk_business_putout.certtype is '证件类型';
comment on column ${iol_schema}.icms_zjbk_business_putout.certid is '证件号码';
comment on column ${iol_schema}.icms_zjbk_business_putout.applydate is '申请日期';
comment on column ${iol_schema}.icms_zjbk_business_putout.startdate is '确认日期';
comment on column ${iol_schema}.icms_zjbk_business_putout.enddate is '到期日';
comment on column ${iol_schema}.icms_zjbk_business_putout.productid is '产品编号';
comment on column ${iol_schema}.icms_zjbk_business_putout.intrate is '利率';
comment on column ${iol_schema}.icms_zjbk_business_putout.termmonth is '期限月';
comment on column ${iol_schema}.icms_zjbk_business_putout.usage is '用途';
comment on column ${iol_schema}.icms_zjbk_business_putout.repaytype is '还款方式';
comment on column ${iol_schema}.icms_zjbk_business_putout.repaycycle is '还款周期';
comment on column ${iol_schema}.icms_zjbk_business_putout.periods is '总期数';
comment on column ${iol_schema}.icms_zjbk_business_putout.graceperiod is '宽限期';
comment on column ${iol_schema}.icms_zjbk_business_putout.putoutstatus is '放款状态';
comment on column ${iol_schema}.icms_zjbk_business_putout.outloanchannelno is '平台订单号';
comment on column ${iol_schema}.icms_zjbk_business_putout.loanresptime is '支付返回成功时间';
comment on column ${iol_schema}.icms_zjbk_business_putout.counterpartyaccounttype is '交易对象账户类型';
comment on column ${iol_schema}.icms_zjbk_business_putout.counterpartyname is '交易对象开户机构';
comment on column ${iol_schema}.icms_zjbk_business_putout.counterpartyaccountno is '交易对象账号';
comment on column ${iol_schema}.icms_zjbk_business_putout.bankaccounttype is '银行卡类型';
comment on column ${iol_schema}.icms_zjbk_business_putout.bankphone is '放款账户手机号';
comment on column ${iol_schema}.icms_zjbk_business_putout.start_dt is '开始时间';
comment on column ${iol_schema}.icms_zjbk_business_putout.end_dt is '结束时间';
comment on column ${iol_schema}.icms_zjbk_business_putout.id_mark is '增删标志';
comment on column ${iol_schema}.icms_zjbk_business_putout.etl_timestamp is 'ETL处理时间戳';
