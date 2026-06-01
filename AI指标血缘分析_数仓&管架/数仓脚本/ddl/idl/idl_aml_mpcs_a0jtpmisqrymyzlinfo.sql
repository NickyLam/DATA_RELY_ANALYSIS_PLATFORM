/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_mpcs_a0jtpmisqrymyzlinfo
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo
whenever sqlerror continue none;
drop table ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo(
    etl_dt date -- 数据日期
    ,mainseq varchar2(16) -- 中台流水号
    ,transdt varchar2(8) -- 交易日期
    ,modifydttm varchar2(14) -- 修改日期时间
    ,year_month varchar2(6) -- 年月
    ,currency_code varchar2(3) -- 币种
    ,exchange varchar2(18) -- 折算率
    ,etl_timestamp timestamp -- 数据处理时间
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo is '美元折率查询表';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo.mainseq is '中台流水号';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo.transdt is '交易日期';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo.modifydttm is '修改日期时间';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo.year_month is '年月';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo.currency_code is '币种';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo.exchange is '折算率';
comment on column ${idl_schema}.aml_mpcs_a0jtpmisqrymyzlinfo.etl_timestamp is '数据处理时间';
