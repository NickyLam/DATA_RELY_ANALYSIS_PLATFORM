/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_note_accr_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_note_accr_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_note_accr_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_note_accr_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(64) -- 交易账号/卡号
    ,business_unit varchar2(10) -- 账套
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,int_type varchar2(5) -- 利率类型
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,profit_center varchar2(20) -- 利润中心
    ,reference varchar2(50) -- 交易参考号
    ,remark varchar2(600) -- 备注
    ,company varchar2(20) -- 法人
    ,int_accrued_diff number(15,10) -- 计提金额差额
    ,int_calc_bal varchar2(2) -- 计息方式
    ,merge_type varchar2(10) -- 计提合并类型
    ,month_basis varchar2(3) -- 月基准
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,source_type varchar2(6) -- 渠道编号
    ,year_basis varchar2(3) -- 年基准天数
    ,int_class varchar2(6) -- 利息分类
    ,accounting_status varchar2(3) -- 核算状态
    ,accr_date date -- 计提日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,actual_rate number(15,8) -- 行内利率
    ,calc_int_amt number(38,2) -- 算息金额
    ,int_accrued number(17,2) -- 累计计提
    ,int_accrued_calc_ctd number(25,10) -- 计提日计提实际金额
    ,int_accrued_ctd number(17,2) -- 计提日计提利息
    ,real_rate number(15,8) -- 执行利率
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,reaccount_cd varchar2(20) -- 对账代码
    ,bus_seq_no varchar2(33) -- 业务流水号
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
grant select on ${iol_schema}.ncbs_rb_note_accr_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_note_accr_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_note_accr_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_note_accr_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_note_accr_hist is '登记簿计提流水表';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.int_accrued_diff is '计提金额差额';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.int_calc_bal is '计息方式';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.merge_type is '计提合并类型';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.month_basis is '月基准';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.year_basis is '年基准天数';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.accr_date is '计提日期';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.calc_int_amt is '算息金额';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.int_accrued is '累计计提';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.int_accrued_calc_ctd is '计提日计提实际金额';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.int_accrued_ctd is '计提日计提利息';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_note_accr_hist.etl_timestamp is 'ETL处理时间戳';
