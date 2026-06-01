/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_payment_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_payment_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_payment_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_payment_info(
    serialno varchar2(64) -- 支付流水号
    ,maxpaydate date -- 最迟支付日
    ,entrustedno varchar2(32) -- 受托支付编号
    ,pigeonholedate date -- 归档日期
    ,updateorgid varchar2(64) -- 更新机构
    ,corporgid varchar2(64) -- 法人机构编号
    ,updatedate date -- 更新日期
    ,zfjyserialno varchar2(40) -- 在线受托支付-止付交易流水号
    ,putoutserialno varchar2(64) -- 放贷流水号
    ,paymentdate date -- 支付日期
    ,payeename varchar2(160) -- 收款人名称
    ,docid varchar2(64) -- 交易代码
    ,inputorgid varchar2(64) -- 登记机构
    ,sequencenum varchar2(32) -- 支付序列号
    ,resenddatetime date -- 重新发送时间
    ,capitalpurpose varchar2(1000) -- 资金用途
    ,inputdate date -- 登记日期
    ,transeqno varchar2(64) -- 平台请求流水号
    ,confirmstatus varchar2(36) -- 确认状态
    ,isreservepay varchar2(12) -- 是否预约受托支付
    ,rowno varchar2(64) -- 明细流水号
    ,objectno varchar2(40) -- 受托支付汇总记录编号
    ,remark varchar2(1000) -- 备注
    ,cause varchar2(255) -- 支付失败原因
    ,batchno varchar2(40) -- 受托支付批次号
    ,transformno varchar2(40) -- 平台交易流水号
    ,freezeseqno varchar2(64) -- 冻结流水号
    ,isinneraccount varchar2(8) -- 是否行内账号
    ,actualpaydate date -- 实际支付日期
    ,zfserialno varchar2(40) -- 止付流水号
    ,iskj varchar2(10) -- 是否跨境
    ,customerid varchar2(32) -- 客户编号
    ,payeebank varchar2(200) -- 收款人开户行
    ,currency varchar2(3) -- 币种
    ,inputuserid varchar2(64) -- 登记人
    ,paystatus varchar2(10) -- 在线受托支付-支付状态码值BillPayStatus
    ,paymenttime varchar2(2) -- 支付时间（10/15）
    ,updateuserid varchar2(64) -- 更新人
    ,zfdate varchar2(10) -- 止付交易日期
    ,plattrxseq varchar2(40) -- 在线受托支付-原交易平台流水号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,payeeaccount varchar2(80) -- 收款账户号
    ,payeebankname varchar2(200) -- 转入行名
    ,customername varchar2(200) -- 客户名称
    ,paymentsum number(24,6) -- 支付金额
    ,paymentstatus varchar2(36) -- 支付状态
    ,trxdate varchar2(10) -- 平台交易日期
    ,entrustedpayid number(10,0) -- 受托支付序号
    ,isinuse varchar2(1) -- 添加维护标志1正常2不维护
    ,resendstatus varchar2(36) -- 重发状态
    ,isbankaccount varchar2(1) -- 是否是本行客户
    ,payeenameadd varchar2(255) -- 收款人地址
    ,capitalpurposedesc varchar2(500) -- 贷款用途描述
    ,paymenttype varchar2(36) -- 
    ,payeecertid varchar2(60) -- 
    ,bcsacctseqnum varchar2(64) -- 
    ,commodityamt number(20,2) -- 
    ,businessname varchar2(200) -- 
    ,businesscertcode varchar2(30) -- 
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
grant select on ${iol_schema}.icms_payment_info to ${iml_schema};
grant select on ${iol_schema}.icms_payment_info to ${icl_schema};
grant select on ${iol_schema}.icms_payment_info to ${idl_schema};
grant select on ${iol_schema}.icms_payment_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_payment_info is '支付信息表支付信息表';
comment on column ${iol_schema}.icms_payment_info.serialno is '支付流水号';
comment on column ${iol_schema}.icms_payment_info.maxpaydate is '最迟支付日';
comment on column ${iol_schema}.icms_payment_info.entrustedno is '受托支付编号';
comment on column ${iol_schema}.icms_payment_info.pigeonholedate is '归档日期';
comment on column ${iol_schema}.icms_payment_info.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_payment_info.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_payment_info.updatedate is '更新日期';
comment on column ${iol_schema}.icms_payment_info.zfjyserialno is '在线受托支付-止付交易流水号';
comment on column ${iol_schema}.icms_payment_info.putoutserialno is '放贷流水号';
comment on column ${iol_schema}.icms_payment_info.paymentdate is '支付日期';
comment on column ${iol_schema}.icms_payment_info.payeename is '收款人名称';
comment on column ${iol_schema}.icms_payment_info.docid is '交易代码';
comment on column ${iol_schema}.icms_payment_info.inputorgid is '登记机构';
comment on column ${iol_schema}.icms_payment_info.sequencenum is '支付序列号';
comment on column ${iol_schema}.icms_payment_info.resenddatetime is '重新发送时间';
comment on column ${iol_schema}.icms_payment_info.capitalpurpose is '资金用途';
comment on column ${iol_schema}.icms_payment_info.inputdate is '登记日期';
comment on column ${iol_schema}.icms_payment_info.transeqno is '平台请求流水号';
comment on column ${iol_schema}.icms_payment_info.confirmstatus is '确认状态';
comment on column ${iol_schema}.icms_payment_info.isreservepay is '是否预约受托支付';
comment on column ${iol_schema}.icms_payment_info.rowno is '明细流水号';
comment on column ${iol_schema}.icms_payment_info.objectno is '受托支付汇总记录编号';
comment on column ${iol_schema}.icms_payment_info.remark is '备注';
comment on column ${iol_schema}.icms_payment_info.cause is '支付失败原因';
comment on column ${iol_schema}.icms_payment_info.batchno is '受托支付批次号';
comment on column ${iol_schema}.icms_payment_info.transformno is '平台交易流水号';
comment on column ${iol_schema}.icms_payment_info.freezeseqno is '冻结流水号';
comment on column ${iol_schema}.icms_payment_info.isinneraccount is '是否行内账号';
comment on column ${iol_schema}.icms_payment_info.actualpaydate is '实际支付日期';
comment on column ${iol_schema}.icms_payment_info.zfserialno is '止付流水号';
comment on column ${iol_schema}.icms_payment_info.iskj is '是否跨境';
comment on column ${iol_schema}.icms_payment_info.customerid is '客户编号';
comment on column ${iol_schema}.icms_payment_info.payeebank is '收款人开户行';
comment on column ${iol_schema}.icms_payment_info.currency is '币种';
comment on column ${iol_schema}.icms_payment_info.inputuserid is '登记人';
comment on column ${iol_schema}.icms_payment_info.paystatus is '在线受托支付-支付状态码值BillPayStatus';
comment on column ${iol_schema}.icms_payment_info.paymenttime is '支付时间（10/15）';
comment on column ${iol_schema}.icms_payment_info.updateuserid is '更新人';
comment on column ${iol_schema}.icms_payment_info.zfdate is '止付交易日期';
comment on column ${iol_schema}.icms_payment_info.plattrxseq is '在线受托支付-原交易平台流水号';
comment on column ${iol_schema}.icms_payment_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_payment_info.payeeaccount is '收款账户号';
comment on column ${iol_schema}.icms_payment_info.payeebankname is '转入行名';
comment on column ${iol_schema}.icms_payment_info.customername is '客户名称';
comment on column ${iol_schema}.icms_payment_info.paymentsum is '支付金额';
comment on column ${iol_schema}.icms_payment_info.paymentstatus is '支付状态';
comment on column ${iol_schema}.icms_payment_info.trxdate is '平台交易日期';
comment on column ${iol_schema}.icms_payment_info.entrustedpayid is '受托支付序号';
comment on column ${iol_schema}.icms_payment_info.isinuse is '添加维护标志1正常2不维护';
comment on column ${iol_schema}.icms_payment_info.resendstatus is '重发状态';
comment on column ${iol_schema}.icms_payment_info.isbankaccount is '是否是本行客户';
comment on column ${iol_schema}.icms_payment_info.payeenameadd is '收款人地址';
comment on column ${iol_schema}.icms_payment_info.capitalpurposedesc is '贷款用途描述';
comment on column ${iol_schema}.icms_payment_info.paymenttype is '';
comment on column ${iol_schema}.icms_payment_info.payeecertid is '';
comment on column ${iol_schema}.icms_payment_info.bcsacctseqnum is '';
comment on column ${iol_schema}.icms_payment_info.commodityamt is '';
comment on column ${iol_schema}.icms_payment_info.businessname is '';
comment on column ${iol_schema}.icms_payment_info.businesscertcode is '';
comment on column ${iol_schema}.icms_payment_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_payment_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_payment_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_payment_info.etl_timestamp is 'ETL处理时间戳';
