/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_rcd_ir_grade_collection_sum
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_rcd_ir_grade_collection_sum
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_rcd_ir_grade_collection_sum purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_rcd_ir_grade_collection_sum(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(30) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,loan_total_bal number(18,2) -- 贷款余额
    ,rist_level varchar2(20) -- 风险等级
    ,grade number(6,2) -- 评分结果
    ,warning_level varchar2(5) -- 预警优化级
    ,collection_level varchar2(5) -- 催收优先级
    ,past_overdue varchar2(5) -- 过去发生逾期情况
    ,overdue number -- 逾期期数
    ,remark varchar2(60) -- 备注
    ,mode_type varchar2(100) -- 模型类型
    ,serno varchar2(60) -- 业务流水号
    ,blng_org_id varchar2(30) -- 所属机构
    ,iden_num varchar2(40) -- 客户证件号码
    ,cus_name varchar2(100) -- 客户名称
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,exc_id varchar2(60) -- 执行清单ID
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
grant select on ${iol_schema}.rsts_rcd_ir_grade_collection_sum to ${iml_schema};
grant select on ${iol_schema}.rsts_rcd_ir_grade_collection_sum to ${icl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_grade_collection_sum to ${idl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_grade_collection_sum to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_rcd_ir_grade_collection_sum is 'C卡评分_总得分_催收';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.key_id is '主键';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.loan_no is '借据号';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.data_dt is '数据日期';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.loan_total_bal is '贷款余额';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.rist_level is '风险等级';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.grade is '评分结果';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.warning_level is '预警优化级';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.collection_level is '催收优先级';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.past_overdue is '过去发生逾期情况';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.overdue is '逾期期数';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.remark is '备注';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.mode_type is '模型类型';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.serno is '业务流水号';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.blng_org_id is '所属机构';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.iden_num is '客户证件号码';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.cus_name is '客户名称';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.exc_id is '执行清单ID';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_rcd_ir_grade_collection_sum.etl_timestamp is 'ETL处理时间戳';
