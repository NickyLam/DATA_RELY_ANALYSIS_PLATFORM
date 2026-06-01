/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_schedule_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_schedule_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_schedule_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_schedule_detail(
    amt_type varchar2(10) -- 金额类型
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,company varchar2(20) -- 法人
    ,delay_pay_int varchar2(1) -- 延期付息标志
    ,fully_settled_flag varchar2(1) -- 单据全额回收标志
    ,invoice_flag varchar2(1) -- 是否出单
    ,invoice_gen_mode varchar2(1) -- 单据生成方式
    ,invoice_tran_no varchar2(50) -- 通知单号
    ,narrative varchar2(400) -- 摘要
    ,sched_seq_no varchar2(50) -- 还款计划序号
    ,stage_no number(5) -- 期次
    ,tax_type varchar2(2) -- 税种
    ,due_date date -- 单据到期日
    ,end_date date -- 结束日期
    ,final_settle_date date -- 最后结算日期
    ,grace_date date -- 宽限日
    ,last_change_date date -- 最后修改日期
    ,start_date date -- 开始日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,billed_amt number(17,2) -- 出单金额
    ,int_rate number(15,8) -- 出单利率
    ,outstanding number(17,2) -- 单据余额
    ,outstanding_prev number(17,2) -- 上日单据未还金额
    ,paid_amt number(17,2) -- 已还金额
    ,pri_outstanding number(17,2) -- 贷款还款本金金额
    ,sched_amt number(17,2) -- 还款计划金额
    ,tax_amt number(17,2) -- 税金
    ,tax_rate number(15,8) -- 税率
    ,wrn_amt number(17,2) -- 贷款核销本金
    ,outstanding_prev_change_date date -- 单据上日余额更新日期
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
grant select on ${iol_schema}.ncbs_cl_acct_schedule_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_schedule_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_schedule_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_schedule_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_schedule_detail is '账户计划明细表';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.delay_pay_int is '延期付息标志';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.fully_settled_flag is '单据全额回收标志';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.invoice_flag is '是否出单';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.invoice_gen_mode is '单据生成方式';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.invoice_tran_no is '通知单号';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.narrative is '摘要';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.sched_seq_no is '还款计划序号';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.stage_no is '期次';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.tax_type is '税种';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.due_date is '单据到期日';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.final_settle_date is '最后结算日期';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.grace_date is '宽限日';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.billed_amt is '出单金额';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.int_rate is '出单利率';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.outstanding is '单据余额';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.outstanding_prev is '上日单据未还金额';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.paid_amt is '已还金额';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.pri_outstanding is '贷款还款本金金额';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.sched_amt is '还款计划金额';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.wrn_amt is '贷款核销本金';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.outstanding_prev_change_date is '单据上日余额更新日期';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_schedule_detail.etl_timestamp is 'ETL处理时间戳';
