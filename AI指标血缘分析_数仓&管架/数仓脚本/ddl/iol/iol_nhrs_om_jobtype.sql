/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_om_jobtype
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_om_jobtype
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_om_jobtype purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_om_jobtype(
    creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,dr number(10,0) -- 
    ,enablestate number(38,0) -- 
    ,father_pk varchar2(30) -- 
    ,innercode varchar2(300) -- 
    ,jobtypecode varchar2(75) -- 
    ,jobtypedesc varchar2(2304) -- 
    ,jobtypename varchar2(450) -- 
    ,jobtypename2 varchar2(450) -- 
    ,jobtypename3 varchar2(450) -- 
    ,jobtypename4 varchar2(450) -- 
    ,jobtypename5 varchar2(450) -- 
    ,jobtypename6 varchar2(450) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,originaldocid varchar2(30) -- 
    ,pk_grade_source varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_jobtype varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pvtjobgrade varchar2(2) -- 
    ,redefineflag varchar2(2) -- 
    ,ts varchar2(29) -- 
    ,type_level number(38,0) -- 
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
grant select on ${iol_schema}.nhrs_om_jobtype to ${iml_schema};
grant select on ${iol_schema}.nhrs_om_jobtype to ${icl_schema};
grant select on ${iol_schema}.nhrs_om_jobtype to ${idl_schema};
grant select on ${iol_schema}.nhrs_om_jobtype to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_om_jobtype is '职务类别表';
comment on column ${iol_schema}.nhrs_om_jobtype.creationtime is '';
comment on column ${iol_schema}.nhrs_om_jobtype.creator is '';
comment on column ${iol_schema}.nhrs_om_jobtype.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_om_jobtype.dr is '';
comment on column ${iol_schema}.nhrs_om_jobtype.enablestate is '';
comment on column ${iol_schema}.nhrs_om_jobtype.father_pk is '';
comment on column ${iol_schema}.nhrs_om_jobtype.innercode is '';
comment on column ${iol_schema}.nhrs_om_jobtype.jobtypecode is '';
comment on column ${iol_schema}.nhrs_om_jobtype.jobtypedesc is '';
comment on column ${iol_schema}.nhrs_om_jobtype.jobtypename is '';
comment on column ${iol_schema}.nhrs_om_jobtype.jobtypename2 is '';
comment on column ${iol_schema}.nhrs_om_jobtype.jobtypename3 is '';
comment on column ${iol_schema}.nhrs_om_jobtype.jobtypename4 is '';
comment on column ${iol_schema}.nhrs_om_jobtype.jobtypename5 is '';
comment on column ${iol_schema}.nhrs_om_jobtype.jobtypename6 is '';
comment on column ${iol_schema}.nhrs_om_jobtype.modifiedtime is '';
comment on column ${iol_schema}.nhrs_om_jobtype.modifier is '';
comment on column ${iol_schema}.nhrs_om_jobtype.originaldocid is '';
comment on column ${iol_schema}.nhrs_om_jobtype.pk_grade_source is '';
comment on column ${iol_schema}.nhrs_om_jobtype.pk_group is '';
comment on column ${iol_schema}.nhrs_om_jobtype.pk_jobtype is '';
comment on column ${iol_schema}.nhrs_om_jobtype.pk_org is '';
comment on column ${iol_schema}.nhrs_om_jobtype.pvtjobgrade is '';
comment on column ${iol_schema}.nhrs_om_jobtype.redefineflag is '';
comment on column ${iol_schema}.nhrs_om_jobtype.ts is '';
comment on column ${iol_schema}.nhrs_om_jobtype.type_level is '';
comment on column ${iol_schema}.nhrs_om_jobtype.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_om_jobtype.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_om_jobtype.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_om_jobtype.etl_timestamp is 'ETL处理时间戳';
