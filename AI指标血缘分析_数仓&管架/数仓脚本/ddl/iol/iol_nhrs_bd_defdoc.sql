/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_bd_defdoc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_bd_defdoc
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_bd_defdoc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_bd_defdoc(
    code varchar2(60) -- 
    ,creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,datatype number(38,0) -- 
    ,dr number(10,0) -- 
    ,enablestate number(38,0) -- 
    ,innercode varchar2(300) -- 
    ,memo varchar2(450) -- 
    ,mnecode varchar2(75) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,name varchar2(450) -- 
    ,name2 varchar2(450) -- 
    ,name3 varchar2(450) -- 
    ,name4 varchar2(450) -- 
    ,name5 varchar2(450) -- 
    ,name6 varchar2(450) -- 
    ,pid varchar2(30) -- 
    ,pk_defdoc varchar2(30) -- 
    ,pk_defdoclist varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,shortname varchar2(450) -- 
    ,shortname2 varchar2(450) -- 
    ,shortname3 varchar2(450) -- 
    ,shortname4 varchar2(450) -- 
    ,shortname5 varchar2(450) -- 
    ,shortname6 varchar2(450) -- 
    ,ts varchar2(29) -- 
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
grant select on ${iol_schema}.nhrs_bd_defdoc to ${iml_schema};
grant select on ${iol_schema}.nhrs_bd_defdoc to ${icl_schema};
grant select on ${iol_schema}.nhrs_bd_defdoc to ${idl_schema};
grant select on ${iol_schema}.nhrs_bd_defdoc to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_bd_defdoc is '数据字典子项';
comment on column ${iol_schema}.nhrs_bd_defdoc.code is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.creationtime is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.creator is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.datatype is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.dr is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.enablestate is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.innercode is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.memo is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.mnecode is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.modifiedtime is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.modifier is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.name is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.name2 is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.name3 is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.name4 is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.name5 is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.name6 is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.pid is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.pk_defdoc is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.pk_defdoclist is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.pk_group is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.pk_org is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.shortname is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.shortname2 is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.shortname3 is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.shortname4 is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.shortname5 is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.shortname6 is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.ts is '';
comment on column ${iol_schema}.nhrs_bd_defdoc.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_bd_defdoc.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_bd_defdoc.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_bd_defdoc.etl_timestamp is 'ETL处理时间戳';
