/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_rcd_ir_grade_business_loan_sum
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum(
    key_id varchar2(60) -- 主键
    ,loan_no varchar2(30) -- 借据号
    ,data_dt varchar2(10) -- 数据日期
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
    ,loan_total_bal number(18,2) -- 贷款余额
    ,rist_level varchar2(2) -- 风险等级
    ,grade number(6,2) -- 评分结果
    ,warning_level varchar2(5) -- 预警优化级
    ,collection_level varchar2(5) -- 催收优先级
    ,past_overdue varchar2(5) -- 过去发生逾期情况
    ,overdue number(22) -- 逾期期数
    ,remark varchar2(60) -- 备注
    ,mode_type varchar2(5) -- 
    ,serno varchar2(60) -- 业务流水号
    ,blng_org_id varchar2(30) -- 所属机构
    ,iden_num varchar2(40) -- 客户证件号码
    ,cus_name varchar2(100) -- 客户名称
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by range(end_dt)(
    partition p_19000101 values less than (to_date('20991231','yyyymmdd'))
    ,partition p_20991231 values less than (maxvalue)
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum to ${iml_schema};
grant select on ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum to ${icl_schema};
grant select on ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum to ${idl_schema};
grant select on ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum is '评分表_经营贷行为汇总';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.key_id is '主键';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.loan_no is '借据号';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.loan_total_bal is '贷款余额';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.rist_level is '风险等级';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.grade is '评分结果';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.warning_level is '预警优化级';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.collection_level is '催收优先级';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.past_overdue is '过去发生逾期情况';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.overdue is '逾期期数';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.remark is '备注';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.mode_type is '';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.serno is '业务流水号';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.blng_org_id is '所属机构';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.iden_num is '客户证件号码';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.cus_name is '客户名称';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_rcd_ir_grade_business_loan_sum.etl_timestamp is 'ETL处理时间戳';
