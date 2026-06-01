/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_ccdb_cif_password_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_ccdb_cif_password_info
whenever sqlerror continue none;
drop table ${idl_schema}.aml_ccdb_cif_password_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_ccdb_cif_password_info(
    etl_dt date -- 数据日期   
    ,id number(22) -- 流水号   
    ,customer_no varchar2(50) -- 客户号   
    ,business_type varchar2(4) -- 业务类型   
    ,password_type varchar2(4) -- 密码类型   
    ,status varchar2(4) -- 状态   
    ,update_date date -- 更新日期   
    ,version number(22) -- 版本号   
    ,card_no varchar2(30) -- 账号   
    ,password varchar2(50) -- 密码（密文）   
    ,from_channel varchar2(50) -- 请求渠道   
    ,verify_error_num number(22) -- 验证错误次数   
    ,verify_record_date date -- 验证日期   
    ,start_dt date -- 开始日期   
    ,end_dt date -- 结束日期   
    ,id_mark varchar2(10) -- 删除标识   
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
grant select on ${idl_schema}.aml_ccdb_cif_password_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_ccdb_cif_password_info is '客户查询密码管理';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.id is '流水号';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.customer_no is '客户号';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.business_type is '业务类型';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.password_type is '密码类型';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.status is '状态';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.update_date is '更新日期';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.version is '版本号';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.card_no is '账号';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.password is '密码（密文）';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.from_channel is '请求渠道';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.verify_error_num is '验证错误次数';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.verify_record_date is '验证日期';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.start_dt is '开始日期';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.end_dt is '结束日期';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.id_mark is '删除标识';
comment on column ${idl_schema}.aml_ccdb_cif_password_info.etl_timestamp is '数据处理时间';