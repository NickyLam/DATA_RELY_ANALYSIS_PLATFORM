/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybkzd_payment_notification
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybkzd_payment_notification
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybkzd_payment_notification purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybkzd_payment_notification(
    serialno varchar2(48) -- 信贷流水号
    ,requestid varchar2(256) -- 请求幂等ID
    ,custipid varchar2(64) -- 借款人在网商的会员ID
    ,custiproleid varchar2(64) -- 借款人在网商的会员角色ID
    ,businessmodel varchar2(64) -- 与合作机构合作的业务模式
    ,loanarno varchar2(64) -- 贷款合约号
    ,amount varchar2(16) -- 支用金额
    ,intrate varchar2(16) -- 初始年利率
    ,realintrate varchar2(16) -- 实际折后年利率
    ,putoutdate varchar2(16) -- 放款日期
    ,startdate varchar2(16) -- 贷款起始日期
    ,enddate varchar2(16) -- 贷款到期日期
    ,repaytype varchar2(8) -- 还款方式
    ,certtype varchar2(8) -- 证件类型
    ,certno varchar2(64) -- 客户证件号
    ,certname varchar2(512) -- 客户姓名
    ,platformamt varchar2(64) -- 授信额度
    ,isdirect varchar2(8) -- 是否受托支付
    ,encashacctno varchar2(64) -- 收款账户
    ,encashacctname varchar2(128) -- 收款账户名
    ,entrustedpay varchar2(64) -- 受托支付账户
    ,entrustedpaymentname varchar2(64) -- 受托支付账户名
    ,lendapproverequestid varchar2(256) -- 支用审批时的requestid
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
grant select on ${iol_schema}.icms_mybkzd_payment_notification to ${iml_schema};
grant select on ${iol_schema}.icms_mybkzd_payment_notification to ${icl_schema};
grant select on ${iol_schema}.icms_mybkzd_payment_notification to ${idl_schema};
grant select on ${iol_schema}.icms_mybkzd_payment_notification to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybkzd_payment_notification is '网商贷助贷支用放款通知信息表';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.serialno is '信贷流水号';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.requestid is '请求幂等ID';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.custipid is '借款人在网商的会员ID';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.custiproleid is '借款人在网商的会员角色ID';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.businessmodel is '与合作机构合作的业务模式';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.loanarno is '贷款合约号';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.amount is '支用金额';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.intrate is '初始年利率';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.realintrate is '实际折后年利率';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.putoutdate is '放款日期';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.startdate is '贷款起始日期';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.enddate is '贷款到期日期';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.repaytype is '还款方式';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.certtype is '证件类型';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.certno is '客户证件号';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.certname is '客户姓名';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.platformamt is '授信额度';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.isdirect is '是否受托支付';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.encashacctno is '收款账户';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.encashacctname is '收款账户名';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.entrustedpay is '受托支付账户';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.entrustedpaymentname is '受托支付账户名';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.lendapproverequestid is '支用审批时的requestid';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybkzd_payment_notification.etl_timestamp is 'ETL处理时间戳';
