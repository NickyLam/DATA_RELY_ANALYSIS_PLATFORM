/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_org_adminorg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_org_adminorg
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_org_adminorg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_org_adminorg(
    code varchar2(75) -- 
    ,creationtime varchar2(29) -- 
    ,creator varchar2(30) -- 
    ,dataoriginflag number(38,0) -- 
    ,def1 varchar2(152) -- 
    ,def10 varchar2(152) -- 
    ,def11 varchar2(152) -- 
    ,def12 varchar2(152) -- 
    ,def13 varchar2(152) -- 
    ,def14 varchar2(152) -- 
    ,def15 varchar2(152) -- 
    ,def16 varchar2(152) -- 
    ,def17 varchar2(152) -- 
    ,def18 varchar2(152) -- 
    ,def19 varchar2(152) -- 
    ,def2 varchar2(152) -- 
    ,def20 varchar2(152) -- 
    ,def3 varchar2(152) -- 
    ,def4 varchar2(152) -- 
    ,def5 varchar2(152) -- 
    ,def6 varchar2(152) -- 
    ,def7 varchar2(152) -- 
    ,def8 varchar2(152) -- 
    ,def9 varchar2(152) -- 
    ,devicemanage varchar2(2) -- 
    ,displayorder number(38,0) -- 
    ,dr number(10,0) -- 
    ,enablestate number(38,0) -- 
    ,innercode varchar2(300) -- 
    ,islastversion varchar2(2) -- 
    ,isreceivesenddoc varchar2(2) -- 
    ,mnecode varchar2(113) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,name varchar2(450) -- 
    ,name2 varchar2(450) -- 
    ,name3 varchar2(450) -- 
    ,name4 varchar2(450) -- 
    ,name5 varchar2(450) -- 
    ,name6 varchar2(450) -- 
    ,pk_adminorg varchar2(30) -- 
    ,pk_fatherorg varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pk_vid varchar2(30) -- 
    ,shortname varchar2(450) -- 
    ,shortname2 varchar2(450) -- 
    ,shortname3 varchar2(450) -- 
    ,shortname4 varchar2(450) -- 
    ,shortname5 varchar2(450) -- 
    ,shortname6 varchar2(450) -- 
    ,suppliesmanage varchar2(2) -- 
    ,ts varchar2(29) -- 
    ,venddate varchar2(29) -- 
    ,vname varchar2(450) -- 
    ,vname2 varchar2(450) -- 
    ,vname3 varchar2(450) -- 
    ,vname4 varchar2(450) -- 
    ,vname5 varchar2(450) -- 
    ,vname6 varchar2(450) -- 
    ,vno varchar2(75) -- 
    ,vstartdate varchar2(29) -- 
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
grant select on ${iol_schema}.nhrs_org_adminorg to ${iml_schema};
grant select on ${iol_schema}.nhrs_org_adminorg to ${icl_schema};
grant select on ${iol_schema}.nhrs_org_adminorg to ${idl_schema};
grant select on ${iol_schema}.nhrs_org_adminorg to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_org_adminorg is '行政组织表';
comment on column ${iol_schema}.nhrs_org_adminorg.code is '';
comment on column ${iol_schema}.nhrs_org_adminorg.creationtime is '';
comment on column ${iol_schema}.nhrs_org_adminorg.creator is '';
comment on column ${iol_schema}.nhrs_org_adminorg.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def1 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def10 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def11 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def12 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def13 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def14 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def15 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def16 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def17 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def18 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def19 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def2 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def20 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def3 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def4 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def5 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def6 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def7 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def8 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.def9 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.devicemanage is '';
comment on column ${iol_schema}.nhrs_org_adminorg.displayorder is '';
comment on column ${iol_schema}.nhrs_org_adminorg.dr is '';
comment on column ${iol_schema}.nhrs_org_adminorg.enablestate is '';
comment on column ${iol_schema}.nhrs_org_adminorg.innercode is '';
comment on column ${iol_schema}.nhrs_org_adminorg.islastversion is '';
comment on column ${iol_schema}.nhrs_org_adminorg.isreceivesenddoc is '';
comment on column ${iol_schema}.nhrs_org_adminorg.mnecode is '';
comment on column ${iol_schema}.nhrs_org_adminorg.modifiedtime is '';
comment on column ${iol_schema}.nhrs_org_adminorg.modifier is '';
comment on column ${iol_schema}.nhrs_org_adminorg.name is '';
comment on column ${iol_schema}.nhrs_org_adminorg.name2 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.name3 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.name4 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.name5 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.name6 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.pk_adminorg is '';
comment on column ${iol_schema}.nhrs_org_adminorg.pk_fatherorg is '';
comment on column ${iol_schema}.nhrs_org_adminorg.pk_group is '';
comment on column ${iol_schema}.nhrs_org_adminorg.pk_org is '';
comment on column ${iol_schema}.nhrs_org_adminorg.pk_vid is '';
comment on column ${iol_schema}.nhrs_org_adminorg.shortname is '';
comment on column ${iol_schema}.nhrs_org_adminorg.shortname2 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.shortname3 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.shortname4 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.shortname5 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.shortname6 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.suppliesmanage is '';
comment on column ${iol_schema}.nhrs_org_adminorg.ts is '';
comment on column ${iol_schema}.nhrs_org_adminorg.venddate is '';
comment on column ${iol_schema}.nhrs_org_adminorg.vname is '';
comment on column ${iol_schema}.nhrs_org_adminorg.vname2 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.vname3 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.vname4 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.vname5 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.vname6 is '';
comment on column ${iol_schema}.nhrs_org_adminorg.vno is '';
comment on column ${iol_schema}.nhrs_org_adminorg.vstartdate is '';
comment on column ${iol_schema}.nhrs_org_adminorg.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_org_adminorg.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_org_adminorg.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_org_adminorg.etl_timestamp is 'ETL处理时间戳';
