/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbr
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbr(
    inr varchar2(12) -- 
    ,tmpref varchar2(24) -- 
    ,ownextkey varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,actiontype varchar2(2) -- 
    ,actiondesc varchar2(198) -- 
    ,rptno varchar2(33) -- 
    ,isref varchar2(2) -- 
    ,payattr varchar2(2) -- 
    ,paytype varchar2(2) -- 
    ,txcode varchar2(9) -- 
    ,tc1amt number(22,0) -- 
    ,txrem varchar2(396) -- 
    ,txcode2 varchar2(9) -- 
    ,tc2amt number(22,0) -- 
    ,tx2rem varchar2(396) -- 
    ,refnos varchar2(4000) -- 
    ,chkamt number(22,0) -- 
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
grant select on ${iol_schema}.isbs_dbr to ${iml_schema};
grant select on ${iol_schema}.isbs_dbr to ${icl_schema};
grant select on ${iol_schema}.isbs_dbr to ${idl_schema};
grant select on ${iol_schema}.isbs_dbr to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbr is '';
comment on column ${iol_schema}.isbs_dbr.inr is '';
comment on column ${iol_schema}.isbs_dbr.tmpref is '';
comment on column ${iol_schema}.isbs_dbr.ownextkey is '';
comment on column ${iol_schema}.isbs_dbr.ver is '';
comment on column ${iol_schema}.isbs_dbr.actiontype is '';
comment on column ${iol_schema}.isbs_dbr.actiondesc is '';
comment on column ${iol_schema}.isbs_dbr.rptno is '';
comment on column ${iol_schema}.isbs_dbr.isref is '';
comment on column ${iol_schema}.isbs_dbr.payattr is '';
comment on column ${iol_schema}.isbs_dbr.paytype is '';
comment on column ${iol_schema}.isbs_dbr.txcode is '';
comment on column ${iol_schema}.isbs_dbr.tc1amt is '';
comment on column ${iol_schema}.isbs_dbr.txrem is '';
comment on column ${iol_schema}.isbs_dbr.txcode2 is '';
comment on column ${iol_schema}.isbs_dbr.tc2amt is '';
comment on column ${iol_schema}.isbs_dbr.tx2rem is '';
comment on column ${iol_schema}.isbs_dbr.refnos is '';
comment on column ${iol_schema}.isbs_dbr.chkamt is '';
comment on column ${iol_schema}.isbs_dbr.crtuser is '';
comment on column ${iol_schema}.isbs_dbr.inptelc is '';
comment on column ${iol_schema}.isbs_dbr.rptdate is '';
comment on column ${iol_schema}.isbs_dbr.regno is '';
comment on column ${iol_schema}.isbs_dbr.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbr.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbr.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbr.etl_timestamp is 'ETL处理时间戳';
