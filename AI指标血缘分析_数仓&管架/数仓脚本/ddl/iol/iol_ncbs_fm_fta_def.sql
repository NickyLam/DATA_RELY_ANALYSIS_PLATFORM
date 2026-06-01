/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_fta_def
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_fta_def
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_fta_def purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_fta_def(
    country varchar2(3) -- 国家
    ,city varchar2(6) -- 行政区划(城市)
    ,company varchar2(20) -- 法人
    ,fta_code varchar2(10) -- 自贸区代码
    ,fta_desc varchar2(50) -- 自贸区名称
    ,fta_nature varchar2(2) -- 自贸区属性
    ,fta_type varchar2(2) -- 自贸区类型
    ,fte_flag varchar2(10) -- 本岸企业客户前缀
    ,ftf_flag varchar2(10) -- 个人非居民标志
    ,fti_flag varchar2(10) -- 区内个人居民账户标志
    ,ftn_flag varchar2(10) -- 离岸企业客户标志
    ,ftu_flag varchar2(10) -- 同业客户账户前缀
    ,state varchar2(6) -- 行政区划(省、州)
    ,tran_timestamp varchar2(26) -- 交易时间戳
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
grant select on ${iol_schema}.ncbs_fm_fta_def to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_fta_def to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_fta_def to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_fta_def to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_fta_def is '自贸区代码定义';
comment on column ${iol_schema}.ncbs_fm_fta_def.country is '国家';
comment on column ${iol_schema}.ncbs_fm_fta_def.city is '行政区划(城市)';
comment on column ${iol_schema}.ncbs_fm_fta_def.company is '法人';
comment on column ${iol_schema}.ncbs_fm_fta_def.fta_code is '自贸区代码';
comment on column ${iol_schema}.ncbs_fm_fta_def.fta_desc is '自贸区名称';
comment on column ${iol_schema}.ncbs_fm_fta_def.fta_nature is '自贸区属性';
comment on column ${iol_schema}.ncbs_fm_fta_def.fta_type is '自贸区类型';
comment on column ${iol_schema}.ncbs_fm_fta_def.fte_flag is '本岸企业客户前缀';
comment on column ${iol_schema}.ncbs_fm_fta_def.ftf_flag is '个人非居民标志';
comment on column ${iol_schema}.ncbs_fm_fta_def.fti_flag is '区内个人居民账户标志';
comment on column ${iol_schema}.ncbs_fm_fta_def.ftn_flag is '离岸企业客户标志';
comment on column ${iol_schema}.ncbs_fm_fta_def.ftu_flag is '同业客户账户前缀';
comment on column ${iol_schema}.ncbs_fm_fta_def.state is '行政区划(省、州)';
comment on column ${iol_schema}.ncbs_fm_fta_def.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_fta_def.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_fta_def.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_fta_def.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_fta_def.etl_timestamp is 'ETL处理时间戳';
