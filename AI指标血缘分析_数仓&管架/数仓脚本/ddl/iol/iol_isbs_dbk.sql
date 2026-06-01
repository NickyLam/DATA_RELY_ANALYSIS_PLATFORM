/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbk
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbk(
    inr varchar2(12) -- 
    ,tmpref varchar2(24) -- 
    ,ownextkey varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,actiontype varchar2(2) -- 
    ,actiondesc varchar2(198) -- 
    ,rptno varchar2(33) -- 
    ,country varchar2(5) -- 
    ,paytype varchar2(2) -- 
    ,txcode varchar2(9) -- 
    ,tc1amt number(22,0) -- 
    ,txrem varchar2(396) -- 
    ,txcode2 varchar2(9) -- 
    ,tc2amt number(22,0) -- 
    ,tx2rem varchar2(396) -- 
    ,isref varchar2(2) -- 
    ,crtuser varchar2(30) -- 
    ,inptelc varchar2(30) -- 
    ,rptdate date -- 
    ,regno varchar2(30) -- 
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
grant select on ${iol_schema}.isbs_dbk to ${iml_schema};
grant select on ${iol_schema}.isbs_dbk to ${icl_schema};
grant select on ${iol_schema}.isbs_dbk to ${idl_schema};
grant select on ${iol_schema}.isbs_dbk to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbk is '';
comment on column ${iol_schema}.isbs_dbk.inr is '';
comment on column ${iol_schema}.isbs_dbk.tmpref is '';
comment on column ${iol_schema}.isbs_dbk.ownextkey is '';
comment on column ${iol_schema}.isbs_dbk.ver is '';
comment on column ${iol_schema}.isbs_dbk.actiontype is '';
comment on column ${iol_schema}.isbs_dbk.actiondesc is '';
comment on column ${iol_schema}.isbs_dbk.rptno is '';
comment on column ${iol_schema}.isbs_dbk.country is '';
comment on column ${iol_schema}.isbs_dbk.paytype is '';
comment on column ${iol_schema}.isbs_dbk.txcode is '';
comment on column ${iol_schema}.isbs_dbk.tc1amt is '';
comment on column ${iol_schema}.isbs_dbk.txrem is '';
comment on column ${iol_schema}.isbs_dbk.txcode2 is '';
comment on column ${iol_schema}.isbs_dbk.tc2amt is '';
comment on column ${iol_schema}.isbs_dbk.tx2rem is '';
comment on column ${iol_schema}.isbs_dbk.isref is '';
comment on column ${iol_schema}.isbs_dbk.crtuser is '';
comment on column ${iol_schema}.isbs_dbk.inptelc is '';
comment on column ${iol_schema}.isbs_dbk.rptdate is '';
comment on column ${iol_schema}.isbs_dbk.regno is '';
comment on column ${iol_schema}.isbs_dbk.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbk.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbk.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbk.etl_timestamp is 'ETL处理时间戳';
