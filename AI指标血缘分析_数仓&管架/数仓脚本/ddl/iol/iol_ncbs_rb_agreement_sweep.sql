/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_sweep
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_sweep
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_sweep purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_sweep(
    acct_name varchar2(200) -- 账户名称
    ,acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,internal_key number(15) -- 账户内部键值
    ,prod_type varchar2(12) -- 产品编号
    ,reason_code varchar2(10) -- 账户用途
    ,user_id varchar2(8) -- 交易柜员编号
    ,term varchar2(5) -- 存期
    ,term_type varchar2(1) -- 期限单位
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_status varchar2(2) -- 协议状态
    ,agreement_type varchar2(5) -- 协议类型
    ,auto_settle_flag varchar2(1) -- 自动结清标志
    ,company varchar2(20) -- 法人
    ,con_transfer_count number(5) -- 持续划款次数
    ,narrative varchar2(400) -- 摘要
    ,oth_acct_desc varchar2(600) -- 对方账户描述
    ,oth_acct_sort varchar2(3) -- 转入方账户类型
    ,priority varchar2(20) -- 优先级
    ,renew_method varchar2(1) -- 转存方式
    ,renew_multiple number(5) -- 转账倍数
    ,renew_type varchar2(3) -- 约定转存方式
    ,sched_no varchar2(50) -- 计划编号
    ,seq_no varchar2(50) -- 序号
    ,sum_con_count number(5) -- 累计追踪次数
    ,sum_count number(5) -- 累计转账次数
    ,lowest_amt number(17,2) -- 保底金额
    ,end_date date -- 结束日期
    ,sign_date date -- 签约日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,acct_fixed_rate number(15,8) -- 分户级固定利率
    ,acct_percent_rate number(11,7) -- 分户级利率浮动百分比
    ,acct_spread_rate number(15,8) -- 分户级利率浮动百分点
    ,bal_ratio number(11,7) -- 余额比例
    ,limit_amt_out_day number(17,2) -- 出账日累计限额
    ,month_limit number(17,2) -- 本月累计限额
    ,oth_acct_ccy varchar2(3) -- 对方账户币种
    ,oth_acct_seq_no varchar2(5) -- 对方账户序列号
    ,oth_bank_code varchar2(20) -- 对方银行代码
    ,oth_base_acct_no varchar2(50) -- 对方账号/卡号
    ,oth_internal_key number(15) -- 对手账户内部键
    ,oth_prod_type varchar2(12) -- 对方账户产品类型
    ,priint_acct_seq_no varchar2(5) -- 本息入账账户序列号
    ,priint_base_acct_no varchar2(50) -- 本息入账账号
    ,priint_ccy varchar2(3) -- 本息入账账户币种
    ,priint_prod_type varchar2(12) -- 本息入账账户产品类型
    ,renew_min_amt number(17,2) -- 最低转存金额
    ,settle_acct_ccy varchar2(3) -- 结算账户币种
    ,settle_acct_seq_no varchar2(5) -- 结算账户序号
    ,settle_base_acct_no varchar2(50) -- 结算账号
    ,settle_prod_type varchar2(12) -- 结算账户产品类型
    ,sum_amt number(17,2) -- 累计转账金额
    ,tran_base_amt number(17,2) -- 转账基数
    ,tran_amt number(17,2) -- 交易金额
    ,renew_acct_type varchar2(1) -- 转存账户类型
    ,fin_fixed_amt number(17,2) -- 理财固定金额
    ,open_num_type varchar2(1) -- 开立笔数类型
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
grant select on ${iol_schema}.ncbs_rb_agreement_sweep to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_sweep to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_sweep to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_sweep to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_sweep is '账户约定转账协议表';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.acct_name is '账户名称';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.internal_key is '账户内部键值';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.reason_code is '账户用途';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.user_id is '交易柜员编号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.term is '存期';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.term_type is '期限单位';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.auto_settle_flag is '自动结清标志';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.con_transfer_count is '持续划款次数';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.narrative is '摘要';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.oth_acct_desc is '对方账户描述';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.oth_acct_sort is '转入方账户类型';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.priority is '优先级';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.renew_method is '转存方式';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.renew_multiple is '转账倍数';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.renew_type is '约定转存方式';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.sched_no is '计划编号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.seq_no is '序号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.sum_con_count is '累计追踪次数';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.sum_count is '累计转账次数';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.lowest_amt is '保底金额';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.sign_date is '签约日期';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.acct_fixed_rate is '分户级固定利率';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.acct_percent_rate is '分户级利率浮动百分比';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.acct_spread_rate is '分户级利率浮动百分点';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.bal_ratio is '余额比例';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.limit_amt_out_day is '出账日累计限额';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.month_limit is '本月累计限额';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.oth_acct_ccy is '对方账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.oth_acct_seq_no is '对方账户序列号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.oth_bank_code is '对方银行代码';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.oth_base_acct_no is '对方账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.oth_internal_key is '对手账户内部键';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.oth_prod_type is '对方账户产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.priint_acct_seq_no is '本息入账账户序列号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.priint_base_acct_no is '本息入账账号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.priint_ccy is '本息入账账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.priint_prod_type is '本息入账账户产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.renew_min_amt is '最低转存金额';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.settle_acct_ccy is '结算账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.settle_acct_seq_no is '结算账户序号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.settle_base_acct_no is '结算账号';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.settle_prod_type is '结算账户产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.sum_amt is '累计转账金额';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.tran_base_amt is '转账基数';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.tran_amt is '交易金额';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.renew_acct_type is '转存账户类型';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.fin_fixed_amt is '理财固定金额';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.open_num_type is '开立笔数类型';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_sweep.etl_timestamp is 'ETL处理时间戳';
