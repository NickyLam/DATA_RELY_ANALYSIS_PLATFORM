/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_tran_hist_pbk
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_tran_hist_pbk
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_tran_hist_pbk purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_tran_hist_pbk(
    acct_seq_no varchar2(5) -- 账户子账号
    ,amt_type varchar2(10) -- 金额类型
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,ccy varchar2(3) -- 币种
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reference varchar2(50) -- 交易参考号
    ,tran_type varchar2(10) -- 交易类型
    ,user_id varchar2(8) -- 交易柜员编号
    ,acct_class varchar2(1) -- 账户等级
    ,acct_desc varchar2(200) -- 账户描述
    ,amt_calc_type varchar2(1) -- 金额计算类型
    ,auto_reversal_flag varchar2(1) -- 自动冲正标志
    ,bal_type varchar2(2) -- 余额类型
    ,bank_seq_no varchar2(50) -- 银行交易序号
    ,batch_no varchar2(50) -- 批次号
    ,biz_type varchar2(10) -- 中间业务类型
    ,cash_item varchar2(10) -- 现金项目
    ,channel_seq_no varchar2(33) -- 全局流水号
    ,company varchar2(20) -- 法人
    ,cr_dr_ind varchar2(1) -- 借贷标志
    ,event_type varchar2(20) -- 事件类型
    ,fin_type varchar2(10) -- 理财类型
    ,from_rate_flag varchar2(1) -- 买方交易汇率标志
    ,lender varchar2(100) -- 贷款人
    ,medium_flag varchar2(1) -- 介质标志
    ,medium_type varchar2(1) -- 存款介质类型
    ,narrative varchar2(400) -- 摘要
    ,pbk_upd_flag varchar2(1) -- 是否补登存
    ,primary_event_type varchar2(5) -- 主事件类型
    ,print_cnt number(5) -- 打印次数
    ,program_id varchar2(20) -- 交易代码
    ,quote_type varchar2(1) -- 牌价类型
    ,rate_type varchar2(10) -- 汇率类型
    ,receipt_no varchar2(50) -- 回收号
    ,reversal varchar2(1) -- 是否冲正标志
    ,reversal_seq_no varchar2(50) -- 冲正流水号
    ,reversal_tran_type varchar2(10) -- 冲正交易类型
    ,seq_no varchar2(50) -- 序号
    ,source_type varchar2(6) -- 渠道编号
    ,sub_seq_no varchar2(100) -- 系统流水号
    ,system_code varchar2(30) -- 来源系统编号
    ,tae_sub_seq_no varchar2(200) -- tae子流水序号
    ,to_rate_flag varchar2(1) -- 卖方交易汇率标志
    ,trace_id varchar2(200) -- 跟踪id
    ,tran_desc varchar2(200) -- 交易描述
    ,tran_note varchar2(1000) -- 交易附言
    ,tran_status varchar2(1) -- 冲补抹标志
    ,tran_category varchar2(5) -- 交易种类
    ,effect_date date -- 产品生效日期
    ,orig_tran_timestamp varchar2(26) -- 原始交易时间戳
    ,reversal_tran_date date -- 冲正交易日期
    ,settlement_date date -- 清算日期
    ,tran_date date -- 交易日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_branch varchar2(12) -- 开户机构编号
    ,acct_ccy varchar2(3) -- 账户币种
    ,actual_bal number(17,2) -- 实际余额
    ,actual_bal_amt_fin number(17,2) -- 交易后余额加理财
    ,base_equiv_amt number(17,2) -- 基础等值金额
    ,contra_equiv_amt number(17,2) -- 对方等值金额
    ,cross_rate number(15,8) -- 交叉汇率
    ,from_amount number(17,2) -- 移出金额
    ,from_xrate number(15,8) -- 买方汇率值
    ,ov_cross_rate number(15,8) -- 实际交易时修改交叉汇率
    ,ov_to_amount number(17,2) -- 根据实际交易时修改交叉汇率计算的金额
    ,previous_bal_amt number(17,2) -- 交易前余额
    ,to_amount number(17,2) -- 移入金额
    ,to_xrate number(15,8) -- 卖方汇率值
    ,tran_amt number(17,2) -- 交易金额
    ,tran_branch varchar2(12) -- 核心交易机构编号
    ,tran_method varchar2(2) -- 到账方式
    ,flat_rate number(15,8) -- 平盘汇率
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
grant select on ${iol_schema}.ncbs_rb_tran_hist_pbk to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_tran_hist_pbk to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_hist_pbk to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_tran_hist_pbk to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_tran_hist_pbk is '存折类账户交易流水专用表';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.amt_type is '金额类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.ccy is '币种';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.reference is '交易参考号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tran_type is '交易类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.acct_class is '账户等级';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.acct_desc is '账户描述';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.amt_calc_type is '金额计算类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.auto_reversal_flag is '自动冲正标志';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.bal_type is '余额类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.bank_seq_no is '银行交易序号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.batch_no is '批次号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.biz_type is '中间业务类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.cash_item is '现金项目';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.channel_seq_no is '全局流水号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.company is '法人';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.cr_dr_ind is '借贷标志';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.event_type is '事件类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.fin_type is '理财类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.from_rate_flag is '买方交易汇率标志';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.lender is '贷款人';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.medium_flag is '介质标志';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.medium_type is '存款介质类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.pbk_upd_flag is '是否补登存';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.primary_event_type is '主事件类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.print_cnt is '打印次数';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.program_id is '交易代码';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.quote_type is '牌价类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.rate_type is '汇率类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.receipt_no is '回收号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.reversal is '是否冲正标志';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.reversal_seq_no is '冲正流水号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.reversal_tran_type is '冲正交易类型';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.source_type is '渠道编号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.sub_seq_no is '系统流水号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.system_code is '来源系统编号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tae_sub_seq_no is 'tae子流水序号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.to_rate_flag is '卖方交易汇率标志';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.trace_id is '跟踪id';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tran_desc is '交易描述';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tran_note is '交易附言';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tran_status is '冲补抹标志';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tran_category is '交易种类';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.effect_date is '产品生效日期';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.orig_tran_timestamp is '原始交易时间戳';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.reversal_tran_date is '冲正交易日期';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.settlement_date is '清算日期';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tran_date is '交易日期';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.acct_branch is '开户机构编号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.actual_bal is '实际余额';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.actual_bal_amt_fin is '交易后余额加理财';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.base_equiv_amt is '基础等值金额';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.contra_equiv_amt is '对方等值金额';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.cross_rate is '交叉汇率';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.from_amount is '移出金额';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.from_xrate is '买方汇率值';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.ov_cross_rate is '实际交易时修改交叉汇率';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.ov_to_amount is '根据实际交易时修改交叉汇率计算的金额';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.previous_bal_amt is '交易前余额';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.to_amount is '移入金额';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.to_xrate is '卖方汇率值';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tran_branch is '核心交易机构编号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.tran_method is '到账方式';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.flat_rate is '平盘汇率';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.reaccount_cd is '对账代码';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.bus_seq_no is '业务流水号';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ncbs_rb_tran_hist_pbk.etl_timestamp is 'ETL处理时间戳';
