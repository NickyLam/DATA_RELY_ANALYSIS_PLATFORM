/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_fm_country
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_fm_country
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_fm_country purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_country(
    ccy varchar2(3) -- 币种
    ,country varchar2(3) -- 国家
    ,company varchar2(20) -- 法人
    ,country_desc varchar2(50) -- 国家名称
    ,country_tel varchar2(5) -- 国家电话区号
    ,iso_code varchar2(3) -- iso编码
    ,ncct_flag varchar2(1) -- 非合作国家
    ,psc_flag varchar2(1) -- 政治敏感国家
    ,region varchar2(2) -- 地区（洲代码）
    ,safe_code varchar2(10) -- safe编码
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
grant select on ${iol_schema}.ncbs_fm_country to ${iml_schema};
grant select on ${iol_schema}.ncbs_fm_country to ${icl_schema};
grant select on ${iol_schema}.ncbs_fm_country to ${idl_schema};
grant select on ${iol_schema}.ncbs_fm_country to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_fm_country is '国家代码表';
comment on column ${iol_schema}.ncbs_fm_country.ccy is '币种';
comment on column ${iol_schema}.ncbs_fm_country.country is '国家';
comment on column ${iol_schema}.ncbs_fm_country.company is '法人';
comment on column ${iol_schema}.ncbs_fm_country.country_desc is '国家名称';
comment on column ${iol_schema}.ncbs_fm_country.country_tel is '国家电话区号';
comment on column ${iol_schema}.ncbs_fm_country.iso_code is 'iso编码';
comment on column ${iol_schema}.ncbs_fm_country.ncct_flag is '非合作国家';
comment on column ${iol_schema}.ncbs_fm_country.psc_flag is '政治敏感国家';
comment on column ${iol_schema}.ncbs_fm_country.region is '地区（洲代码）';
comment on column ${iol_schema}.ncbs_fm_country.safe_code is 'safe编码';
comment on column ${iol_schema}.ncbs_fm_country.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_fm_country.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_fm_country.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_fm_country.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_fm_country.etl_timestamp is 'ETL处理时间戳';
