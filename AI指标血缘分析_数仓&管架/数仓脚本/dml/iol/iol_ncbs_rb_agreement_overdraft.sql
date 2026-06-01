/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_agreement_overdraft
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.ncbs_rb_agreement_overdraft_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_agreement_overdraft
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_overdraft_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_overdraft_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_agreement_overdraft_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_overdraft where 0=1;

create table ${iol_schema}.ncbs_rb_agreement_overdraft_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_agreement_overdraft where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_overdraft_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,fee_taken_mode -- 贷款手续费收取方式
            ,od_method -- 透支方式
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,fee_rate -- 费率
            ,loan_acct_ccy -- 贷款账户币种
            ,loan_base_acct_no -- 透支签约贷款账户编号
            ,loan_internal_key -- 贷款账户key值
            ,loan_prod_type -- 贷款产品类型
            ,loan_seq_no -- 贷款账户序列号
            ,od_amt -- 透支额度
            ,od_ccy -- 透支币种
            ,od_grace_period -- 透支免息期
            ,od_term -- 透支期限
            ,od_term_type -- 透支期限类型
            ,charge_day -- 收费日|收费日
            ,charge_period_freq -- 收费频率|收费频率
            ,cross_period_rate -- 跨月/季利率|靠当利率中的跨月/季利率，与跨月季标志同时存在
            ,fee_charge_type -- 费用收取方式|费用收取方式|T-转账 ,C-现金 ,F-暂不收费
            ,fee_percent -- 收费比例|收费比例
            ,is_over_month_season_od -- 靠档是否跨月/季|透支是否跨月/季
            ,od_maturity_rule -- 法透到期日计算规则|每笔法透放款的到期日计算规则|1-不跨月,2-不跨季,3-普通法透
            ,od_pay_method -- 透支还款方式|透支还款方式|0-到期自动还本,1-提前自动还本及结清
            ,od_start_amt -- 起透金额|起透金额
            ,profit_amortize_flag -- 是否需要摊销|是否需要摊销|Y-是,N-否
            ,white_client_name -- 白名单客户信息串|白名单客户信息串
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,amortize_period_freq -- 摊销频率
            ,amortize_time_type -- 摊销时间类型 F-期初,L-期末,D-周期内固定日期
            ,remark -- 备注
            ,od_mode -- 透支模式|透支模式
            ,fee_type -- 费率类型|费率类型
            ,int_basis_rate -- 基准利率|基准利率
            ,real_rate -- 执行利率|执行利率
            ,past_due_rate -- 逾期利率
            ,email_box -- 
            ,gear_prod_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_overdraft_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,fee_taken_mode -- 贷款手续费收取方式
            ,od_method -- 透支方式
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,fee_rate -- 费率
            ,loan_acct_ccy -- 贷款账户币种
            ,loan_base_acct_no -- 透支签约贷款账户编号
            ,loan_internal_key -- 贷款账户key值
            ,loan_prod_type -- 贷款产品类型
            ,loan_seq_no -- 贷款账户序列号
            ,od_amt -- 透支额度
            ,od_ccy -- 透支币种
            ,od_grace_period -- 透支免息期
            ,od_term -- 透支期限
            ,od_term_type -- 透支期限类型
            ,charge_day -- 收费日|收费日
            ,charge_period_freq -- 收费频率|收费频率
            ,cross_period_rate -- 跨月/季利率|靠当利率中的跨月/季利率，与跨月季标志同时存在
            ,fee_charge_type -- 费用收取方式|费用收取方式|T-转账 ,C-现金 ,F-暂不收费
            ,fee_percent -- 收费比例|收费比例
            ,is_over_month_season_od -- 靠档是否跨月/季|透支是否跨月/季
            ,od_maturity_rule -- 法透到期日计算规则|每笔法透放款的到期日计算规则|1-不跨月,2-不跨季,3-普通法透
            ,od_pay_method -- 透支还款方式|透支还款方式|0-到期自动还本,1-提前自动还本及结清
            ,od_start_amt -- 起透金额|起透金额
            ,profit_amortize_flag -- 是否需要摊销|是否需要摊销|Y-是,N-否
            ,white_client_name -- 白名单客户信息串|白名单客户信息串
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,amortize_period_freq -- 摊销频率
            ,amortize_time_type -- 摊销时间类型 F-期初,L-期末,D-周期内固定日期
            ,remark -- 备注
            ,od_mode -- 透支模式|透支模式
            ,fee_type -- 费率类型|费率类型
            ,int_basis_rate -- 基准利率|基准利率
            ,real_rate -- 执行利率|执行利率
            ,past_due_rate -- 逾期利率
            ,email_box -- 
            ,gear_prod_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_seq_no, o.acct_seq_no) as acct_seq_no -- 账户子账号
    ,nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.prod_type, o.prod_type) as prod_type -- 产品编号
    ,nvl(n.agreement_id, o.agreement_id) as agreement_id -- 协议编号
    ,nvl(n.agreement_status, o.agreement_status) as agreement_status -- 协议状态
    ,nvl(n.agreement_type, o.agreement_type) as agreement_type -- 协议类型
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.fee_taken_mode, o.fee_taken_mode) as fee_taken_mode -- 贷款手续费收取方式
    ,nvl(n.od_method, o.od_method) as od_method -- 透支方式
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.acct_ccy, o.acct_ccy) as acct_ccy -- 账户币种
    ,nvl(n.fee_rate, o.fee_rate) as fee_rate -- 费率
    ,nvl(n.loan_acct_ccy, o.loan_acct_ccy) as loan_acct_ccy -- 贷款账户币种
    ,nvl(n.loan_base_acct_no, o.loan_base_acct_no) as loan_base_acct_no -- 透支签约贷款账户编号
    ,nvl(n.loan_internal_key, o.loan_internal_key) as loan_internal_key -- 贷款账户key值
    ,nvl(n.loan_prod_type, o.loan_prod_type) as loan_prod_type -- 贷款产品类型
    ,nvl(n.loan_seq_no, o.loan_seq_no) as loan_seq_no -- 贷款账户序列号
    ,nvl(n.od_amt, o.od_amt) as od_amt -- 透支额度
    ,nvl(n.od_ccy, o.od_ccy) as od_ccy -- 透支币种
    ,nvl(n.od_grace_period, o.od_grace_period) as od_grace_period -- 透支免息期
    ,nvl(n.od_term, o.od_term) as od_term -- 透支期限
    ,nvl(n.od_term_type, o.od_term_type) as od_term_type -- 透支期限类型
    ,nvl(n.charge_day, o.charge_day) as charge_day -- 收费日|收费日
    ,nvl(n.charge_period_freq, o.charge_period_freq) as charge_period_freq -- 收费频率|收费频率
    ,nvl(n.cross_period_rate, o.cross_period_rate) as cross_period_rate -- 跨月/季利率|靠当利率中的跨月/季利率，与跨月季标志同时存在
    ,nvl(n.fee_charge_type, o.fee_charge_type) as fee_charge_type -- 费用收取方式|费用收取方式|T-转账 ,C-现金 ,F-暂不收费
    ,nvl(n.fee_percent, o.fee_percent) as fee_percent -- 收费比例|收费比例
    ,nvl(n.is_over_month_season_od, o.is_over_month_season_od) as is_over_month_season_od -- 靠档是否跨月/季|透支是否跨月/季
    ,nvl(n.od_maturity_rule, o.od_maturity_rule) as od_maturity_rule -- 法透到期日计算规则|每笔法透放款的到期日计算规则|1-不跨月,2-不跨季,3-普通法透
    ,nvl(n.od_pay_method, o.od_pay_method) as od_pay_method -- 透支还款方式|透支还款方式|0-到期自动还本,1-提前自动还本及结清
    ,nvl(n.od_start_amt, o.od_start_amt) as od_start_amt -- 起透金额|起透金额
    ,nvl(n.profit_amortize_flag, o.profit_amortize_flag) as profit_amortize_flag -- 是否需要摊销|是否需要摊销|Y-是,N-否
    ,nvl(n.white_client_name, o.white_client_name) as white_client_name -- 白名单客户信息串|白名单客户信息串
    ,nvl(n.amortize_day, o.amortize_day) as amortize_day -- 摊销日
    ,nvl(n.amortize_month, o.amortize_month) as amortize_month -- 摊销月
    ,nvl(n.amortize_period_freq, o.amortize_period_freq) as amortize_period_freq -- 摊销频率
    ,nvl(n.amortize_time_type, o.amortize_time_type) as amortize_time_type -- 摊销时间类型 F-期初,L-期末,D-周期内固定日期
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.od_mode, o.od_mode) as od_mode -- 透支模式|透支模式
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 费率类型|费率类型
    ,nvl(n.int_basis_rate, o.int_basis_rate) as int_basis_rate -- 基准利率|基准利率
    ,nvl(n.real_rate, o.real_rate) as real_rate -- 执行利率|执行利率
    ,nvl(n.past_due_rate, o.past_due_rate) as past_due_rate -- 逾期利率
    ,nvl(n.email_box, o.email_box) as email_box -- 
    ,nvl(n.gear_prod_flag, o.gear_prod_flag) as gear_prod_flag -- 
    ,case when
            n.agreement_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agreement_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agreement_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_agreement_overdraft_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_agreement_overdraft where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.agreement_id = n.agreement_id
