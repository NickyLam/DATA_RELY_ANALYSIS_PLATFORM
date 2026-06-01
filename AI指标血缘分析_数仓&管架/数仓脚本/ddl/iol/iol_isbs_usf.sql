/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_usf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_usf
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_usf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_usf(
    extkey varchar2(9) -- 
    ,inr varchar2(12) -- 
    ,usrinr varchar2(12) -- 
    ,nam varchar2(60) -- 
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
grant select on ${iol_schema}.isbs_usf to ${iml_schema};
grant select on ${iol_schema}.isbs_usf to ${icl_schema};
grant select on ${iol_schema}.isbs_usf to ${idl_schema};
grant select on ${iol_schema}.isbs_usf to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_usf is '用户Profile表';
comment on column ${iol_schema}.isbs_usf.extkey is '';
comment on column ${iol_schema}.isbs_usf.inr is '';
comment on column ${iol_schema}.isbs_usf.usrinr is '';
comment on column ${iol_schema}.isbs_usf.nam is '';
comment on column ${iol_schema}.isbs_usf.start_dt is '开始时间';
comment on column ${iol_schema}.isbs_usf.end_dt is '结束时间';
comment on column ${iol_schema}.isbs_usf.id_mark is '增删标志';
comment on column ${iol_schema}.isbs_usf.etl_timestamp is 'ETL处理时间戳';
