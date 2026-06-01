/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol tgls_cbrc_shet_cond
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.tgls_cbrc_shet_cond
whenever sqlerror continue none;
drop table ${iol_schema}.tgls_cbrc_shet_cond purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_cbrc_shet_cond(
    condcd varchar2(10) -- 条件代码
    ,condna varchar2(20) -- 条件名称
    ,fldknd varchar2(1) -- d日期型n数字型c字符型s字典型llookup型
    ,condtp varchar2(1) -- 条件类型(0固定条件，不允许删除及修改1自定义条件可以修改及删除)
    ,dictcd varchar2(20) -- 当字段类型为字典型时，此列才会有值
    ,lupurl varchar2(255) -- 当字段类型为lookup型时，此列才会有值
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
grant select on ${iol_schema}.tgls_cbrc_shet_cond to ${iml_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_cond to ${icl_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_cond to ${idl_schema};
grant select on ${iol_schema}.tgls_cbrc_shet_cond to ${iel_schema};

-- comment
comment on table ${iol_schema}.tgls_cbrc_shet_cond is '条件属性';
comment on column ${iol_schema}.tgls_cbrc_shet_cond.condcd is '条件代码';
comment on column ${iol_schema}.tgls_cbrc_shet_cond.condna is '条件名称';
comment on column ${iol_schema}.tgls_cbrc_shet_cond.fldknd is 'd日期型n数字型c字符型s字典型llookup型';
comment on column ${iol_schema}.tgls_cbrc_shet_cond.condtp is '条件类型(0固定条件，不允许删除及修改1自定义条件可以修改及删除)';
comment on column ${iol_schema}.tgls_cbrc_shet_cond.dictcd is '当字段类型为字典型时，此列才会有值';
comment on column ${iol_schema}.tgls_cbrc_shet_cond.lupurl is '当字段类型为lookup型时，此列才会有值';
comment on column ${iol_schema}.tgls_cbrc_shet_cond.start_dt is '开始时间';
comment on column ${iol_schema}.tgls_cbrc_shet_cond.end_dt is '结束时间';
comment on column ${iol_schema}.tgls_cbrc_shet_cond.id_mark is '增删标志';
comment on column ${iol_schema}.tgls_cbrc_shet_cond.etl_timestamp is 'ETL处理时间戳';
