/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_bd_countryzone
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_bd_countryzone
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_bd_countryzone purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_bd_countryzone(
    bbanrule varchar2(75) -- 
    ,code varchar2(60) -- 
    ,codeth varchar2(60) -- 
    ,creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,description varchar2(450) -- 
    ,dr number(10,0) -- 
    ,ibanlength number(38,0) -- 
    ,ibanrule varchar2(75) -- 
    ,iseucountry varchar2(2) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,name varchar2(450) -- 
    ,name2 varchar2(450) -- 
    ,name3 varchar2(450) -- 
    ,name4 varchar2(450) -- 
    ,name5 varchar2(450) -- 
    ,name6 varchar2(450) -- 
    ,phonecode varchar2(30) -- 
    ,pk_country varchar2(30) -- 
    ,pk_currtype varchar2(30) -- 
    ,pk_format varchar2(30) -- 
    ,pk_lang varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pk_timezone varchar2(30) -- 
    ,ts varchar2(29) -- 
    ,wholename varchar2(450) -- 
    ,wholename2 varchar2(450) -- 
    ,wholename3 varchar2(450) -- 
    ,wholename4 varchar2(450) -- 
    ,wholename5 varchar2(450) -- 
    ,wholename6 varchar2(450) -- 
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
grant select on ${iol_schema}.nhrs_bd_countryzone to ${iml_schema};
grant select on ${iol_schema}.nhrs_bd_countryzone to ${icl_schema};
grant select on ${iol_schema}.nhrs_bd_countryzone to ${idl_schema};
grant select on ${iol_schema}.nhrs_bd_countryzone to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_bd_countryzone is '国家地区表';
comment on column ${iol_schema}.nhrs_bd_countryzone.bbanrule is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.code is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.codeth is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.creationtime is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.creator is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.description is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.dr is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.ibanlength is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.ibanrule is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.iseucountry is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.modifiedtime is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.modifier is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.name is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.name2 is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.name3 is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.name4 is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.name5 is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.name6 is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.phonecode is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.pk_country is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.pk_currtype is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.pk_format is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.pk_lang is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.pk_org is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.pk_timezone is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.ts is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.wholename is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.wholename2 is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.wholename3 is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.wholename4 is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.wholename5 is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.wholename6 is '';
comment on column ${iol_schema}.nhrs_bd_countryzone.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_bd_countryzone.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_bd_countryzone.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_bd_countryzone.etl_timestamp is 'ETL处理时间戳';
