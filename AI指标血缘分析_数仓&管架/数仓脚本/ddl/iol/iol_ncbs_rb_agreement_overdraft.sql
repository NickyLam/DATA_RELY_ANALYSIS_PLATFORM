/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ncbs_rb_agreement_overdraft
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ncbs_rb_agreement_overdraft
whenever sqlerror continue none;
drop table ${iol_schema}.ncbs_rb_agreement_overdraft purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_overdraft(
    acct_seq_no varchar2(5) -- 账户子账号
    ,base_acct_no varchar2(50) -- 交易账号/卡号
    ,client_no varchar2(16) -- 客户编号
    ,prod_type varchar2(12) -- 产品编号
    ,agreement_id varchar2(50) -- 协议编号
    ,agreement_status varchar2(2) -- 协议状态
    ,agreement_type varchar2(5) -- 协议类型
    ,company varchar2(20) -- 法人
    ,fee_taken_mode varchar2(1) -- 贷款手续费收取方式
    ,od_method varchar2(2) -- 透支方式
    ,end_date date -- 结束日期
    ,start_date date -- 开始日期
    ,tran_timestamp varchar2(26) -- 交易时间戳
    ,acct_ccy varchar2(3) -- 账户币种
    ,fee_rate number(15,8) -- 费率
    ,loan_acct_ccy varchar2(3) -- 贷款账户币种
    ,loan_base_acct_no varchar2(50) -- 透支签约贷款账户编号
    ,loan_internal_key number(15) -- 贷款账户key值
    ,loan_prod_type varchar2(12) -- 贷款产品类型
    ,loan_seq_no varchar2(5) -- 贷款账户序列号
    ,od_amt number(17,2) -- 透支额度
    ,od_ccy varchar2(3) -- 透支币种
    ,od_grace_period varchar2(5) -- 透支免息期
    ,od_term varchar2(5) -- 透支期限
    ,od_term_type varchar2(1) -- 透支期限类型
    ,charge_day varchar2(2) -- 收费日|收费日
    ,charge_period_freq varchar2(5) -- 收费频率|收费频率
    ,cross_period_rate number(15,8) -- 跨月/季利率|靠当利率中的跨月/季利率，与跨月季标志同时存在
    ,fee_charge_type varchar2(1) -- 费用收取方式|费用收取方式|T-转账 ,C-现金 ,F-暂不收费
    ,fee_percent number(5,2) -- 收费比例|收费比例
    ,is_over_month_season_od varchar2(1) -- 靠档是否跨月/季|透支是否跨月/季
    ,od_maturity_rule varchar2(1) -- 法透到期日计算规则|每笔法透放款的到期日计算规则|1-不跨月,2-不跨季,3-普通法透
    ,od_pay_method varchar2(1) -- 透支还款方式|透支还款方式|0-到期自动还本,1-提前自动还本及结清
    ,od_start_amt number(17,2) -- 起透金额|起透金额
    ,profit_amortize_flag varchar2(1) -- 是否需要摊销|是否需要摊销|Y-是,N-否
    ,white_client_name varchar2(3000) -- 白名单客户信息串|白名单客户信息串
    ,amortize_day varchar2(2) -- 摊销日
    ,amortize_month varchar2(2) -- 摊销月
    ,amortize_period_freq varchar2(5) -- 摊销频率
    ,amortize_time_type varchar2(1) -- 摊销时间类型 F-期初,L-期末,D-周期内固定日期
    ,remark varchar2(600) -- 备注
    ,od_mode varchar2(1) -- 透支模式|透支模式
    ,fee_type varchar2(20) -- 费率类型|费率类型
    ,int_basis_rate number(15,8) -- 基准利率|基准利率
    ,real_rate number(15,8) -- 执行利率|执行利率
    ,past_due_rate number(15,8) -- 逾期利率
    ,email_box varchar2(3000) -- 
    ,gear_prod_flag varchar2(1) -- 
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
grant select on ${iol_schema}.ncbs_rb_agreement_overdraft to ${iml_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_overdraft to ${icl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_overdraft to ${idl_schema};
grant select on ${iol_schema}.ncbs_rb_agreement_overdraft to ${iel_schema};

-- comment
comment on table ${iol_schema}.ncbs_rb_agreement_overdraft is '透支签约表';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.acct_seq_no is '账户子账号';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.base_acct_no is '交易账号/卡号';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.client_no is '客户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.prod_type is '产品编号';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.agreement_id is '协议编号';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.agreement_status is '协议状态';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.agreement_type is '协议类型';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.company is '法人';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.fee_taken_mode is '贷款手续费收取方式';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.od_method is '透支方式';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.end_date is '结束日期';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.start_date is '开始日期';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.tran_timestamp is '交易时间戳';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.acct_ccy is '账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.fee_rate is '费率';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.loan_acct_ccy is '贷款账户币种';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.loan_base_acct_no is '透支签约贷款账户编号';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.loan_internal_key is '贷款账户key值';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.loan_prod_type is '贷款产品类型';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.loan_seq_no is '贷款账户序列号';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.od_amt is '透支额度';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.od_ccy is '透支币种';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.od_grace_period is '透支免息期';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.od_term is '透支期限';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.od_term_type is '透支期限类型';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.charge_day is '收费日|收费日';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.charge_period_freq is '收费频率|收费频率';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.cross_period_rate is '跨月/季利率|靠当利率中的跨月/季利率，与跨月季标志同时存在';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.fee_charge_type is '费用收取方式|费用收取方式|T-转账 ,C-现金 ,F-暂不收费';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.fee_percent is '收费比例|收费比例';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.is_over_month_season_od is '靠档是否跨月/季|透支是否跨月/季';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.od_maturity_rule is '法透到期日计算规则|每笔法透放款的到期日计算规则|1-不跨月,2-不跨季,3-普通法透';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.od_pay_method is '透支还款方式|透支还款方式|0-到期自动还本,1-提前自动还本及结清';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.od_start_amt is '起透金额|起透金额';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.profit_amortize_flag is '是否需要摊销|是否需要摊销|Y-是,N-否';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.white_client_name is '白名单客户信息串|白名单客户信息串';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.amortize_day is '摊销日';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.amortize_month is '摊销月';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.amortize_period_freq is '摊销频率';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.amortize_time_type is '摊销时间类型 F-期初,L-期末,D-周期内固定日期';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.remark is '备注';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.od_mode is '透支模式|透支模式';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.fee_type is '费率类型|费率类型';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.int_basis_rate is '基准利率|基准利率';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.real_rate is '执行利率|执行利率';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.past_due_rate is '逾期利率';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.email_box is '';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.gear_prod_flag is '';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.start_dt is '开始时间';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.end_dt is '结束时间';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.id_mark is '增删标志';
comment on column ${iol_schema}.ncbs_rb_agreement_overdraft.etl_timestamp is 'ETL处理时间戳';
