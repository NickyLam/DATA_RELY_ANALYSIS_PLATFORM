/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_scel_attr
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_scel_attr
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_scel_attr purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_scel_attr(
    stacid number(19) -- 账套
    ,elemcd varchar2(20) -- 要素编号
    ,elemna varchar2(100) -- 要素名称
    ,busitp varchar2(20) -- 业务类型
    ,busina varchar2(255) -- 业务名称
    ,tablcl varchar2(30) -- 参考列名称
    ,paracd varchar2(30) -- 代码值
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
grant select on ${iol_schema}.tgls_amc_scel_attr to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_scel_attr to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_scel_attr to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_scel_attr to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_scel_attr is '来源系统要素定义子表';
comment on column ${iol_schema}.tgls_amc_scel_attr.stacid is '账套';
comment on column ${iol_schema}.tgls_amc_scel_attr.elemcd is '要素编号';
comment on column ${iol_schema}.tgls_amc_scel_attr.elemna is '要素名称';
comment on column ${iol_schema}.tgls_amc_scel_attr.busitp is '业务类型';
comment on column ${iol_schema}.tgls_amc_scel_attr.busina is '业务名称';
comment on column ${iol_schema}.tgls_amc_scel_attr.tablcl is '参考列名称';
comment on column ${iol_schema}.tgls_amc_scel_attr.paracd is '代码值';
comment on column ${iol_schema}.tgls_amc_scel_attr.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_scel_attr.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_scel_attr.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_scel_attr.etl_timestamp is 'ETL处理时间戳';
