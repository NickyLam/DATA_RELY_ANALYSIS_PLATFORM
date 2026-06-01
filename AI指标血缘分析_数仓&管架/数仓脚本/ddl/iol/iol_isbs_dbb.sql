/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbb
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbb purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbb(
    inr varchar2(12) -- 
    ,tmpref varchar2(24) -- 
    ,ownextkey varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,actiontype varchar2(2) -- 
    ,actiondesc varchar2(198) -- 
    ,rptno varchar2(33) -- 
    ,custype varchar2(2) -- 
    ,idcode varchar2(48) -- 
    ,custcod varchar2(27) -- 
    ,custnm varchar2(195) -- 
    ,oppuser varchar2(195) -- 
    ,txccy varchar2(5) -- 
    ,txamt number(22,0) -- 
    ,exrate number(13,8) -- 
    ,lcyamt number(22,0) -- 
    ,lcyacc varchar2(48) -- 
    ,fcyamt number(22,0) -- 
    ,fcyacc varchar2(48) -- 
    ,othamt number(22,0) -- 
    ,othacc varchar2(48) -- 
    ,methods varchar2(2) -- 
    ,buscode varchar2(33) -- 
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
grant select on ${iol_schema}.isbs_dbb to ${iml_schema};
grant select on ${iol_schema}.isbs_dbb to ${icl_schema};
grant select on ${iol_schema}.isbs_dbb to ${idl_schema};
grant select on ${iol_schema}.isbs_dbb to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbb is '';
comment on column ${iol_schema}.isbs_dbb.inr is '';
comment on column ${iol_schema}.isbs_dbb.tmpref is '';
comment on column ${iol_schema}.isbs_dbb.ownextkey is '';
comment on column ${iol_schema}.isbs_dbb.ver is '';
comment on column ${iol_schema}.isbs_dbb.actiontype is '';
comment on column ${iol_schema}.isbs_dbb.actiondesc is '';
comment on column ${iol_schema}.isbs_dbb.rptno is '';
comment on column ${iol_schema}.isbs_dbb.custype is '';
comment on column ${iol_schema}.isbs_dbb.idcode is '';
comment on column ${iol_schema}.isbs_dbb.custcod is '';
comment on column ${iol_schema}.isbs_dbb.custnm is '';
comment on column ${iol_schema}.isbs_dbb.oppuser is '';
comment on column ${iol_schema}.isbs_dbb.txccy is '';
comment on column ${iol_schema}.isbs_dbb.txamt is '';
comment on column ${iol_schema}.isbs_dbb.exrate is '';
comment on column ${iol_schema}.isbs_dbb.lcyamt is '';
comment on column ${iol_schema}.isbs_dbb.lcyacc is '';
comment on column ${iol_schema}.isbs_dbb.fcyamt is '';
comment on column ${iol_schema}.isbs_dbb.fcyacc is '';
comment on column ${iol_schema}.isbs_dbb.othamt is '';
comment on column ${iol_schema}.isbs_dbb.othacc is '';
comment on column ${iol_schema}.isbs_dbb.methods is '';
comment on column ${iol_schema}.isbs_dbb.buscode is '';
comment on column ${iol_schema}.isbs_dbb.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbb.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbb.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbb.etl_timestamp is 'ETL处理时间戳';
