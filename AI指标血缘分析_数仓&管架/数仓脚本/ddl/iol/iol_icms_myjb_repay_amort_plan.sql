/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myjb_repay_amort_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myjb_repay_amort_plan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myjb_repay_amort_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_repay_amort_plan(
    contractno varchar2(64) -- 融资平台贷款合约号
    ,termno varchar2(32) -- 期次号
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,intamt number(24,6) -- 初始利息匡算金额
    ,prinamt number(24,6) -- 本金金额
    ,prinbal number(24,6) -- 本金余额
    ,intovddays number(22) -- 利息逾期天数
    ,enddate varchar2(10) -- 分期结束日期
    ,startdate varchar2(10) -- 分期开始日期
    ,intbal number(24,6) -- 利息余额
    ,ovdintpnltbal number(24,6) -- 逾期利息罚息余额
    ,prinovddate varchar2(10) -- 本金转逾期日期
    ,settledate varchar2(10) -- 会计日期
    ,status varchar2(20) -- 分期状态
    ,prinovddays number(22) -- 本金逾期天数
    ,intovddate varchar2(10) -- 利息转逾期日期
    ,inputdate varchar2(10) -- 登记时间
    ,cleardate varchar2(10) -- 结清日期
    ,ovdprinpnltbal number(24,6) -- 逾期本金罚息余额
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
grant select on ${iol_schema}.icms_myjb_repay_amort_plan to ${iml_schema};
grant select on ${iol_schema}.icms_myjb_repay_amort_plan to ${icl_schema};
grant select on ${iol_schema}.icms_myjb_repay_amort_plan to ${idl_schema};
grant select on ${iol_schema}.icms_myjb_repay_amort_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myjb_repay_amort_plan is '借呗还款计划-二期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.contractno is '融资平台贷款合约号';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.termno is '期次号';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.intamt is '初始利息匡算金额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.prinamt is '本金金额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.prinbal is '本金余额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.intovddays is '利息逾期天数';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.enddate is '分期结束日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.startdate is '分期开始日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.intbal is '利息余额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.ovdintpnltbal is '逾期利息罚息余额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.prinovddate is '本金转逾期日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.settledate is '会计日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.status is '分期状态';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.prinovddays is '本金逾期天数';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.intovddate is '利息转逾期日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.inputdate is '登记时间';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.cleardate is '结清日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.ovdprinpnltbal is '逾期本金罚息余额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan.etl_timestamp is 'ETL处理时间戳';
