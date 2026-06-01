/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dba
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dba
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dba purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dba(
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
    ,inchargeccy varchar2(5) -- 
    ,inchargeamt number(22,0) -- 
    ,outchargeccy varchar2(5) -- 
    ,outchargeamt number(22,0) -- 
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
grant select on ${iol_schema}.isbs_dba to ${iml_schema};
grant select on ${iol_schema}.isbs_dba to ${icl_schema};
grant select on ${iol_schema}.isbs_dba to ${idl_schema};
grant select on ${iol_schema}.isbs_dba to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dba is '';
comment on column ${iol_schema}.isbs_dba.inr is '';
comment on column ${iol_schema}.isbs_dba.tmpref is '';
comment on column ${iol_schema}.isbs_dba.ownextkey is '';
comment on column ${iol_schema}.isbs_dba.ver is '';
comment on column ${iol_schema}.isbs_dba.actiontype is '';
comment on column ${iol_schema}.isbs_dba.actiondesc is '';
comment on column ${iol_schema}.isbs_dba.rptno is '';
comment on column ${iol_schema}.isbs_dba.custype is '';
comment on column ${iol_schema}.isbs_dba.idcode is '';
comment on column ${iol_schema}.isbs_dba.custcod is '';
comment on column ${iol_schema}.isbs_dba.custnm is '';
comment on column ${iol_schema}.isbs_dba.oppuser is '';
comment on column ${iol_schema}.isbs_dba.txccy is '';
comment on column ${iol_schema}.isbs_dba.txamt is '';
comment on column ${iol_schema}.isbs_dba.exrate is '';
comment on column ${iol_schema}.isbs_dba.lcyamt is '';
comment on column ${iol_schema}.isbs_dba.lcyacc is '';
comment on column ${iol_schema}.isbs_dba.fcyamt is '';
comment on column ${iol_schema}.isbs_dba.fcyacc is '';
comment on column ${iol_schema}.isbs_dba.othamt is '';
comment on column ${iol_schema}.isbs_dba.othacc is '';
comment on column ${iol_schema}.isbs_dba.methods is '';
comment on column ${iol_schema}.isbs_dba.buscode is '';
comment on column ${iol_schema}.isbs_dba.inchargeccy is '';
comment on column ${iol_schema}.isbs_dba.inchargeamt is '';
comment on column ${iol_schema}.isbs_dba.outchargeccy is '';
comment on column ${iol_schema}.isbs_dba.outchargeamt is '';
comment on column ${iol_schema}.isbs_dba.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dba.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dba.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dba.etl_timestamp is 'ETL处理时间戳';
