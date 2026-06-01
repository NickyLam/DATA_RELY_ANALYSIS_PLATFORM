/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myjb_repay_cont_tail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myjb_repay_cont_tail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myjb_repay_cont_tail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_repay_cont_tail(
    seqno varchar2(64) -- 还款流水号
    ,feeamt number(24,6) -- 本次还款对应的平台服务费金额（单位分）
    ,currovdprinbal number(24,6) -- 本次还款前的应收未收逾期本金余额（单位分）
    ,currintbal number(24,6) -- 本次还款前的应收未收正常利息余额（单位分），仅包括已结利息
    ,repaydate varchar2(20) -- 还款日期
    ,paidovdintpnltamt number(24,6) -- 本次实还逾期利息罚息金额（单位分）
    ,writeoff varchar2(10) -- 核销标识，已核销为Y，否则为N
    ,paidovdintamt number(24,6) -- 本次实还逾期利息金额（单位分）
    ,currovdintpnltbal number(24,6) -- 本次还款前的应收未收逾期利息罚息余额（单位分）
    ,inputdate varchar2(10) -- 登记日期
    ,withdrawno varchar2(64) -- 还款提现单号，用来和网商银行账户资金流水进行对账
    ,currprinbal number(24,6) -- 本次还款前的应收未收正常本金余额（单位分）
    ,contractno varchar2(64) -- 借呗平台贷款合同号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,repaytype varchar2(10) -- 还款类型
    ,currovdintbal number(24,6) -- 本次还款前的应收未收逾期利息余额（单位分）
    ,currovdprinpnltbal number(24,6) -- 本次还款前的应收未收逾期本金罚息余额（单位分）
    ,repayamt number(24,6) -- 总金额（单位分）
    ,accruedstatus varchar2(10) -- 应计非应计标识，应计0，非应计1
    ,paidovdprinamt number(24,6) -- 本次实还逾期本金金额（单位分）
    ,paidovdprinpnltamt number(24,6) -- 本次实还逾期本金罚息金额（单位分）
    ,paidprinamt number(24,6) -- 本次实还正常本金金额（单位分）
    ,paidintamt number(24,6) -- 本次实还正常利息金额（单位分）
    ,feeno varchar2(64) -- 平台服务费收费单号，用来和网商银行账户资金流水进行对账
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
grant select on ${iol_schema}.icms_myjb_repay_cont_tail to ${iml_schema};
grant select on ${iol_schema}.icms_myjb_repay_cont_tail to ${icl_schema};
grant select on ${iol_schema}.icms_myjb_repay_cont_tail to ${idl_schema};
grant select on ${iol_schema}.icms_myjb_repay_cont_tail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myjb_repay_cont_tail is '借呗还款明细-二期';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.seqno is '还款流水号';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.feeamt is '本次还款对应的平台服务费金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.currovdprinbal is '本次还款前的应收未收逾期本金余额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.currintbal is '本次还款前的应收未收正常利息余额（单位分），仅包括已结利息';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.repaydate is '还款日期';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.paidovdintpnltamt is '本次实还逾期利息罚息金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.paidovdintamt is '本次实还逾期利息金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.currovdintpnltbal is '本次还款前的应收未收逾期利息罚息余额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.inputdate is '登记日期';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.withdrawno is '还款提现单号，用来和网商银行账户资金流水进行对账';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.currprinbal is '本次还款前的应收未收正常本金余额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.contractno is '借呗平台贷款合同号';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.repaytype is '还款类型';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.currovdintbal is '本次还款前的应收未收逾期利息余额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.currovdprinpnltbal is '本次还款前的应收未收逾期本金罚息余额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.repayamt is '总金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.accruedstatus is '应计非应计标识，应计0，非应计1';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.paidovdprinamt is '本次实还逾期本金金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.paidovdprinpnltamt is '本次实还逾期本金罚息金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.paidprinamt is '本次实还正常本金金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.paidintamt is '本次实还正常利息金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.feeno is '平台服务费收费单号，用来和网商银行账户资金流水进行对账';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_myjb_repay_cont_tail.etl_timestamp is 'ETL处理时间戳';
