/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_bd_region
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_bd_region
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_bd_region purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_bd_region(
    code varchar2(60) -- 
    ,creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,dr number(10,0) -- 
    ,enablestate number(38,0) -- 
    ,innercode varchar2(300) -- 
    ,memcode varchar2(75) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,name varchar2(450) -- 
    ,name2 varchar2(450) -- 
    ,name3 varchar2(450) -- 
    ,name4 varchar2(450) -- 
    ,name5 varchar2(450) -- 
    ,name6 varchar2(450) -- 
    ,pk_country varchar2(30) -- 
    ,pk_father varchar2(30) -- 
    ,pk_format varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_lang varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pk_region varchar2(30) -- 
    ,pk_timezone varchar2(30) -- 
    ,shortname varchar2(450) -- 
    ,shortname2 varchar2(450) -- 
    ,shortname3 varchar2(450) -- 
    ,shortname4 varchar2(450) -- 
    ,shortname5 varchar2(450) -- 
    ,shortname6 varchar2(450) -- 
    ,ts varchar2(29) -- 
    ,zipcode varchar2(75) -- 
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
grant select on ${iol_schema}.nhrs_bd_region to ${iml_schema};
grant select on ${iol_schema}.nhrs_bd_region to ${icl_schema};
grant select on ${iol_schema}.nhrs_bd_region to ${idl_schema};
grant select on ${iol_schema}.nhrs_bd_region to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_bd_region is '行政区划表';
comment on column ${iol_schema}.nhrs_bd_region.code is '';
comment on column ${iol_schema}.nhrs_bd_region.creationtime is '';
comment on column ${iol_schema}.nhrs_bd_region.creator is '';
comment on column ${iol_schema}.nhrs_bd_region.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_bd_region.dr is '';
comment on column ${iol_schema}.nhrs_bd_region.enablestate is '';
comment on column ${iol_schema}.nhrs_bd_region.innercode is '';
comment on column ${iol_schema}.nhrs_bd_region.memcode is '';
comment on column ${iol_schema}.nhrs_bd_region.modifiedtime is '';
comment on column ${iol_schema}.nhrs_bd_region.modifier is '';
comment on column ${iol_schema}.nhrs_bd_region.name is '';
comment on column ${iol_schema}.nhrs_bd_region.name2 is '';
comment on column ${iol_schema}.nhrs_bd_region.name3 is '';
comment on column ${iol_schema}.nhrs_bd_region.name4 is '';
comment on column ${iol_schema}.nhrs_bd_region.name5 is '';
comment on column ${iol_schema}.nhrs_bd_region.name6 is '';
comment on column ${iol_schema}.nhrs_bd_region.pk_country is '';
comment on column ${iol_schema}.nhrs_bd_region.pk_father is '';
comment on column ${iol_schema}.nhrs_bd_region.pk_format is '';
comment on column ${iol_schema}.nhrs_bd_region.pk_group is '';
comment on column ${iol_schema}.nhrs_bd_region.pk_lang is '';
comment on column ${iol_schema}.nhrs_bd_region.pk_org is '';
comment on column ${iol_schema}.nhrs_bd_region.pk_region is '';
comment on column ${iol_schema}.nhrs_bd_region.pk_timezone is '';
comment on column ${iol_schema}.nhrs_bd_region.shortname is '';
comment on column ${iol_schema}.nhrs_bd_region.shortname2 is '';
comment on column ${iol_schema}.nhrs_bd_region.shortname3 is '';
comment on column ${iol_schema}.nhrs_bd_region.shortname4 is '';
comment on column ${iol_schema}.nhrs_bd_region.shortname5 is '';
comment on column ${iol_schema}.nhrs_bd_region.shortname6 is '';
comment on column ${iol_schema}.nhrs_bd_region.ts is '';
comment on column ${iol_schema}.nhrs_bd_region.zipcode is '';
comment on column ${iol_schema}.nhrs_bd_region.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_bd_region.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_bd_region.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_bd_region.etl_timestamp is 'ETL处理时间戳';
