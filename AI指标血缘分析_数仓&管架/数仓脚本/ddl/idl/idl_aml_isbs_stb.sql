/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_stb
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_stb
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_stb purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_stb(
    etl_dt date -- 数据日期
    ,tbl varchar2(6) -- 参数代码
    ,uil varchar2(2) -- 语种
    ,cod varchar2(8) -- 参数值
    ,txt varchar2(80) -- 注释
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
grant select on ${idl_schema}.aml_isbs_stb to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_stb is 'CodeTable内容';
comment on column ${idl_schema}.aml_isbs_stb.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_stb.tbl is '参数代码';
comment on column ${idl_schema}.aml_isbs_stb.uil is '语种';
comment on column ${idl_schema}.aml_isbs_stb.cod is '参数值';
comment on column ${idl_schema}.aml_isbs_stb.txt is '注释';
comment on column ${idl_schema}.aml_isbs_stb.etl_timestamp is '数据处理时间';
