/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_osbs_ats_securitymobile
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_osbs_ats_securitymobile
whenever sqlerror continue none;
drop table ${idl_schema}.aml_osbs_ats_securitymobile purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_osbs_ats_securitymobile(
    etl_dt date -- 数据日期
    ,asm_cstno varchar2(32) -- 统一客户号
    ,asm_userno varchar2(32) -- 用户顺序号
    ,asm_mobile varchar2(32) -- 安全手机号
    ,asm_create_date varchar2(14) -- 创建日期
    ,asm_update_date varchar2(14) -- 最后修改日期
    ,asm_state varchar2(1) -- 状态
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
grant select on ${idl_schema}.aml_osbs_ats_securitymobile to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_osbs_ats_securitymobile is '安全手机号表';
comment on column ${idl_schema}.aml_osbs_ats_securitymobile.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_osbs_ats_securitymobile.asm_cstno is '统一客户号';
comment on column ${idl_schema}.aml_osbs_ats_securitymobile.asm_userno is '用户顺序号';
comment on column ${idl_schema}.aml_osbs_ats_securitymobile.asm_mobile is '安全手机号';
comment on column ${idl_schema}.aml_osbs_ats_securitymobile.asm_create_date is '创建日期';
comment on column ${idl_schema}.aml_osbs_ats_securitymobile.asm_update_date is '最后修改日期';
comment on column ${idl_schema}.aml_osbs_ats_securitymobile.asm_state is '状态';
comment on column ${idl_schema}.aml_osbs_ats_securitymobile.etl_timestamp is '数据处理时间';
