/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_afterloan_payment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_afterloan_payment
whenever sqlerror continue none;
drop table ${iol_schema}.icms_afterloan_payment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_afterloan_payment(
    serialno varchar2(64) -- 流水号
    ,updateuserid varchar2(8) -- 更新人
    ,violateamt number(16,2) -- 违约金金额
    ,objecttype varchar2(80) -- 关联对象类型
    ,actualpayinterestamt number(24,6) -- 实收利息
    ,payaccountno varchar2(64) -- 存款账户账号
    ,transno varchar2(64) -- 核心交易号
    ,updatedate date -- 更新日期
    ,prepayamtflag varchar2(36) -- 提前还款金额类型
    ,belongdept varchar2(36) -- 所属条线
    ,customerid varchar2(64) -- 客户编号
    ,actualpayinterestpenaltyamt number(24,6) -- 实收复息
    ,remark varchar2(2000) -- 备注
    ,prepayinterestamt number(24,6) -- 提前归还利息
    ,inputdate date -- 登记日期
    ,corporgid varchar2(64) -- 法人机构编号
    ,productid varchar2(64) -- 产品编号
    ,prepayinterestdaysflag varchar2(36) -- 提前还款计息模式
    ,transstatus varchar2(6) -- 交易状态
    ,updateorgid varchar2(64) -- 更新机构
    ,payaccountflag varchar2(36) -- 账户标志
    ,actualpayprincipalpenaltyamt number(24,6) -- 实收罚息
    ,payaccountname varchar2(160) -- 存款账户名称
    ,prepayprincipalamt number(24,6) -- 提前归还本金
    ,prepayfeeamt number(24,6) -- 提前归还费用
    ,excutedate date -- 交易日期
    ,transdate date -- 生效日期
    ,inputuserid varchar2(8) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,prepayinterestbaseflag varchar2(36) -- 提前还款计息基础
    ,prepayamt number(24,6) -- 提前还款金额
    ,payaccounttype varchar2(36) -- 账户类型
    ,loanno varchar2(64) -- 关联借据号
    ,transcode varchar2(64) -- 交易类型
    ,actualpayfeeamt number(24,6) -- 实收费用
    ,completeflag varchar2(2) -- 完成标志
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,customername varchar2(200) -- 客户名称
    ,payamt number(24,6) -- 还款总金额
    ,paymentcurrency varchar2(3) -- 币种
    ,applystatus varchar2(64) -- 申请状态
    ,actualpayprincipalamt number(24,6) -- 实收本金
    ,payruletype varchar2(36) -- 扣款顺序
    ,relativeserialno varchar2(64) -- 关联流水号
    ,prepaytype varchar2(36) -- 提前还款方式
    ,autopayflag varchar2(2) -- 是否在线支付
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
grant select on ${iol_schema}.icms_afterloan_payment to ${iml_schema};
grant select on ${iol_schema}.icms_afterloan_payment to ${icl_schema};
grant select on ${iol_schema}.icms_afterloan_payment to ${idl_schema};
grant select on ${iol_schema}.icms_afterloan_payment to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_afterloan_payment is '贷后还款交易表';
comment on column ${iol_schema}.icms_afterloan_payment.serialno is '流水号';
comment on column ${iol_schema}.icms_afterloan_payment.updateuserid is '更新人';
comment on column ${iol_schema}.icms_afterloan_payment.violateamt is '违约金金额';
comment on column ${iol_schema}.icms_afterloan_payment.objecttype is '关联对象类型';
comment on column ${iol_schema}.icms_afterloan_payment.actualpayinterestamt is '实收利息';
comment on column ${iol_schema}.icms_afterloan_payment.payaccountno is '存款账户账号';
comment on column ${iol_schema}.icms_afterloan_payment.transno is '核心交易号';
comment on column ${iol_schema}.icms_afterloan_payment.updatedate is '更新日期';
comment on column ${iol_schema}.icms_afterloan_payment.prepayamtflag is '提前还款金额类型';
comment on column ${iol_schema}.icms_afterloan_payment.belongdept is '所属条线';
comment on column ${iol_schema}.icms_afterloan_payment.customerid is '客户编号';
comment on column ${iol_schema}.icms_afterloan_payment.actualpayinterestpenaltyamt is '实收复息';
comment on column ${iol_schema}.icms_afterloan_payment.remark is '备注';
comment on column ${iol_schema}.icms_afterloan_payment.prepayinterestamt is '提前归还利息';
comment on column ${iol_schema}.icms_afterloan_payment.inputdate is '登记日期';
comment on column ${iol_schema}.icms_afterloan_payment.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_afterloan_payment.productid is '产品编号';
comment on column ${iol_schema}.icms_afterloan_payment.prepayinterestdaysflag is '提前还款计息模式';
comment on column ${iol_schema}.icms_afterloan_payment.transstatus is '交易状态';
comment on column ${iol_schema}.icms_afterloan_payment.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_afterloan_payment.payaccountflag is '账户标志';
comment on column ${iol_schema}.icms_afterloan_payment.actualpayprincipalpenaltyamt is '实收罚息';
comment on column ${iol_schema}.icms_afterloan_payment.payaccountname is '存款账户名称';
comment on column ${iol_schema}.icms_afterloan_payment.prepayprincipalamt is '提前归还本金';
comment on column ${iol_schema}.icms_afterloan_payment.prepayfeeamt is '提前归还费用';
comment on column ${iol_schema}.icms_afterloan_payment.excutedate is '交易日期';
comment on column ${iol_schema}.icms_afterloan_payment.transdate is '生效日期';
comment on column ${iol_schema}.icms_afterloan_payment.inputuserid is '登记人';
comment on column ${iol_schema}.icms_afterloan_payment.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_afterloan_payment.prepayinterestbaseflag is '提前还款计息基础';
comment on column ${iol_schema}.icms_afterloan_payment.prepayamt is '提前还款金额';
comment on column ${iol_schema}.icms_afterloan_payment.payaccounttype is '账户类型';
comment on column ${iol_schema}.icms_afterloan_payment.loanno is '关联借据号';
comment on column ${iol_schema}.icms_afterloan_payment.transcode is '交易类型';
comment on column ${iol_schema}.icms_afterloan_payment.actualpayfeeamt is '实收费用';
comment on column ${iol_schema}.icms_afterloan_payment.completeflag is '完成标志';
comment on column ${iol_schema}.icms_afterloan_payment.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_afterloan_payment.customername is '客户名称';
comment on column ${iol_schema}.icms_afterloan_payment.payamt is '还款总金额';
comment on column ${iol_schema}.icms_afterloan_payment.paymentcurrency is '币种';
comment on column ${iol_schema}.icms_afterloan_payment.applystatus is '申请状态';
comment on column ${iol_schema}.icms_afterloan_payment.actualpayprincipalamt is '实收本金';
comment on column ${iol_schema}.icms_afterloan_payment.payruletype is '扣款顺序';
comment on column ${iol_schema}.icms_afterloan_payment.relativeserialno is '关联流水号';
comment on column ${iol_schema}.icms_afterloan_payment.prepaytype is '提前还款方式';
comment on column ${iol_schema}.icms_afterloan_payment.autopayflag is '是否在线支付';
comment on column ${iol_schema}.icms_afterloan_payment.start_dt is '开始时间';
comment on column ${iol_schema}.icms_afterloan_payment.end_dt is '结束时间';
comment on column ${iol_schema}.icms_afterloan_payment.id_mark is '增删标志';
comment on column ${iol_schema}.icms_afterloan_payment.etl_timestamp is 'ETL处理时间戳';
