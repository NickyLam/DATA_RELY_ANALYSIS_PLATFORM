/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_amc_cdrl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_amc_cdrl
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_amc_cdrl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_cdrl(
    stacid number(19) -- 账套
    ,systid varchar2(8) -- 系统来源
    ,mapptp varchar2(8) -- 映射类型
    ,sourvl varchar2(20) -- 源值
    ,sourna varchar2(128) -- 源值描述
    ,mappvl varchar2(20) -- 映射值
    ,mappna varchar2(128) -- 映射值描述
    ,valide varchar2(1) -- 启用标示,y-是n-否
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
grant select on ${iol_schema}.tgls_amc_cdrl to ${iml_schema};
grant select on ${iol_schema}.tgls_amc_cdrl to ${icl_schema};
grant select on ${iol_schema}.tgls_amc_cdrl to ${idl_schema};
grant select on ${iol_schema}.tgls_amc_cdrl to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_amc_cdrl is '源系统码值与会计计量系统码值关系表';
comment on column ${iol_schema}.tgls_amc_cdrl.stacid is '账套';
comment on column ${iol_schema}.tgls_amc_cdrl.systid is '系统来源';
comment on column ${iol_schema}.tgls_amc_cdrl.mapptp is '映射类型';
comment on column ${iol_schema}.tgls_amc_cdrl.sourvl is '源值';
comment on column ${iol_schema}.tgls_amc_cdrl.sourna is '源值描述';
comment on column ${iol_schema}.tgls_amc_cdrl.mappvl is '映射值';
comment on column ${iol_schema}.tgls_amc_cdrl.mappna is '映射值描述';
comment on column ${iol_schema}.tgls_amc_cdrl.valide is '启用标示,y-是n-否';
comment on column ${iol_schema}.tgls_amc_cdrl.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_amc_cdrl.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_amc_cdrl.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_amc_cdrl.etl_timestamp is 'ETL处理时间戳';
