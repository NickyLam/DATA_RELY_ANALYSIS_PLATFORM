/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_ashareownership
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_ashareownership
whenever sqlerror continue none;
drop table ${iol_schema}.wind_ashareownership purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_ashareownership(
    object_id varchar2(150) -- 对象ID
    ,s_info_compcode varchar2(60) -- 公司id
    ,s_info_compname varchar2(300) -- 公司名称
    ,wind_sec_code varchar2(15) -- 板块代码
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
grant select on ${iol_schema}.wind_ashareownership to ${iml_schema};
grant select on ${iol_schema}.wind_ashareownership to ${icl_schema};
grant select on ${iol_schema}.wind_ashareownership to ${idl_schema};
grant select on ${iol_schema}.wind_ashareownership to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_ashareownership is '中国A股企业所有制板块';
comment on column ${iol_schema}.wind_ashareownership.object_id is '对象ID';
comment on column ${iol_schema}.wind_ashareownership.s_info_compcode is '公司id';
comment on column ${iol_schema}.wind_ashareownership.s_info_compname is '公司名称';
comment on column ${iol_schema}.wind_ashareownership.wind_sec_code is '板块代码';
comment on column ${iol_schema}.wind_ashareownership.entry_dt is '纳入日期';
comment on column ${iol_schema}.wind_ashareownership.remove_dt is '剔除日期';
comment on column ${iol_schema}.wind_ashareownership.cur_sign is '最新标志';
comment on column ${iol_schema}.wind_ashareownership.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_ashareownership.etl_timestamp is 'ETL处理时间戳';
