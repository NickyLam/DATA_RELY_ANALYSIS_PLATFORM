/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_repay_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_repay_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_repay_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_repay_detail(
    seqno varchar2(64) -- 还款流水号
    ,termno varchar2(32) -- 期次号
    ,paidprinamt number(24,6) -- 本次实还本金金额
    ,befassetclass varchar2(64) -- 变更前五级分类
    ,bsntype varchar2(64) -- 产品业务类型
    ,repayamttype varchar2(8) -- 还款金额类型
    ,paidovdintpnltamt number(24,6) -- 本次实还逾期利息罚息金额
    ,writeoff varchar2(8) -- 核销标识，已核销为Y，否则为N
    ,paidintamt number(24,6) -- 本次实还利息金额
    ,paidovdprinpnltamt number(24,6) -- 本次实还逾期本金罚息金额
    ,befaccruedstatus varchar2(64) -- 还款前的应计状态
    ,currintbal number(24,6) -- 本次还款前的应收未收正常利息
    ,currovdprinpnltbal number(24,6) -- 本次还款前的应收未收逾期本金罚息
    ,contractno varchar2(32) -- 借据号
    ,repaydate varchar2(64) -- 还款日期
    ,befstatus varchar2(64) -- 变更前状态
    ,currovdintpnltbal number(24,6) -- 本次还款前的应收未收逾期利息罚息
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,withdrawno varchar2(64) -- 还款提现单号
    ,currprinbal number(24,6) -- 本次还款前的应收未收正常本金余额
    ,repayamt number(24,6) -- 本次实还总金额
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
grant select on ${iol_schema}.icms_mybk_repay_detail to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_repay_detail to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_repay_detail to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_repay_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_repay_detail is '还款分期信息';
comment on column ${iol_schema}.icms_mybk_repay_detail.seqno is '还款流水号';
comment on column ${iol_schema}.icms_mybk_repay_detail.termno is '期次号';
comment on column ${iol_schema}.icms_mybk_repay_detail.paidprinamt is '本次实还本金金额';
comment on column ${iol_schema}.icms_mybk_repay_detail.befassetclass is '变更前五级分类';
comment on column ${iol_schema}.icms_mybk_repay_detail.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_repay_detail.repayamttype is '还款金额类型';
comment on column ${iol_schema}.icms_mybk_repay_detail.paidovdintpnltamt is '本次实还逾期利息罚息金额';
comment on column ${iol_schema}.icms_mybk_repay_detail.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_mybk_repay_detail.paidintamt is '本次实还利息金额';
comment on column ${iol_schema}.icms_mybk_repay_detail.paidovdprinpnltamt is '本次实还逾期本金罚息金额';
comment on column ${iol_schema}.icms_mybk_repay_detail.befaccruedstatus is '还款前的应计状态';
comment on column ${iol_schema}.icms_mybk_repay_detail.currintbal is '本次还款前的应收未收正常利息';
comment on column ${iol_schema}.icms_mybk_repay_detail.currovdprinpnltbal is '本次还款前的应收未收逾期本金罚息';
comment on column ${iol_schema}.icms_mybk_repay_detail.contractno is '借据号';
comment on column ${iol_schema}.icms_mybk_repay_detail.repaydate is '还款日期';
comment on column ${iol_schema}.icms_mybk_repay_detail.befstatus is '变更前状态';
comment on column ${iol_schema}.icms_mybk_repay_detail.currovdintpnltbal is '本次还款前的应收未收逾期利息罚息';
comment on column ${iol_schema}.icms_mybk_repay_detail.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_mybk_repay_detail.withdrawno is '还款提现单号';
comment on column ${iol_schema}.icms_mybk_repay_detail.currprinbal is '本次还款前的应收未收正常本金余额';
comment on column ${iol_schema}.icms_mybk_repay_detail.repayamt is '本次实还总金额';
comment on column ${iol_schema}.icms_mybk_repay_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_mybk_repay_detail.etl_timestamp is 'ETL处理时间戳';
