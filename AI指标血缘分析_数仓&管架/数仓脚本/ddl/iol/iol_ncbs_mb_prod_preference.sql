/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_prod_preference
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_prod_preference
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_prod_preference purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_prod_preference(
    prod_type varchar2(12) -- 产品编号
    ,company varchar2(20) -- 法人
    ,preference_type varchar2(10) -- 优惠方式
    ,preference_value varchar2(50) -- 优惠值定义
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,preference_fixed_rate number(15,8) -- 利率优惠固定利率
    ,preference_percent_rate number(11,7) -- 利率优惠浮动百分比
    ,preference_spread_rate number(15,8) -- 利率优惠浮动百分点
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
grant select on ${iol_schema}.ncbs_mb_prod_preference to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_prod_preference to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_preference to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_prod_preference to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_prod_preference is '产品利率优惠表';
comment on column ${iol_schema}.ncbs_mb_prod_preference.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_mb_prod_preference.company is '法人';
comment on column ${iol_schema}.ncbs_mb_prod_preference.preference_type is '优惠方式';
comment on column ${iol_schema}.ncbs_mb_prod_preference.preference_value is '优惠值定义';
comment on column ${iol_schema}.ncbs_mb_prod_preference.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_prod_preference.preference_fixed_rate is '利率优惠固定利率';
comment on column ${iol_schema}.ncbs_mb_prod_preference.preference_percent_rate is '利率优惠浮动百分比';
comment on column ${iol_schema}.ncbs_mb_prod_preference.preference_spread_rate is '利率优惠浮动百分点';
comment on column ${iol_schema}.ncbs_mb_prod_preference.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_prod_preference.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_prod_preference.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_prod_preference.etl_timestamp is 'ETL处理时间戳';
