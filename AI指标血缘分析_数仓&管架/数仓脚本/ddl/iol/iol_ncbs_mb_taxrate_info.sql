/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_taxrate_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_taxrate_info
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_taxrate_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_taxrate_info(
    country varchar2(3) -- 国家
    ,company varchar2(20) -- 法人
    ,province varchar2(30) -- 省
    ,tax_rate_code varchar2(3) -- 税率代码
    ,effect_date date -- 产品生效日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,tax_rate number(15,8) -- 税率
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
grant select on ${iol_schema}.ncbs_mb_taxrate_info to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_taxrate_info to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_taxrate_info to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_taxrate_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_taxrate_info is '税率类型信息表';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.country is '国家';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.company is '法人';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.province is '省';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.tax_rate_code is '税率代码';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_taxrate_info.etl_timestamp is 'ETL处理时间戳';
