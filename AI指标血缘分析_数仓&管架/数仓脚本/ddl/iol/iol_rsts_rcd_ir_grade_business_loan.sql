/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rsts_rcd_ir_grade_business_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rsts_rcd_ir_grade_business_loan
whenever sqlerror continue none;
drop table ${iol_schema}.rsts_rcd_ir_grade_business_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rsts_rcd_ir_grade_business_loan(
    key_id varchar2(60) -- 主键
    ,data_dt varchar2(10) -- 数据日期
    ,loan_no varchar2(30) -- 借据号
    ,var_name varchar2(60) -- 变量名称
    ,var_desc varchar2(200) -- 变量描述
    ,var_value varchar2(60) -- 变量取值
    ,grade number(6,2) -- 评分
    ,remark varchar2(60) -- 备注
    ,mode_type varchar2(100) -- 模型类型
    ,serno varchar2(60) -- 业务流水号
    ,blng_org_id varchar2(30) -- 所属机构
    ,iden_num varchar2(40) -- 客户证件号码
    ,cus_name varchar2(100) -- 客户名称
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
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
grant select on ${iol_schema}.rsts_rcd_ir_grade_business_loan to ${iml_schema};
grant select on ${iol_schema}.rsts_rcd_ir_grade_business_loan to ${icl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_grade_business_loan to ${idl_schema};
grant select on ${iol_schema}.rsts_rcd_ir_grade_business_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.rsts_rcd_ir_grade_business_loan is 'B卡评分_细项得分_经营贷行为';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.key_id is '主键';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.data_dt is '数据日期';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.loan_no is '借据号';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.var_name is '变量名称';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.var_desc is '变量描述';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.var_value is '变量取值';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.grade is '评分';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.remark is '备注';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.mode_type is '模型类型';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.serno is '业务流水号';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.blng_org_id is '所属机构';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.iden_num is '客户证件号码';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.cus_name is '客户名称';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.exc_id is '执行清单ID';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rsts_rcd_ir_grade_business_loan.etl_timestamp is 'ETL处理时间戳';
