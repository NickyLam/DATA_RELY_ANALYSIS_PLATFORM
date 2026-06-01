/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_cpr_index_processing_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_cpr_index_processing_record
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_cpr_index_processing_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_index_processing_record(
    uuid varchar2(64) -- 指标加工ID
    ,serial_no varchar2(128) -- 评级流水号
    ,inputs varchar2(4000) -- 评级记录入参
    ,outputs varchar2(4000) -- 评级记录出参
    ,is_success number(4,0) -- 是否成功(默认0，1成功，-1失败)
    ,create_time date -- 创建时间
    ,spend_time varchar2(12) -- 耗时
    ,describe varchar2(4000) -- 描述
    ,rating_type varchar2(32) -- 评级类型
    ,cust_no varchar2(64) -- 客户编号
    ,cust_name varchar2(256) -- 客户名称
    ,rating_model varchar2(256) -- 评级模型
    ,model_code varchar2(100) -- 模型代码
    ,is_test number(4,0) -- 是否测算(1是0否)
    ,reporting_period varchar2(32) -- 使用财报期次
    ,reporting_type varchar2(32) -- 使用财报类型
    ,national_industry varchar2(32) -- 国标行业
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
grant select on ${iol_schema}.rsts_cpr_index_processing_record to ${iml_schema};
grant select on ${iol_schema}.rsts_cpr_index_processing_record to ${icl_schema};
grant select on ${iol_schema}.rsts_cpr_index_processing_record to ${idl_schema};
grant select on ${iol_schema}.rsts_cpr_index_processing_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_cpr_index_processing_record is '指标加工记录表';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.uuid is '指标加工ID';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.serial_no is '评级流水号';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.inputs is '评级记录入参';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.outputs is '评级记录出参';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.is_success is '是否成功(默认0，1成功，-1失败)';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.create_time is '创建时间';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.spend_time is '耗时';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.describe is '描述';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.rating_type is '评级类型';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.cust_no is '客户编号';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.cust_name is '客户名称';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.rating_model is '评级模型';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.model_code is '模型代码';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.is_test is '是否测算(1是0否)';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.reporting_period is '使用财报期次';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.reporting_type is '使用财报类型';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.national_industry is '国标行业';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_cpr_index_processing_record.etl_timestamp is 'ETL处理时间戳';
