/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_gwd
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_gwd
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_gwd purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_gwd(
    opndat date -- 
    ,ver varchar2(6) -- 
    ,credat date -- 
    ,valdat date -- 
    ,nam varchar2(60) -- 
    ,inr varchar2(12) -- 
    ,wrkgrp varchar2(12) -- 
    ,rpflg varchar2(2) -- 
    ,clsdat date -- 
    ,checkflg varchar2(2) -- 
    ,bustyp varchar2(9) -- 
    ,rptyp varchar2(3) -- 
    ,ownusr varchar2(12) -- 
    ,cdflg varchar2(2) -- 
    ,etyextkey varchar2(12) -- 
    ,ownref varchar2(24) -- 
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
grant select on ${iol_schema}.isbs_gwd to ${iml_schema};
grant select on ${iol_schema}.isbs_gwd to ${icl_schema};
grant select on ${iol_schema}.isbs_gwd to ${idl_schema};
grant select on ${iol_schema}.isbs_gwd to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_gwd is '汇入清算';
comment on column ${iol_schema}.isbs_gwd.opndat is '';
comment on column ${iol_schema}.isbs_gwd.ver is '';
comment on column ${iol_schema}.isbs_gwd.credat is '';
comment on column ${iol_schema}.isbs_gwd.valdat is '';
comment on column ${iol_schema}.isbs_gwd.nam is '';
comment on column ${iol_schema}.isbs_gwd.inr is '';
comment on column ${iol_schema}.isbs_gwd.wrkgrp is '';
comment on column ${iol_schema}.isbs_gwd.rpflg is '';
comment on column ${iol_schema}.isbs_gwd.clsdat is '';
comment on column ${iol_schema}.isbs_gwd.checkflg is '';
comment on column ${iol_schema}.isbs_gwd.bustyp is '';
comment on column ${iol_schema}.isbs_gwd.rptyp is '';
comment on column ${iol_schema}.isbs_gwd.ownusr is '';
comment on column ${iol_schema}.isbs_gwd.cdflg is '';
comment on column ${iol_schema}.isbs_gwd.etyextkey is '';
comment on column ${iol_schema}.isbs_gwd.ownref is '';
comment on column ${iol_schema}.isbs_gwd.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_gwd.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_gwd.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_gwd.etl_timestamp is 'ETL处理时间戳';
