/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ntm_schedule
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ntm_schedule
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ntm_schedule purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_schedule(
    schedule_id number(20,0) -- 分配表id
    ,loan_id number(20,0) -- 贷款计划id
    ,org varchar2(18) -- 机构号
    ,acct_no number(20,0) -- 账户编号
    ,acct_type varchar2(2) -- 账户类型
    ,logical_card_no varchar2(29) -- 逻辑卡号
    ,card_no varchar2(29) -- 卡号
    ,loan_init_prin number(15,2) -- 贷款总本金
    ,loan_init_term number(22) -- 贷款总期数
    ,curr_term number(22) -- 当前期数
    ,loan_term_prin number(15,2) -- 应还本金
    ,loan_term_fee1 number(15,2) -- 应还费用
    ,loan_term_interest number(15,2) -- 应还利息
    ,loan_pmt_due_date date -- 到款到期还款日期
    ,loan_grace_date date -- 宽限日
    ,last_modified_datetime date -- 修改时间
    ,start_date date -- 起息日
    ,schedule_action varchar2(2) -- 还款计划操作动作
    ,prin_paid number(15,2) -- 已偿还本金
    ,int_paid number(15,2) -- 已偿还利息
    ,penalty_paid number(15,2) -- 已偿还罚息
    ,compound_paid number(15,2) -- 已偿还复利
    ,fee_paid number(15,2) -- 已偿还费用
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
    ,isztdata varchar2(2) -- 归属数据(1 中台;2 信贷)
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.mpcs_a0ntm_schedule to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ntm_schedule to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_schedule to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_schedule to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ntm_schedule is '贷款分配表';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.schedule_id is '分配表id';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.loan_id is '贷款计划id';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.org is '机构号';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.acct_no is '账户编号';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.acct_type is '账户类型';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.logical_card_no is '逻辑卡号';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.card_no is '卡号';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.loan_init_prin is '贷款总本金';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.loan_init_term is '贷款总期数';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.curr_term is '当前期数';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.loan_term_prin is '应还本金';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.loan_term_fee1 is '应还费用';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.loan_term_interest is '应还利息';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.loan_pmt_due_date is '到款到期还款日期';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.loan_grace_date is '宽限日';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.last_modified_datetime is '修改时间';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.start_date is '起息日';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.schedule_action is '还款计划操作动作';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.prin_paid is '已偿还本金';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.int_paid is '已偿还利息';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.penalty_paid is '已偿还罚息';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.compound_paid is '已偿还复利';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.fee_paid is '已偿还费用';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.isztdata is '归属数据(1 中台;2 信贷)';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0ntm_schedule.etl_timestamp is 'ETL处理时间戳';
