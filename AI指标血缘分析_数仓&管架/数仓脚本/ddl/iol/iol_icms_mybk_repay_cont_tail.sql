/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_repay_cont_tail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_repay_cont_tail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_repay_cont_tail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_repay_cont_tail(
    seqno varchar2(64) -- 还款流水号
    ,paidovdprinpnltamt number(20,2) -- 本次实还逾期本金罚息金额
    ,currprinbal number(20,2) -- 本次还款前的应收未收正常本金余额
    ,currovdintpnltbal number(20,2) -- 本次还款前的应收未收逾期利息罚息余额
    ,currovdprinpnltbal number(20,2) -- 本次还款前的应收未收逾期本金罚息余额
    ,paidovdprinamt number(20,2) -- 本次实还逾期本金金额
    ,writeoff varchar2(8) -- 核销标识，已核销为Y，否则为N
    ,repaydate varchar2(64) -- 还款日期
    ,befstatus varchar2(64) -- 变更前状态
    ,migtflag varchar2(80) -- 
    ,paidprinamt number(20,2) -- 本次实还正常本金金额
    ,befassetclass varchar2(64) -- 变更前五级分类
    ,contractno varchar2(32) -- 借据号
    ,currovdintbal number(20,2) -- 本次还款前的应收未收逾期利息余额
    ,paidintamt number(20,2) -- 本次实还正常利息金额
    ,currovdprinbal number(20,2) -- 本次还款前的应收未收逾期本金余额
    ,repayamt number(20,2) -- 总金额
    ,befaccruedstatus varchar2(64) -- 还款前的应计状态
    ,bsntype varchar2(64) -- 产品业务类型
    ,currintbal number(20,2) -- 本次还款前的应收未收正常利息余额
    ,paidovdintpnltamt number(20,2) -- 本次实还逾期利息罚息金额
    ,repaytype varchar2(8) -- 还款类型
    ,paidovdintamt number(20,2) -- 本次实还逾期利息金额
    ,withdrawno varchar2(64) -- 还款提现单号
    ,repayaccttype varchar2(10) -- 还款账户类型
    ,repayacctno varchar2(50) -- 还款账户编号
    ,repaybankname varchar2(200) -- 还款银行名称
    ,externalserialno varchar2(50) -- 清算交易编号
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
grant select on ${iol_schema}.icms_mybk_repay_cont_tail to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_repay_cont_tail to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_repay_cont_tail to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_repay_cont_tail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_repay_cont_tail is '网商贷还款明细';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.seqno is '还款流水号';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.paidovdprinpnltamt is '本次实还逾期本金罚息金额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.currprinbal is '本次还款前的应收未收正常本金余额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.currovdintpnltbal is '本次还款前的应收未收逾期利息罚息余额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.currovdprinpnltbal is '本次还款前的应收未收逾期本金罚息余额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.paidovdprinamt is '本次实还逾期本金金额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.repaydate is '还款日期';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.befstatus is '变更前状态';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.migtflag is '';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.paidprinamt is '本次实还正常本金金额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.befassetclass is '变更前五级分类';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.contractno is '借据号';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.currovdintbal is '本次还款前的应收未收逾期利息余额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.paidintamt is '本次实还正常利息金额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.currovdprinbal is '本次还款前的应收未收逾期本金余额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.repayamt is '总金额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.befaccruedstatus is '还款前的应计状态';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.currintbal is '本次还款前的应收未收正常利息余额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.paidovdintpnltamt is '本次实还逾期利息罚息金额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.repaytype is '还款类型';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.paidovdintamt is '本次实还逾期利息金额';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.withdrawno is '还款提现单号';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.repayaccttype is '还款账户类型';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.repayacctno is '还款账户编号';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.repaybankname is '还款银行名称';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.externalserialno is '清算交易编号';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_repay_cont_tail.etl_timestamp is 'ETL处理时间戳';
