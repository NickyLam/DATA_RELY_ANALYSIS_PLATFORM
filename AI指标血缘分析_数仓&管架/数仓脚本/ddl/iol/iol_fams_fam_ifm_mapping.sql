/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol fams_fam_ifm_mapping
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.fams_fam_ifm_mapping
whenever sqlerror continue none;
drop table ${iol_schema}.fams_fam_ifm_mapping purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_fam_ifm_mapping(
    fam_prod_code varchar2(40) -- 资管产品代码
    ,ifm_prod_code varchar2(40) -- 销售产品代码
    ,create_user varchar2(40) -- 创建人
    ,create_dept varchar2(64) -- 创建部门
    ,create_time timestamp -- 创建时间
    ,update_user varchar2(40) -- 更新人
    ,update_time timestamp -- 更新时间
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.fams_fam_ifm_mapping to ${iml_schema};
grant select on ${iol_schema}.fams_fam_ifm_mapping to ${icl_schema};
grant select on ${iol_schema}.fams_fam_ifm_mapping to ${idl_schema};
grant select on ${iol_schema}.fams_fam_ifm_mapping to ${iel_schema};

-- comment
comment on table ${iol_schema}.fams_fam_ifm_mapping is '资管销售产品代码关联';
comment on column ${iol_schema}.fams_fam_ifm_mapping.fam_prod_code is '资管产品代码';
comment on column ${iol_schema}.fams_fam_ifm_mapping.ifm_prod_code is '销售产品代码';
comment on column ${iol_schema}.fams_fam_ifm_mapping.create_user is '创建人';
comment on column ${iol_schema}.fams_fam_ifm_mapping.create_dept is '创建部门';
comment on column ${iol_schema}.fams_fam_ifm_mapping.create_time is '创建时间';
comment on column ${iol_schema}.fams_fam_ifm_mapping.update_user is '更新人';
comment on column ${iol_schema}.fams_fam_ifm_mapping.update_time is '更新时间';
comment on column ${iol_schema}.fams_fam_ifm_mapping.start_dt is '开始时间';
comment on column ${iol_schema}.fams_fam_ifm_mapping.end_dt is '结束时间';
comment on column ${iol_schema}.fams_fam_ifm_mapping.id_mark is '增删标志';
comment on column ${iol_schema}.fams_fam_ifm_mapping.etl_timestamp is 'ETL处理时间戳';
