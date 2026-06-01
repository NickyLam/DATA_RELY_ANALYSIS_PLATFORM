/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol wind_iamfundnav
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.wind_iamfundnav
whenever sqlerror continue none;
drop table ${iol_schema}.wind_iamfundnav purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_iamfundnav(
    object_id varchar2(150) -- 对象ID
    ,f_info_windcode varchar2(60) -- Wind代码
    ,price_date varchar2(12) -- 日期
    ,f_nav_unit number(24,8) -- 份额净值
    ,f_nav_accumulated number(24,8) -- 公布份额累计净值
    ,f_nav_divaccumulated number(24,8) -- 份额累计分红
    ,f_nav_adjfactor number(20,8) -- 复权因子
    ,crncy_code varchar2(15) -- 净值货币代码
    ,f_nav_adjusted number(24,8) -- 复权单位净值(计算)
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
grant select on ${iol_schema}.wind_iamfundnav to ${iml_schema};
grant select on ${iol_schema}.wind_iamfundnav to ${icl_schema};
grant select on ${iol_schema}.wind_iamfundnav to ${idl_schema};
grant select on ${iol_schema}.wind_iamfundnav to ${iel_schema};

-- comment
comment on table ${iol_schema}.wind_iamfundnav is '保险资管净值';
comment on column ${iol_schema}.wind_iamfundnav.object_id is '对象ID';
comment on column ${iol_schema}.wind_iamfundnav.f_info_windcode is 'Wind代码';
comment on column ${iol_schema}.wind_iamfundnav.price_date is '日期';
comment on column ${iol_schema}.wind_iamfundnav.f_nav_unit is '份额净值';
comment on column ${iol_schema}.wind_iamfundnav.f_nav_accumulated is '公布份额累计净值';
comment on column ${iol_schema}.wind_iamfundnav.f_nav_divaccumulated is '份额累计分红';
comment on column ${iol_schema}.wind_iamfundnav.f_nav_adjfactor is '复权因子';
comment on column ${iol_schema}.wind_iamfundnav.crncy_code is '净值货币代码';
comment on column ${iol_schema}.wind_iamfundnav.f_nav_adjusted is '复权单位净值(计算)';
comment on column ${iol_schema}.wind_iamfundnav.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.wind_iamfundnav.etl_timestamp is 'ETL处理时间戳';
