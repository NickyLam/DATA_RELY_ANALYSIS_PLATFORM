/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbd(
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
grant select on ${iol_schema}.isbs_dbd to ${iml_schema};
grant select on ${iol_schema}.isbs_dbd to ${icl_schema};
grant select on ${iol_schema}.isbs_dbd to ${idl_schema};
grant select on ${iol_schema}.isbs_dbd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbd is '';
comment on column ${iol_schema}.isbs_dbd.inr is '';
comment on column ${iol_schema}.isbs_dbd.tmpref is '';
comment on column ${iol_schema}.isbs_dbd.ownextkey is '';
comment on column ${iol_schema}.isbs_dbd.ver is '';
comment on column ${iol_schema}.isbs_dbd.actiontype is '';
comment on column ${iol_schema}.isbs_dbd.actiondesc is '';
comment on column ${iol_schema}.isbs_dbd.rptno is '';
comment on column ${iol_schema}.isbs_dbd.custype is '';
comment on column ${iol_schema}.isbs_dbd.idcode is '';
comment on column ${iol_schema}.isbs_dbd.custcod is '';
comment on column ${iol_schema}.isbs_dbd.custnm is '';
comment on column ${iol_schema}.isbs_dbd.oppuser is '';
comment on column ${iol_schema}.isbs_dbd.txccy is '';
comment on column ${iol_schema}.isbs_dbd.txamt is '';
comment on column ${iol_schema}.isbs_dbd.exrate is '';
comment on column ${iol_schema}.isbs_dbd.lcyamt is '';
comment on column ${iol_schema}.isbs_dbd.lcyacc is '';
comment on column ${iol_schema}.isbs_dbd.fcyamt is '';
comment on column ${iol_schema}.isbs_dbd.fcyacc is '';
comment on column ${iol_schema}.isbs_dbd.othamt is '';
comment on column ${iol_schema}.isbs_dbd.othacc is '';
comment on column ${iol_schema}.isbs_dbd.methods is '';
comment on column ${iol_schema}.isbs_dbd.buscode is '';
comment on column ${iol_schema}.isbs_dbd.inchargeccy is '';
comment on column ${iol_schema}.isbs_dbd.inchargeamt is '';
comment on column ${iol_schema}.isbs_dbd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbd.etl_timestamp is 'ETL处理时间戳';
