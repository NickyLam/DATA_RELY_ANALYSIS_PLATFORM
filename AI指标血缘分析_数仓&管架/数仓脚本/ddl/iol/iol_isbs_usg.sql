/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_usg
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_usg
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_usg purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_usg(
    inr varchar2(12) -- 
    ,extkey varchar2(9) -- 
    ,etyextkey varchar2(12) -- 
    ,nam varchar2(60) -- 
    ,ver varchar2(6) -- 
    ,cusmgrflg varchar2(2) -- 
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
grant select on ${iol_schema}.isbs_usg to ${iml_schema};
grant select on ${iol_schema}.isbs_usg to ${icl_schema};
grant select on ${iol_schema}.isbs_usg to ${idl_schema};
grant select on ${iol_schema}.isbs_usg to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_usg is '用户组';
comment on column ${iol_schema}.isbs_usg.inr is '';
comment on column ${iol_schema}.isbs_usg.extkey is '';
comment on column ${iol_schema}.isbs_usg.etyextkey is '';
comment on column ${iol_schema}.isbs_usg.nam is '';
comment on column ${iol_schema}.isbs_usg.ver is '';
comment on column ${iol_schema}.isbs_usg.cusmgrflg is '';
comment on column ${iol_schema}.isbs_usg.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_usg.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_usg.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_usg.etl_timestamp is 'ETL处理时间戳';
