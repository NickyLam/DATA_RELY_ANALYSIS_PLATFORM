/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_appr_letter_tran_hist
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_appr_letter_tran_hist
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_appr_letter_tran_hist purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_appr_letter_tran_hist(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,branch varchar2(12) -- 机构编号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,gl_code varchar2(20) -- 科目代码
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_desc varchar2(200) -- 账户描述
    ,appr_letter_no varchar2(30) -- 核准件编号
    ,appr_type varchar2(10) -- 核准件类型
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,cash_item varchar2(10) -- 现金项目
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,cr_dr_maint_ind varchar2(1) -- 借贷标识
    ,event_type varchar2(20) -- 事件类型
    ,narrative varchar2(400) -- 摘要
    ,oth_acct_desc varchar2(600) -- 对方账户描述
    ,oth_seq_no varchar2(50) -- 对方交易流水号
    ,priority varchar2(20) -- 优先级
    ,reversal_tran_type varchar2(10) -- 冲正交易类型
    ,seq_no varchar2(50) -- 序号
    ,serv_charge varchar2(1) -- 服务费标识
    ,source_type varchar2(6) -- 渠道编号
    ,terminal_id varchar2(50) -- 交易终端编号
    ,trace_id varchar2(200) -- 跟踪id
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_note varchar2(1000) -- 交易附言
    ,tran_status varchar2(1) -- 冲补抹标志
    ,tran_category varchar2(5) -- 交易种类
    ,effect_date date -- 产品生效日期
    ,reversal_date date -- 冲正日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,actual_bal number(17,2) -- 实际余额
    ,appr_user_id varchar2(8) -- 复核柜员
    ,auth_user_id varchar2(8) -- 授权柜员
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_bank_code varchar2(20) -- 对方银行代码
    ,oth_bank_name varchar2(400) -- 对方银行名称
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_branch varchar2(20) -- 对方账户开户机构
    ,oth_internal_key number(15) -- 对手账户内部键
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,oth_reference varchar2(50) -- 对方交易参考号
    ,previous_bal_amt number(17,2) -- 交易前余额
    ,tran_amt number(17,2) -- 交易金额
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
grant select on ${iol_schema}.ncbs_rb_appr_letter_tran_hist to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_appr_letter_tran_hist to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_appr_letter_tran_hist to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_appr_letter_tran_hist to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_appr_letter_tran_hist is '核准件交易流水表';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.branch is '机构编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.gl_code is '科目代码';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.acct_desc is '账户描述';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.appr_letter_no is '核准件编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.appr_type is '核准件类型';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.cash_item is '现金项目';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.company is '法人';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.cr_dr_maint_ind is '借贷标识';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_acct_desc is '对方账户描述';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_seq_no is '对方交易流水号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.priority is '优先级';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.reversal_tran_type is '冲正交易类型';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.serv_charge is '服务费标识';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.terminal_id is '交易终端编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.trace_id is '跟踪id';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.tran_note is '交易附言';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.tran_category is '交易种类';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.reversal_date is '冲正日期';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.actual_bal is '实际余额';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.appr_user_id is '复核柜员';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.auth_user_id is '授权柜员';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_bank_code is '对方银行代码';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_bank_name is '对方银行名称';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_branch is '对方账户开户机构';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.oth_reference is '对方交易参考号';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.previous_bal_amt is '交易前余额';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_appr_letter_tran_hist.etl_timestamp is 'ETL处理时间戳';
