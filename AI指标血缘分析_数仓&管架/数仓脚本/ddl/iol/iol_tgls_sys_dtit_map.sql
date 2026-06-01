/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_sys_dtit_map
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_sys_dtit_map
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_sys_dtit_map purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_sys_dtit_map(
    prodcd varchar2(12) -- 产品编号
    ,prodp1 varchar2(30) -- 产品属性组1
    ,prodp2 varchar2(30) -- 产品属性组2
    ,prodp3 varchar2(30) -- 产品属性组3
    ,prodp4 varchar2(30) -- 产品属性组4
    ,prodp5 varchar2(30) -- 产品属性组5
    ,prodp6 varchar2(30) -- 产品属性组6
    ,prodp7 varchar2(30) -- 产品属性组7
    ,prodp8 varchar2(30) -- 产品属性组8
    ,prodp9 varchar2(30) -- 产品属性组9
    ,prodpa varchar2(30) -- 产品属性组10
    ,dtitcd varchar2(30) -- 核算规则组
    ,stacid number(19) -- 账套标记
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
grant select on ${iol_schema}.tgls_sys_dtit_map to ${iml_schema};
grant select on ${iol_schema}.tgls_sys_dtit_map to ${icl_schema};
grant select on ${iol_schema}.tgls_sys_dtit_map to ${idl_schema};
grant select on ${iol_schema}.tgls_sys_dtit_map to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_sys_dtit_map is '产品核算配置明细表';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodcd is '产品编号';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodp1 is '产品属性组1';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodp2 is '产品属性组2';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodp3 is '产品属性组3';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodp4 is '产品属性组4';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodp5 is '产品属性组5';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodp6 is '产品属性组6';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodp7 is '产品属性组7';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodp8 is '产品属性组8';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodp9 is '产品属性组9';
comment on column ${iol_schema}.tgls_sys_dtit_map.prodpa is '产品属性组10';
comment on column ${iol_schema}.tgls_sys_dtit_map.dtitcd is '核算规则组';
comment on column ${iol_schema}.tgls_sys_dtit_map.stacid is '账套标记';
comment on column ${iol_schema}.tgls_sys_dtit_map.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.tgls_sys_dtit_map.etl_timestamp is 'ETL处理时间戳';
