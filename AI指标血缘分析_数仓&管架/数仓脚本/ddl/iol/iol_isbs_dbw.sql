/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbw
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbw(
    actiontype varchar2(2) -- 
    ,rptno varchar2(33) -- 
    ,buscode varchar2(33) -- 
    ,tmpref varchar2(24) -- 
    ,fcyacc varchar2(48) -- 
    ,oppbank varchar2(384) -- 
    ,custcod varchar2(14) -- 
    ,idcode varchar2(48) -- 
    ,lcyccy varchar2(5) -- 
    ,inr varchar2(12) -- 
    ,ownextkey varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,actiondesc varchar2(192) -- 
    ,exrate number(13,8) -- 
    ,custnm varchar2(192) -- 
    ,oppuser varchar2(192) -- 
    ,lcyacc varchar2(48) -- 
    ,lcyamt number(22,0) -- 
    ,custype varchar2(2) -- 
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
grant select on ${iol_schema}.isbs_dbw to ${iml_schema};
grant select on ${iol_schema}.isbs_dbw to ${icl_schema};
grant select on ${iol_schema}.isbs_dbw to ${idl_schema};
grant select on ${iol_schema}.isbs_dbw to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbw is '购汇申请书-申请信息';
comment on column ${iol_schema}.isbs_dbw.actiontype is '';
comment on column ${iol_schema}.isbs_dbw.rptno is '';
comment on column ${iol_schema}.isbs_dbw.buscode is '';
comment on column ${iol_schema}.isbs_dbw.tmpref is '';
comment on column ${iol_schema}.isbs_dbw.fcyacc is '';
comment on column ${iol_schema}.isbs_dbw.oppbank is '';
comment on column ${iol_schema}.isbs_dbw.custcod is '';
comment on column ${iol_schema}.isbs_dbw.idcode is '';
comment on column ${iol_schema}.isbs_dbw.lcyccy is '';
comment on column ${iol_schema}.isbs_dbw.inr is '';
comment on column ${iol_schema}.isbs_dbw.ownextkey is '';
comment on column ${iol_schema}.isbs_dbw.ver is '';
comment on column ${iol_schema}.isbs_dbw.actiondesc is '';
comment on column ${iol_schema}.isbs_dbw.exrate is '';
comment on column ${iol_schema}.isbs_dbw.custnm is '';
comment on column ${iol_schema}.isbs_dbw.oppuser is '';
comment on column ${iol_schema}.isbs_dbw.lcyacc is '';
comment on column ${iol_schema}.isbs_dbw.lcyamt is '';
comment on column ${iol_schema}.isbs_dbw.custype is '';
comment on column ${iol_schema}.isbs_dbw.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbw.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbw.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbw.etl_timestamp is 'ETL处理时间戳';
