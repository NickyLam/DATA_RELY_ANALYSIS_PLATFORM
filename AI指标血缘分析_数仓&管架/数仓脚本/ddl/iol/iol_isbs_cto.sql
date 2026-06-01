/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_cto
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_cto
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_cto purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cto(
    ownextkey varchar2(12) -- 
    ,inr varchar2(12) -- 
    ,trninr varchar2(12) -- 
    ,ver varchar2(6) -- 
    ,objtyp varchar2(9) -- 
    ,reldat date -- 
    ,vrfsta varchar2(2) -- 
    ,tmpref varchar2(24) -- 
    ,credat date -- 
    ,rptno varchar2(33) -- 
    ,dclsta varchar2(2) -- 
    ,objinr varchar2(12) -- 
    ,ownusr varchar2(9) -- 
    ,bassta varchar2(2) -- 
    ,trdtyp varchar2(2) -- 
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
grant select on ${iol_schema}.isbs_cto to ${iml_schema};
grant select on ${iol_schema}.isbs_cto to ${icl_schema};
grant select on ${iol_schema}.isbs_cto to ${idl_schema};
grant select on ${iol_schema}.isbs_cto to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_cto is '外汇账户申报信息';
comment on column ${iol_schema}.isbs_cto.ownextkey is '';
comment on column ${iol_schema}.isbs_cto.inr is '';
comment on column ${iol_schema}.isbs_cto.trninr is '';
comment on column ${iol_schema}.isbs_cto.ver is '';
comment on column ${iol_schema}.isbs_cto.objtyp is '';
comment on column ${iol_schema}.isbs_cto.reldat is '';
comment on column ${iol_schema}.isbs_cto.vrfsta is '';
comment on column ${iol_schema}.isbs_cto.tmpref is '';
comment on column ${iol_schema}.isbs_cto.credat is '';
comment on column ${iol_schema}.isbs_cto.rptno is '';
comment on column ${iol_schema}.isbs_cto.dclsta is '';
comment on column ${iol_schema}.isbs_cto.objinr is '';
comment on column ${iol_schema}.isbs_cto.ownusr is '';
comment on column ${iol_schema}.isbs_cto.bassta is '';
comment on column ${iol_schema}.isbs_cto.trdtyp is '';
comment on column ${iol_schema}.isbs_cto.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_cto.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_cto.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_cto.etl_timestamp is 'ETL处理时间戳';
