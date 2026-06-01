/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rcds_ir_indv_loan_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rcds_ir_indv_loan_info
whenever sqlerror continue none;
drop table ${iol_schema}.rcds_ir_indv_loan_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rcds_ir_indv_loan_info(
    key_id varchar2(60) -- 主键
    ,grade_key_id varchar2(60) -- 申请评分流水号
    ,data_time varchar2(20) -- 数据记录时间
    ,princp_bal varchar2(39) -- 本金余额
    ,loan_desc varchar2(300) -- 描述
    ,agt_status_cd varchar2(10) -- 贷款账户状态
    ,guar_mode_cd varchar2(2) -- 担保方式代码
    ,loan_type_cd varchar2(2) -- 贷款类型
    ,indv_loan_info_seq_num varchar2(12) -- 个人贷款信息序号
    ,last_two_year_repay_rec varchar2(100) -- 24期还款状态
    ,loan_issue_dt varchar2(20) -- 贷款发放日期
    ,last_two_year_repay_rec_align varchar2(50) -- 
    ,end_date varchar2(20) -- 
    ,curr_ovdue_amt varchar2(38) -- 当前逾期金额
    ,mon_payable_amt varchar2(38) -- 本月应还款金额
    ,ctr_amt varchar2(38) -- 合同金额
    ,loan_org varchar2(60) -- 贷款机构
    ,bal varchar2(38) -- 余额
    ,last_five_year_repay_rec varchar2(160) -- 60期还款状态
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
grant select on ${iol_schema}.rcds_ir_indv_loan_info to ${iml_schema};
grant select on ${iol_schema}.rcds_ir_indv_loan_info to ${icl_schema};
grant select on ${iol_schema}.rcds_ir_indv_loan_info to ${idl_schema};
grant select on ${iol_schema}.rcds_ir_indv_loan_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rcds_ir_indv_loan_info is '个人贷款信息表';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.key_id is '主键';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.grade_key_id is '申请评分流水号';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.data_time is '数据记录时间';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.princp_bal is '本金余额';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.loan_desc is '描述';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.agt_status_cd is '贷款账户状态';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.guar_mode_cd is '担保方式代码';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.loan_type_cd is '贷款类型';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.indv_loan_info_seq_num is '个人贷款信息序号';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.last_two_year_repay_rec is '24期还款状态';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.loan_issue_dt is '贷款发放日期';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.last_two_year_repay_rec_align is '';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.end_date is '';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.curr_ovdue_amt is '当前逾期金额';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.mon_payable_amt is '本月应还款金额';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.ctr_amt is '合同金额';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.loan_org is '贷款机构';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.bal is '余额';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.last_five_year_repay_rec is '60期还款状态';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.start_dt is '开始时间';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.end_dt is '结束时间';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.id_mark is '增删标志';
comment on column ${iol_schema}.rcds_ir_indv_loan_info.etl_timestamp is 'ETL处理时间戳';
