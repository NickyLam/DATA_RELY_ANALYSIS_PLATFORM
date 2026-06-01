/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_bap_upl_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_bap_upl_loan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_bap_upl_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_bap_upl_loan(
    serialno varchar2(32) -- 批复编号流水号
    ,migtflag varchar2(80) -- 
    ,feesum number(24,6) -- 手续费金额
    ,paymenttype varchar2(18) -- 支付方式
    ,loankind varchar2(10) -- 期限类型
    ,businessprop number(24,8) -- 贷款成数
    ,mfeesum number(24,6) -- 管理费金额
    ,payaccountno2 varchar2(40) -- 第二还款账户
    ,warrantor varchar2(80) -- 主要担保人
    ,warrantorid varchar2(32) -- 主要担保人代码
    ,incomeorgid varchar2(32) -- 入账机构编号
    ,batchpaymentflag varchar2(1) -- 是否参与批扣
    ,feepayment varchar2(18) -- 手续费支付方式
    ,bankinoutflag varchar2(18) -- 行内外标识
    ,loantradesum number(24,6) -- 贷款用途交易金额
    ,paybankaddcode varchar2(500) -- 收款人开户行地点
    ,holdcorpus number(20,4) -- 保留本金
    ,subbusinesstype varchar2(32) -- 助贷默认业务品种
    ,feeratio number(24,6) -- 手续费率
    ,approvedate date -- 审批通过日
    ,payaccountname2 varchar2(80) -- 第二还款账户名
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
grant select on ${iol_schema}.icms_bap_upl_loan to ${iml_schema};
grant select on ${iol_schema}.icms_bap_upl_loan to ${icl_schema};
grant select on ${iol_schema}.icms_bap_upl_loan to ${idl_schema};
grant select on ${iol_schema}.icms_bap_upl_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_bap_upl_loan is '微贷批复附表';
comment on column ${iol_schema}.icms_bap_upl_loan.serialno is '批复编号流水号';
comment on column ${iol_schema}.icms_bap_upl_loan.migtflag is '';
comment on column ${iol_schema}.icms_bap_upl_loan.feesum is '手续费金额';
comment on column ${iol_schema}.icms_bap_upl_loan.paymenttype is '支付方式';
comment on column ${iol_schema}.icms_bap_upl_loan.loankind is '期限类型';
comment on column ${iol_schema}.icms_bap_upl_loan.businessprop is '贷款成数';
comment on column ${iol_schema}.icms_bap_upl_loan.mfeesum is '管理费金额';
comment on column ${iol_schema}.icms_bap_upl_loan.payaccountno2 is '第二还款账户';
comment on column ${iol_schema}.icms_bap_upl_loan.warrantor is '主要担保人';
comment on column ${iol_schema}.icms_bap_upl_loan.warrantorid is '主要担保人代码';
comment on column ${iol_schema}.icms_bap_upl_loan.incomeorgid is '入账机构编号';
comment on column ${iol_schema}.icms_bap_upl_loan.batchpaymentflag is '是否参与批扣';
comment on column ${iol_schema}.icms_bap_upl_loan.feepayment is '手续费支付方式';
comment on column ${iol_schema}.icms_bap_upl_loan.bankinoutflag is '行内外标识';
comment on column ${iol_schema}.icms_bap_upl_loan.loantradesum is '贷款用途交易金额';
comment on column ${iol_schema}.icms_bap_upl_loan.paybankaddcode is '收款人开户行地点';
comment on column ${iol_schema}.icms_bap_upl_loan.holdcorpus is '保留本金';
comment on column ${iol_schema}.icms_bap_upl_loan.subbusinesstype is '助贷默认业务品种';
comment on column ${iol_schema}.icms_bap_upl_loan.feeratio is '手续费率';
comment on column ${iol_schema}.icms_bap_upl_loan.approvedate is '审批通过日';
comment on column ${iol_schema}.icms_bap_upl_loan.payaccountname2 is '第二还款账户名';
comment on column ${iol_schema}.icms_bap_upl_loan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_bap_upl_loan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_bap_upl_loan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_bap_upl_loan.etl_timestamp is 'ETL处理时间戳';
