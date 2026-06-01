/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_cbondsecindustriesclass
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_cbondsecindustriesclass
whenever sqlerror continue none;
drop table ${iol_schema}.wind_cbondsecindustriesclass purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondsecindustriesclass(
    object_id varchar2(300) -- 对象ID
    ,s_info_windcode varchar2(60) -- Wind代码
    ,sec_ind_code varchar2(75) -- 所属板块代码
    ,entry_dt varchar2(12) -- 纳入日期
    ,remove_dt varchar2(12) -- 剔除日期
    ,cur_sign number(1,0) -- 最新标志
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
grant select on ${iol_schema}.wind_cbondsecindustriesclass to ${iml_schema};
grant select on ${iol_schema}.wind_cbondsecindustriesclass to ${icl_schema};
grant select on ${iol_schema}.wind_cbondsecindustriesclass to ${idl_schema};
grant select on ${iol_schema}.wind_cbondsecindustriesclass to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_cbondsecindustriesclass is '中国债券证监会行业分类';
comment on column ${iol_schema}.wind_cbondsecindustriesclass.object_id is '对象ID';
comment on column ${iol_schema}.wind_cbondsecindustriesclass.s_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_cbondsecindustriesclass.sec_ind_code is '所属板块代码';
comment on column ${iol_schema}.wind_cbondsecindustriesclass.entry_dt is '纳入日期';
comment on column ${iol_schema}.wind_cbondsecindustriesclass.remove_dt is '剔除日期';
comment on column ${iol_schema}.wind_cbondsecindustriesclass.cur_sign is '最新标志';
comment on column ${iol_schema}.wind_cbondsecindustriesclass.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_cbondsecindustriesclass.etl_timestamp is 'ETL处理时间戳';
