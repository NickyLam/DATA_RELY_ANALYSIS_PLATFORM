/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbh
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbh
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbh purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbh(
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
grant select on ${iol_schema}.isbs_dbh to ${iml_schema};
grant select on ${iol_schema}.isbs_dbh to ${icl_schema};
grant select on ${iol_schema}.isbs_dbh to ${idl_schema};
grant select on ${iol_schema}.isbs_dbh to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbh is '';
comment on column ${iol_schema}.isbs_dbh.inr is '';
comment on column ${iol_schema}.isbs_dbh.tmpref is '';
comment on column ${iol_schema}.isbs_dbh.ownextkey is '';
comment on column ${iol_schema}.isbs_dbh.ver is '';
comment on column ${iol_schema}.isbs_dbh.actiontype is '';
comment on column ${iol_schema}.isbs_dbh.actiondesc is '';
comment on column ${iol_schema}.isbs_dbh.rptno is '';
comment on column ${iol_schema}.isbs_dbh.country is '';
comment on column ${iol_schema}.isbs_dbh.paytype is '';
comment on column ${iol_schema}.isbs_dbh.txcode is '';
comment on column ${iol_schema}.isbs_dbh.tc1amt is '';
comment on column ${iol_schema}.isbs_dbh.txrem is '';
comment on column ${iol_schema}.isbs_dbh.txcode2 is '';
comment on column ${iol_schema}.isbs_dbh.tc2amt is '';
comment on column ${iol_schema}.isbs_dbh.tx2rem is '';
comment on column ${iol_schema}.isbs_dbh.isref is '';
comment on column ${iol_schema}.isbs_dbh.crtuser is '';
comment on column ${iol_schema}.isbs_dbh.inptelc is '';
comment on column ${iol_schema}.isbs_dbh.rptdate is '';
comment on column ${iol_schema}.isbs_dbh.regno is '';
comment on column ${iol_schema}.isbs_dbh.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbh.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbh.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbh.etl_timestamp is 'ETL处理时间戳';
