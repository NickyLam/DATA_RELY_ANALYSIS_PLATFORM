/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_financial_acct_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_financial_acct_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_financial_acct_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_financial_acct_register(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,acct_status varchar2(1) -- 账户状态
    ,agg number(38,2) -- 积数
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,acct_desc varchar2(200) -- 账户描述
    ,acct_exec varchar2(24) -- 银行客户经理编号
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_type varchar2(5) -- 协议类型
    ,company varchar2(20) -- 法人
    ,individual_flag varchar2(1) -- 对公对私标志
    ,int_accrued_diff number(15,10) -- 计提金额差额
    ,int_appl_type varchar2(1) -- 利率启用方式
    ,int_calc_bal varchar2(2) -- 计息方式
    ,int_ind_flag varchar2(1) -- 是否计息
    ,month_basis varchar2(3) -- 月基准
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,acct_close_date date -- 销户日期
    ,acct_open_date date -- 账户开户日期
    ,last_accrual_date date -- 上一利息计提日
    ,last_bal_upd_date date -- 上次动户日期
    ,last_change_date date -- 最后修改日期
    ,last_cycle_date date -- 上一结息日
    ,maturity_date date -- 到期日期
    ,next_accr_date date -- 下一计提日期
    ,next_cycle_date date -- 下一结息日
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,int_accrued number(17,2) -- 累计计提
    ,int_accrued_calc_ctd number(25,10) -- 计提日计提实际金额
    ,int_accrued_ctd number(17,2) -- 计提日计提利息
    ,int_accrued_prev number(17,2) -- 上日累计计提利息
    ,int_adj number(17,2) -- 利息调增金额
    ,int_adj_ctd number(17,2) -- 计提日利息调整
    ,int_adj_prev number(17,2) -- 上日利息调整(累计)
    ,int_posted number(17,2) -- 结息金额
    ,int_posted_ctd number(17,2) -- 结息日利息金额
    ,parent_internal_key number(15) -- 上级账户标识符
    ,real_rate number(15,8) -- 执行利率
    ,total_amount number(17,2) -- 汇总金额
    ,total_amount_prev number(17,2) -- 上日总金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
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
grant select on ${iol_schema}.ncbs_rb_financial_acct_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_financial_acct_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_financial_acct_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_financial_acct_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_financial_acct_register is '理财账户登记薄';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.acct_status is '账户状态';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.agg is '积数';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.term is '存期';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.acct_desc is '账户描述';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.acct_exec is '银行客户经理编号';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.company is '法人';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.individual_flag is '对公对私标志';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_accrued_diff is '计提金额差额';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_appl_type is '利率启用方式';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_calc_bal is '计息方式';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_ind_flag is '是否计息';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.acct_close_date is '销户日期';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.last_accrual_date is '上一利息计提日';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.last_bal_upd_date is '上次动户日期';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.last_change_date is '最后修改日期';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.last_cycle_date is '上一结息日';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.next_accr_date is '下一计提日期';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.next_cycle_date is '下一结息日';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_accrued is '累计计提';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_accrued_calc_ctd is '计提日计提实际金额';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_accrued_ctd is '计提日计提利息';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_accrued_prev is '上日累计计提利息';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_adj is '利息调增金额';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_adj_ctd is '计提日利息调整';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_adj_prev is '上日利息调整(累计)';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_posted is '结息金额';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.int_posted_ctd is '结息日利息金额';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.parent_internal_key is '上级账户标识符';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.total_amount is '汇总金额';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.total_amount_prev is '上日总金额';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_financial_acct_register.etl_timestamp is 'ETL处理时间戳';
