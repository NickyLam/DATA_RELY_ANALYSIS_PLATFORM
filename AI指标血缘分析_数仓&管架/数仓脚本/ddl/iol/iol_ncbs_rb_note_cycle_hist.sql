/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_note_cycle_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_note_cycle_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_note_cycle_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_note_cycle_hist(
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
    ,company varchar2(20) -- 法人
    ,narrative varchar2(400) -- 摘要
    ,seq_no varchar2(50) -- 序号
    ,source_module varchar2(3) -- 源模块
    ,int_class varchar2(6) -- 利息分类
    ,accounting_status varchar2(3) -- 核算状态
    ,acct_open_date date -- 账户开户日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,actual_rate number(15,8) -- 行内利率
    ,float_rate number(15,8) -- 浮动利率
    ,real_rate number(15,8) -- 执行利率
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_rb_note_cycle_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_note_cycle_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_note_cycle_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_note_cycle_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_note_cycle_hist is '登记簿结息流水表';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.business_unit is '账套';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.int_type is '利率类型';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.profit_center is '利润中心';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.source_module is '源模块';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.int_class is '利息分类';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.accounting_status is '核算状态';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.actual_rate is '行内利率';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.float_rate is '浮动利率';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.real_rate is '执行利率';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_note_cycle_hist.etl_timestamp is 'ETL处理时间戳';
