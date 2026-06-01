/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareindustriesclasscitics
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareindustriesclasscitics
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareindustriesclasscitics purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareindustriesclasscitics(
    object_id varchar2(150) -- 对象ID
    ,wind_code varchar2(60) -- 
    ,s_info_windcode varchar2(60) -- Wind代码
    ,citics_ind_code varchar2(75) -- 中信行业代码
    ,entry_dt varchar2(12) -- 纳入日期
    ,remove_dt varchar2(12) -- 剔除日期
    ,cur_sign varchar2(15) -- 最新标志
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
grant select on ${iol_schema}.wind_ashareindustriesclasscitics to ${iml_schema};
grant select on ${iol_schema}.wind_ashareindustriesclasscitics to ${icl_schema};
grant select on ${iol_schema}.wind_ashareindustriesclasscitics to ${idl_schema};
grant select on ${iol_schema}.wind_ashareindustriesclasscitics to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareindustriesclasscitics is '中国A股中信行业分类';
comment on column ${iol_schema}.wind_ashareindustriesclasscitics.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareindustriesclasscitics.wind_code is '';
comment on column ${iol_schema}.wind_ashareindustriesclasscitics.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_ashareindustriesclasscitics.citics_ind_code is '中信行业代码';
comment on column ${iol_schema}.wind_ashareindustriesclasscitics.entry_dt is '纳入日期';
comment on column ${iol_schema}.wind_ashareindustriesclasscitics.remove_dt is '剔除日期';
comment on column ${iol_schema}.wind_ashareindustriesclasscitics.cur_sign is '最新标志';
comment on column ${iol_schema}.wind_ashareindustriesclasscitics.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareindustriesclasscitics.etl_timestamp is 'ETL处理时间戳';
