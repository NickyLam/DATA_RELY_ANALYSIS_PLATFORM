/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_sf_mod_int_pd_i9
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_sf_mod_int_pd_i9
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_sf_mod_int_pd_i9 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_sf_mod_int_pd_i9(
    pd_internal_review varchar2(75) -- 国标行业门类
    ,pd_internal_review_code_1 varchar2(38) -- 国标行业门类代码
    ,i9_mod_grouping_1 varchar2(75) -- 模型分组名称
    ,pd_internal_review_id varchar2(96) -- 序号
    ,status number -- 状态
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
grant select on ${iol_schema}.ifrs_sf_mod_int_pd_i9 to ${iml_schema};
grant select on ${iol_schema}.ifrs_sf_mod_int_pd_i9 to ${icl_schema};
grant select on ${iol_schema}.ifrs_sf_mod_int_pd_i9 to ${idl_schema};
grant select on ${iol_schema}.ifrs_sf_mod_int_pd_i9 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_sf_mod_int_pd_i9 is 'PD-国标行业映射';
comment on column ${iol_schema}.ifrs_sf_mod_int_pd_i9.pd_internal_review is '国标行业门类';
comment on column ${iol_schema}.ifrs_sf_mod_int_pd_i9.pd_internal_review_code_1 is '国标行业门类代码';
comment on column ${iol_schema}.ifrs_sf_mod_int_pd_i9.i9_mod_grouping_1 is '模型分组名称';
comment on column ${iol_schema}.ifrs_sf_mod_int_pd_i9.pd_internal_review_id is '序号';
comment on column ${iol_schema}.ifrs_sf_mod_int_pd_i9.status is '状态';
comment on column ${iol_schema}.ifrs_sf_mod_int_pd_i9.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_sf_mod_int_pd_i9.etl_timestamp is 'ETL处理时间戳';
