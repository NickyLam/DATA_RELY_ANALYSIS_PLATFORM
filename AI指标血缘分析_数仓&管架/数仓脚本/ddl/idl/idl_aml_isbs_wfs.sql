/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_isbs_wfs
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_isbs_wfs
whenever sqlerror continue none;
drop table ${idl_schema}.aml_isbs_wfs purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_isbs_wfs(
    etl_dt date -- 数据日期
    ,inr varchar2(8) -- 唯一ID
    ,objtyp varchar2(6) -- 关联对象类型
    ,objinr varchar2(8) -- 关联对象INR
    ,objnam varchar2(40) -- 关联对象名字
    ,etyextkey varchar2(8) -- 实体
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
grant select on ${idl_schema}.aml_isbs_wfs to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_isbs_wfs is '工作流关联表';
comment on column ${idl_schema}.aml_isbs_wfs.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_isbs_wfs.inr is '唯一ID';
comment on column ${idl_schema}.aml_isbs_wfs.objtyp is '关联对象类型';
comment on column ${idl_schema}.aml_isbs_wfs.objinr is '关联对象INR';
comment on column ${idl_schema}.aml_isbs_wfs.objnam is '关联对象名字';
comment on column ${idl_schema}.aml_isbs_wfs.etyextkey is '实体';
comment on column ${idl_schema}.aml_isbs_wfs.etl_timestamp is '数据处理时间';
