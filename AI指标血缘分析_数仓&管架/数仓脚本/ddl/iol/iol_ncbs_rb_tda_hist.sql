/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_tda_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_tda_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_tda_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tda_hist(
    client_no varchar2(16) -- 客户编号
    ,doc_type varchar2(10) -- 凭证类型
    ,internal_key number(15) -- 账户内部键值
    ,reference varchar2(50) -- 交易参考号
    ,user_id varchar2(8) -- 交易柜员编号
    ,add_term number(5) -- 续存期数
    ,addtl_principal varchar2(1) -- 是否允许增加本金
    ,auto_renew_rollover varchar2(1) -- 自动转存方式
    ,company varchar2(20) -- 法人
    ,impound_type varchar2(1) -- 扣划类型
    ,lost_no varchar2(50) -- 挂失编号
    ,mat_notice_flag varchar2(1) -- 是否到期通知
    ,movt_status varchar2(1) -- 转存类型
    ,partial_renew_roll varchar2(1) -- 是否部分本金转存
    ,prefix varchar2(10) -- 前缀
    ,renew_no number(5) -- 本金转存次数
    ,rev_seq_no varchar2(50) -- 冲正交易序号
    ,rollover_no number(5) -- 本息转存次数
    ,seq_no varchar2(50) -- 序号
    ,seq_renew_rollover_no varchar2(50) -- 转存序号
    ,tda_certificate_no varchar2(50) -- 定期存单号
    ,tda_status varchar2(1) -- 定期交易状态
    ,tran_scene varchar2(50) -- 交易场景
    ,tran_seq_no varchar2(50) -- 交易序号
    ,acct_movt_date date -- 转存交易日期
    ,acct_open_date date -- 账户开户日期
    ,maturity_date date -- 到期日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_level_int_rate number(15,8) -- 账户基础利率
    ,debt_amt number(17,2) -- 支取金额
    ,debt_int_rate number(15,8) -- 支取利率
    ,dep_term_period varchar2(5) -- 定期存期
    ,dep_term_type varchar2(1) -- 定期账户存期类型
    ,gross_interest_amt number(17,2) -- 总利息金额
    ,int_adj number(17,2) -- 利息调增金额
    ,int_adj_ctd number(17,2) -- 计提日利息调整
    ,net_interest_amt number(17,2) -- 净利息
    ,notice_period varchar2(5) -- 通知期限
    ,principal_amt number(17,2) -- 交易本金
    ,principal_amt_actual number(17,2) -- 实际本金金额
    ,spread_rate number(15,8) -- 浮动点数
    ,tax_amt number(17,2) -- 税金
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
grant select on ${iol_schema}.ncbs_rb_tda_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_tda_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_tda_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_tda_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_tda_hist is '定期交易历史表';
comment on column ${iol_schema}.ncbs_rb_tda_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_tda_hist.doc_type is '凭证类型';
comment on column ${iol_schema}.ncbs_rb_tda_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_tda_hist.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_tda_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_tda_hist.add_term is '续存期数';
comment on column ${iol_schema}.ncbs_rb_tda_hist.addtl_principal is '是否允许增加本金';
comment on column ${iol_schema}.ncbs_rb_tda_hist.auto_renew_rollover is '自动转存方式';
comment on column ${iol_schema}.ncbs_rb_tda_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_tda_hist.impound_type is '扣划类型';
comment on column ${iol_schema}.ncbs_rb_tda_hist.lost_no is '挂失编号';
comment on column ${iol_schema}.ncbs_rb_tda_hist.mat_notice_flag is '是否到期通知';
comment on column ${iol_schema}.ncbs_rb_tda_hist.movt_status is '转存类型';
comment on column ${iol_schema}.ncbs_rb_tda_hist.partial_renew_roll is '是否部分本金转存';
comment on column ${iol_schema}.ncbs_rb_tda_hist.prefix is '前缀';
comment on column ${iol_schema}.ncbs_rb_tda_hist.renew_no is '本金转存次数';
comment on column ${iol_schema}.ncbs_rb_tda_hist.rev_seq_no is '冲正交易序号';
comment on column ${iol_schema}.ncbs_rb_tda_hist.rollover_no is '本息转存次数';
comment on column ${iol_schema}.ncbs_rb_tda_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_tda_hist.seq_renew_rollover_no is '转存序号';
comment on column ${iol_schema}.ncbs_rb_tda_hist.tda_certificate_no is '定期存单号';
comment on column ${iol_schema}.ncbs_rb_tda_hist.tda_status is '定期交易状态';
comment on column ${iol_schema}.ncbs_rb_tda_hist.tran_scene is '交易场景';
comment on column ${iol_schema}.ncbs_rb_tda_hist.tran_seq_no is '交易序号';
comment on column ${iol_schema}.ncbs_rb_tda_hist.acct_movt_date is '转存交易日期';
comment on column ${iol_schema}.ncbs_rb_tda_hist.acct_open_date is '账户开户日期';
comment on column ${iol_schema}.ncbs_rb_tda_hist.maturity_date is '到期日期';
comment on column ${iol_schema}.ncbs_rb_tda_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_tda_hist.acct_level_int_rate is '账户基础利率';
comment on column ${iol_schema}.ncbs_rb_tda_hist.debt_amt is '支取金额';
comment on column ${iol_schema}.ncbs_rb_tda_hist.debt_int_rate is '支取利率';
comment on column ${iol_schema}.ncbs_rb_tda_hist.dep_term_period is '定期存期';
comment on column ${iol_schema}.ncbs_rb_tda_hist.dep_term_type is '定期账户存期类型';
comment on column ${iol_schema}.ncbs_rb_tda_hist.gross_interest_amt is '总利息金额';
comment on column ${iol_schema}.ncbs_rb_tda_hist.int_adj is '利息调增金额';
comment on column ${iol_schema}.ncbs_rb_tda_hist.int_adj_ctd is '计提日利息调整';
comment on column ${iol_schema}.ncbs_rb_tda_hist.net_interest_amt is '净利息';
comment on column ${iol_schema}.ncbs_rb_tda_hist.notice_period is '通知期限';
comment on column ${iol_schema}.ncbs_rb_tda_hist.principal_amt is '交易本金';
comment on column ${iol_schema}.ncbs_rb_tda_hist.principal_amt_actual is '实际本金金额';
comment on column ${iol_schema}.ncbs_rb_tda_hist.spread_rate is '浮动点数';
comment on column ${iol_schema}.ncbs_rb_tda_hist.tax_amt is '税金';
comment on column ${iol_schema}.ncbs_rb_tda_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_tda_hist.etl_timestamp is 'ETL处理时间戳';