where (
        o.agreement_id is null
    )
    or (
        n.agreement_id is null
    )
    or (
        o.acct_seq_no <> n.acct_seq_no
        or o.base_acct_no <> n.base_acct_no
        or o.client_no <> n.client_no
        or o.prod_type <> n.prod_type
        or o.agreement_status <> n.agreement_status
        or o.agreement_type <> n.agreement_type
        or o.company <> n.company
        or o.fee_taken_mode <> n.fee_taken_mode
        or o.od_method <> n.od_method
        or o.end_date <> n.end_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.acct_ccy <> n.acct_ccy
        or o.fee_rate <> n.fee_rate
        or o.loan_acct_ccy <> n.loan_acct_ccy
        or o.loan_base_acct_no <> n.loan_base_acct_no
        or o.loan_internal_key <> n.loan_internal_key
        or o.loan_prod_type <> n.loan_prod_type
        or o.loan_seq_no <> n.loan_seq_no
        or o.od_amt <> n.od_amt
        or o.od_ccy <> n.od_ccy
        or o.od_grace_period <> n.od_grace_period
        or o.od_term <> n.od_term
        or o.od_term_type <> n.od_term_type
        or o.charge_day <> n.charge_day
        or o.charge_period_freq <> n.charge_period_freq
        or o.cross_period_rate <> n.cross_period_rate
        or o.fee_charge_type <> n.fee_charge_type
        or o.fee_percent <> n.fee_percent
        or o.is_over_month_season_od <> n.is_over_month_season_od
        or o.od_maturity_rule <> n.od_maturity_rule
        or o.od_pay_method <> n.od_pay_method
        or o.od_start_amt <> n.od_start_amt
        or o.profit_amortize_flag <> n.profit_amortize_flag
        or o.white_client_name <> n.white_client_name
        or o.amortize_day <> n.amortize_day
        or o.amortize_month <> n.amortize_month
        or o.amortize_period_freq <> n.amortize_period_freq
        or o.amortize_time_type <> n.amortize_time_type
        or o.remark <> n.remark
        or o.od_mode <> n.od_mode
        or o.fee_type <> n.fee_type
        or o.int_basis_rate <> n.int_basis_rate
        or o.real_rate <> n.real_rate
        or o.past_due_rate <> n.past_due_rate
        or o.email_box <> n.email_box
        or o.gear_prod_flag <> n.gear_prod_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_agreement_overdraft_cl(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,fee_taken_mode -- 贷款手续费收取方式
            ,od_method -- 透支方式
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,fee_rate -- 费率
            ,loan_acct_ccy -- 贷款账户币种
            ,loan_base_acct_no -- 透支签约贷款账户编号
            ,loan_internal_key -- 贷款账户key值
            ,loan_prod_type -- 贷款产品类型
            ,loan_seq_no -- 贷款账户序列号
            ,od_amt -- 透支额度
            ,od_ccy -- 透支币种
            ,od_grace_period -- 透支免息期
            ,od_term -- 透支期限
            ,od_term_type -- 透支期限类型
            ,charge_day -- 收费日|收费日
            ,charge_period_freq -- 收费频率|收费频率
            ,cross_period_rate -- 跨月/季利率|靠当利率中的跨月/季利率，与跨月季标志同时存在
            ,fee_charge_type -- 费用收取方式|费用收取方式|T-转账 ,C-现金 ,F-暂不收费
            ,fee_percent -- 收费比例|收费比例
            ,is_over_month_season_od -- 靠档是否跨月/季|透支是否跨月/季
            ,od_maturity_rule -- 法透到期日计算规则|每笔法透放款的到期日计算规则|1-不跨月,2-不跨季,3-普通法透
            ,od_pay_method -- 透支还款方式|透支还款方式|0-到期自动还本,1-提前自动还本及结清
            ,od_start_amt -- 起透金额|起透金额
            ,profit_amortize_flag -- 是否需要摊销|是否需要摊销|Y-是,N-否
            ,white_client_name -- 白名单客户信息串|白名单客户信息串
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,amortize_period_freq -- 摊销频率
            ,amortize_time_type -- 摊销时间类型 F-期初,L-期末,D-周期内固定日期
            ,remark -- 备注
            ,od_mode -- 透支模式|透支模式
            ,fee_type -- 费率类型|费率类型
            ,int_basis_rate -- 基准利率|基准利率
            ,real_rate -- 执行利率|执行利率
            ,past_due_rate -- 逾期利率
            ,email_box -- 
            ,gear_prod_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_agreement_overdraft_op(
            acct_seq_no -- 账户子账号
            ,base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,prod_type -- 产品编号
            ,agreement_id -- 协议编号
            ,agreement_status -- 协议状态
            ,agreement_type -- 协议类型
            ,company -- 法人
            ,fee_taken_mode -- 贷款手续费收取方式
            ,od_method -- 透支方式
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,acct_ccy -- 账户币种
            ,fee_rate -- 费率
            ,loan_acct_ccy -- 贷款账户币种
            ,loan_base_acct_no -- 透支签约贷款账户编号
            ,loan_internal_key -- 贷款账户key值
            ,loan_prod_type -- 贷款产品类型
            ,loan_seq_no -- 贷款账户序列号
            ,od_amt -- 透支额度
            ,od_ccy -- 透支币种
            ,od_grace_period -- 透支免息期
            ,od_term -- 透支期限
            ,od_term_type -- 透支期限类型
            ,charge_day -- 收费日|收费日
            ,charge_period_freq -- 收费频率|收费频率
            ,cross_period_rate -- 跨月/季利率|靠当利率中的跨月/季利率，与跨月季标志同时存在
            ,fee_charge_type -- 费用收取方式|费用收取方式|T-转账 ,C-现金 ,F-暂不收费
            ,fee_percent -- 收费比例|收费比例
            ,is_over_month_season_od -- 靠档是否跨月/季|透支是否跨月/季
            ,od_maturity_rule -- 法透到期日计算规则|每笔法透放款的到期日计算规则|1-不跨月,2-不跨季,3-普通法透
            ,od_pay_method -- 透支还款方式|透支还款方式|0-到期自动还本,1-提前自动还本及结清
            ,od_start_amt -- 起透金额|起透金额
            ,profit_amortize_flag -- 是否需要摊销|是否需要摊销|Y-是,N-否
            ,white_client_name -- 白名单客户信息串|白名单客户信息串
            ,amortize_day -- 摊销日
            ,amortize_month -- 摊销月
            ,amortize_period_freq -- 摊销频率
            ,amortize_time_type -- 摊销时间类型 F-期初,L-期末,D-周期内固定日期
            ,remark -- 备注
            ,od_mode -- 透支模式|透支模式
            ,fee_type -- 费率类型|费率类型
            ,int_basis_rate -- 基准利率|基准利率
            ,real_rate -- 执行利率|执行利率
            ,past_due_rate -- 逾期利率
            ,email_box -- 
            ,gear_prod_flag -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_seq_no -- 账户子账号
    ,o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.prod_type -- 产品编号
    ,o.agreement_id -- 协议编号
    ,o.agreement_status -- 协议状态
    ,o.agreement_type -- 协议类型
    ,o.company -- 法人
    ,o.fee_taken_mode -- 贷款手续费收取方式
    ,o.od_method -- 透支方式
    ,o.end_date -- 结束日期
    ,o.start_date -- 开始日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.acct_ccy -- 账户币种
    ,o.fee_rate -- 费率
    ,o.loan_acct_ccy -- 贷款账户币种
    ,o.loan_base_acct_no -- 透支签约贷款账户编号
    ,o.loan_internal_key -- 贷款账户key值
    ,o.loan_prod_type -- 贷款产品类型
    ,o.loan_seq_no -- 贷款账户序列号
    ,o.od_amt -- 透支额度
    ,o.od_ccy -- 透支币种
    ,o.od_grace_period -- 透支免息期
    ,o.od_term -- 透支期限
    ,o.od_term_type -- 透支期限类型
    ,o.charge_day -- 收费日|收费日
    ,o.charge_period_freq -- 收费频率|收费频率
    ,o.cross_period_rate -- 跨月/季利率|靠当利率中的跨月/季利率，与跨月季标志同时存在
    ,o.fee_charge_type -- 费用收取方式|费用收取方式|T-转账 ,C-现金 ,F-暂不收费
    ,o.fee_percent -- 收费比例|收费比例
    ,o.is_over_month_season_od -- 靠档是否跨月/季|透支是否跨月/季
    ,o.od_maturity_rule -- 法透到期日计算规则|每笔法透放款的到期日计算规则|1-不跨月,2-不跨季,3-普通法透
    ,o.od_pay_method -- 透支还款方式|透支还款方式|0-到期自动还本,1-提前自动还本及结清
    ,o.od_start_amt -- 起透金额|起透金额
    ,o.profit_amortize_flag -- 是否需要摊销|是否需要摊销|Y-是,N-否
    ,o.white_client_name -- 白名单客户信息串|白名单客户信息串
    ,o.amortize_day -- 摊销日
    ,o.amortize_month -- 摊销月
    ,o.amortize_period_freq -- 摊销频率
    ,o.amortize_time_type -- 摊销时间类型 F-期初,L-期末,D-周期内固定日期
    ,o.remark -- 备注
    ,o.od_mode -- 透支模式|透支模式
    ,o.fee_type -- 费率类型|费率类型
    ,o.int_basis_rate -- 基准利率|基准利率
    ,o.real_rate -- 执行利率|执行利率
    ,o.past_due_rate -- 逾期利率
    ,o.email_box -- 
    ,o.gear_prod_flag -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.ncbs_rb_agreement_overdraft_bk o
    left join ${iol_schema}.ncbs_rb_agreement_overdraft_op n
        on
            o.agreement_id = n.agreement_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_agreement_overdraft_cl d
        on
            o.agreement_id = d.agreement_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_agreement_overdraft;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_agreement_overdraft') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_agreement_overdraft drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_agreement_overdraft add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_agreement_overdraft exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_agreement_overdraft_cl;
alter table ${iol_schema}.ncbs_rb_agreement_overdraft exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_agreement_overdraft_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_agreement_overdraft to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_agreement_overdraft_op purge;
drop table ${iol_schema}.ncbs_rb_agreement_overdraft_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_agreement_overdraft_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_agreement_overdraft',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
