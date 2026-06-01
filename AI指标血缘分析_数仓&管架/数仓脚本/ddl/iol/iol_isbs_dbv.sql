/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbv
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbv
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbv purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbv(
    rptno varchar2(33) -- 
    ,usedetail varchar2(150) -- 
    ,usetype varchar2(5) -- 
    ,ver varchar2(6) -- 
    ,rptdate date -- 
    ,crtuser varchar2(30) -- 
    ,actiontype varchar2(2) -- 
    ,tmpref varchar2(24) -- 
    ,inptelc varchar2(30) -- 
    ,regno varchar2(30) -- 
    ,actiondesc varchar2(192) -- 
    ,txcode varchar2(9) -- 
    ,ownextkey varchar2(12) -- 
    ,inr varchar2(12) -- 
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
grant select on ${iol_schema}.isbs_dbv to ${iml_schema};
grant select on ${iol_schema}.isbs_dbv to ${icl_schema};
grant select on ${iol_schema}.isbs_dbv to ${idl_schema};
grant select on ${iol_schema}.isbs_dbv to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbv is '结汇申请书-管理信息';
comment on column ${iol_schema}.isbs_dbv.rptno is '';
comment on column ${iol_schema}.isbs_dbv.usedetail is '';
comment on column ${iol_schema}.isbs_dbv.usetype is '';
comment on column ${iol_schema}.isbs_dbv.ver is '';
comment on column ${iol_schema}.isbs_dbv.rptdate is '';
comment on column ${iol_schema}.isbs_dbv.crtuser is '';
comment on column ${iol_schema}.isbs_dbv.actiontype is '';
comment on column ${iol_schema}.isbs_dbv.tmpref is '';
comment on column ${iol_schema}.isbs_dbv.inptelc is '';
comment on column ${iol_schema}.isbs_dbv.regno is '';
comment on column ${iol_schema}.isbs_dbv.actiondesc is '';
comment on column ${iol_schema}.isbs_dbv.txcode is '';
comment on column ${iol_schema}.isbs_dbv.ownextkey is '';
comment on column ${iol_schema}.isbs_dbv.inr is '';
comment on column ${iol_schema}.isbs_dbv.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbv.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbv.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbv.etl_timestamp is 'ETL处理时间戳';
