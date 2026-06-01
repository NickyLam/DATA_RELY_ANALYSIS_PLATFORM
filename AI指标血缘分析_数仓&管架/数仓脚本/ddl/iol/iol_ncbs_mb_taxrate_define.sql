/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_mb_taxrate_define
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_mb_taxrate_define
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_mb_taxrate_define purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_mb_taxrate_define(
    company varchar2(20) -- 法人
    ,start_method varchar2(1) -- 启动方式
    ,tax_type varchar2(2) -- 税种
    ,tax_type_desc varchar2(50) -- 税率类型描述
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
grant select on ${iol_schema}.ncbs_mb_taxrate_define to ${iml_schema};
grant select on ${iol_schema}.ncbs_mb_taxrate_define to ${icl_schema};
grant select on ${iol_schema}.ncbs_mb_taxrate_define to ${idl_schema};
grant select on ${iol_schema}.ncbs_mb_taxrate_define to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_mb_taxrate_define is '税率类型定义表';
comment on column ${iol_schema}.ncbs_mb_taxrate_define.company is '法人';
comment on column ${iol_schema}.ncbs_mb_taxrate_define.start_method is '启动方式';
comment on column ${iol_schema}.ncbs_mb_taxrate_define.tax_type is '税种';
comment on column ${iol_schema}.ncbs_mb_taxrate_define.tax_type_desc is '税率类型描述';
comment on column ${iol_schema}.ncbs_mb_taxrate_define.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_mb_taxrate_define.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_mb_taxrate_define.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_mb_taxrate_define.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_mb_taxrate_define.etl_timestamp is 'ETL处理时间戳';
