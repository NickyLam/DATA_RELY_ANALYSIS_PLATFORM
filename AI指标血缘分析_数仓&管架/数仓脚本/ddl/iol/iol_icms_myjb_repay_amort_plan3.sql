/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_myjb_repay_amort_plan3
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_myjb_repay_amort_plan3
whenever sqlerror continue none;
drop table ${iol_schema}.icms_myjb_repay_amort_plan3 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_myjb_repay_amort_plan3(
    contractno varchar2(64) -- 融资平台贷款合约号
    ,termno varchar2(32) -- 期次号
    ,status varchar2(20) -- 分期状态
    ,startdate varchar2(10) -- 分期开始日期
    ,intbal number(24,6) -- 利息余额
    ,prinbal number(24,6) -- 本金余额
    ,prinovddate varchar2(10) -- 本金转逾期日期
    ,prinovddays number(22) -- 本金逾期天数
    ,settledate varchar2(10) -- 会计日期
    ,prinamt number(24,6) -- 本金金额
    ,cleardate varchar2(10) -- 结清日期
    ,inputdate varchar2(10) -- 登记时间
    ,ovdprinpnltbal number(24,6) -- 逾期本金罚息余额
    ,intovddate varchar2(10) -- 利息转逾期日期
    ,intovddays number(22) -- 利息逾期天数
    ,ovdintpnltbal number(24,6) -- 逾期利息罚息余额
    ,intamt number(24,6) -- 初始利息匡算金额
    ,enddate varchar2(10) -- 分期结束日期
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
grant select on ${iol_schema}.icms_myjb_repay_amort_plan3 to ${iml_schema};
grant select on ${iol_schema}.icms_myjb_repay_amort_plan3 to ${icl_schema};
grant select on ${iol_schema}.icms_myjb_repay_amort_plan3 to ${idl_schema};
grant select on ${iol_schema}.icms_myjb_repay_amort_plan3 to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_myjb_repay_amort_plan3 is '借呗还款计划-三期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.contractno is '融资平台贷款合约号';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.termno is '期次号';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.status is '分期状态';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.startdate is '分期开始日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.intbal is '利息余额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.prinbal is '本金余额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.prinovddate is '本金转逾期日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.prinovddays is '本金逾期天数';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.settledate is '会计日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.prinamt is '本金金额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.cleardate is '结清日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.inputdate is '登记时间';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.ovdprinpnltbal is '逾期本金罚息余额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.intovddate is '利息转逾期日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.intovddays is '利息逾期天数';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.ovdintpnltbal is '逾期利息罚息余额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.intamt is '初始利息匡算金额';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.enddate is '分期结束日期';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.start_dt is '开始时间';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.end_dt is '结束时间';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.id_mark is '增删标志';
comment on column ${iol_schema}.icms_myjb_repay_amort_plan3.etl_timestamp is 'ETL处理时间戳';
