/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_a_apply_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_a_apply_info
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_a_apply_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_a_apply_info(
    grade_key_id varchar2(60) -- 申请评分流水号
    ,application_num varchar2(40) -- 申请编号
    ,data_time varchar2(20) -- 数据记录时间
    ,apply_date varchar2(10) -- 申请日期
    ,loan_amt_raw number(24,6) -- 申请金额
    ,loan_cur varchar2(40) -- 申请币种
    ,loan_cur_std varchar2(40) -- 申请币种(规则标准)
    ,repay_mode varchar2(40) -- 还款方式
    ,repay_mode_std varchar2(40) -- 还款方式(规则标准)
    ,loan_purpose varchar2(40) -- 贷款用途
    ,loan_purpose_desc varchar2(100) -- 贷款用途描述
    ,original_loan_term_raw number(17,2) -- 贷款期限
    ,prod_type_raw varchar2(40) -- 贷款种类
    ,prod_type_raw_std varchar2(40) -- 贷款种类(规则标准)
    ,cus_manager varchar2(40) -- 客户经理
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
grant select on ${iol_schema}.rcds_ir_a_apply_info to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_a_apply_info to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_a_apply_info to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_a_apply_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_a_apply_info is '一次性数据-申请信息';
comment on column ${iol_schema}.rcds_ir_a_apply_info.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_a_apply_info.application_num is '申请编号';
comment on column ${iol_schema}.rcds_ir_a_apply_info.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_a_apply_info.apply_date is '申请日期';
comment on column ${iol_schema}.rcds_ir_a_apply_info.loan_amt_raw is '申请金额';
comment on column ${iol_schema}.rcds_ir_a_apply_info.loan_cur is '申请币种';
comment on column ${iol_schema}.rcds_ir_a_apply_info.loan_cur_std is '申请币种(规则标准)';
comment on column ${iol_schema}.rcds_ir_a_apply_info.repay_mode is '还款方式';
comment on column ${iol_schema}.rcds_ir_a_apply_info.repay_mode_std is '还款方式(规则标准)';
comment on column ${iol_schema}.rcds_ir_a_apply_info.loan_purpose is '贷款用途';
comment on column ${iol_schema}.rcds_ir_a_apply_info.loan_purpose_desc is '贷款用途描述';
comment on column ${iol_schema}.rcds_ir_a_apply_info.original_loan_term_raw is '贷款期限';
comment on column ${iol_schema}.rcds_ir_a_apply_info.prod_type_raw is '贷款种类';
comment on column ${iol_schema}.rcds_ir_a_apply_info.prod_type_raw_std is '贷款种类(规则标准)';
comment on column ${iol_schema}.rcds_ir_a_apply_info.cus_manager is '客户经理';
comment on column ${iol_schema}.rcds_ir_a_apply_info.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_a_apply_info.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_a_apply_info.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_a_apply_info.etl_timestamp is 'ETL处理时间戳';
