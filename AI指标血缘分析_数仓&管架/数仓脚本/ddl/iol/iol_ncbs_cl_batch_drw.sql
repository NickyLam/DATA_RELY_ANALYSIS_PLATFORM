/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_cl_batch_drw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_cl_batch_drw
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_cl_batch_drw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cl_batch_drw(
    branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,contract_no varchar2(30) -- 合同编号
    ,int_type varchar2(5) -- 利率类型
    ,prod_type varchar2(12) -- 产品编号
    ,tran_type varchar2(10) -- 交易类型
    ,analysis varchar2(10) -- 分析类型
    ,anytime_rec_flag varchar2(1) -- 随借随还标志
    ,auto_settle_flag varchar2(1) -- 自动结清标志
    ,batch_no varchar2(50) -- 批次号
    ,calc_by_int varchar2(1) -- 是否按正常利率浮动
    ,cmisloan_no varchar2(60) -- 客户借据编号
    ,company varchar2(20) -- 法人
    ,cycle_freq varchar2(5) -- 结息频率
    ,error_code varchar2(50) -- 错误码
    ,error_desc varchar2(3000) -- 错误描述
    ,guaranty_style varchar2(5) -- 担保方式
    ,int_appl_type varchar2(1) -- 利率启用方式
    ,job_run_id varchar2(50) -- 批处理任务id
    ,month_basis varchar2(3) -- 月基准
    ,odi_calc_by_int_flag varchar2(1) -- 复利利率是否随执行利率浮动
    ,ododi_calc_by_int varchar2(1) -- 复利的复利利率是否随执行利率浮动
    ,ododp_calc_by_int varchar2(1) -- 罚息的复利利率是否随执行利率浮动
    ,odp_calc_by_int varchar2(1) -- 罚息利率是否随执行利率浮动
    ,pre_repay_deal varchar2(1) -- 还款计划变更方式
    ,revolve_flag varchar2(1) -- 循环贷款标志
    ,roll_freq varchar2(5) -- 利率变更周期
    ,sched_mode varchar2(2) -- 还款方式
    ,seq_no varchar2(50) -- 序号
    ,tran_status varchar2(1) -- 冲补抹标志
    ,year_basis varchar2(3) -- 年基准天数
    ,hunting_status varchar2(1) -- 持续扣款标志
    ,dd_date date -- 贷款发放日期
    ,end_date date -- 结束日期
    ,next_cycle_date date -- 下一结息日
    ,next_roll_date date -- 下一个利率变更日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,dd_amt number(17,2) -- 发放金额
    ,int_actual_rate number(15,8) -- 正常利息行内利率
    ,int_rate number(15,8) -- 出单利率
    ,loan_no varchar2(50) -- 贷款号
    ,odi_actual_rate number(15,8) -- 复利行内利率
    ,odi_int_type varchar2(5) -- 复利利率类型
    ,odi_rate number(15,8) -- 贷款复利利率
    ,ododi_actual_rate number(15,8) -- 复利的复利行内利率
    ,ododi_int_type varchar2(5) -- 复利的复利利率类型
    ,ododi_rate number(15,8) -- 复利的复利利率
    ,ododp_actual_rate number(15,8) -- 罚息的复利行内利率
    ,ododp_int_type varchar2(5) -- 罚息的复利利率类型
    ,ododp_rate number(15,8) -- 罚息复利利率
    ,odp_actual_rate number(15,8) -- 罚息行内利率
    ,odp_int_type varchar2(5) -- 罚息利率类型
    ,odp_rate number(15,8) -- 贷款罚息利率
    ,orig_loan_amt number(17,2) -- 贷款签约合同金额
    ,roll_day varchar2(2) -- 利率变更日
    ,settle_pay_acct_seq_no varchar2(5) -- 结算账户序列号
    ,settle_pay_base_acct_no varchar2(50) -- 结算付款账户
    ,settle_rec_acct_seq_no varchar2(5) -- 自动回收结算账户序列号
    ,settle_rec_base_acct_no varchar2(50) -- 自动回收结算账户账号
    ,settle_wtr_acct_seq_no varchar2(5) -- 委托存款账户序列号
    ,settle_wtr_base_acct_no varchar2(50) -- 贷款委托账号
    ,settle_wts_acct_seq_no varchar2(5) -- 委托结算账户序列号
    ,settle_wts_base_acct_no varchar2(50) -- 委托结算账户账号
    ,int_day varchar2(2) -- 存贷结息日期
    ,reference varchar2(50) -- 交易参考号
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
grant select on ${iol_schema}.ncbs_cl_batch_drw to ${iml_schema};
grant select on ${iol_schema}.ncbs_cl_batch_drw to ${icl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_drw to ${idl_schema};
grant select on ${iol_schema}.ncbs_cl_batch_drw to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_cl_batch_drw is '批量发放明细表';
comment on column ${iol_schema}.ncbs_cl_batch_drw.branch is '机构编号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.ccy is '币种';
comment on column ${iol_schema}.ncbs_cl_batch_drw.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.contract_no is '合同编号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_cl_batch_drw.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_cl_batch_drw.analysis is '分析类型';
comment on column ${iol_schema}.ncbs_cl_batch_drw.anytime_rec_flag is '随借随还标志';
comment on column ${iol_schema}.ncbs_cl_batch_drw.auto_settle_flag is '自动结清标志';
comment on column ${iol_schema}.ncbs_cl_batch_drw.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.calc_by_int is '是否按正常利率浮动';
comment on column ${iol_schema}.ncbs_cl_batch_drw.cmisloan_no is '客户借据编号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.company is '法人';
comment on column ${iol_schema}.ncbs_cl_batch_drw.cycle_freq is '结息频率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.error_code is '错误码';
comment on column ${iol_schema}.ncbs_cl_batch_drw.error_desc is '错误描述';
comment on column ${iol_schema}.ncbs_cl_batch_drw.guaranty_style is '担保方式';
comment on column ${iol_schema}.ncbs_cl_batch_drw.int_appl_type is '利率启用方式';
comment on column ${iol_schema}.ncbs_cl_batch_drw.job_run_id is '批处理任务id';
comment on column ${iol_schema}.ncbs_cl_batch_drw.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_cl_batch_drw.odi_calc_by_int_flag is '复利利率是否随执行利率浮动';
comment on column ${iol_schema}.ncbs_cl_batch_drw.ododi_calc_by_int is '复利的复利利率是否随执行利率浮动';
comment on column ${iol_schema}.ncbs_cl_batch_drw.ododp_calc_by_int is '罚息的复利利率是否随执行利率浮动';
comment on column ${iol_schema}.ncbs_cl_batch_drw.odp_calc_by_int is '罚息利率是否随执行利率浮动';
comment on column ${iol_schema}.ncbs_cl_batch_drw.pre_repay_deal is '还款计划变更方式';
comment on column ${iol_schema}.ncbs_cl_batch_drw.revolve_flag is '循环贷款标志';
comment on column ${iol_schema}.ncbs_cl_batch_drw.roll_freq is '利率变更周期';
comment on column ${iol_schema}.ncbs_cl_batch_drw.sched_mode is '还款方式';
comment on column ${iol_schema}.ncbs_cl_batch_drw.seq_no is '序号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_cl_batch_drw.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_cl_batch_drw.hunting_status is '持续扣款标志';
comment on column ${iol_schema}.ncbs_cl_batch_drw.dd_date is '贷款发放日期';
comment on column ${iol_schema}.ncbs_cl_batch_drw.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_cl_batch_drw.next_cycle_date is '下一结息日';
comment on column ${iol_schema}.ncbs_cl_batch_drw.next_roll_date is '下一个利率变更日期';
comment on column ${iol_schema}.ncbs_cl_batch_drw.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_cl_batch_drw.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_cl_batch_drw.dd_amt is '发放金额';
comment on column ${iol_schema}.ncbs_cl_batch_drw.int_actual_rate is '正常利息行内利率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.int_rate is '出单利率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.loan_no is '贷款号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.odi_actual_rate is '复利行内利率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.odi_int_type is '复利利率类型';
comment on column ${iol_schema}.ncbs_cl_batch_drw.odi_rate is '贷款复利利率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.ododi_actual_rate is '复利的复利行内利率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.ododi_int_type is '复利的复利利率类型';
comment on column ${iol_schema}.ncbs_cl_batch_drw.ododi_rate is '复利的复利利率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.ododp_actual_rate is '罚息的复利行内利率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.ododp_int_type is '罚息的复利利率类型';
comment on column ${iol_schema}.ncbs_cl_batch_drw.ododp_rate is '罚息复利利率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.odp_actual_rate is '罚息行内利率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.odp_int_type is '罚息利率类型';
comment on column ${iol_schema}.ncbs_cl_batch_drw.odp_rate is '贷款罚息利率';
comment on column ${iol_schema}.ncbs_cl_batch_drw.orig_loan_amt is '贷款签约合同金额';
comment on column ${iol_schema}.ncbs_cl_batch_drw.roll_day is '利率变更日';
comment on column ${iol_schema}.ncbs_cl_batch_drw.settle_pay_acct_seq_no is '结算账户序列号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.settle_pay_base_acct_no is '结算付款账户';
comment on column ${iol_schema}.ncbs_cl_batch_drw.settle_rec_acct_seq_no is '自动回收结算账户序列号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.settle_rec_base_acct_no is '自动回收结算账户账号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.settle_wtr_acct_seq_no is '委托存款账户序列号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.settle_wtr_base_acct_no is '贷款委托账号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.settle_wts_acct_seq_no is '委托结算账户序列号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.settle_wts_base_acct_no is '委托结算账户账号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.int_day is '存贷结息日期';
comment on column ${iol_schema}.ncbs_cl_batch_drw.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_cl_batch_drw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_cl_batch_drw.etl_timestamp is 'ETL处理时间戳';
