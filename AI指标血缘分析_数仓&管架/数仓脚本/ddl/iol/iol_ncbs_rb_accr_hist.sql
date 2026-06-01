/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_accr_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_accr_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_accr_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_accr_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,agg number(38,2) -- 积数
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,business_unit varchar2(10) -- 账套
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,client_type varchar2(3) -- 客户类型
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,agree_change_type varchar2(1) -- 协议变动方式
    ,company varchar2(20) -- 法人
    ,gl_merge_type_flag varchar2(1) -- 计提是否合并标志
    ,gl_posted_flag varchar2(1) -- 过账标记
    ,int_accrued_diff number(15,10) -- 计提金额差额
    ,int_calc_bal varchar2(2) -- 计息方式
    ,irl_seq_no varchar2(50) -- 费率编号
    ,month_basis varchar2(3) -- 月基准
    ,reversal_flag varchar2(1) -- 交易是否已冲正
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,system_id varchar2(20) -- 系统id
    ,tax_accrued_diff number(15,10) -- 利息税差额
    ,tax_type varchar2(2) -- 税种
    ,tran_source varchar2(1) -- 交易发起方
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,accounting_status varchar2(3) -- 核算状态
    ,accr_date date -- 计提日期
    ,td_last_accr_date date -- 当期上一计提日
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_percent_rate number(11,7) -- 分户级利率浮动百分比
    ,acct_spread_rate number(15,8) -- 分户级利率浮动百分点
    ,actual_rate number(15,8) -- 行内利率
    ,agree_fixed_rate number(15,8) -- 协议固定利率
    ,agree_percent_rate number(11,7) -- 协议浮动百分比
    ,agree_spread_rate number(15,8) -- 协议浮动百分点
    ,float_rate number(15,8) -- 浮动利率
    ,int_accrued number(17,2) -- 累计计提
    ,int_accrued_calc_ctd number(25,10) -- 计提日计提实际金额
    ,int_accrued_ctd number(17,2) -- 计提日计提利息
    ,int_amt number(17,2) -- 利息金额
    ,oth_reference varchar2(50) -- 对方交易参考号
    ,real_rate number(15,8) -- 执行利率
    ,tax_accrued number(17,2) -- 结息周期内利息税累计金额
    ,tax_accrued_calc_ctd number(25,10) -- 计提日利息税原金额
    ,tax_accrued_ctd number(17,2) -- 计提日利息税
    ,tax_rate number(15,8) -- 税率
    ,td_int_num_days number(5) -- 当期累计计息天数
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,reaccount_cd varchar2(20) -- 对账代码
    ,bus_seq_no varchar2(33) -- 业务流水号
    ,delay_pay_int varchar2(1) -- 延期付息标志
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
grant select on ${iol_schema}.ncbs_rb_accr_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_accr_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_accr_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_accr_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_accr_hist is '计提流水表';
comment on column ${iol_schema}.ncbs_rb_accr_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_accr_hist.agg is '积数';
comment on column ${iol_schema}.ncbs_rb_accr_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_accr_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_rb_accr_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_accr_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_accr_hist.client_type is '客户类型';
comment on column ${iol_schema}.ncbs_rb_accr_hist.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_accr_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_accr_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_accr_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_rb_accr_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_accr_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_accr_hist.agree_change_type is '协议变动方式';
comment on column ${iol_schema}.ncbs_rb_accr_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_accr_hist.gl_merge_type_flag is '计提是否合并标志';
comment on column ${iol_schema}.ncbs_rb_accr_hist.gl_posted_flag is '过账标记';
comment on column ${iol_schema}.ncbs_rb_accr_hist.int_accrued_diff is '计提金额差额';
comment on column ${iol_schema}.ncbs_rb_accr_hist.int_calc_bal is '计息方式';
comment on column ${iol_schema}.ncbs_rb_accr_hist.irl_seq_no is '费率编号';
comment on column ${iol_schema}.ncbs_rb_accr_hist.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_rb_accr_hist.reversal_flag is '交易是否已冲正';
comment on column ${iol_schema}.ncbs_rb_accr_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_accr_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_accr_hist.system_id is '系统id';
comment on column ${iol_schema}.ncbs_rb_accr_hist.tax_accrued_diff is '利息税差额';
comment on column ${iol_schema}.ncbs_rb_accr_hist.tax_type is '税种';
comment on column ${iol_schema}.ncbs_rb_accr_hist.tran_source is '交易发起方';
comment on column ${iol_schema}.ncbs_rb_accr_hist.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_accr_hist.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_accr_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_rb_accr_hist.accr_date is '计提日期';
comment on column ${iol_schema}.ncbs_rb_accr_hist.td_last_accr_date is '当期上一计提日';
comment on column ${iol_schema}.ncbs_rb_accr_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_accr_hist.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_rb_accr_hist.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_accr_hist.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_accr_hist.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_accr_hist.agree_fixed_rate is '协议固定利率';
comment on column ${iol_schema}.ncbs_rb_accr_hist.agree_percent_rate is '协议浮动百分比';
comment on column ${iol_schema}.ncbs_rb_accr_hist.agree_spread_rate is '协议浮动百分点';
comment on column ${iol_schema}.ncbs_rb_accr_hist.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_accr_hist.int_accrued is '累计计提';
comment on column ${iol_schema}.ncbs_rb_accr_hist.int_accrued_calc_ctd is '计提日计提实际金额';
comment on column ${iol_schema}.ncbs_rb_accr_hist.int_accrued_ctd is '计提日计提利息';
comment on column ${iol_schema}.ncbs_rb_accr_hist.int_amt is '利息金额';
comment on column ${iol_schema}.ncbs_rb_accr_hist.oth_reference is '对方交易参考号';
comment on column ${iol_schema}.ncbs_rb_accr_hist.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_accr_hist.tax_accrued is '结息周期内利息税累计金额';
comment on column ${iol_schema}.ncbs_rb_accr_hist.tax_accrued_calc_ctd is '计提日利息税原金额';
comment on column ${iol_schema}.ncbs_rb_accr_hist.tax_accrued_ctd is '计提日利息税';
comment on column ${iol_schema}.ncbs_rb_accr_hist.tax_rate is '税率';
comment on column ${iol_schema}.ncbs_rb_accr_hist.td_int_num_days is '当期累计计息天数';
comment on column ${iol_schema}.ncbs_rb_accr_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_accr_hist.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_rb_accr_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_rb_accr_hist.delay_pay_int is '延期付息标志';
comment on column ${iol_schema}.ncbs_rb_accr_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_accr_hist.etl_timestamp is 'ETL处理时间戳';
