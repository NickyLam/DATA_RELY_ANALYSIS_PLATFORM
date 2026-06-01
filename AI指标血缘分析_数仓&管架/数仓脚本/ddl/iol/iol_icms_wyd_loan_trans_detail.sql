/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_wyd_loan_trans_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_wyd_loan_trans_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_wyd_loan_trans_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wyd_loan_trans_detail(
    consumertransid varchar2(40) -- 核心流水号
    ,systransid varchar2(32) -- 系统调用流水号
    ,txnseq varchar2(40) -- 交易流水号
    ,txndate varchar2(10) -- 交易日期
    ,orgid varchar2(20) -- 机构号
    ,logicalcardno varchar2(32) -- 逻辑卡号
    ,lendingref varchar2(64) -- 借据号
    ,currcd varchar2(10) -- 币种
    ,txncode varchar2(10) -- 交易码
    ,txndesc varchar2(400) -- 交易描述
    ,dbcrind varchar2(2) -- 借贷标记
    ,postamt number(22,4) -- 入账金额
    ,postglind varchar2(5) -- 入账方式
    ,owningbranch varchar2(32) -- 支行
    ,subject varchar2(20) -- 科目
    ,redflag varchar2(2) -- 红蓝字标识
    ,queue varchar2(32) -- 排序
    ,agegroup varchar2(32) -- 账龄组
    ,bnpgroup varchar2(32) -- 余额成分组
    ,bankgroupid varchar2(32) -- 银团代码
    ,bankno varchar2(32) -- 银行代码
    ,term varchar2(10) -- 期数
    ,batchdate varchar2(10) -- 交易日期
    ,txntime varchar2(20) -- 交易时间
    ,acctno varchar2(40) -- 帐号
    ,accttype varchar2(10) -- 账户类型
    ,txnbalance number(22,4) -- 账户余额
    ,cashflag varchar2(1) -- 现转标志
    ,postdate varchar2(10) -- 入账日期
    ,posttime varchar2(20) -- 入账时间
    ,youracctno varchar2(40) -- 对方账号
    ,youracctname varchar2(100) -- 对方户名
    ,yourbankid varchar2(40) -- 对方行号
    ,yourbankname varchar2(100) -- 对方行名
    ,qchannelid varchar2(10) -- 交易渠道编号
    ,trasnuser varchar2(50) -- 交易柜员号
    ,uesrserno varchar2(32) -- 柜员流水号
    ,authuser varchar2(50) -- 授权柜员号
    ,vouchertype varchar2(32) -- 主凭证种类
    ,voucherno varchar2(32) -- 主凭证号
    ,transflag varchar2(1) -- 冲补抹标志
    ,agentname varchar2(100) -- 代办人姓名
    ,agentidtype varchar2(10) -- 代办人证件类别
    ,agentidno varchar2(32) -- 代办人证件号码
    ,payeracct varchar2(40) -- 付款人账号
    ,payername varchar2(100) -- 付款人名称
    ,payerbrno varchar2(40) -- 付款人开户行行号
    ,payerbrname varchar2(100) -- 付款人开户行名称
    ,payeeacct varchar2(40) -- 收款人账号
    ,payeename varchar2(100) -- 收款人名称
    ,payeebrno varchar2(40) -- 收款人开户行行号
    ,payeebrname varchar2(100) -- 收款人开户行名称
    ,settleid varchar2(100) -- 还款清算交易编号
    ,inputuserid varchar2(64) -- 登记人
    ,inputorgid varchar2(64) -- 登记人所属机构
    ,inputdate date -- 登记时间
    ,updateuserid varchar2(64) -- 更新人
    ,updateorgid varchar2(64) -- 更新机构
    ,updatedate date -- 更新日期
    ,customerid varchar2(64) -- 我行客户号
    ,productid varchar2(64) -- 产品编号
    ,classifyresult varchar2(24) -- 废除五级分类
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.icms_wyd_loan_trans_detail to ${iml_schema};
grant select on ${iol_schema}.icms_wyd_loan_trans_detail to ${icl_schema};
grant select on ${iol_schema}.icms_wyd_loan_trans_detail to ${idl_schema};
grant select on ${iol_schema}.icms_wyd_loan_trans_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_wyd_loan_trans_detail is '贷款交易流水';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.consumertransid is '核心流水号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.systransid is '系统调用流水号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.txnseq is '交易流水号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.txndate is '交易日期';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.orgid is '机构号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.logicalcardno is '逻辑卡号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.lendingref is '借据号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.currcd is '币种';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.txncode is '交易码';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.txndesc is '交易描述';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.dbcrind is '借贷标记';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.postamt is '入账金额';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.postglind is '入账方式';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.owningbranch is '支行';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.subject is '科目';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.redflag is '红蓝字标识';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.queue is '排序';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.agegroup is '账龄组';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.bnpgroup is '余额成分组';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.bankgroupid is '银团代码';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.bankno is '银行代码';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.term is '期数';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.batchdate is '交易日期';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.txntime is '交易时间';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.acctno is '帐号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.accttype is '账户类型';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.txnbalance is '账户余额';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.cashflag is '现转标志';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.postdate is '入账日期';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.posttime is '入账时间';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.youracctno is '对方账号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.youracctname is '对方户名';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.yourbankid is '对方行号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.yourbankname is '对方行名';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.qchannelid is '交易渠道编号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.trasnuser is '交易柜员号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.uesrserno is '柜员流水号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.authuser is '授权柜员号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.vouchertype is '主凭证种类';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.voucherno is '主凭证号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.transflag is '冲补抹标志';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.agentname is '代办人姓名';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.agentidtype is '代办人证件类别';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.agentidno is '代办人证件号码';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.payeracct is '付款人账号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.payername is '付款人名称';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.payerbrno is '付款人开户行行号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.payerbrname is '付款人开户行名称';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.payeeacct is '收款人账号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.payeename is '收款人名称';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.payeebrno is '收款人开户行行号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.payeebrname is '收款人开户行名称';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.settleid is '还款清算交易编号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.inputuserid is '登记人';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.inputorgid is '登记人所属机构';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.inputdate is '登记时间';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.updateuserid is '更新人';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.updateorgid is '更新机构';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.updatedate is '更新日期';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.customerid is '我行客户号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.productid is '产品编号';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.classifyresult is '废除五级分类';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_wyd_loan_trans_detail.etl_timestamp is 'ETL处理时间戳';
