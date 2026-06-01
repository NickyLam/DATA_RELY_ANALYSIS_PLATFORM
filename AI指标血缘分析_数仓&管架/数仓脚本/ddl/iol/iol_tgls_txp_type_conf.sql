/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_txp_type_conf
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_txp_type_conf
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_txp_type_conf purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_txp_type_conf(
    stacid number(9) -- 账套
    ,prodcd varchar2(30) -- 产品（类别1）
    ,prodp1 varchar2(10) -- 属性1
    ,prodp2 varchar2(10) -- 属性1
    ,prodp3 varchar2(10) -- 属性1
    ,prodp4 varchar2(10) -- 属性1
    ,prodp5 varchar2(10) -- 属性1
    ,prodp6 varchar2(10) -- 属性1
    ,prodp7 varchar2(10) -- 属性1
    ,prodp8 varchar2(10) -- 属性1
    ,prodp9 varchar2(10) -- 属性1
    ,prodpa varchar2(10) -- 属性1
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
grant select on ${iol_schema}.tgls_txp_type_conf to ${iml_schema};
grant select on ${iol_schema}.tgls_txp_type_conf to ${icl_schema};
grant select on ${iol_schema}.tgls_txp_type_conf to ${idl_schema};
grant select on ${iol_schema}.tgls_txp_type_conf to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_txp_type_conf is '分离规则配置表';
comment on column ${iol_schema}.tgls_txp_type_conf.stacid is '账套';
comment on column ${iol_schema}.tgls_txp_type_conf.prodcd is '产品（类别1）';
comment on column ${iol_schema}.tgls_txp_type_conf.prodp1 is '属性1';
comment on column ${iol_schema}.tgls_txp_type_conf.prodp2 is '属性1';
comment on column ${iol_schema}.tgls_txp_type_conf.prodp3 is '属性1';
comment on column ${iol_schema}.tgls_txp_type_conf.prodp4 is '属性1';
comment on column ${iol_schema}.tgls_txp_type_conf.prodp5 is '属性1';
comment on column ${iol_schema}.tgls_txp_type_conf.prodp6 is '属性1';
comment on column ${iol_schema}.tgls_txp_type_conf.prodp7 is '属性1';
comment on column ${iol_schema}.tgls_txp_type_conf.prodp8 is '属性1';
comment on column ${iol_schema}.tgls_txp_type_conf.prodp9 is '属性1';
comment on column ${iol_schema}.tgls_txp_type_conf.prodpa is '属性1';
comment on column ${iol_schema}.tgls_txp_type_conf.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_txp_type_conf.etl_timestamp is 'ETL处理时间戳';
