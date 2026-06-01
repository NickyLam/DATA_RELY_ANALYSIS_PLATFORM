/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_attach
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_attach
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_attach purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_attach(
    internal_key number(15,0) -- 账户内部键值
    ,client_no varchar2(16) -- 客户编号
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,pri_due_days number(5,0) -- 本金逾期天数（考虑宽限期）
    ,int_due_days number(5,0) -- 利息逾期天数（考虑宽限期）
    ,pri_first_date date -- 本金最早逾期日期
    ,int_first_date date -- 利息最早逾期日期
    ,last_change_date date -- 最后修改日期
    ,due_days number(5,0) -- 
    ,act_tran_amt number(17,2) -- 
    ,reference varchar2(50) -- 
    ,remark varchar2(600) -- 
    ,loan_type varchar2(50) -- 
    ,hide_sched_flag varchar2(1) -- 
    ,is_counter_fyj_flag varchar2(1) -- 
    ,old_five_category varchar2(10) -- 
    ,fyj_reason varchar2(1) -- 
    ,change_reason varchar2(200) -- 
    ,past_due_last_stage number(5,0) -- 
    ,past_due_stage_count number(5,0) -- 
    ,first_overdue_date date -- 
    ,comp_flag varchar2(1) -- 
    ,receipt_type varchar2(2) -- 
    ,rec_amt_ctrl varchar2(1) -- 
    ,inp_eod_flag varchar2(3) -- 
    ,comp_rule varchar2(20) -- 
    ,comp_highest varchar2(5) -- 
    ,comp_effect_flag varchar2(1) -- 
    ,open_tran_timestamp varchar2(26) -- 开户时间戳
    ,close_tran_timestamp varchar2(26) -- 销户时间戳
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
grant select on ${iol_schema}.ncbs_cl_acct_attach to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_attach to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_attach to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_attach to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_attach is '账户辅助信息表';
comment on column ${iol_schema}.ncbs_cl_acct_attach.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_attach.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_attach.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_attach.pri_due_days is '本金逾期天数（考虑宽限期）';
comment on column ${iol_schema}.ncbs_cl_acct_attach.int_due_days is '利息逾期天数（考虑宽限期）';
comment on column ${iol_schema}.ncbs_cl_acct_attach.pri_first_date is '本金最早逾期日期';
comment on column ${iol_schema}.ncbs_cl_acct_attach.int_first_date is '利息最早逾期日期';
comment on column ${iol_schema}.ncbs_cl_acct_attach.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_acct_attach.due_days is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.act_tran_amt is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.reference is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.remark is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.loan_type is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.hide_sched_flag is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.is_counter_fyj_flag is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.old_five_category is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.fyj_reason is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.change_reason is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.past_due_last_stage is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.past_due_stage_count is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.first_overdue_date is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.comp_flag is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.receipt_type is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.rec_amt_ctrl is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.inp_eod_flag is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.comp_rule is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.comp_highest is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.comp_effect_flag is '';
comment on column ${iol_schema}.ncbs_cl_acct_attach.open_tran_timestamp is '开户时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_attach.close_tran_timestamp is '销户时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_attach.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_attach.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_attach.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_attach.etl_timestamp is 'ETL处理时间戳';
