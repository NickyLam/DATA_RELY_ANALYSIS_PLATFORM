/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_sf_one_year_parameter
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_sf_one_year_parameter
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_sf_one_year_parameter purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_sf_one_year_parameter(
    v_i9_mod_grouping varchar2(45) -- i9模型分组
    ,v_internal_rating varchar2(30) -- 客户内部评级
    ,v_pessimism number(15,4) -- 悲观PD
    ,v_standard number(15,4) -- 基准PD
    ,v_optimistic number(15,4) -- 乐观PD
    ,v_year_parameter_id varchar2(96) -- ID
    ,official_trial number -- 批次区分代码1为正式批
    ,trial_active number -- 是否启用，1启用
    ,sid number -- 规则组id
    ,addweightpd number(15,5) -- 加权PD
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
grant select on ${iol_schema}.ifrs_sf_one_year_parameter to ${iml_schema};
grant select on ${iol_schema}.ifrs_sf_one_year_parameter to ${icl_schema};
grant select on ${iol_schema}.ifrs_sf_one_year_parameter to ${idl_schema};
grant select on ${iol_schema}.ifrs_sf_one_year_parameter to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_sf_one_year_parameter is 'PD-内评主标尺参数明细表';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.v_i9_mod_grouping is 'i9模型分组';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.v_internal_rating is '客户内部评级';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.v_pessimism is '悲观PD';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.v_standard is '基准PD';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.v_optimistic is '乐观PD';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.v_year_parameter_id is 'ID';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.official_trial is '批次区分代码1为正式批';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.trial_active is '是否启用，1启用';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.sid is '规则组id';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.addweightpd is '加权PD';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_sf_one_year_parameter.etl_timestamp is 'ETL处理时间戳';
