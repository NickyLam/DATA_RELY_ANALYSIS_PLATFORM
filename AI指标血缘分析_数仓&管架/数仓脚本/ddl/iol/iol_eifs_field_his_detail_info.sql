/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_field_his_detail_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_field_his_detail_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_field_his_detail_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_field_his_detail_info(
    modify_his_id varchar2(45) -- 修改历史序列号
    ,info_id varchar2(450) -- 信息序列号
    ,table_name varchar2(450) -- 表名
    ,table_name_desc varchar2(450) -- 表名称
    ,type_desc varchar2(450) -- 类型描述
    ,field_name varchar2(450) -- 字段名
    ,field_name_desc varchar2(450) -- 字段名称
    ,before_value varchar2(450) -- 修改前值
    ,after_value varchar2(521) -- 修改后值
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
grant select on ${iol_schema}.eifs_field_his_detail_info to ${iml_schema};
grant select on ${iol_schema}.eifs_field_his_detail_info to ${icl_schema};
grant select on ${iol_schema}.eifs_field_his_detail_info to ${idl_schema};
grant select on ${iol_schema}.eifs_field_his_detail_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_field_his_detail_info is '字段修改历史详情表';
comment on column ${iol_schema}.eifs_field_his_detail_info.modify_his_id is '修改历史序列号';
comment on column ${iol_schema}.eifs_field_his_detail_info.info_id is '信息序列号';
comment on column ${iol_schema}.eifs_field_his_detail_info.table_name is '表名';
comment on column ${iol_schema}.eifs_field_his_detail_info.table_name_desc is '表名称';
comment on column ${iol_schema}.eifs_field_his_detail_info.type_desc is '类型描述';
comment on column ${iol_schema}.eifs_field_his_detail_info.field_name is '字段名';
comment on column ${iol_schema}.eifs_field_his_detail_info.field_name_desc is '字段名称';
comment on column ${iol_schema}.eifs_field_his_detail_info.before_value is '修改前值';
comment on column ${iol_schema}.eifs_field_his_detail_info.after_value is '修改后值';
comment on column ${iol_schema}.eifs_field_his_detail_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.eifs_field_his_detail_info.etl_timestamp is 'ETL处理时间戳';
