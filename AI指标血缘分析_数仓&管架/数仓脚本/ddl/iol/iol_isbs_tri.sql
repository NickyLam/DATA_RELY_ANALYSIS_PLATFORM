/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol isbs_tri
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.isbs_tri
whenever sqlerror continue none;
drop table ${iol_schema}.isbs_tri purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_tri(
    trninr varchar2(12) -- 交易索引
    ,itfinr varchar2(21) -- 记账核心流水号
    ,type varchar2(2) -- 类型
    ,coreinr varchar2(21) -- 冲正核心流水号
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.isbs_tri to ${iml_schema};
grant select on ${iol_schema}.isbs_tri to ${icl_schema};
grant select on ${iol_schema}.isbs_tri to ${idl_schema};
grant select on ${iol_schema}.isbs_tri to ${iel_schema};

-- comment
comment on table ${iol_schema}.isbs_tri is '核心流水号';
comment on column ${iol_schema}.isbs_tri.trninr is '交易索引';
comment on column ${iol_schema}.isbs_tri.itfinr is '记账核心流水号';
comment on column ${iol_schema}.isbs_tri.type is '类型';
comment on column ${iol_schema}.isbs_tri.coreinr is '冲正核心流水号';
comment on column ${iol_schema}.isbs_tri.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.isbs_tri.etl_timestamp is 'ETL处理时间戳';
