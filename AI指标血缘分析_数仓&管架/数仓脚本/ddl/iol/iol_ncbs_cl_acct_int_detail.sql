/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_acct_int_detail
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_acct_int_detail
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_acct_int_detail purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_acct_int_detail(
    last_int_calc_date date -- 上一利息计算日期
    ,agg number(38,2) -- 积数
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,company varchar2(20) -- 法人
    ,dac_value varchar2(200) -- dac值防篡改加密
    ,discnt_ui_flag varchar2(1) -- 折扣利息标志
    ,int_accrued_diff number(15,10) -- 计提金额差额
    ,tax_accrued_diff number(15,10) -- 利息税差额
    ,int_class varchar2(6) -- 利息分类
    ,calc_begin_date date -- 利息计算起始日
    ,calc_end_date date -- 利息计算截止日
    ,last_accrual_date date -- 上一利息计提日
    ,last_change_date date -- 最后修改日期
    ,last_cycle_date date -- 上一结息日
    ,last_cycle_date_pre date -- 日切前上一结息日
    ,last_true_cycle_date date -- 上一真实结息日
    ,next_accr_date date -- 下一计提日期
    ,next_cycle_date date -- 下一结息日
    ,settle_cycle_date date -- 账户结算日期
    ,td_last_accr_date date -- 当期上一计提日
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,agree_agg number(38,2) -- 协议积数
    ,agree_int number(17,2) -- 协议利息
    ,agree_reduce_amt number(17,2) -- 协议优惠金额
    ,discnt_int number(17,2) -- 折扣利息
    ,discnt_int_prev number(17,2) -- 上日前付息
    ,discnt_retain_int number(17,2) -- 未实现利息
    ,follow_trace_natural_days number(5) -- 回溯自然日天数
    ,follow_trace_workday_days number(5) -- 回溯工作日天数
    ,int_accrued number(17,2) -- 累计计提
    ,int_accrued_calc_ctd number(25,10) -- 计提日计提实际金额
    ,int_accrued_ctd number(17,2) -- 计提日计提利息
    ,int_accrued_prev number(17,2) -- 上日累计计提利息
    ,int_adj number(17,2) -- 利息调增金额
    ,int_adj_ctd number(17,2) -- 计提日利息调整
    ,int_adj_prev number(17,2) -- 上日利息调整(累计)
    ,int_amt number(17,2) -- 利息金额
    ,int_cap_amt number(17,2) -- 利息资本化金额
    ,int_past_due number(17,2) -- 逾期利息值
    ,int_posted number(17,2) -- 结息金额
    ,int_posted_ctd number(17,2) -- 结息日利息金额
    ,int_rem_days number(5) -- 计息剩余天数
    ,int_tax_t number(17,2) -- 存量利息税
    ,last_change_user_id varchar2(8) -- 最后修改柜员
    ,last_int_past_due number(17,2) -- 上日逾期利息
    ,tax_accrued number(17,2) -- 结息周期内利息税累计金额
    ,tax_accrued_calc_ctd number(25,10) -- 计提日利息税原金额
    ,tax_accrued_ctd number(17,2) -- 计提日利息税
    ,tax_posted number(17,2) -- 利息税累计金额
    ,tax_posted_ctd number(17,2) -- 结息日利息税
    ,td_accr_int_day varchar2(2) -- 计提起始日
    ,td_int_num_days number(5) -- 当期累计计息天数
    ,ui_int number(17,2) -- 折扣付出利息
    ,ui_penalty_amt number(17,2) -- 折扣罚息金额
    ,cur_amortize_accrued number(17,2) -- 当期累计已摊销计提
    ,last_bal_upd_date date -- 上次动户日期
    ,last_int_accrued_prev number(17,2) -- 上上日累计计提利息
    ,last_int_adj_prev number(17,2) -- 上上日利息累计计提调整
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
grant select on ${iol_schema}.ncbs_cl_acct_int_detail to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_acct_int_detail to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_int_detail to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_acct_int_detail to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_acct_int_detail is '利息明细表';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_int_calc_date is '上一利息计算日期';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.agg is '积数';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.company is '法人';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.dac_value is 'dac值防篡改加密';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.discnt_ui_flag is '折扣利息标志';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_accrued_diff is '计提金额差额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.tax_accrued_diff is '利息税差额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.calc_begin_date is '利息计算起始日';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.calc_end_date is '利息计算截止日';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_accrual_date is '上一利息计提日';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_cycle_date is '上一结息日';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_cycle_date_pre is '日切前上一结息日';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_true_cycle_date is '上一真实结息日';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.next_accr_date is '下一计提日期';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.next_cycle_date is '下一结息日';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.settle_cycle_date is '账户结算日期';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.td_last_accr_date is '当期上一计提日';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.agree_agg is '协议积数';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.agree_int is '协议利息';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.agree_reduce_amt is '协议优惠金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.discnt_int is '折扣利息';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.discnt_int_prev is '上日前付息';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.discnt_retain_int is '未实现利息';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.follow_trace_natural_days is '回溯自然日天数';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.follow_trace_workday_days is '回溯工作日天数';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_accrued is '累计计提';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_accrued_calc_ctd is '计提日计提实际金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_accrued_ctd is '计提日计提利息';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_accrued_prev is '上日累计计提利息';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_adj is '利息调增金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_adj_ctd is '计提日利息调整';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_adj_prev is '上日利息调整(累计)';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_cap_amt is '利息资本化金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_past_due is '逾期利息值';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_posted is '结息金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_posted_ctd is '结息日利息金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_rem_days is '计息剩余天数';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.int_tax_t is '存量利息税';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_change_user_id is '最后修改柜员';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_int_past_due is '上日逾期利息';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.tax_accrued is '结息周期内利息税累计金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.tax_accrued_calc_ctd is '计提日利息税原金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.tax_accrued_ctd is '计提日利息税';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.tax_posted is '利息税累计金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.tax_posted_ctd is '结息日利息税';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.td_accr_int_day is '计提起始日';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.td_int_num_days is '当期累计计息天数';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.ui_int is '折扣付出利息';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.ui_penalty_amt is '折扣罚息金额';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.cur_amortize_accrued is '当期累计已摊销计提';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_bal_upd_date is '上次动户日期';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_int_accrued_prev is '上上日累计计提利息';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.last_int_adj_prev is '上上日利息累计计提调整';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_cl_acct_int_detail.etl_timestamp is 'ETL处理时间戳';
