/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bp_upl_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bp_upl_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bp_upl_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bp_upl_loan(
    serialno varchar2(32) -- 出账流水号
    ,paybankno varchar2(20) -- 收款人行号
    ,mfcustomerid varchar2(32) -- 核心客户编号
    ,migtflag varchar2(80) -- 
    ,oldtradedate date -- 原交易日期
    ,oldtradeserialno varchar2(18) -- 原交易流水号
    ,loanterm varchar2(18) -- 贷款期限
    ,vouchmode varchar2(10) -- 担保方式
    ,repaymode varchar2(10) -- 付款方式
    ,begintime date -- 开始时间
    ,loankind varchar2(10) -- 期限类型
    ,trustpayaccountno varchar2(32) -- 受托支付账号
    ,paysource varchar2(500) -- 还款说明
    ,loantype varchar2(18) -- 贷款类型
    ,businessserialno varchar2(40) -- 交易流水号
    ,warrantorid varchar2(32) -- 主要担保人编码
    ,warrantor varchar2(132) -- 主要担保人
    ,uplaccountno varchar2(32) -- 微贷结算账号
    ,stayentrustnumber number(22) -- 待受托划款的笔数
    ,paybankaddcode varchar2(200) -- 收款人开户行地点
    ,holdcorpus number(20,4) -- 保留本金
    ,crstranseqno varchar2(40) -- 正向交易流水号
    ,uplpayaccountno2 varchar2(32) -- 微贷还款账户2
    ,paybankname varchar2(80) -- 收款人行名
    ,subbusinesstype varchar2(32) -- 助贷业务品种
    ,uplpayaccountno1 varchar2(32) -- 微贷还款账户1
    ,tradedate date -- 交易日期
    ,putoutstatus varchar2(2) -- 出账状态
    ,bankinoutflag varchar2(18) -- 行内外标识
    ,errorinfo varchar2(200) -- 错误信息
    ,paybankkindcode varchar2(18) -- 收款人开户行类别
    ,trustpayaccountname varchar2(80) -- 受托支付户名
    ,batchpaymentflag varchar2(1) -- 是否参与批扣
    ,userid varchar2(32) -- 用户编号
    ,payaccountno2 varchar2(40) -- 第二还款账户
    ,actualbegintime date -- 实际开始时间
    ,exchangetype varchar2(18) -- 交易类型
    ,payprinintvl number(22) -- 贷款还息间隔
    ,incomeorgid varchar2(32) -- 入账机构
    ,payaccountname2 varchar2(80) -- 第二还款账户名
    ,crstrandate date -- 正向交易日期
    ,paymentmode varchar2(18) -- 
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
grant select on ${iol_schema}.icms_bp_upl_loan to ${iml_schema};
grant select on ${iol_schema}.icms_bp_upl_loan to ${icl_schema};
grant select on ${iol_schema}.icms_bp_upl_loan to ${idl_schema};
grant select on ${iol_schema}.icms_bp_upl_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bp_upl_loan is '出账微贷附属表';
comment on column ${iol_schema}.icms_bp_upl_loan.serialno is '出账流水号';
comment on column ${iol_schema}.icms_bp_upl_loan.paybankno is '收款人行号';
comment on column ${iol_schema}.icms_bp_upl_loan.mfcustomerid is '核心客户编号';
comment on column ${iol_schema}.icms_bp_upl_loan.migtflag is '';
comment on column ${iol_schema}.icms_bp_upl_loan.oldtradedate is '原交易日期';
comment on column ${iol_schema}.icms_bp_upl_loan.oldtradeserialno is '原交易流水号';
comment on column ${iol_schema}.icms_bp_upl_loan.loanterm is '贷款期限';
comment on column ${iol_schema}.icms_bp_upl_loan.vouchmode is '担保方式';
comment on column ${iol_schema}.icms_bp_upl_loan.repaymode is '付款方式';
comment on column ${iol_schema}.icms_bp_upl_loan.begintime is '开始时间';
comment on column ${iol_schema}.icms_bp_upl_loan.loankind is '期限类型';
comment on column ${iol_schema}.icms_bp_upl_loan.trustpayaccountno is '受托支付账号';
comment on column ${iol_schema}.icms_bp_upl_loan.paysource is '还款说明';
comment on column ${iol_schema}.icms_bp_upl_loan.loantype is '贷款类型';
comment on column ${iol_schema}.icms_bp_upl_loan.businessserialno is '交易流水号';
comment on column ${iol_schema}.icms_bp_upl_loan.warrantorid is '主要担保人编码';
comment on column ${iol_schema}.icms_bp_upl_loan.warrantor is '主要担保人';
comment on column ${iol_schema}.icms_bp_upl_loan.uplaccountno is '微贷结算账号';
comment on column ${iol_schema}.icms_bp_upl_loan.stayentrustnumber is '待受托划款的笔数';
comment on column ${iol_schema}.icms_bp_upl_loan.paybankaddcode is '收款人开户行地点';
comment on column ${iol_schema}.icms_bp_upl_loan.holdcorpus is '保留本金';
comment on column ${iol_schema}.icms_bp_upl_loan.crstranseqno is '正向交易流水号';
comment on column ${iol_schema}.icms_bp_upl_loan.uplpayaccountno2 is '微贷还款账户2';
comment on column ${iol_schema}.icms_bp_upl_loan.paybankname is '收款人行名';
comment on column ${iol_schema}.icms_bp_upl_loan.subbusinesstype is '助贷业务品种';
comment on column ${iol_schema}.icms_bp_upl_loan.uplpayaccountno1 is '微贷还款账户1';
comment on column ${iol_schema}.icms_bp_upl_loan.tradedate is '交易日期';
comment on column ${iol_schema}.icms_bp_upl_loan.putoutstatus is '出账状态';
comment on column ${iol_schema}.icms_bp_upl_loan.bankinoutflag is '行内外标识';
comment on column ${iol_schema}.icms_bp_upl_loan.errorinfo is '错误信息';
comment on column ${iol_schema}.icms_bp_upl_loan.paybankkindcode is '收款人开户行类别';
comment on column ${iol_schema}.icms_bp_upl_loan.trustpayaccountname is '受托支付户名';
comment on column ${iol_schema}.icms_bp_upl_loan.batchpaymentflag is '是否参与批扣';
comment on column ${iol_schema}.icms_bp_upl_loan.userid is '用户编号';
comment on column ${iol_schema}.icms_bp_upl_loan.payaccountno2 is '第二还款账户';
comment on column ${iol_schema}.icms_bp_upl_loan.actualbegintime is '实际开始时间';
comment on column ${iol_schema}.icms_bp_upl_loan.exchangetype is '交易类型';
comment on column ${iol_schema}.icms_bp_upl_loan.payprinintvl is '贷款还息间隔';
comment on column ${iol_schema}.icms_bp_upl_loan.incomeorgid is '入账机构';
comment on column ${iol_schema}.icms_bp_upl_loan.payaccountname2 is '第二还款账户名';
comment on column ${iol_schema}.icms_bp_upl_loan.crstrandate is '正向交易日期';
comment on column ${iol_schema}.icms_bp_upl_loan.paymentmode is '';
comment on column ${iol_schema}.icms_bp_upl_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bp_upl_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bp_upl_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bp_upl_loan.etl_timestamp is 'ETL处理时间戳';
