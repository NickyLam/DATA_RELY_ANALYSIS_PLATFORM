/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myjb_repay_instmnt_detail3
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myjb_repay_instmnt_detail3
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myjb_repay_instmnt_detail3 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_repay_instmnt_detail3(
    contractno varchar2(64) -- 借呗平台贷款合同号
    ,seqno varchar2(64) -- 还款流水号
    ,termno varchar2(32) -- 期次号
    ,repaydate varchar2(8) -- 还款日期
    ,currovdprinpnltbal number(12,0) -- 本次还款前的应收未收逾期本金罚息（单位分）
    ,repayamt number(12,0) -- 本次实还总金额（单位分）
    ,paidovdprinpnltamt number(12,0) -- 本次实还逾期本金罚息金额（单位分）
    ,writeoff varchar2(2) -- 核销标识，已核销为Y，否则为N
    ,currintbal number(12,0) -- 本次还款前的应收未收正常利息（单位分），仅包括已结利息
    ,currovdintpnltbal number(12,0) -- 本次还款前的应收未收逾期利息罚息（单位分）
    ,paidprinamt number(12,0) -- 本次实还正常本金金额（单位分）
    ,repayamttype varchar2(8) -- 还款金额类型
    ,currprinbal number(12,0) -- 本次还款前的应收未收正常本金余额（单位分）
    ,paidintamt number(12,0) -- 本次实还利息金额（单位分）
    ,accruedstatus varchar2(2) -- 应计非应计标识，应计0，非应计1
    ,paidovdintpnltamt number(12,0) -- 本次实还逾期利息罚息金额（单位分）
    ,migtflag varchar2(80) -- 迁移标志
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
grant select on ${iol_schema}.icms_myjb_repay_instmnt_detail3 to ${iml_schema};
grant select on ${iol_schema}.icms_myjb_repay_instmnt_detail3 to ${icl_schema};
grant select on ${iol_schema}.icms_myjb_repay_instmnt_detail3 to ${idl_schema};
grant select on ${iol_schema}.icms_myjb_repay_instmnt_detail3 to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myjb_repay_instmnt_detail3 is '蚂蚁借呗3期还款（分期）明细';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.contractno is '借呗平台贷款合同号';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.seqno is '还款流水号';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.termno is '期次号';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.repaydate is '还款日期';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.currovdprinpnltbal is '本次还款前的应收未收逾期本金罚息（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.repayamt is '本次实还总金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.paidovdprinpnltamt is '本次实还逾期本金罚息金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.currintbal is '本次还款前的应收未收正常利息（单位分），仅包括已结利息';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.currovdintpnltbal is '本次还款前的应收未收逾期利息罚息（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.paidprinamt is '本次实还正常本金金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.repayamttype is '还款金额类型';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.currprinbal is '本次还款前的应收未收正常本金余额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.paidintamt is '本次实还利息金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.accruedstatus is '应计非应计标识，应计0，非应计1';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.paidovdintpnltamt is '本次实还逾期利息罚息金额（单位分）';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.migtflag is '迁移标志';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_myjb_repay_instmnt_detail3.etl_timestamp is 'ETL处理时间戳';
