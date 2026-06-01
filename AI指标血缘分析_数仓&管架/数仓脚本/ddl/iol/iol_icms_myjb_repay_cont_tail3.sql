/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myjb_repay_cont_tail3
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myjb_repay_cont_tail3
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myjb_repay_cont_tail3 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_repay_cont_tail3(
    seqno varchar2(64) -- 借呗平台贷款合同号
    ,paidovdprinpnltamt number(24,6) -- 本次实还逾期本金罚息金额
    ,currovdintbal number(24,6) -- 本次还款前的应收未收逾期利息余额
    ,accruedstatus varchar2(2) -- 应计非应计标识，应计0，非应计1
    ,paidprinamt number(24,6) -- 本次实还正常本金金额
    ,paidovdprinamt number(24,6) -- 本次实还逾期本金金额
    ,currintbal number(24,6) -- 本次还款前的应收未收正常利息余额
    ,withdrawno varchar2(64) -- 还款提现单号
    ,contractno varchar2(64) -- 还款流水号
    ,paidintamt number(24,6) -- 本次实还正常利息金额
    ,repaytype varchar2(8) -- 还款类型
    ,currovdprinpnltbal number(24,6) -- 本次还款前的应收未收逾期本金罚息余额
    ,feeno varchar2(64) -- 平台服务费收费单号
    ,paidovdintamt number(24,6) -- 本次实还逾期利息金额
    ,writeoff varchar2(2) -- 核销标识，已核销为y，否则为n
    ,currovdprinbal number(24,6) -- 本次还款前的应收未收逾期本金余额
    ,currovdintpnltbal number(24,6) -- 本次还款前的应收未收逾期利息罚息余额
    ,inputdate varchar2(10) -- 登记日期
    ,paidovdintpnltamt number(24,6) -- 本次实还逾期利息罚息金额
    ,repaydate varchar2(20) -- 还款日期
    ,repayamt number(24,6) -- 总金额
    ,feeamt number(24,6) -- 本次还款对应的平台服务费金额
    ,currprinbal number(24,6) -- 本次还款前的应收未收正常本金余额
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
grant select on ${iol_schema}.icms_myjb_repay_cont_tail3 to ${iml_schema};
grant select on ${iol_schema}.icms_myjb_repay_cont_tail3 to ${icl_schema};
grant select on ${iol_schema}.icms_myjb_repay_cont_tail3 to ${idl_schema};
grant select on ${iol_schema}.icms_myjb_repay_cont_tail3 to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myjb_repay_cont_tail3 is '借呗还款明细-三期';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.seqno is '借呗平台贷款合同号';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.paidovdprinpnltamt is '本次实还逾期本金罚息金额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.currovdintbal is '本次还款前的应收未收逾期利息余额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.accruedstatus is '应计非应计标识，应计0，非应计1';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.paidprinamt is '本次实还正常本金金额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.paidovdprinamt is '本次实还逾期本金金额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.currintbal is '本次还款前的应收未收正常利息余额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.withdrawno is '还款提现单号';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.contractno is '还款流水号';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.paidintamt is '本次实还正常利息金额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.repaytype is '还款类型';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.currovdprinpnltbal is '本次还款前的应收未收逾期本金罚息余额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.feeno is '平台服务费收费单号';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.paidovdintamt is '本次实还逾期利息金额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.writeoff is '核销标识，已核销为y，否则为n';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.currovdprinbal is '本次还款前的应收未收逾期本金余额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.currovdintpnltbal is '本次还款前的应收未收逾期利息罚息余额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.inputdate is '登记日期';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.paidovdintpnltamt is '本次实还逾期利息罚息金额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.repaydate is '还款日期';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.repayamt is '总金额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.feeamt is '本次还款对应的平台服务费金额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.currprinbal is '本次还款前的应收未收正常本金余额';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.start_dt is '开始时间';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.end_dt is '结束时间';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.id_mark is '增删标志';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail3.etl_timestamp is 'ETL处理时间戳';
