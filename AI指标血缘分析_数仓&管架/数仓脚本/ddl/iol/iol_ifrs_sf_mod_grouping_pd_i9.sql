/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_sf_mod_grouping_pd_i9
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9(
    pd_internal_review varchar2(75) -- 内评pd模型
    ,pd_internal_review_code varchar2(38) -- 内评pd模型代码
    ,i9_mod_grouping varchar2(75) -- i9模型分组
    ,status number(22) -- 0，启用 ，1，禁用 旧版
    ,pd_internal_review_id varchar2(96) -- 唯一id
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
grant select on ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 to ${iml_schema};
grant select on ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 to ${icl_schema};
grant select on ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 to ${idl_schema};
grant select on ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 is 'pd模型分组映射i9模型分组配置表';
comment on column ${iol_schema}.ifrs_sf_mod_grouping_pd_i9.pd_internal_review is '内评pd模型';
comment on column ${iol_schema}.ifrs_sf_mod_grouping_pd_i9.pd_internal_review_code is '内评pd模型代码';
comment on column ${iol_schema}.ifrs_sf_mod_grouping_pd_i9.i9_mod_grouping is 'i9模型分组';
comment on column ${iol_schema}.ifrs_sf_mod_grouping_pd_i9.status is '0，启用 ，1，禁用 旧版';
comment on column ${iol_schema}.ifrs_sf_mod_grouping_pd_i9.pd_internal_review_id is '唯一id';
comment on column ${iol_schema}.ifrs_sf_mod_grouping_pd_i9.start_dt is '开始时间';
comment on column ${iol_schema}.ifrs_sf_mod_grouping_pd_i9.end_dt is '结束时间';
comment on column ${iol_schema}.ifrs_sf_mod_grouping_pd_i9.id_mark is '增删标志';
comment on column ${iol_schema}.ifrs_sf_mod_grouping_pd_i9.etl_timestamp is 'ETL处理时间戳';
