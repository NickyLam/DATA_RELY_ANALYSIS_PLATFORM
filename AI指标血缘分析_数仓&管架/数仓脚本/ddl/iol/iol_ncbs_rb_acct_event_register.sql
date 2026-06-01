/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_acct_event_register
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_acct_event_register
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_acct_event_register purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_acct_event_register(
    acct_seq_no varchar2(5) -- 账户子账号
    ,amt_type varchar2(10) -- 金额类型
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,business_unit varchar2(10) -- 账套
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,doc_type varchar2(10) -- 凭证类型
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,voucher_no varchar2(50) -- 凭证号码
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,company varchar2(20) -- 法人
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,int_cap_flag varchar2(1) -- 资本化标志
    ,movt_status varchar2(1) -- 转存类型
    ,narrative varchar2(400) -- 摘要
    ,prefix varchar2(10) -- 前缀
    ,print_cnt number(5) -- 打印次数
    ,seq_no varchar2(50) -- 序号
    ,seq_renew_rollover_no varchar2(50) -- 转存序号
    ,source_module varchar2(3) -- 源模块
    ,tax_type varchar2(2) -- 税种
    ,tran_status varchar2(1) -- 冲补抹标志
    ,int_class varchar2(6) -- 利息分类
    ,accounting_status varchar2(3) -- 核算状态
    ,acct_open_date date -- 账户开户日期
    ,last_cycle_date date -- 上一结息日
    ,maturity_date date -- 到期日期
    ,reversal_date date -- 冲正日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_level_int_rate number(15,8) -- 账户基础利率
    ,actual_rate number(15,8) -- 行内利率
    ,calc_days number(5) -- 算息天数
    ,calc_int_amt number(38,2) -- 算息金额
    ,debt_int_rate number(15,8) -- 支取利率
    ,float_rate number(15,8) -- 浮动利率
    ,gross_interest_amt number(17,2) -- 总利息金额
    ,int_adj number(17,2) -- 利息调增金额
    ,int_adj_ctd number(17,2) -- 计提日利息调整
    ,net_interest_amt number(17,2) -- 净利息
    ,principal_amt number(17,2) -- 交易本金
    ,real_rate number(15,8) -- 执行利率
    ,spread_rate number(15,8) -- 浮动点数
    ,tax_amt number(17,2) -- 税金
    ,tax_rate number(15,8) -- 税率
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,reaccount_cd varchar2(20) -- 对账代码
    ,bus_seq_no varchar2(33) -- 业务流水号
    ,calc_begin_date date -- 利息计算起始日
    ,year_basis varchar2(3) -- 年基准天数
    ,month_basis varchar2(3) -- 月基准
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
grant select on ${iol_schema}.ncbs_rb_acct_event_register to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_acct_event_register to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_event_register to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_acct_event_register to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_acct_event_register is '账户重要事件登记簿';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.business_unit is '账套';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.voucher_no is '凭证号码';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.term is '存期';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.company is '法人';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.int_cap_flag is '资本化标志';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.movt_status is '转存类型';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.print_cnt is '打印次数';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.seq_renew_rollover_no is '转存序号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.tax_type is '税种';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.last_cycle_date is '上一结息日';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.acct_level_int_rate is '账户基础利率';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.calc_days is '算息天数';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.calc_int_amt is '算息金额';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.debt_int_rate is '支取利率';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.gross_interest_amt is '总利息金额';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.int_adj is '利息调增金额';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.int_adj_ctd is '计提日利息调整';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.net_interest_amt is '净利息';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.principal_amt is '交易本金';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.spread_rate is '浮动点数';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.calc_begin_date is '利息计算起始日';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_acct_event_register.etl_timestamp is 'ETL处理时间戳';
