/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_eta
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_eta
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_eta purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_eta(
    priflg varchar2(2) -- 
    ,inr varchar2(12) -- 
    ,bolrid varchar2(120) -- 
    ,ety varchar2(12) -- 
    ,etgeml varchar2(120) -- 
    ,tlx varchar2(30) -- 
    ,extkey varchar2(12) -- 
    ,etgextkey varchar2(12) -- 
    ,nam varchar2(60) -- 
    ,fax varchar2(30) -- 
    ,eml varchar2(53) -- 
    ,tel varchar2(30) -- 
    ,blz varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,tid varchar2(35) -- 
    ,bic varchar2(18) -- 
    ,web varchar2(53) -- 
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
grant select on ${iol_schema}.isbs_eta to ${iml_schema};
grant select on ${iol_schema}.isbs_eta to ${icl_schema};
grant select on ${iol_schema}.isbs_eta to ${idl_schema};
grant select on ${iol_schema}.isbs_eta to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_eta is '实体地址';
comment on column ${iol_schema}.isbs_eta.priflg is '';
comment on column ${iol_schema}.isbs_eta.inr is '';
comment on column ${iol_schema}.isbs_eta.bolrid is '';
comment on column ${iol_schema}.isbs_eta.ety is '';
comment on column ${iol_schema}.isbs_eta.etgeml is '';
comment on column ${iol_schema}.isbs_eta.tlx is '';
comment on column ${iol_schema}.isbs_eta.extkey is '';
comment on column ${iol_schema}.isbs_eta.etgextkey is '';
comment on column ${iol_schema}.isbs_eta.nam is '';
comment on column ${iol_schema}.isbs_eta.fax is '';
comment on column ${iol_schema}.isbs_eta.eml is '';
comment on column ${iol_schema}.isbs_eta.tel is '';
comment on column ${iol_schema}.isbs_eta.blz is '';
comment on column ${iol_schema}.isbs_eta.ver is '';
comment on column ${iol_schema}.isbs_eta.tid is '';
comment on column ${iol_schema}.isbs_eta.bic is '';
comment on column ${iol_schema}.isbs_eta.web is '';
comment on column ${iol_schema}.isbs_eta.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_eta.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_eta.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_eta.etl_timestamp is 'ETL处理时间戳';
