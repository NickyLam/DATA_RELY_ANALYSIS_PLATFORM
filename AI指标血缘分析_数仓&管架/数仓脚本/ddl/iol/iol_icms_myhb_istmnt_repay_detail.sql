/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myhb_istmnt_repay_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myhb_istmnt_repay_detail
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myhb_istmnt_repay_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myhb_istmnt_repay_detail(
    contractno varchar2(64) -- 花呗平台贷款合同号
    ,seqno varchar2(64) -- 还款流水号
    ,termno varchar2(32) -- 期次号
    ,repaytype varchar2(8) -- 还款类型
    ,internaltransfertag varchar2(8) -- 内部结转标识
    ,regioncode varchar2(8) -- 行政区划代码
    ,creditcode varchar2(8) -- 额度类型
    ,contracttype varchar2(8) -- 借据类型
    ,paidovdprinpnltamt number(24,6) -- 本次实还逾期本金罚息金额
    ,repaydate varchar2(20) -- 还款日期
    ,paidintamt number(24,6) -- 本次实还利息金额
    ,repayamt number(24,6) -- 本次实还总金额
    ,termstatus varchar2(20) -- 分期状态
    ,paidprinamt number(24,6) -- 本次实还正常本金金额
    ,paidovdintpnltamt number(24,6) -- 本次实还逾期利息罚息金额)
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
grant select on ${iol_schema}.icms_myhb_istmnt_repay_detail to ${iml_schema};
grant select on ${iol_schema}.icms_myhb_istmnt_repay_detail to ${icl_schema};
grant select on ${iol_schema}.icms_myhb_istmnt_repay_detail to ${idl_schema};
grant select on ${iol_schema}.icms_myhb_istmnt_repay_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myhb_istmnt_repay_detail is '还款(还款计划)明细文件';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.contractno is '花呗平台贷款合同号';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.seqno is '还款流水号';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.termno is '期次号';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.repaytype is '还款类型';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.internaltransfertag is '内部结转标识';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.regioncode is '行政区划代码';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.creditcode is '额度类型';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.contracttype is '借据类型';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.paidovdprinpnltamt is '本次实还逾期本金罚息金额';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.repaydate is '还款日期';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.paidintamt is '本次实还利息金额';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.repayamt is '本次实还总金额';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.termstatus is '分期状态';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.paidprinamt is '本次实还正常本金金额';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.paidovdintpnltamt is '本次实还逾期利息罚息金额)';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_myhb_istmnt_repay_detail.etl_timestamp is 'ETL处理时间戳';
