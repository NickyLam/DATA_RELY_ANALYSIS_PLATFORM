/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_cpr_rating_record
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_cpr_rating_record
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_cpr_rating_record purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_cpr_rating_record(
    uuid varchar2(64) -- 评级记录ID
    ,serial_no varchar2(128) -- 评级流水号
    ,rating_type varchar2(32) -- 评级类型
    ,cust_no varchar2(64) -- 客户编号
    ,cust_name varchar2(256) -- 客户名称
    ,organization varchar2(256) -- 所属机构
    ,national_industry varchar2(32) -- 国标行业
    ,rating_model varchar2(256) -- 评级模型
    ,model_code varchar2(100) -- 模型代码
    ,final_score varchar2(100) -- 最终得分
    ,machine_rating varchar2(12) -- 机评等级
    ,special_rating varchar2(12) -- 特例等级
    ,inputs varchar2(4000) -- 评级记录入参
    ,outputs varchar2(4000) -- 评级记录出参
    ,create_time date -- 创建时间
    ,spend_time varchar2(12) -- 耗时
    ,is_success number(4,0) -- 是否成功(默认0，1成功，-1失败)
    ,describe varchar2(4000) -- 描述
    ,is_test number(4,0) -- 是否测算(1是0否)
    ,financial_score varchar2(255) -- 财务得分
    ,non_financial_score varchar2(255) -- 非财务得分
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
grant select on ${iol_schema}.rsts_cpr_rating_record to ${iml_schema};
grant select on ${iol_schema}.rsts_cpr_rating_record to ${icl_schema};
grant select on ${iol_schema}.rsts_cpr_rating_record to ${idl_schema};
grant select on ${iol_schema}.rsts_cpr_rating_record to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_cpr_rating_record is '评级记录表';
comment on column ${iol_schema}.rsts_cpr_rating_record.uuid is '评级记录ID';
comment on column ${iol_schema}.rsts_cpr_rating_record.serial_no is '评级流水号';
comment on column ${iol_schema}.rsts_cpr_rating_record.rating_type is '评级类型';
comment on column ${iol_schema}.rsts_cpr_rating_record.cust_no is '客户编号';
comment on column ${iol_schema}.rsts_cpr_rating_record.cust_name is '客户名称';
comment on column ${iol_schema}.rsts_cpr_rating_record.organization is '所属机构';
comment on column ${iol_schema}.rsts_cpr_rating_record.national_industry is '国标行业';
comment on column ${iol_schema}.rsts_cpr_rating_record.rating_model is '评级模型';
comment on column ${iol_schema}.rsts_cpr_rating_record.model_code is '模型代码';
comment on column ${iol_schema}.rsts_cpr_rating_record.final_score is '最终得分';
comment on column ${iol_schema}.rsts_cpr_rating_record.machine_rating is '机评等级';
comment on column ${iol_schema}.rsts_cpr_rating_record.special_rating is '特例等级';
comment on column ${iol_schema}.rsts_cpr_rating_record.inputs is '评级记录入参';
comment on column ${iol_schema}.rsts_cpr_rating_record.outputs is '评级记录出参';
comment on column ${iol_schema}.rsts_cpr_rating_record.create_time is '创建时间';
comment on column ${iol_schema}.rsts_cpr_rating_record.spend_time is '耗时';
comment on column ${iol_schema}.rsts_cpr_rating_record.is_success is '是否成功(默认0，1成功，-1失败)';
comment on column ${iol_schema}.rsts_cpr_rating_record.describe is '描述';
comment on column ${iol_schema}.rsts_cpr_rating_record.is_test is '是否测算(1是0否)';
comment on column ${iol_schema}.rsts_cpr_rating_record.financial_score is '财务得分';
comment on column ${iol_schema}.rsts_cpr_rating_record.non_financial_score is '非财务得分';
comment on column ${iol_schema}.rsts_cpr_rating_record.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_cpr_rating_record.etl_timestamp is 'ETL处理时间戳';
