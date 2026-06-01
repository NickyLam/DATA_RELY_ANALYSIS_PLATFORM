/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_om_jobgrade
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_om_jobgrade
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_om_jobgrade purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_om_jobgrade(
    dataoriginflag number(38,0) -- 
    ,dr number(10,0) -- 
    ,jobgradecode varchar2(42) -- 
    ,jobgradedesc varchar2(1500) -- 
    ,jobgradename varchar2(225) -- 
    ,jobgradename2 varchar2(225) -- 
    ,jobgradename3 varchar2(225) -- 
    ,jobgradename4 varchar2(225) -- 
    ,jobgradename5 varchar2(225) -- 
    ,jobgradename6 varchar2(225) -- 
    ,pk_job varchar2(30) -- 
    ,pk_jobgrade varchar2(30) -- 
    ,pk_jobrank varchar2(30) -- 
    ,pk_jobtype varchar2(30) -- 
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
grant select on ${iol_schema}.nhrs_om_jobgrade to ${iml_schema};
grant select on ${iol_schema}.nhrs_om_jobgrade to ${icl_schema};
grant select on ${iol_schema}.nhrs_om_jobgrade to ${idl_schema};
grant select on ${iol_schema}.nhrs_om_jobgrade to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_om_jobgrade is '职级表';
comment on column ${iol_schema}.nhrs_om_jobgrade.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.dr is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.jobgradecode is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.jobgradedesc is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.jobgradename is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.jobgradename2 is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.jobgradename3 is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.jobgradename4 is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.jobgradename5 is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.jobgradename6 is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.pk_job is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.pk_jobgrade is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.pk_jobrank is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.pk_jobtype is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.ts is '';
comment on column ${iol_schema}.nhrs_om_jobgrade.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_om_jobgrade.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_om_jobgrade.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_om_jobgrade.etl_timestamp is 'ETL处理时间戳';
