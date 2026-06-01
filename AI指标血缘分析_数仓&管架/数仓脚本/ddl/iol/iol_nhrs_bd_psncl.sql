/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_bd_psncl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_bd_psncl
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_bd_psncl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_bd_psncl(
    code varchar2(60) -- 
    ,creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,dr number(10,0) -- 
    ,enablestate number(38,0) -- 
    ,innercode varchar2(300) -- 
    ,memo varchar2(225) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,name varchar2(450) -- 
    ,name2 varchar2(450) -- 
    ,name3 varchar2(450) -- 
    ,name4 varchar2(450) -- 
    ,name5 varchar2(450) -- 
    ,name6 varchar2(450) -- 
    ,parent_id varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pk_psncl varchar2(30) -- 
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
grant select on ${iol_schema}.nhrs_bd_psncl to ${iml_schema};
grant select on ${iol_schema}.nhrs_bd_psncl to ${icl_schema};
grant select on ${iol_schema}.nhrs_bd_psncl to ${idl_schema};
grant select on ${iol_schema}.nhrs_bd_psncl to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_bd_psncl is '人员类别表';
comment on column ${iol_schema}.nhrs_bd_psncl.code is '';
comment on column ${iol_schema}.nhrs_bd_psncl.creationtime is '';
comment on column ${iol_schema}.nhrs_bd_psncl.creator is '';
comment on column ${iol_schema}.nhrs_bd_psncl.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_bd_psncl.dr is '';
comment on column ${iol_schema}.nhrs_bd_psncl.enablestate is '';
comment on column ${iol_schema}.nhrs_bd_psncl.innercode is '';
comment on column ${iol_schema}.nhrs_bd_psncl.memo is '';
comment on column ${iol_schema}.nhrs_bd_psncl.modifiedtime is '';
comment on column ${iol_schema}.nhrs_bd_psncl.modifier is '';
comment on column ${iol_schema}.nhrs_bd_psncl.name is '';
comment on column ${iol_schema}.nhrs_bd_psncl.name2 is '';
comment on column ${iol_schema}.nhrs_bd_psncl.name3 is '';
comment on column ${iol_schema}.nhrs_bd_psncl.name4 is '';
comment on column ${iol_schema}.nhrs_bd_psncl.name5 is '';
comment on column ${iol_schema}.nhrs_bd_psncl.name6 is '';
comment on column ${iol_schema}.nhrs_bd_psncl.parent_id is '';
comment on column ${iol_schema}.nhrs_bd_psncl.pk_group is '';
comment on column ${iol_schema}.nhrs_bd_psncl.pk_org is '';
comment on column ${iol_schema}.nhrs_bd_psncl.pk_psncl is '';
comment on column ${iol_schema}.nhrs_bd_psncl.seq is '';
comment on column ${iol_schema}.nhrs_bd_psncl.ts is '';
comment on column ${iol_schema}.nhrs_bd_psncl.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_bd_psncl.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_bd_psncl.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_bd_psncl.etl_timestamp is 'ETL处理时间戳';
