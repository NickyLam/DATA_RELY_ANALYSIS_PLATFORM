/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_om_jobrank
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_om_jobrank
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_om_jobrank purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_om_jobrank(
    creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,dr number(10,0) -- 
    ,enablestate number(38,0) -- 
    ,jobrankcode varchar2(42) -- 
    ,jobrankdesc varchar2(2250) -- 
    ,jobrankname varchar2(2304) -- 
    ,jobrankname2 varchar2(2304) -- 
    ,jobrankname3 varchar2(2304) -- 
    ,jobrankname4 varchar2(2304) -- 
    ,jobrankname5 varchar2(2304) -- 
    ,jobrankname6 varchar2(2304) -- 
    ,jobrankorder number(38,0) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_jobrank varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,sealflag varchar2(2) -- 
    ,ts varchar2(29) -- 
    ,usedflag varchar2(2) -- 
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
grant select on ${iol_schema}.nhrs_om_jobrank to ${iml_schema};
grant select on ${iol_schema}.nhrs_om_jobrank to ${icl_schema};
grant select on ${iol_schema}.nhrs_om_jobrank to ${idl_schema};
grant select on ${iol_schema}.nhrs_om_jobrank to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_om_jobrank is '职等表';
comment on column ${iol_schema}.nhrs_om_jobrank.creationtime is '';
comment on column ${iol_schema}.nhrs_om_jobrank.creator is '';
comment on column ${iol_schema}.nhrs_om_jobrank.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_om_jobrank.dr is '';
comment on column ${iol_schema}.nhrs_om_jobrank.enablestate is '';
comment on column ${iol_schema}.nhrs_om_jobrank.jobrankcode is '';
comment on column ${iol_schema}.nhrs_om_jobrank.jobrankdesc is '';
comment on column ${iol_schema}.nhrs_om_jobrank.jobrankname is '';
comment on column ${iol_schema}.nhrs_om_jobrank.jobrankname2 is '';
comment on column ${iol_schema}.nhrs_om_jobrank.jobrankname3 is '';
comment on column ${iol_schema}.nhrs_om_jobrank.jobrankname4 is '';
comment on column ${iol_schema}.nhrs_om_jobrank.jobrankname5 is '';
comment on column ${iol_schema}.nhrs_om_jobrank.jobrankname6 is '';
comment on column ${iol_schema}.nhrs_om_jobrank.jobrankorder is '';
comment on column ${iol_schema}.nhrs_om_jobrank.modifiedtime is '';
comment on column ${iol_schema}.nhrs_om_jobrank.modifier is '';
comment on column ${iol_schema}.nhrs_om_jobrank.pk_group is '';
comment on column ${iol_schema}.nhrs_om_jobrank.pk_jobrank is '';
comment on column ${iol_schema}.nhrs_om_jobrank.pk_org is '';
comment on column ${iol_schema}.nhrs_om_jobrank.sealflag is '';
comment on column ${iol_schema}.nhrs_om_jobrank.ts is '';
comment on column ${iol_schema}.nhrs_om_jobrank.usedflag is '';
comment on column ${iol_schema}.nhrs_om_jobrank.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_om_jobrank.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_om_jobrank.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_om_jobrank.etl_timestamp is 'ETL处理时间戳';
