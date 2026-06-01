/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbe
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbe
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbe purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbe(
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
    ,oppacc varchar2(48) -- 
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
grant select on ${iol_schema}.isbs_dbe to ${iml_schema};
grant select on ${iol_schema}.isbs_dbe to ${icl_schema};
grant select on ${iol_schema}.isbs_dbe to ${idl_schema};
grant select on ${iol_schema}.isbs_dbe to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbe is '';
comment on column ${iol_schema}.isbs_dbe.inr is '';
comment on column ${iol_schema}.isbs_dbe.tmpref is '';
comment on column ${iol_schema}.isbs_dbe.ownextkey is '';
comment on column ${iol_schema}.isbs_dbe.ver is '';
comment on column ${iol_schema}.isbs_dbe.actiontype is '';
comment on column ${iol_schema}.isbs_dbe.actiondesc is '';
comment on column ${iol_schema}.isbs_dbe.rptno is '';
comment on column ${iol_schema}.isbs_dbe.custype is '';
comment on column ${iol_schema}.isbs_dbe.idcode is '';
comment on column ${iol_schema}.isbs_dbe.custcod is '';
comment on column ${iol_schema}.isbs_dbe.custnm is '';
comment on column ${iol_schema}.isbs_dbe.oppuser is '';
comment on column ${iol_schema}.isbs_dbe.txccy is '';
comment on column ${iol_schema}.isbs_dbe.txamt is '';
comment on column ${iol_schema}.isbs_dbe.exrate is '';
comment on column ${iol_schema}.isbs_dbe.lcyamt is '';
comment on column ${iol_schema}.isbs_dbe.lcyacc is '';
comment on column ${iol_schema}.isbs_dbe.fcyamt is '';
comment on column ${iol_schema}.isbs_dbe.fcyacc is '';
comment on column ${iol_schema}.isbs_dbe.othamt is '';
comment on column ${iol_schema}.isbs_dbe.othacc is '';
comment on column ${iol_schema}.isbs_dbe.methods is '';
comment on column ${iol_schema}.isbs_dbe.buscode is '';
comment on column ${iol_schema}.isbs_dbe.oppacc is '';
comment on column ${iol_schema}.isbs_dbe.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbe.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbe.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbe.etl_timestamp is 'ETL处理时间戳';
