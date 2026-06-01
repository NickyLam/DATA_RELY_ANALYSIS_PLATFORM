/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_etg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_etg
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_etg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_etg(
    nam varchar2(60) -- 
    ,xrtratdir number(1,0) -- 
    ,extkey varchar2(12) -- 
    ,inr varchar2(12) -- 
    ,ratbascur varchar2(5) -- 
    ,syscur varchar2(5) -- 
    ,ver varchar2(6) -- 
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
grant select on ${iol_schema}.isbs_etg to ${iml_schema};
grant select on ${iol_schema}.isbs_etg to ${icl_schema};
grant select on ${iol_schema}.isbs_etg to ${idl_schema};
grant select on ${iol_schema}.isbs_etg to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_etg is '实体组';
comment on column ${iol_schema}.isbs_etg.nam is '';
comment on column ${iol_schema}.isbs_etg.xrtratdir is '';
comment on column ${iol_schema}.isbs_etg.extkey is '';
comment on column ${iol_schema}.isbs_etg.inr is '';
comment on column ${iol_schema}.isbs_etg.ratbascur is '';
comment on column ${iol_schema}.isbs_etg.syscur is '';
comment on column ${iol_schema}.isbs_etg.ver is '';
comment on column ${iol_schema}.isbs_etg.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_etg.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_etg.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_etg.etl_timestamp is 'ETL处理时间戳';
