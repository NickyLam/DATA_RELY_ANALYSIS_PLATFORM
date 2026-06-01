/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_rcd_ir_grade_a_score_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_rcd_ir_grade_a_score_result
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_rcd_ir_grade_a_score_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_rcd_ir_grade_a_score_result(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,serialno varchar2(60) -- 申请流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,rist_level varchar2(60) -- 风险等级
    ,grade number(6,2) -- 总评分
    ,mode_type varchar2(100) -- 评分模型类型
    ,cus_name varchar2(60) -- 客户号码
    ,prd_code varchar2(40) -- 产品编号
    ,customerid varchar2(60) -- 客户证件号码
    ,input_br_id varchar2(30) -- 所属机构
    ,input_br_id_all varchar2(30) -- 所属机构(所有)
    ,cus_id varchar2(40) -- 客户号
    ,cert_type varchar2(5) -- 客户证件类型
    ,rerun_flag varchar2(5) -- 重跑标志，Y-是 N-否
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
grant select on ${iol_schema}.rsts_rcd_ir_grade_a_score_result to ${iml_schema};
grant select on ${iol_schema}.rsts_rcd_ir_grade_a_score_result to ${icl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_grade_a_score_result to ${idl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_grade_a_score_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_rcd_ir_grade_a_score_result is 'A卡_总得分_评分结果表';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.serialno is '申请流水号';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.data_time is '数据记录时间';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.rist_level is '风险等级';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.grade is '总评分';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.mode_type is '评分模型类型';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.cus_name is '客户号码';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.prd_code is '产品编号';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.customerid is '客户证件号码';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.input_br_id is '所属机构';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.input_br_id_all is '所属机构(所有)';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.cus_id is '客户号';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.cert_type is '客户证件类型';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.rerun_flag is '重跑标志，Y-是 N-否';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.start_dt is '开始时间';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.end_dt is '结束时间';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.id_mark is '增删标志';
comment on column ${iol_schema}.rsts_rcd_ir_grade_a_score_result.etl_timestamp is 'ETL处理时间戳';
