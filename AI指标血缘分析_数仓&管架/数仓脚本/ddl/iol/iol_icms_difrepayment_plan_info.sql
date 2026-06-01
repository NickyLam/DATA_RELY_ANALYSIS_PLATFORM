/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_difrepayment_plan_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_difrepayment_plan_info
whenever sqlerror continue none;
drop table ${iol_schema}.icms_difrepayment_plan_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_difrepayment_plan_info(
    duebillserialno varchar2(40) -- 借据号
    ,executiondate date -- 执行日期
    ,migtflag varchar2(80) -- 迁移标志：crsrcrilcupl
    ,startdate date -- 起息日期
    ,normalsum number(24,6) -- 应计正常本金
    ,periodsum number(24,6) -- 本期应收本金
    ,businesscurrency varchar2(10) -- 币种
    ,periodinterestsum number(24,6) -- 本期应收利息
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
grant select on ${iol_schema}.icms_difrepayment_plan_info to ${iml_schema};
grant select on ${iol_schema}.icms_difrepayment_plan_info to ${icl_schema};
grant select on ${iol_schema}.icms_difrepayment_plan_info to ${idl_schema};
grant select on ${iol_schema}.icms_difrepayment_plan_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_difrepayment_plan_info is '不规则还款计划表';
comment on column ${iol_schema}.icms_difrepayment_plan_info.duebillserialno is '借据号';
comment on column ${iol_schema}.icms_difrepayment_plan_info.executiondate is '执行日期';
comment on column ${iol_schema}.icms_difrepayment_plan_info.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_difrepayment_plan_info.startdate is '起息日期';
comment on column ${iol_schema}.icms_difrepayment_plan_info.normalsum is '应计正常本金';
comment on column ${iol_schema}.icms_difrepayment_plan_info.periodsum is '本期应收本金';
comment on column ${iol_schema}.icms_difrepayment_plan_info.businesscurrency is '币种';
comment on column ${iol_schema}.icms_difrepayment_plan_info.periodinterestsum is '本期应收利息';
comment on column ${iol_schema}.icms_difrepayment_plan_info.start_dt is '开始时间';
comment on column ${iol_schema}.icms_difrepayment_plan_info.end_dt is '结束时间';
comment on column ${iol_schema}.icms_difrepayment_plan_info.id_mark is '增删标志';
comment on column ${iol_schema}.icms_difrepayment_plan_info.etl_timestamp is 'ETL处理时间戳';
