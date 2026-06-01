/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybkzd_loan_payment
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybkzd_loan_payment
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybkzd_loan_payment purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_loan_payment(
    serialno varchar2(32) -- 网商贷支用信贷流水号
    ,custiproleid varchar2(64) -- 客户IPROLEID
    ,requestid varchar2(256) -- 请求幂等ID
    ,creditno varchar2(64) -- 贷前授信的编号
    ,certtype varchar2(32) -- 借款人证件类型
    ,certname varchar2(512) -- 借款人证件名称
    ,certno varchar2(64) -- 借款人证件号码
    ,platformamt varchar2(64) -- 授信额度
    ,availableamt varchar2(64) -- 可用额度
    ,businessmodel varchar2(64) -- 与合作机构合作的业务模式
    ,businessscene varchar2(64) -- 与合作机构的业务场景
    ,businesstag varchar2(64) -- 与合作机构的业务标识
    ,loanmode varchar2(8) -- 出资模式
    ,loanuse varchar2(64) -- 资金用途
    ,encashamt varchar2(64) -- 申请放款金额(分)
    ,totalterms varchar2(64) -- 贷款期数
    ,termtype varchar2(8) -- 贷款期数单位
    ,repaymode varchar2(8) -- 还款方式
    ,ratetype varchar2(8) -- 利率类型
    ,rate varchar2(64) -- 实际放款利率(年利率)
    ,encashacctno varchar2(64) -- 收款账户
    ,encashacctname varchar2(128) -- 收款账户名
    ,isdirect varchar2(8) -- 是否受托支付
    ,entrustedpayment varchar2(64) -- 受托账号
    ,entrustedpaymentname varchar2(64) -- 受托账号户名
    ,custverifytype varchar2(64) -- 核身方式
    ,contracts varchar2(4000) -- 合同版本信息
    ,custverifyresult varchar2(8) -- 核身结果
    ,custverifytime varchar2(24) -- 核身通过时间
    ,customerid varchar2(64) -- 客户ID
    ,approvestatus varchar2(64) -- 审批状态
    ,extendfield1 varchar2(2000) -- 拓展字段1
    ,extendfield2 varchar2(64) -- 拓展字段2
    ,inputuserid varchar2(32) -- 登记人
    ,inputorgid varchar2(32) -- 登记单位
    ,inputdate varchar2(24) -- 登记日期
    ,updateuserid varchar2(32) -- 更新人
    ,updateorgid varchar2(32) -- 更新单位
    ,updatedate varchar2(24) -- 更新日期
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
grant select on ${iol_schema}.icms_mybkzd_loan_payment to ${iml_schema};
grant select on ${iol_schema}.icms_mybkzd_loan_payment to ${icl_schema};
grant select on ${iol_schema}.icms_mybkzd_loan_payment to ${idl_schema};
grant select on ${iol_schema}.icms_mybkzd_loan_payment to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybkzd_loan_payment is '网商贷助贷贷中支用信息表';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.serialno is '网商贷支用信贷流水号';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.custiproleid is '客户IPROLEID';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.requestid is '请求幂等ID';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.creditno is '贷前授信的编号';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.certtype is '借款人证件类型';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.certname is '借款人证件名称';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.certno is '借款人证件号码';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.platformamt is '授信额度';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.availableamt is '可用额度';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.businessmodel is '与合作机构合作的业务模式';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.businessscene is '与合作机构的业务场景';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.businesstag is '与合作机构的业务标识';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.loanmode is '出资模式';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.loanuse is '资金用途';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.encashamt is '申请放款金额(分)';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.totalterms is '贷款期数';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.termtype is '贷款期数单位';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.repaymode is '还款方式';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.ratetype is '利率类型';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.rate is '实际放款利率(年利率)';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.encashacctno is '收款账户';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.encashacctname is '收款账户名';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.isdirect is '是否受托支付';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.entrustedpayment is '受托账号';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.entrustedpaymentname is '受托账号户名';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.custverifytype is '核身方式';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.contracts is '合同版本信息';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.custverifyresult is '核身结果';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.custverifytime is '核身通过时间';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.customerid is '客户ID';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.approvestatus is '审批状态';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.extendfield1 is '拓展字段1';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.extendfield2 is '拓展字段2';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.inputuserid is '登记人';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.inputorgid is '登记单位';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.inputdate is '登记日期';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.updateuserid is '更新人';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.updateorgid is '更新单位';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.updatedate is '更新日期';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybkzd_loan_payment.etl_timestamp is 'ETL处理时间戳';
