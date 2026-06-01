/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ctms_tbs_v_security_cus_field
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ctms_tbs_v_security_cus_field
whenever sqlerror continue none;
drop table ${iol_schema}.ctms_tbs_v_security_cus_field purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_security_cus_field(
    security_cus_field_id number -- (KMS)自定义字段ID
    ,field_id number -- CMS自定义字段ID
    ,field_name varchar2(150) -- 自定义字段定义名称
    ,field_value varchar2(450) -- 自定义字段定义值
    ,security_code varchar2(24) -- 债券代码
    ,seq number -- 序列号
    ,field_modify_time date -- 自定义字段更新时间
    ,value_modify_time date -- 自定义字段值更新时间
    ,datasymbol_id number -- 数据源ID
    ,aspclient_id number -- 部门ID
    ,lastmodified timestamp -- 修改时间
    ,cus_number number -- 机构号
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
grant select on ${iol_schema}.ctms_tbs_v_security_cus_field to ${iml_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_cus_field to ${icl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_cus_field to ${idl_schema};
grant select on ${iol_schema}.ctms_tbs_v_security_cus_field to ${iel_schema};

-- comment
comment on table ${iol_schema}.ctms_tbs_v_security_cus_field is '债券自定义字段表';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.security_cus_field_id is '(KMS)自定义字段ID';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.field_id is 'CMS自定义字段ID';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.field_name is '自定义字段定义名称';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.field_value is '自定义字段定义值';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.security_code is '债券代码';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.seq is '序列号';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.field_modify_time is '自定义字段更新时间';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.value_modify_time is '自定义字段值更新时间';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.datasymbol_id is '数据源ID';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.aspclient_id is '部门ID';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.lastmodified is '修改时间';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.cus_number is '机构号';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.start_dt is '开始时间';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.end_dt is '结束时间';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.id_mark is '增删标志';
comment on column ${iol_schema}.ctms_tbs_v_security_cus_field.etl_timestamp is 'ETL处理时间戳';
