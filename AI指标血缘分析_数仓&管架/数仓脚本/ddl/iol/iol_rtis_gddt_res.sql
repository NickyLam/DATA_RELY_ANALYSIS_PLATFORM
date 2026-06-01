/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rtis_gddt_res
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rtis_gddt_res
whenever sqlerror continue none;
drop table ${iol_schema}.rtis_gddt_res purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rtis_gddt_res(
    ip varchar2(50) -- IP地址
    ,oper_county varchar2(50) -- 国家
    ,oper_prov varchar2(50) -- 省份
    ,oper_city varchar2(50) -- 城市
    ,create_time date -- 创建时间
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
grant select on ${iol_schema}.rtis_gddt_res to ${iml_schema};
grant select on ${iol_schema}.rtis_gddt_res to ${icl_schema};
grant select on ${iol_schema}.rtis_gddt_res to ${idl_schema};
grant select on ${iol_schema}.rtis_gddt_res to ${iel_schema};

-- comment
comment on table ${iol_schema}.rtis_gddt_res is '高德地图表';
comment on column ${iol_schema}.rtis_gddt_res.ip is 'IP地址';
comment on column ${iol_schema}.rtis_gddt_res.oper_county is '国家';
comment on column ${iol_schema}.rtis_gddt_res.oper_prov is '省份';
comment on column ${iol_schema}.rtis_gddt_res.oper_city is '城市';
comment on column ${iol_schema}.rtis_gddt_res.create_time is '创建时间';
comment on column ${iol_schema}.rtis_gddt_res.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rtis_gddt_res.etl_timestamp is 'ETL处理时间戳';
