/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_ety
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_ety
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_ety purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ety(
    offlog varchar2(57) -- 
    ,coredat date -- 
    ,ver varchar2(6) -- 
    ,admusr varchar2(12) -- 
    ,timzon varchar2(9) -- 
    ,owntid varchar2(35) -- 
    ,userpic varchar2(57) -- 
    ,etg varchar2(12) -- 
    ,extkey varchar2(12) -- 
    ,nam varchar2(60) -- 
    ,clearid varchar2(6) -- 
    ,defrouusg varchar2(9) -- 
    ,defico varchar2(57) -- 
    ,etaextkey varchar2(12) -- 
    ,ownptainr varchar2(12) -- 
    ,ownbic varchar2(18) -- 
    ,letlog varchar2(57) -- 
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
grant select on ${iol_schema}.isbs_ety to ${iml_schema};
grant select on ${iol_schema}.isbs_ety to ${icl_schema};
grant select on ${iol_schema}.isbs_ety to ${idl_schema};
grant select on ${iol_schema}.isbs_ety to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_ety is '实体信息';
comment on column ${iol_schema}.isbs_ety.offlog is '';
comment on column ${iol_schema}.isbs_ety.coredat is '';
comment on column ${iol_schema}.isbs_ety.ver is '';
comment on column ${iol_schema}.isbs_ety.admusr is '';
comment on column ${iol_schema}.isbs_ety.timzon is '';
comment on column ${iol_schema}.isbs_ety.owntid is '';
comment on column ${iol_schema}.isbs_ety.userpic is '';
comment on column ${iol_schema}.isbs_ety.etg is '';
comment on column ${iol_schema}.isbs_ety.extkey is '';
comment on column ${iol_schema}.isbs_ety.nam is '';
comment on column ${iol_schema}.isbs_ety.clearid is '';
comment on column ${iol_schema}.isbs_ety.defrouusg is '';
comment on column ${iol_schema}.isbs_ety.defico is '';
comment on column ${iol_schema}.isbs_ety.etaextkey is '';
comment on column ${iol_schema}.isbs_ety.ownptainr is '';
comment on column ${iol_schema}.isbs_ety.ownbic is '';
comment on column ${iol_schema}.isbs_ety.letlog is '';
comment on column ${iol_schema}.isbs_ety.inr is '';
comment on column ${iol_schema}.isbs_ety.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_ety.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_ety.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_ety.etl_timestamp is 'ETL处理时间戳';
