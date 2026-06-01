/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbc
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbc
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbc purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbc(
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
    ,actuccy varchar2(5) -- 
    ,actuamt number(22,0) -- 
    ,outchargeccy varchar2(5) -- 
    ,outchargeamt number(22,0) -- 
    ,lcbgno varchar2(30) -- 
    ,issdate date -- 
    ,tenor number(10,0) -- 
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
grant select on ${iol_schema}.isbs_dbc to ${iml_schema};
grant select on ${iol_schema}.isbs_dbc to ${icl_schema};
grant select on ${iol_schema}.isbs_dbc to ${idl_schema};
grant select on ${iol_schema}.isbs_dbc to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbc is '';
comment on column ${iol_schema}.isbs_dbc.inr is '';
comment on column ${iol_schema}.isbs_dbc.tmpref is '';
comment on column ${iol_schema}.isbs_dbc.ownextkey is '';
comment on column ${iol_schema}.isbs_dbc.ver is '';
comment on column ${iol_schema}.isbs_dbc.actiontype is '';
comment on column ${iol_schema}.isbs_dbc.actiondesc is '';
comment on column ${iol_schema}.isbs_dbc.rptno is '';
comment on column ${iol_schema}.isbs_dbc.custype is '';
comment on column ${iol_schema}.isbs_dbc.idcode is '';
comment on column ${iol_schema}.isbs_dbc.custcod is '';
comment on column ${iol_schema}.isbs_dbc.custnm is '';
comment on column ${iol_schema}.isbs_dbc.oppuser is '';
comment on column ${iol_schema}.isbs_dbc.txccy is '';
comment on column ${iol_schema}.isbs_dbc.txamt is '';
comment on column ${iol_schema}.isbs_dbc.exrate is '';
comment on column ${iol_schema}.isbs_dbc.lcyamt is '';
comment on column ${iol_schema}.isbs_dbc.lcyacc is '';
comment on column ${iol_schema}.isbs_dbc.fcyamt is '';
comment on column ${iol_schema}.isbs_dbc.fcyacc is '';
comment on column ${iol_schema}.isbs_dbc.othamt is '';
comment on column ${iol_schema}.isbs_dbc.othacc is '';
comment on column ${iol_schema}.isbs_dbc.methods is '';
comment on column ${iol_schema}.isbs_dbc.buscode is '';
comment on column ${iol_schema}.isbs_dbc.actuccy is '';
comment on column ${iol_schema}.isbs_dbc.actuamt is '';
comment on column ${iol_schema}.isbs_dbc.outchargeccy is '';
comment on column ${iol_schema}.isbs_dbc.outchargeamt is '';
comment on column ${iol_schema}.isbs_dbc.lcbgno is '';
comment on column ${iol_schema}.isbs_dbc.issdate is '';
comment on column ${iol_schema}.isbs_dbc.tenor is '';
comment on column ${iol_schema}.isbs_dbc.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbc.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbc.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbc.etl_timestamp is 'ETL处理时间戳';
