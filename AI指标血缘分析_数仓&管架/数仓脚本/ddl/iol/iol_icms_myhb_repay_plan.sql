/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myhb_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myhb_repay_plan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myhb_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myhb_repay_plan(
    contractno varchar2(64) -- 花呗平台贷款合约号
    ,fundseqno varchar2(64) -- 放款资金流水号
    ,termno varchar2(32) -- 期次号
    ,prinovddate varchar2(8) -- 本金转逾期日期
    ,beginprin number(24,6) -- 应还本金
    ,regioncode varchar2(8) -- 行政区划代码
    ,accruedstatus varchar2(2) -- 应计非应计标识，应计0，非应计1
    ,writeoff varchar2(2) -- 核销标识，已核销为Y，否则为N
    ,prinbal number(24,6) -- 本金余额
    ,settledate varchar2(8) -- 会计日期
    ,ovdintpnltbal number(24,6) -- 逾期利息罚息余额
    ,status varchar2(10) -- 分期状态
    ,cleardate varchar2(8) -- 结清日期
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,intovddate varchar2(8) -- 利息转逾期日期
    ,prinovddays number(22) -- 本金逾期天数
    ,beginint number(24,6) -- 应还利息
    ,creditcode varchar2(8) -- 额度类型
    ,prinamt number(24,6) -- 本金金额
    ,enddate varchar2(8) -- 分期结束日期
    ,ovdprinpnltbal number(24,6) -- 逾期本金罚息余额
    ,contracttype varchar2(8) -- 借据类型
    ,intovddays number(22) -- 利息逾期天数
    ,internaltransfertag varchar2(8) -- 内部结转标识
    ,startdate varchar2(8) -- 分期开始日期
    ,intbal number(24,6) -- 利息余额
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
grant select on ${iol_schema}.icms_myhb_repay_plan to ${iml_schema};
grant select on ${iol_schema}.icms_myhb_repay_plan to ${icl_schema};
grant select on ${iol_schema}.icms_myhb_repay_plan to ${idl_schema};
grant select on ${iol_schema}.icms_myhb_repay_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myhb_repay_plan is '花呗还款计划';
comment on column ${iol_schema}.icms_myhb_repay_plan.contractno is '花呗平台贷款合约号';
comment on column ${iol_schema}.icms_myhb_repay_plan.fundseqno is '放款资金流水号';
comment on column ${iol_schema}.icms_myhb_repay_plan.termno is '期次号';
comment on column ${iol_schema}.icms_myhb_repay_plan.prinovddate is '本金转逾期日期';
comment on column ${iol_schema}.icms_myhb_repay_plan.beginprin is '应还本金';
comment on column ${iol_schema}.icms_myhb_repay_plan.regioncode is '行政区划代码';
comment on column ${iol_schema}.icms_myhb_repay_plan.accruedstatus is '应计非应计标识，应计0，非应计1';
comment on column ${iol_schema}.icms_myhb_repay_plan.writeoff is '核销标识，已核销为Y，否则为N';
comment on column ${iol_schema}.icms_myhb_repay_plan.prinbal is '本金余额';
comment on column ${iol_schema}.icms_myhb_repay_plan.settledate is '会计日期';
comment on column ${iol_schema}.icms_myhb_repay_plan.ovdintpnltbal is '逾期利息罚息余额';
comment on column ${iol_schema}.icms_myhb_repay_plan.status is '分期状态';
comment on column ${iol_schema}.icms_myhb_repay_plan.cleardate is '结清日期';
comment on column ${iol_schema}.icms_myhb_repay_plan.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_myhb_repay_plan.intovddate is '利息转逾期日期';
comment on column ${iol_schema}.icms_myhb_repay_plan.prinovddays is '本金逾期天数';
comment on column ${iol_schema}.icms_myhb_repay_plan.beginint is '应还利息';
comment on column ${iol_schema}.icms_myhb_repay_plan.creditcode is '额度类型';
comment on column ${iol_schema}.icms_myhb_repay_plan.prinamt is '本金金额';
comment on column ${iol_schema}.icms_myhb_repay_plan.enddate is '分期结束日期';
comment on column ${iol_schema}.icms_myhb_repay_plan.ovdprinpnltbal is '逾期本金罚息余额';
comment on column ${iol_schema}.icms_myhb_repay_plan.contracttype is '借据类型';
comment on column ${iol_schema}.icms_myhb_repay_plan.intovddays is '利息逾期天数';
comment on column ${iol_schema}.icms_myhb_repay_plan.internaltransfertag is '内部结转标识';
comment on column ${iol_schema}.icms_myhb_repay_plan.startdate is '分期开始日期';
comment on column ${iol_schema}.icms_myhb_repay_plan.intbal is '利息余额';
comment on column ${iol_schema}.icms_myhb_repay_plan.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.icms_myhb_repay_plan.etl_timestamp is 'ETL处理时间戳';
