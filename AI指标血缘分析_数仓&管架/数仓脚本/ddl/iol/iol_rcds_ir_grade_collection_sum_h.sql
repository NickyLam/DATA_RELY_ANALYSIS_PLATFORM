/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_grade_collection_sum_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_grade_collection_sum_h
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_grade_collection_sum_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_grade_collection_sum_h(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(30) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,loan_total_bal number(18,2) -- 贷款余额
    ,rist_level varchar2(2) -- 风险等级
    ,grade number(6,2) -- 评分结果
    ,warning_level varchar2(5) -- 预警优先级
    ,collection_level varchar2(5) -- 催收优先级
    ,remark varchar2(60) -- 备注
    ,mode_type varchar2(5) -- 评分模型类型
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
grant select on ${iol_schema}.rcds_ir_grade_collection_sum_h to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_grade_collection_sum_h to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_grade_collection_sum_h to ${idl_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_grade_collection_sum_h is '评分表_催收汇总历史表';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.loan_no is '借据号';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.loan_total_bal is '贷款余额';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.rist_level is '风险等级';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.grade is '评分结果';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.warning_level is '预警优先级';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.collection_level is '催收优先级';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.remark is '备注';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.mode_type is '评分模型类型';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rcds_ir_grade_collection_sum_h.etl_timestamp is 'ETL处理时间戳';
