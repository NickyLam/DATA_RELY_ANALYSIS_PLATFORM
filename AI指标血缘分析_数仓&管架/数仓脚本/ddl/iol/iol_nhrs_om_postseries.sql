/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_om_postseries
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_om_postseries
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_om_postseries purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_om_postseries(
    creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,dr number(10,0) -- 
    ,enablestate number(38,0) -- 
    ,father_pk varchar2(30) -- 
    ,innercode varchar2(300) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pk_postseries varchar2(30) -- 
    ,postseriescode varchar2(60) -- 
    ,postseriesdesc varchar2(2304) -- 
    ,postseriesname varchar2(450) -- 
    ,postseriesname2 varchar2(450) -- 
    ,postseriesname3 varchar2(450) -- 
    ,postseriesname4 varchar2(450) -- 
    ,postseriesname5 varchar2(450) -- 
    ,postseriesname6 varchar2(450) -- 
    ,seq varchar2(30) -- 
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
grant select on ${iol_schema}.nhrs_om_postseries to ${iml_schema};
grant select on ${iol_schema}.nhrs_om_postseries to ${icl_schema};
grant select on ${iol_schema}.nhrs_om_postseries to ${idl_schema};
grant select on ${iol_schema}.nhrs_om_postseries to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_om_postseries is '岗位序列表';
comment on column ${iol_schema}.nhrs_om_postseries.creationtime is '';
comment on column ${iol_schema}.nhrs_om_postseries.creator is '';
comment on column ${iol_schema}.nhrs_om_postseries.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_om_postseries.dr is '';
comment on column ${iol_schema}.nhrs_om_postseries.enablestate is '';
comment on column ${iol_schema}.nhrs_om_postseries.father_pk is '';
comment on column ${iol_schema}.nhrs_om_postseries.innercode is '';
comment on column ${iol_schema}.nhrs_om_postseries.modifiedtime is '';
comment on column ${iol_schema}.nhrs_om_postseries.modifier is '';
comment on column ${iol_schema}.nhrs_om_postseries.pk_group is '';
comment on column ${iol_schema}.nhrs_om_postseries.pk_org is '';
comment on column ${iol_schema}.nhrs_om_postseries.pk_postseries is '';
comment on column ${iol_schema}.nhrs_om_postseries.postseriescode is '';
comment on column ${iol_schema}.nhrs_om_postseries.postseriesdesc is '';
comment on column ${iol_schema}.nhrs_om_postseries.postseriesname is '';
comment on column ${iol_schema}.nhrs_om_postseries.postseriesname2 is '';
comment on column ${iol_schema}.nhrs_om_postseries.postseriesname3 is '';
comment on column ${iol_schema}.nhrs_om_postseries.postseriesname4 is '';
comment on column ${iol_schema}.nhrs_om_postseries.postseriesname5 is '';
comment on column ${iol_schema}.nhrs_om_postseries.postseriesname6 is '';
comment on column ${iol_schema}.nhrs_om_postseries.seq is '';
comment on column ${iol_schema}.nhrs_om_postseries.ts is '';
comment on column ${iol_schema}.nhrs_om_postseries.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_om_postseries.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_om_postseries.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_om_postseries.etl_timestamp is 'ETL处理时间戳';
