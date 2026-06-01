/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_dbj
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_dbj
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_dbj purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_dbj(
    lcyacc varchar2(48) -- 
    ,fcyacc varchar2(48) -- 
    ,fcyamt number(22,0) -- 
    ,oppbank varchar2(384) -- 
    ,buscode varchar2(33) -- 
    ,ver varchar2(6) -- 
    ,rptno varchar2(33) -- 
    ,custnm varchar2(192) -- 
    ,actiontype varchar2(2) -- 
    ,ownextkey varchar2(12) -- 
    ,inr varchar2(12) -- 
    ,fcyccy varchar2(5) -- 
    ,exrate number(13,8) -- 
    ,custcod varchar2(14) -- 
    ,oppuser varchar2(192) -- 
    ,idcode varchar2(48) -- 
    ,custype varchar2(2) -- 
    ,actiondesc varchar2(192) -- 
    ,tmpref varchar2(24) -- 
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
grant select on ${iol_schema}.isbs_dbj to ${iml_schema};
grant select on ${iol_schema}.isbs_dbj to ${icl_schema};
grant select on ${iol_schema}.isbs_dbj to ${idl_schema};
grant select on ${iol_schema}.isbs_dbj to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_dbj is '结汇申请书-基础信息';
comment on column ${iol_schema}.isbs_dbj.lcyacc is '';
comment on column ${iol_schema}.isbs_dbj.fcyacc is '';
comment on column ${iol_schema}.isbs_dbj.fcyamt is '';
comment on column ${iol_schema}.isbs_dbj.oppbank is '';
comment on column ${iol_schema}.isbs_dbj.buscode is '';
comment on column ${iol_schema}.isbs_dbj.ver is '';
comment on column ${iol_schema}.isbs_dbj.rptno is '';
comment on column ${iol_schema}.isbs_dbj.custnm is '';
comment on column ${iol_schema}.isbs_dbj.actiontype is '';
comment on column ${iol_schema}.isbs_dbj.ownextkey is '';
comment on column ${iol_schema}.isbs_dbj.inr is '';
comment on column ${iol_schema}.isbs_dbj.fcyccy is '';
comment on column ${iol_schema}.isbs_dbj.exrate is '';
comment on column ${iol_schema}.isbs_dbj.custcod is '';
comment on column ${iol_schema}.isbs_dbj.oppuser is '';
comment on column ${iol_schema}.isbs_dbj.idcode is '';
comment on column ${iol_schema}.isbs_dbj.custype is '';
comment on column ${iol_schema}.isbs_dbj.actiondesc is '';
comment on column ${iol_schema}.isbs_dbj.tmpref is '';
comment on column ${iol_schema}.isbs_dbj.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_dbj.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_dbj.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_dbj.etl_timestamp is 'ETL处理时间戳';
