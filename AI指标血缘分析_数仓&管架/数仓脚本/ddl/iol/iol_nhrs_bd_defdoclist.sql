/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_bd_defdoclist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_bd_defdoclist
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_bd_defdoclist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_bd_defdoclist(
    associatename varchar2(300) -- 
    ,bpfcomponentid varchar2(75) -- 
    ,code varchar2(45) -- 
    ,codectlgrade number(38,0) -- 
    ,coderule varchar2(60) -- 
    ,componentid varchar2(75) -- 
    ,creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,docclass varchar2(75) -- 
    ,doclevel number(38,0) -- 
    ,doctype number(38,0) -- 
    ,dr number(10,0) -- 
    ,funcode varchar2(60) -- 
    ,isgrade varchar2(2) -- 
    ,isrelease varchar2(2) -- 
    ,mngctlmode number(38,0) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,name varchar2(158) -- 
    ,name2 varchar2(158) -- 
    ,name3 varchar2(158) -- 
    ,name4 varchar2(158) -- 
    ,name5 varchar2(158) -- 
    ,name6 varchar2(158) -- 
    ,pk_defdoclist varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_org varchar2(30) -- 
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
grant select on ${iol_schema}.nhrs_bd_defdoclist to ${iml_schema};
grant select on ${iol_schema}.nhrs_bd_defdoclist to ${icl_schema};
grant select on ${iol_schema}.nhrs_bd_defdoclist to ${idl_schema};
grant select on ${iol_schema}.nhrs_bd_defdoclist to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_bd_defdoclist is '数据字典';
comment on column ${iol_schema}.nhrs_bd_defdoclist.associatename is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.bpfcomponentid is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.code is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.codectlgrade is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.coderule is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.componentid is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.creationtime is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.creator is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.docclass is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.doclevel is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.doctype is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.dr is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.funcode is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.isgrade is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.isrelease is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.mngctlmode is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.modifiedtime is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.modifier is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.name is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.name2 is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.name3 is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.name4 is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.name5 is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.name6 is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.pk_defdoclist is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.pk_group is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.pk_org is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.ts is '';
comment on column ${iol_schema}.nhrs_bd_defdoclist.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_bd_defdoclist.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_bd_defdoclist.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_bd_defdoclist.etl_timestamp is 'ETL处理时间戳';
