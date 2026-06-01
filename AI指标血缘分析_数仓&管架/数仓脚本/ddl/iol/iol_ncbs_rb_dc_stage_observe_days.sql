/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_dc_stage_observe_days
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_dc_stage_observe_days
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_dc_stage_observe_days purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_dc_stage_observe_days(
    client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,stage_code varchar2(50) -- 期次代码
    ,observe_end_date date -- 观察终止日期
    ,observe_start_date date -- 观察起始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_dc_stage_observe_days to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_observe_days to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_observe_days to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_dc_stage_observe_days to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_dc_stage_observe_days is '期次观察日表';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.company is '法人';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.stage_code is '期次代码';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.observe_end_date is '观察终止日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.observe_start_date is '观察起始日期';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_dc_stage_observe_days.etl_timestamp is 'ETL处理时间戳';
