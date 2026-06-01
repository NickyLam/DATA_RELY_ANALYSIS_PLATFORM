/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_lx_business_putout
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_lx_business_putout
whenever sqlerror continue none;
drop table ${iol_schema}.icms_lx_business_putout purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_lx_business_putout(
    serialno varchar2(64) -- 出账号
    ,contractserialno varchar2(64) -- 关联合同号
    ,customerid varchar2(32) -- 客户号
    ,customername varchar2(200) -- 客户名称
    ,applyid varchar2(32) -- 用信审批申请编号
    ,partnercode varchar2(20) -- 合作方代码
    ,productid varchar2(32) -- 产品编号
    ,creditno varchar2(32) -- 资方授信编号
    ,ordertype varchar2(10) -- 资产类型
    ,businesssum number(24,6) -- 借款金额
    ,currency varchar2(10) -- 币种
    ,startdate date -- 贷款发放日
    ,maturity date -- 贷款到期日
    ,fixedbillday varchar2(8) -- 固定出账日
    ,fixedrepayday varchar2(8) -- 固定还款日
    ,loanterm number(22) -- 借款期数
    ,annualrate number(15,2) -- 年化利率
    ,loanuse varchar2(32) -- 申请贷款用途
    ,mobileno varchar2(11) -- 手机号
    ,debitaccountname varchar2(64) -- 借款人收款户名
    ,debitopenaccountbank varchar2(64) -- 收款人银行卡开户行
    ,debitaccountno varchar2(64) -- 收款人银行卡卡号
    ,debitcnaps varchar2(64) -- 收款卡联行号
    ,repaytype varchar2(10) -- 乐信还款方式
    ,unionguaranteeflag varchar2(10) -- 是否联合融担
    ,approvestatus varchar2(32) -- 审批状态
    ,hxfkstatus varchar2(32) -- 核心放款状态
    ,hxfkmessage varchar2(1024) -- 核心放款失败信息
    ,hwzzstatus varchar2(32) -- 行外转账状态
    ,hwzzmessage varchar2(1024) -- 行外转账失败信息
    ,hxczstatus varchar2(32) -- 核心冲正状态
    ,hxczmessage varchar2(1024) -- 核心冲正失败信息
    ,inputdate date -- 登记时间
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记机构
    ,updatedate date -- 更新时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,paymenttime date -- 放款时间
    ,capitalloanno varchar2(64) -- 借据号
    ,hxfkseqnum varchar2(64) -- 核心交易流水号（用于冲正）
    ,gxzseqnum varchar2(64) -- 挂销账编号
    ,stzfseqnum varchar2(64) -- 受托支付全局流水号
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
grant select on ${iol_schema}.icms_lx_business_putout to ${iml_schema};
grant select on ${iol_schema}.icms_lx_business_putout to ${icl_schema};
grant select on ${iol_schema}.icms_lx_business_putout to ${idl_schema};
grant select on ${iol_schema}.icms_lx_business_putout to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_lx_business_putout is '乐信出账表';
comment on column ${iol_schema}.icms_lx_business_putout.serialno is '出账号';
comment on column ${iol_schema}.icms_lx_business_putout.contractserialno is '关联合同号';
comment on column ${iol_schema}.icms_lx_business_putout.customerid is '客户号';
comment on column ${iol_schema}.icms_lx_business_putout.customername is '客户名称';
comment on column ${iol_schema}.icms_lx_business_putout.applyid is '用信审批申请编号';
comment on column ${iol_schema}.icms_lx_business_putout.partnercode is '合作方代码';
comment on column ${iol_schema}.icms_lx_business_putout.productid is '产品编号';
comment on column ${iol_schema}.icms_lx_business_putout.creditno is '资方授信编号';
comment on column ${iol_schema}.icms_lx_business_putout.ordertype is '资产类型';
comment on column ${iol_schema}.icms_lx_business_putout.businesssum is '借款金额';
comment on column ${iol_schema}.icms_lx_business_putout.currency is '币种';
comment on column ${iol_schema}.icms_lx_business_putout.startdate is '贷款发放日';
comment on column ${iol_schema}.icms_lx_business_putout.maturity is '贷款到期日';
comment on column ${iol_schema}.icms_lx_business_putout.fixedbillday is '固定出账日';
comment on column ${iol_schema}.icms_lx_business_putout.fixedrepayday is '固定还款日';
comment on column ${iol_schema}.icms_lx_business_putout.loanterm is '借款期数';
comment on column ${iol_schema}.icms_lx_business_putout.annualrate is '年化利率';
comment on column ${iol_schema}.icms_lx_business_putout.loanuse is '申请贷款用途';
comment on column ${iol_schema}.icms_lx_business_putout.mobileno is '手机号';
comment on column ${iol_schema}.icms_lx_business_putout.debitaccountname is '借款人收款户名';
comment on column ${iol_schema}.icms_lx_business_putout.debitopenaccountbank is '收款人银行卡开户行';
comment on column ${iol_schema}.icms_lx_business_putout.debitaccountno is '收款人银行卡卡号';
comment on column ${iol_schema}.icms_lx_business_putout.debitcnaps is '收款卡联行号';
comment on column ${iol_schema}.icms_lx_business_putout.repaytype is '乐信还款方式';
comment on column ${iol_schema}.icms_lx_business_putout.unionguaranteeflag is '是否联合融担';
comment on column ${iol_schema}.icms_lx_business_putout.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_lx_business_putout.hxfkstatus is '核心放款状态';
comment on column ${iol_schema}.icms_lx_business_putout.hxfkmessage is '核心放款失败信息';
comment on column ${iol_schema}.icms_lx_business_putout.hwzzstatus is '行外转账状态';
comment on column ${iol_schema}.icms_lx_business_putout.hwzzmessage is '行外转账失败信息';
comment on column ${iol_schema}.icms_lx_business_putout.hxczstatus is '核心冲正状态';
comment on column ${iol_schema}.icms_lx_business_putout.hxczmessage is '核心冲正失败信息';
comment on column ${iol_schema}.icms_lx_business_putout.inputdate is '登记时间';
comment on column ${iol_schema}.icms_lx_business_putout.inputuserid is '登记人';
comment on column ${iol_schema}.icms_lx_business_putout.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_lx_business_putout.updatedate is '更新时间';
comment on column ${iol_schema}.icms_lx_business_putout.updateuserid is '更新人';
comment on column ${iol_schema}.icms_lx_business_putout.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_lx_business_putout.paymenttime is '放款时间';
comment on column ${iol_schema}.icms_lx_business_putout.capitalloanno is '借据号';
comment on column ${iol_schema}.icms_lx_business_putout.hxfkseqnum is '核心交易流水号（用于冲正）';
comment on column ${iol_schema}.icms_lx_business_putout.gxzseqnum is '挂销账编号';
comment on column ${iol_schema}.icms_lx_business_putout.stzfseqnum is '受托支付全局流水号';
comment on column ${iol_schema}.icms_lx_business_putout.start_dt is '开始时间';
comment on column ${iol_schema}.icms_lx_business_putout.end_dt is '结束时间';
comment on column ${iol_schema}.icms_lx_business_putout.id_mark is '增删标志';
comment on column ${iol_schema}.icms_lx_business_putout.etl_timestamp is 'ETL处理时间戳';
