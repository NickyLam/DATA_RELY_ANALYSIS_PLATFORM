/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol nhrs_org_dept
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.nhrs_org_dept
whenever sqlerror continue none;
drop table ${iol_schema}.nhrs_org_dept purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_org_dept(
    address varchar2(600) -- 
    ,code varchar2(60) -- 
    ,createdate varchar2(15) -- 
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
    ,deptcanceldate varchar2(15) -- 
    ,deptlevel varchar2(30) -- 
    ,depttype number(38,0) -- 
    ,displayorder number(38,0) -- 
    ,dr number(10,0) -- 
    ,enablestate number(38,0) -- 
    ,hrcanceled varchar2(2) -- 
    ,innercode varchar2(300) -- 
    ,islastversion varchar2(2) -- 
    ,isretail varchar2(2) -- 
    ,memo varchar2(300) -- 
    ,mnecode varchar2(75) -- 
    ,modifiedtime varchar2(29) -- 
    ,modifier varchar2(30) -- 
    ,name varchar2(450) -- 
    ,name2 varchar2(450) -- 
    ,name3 varchar2(450) -- 
    ,name4 varchar2(450) -- 
    ,name5 varchar2(450) -- 
    ,name6 varchar2(450) -- 
    ,orgtype13 varchar2(2) -- 
    ,orgtype17 varchar2(2) -- 
    ,pk_dept varchar2(30) -- 
    ,pk_fatherorg varchar2(30) -- 
    ,pk_group varchar2(30) -- 
    ,pk_org varchar2(30) -- 
    ,pk_vid varchar2(30) -- 
    ,principal varchar2(30) -- 
    ,resposition varchar2(30) -- 
    ,shortname varchar2(450) -- 
    ,shortname2 varchar2(450) -- 
    ,shortname3 varchar2(450) -- 
    ,shortname4 varchar2(450) -- 
    ,shortname5 varchar2(450) -- 
    ,shortname6 varchar2(450) -- 
    ,tel varchar2(45) -- 
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
    ,deptduty varchar2(1536) -- 
    ,glbdef1 varchar2(30) -- 
    ,glbdef2 varchar2(2) -- 
    ,glbdef3 varchar2(192) -- 
    ,glbdef4 varchar2(192) -- 
    ,glbdef5 varchar2(30) -- 
    ,glbdef6 varchar2(30) -- 
    ,glbdef7 number(22,0) -- 
    ,glbdef8 number(22,0) -- 
    ,glbdef9 varchar2(30) -- 
    ,glbdef10 varchar2(30) -- 
    ,glbdef11 varchar2(30) -- 
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
grant select on ${iol_schema}.nhrs_org_dept to ${iml_schema};
grant select on ${iol_schema}.nhrs_org_dept to ${icl_schema};
grant select on ${iol_schema}.nhrs_org_dept to ${idl_schema};
grant select on ${iol_schema}.nhrs_org_dept to ${iel_schema};

-- comment
comment on table ${iol_schema}.nhrs_org_dept is '组织_部门表';
comment on column ${iol_schema}.nhrs_org_dept.address is '';
comment on column ${iol_schema}.nhrs_org_dept.code is '';
comment on column ${iol_schema}.nhrs_org_dept.createdate is '';
comment on column ${iol_schema}.nhrs_org_dept.creationtime is '';
comment on column ${iol_schema}.nhrs_org_dept.creator is '';
comment on column ${iol_schema}.nhrs_org_dept.dataoriginflag is '';
comment on column ${iol_schema}.nhrs_org_dept.def1 is '';
comment on column ${iol_schema}.nhrs_org_dept.def10 is '';
comment on column ${iol_schema}.nhrs_org_dept.def11 is '';
comment on column ${iol_schema}.nhrs_org_dept.def12 is '';
comment on column ${iol_schema}.nhrs_org_dept.def13 is '';
comment on column ${iol_schema}.nhrs_org_dept.def14 is '';
comment on column ${iol_schema}.nhrs_org_dept.def15 is '';
comment on column ${iol_schema}.nhrs_org_dept.def16 is '';
comment on column ${iol_schema}.nhrs_org_dept.def17 is '';
comment on column ${iol_schema}.nhrs_org_dept.def18 is '';
comment on column ${iol_schema}.nhrs_org_dept.def19 is '';
comment on column ${iol_schema}.nhrs_org_dept.def2 is '';
comment on column ${iol_schema}.nhrs_org_dept.def20 is '';
comment on column ${iol_schema}.nhrs_org_dept.def3 is '';
comment on column ${iol_schema}.nhrs_org_dept.def4 is '';
comment on column ${iol_schema}.nhrs_org_dept.def5 is '';
comment on column ${iol_schema}.nhrs_org_dept.def6 is '';
comment on column ${iol_schema}.nhrs_org_dept.def7 is '';
comment on column ${iol_schema}.nhrs_org_dept.def8 is '';
comment on column ${iol_schema}.nhrs_org_dept.def9 is '';
comment on column ${iol_schema}.nhrs_org_dept.deptcanceldate is '';
comment on column ${iol_schema}.nhrs_org_dept.deptlevel is '';
comment on column ${iol_schema}.nhrs_org_dept.depttype is '';
comment on column ${iol_schema}.nhrs_org_dept.displayorder is '';
comment on column ${iol_schema}.nhrs_org_dept.dr is '';
comment on column ${iol_schema}.nhrs_org_dept.enablestate is '';
comment on column ${iol_schema}.nhrs_org_dept.hrcanceled is '';
comment on column ${iol_schema}.nhrs_org_dept.innercode is '';
comment on column ${iol_schema}.nhrs_org_dept.islastversion is '';
comment on column ${iol_schema}.nhrs_org_dept.isretail is '';
comment on column ${iol_schema}.nhrs_org_dept.memo is '';
comment on column ${iol_schema}.nhrs_org_dept.mnecode is '';
comment on column ${iol_schema}.nhrs_org_dept.modifiedtime is '';
comment on column ${iol_schema}.nhrs_org_dept.modifier is '';
comment on column ${iol_schema}.nhrs_org_dept.name is '';
comment on column ${iol_schema}.nhrs_org_dept.name2 is '';
comment on column ${iol_schema}.nhrs_org_dept.name3 is '';
comment on column ${iol_schema}.nhrs_org_dept.name4 is '';
comment on column ${iol_schema}.nhrs_org_dept.name5 is '';
comment on column ${iol_schema}.nhrs_org_dept.name6 is '';
comment on column ${iol_schema}.nhrs_org_dept.orgtype13 is '';
comment on column ${iol_schema}.nhrs_org_dept.orgtype17 is '';
comment on column ${iol_schema}.nhrs_org_dept.pk_dept is '';
comment on column ${iol_schema}.nhrs_org_dept.pk_fatherorg is '';
comment on column ${iol_schema}.nhrs_org_dept.pk_group is '';
comment on column ${iol_schema}.nhrs_org_dept.pk_org is '';
comment on column ${iol_schema}.nhrs_org_dept.pk_vid is '';
comment on column ${iol_schema}.nhrs_org_dept.principal is '';
comment on column ${iol_schema}.nhrs_org_dept.resposition is '';
comment on column ${iol_schema}.nhrs_org_dept.shortname is '';
comment on column ${iol_schema}.nhrs_org_dept.shortname2 is '';
comment on column ${iol_schema}.nhrs_org_dept.shortname3 is '';
comment on column ${iol_schema}.nhrs_org_dept.shortname4 is '';
comment on column ${iol_schema}.nhrs_org_dept.shortname5 is '';
comment on column ${iol_schema}.nhrs_org_dept.shortname6 is '';
comment on column ${iol_schema}.nhrs_org_dept.tel is '';
comment on column ${iol_schema}.nhrs_org_dept.ts is '';
comment on column ${iol_schema}.nhrs_org_dept.venddate is '';
comment on column ${iol_schema}.nhrs_org_dept.vname is '';
comment on column ${iol_schema}.nhrs_org_dept.vname2 is '';
comment on column ${iol_schema}.nhrs_org_dept.vname3 is '';
comment on column ${iol_schema}.nhrs_org_dept.vname4 is '';
comment on column ${iol_schema}.nhrs_org_dept.vname5 is '';
comment on column ${iol_schema}.nhrs_org_dept.vname6 is '';
comment on column ${iol_schema}.nhrs_org_dept.vno is '';
comment on column ${iol_schema}.nhrs_org_dept.vstartdate is '';
comment on column ${iol_schema}.nhrs_org_dept.deptduty is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef1 is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef2 is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef3 is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef4 is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef5 is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef6 is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef7 is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef8 is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef9 is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef10 is '';
comment on column ${iol_schema}.nhrs_org_dept.glbdef11 is '';
comment on column ${iol_schema}.nhrs_org_dept.start_dt is '开始时间';
comment on column ${iol_schema}.nhrs_org_dept.end_dt is '结束时间';
comment on column ${iol_schema}.nhrs_org_dept.id_mark is '增删标志';
comment on column ${iol_schema}.nhrs_org_dept.etl_timestamp is 'ETL处理时间戳';
