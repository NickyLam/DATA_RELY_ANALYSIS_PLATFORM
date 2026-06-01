/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_grade_consumer_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_grade_consumer_loan
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_grade_consumer_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_grade_consumer_loan(
    key_id varchar2(60) -- 主键
    ,data_dt varchar2(10) -- 数据日期
    ,loan_no varchar2(30) -- 借据号
    ,var_name varchar2(60) -- 变量名称
    ,var_desc varchar2(60) -- 变量描述
    ,var_value varchar2(60) -- 变量取值
    ,grade number(6,2) -- 评分
    ,remark varchar2(60) -- 备注
    ,mode_type varchar2(5) -- 
    ,serno varchar2(60) -- 业务流水号
    ,blng_org_id varchar2(30) -- 所属机构
    ,iden_num varchar2(40) -- 客户证件号码
    ,cus_name varchar2(100) -- 客户名称
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,loan_biz_type_cd varchar2(30) -- 业务品种代码
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
grant select on ${iol_schema}.rcds_ir_grade_consumer_loan to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_grade_consumer_loan to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_grade_consumer_loan to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_grade_consumer_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_grade_consumer_loan is '评分表_消费贷行为';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.data_dt is '数据日期';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.loan_no is '借据号';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.var_name is '变量名称';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.var_desc is '变量描述';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.var_value is '变量取值';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.grade is '评分';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.remark is '备注';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.mode_type is '';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.serno is '业务流水号';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.blng_org_id is '所属机构';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.iden_num is '客户证件号码';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.cus_name is '客户名称';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.loan_biz_type_cd is '业务品种代码';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_grade_consumer_loan.etl_timestamp is 'ETL处理时间戳';
