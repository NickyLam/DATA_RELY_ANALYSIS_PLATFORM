/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_cpr_index_processing_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_cpr_index_processing_detail
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_cpr_index_processing_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_index_processing_detail(
    uuid varchar2(64) -- 指标加工明细ID
    ,serial_no varchar2(128) -- 评级流水号
    ,processing_id varchar2(64) -- 指标加工记录UUID
    ,index_type varchar2(32) -- 指标类型
    ,index_code varchar2(64) -- 指标标识
    ,index_name varchar2(256) -- 指标名称
    ,financial_index_value varchar2(256) -- 财务指标值
    ,account_number varchar2(32) -- 科目号
    ,account_value varchar2(256) -- 科目值
    ,ext_refreence_value varchar2(256) -- 外部数据参考值
    ,ext_filed_code varchar2(256) -- 外部数据字段标识
    ,ext_field_value varchar2(256) -- 外部数据字段值
    ,index_score varchar2(32) -- 指标得分
    ,index_value varchar2(256) -- 指标值
    ,source varchar2(256) -- 外部数据来源
    ,formula varchar2(1024) -- 计算公式
    ,account_map varchar2(4000) -- 科目号及科目值集合
    ,field_name varchar2(32) -- 字段名
    ,field_value varchar2(256) -- 字段值
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
grant select on ${iol_schema}.rsts_cpr_index_processing_detail to ${iml_schema};
grant select on ${iol_schema}.rsts_cpr_index_processing_detail to ${icl_schema};
grant select on ${iol_schema}.rsts_cpr_index_processing_detail to ${idl_schema};
grant select on ${iol_schema}.rsts_cpr_index_processing_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_cpr_index_processing_detail is '指标加工明细表';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.uuid is '指标加工明细ID';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.serial_no is '评级流水号';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.processing_id is '指标加工记录UUID';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.index_type is '指标类型';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.index_code is '指标标识';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.index_name is '指标名称';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.financial_index_value is '财务指标值';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.account_number is '科目号';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.account_value is '科目值';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.ext_refreence_value is '外部数据参考值';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.ext_filed_code is '外部数据字段标识';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.ext_field_value is '外部数据字段值';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.index_score is '指标得分';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.index_value is '指标值';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.source is '外部数据来源';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.formula is '计算公式';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.account_map is '科目号及科目值集合';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.field_name is '字段名';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.field_value is '字段值';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_cpr_index_processing_detail.etl_timestamp is 'ETL处理时间戳';
