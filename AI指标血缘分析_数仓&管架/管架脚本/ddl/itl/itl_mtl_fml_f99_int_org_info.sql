/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl mtl_fml_f99_int_org_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.mtl_fml_f99_int_org_info
whenever sqlerror continue none;
drop table ${itl_schema}.mtl_fml_f99_int_org_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.mtl_fml_f99_int_org_info(
    org_no varchar2(60) -- 机构编号
    ,org_name varchar2(100) -- 机构名称
    ,org_level_cd varchar2(30) -- 机构级别代码
    ,accts_org_ind varchar2(10) -- 账务机构标志
    ,super_org_no varchar2(60) -- 上级机构编号
    ,org_status_cd varchar2(30) -- 机构状态代码
    ,org_effect_dt date -- 机构生效日期
    ,org_invalid_dt date -- 机构失效日期
    ,org_abbr varchar2(200) -- 机构简称
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${itl_schema}.mtl_fml_f99_int_org_info to ${iol_schema};

-- comment
comment on table ${itl_schema}.mtl_fml_f99_int_org_info is 'FML_F99_内部机构信息';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.org_no is '机构编号';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.org_name is '机构名称';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.org_level_cd is '机构级别代码';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.accts_org_ind is '账务机构标志';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.super_org_no is '上级机构编号';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.org_status_cd is '机构状态代码';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.org_effect_dt is '机构生效日期';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.org_invalid_dt is '机构失效日期';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.org_abbr is '机构简称';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.mtl_fml_f99_int_org_info.etl_timestamp is 'ETL处理时间戳';
