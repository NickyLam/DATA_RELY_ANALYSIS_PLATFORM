/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_mybk_repay_plan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_mybk_repay_plan
whenever sqlerror continue none;
drop table ${iol_schema}.icms_mybk_repay_plan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_mybk_repay_plan(
    contractno varchar2(64) -- 借据号
    ,termno number -- 期次号
    ,prinamt number -- 本金金额
    ,bsntype varchar2(64) -- 产品业务类型
    ,enddate varchar2(64) -- 分期结束日期
    ,startdate varchar2(64) -- 分期开始日期
    ,intamt number -- 初始利息匡算金额
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
grant select on ${iol_schema}.icms_mybk_repay_plan to ${iml_schema};
grant select on ${iol_schema}.icms_mybk_repay_plan to ${icl_schema};
grant select on ${iol_schema}.icms_mybk_repay_plan to ${idl_schema};
grant select on ${iol_schema}.icms_mybk_repay_plan to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_mybk_repay_plan is '网商贷还款计划';
comment on column ${iol_schema}.icms_mybk_repay_plan.contractno is '借据号';
comment on column ${iol_schema}.icms_mybk_repay_plan.termno is '期次号';
comment on column ${iol_schema}.icms_mybk_repay_plan.prinamt is '本金金额';
comment on column ${iol_schema}.icms_mybk_repay_plan.bsntype is '产品业务类型';
comment on column ${iol_schema}.icms_mybk_repay_plan.enddate is '分期结束日期';
comment on column ${iol_schema}.icms_mybk_repay_plan.startdate is '分期开始日期';
comment on column ${iol_schema}.icms_mybk_repay_plan.intamt is '初始利息匡算金额';
comment on column ${iol_schema}.icms_mybk_repay_plan.start_dt is '开始时间';
comment on column ${iol_schema}.icms_mybk_repay_plan.end_dt is '结束时间';
comment on column ${iol_schema}.icms_mybk_repay_plan.id_mark is '增删标志';
comment on column ${iol_schema}.icms_mybk_repay_plan.etl_timestamp is 'ETL处理时间戳';
