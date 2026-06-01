/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_tax_item
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_tax_item
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_tax_item purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_tax_item(
    taxcode varchar2(10) -- 税种代码
    ,taxname varchar2(100) -- 税种名称
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
grant select on ${iol_schema}.tgls_tax_item to ${iml_schema};
grant select on ${iol_schema}.tgls_tax_item to ${icl_schema};
grant select on ${iol_schema}.tgls_tax_item to ${idl_schema};
grant select on ${iol_schema}.tgls_tax_item to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_tax_item is '税种表';
comment on column ${iol_schema}.tgls_tax_item.taxcode is '税种代码';
comment on column ${iol_schema}.tgls_tax_item.taxname is '税种名称';
comment on column ${iol_schema}.tgls_tax_item.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_tax_item.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_tax_item.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_tax_item.etl_timestamp is 'ETL处理时间戳';
