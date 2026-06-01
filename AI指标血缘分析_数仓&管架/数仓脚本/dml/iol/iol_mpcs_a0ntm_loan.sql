/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a0ntm_loan
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
create table ${iol_schema}.mpcs_a0ntm_loan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a0ntm_loan
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_loan_op purge;
drop table ${iol_schema}.mpcs_a0ntm_loan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_loan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ntm_loan where 0=1;

create table ${iol_schema}.mpcs_a0ntm_loan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a0ntm_loan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_loan_cl(
            org -- 机构号
            ,loan_id -- 借据ID
            ,acct_no -- 账户编号
            ,acct_type -- 账户类型
            ,ref_nbr -- 交易参考号
            ,logical_card_no -- 逻辑卡号
            ,card_no -- 卡号
            ,register_date -- 贷款注册日期
            ,request_time -- 请求日期时间
            ,loan_type -- 贷款类型
            ,loan_status -- 贷款状态
            ,last_loan_status -- 贷款上次状态
            ,loan_init_term -- 贷款总期数
            ,curr_term -- 当前期数
            ,remain_term -- 剩余期数
            ,loan_init_prin -- 贷款总本金
            ,loan_fixed_pmt_prin -- 贷款每期应还本金
            ,loan_first_term_prin -- 贷款首期应还本金
            ,loan_final_term_prin -- 贷款末期应还本金
            ,loan_init_fee1 -- 贷款总手续费
            ,loan_fixed_fee1 -- 贷款每期手续费
            ,loan_first_term_fee1 -- 贷款首期手续费
            ,loan_final_term_fee1 -- 贷款末期手续费
            ,unearned_prin -- 贷款账单的本金
            ,unearned_fee1 -- 贷款账单手续费
            ,paid_out_date -- 还清日期
            ,terminate_date -- 提前终止日期
            ,terminate_reason_cd -- 贷款终止原因代码
            ,prin_paid -- 已偿还本金
            ,int_paid -- 已偿还利息
            ,fee_paid -- 已偿还费用
            ,loan_curr_bal -- 贷款当前总余额
            ,loan_bal_xfrout -- 贷款未到期余额
            ,loan_bal_xfrin -- 贷款已到期余额
            ,loan_bal_principal -- 欠款总本金
            ,loan_bal_interest -- 欠款总利息
            ,loan_bal_penalty -- 欠款总罚息
            ,loan_prin_xfrout -- 贷款未到期本金
            ,loan_prin_xfrin -- 贷款已到期本金
            ,loan_fee1_xfrout -- 贷款未到期手续费
            ,loan_fee1_xfrin -- 贷款已到期手续费
            ,orig_txn_amt -- 原始交易币种金额
            ,orig_trans_date -- 原始交易日期
            ,orig_auth_code -- 原始交易授权码
            ,jpa_version -- 乐观锁版本号
            ,loan_code -- 贷款产品号
            ,register_id -- 贷款申请顺序号
            ,resch_init_prin -- 展期本金金额
            ,resch_date -- 展期生效日期
            ,bef_resch_fixed_pmt_prin -- 展期前每期应还本金
            ,bef_resch_init_term -- 展期前总期数
            ,bef_resch_first_term_prin -- 展期前贷款首期应还本金
            ,bef_resch_final_term_prin -- 展期前贷款末期应还本金
            ,bef_resch_init_fee1 -- 展期前贷款总手续费
            ,bef_resch_fixed_fee1 -- 贷款每期手续费
            ,bef_resch_first_term_fee1 -- 展期前贷款首期手续费
            ,bef_resch_final_term_fee1 -- 展期前贷款末期手续费
            ,resch_first_term_fee1 -- 展期后首期手续费
            ,loan_fee_method -- 贷款手续费收取方式
            ,interest_rate -- 基础利率
            ,penalty_rate -- 罚息利率
            ,compound_rate -- 复利利率
            ,float_rate -- 浮动比例
            ,loan_receipt_nbr -- 借据号
            ,loan_expire_date -- 贷款到期日期
            ,loan_cd -- 贷款逾期最大期数
            ,payment_hist -- 24个月还款状态
            ,ctd_payment_amt -- 当期还款额
            ,past_resch_cnt -- 已展期次数
            ,past_shorted_cnt -- 已缩期次数
            ,adv_pmt_amt -- 提前还款金额
            ,last_action_date -- 上次行动日期
            ,last_action_type -- 上次行动类型
            ,last_modified_datetime -- 修改时间
            ,activate_date -- 激活日期
            ,interest_calc_base -- 计息基数
            ,first_bill_date -- 首个到期还款日
            ,age_cd -- 账龄
            ,recalc_ind -- 利率重算标志
            ,recalc_date -- 利率重算日
            ,grace_date -- 宽限日期
            ,cancel_date -- 撤销日期
            ,cancel_reason -- 贷款撤销原因
            ,bank_group_id -- 银团编号
            ,due_days -- 当前逾期天数
            ,contract_ver -- 合同版本号
            ,loan_init_interest -- 贷款总利息
            ,bef_init_interest -- 原贷款总利息
            ,bank_proportion -- 银行出资比例
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,three_type_cd -- 资产三分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_loan_op(
            org -- 机构号
            ,loan_id -- 借据ID
            ,acct_no -- 账户编号
            ,acct_type -- 账户类型
            ,ref_nbr -- 交易参考号
            ,logical_card_no -- 逻辑卡号
            ,card_no -- 卡号
            ,register_date -- 贷款注册日期
            ,request_time -- 请求日期时间
            ,loan_type -- 贷款类型
            ,loan_status -- 贷款状态
            ,last_loan_status -- 贷款上次状态
            ,loan_init_term -- 贷款总期数
            ,curr_term -- 当前期数
            ,remain_term -- 剩余期数
            ,loan_init_prin -- 贷款总本金
            ,loan_fixed_pmt_prin -- 贷款每期应还本金
            ,loan_first_term_prin -- 贷款首期应还本金
            ,loan_final_term_prin -- 贷款末期应还本金
            ,loan_init_fee1 -- 贷款总手续费
            ,loan_fixed_fee1 -- 贷款每期手续费
            ,loan_first_term_fee1 -- 贷款首期手续费
            ,loan_final_term_fee1 -- 贷款末期手续费
            ,unearned_prin -- 贷款账单的本金
            ,unearned_fee1 -- 贷款账单手续费
            ,paid_out_date -- 还清日期
            ,terminate_date -- 提前终止日期
            ,terminate_reason_cd -- 贷款终止原因代码
            ,prin_paid -- 已偿还本金
            ,int_paid -- 已偿还利息
            ,fee_paid -- 已偿还费用
            ,loan_curr_bal -- 贷款当前总余额
            ,loan_bal_xfrout -- 贷款未到期余额
            ,loan_bal_xfrin -- 贷款已到期余额
            ,loan_bal_principal -- 欠款总本金
            ,loan_bal_interest -- 欠款总利息
            ,loan_bal_penalty -- 欠款总罚息
            ,loan_prin_xfrout -- 贷款未到期本金
            ,loan_prin_xfrin -- 贷款已到期本金
            ,loan_fee1_xfrout -- 贷款未到期手续费
            ,loan_fee1_xfrin -- 贷款已到期手续费
            ,orig_txn_amt -- 原始交易币种金额
            ,orig_trans_date -- 原始交易日期
            ,orig_auth_code -- 原始交易授权码
            ,jpa_version -- 乐观锁版本号
            ,loan_code -- 贷款产品号
            ,register_id -- 贷款申请顺序号
            ,resch_init_prin -- 展期本金金额
            ,resch_date -- 展期生效日期
            ,bef_resch_fixed_pmt_prin -- 展期前每期应还本金
            ,bef_resch_init_term -- 展期前总期数
            ,bef_resch_first_term_prin -- 展期前贷款首期应还本金
            ,bef_resch_final_term_prin -- 展期前贷款末期应还本金
            ,bef_resch_init_fee1 -- 展期前贷款总手续费
            ,bef_resch_fixed_fee1 -- 贷款每期手续费
            ,bef_resch_first_term_fee1 -- 展期前贷款首期手续费
            ,bef_resch_final_term_fee1 -- 展期前贷款末期手续费
            ,resch_first_term_fee1 -- 展期后首期手续费
            ,loan_fee_method -- 贷款手续费收取方式
            ,interest_rate -- 基础利率
            ,penalty_rate -- 罚息利率
            ,compound_rate -- 复利利率
            ,float_rate -- 浮动比例
            ,loan_receipt_nbr -- 借据号
            ,loan_expire_date -- 贷款到期日期
            ,loan_cd -- 贷款逾期最大期数
            ,payment_hist -- 24个月还款状态
            ,ctd_payment_amt -- 当期还款额
            ,past_resch_cnt -- 已展期次数
            ,past_shorted_cnt -- 已缩期次数
            ,adv_pmt_amt -- 提前还款金额
            ,last_action_date -- 上次行动日期
            ,last_action_type -- 上次行动类型
            ,last_modified_datetime -- 修改时间
            ,activate_date -- 激活日期
            ,interest_calc_base -- 计息基数
            ,first_bill_date -- 首个到期还款日
            ,age_cd -- 账龄
            ,recalc_ind -- 利率重算标志
            ,recalc_date -- 利率重算日
            ,grace_date -- 宽限日期
            ,cancel_date -- 撤销日期
            ,cancel_reason -- 贷款撤销原因
            ,bank_group_id -- 银团编号
            ,due_days -- 当前逾期天数
            ,contract_ver -- 合同版本号
            ,loan_init_interest -- 贷款总利息
            ,bef_init_interest -- 原贷款总利息
            ,bank_proportion -- 银行出资比例
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,three_type_cd -- 资产三分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.org, o.org) as org -- 机构号
    ,nvl(n.loan_id, o.loan_id) as loan_id -- 借据ID
    ,nvl(n.acct_no, o.acct_no) as acct_no -- 账户编号
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.ref_nbr, o.ref_nbr) as ref_nbr -- 交易参考号
    ,nvl(n.logical_card_no, o.logical_card_no) as logical_card_no -- 逻辑卡号
    ,nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.register_date, o.register_date) as register_date -- 贷款注册日期
    ,nvl(n.request_time, o.request_time) as request_time -- 请求日期时间
    ,nvl(n.loan_type, o.loan_type) as loan_type -- 贷款类型
    ,nvl(n.loan_status, o.loan_status) as loan_status -- 贷款状态
    ,nvl(n.last_loan_status, o.last_loan_status) as last_loan_status -- 贷款上次状态
    ,nvl(n.loan_init_term, o.loan_init_term) as loan_init_term -- 贷款总期数
    ,nvl(n.curr_term, o.curr_term) as curr_term -- 当前期数
    ,nvl(n.remain_term, o.remain_term) as remain_term -- 剩余期数
    ,nvl(n.loan_init_prin, o.loan_init_prin) as loan_init_prin -- 贷款总本金
    ,nvl(n.loan_fixed_pmt_prin, o.loan_fixed_pmt_prin) as loan_fixed_pmt_prin -- 贷款每期应还本金
    ,nvl(n.loan_first_term_prin, o.loan_first_term_prin) as loan_first_term_prin -- 贷款首期应还本金
    ,nvl(n.loan_final_term_prin, o.loan_final_term_prin) as loan_final_term_prin -- 贷款末期应还本金
    ,nvl(n.loan_init_fee1, o.loan_init_fee1) as loan_init_fee1 -- 贷款总手续费
    ,nvl(n.loan_fixed_fee1, o.loan_fixed_fee1) as loan_fixed_fee1 -- 贷款每期手续费
    ,nvl(n.loan_first_term_fee1, o.loan_first_term_fee1) as loan_first_term_fee1 -- 贷款首期手续费
    ,nvl(n.loan_final_term_fee1, o.loan_final_term_fee1) as loan_final_term_fee1 -- 贷款末期手续费
    ,nvl(n.unearned_prin, o.unearned_prin) as unearned_prin -- 贷款账单的本金
    ,nvl(n.unearned_fee1, o.unearned_fee1) as unearned_fee1 -- 贷款账单手续费
    ,nvl(n.paid_out_date, o.paid_out_date) as paid_out_date -- 还清日期
    ,nvl(n.terminate_date, o.terminate_date) as terminate_date -- 提前终止日期
    ,nvl(n.terminate_reason_cd, o.terminate_reason_cd) as terminate_reason_cd -- 贷款终止原因代码
    ,nvl(n.prin_paid, o.prin_paid) as prin_paid -- 已偿还本金
    ,nvl(n.int_paid, o.int_paid) as int_paid -- 已偿还利息
    ,nvl(n.fee_paid, o.fee_paid) as fee_paid -- 已偿还费用
    ,nvl(n.loan_curr_bal, o.loan_curr_bal) as loan_curr_bal -- 贷款当前总余额
    ,nvl(n.loan_bal_xfrout, o.loan_bal_xfrout) as loan_bal_xfrout -- 贷款未到期余额
    ,nvl(n.loan_bal_xfrin, o.loan_bal_xfrin) as loan_bal_xfrin -- 贷款已到期余额
    ,nvl(n.loan_bal_principal, o.loan_bal_principal) as loan_bal_principal -- 欠款总本金
    ,nvl(n.loan_bal_interest, o.loan_bal_interest) as loan_bal_interest -- 欠款总利息
    ,nvl(n.loan_bal_penalty, o.loan_bal_penalty) as loan_bal_penalty -- 欠款总罚息
    ,nvl(n.loan_prin_xfrout, o.loan_prin_xfrout) as loan_prin_xfrout -- 贷款未到期本金
    ,nvl(n.loan_prin_xfrin, o.loan_prin_xfrin) as loan_prin_xfrin -- 贷款已到期本金
    ,nvl(n.loan_fee1_xfrout, o.loan_fee1_xfrout) as loan_fee1_xfrout -- 贷款未到期手续费
    ,nvl(n.loan_fee1_xfrin, o.loan_fee1_xfrin) as loan_fee1_xfrin -- 贷款已到期手续费
    ,nvl(n.orig_txn_amt, o.orig_txn_amt) as orig_txn_amt -- 原始交易币种金额
    ,nvl(n.orig_trans_date, o.orig_trans_date) as orig_trans_date -- 原始交易日期
    ,nvl(n.orig_auth_code, o.orig_auth_code) as orig_auth_code -- 原始交易授权码
    ,nvl(n.jpa_version, o.jpa_version) as jpa_version -- 乐观锁版本号
    ,nvl(n.loan_code, o.loan_code) as loan_code -- 贷款产品号
    ,nvl(n.register_id, o.register_id) as register_id -- 贷款申请顺序号
    ,nvl(n.resch_init_prin, o.resch_init_prin) as resch_init_prin -- 展期本金金额
    ,nvl(n.resch_date, o.resch_date) as resch_date -- 展期生效日期
    ,nvl(n.bef_resch_fixed_pmt_prin, o.bef_resch_fixed_pmt_prin) as bef_resch_fixed_pmt_prin -- 展期前每期应还本金
    ,nvl(n.bef_resch_init_term, o.bef_resch_init_term) as bef_resch_init_term -- 展期前总期数
    ,nvl(n.bef_resch_first_term_prin, o.bef_resch_first_term_prin) as bef_resch_first_term_prin -- 展期前贷款首期应还本金
    ,nvl(n.bef_resch_final_term_prin, o.bef_resch_final_term_prin) as bef_resch_final_term_prin -- 展期前贷款末期应还本金
    ,nvl(n.bef_resch_init_fee1, o.bef_resch_init_fee1) as bef_resch_init_fee1 -- 展期前贷款总手续费
    ,nvl(n.bef_resch_fixed_fee1, o.bef_resch_fixed_fee1) as bef_resch_fixed_fee1 -- 贷款每期手续费
    ,nvl(n.bef_resch_first_term_fee1, o.bef_resch_first_term_fee1) as bef_resch_first_term_fee1 -- 展期前贷款首期手续费
    ,nvl(n.bef_resch_final_term_fee1, o.bef_resch_final_term_fee1) as bef_resch_final_term_fee1 -- 展期前贷款末期手续费
    ,nvl(n.resch_first_term_fee1, o.resch_first_term_fee1) as resch_first_term_fee1 -- 展期后首期手续费
    ,nvl(n.loan_fee_method, o.loan_fee_method) as loan_fee_method -- 贷款手续费收取方式
    ,nvl(n.interest_rate, o.interest_rate) as interest_rate -- 基础利率
    ,nvl(n.penalty_rate, o.penalty_rate) as penalty_rate -- 罚息利率
    ,nvl(n.compound_rate, o.compound_rate) as compound_rate -- 复利利率
    ,nvl(n.float_rate, o.float_rate) as float_rate -- 浮动比例
    ,nvl(n.loan_receipt_nbr, o.loan_receipt_nbr) as loan_receipt_nbr -- 借据号
    ,nvl(n.loan_expire_date, o.loan_expire_date) as loan_expire_date -- 贷款到期日期
    ,nvl(n.loan_cd, o.loan_cd) as loan_cd -- 贷款逾期最大期数
    ,nvl(n.payment_hist, o.payment_hist) as payment_hist -- 24个月还款状态
    ,nvl(n.ctd_payment_amt, o.ctd_payment_amt) as ctd_payment_amt -- 当期还款额
    ,nvl(n.past_resch_cnt, o.past_resch_cnt) as past_resch_cnt -- 已展期次数
    ,nvl(n.past_shorted_cnt, o.past_shorted_cnt) as past_shorted_cnt -- 已缩期次数
    ,nvl(n.adv_pmt_amt, o.adv_pmt_amt) as adv_pmt_amt -- 提前还款金额
    ,nvl(n.last_action_date, o.last_action_date) as last_action_date -- 上次行动日期
    ,nvl(n.last_action_type, o.last_action_type) as last_action_type -- 上次行动类型
    ,nvl(n.last_modified_datetime, o.last_modified_datetime) as last_modified_datetime -- 修改时间
    ,nvl(n.activate_date, o.activate_date) as activate_date -- 激活日期
    ,nvl(n.interest_calc_base, o.interest_calc_base) as interest_calc_base -- 计息基数
    ,nvl(n.first_bill_date, o.first_bill_date) as first_bill_date -- 首个到期还款日
    ,nvl(n.age_cd, o.age_cd) as age_cd -- 账龄
    ,nvl(n.recalc_ind, o.recalc_ind) as recalc_ind -- 利率重算标志
    ,nvl(n.recalc_date, o.recalc_date) as recalc_date -- 利率重算日
    ,nvl(n.grace_date, o.grace_date) as grace_date -- 宽限日期
    ,nvl(n.cancel_date, o.cancel_date) as cancel_date -- 撤销日期
    ,nvl(n.cancel_reason, o.cancel_reason) as cancel_reason -- 贷款撤销原因
    ,nvl(n.bank_group_id, o.bank_group_id) as bank_group_id -- 银团编号
    ,nvl(n.due_days, o.due_days) as due_days -- 当前逾期天数
    ,nvl(n.contract_ver, o.contract_ver) as contract_ver -- 合同版本号
    ,nvl(n.loan_init_interest, o.loan_init_interest) as loan_init_interest -- 贷款总利息
    ,nvl(n.bef_init_interest, o.bef_init_interest) as bef_init_interest -- 原贷款总利息
    ,nvl(n.bank_proportion, o.bank_proportion) as bank_proportion -- 银行出资比例
    ,nvl(n.batchfilename, o.batchfilename) as batchfilename -- 批量文件名
    ,nvl(n.seqno, o.seqno) as seqno -- 序列号
    ,nvl(n.three_type_cd, o.three_type_cd) as three_type_cd -- 资产三分类
    ,case when
            n.loan_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.loan_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.loan_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a0ntm_loan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a0ntm_loan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.loan_id = n.loan_id
where (
        o.loan_id is null
    )
    or (
        n.loan_id is null
    )
    or (
        o.org <> n.org
        or o.acct_no <> n.acct_no
        or o.acct_type <> n.acct_type
        or o.ref_nbr <> n.ref_nbr
        or o.logical_card_no <> n.logical_card_no
        or o.card_no <> n.card_no
        or o.register_date <> n.register_date
        or o.request_time <> n.request_time
        or o.loan_type <> n.loan_type
        or o.loan_status <> n.loan_status
        or o.last_loan_status <> n.last_loan_status
        or o.loan_init_term <> n.loan_init_term
        or o.curr_term <> n.curr_term
        or o.remain_term <> n.remain_term
        or o.loan_init_prin <> n.loan_init_prin
        or o.loan_fixed_pmt_prin <> n.loan_fixed_pmt_prin
        or o.loan_first_term_prin <> n.loan_first_term_prin
        or o.loan_final_term_prin <> n.loan_final_term_prin
        or o.loan_init_fee1 <> n.loan_init_fee1
        or o.loan_fixed_fee1 <> n.loan_fixed_fee1
        or o.loan_first_term_fee1 <> n.loan_first_term_fee1
        or o.loan_final_term_fee1 <> n.loan_final_term_fee1
        or o.unearned_prin <> n.unearned_prin
        or o.unearned_fee1 <> n.unearned_fee1
        or o.paid_out_date <> n.paid_out_date
        or o.terminate_date <> n.terminate_date
        or o.terminate_reason_cd <> n.terminate_reason_cd
        or o.prin_paid <> n.prin_paid
        or o.int_paid <> n.int_paid
        or o.fee_paid <> n.fee_paid
        or o.loan_curr_bal <> n.loan_curr_bal
        or o.loan_bal_xfrout <> n.loan_bal_xfrout
        or o.loan_bal_xfrin <> n.loan_bal_xfrin
        or o.loan_bal_principal <> n.loan_bal_principal
        or o.loan_bal_interest <> n.loan_bal_interest
        or o.loan_bal_penalty <> n.loan_bal_penalty
        or o.loan_prin_xfrout <> n.loan_prin_xfrout
        or o.loan_prin_xfrin <> n.loan_prin_xfrin
        or o.loan_fee1_xfrout <> n.loan_fee1_xfrout
        or o.loan_fee1_xfrin <> n.loan_fee1_xfrin
        or o.orig_txn_amt <> n.orig_txn_amt
        or o.orig_trans_date <> n.orig_trans_date
        or o.orig_auth_code <> n.orig_auth_code
        or o.jpa_version <> n.jpa_version
        or o.loan_code <> n.loan_code
        or o.register_id <> n.register_id
        or o.resch_init_prin <> n.resch_init_prin
        or o.resch_date <> n.resch_date
        or o.bef_resch_fixed_pmt_prin <> n.bef_resch_fixed_pmt_prin
        or o.bef_resch_init_term <> n.bef_resch_init_term
        or o.bef_resch_first_term_prin <> n.bef_resch_first_term_prin
        or o.bef_resch_final_term_prin <> n.bef_resch_final_term_prin
        or o.bef_resch_init_fee1 <> n.bef_resch_init_fee1
        or o.bef_resch_fixed_fee1 <> n.bef_resch_fixed_fee1
        or o.bef_resch_first_term_fee1 <> n.bef_resch_first_term_fee1
        or o.bef_resch_final_term_fee1 <> n.bef_resch_final_term_fee1
        or o.resch_first_term_fee1 <> n.resch_first_term_fee1
        or o.loan_fee_method <> n.loan_fee_method
        or o.interest_rate <> n.interest_rate
        or o.penalty_rate <> n.penalty_rate
        or o.compound_rate <> n.compound_rate
        or o.float_rate <> n.float_rate
        or o.loan_receipt_nbr <> n.loan_receipt_nbr
        or o.loan_expire_date <> n.loan_expire_date
        or o.loan_cd <> n.loan_cd
        or o.payment_hist <> n.payment_hist
        or o.ctd_payment_amt <> n.ctd_payment_amt
        or o.past_resch_cnt <> n.past_resch_cnt
        or o.past_shorted_cnt <> n.past_shorted_cnt
        or o.adv_pmt_amt <> n.adv_pmt_amt
        or o.last_action_date <> n.last_action_date
        or o.last_action_type <> n.last_action_type
        or o.last_modified_datetime <> n.last_modified_datetime
        or o.activate_date <> n.activate_date
        or o.interest_calc_base <> n.interest_calc_base
        or o.first_bill_date <> n.first_bill_date
        or o.age_cd <> n.age_cd
        or o.recalc_ind <> n.recalc_ind
        or o.recalc_date <> n.recalc_date
        or o.grace_date <> n.grace_date
        or o.cancel_date <> n.cancel_date
        or o.cancel_reason <> n.cancel_reason
        or o.bank_group_id <> n.bank_group_id
        or o.due_days <> n.due_days
        or o.contract_ver <> n.contract_ver
        or o.loan_init_interest <> n.loan_init_interest
        or o.bef_init_interest <> n.bef_init_interest
        or o.bank_proportion <> n.bank_proportion
        or o.batchfilename <> n.batchfilename
        or o.seqno <> n.seqno
        or o.three_type_cd <> n.three_type_cd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a0ntm_loan_cl(
            org -- 机构号
            ,loan_id -- 借据ID
            ,acct_no -- 账户编号
            ,acct_type -- 账户类型
            ,ref_nbr -- 交易参考号
            ,logical_card_no -- 逻辑卡号
            ,card_no -- 卡号
            ,register_date -- 贷款注册日期
            ,request_time -- 请求日期时间
            ,loan_type -- 贷款类型
            ,loan_status -- 贷款状态
            ,last_loan_status -- 贷款上次状态
            ,loan_init_term -- 贷款总期数
            ,curr_term -- 当前期数
            ,remain_term -- 剩余期数
            ,loan_init_prin -- 贷款总本金
            ,loan_fixed_pmt_prin -- 贷款每期应还本金
            ,loan_first_term_prin -- 贷款首期应还本金
            ,loan_final_term_prin -- 贷款末期应还本金
            ,loan_init_fee1 -- 贷款总手续费
            ,loan_fixed_fee1 -- 贷款每期手续费
            ,loan_first_term_fee1 -- 贷款首期手续费
            ,loan_final_term_fee1 -- 贷款末期手续费
            ,unearned_prin -- 贷款账单的本金
            ,unearned_fee1 -- 贷款账单手续费
            ,paid_out_date -- 还清日期
            ,terminate_date -- 提前终止日期
            ,terminate_reason_cd -- 贷款终止原因代码
            ,prin_paid -- 已偿还本金
            ,int_paid -- 已偿还利息
            ,fee_paid -- 已偿还费用
            ,loan_curr_bal -- 贷款当前总余额
            ,loan_bal_xfrout -- 贷款未到期余额
            ,loan_bal_xfrin -- 贷款已到期余额
            ,loan_bal_principal -- 欠款总本金
            ,loan_bal_interest -- 欠款总利息
            ,loan_bal_penalty -- 欠款总罚息
            ,loan_prin_xfrout -- 贷款未到期本金
            ,loan_prin_xfrin -- 贷款已到期本金
            ,loan_fee1_xfrout -- 贷款未到期手续费
            ,loan_fee1_xfrin -- 贷款已到期手续费
            ,orig_txn_amt -- 原始交易币种金额
            ,orig_trans_date -- 原始交易日期
            ,orig_auth_code -- 原始交易授权码
            ,jpa_version -- 乐观锁版本号
            ,loan_code -- 贷款产品号
            ,register_id -- 贷款申请顺序号
            ,resch_init_prin -- 展期本金金额
            ,resch_date -- 展期生效日期
            ,bef_resch_fixed_pmt_prin -- 展期前每期应还本金
            ,bef_resch_init_term -- 展期前总期数
            ,bef_resch_first_term_prin -- 展期前贷款首期应还本金
            ,bef_resch_final_term_prin -- 展期前贷款末期应还本金
            ,bef_resch_init_fee1 -- 展期前贷款总手续费
            ,bef_resch_fixed_fee1 -- 贷款每期手续费
            ,bef_resch_first_term_fee1 -- 展期前贷款首期手续费
            ,bef_resch_final_term_fee1 -- 展期前贷款末期手续费
            ,resch_first_term_fee1 -- 展期后首期手续费
            ,loan_fee_method -- 贷款手续费收取方式
            ,interest_rate -- 基础利率
            ,penalty_rate -- 罚息利率
            ,compound_rate -- 复利利率
            ,float_rate -- 浮动比例
            ,loan_receipt_nbr -- 借据号
            ,loan_expire_date -- 贷款到期日期
            ,loan_cd -- 贷款逾期最大期数
            ,payment_hist -- 24个月还款状态
            ,ctd_payment_amt -- 当期还款额
            ,past_resch_cnt -- 已展期次数
            ,past_shorted_cnt -- 已缩期次数
            ,adv_pmt_amt -- 提前还款金额
            ,last_action_date -- 上次行动日期
            ,last_action_type -- 上次行动类型
            ,last_modified_datetime -- 修改时间
            ,activate_date -- 激活日期
            ,interest_calc_base -- 计息基数
            ,first_bill_date -- 首个到期还款日
            ,age_cd -- 账龄
            ,recalc_ind -- 利率重算标志
            ,recalc_date -- 利率重算日
            ,grace_date -- 宽限日期
            ,cancel_date -- 撤销日期
            ,cancel_reason -- 贷款撤销原因
            ,bank_group_id -- 银团编号
            ,due_days -- 当前逾期天数
            ,contract_ver -- 合同版本号
            ,loan_init_interest -- 贷款总利息
            ,bef_init_interest -- 原贷款总利息
            ,bank_proportion -- 银行出资比例
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,three_type_cd -- 资产三分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a0ntm_loan_op(
            org -- 机构号
            ,loan_id -- 借据ID
            ,acct_no -- 账户编号
            ,acct_type -- 账户类型
            ,ref_nbr -- 交易参考号
            ,logical_card_no -- 逻辑卡号
            ,card_no -- 卡号
            ,register_date -- 贷款注册日期
            ,request_time -- 请求日期时间
            ,loan_type -- 贷款类型
            ,loan_status -- 贷款状态
            ,last_loan_status -- 贷款上次状态
            ,loan_init_term -- 贷款总期数
            ,curr_term -- 当前期数
            ,remain_term -- 剩余期数
            ,loan_init_prin -- 贷款总本金
            ,loan_fixed_pmt_prin -- 贷款每期应还本金
            ,loan_first_term_prin -- 贷款首期应还本金
            ,loan_final_term_prin -- 贷款末期应还本金
            ,loan_init_fee1 -- 贷款总手续费
            ,loan_fixed_fee1 -- 贷款每期手续费
            ,loan_first_term_fee1 -- 贷款首期手续费
            ,loan_final_term_fee1 -- 贷款末期手续费
            ,unearned_prin -- 贷款账单的本金
            ,unearned_fee1 -- 贷款账单手续费
            ,paid_out_date -- 还清日期
            ,terminate_date -- 提前终止日期
            ,terminate_reason_cd -- 贷款终止原因代码
            ,prin_paid -- 已偿还本金
            ,int_paid -- 已偿还利息
            ,fee_paid -- 已偿还费用
            ,loan_curr_bal -- 贷款当前总余额
            ,loan_bal_xfrout -- 贷款未到期余额
            ,loan_bal_xfrin -- 贷款已到期余额
            ,loan_bal_principal -- 欠款总本金
            ,loan_bal_interest -- 欠款总利息
            ,loan_bal_penalty -- 欠款总罚息
            ,loan_prin_xfrout -- 贷款未到期本金
            ,loan_prin_xfrin -- 贷款已到期本金
            ,loan_fee1_xfrout -- 贷款未到期手续费
            ,loan_fee1_xfrin -- 贷款已到期手续费
            ,orig_txn_amt -- 原始交易币种金额
            ,orig_trans_date -- 原始交易日期
            ,orig_auth_code -- 原始交易授权码
            ,jpa_version -- 乐观锁版本号
            ,loan_code -- 贷款产品号
            ,register_id -- 贷款申请顺序号
            ,resch_init_prin -- 展期本金金额
            ,resch_date -- 展期生效日期
            ,bef_resch_fixed_pmt_prin -- 展期前每期应还本金
            ,bef_resch_init_term -- 展期前总期数
            ,bef_resch_first_term_prin -- 展期前贷款首期应还本金
            ,bef_resch_final_term_prin -- 展期前贷款末期应还本金
            ,bef_resch_init_fee1 -- 展期前贷款总手续费
            ,bef_resch_fixed_fee1 -- 贷款每期手续费
            ,bef_resch_first_term_fee1 -- 展期前贷款首期手续费
            ,bef_resch_final_term_fee1 -- 展期前贷款末期手续费
            ,resch_first_term_fee1 -- 展期后首期手续费
            ,loan_fee_method -- 贷款手续费收取方式
            ,interest_rate -- 基础利率
            ,penalty_rate -- 罚息利率
            ,compound_rate -- 复利利率
            ,float_rate -- 浮动比例
            ,loan_receipt_nbr -- 借据号
            ,loan_expire_date -- 贷款到期日期
            ,loan_cd -- 贷款逾期最大期数
            ,payment_hist -- 24个月还款状态
            ,ctd_payment_amt -- 当期还款额
            ,past_resch_cnt -- 已展期次数
            ,past_shorted_cnt -- 已缩期次数
            ,adv_pmt_amt -- 提前还款金额
            ,last_action_date -- 上次行动日期
            ,last_action_type -- 上次行动类型
            ,last_modified_datetime -- 修改时间
            ,activate_date -- 激活日期
            ,interest_calc_base -- 计息基数
            ,first_bill_date -- 首个到期还款日
            ,age_cd -- 账龄
            ,recalc_ind -- 利率重算标志
            ,recalc_date -- 利率重算日
            ,grace_date -- 宽限日期
            ,cancel_date -- 撤销日期
            ,cancel_reason -- 贷款撤销原因
            ,bank_group_id -- 银团编号
            ,due_days -- 当前逾期天数
            ,contract_ver -- 合同版本号
            ,loan_init_interest -- 贷款总利息
            ,bef_init_interest -- 原贷款总利息
            ,bank_proportion -- 银行出资比例
            ,batchfilename -- 批量文件名
            ,seqno -- 序列号
            ,three_type_cd -- 资产三分类
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org -- 机构号
    ,o.loan_id -- 借据ID
    ,o.acct_no -- 账户编号
    ,o.acct_type -- 账户类型
    ,o.ref_nbr -- 交易参考号
    ,o.logical_card_no -- 逻辑卡号
    ,o.card_no -- 卡号
    ,o.register_date -- 贷款注册日期
    ,o.request_time -- 请求日期时间
    ,o.loan_type -- 贷款类型
    ,o.loan_status -- 贷款状态
    ,o.last_loan_status -- 贷款上次状态
    ,o.loan_init_term -- 贷款总期数
    ,o.curr_term -- 当前期数
    ,o.remain_term -- 剩余期数
    ,o.loan_init_prin -- 贷款总本金
    ,o.loan_fixed_pmt_prin -- 贷款每期应还本金
    ,o.loan_first_term_prin -- 贷款首期应还本金
    ,o.loan_final_term_prin -- 贷款末期应还本金
    ,o.loan_init_fee1 -- 贷款总手续费
    ,o.loan_fixed_fee1 -- 贷款每期手续费
    ,o.loan_first_term_fee1 -- 贷款首期手续费
    ,o.loan_final_term_fee1 -- 贷款末期手续费
    ,o.unearned_prin -- 贷款账单的本金
    ,o.unearned_fee1 -- 贷款账单手续费
    ,o.paid_out_date -- 还清日期
    ,o.terminate_date -- 提前终止日期
    ,o.terminate_reason_cd -- 贷款终止原因代码
    ,o.prin_paid -- 已偿还本金
    ,o.int_paid -- 已偿还利息
    ,o.fee_paid -- 已偿还费用
    ,o.loan_curr_bal -- 贷款当前总余额
    ,o.loan_bal_xfrout -- 贷款未到期余额
    ,o.loan_bal_xfrin -- 贷款已到期余额
    ,o.loan_bal_principal -- 欠款总本金
    ,o.loan_bal_interest -- 欠款总利息
    ,o.loan_bal_penalty -- 欠款总罚息
    ,o.loan_prin_xfrout -- 贷款未到期本金
    ,o.loan_prin_xfrin -- 贷款已到期本金
    ,o.loan_fee1_xfrout -- 贷款未到期手续费
    ,o.loan_fee1_xfrin -- 贷款已到期手续费
    ,o.orig_txn_amt -- 原始交易币种金额
    ,o.orig_trans_date -- 原始交易日期
    ,o.orig_auth_code -- 原始交易授权码
    ,o.jpa_version -- 乐观锁版本号
    ,o.loan_code -- 贷款产品号
    ,o.register_id -- 贷款申请顺序号
    ,o.resch_init_prin -- 展期本金金额
    ,o.resch_date -- 展期生效日期
    ,o.bef_resch_fixed_pmt_prin -- 展期前每期应还本金
    ,o.bef_resch_init_term -- 展期前总期数
    ,o.bef_resch_first_term_prin -- 展期前贷款首期应还本金
    ,o.bef_resch_final_term_prin -- 展期前贷款末期应还本金
    ,o.bef_resch_init_fee1 -- 展期前贷款总手续费
    ,o.bef_resch_fixed_fee1 -- 贷款每期手续费
    ,o.bef_resch_first_term_fee1 -- 展期前贷款首期手续费
    ,o.bef_resch_final_term_fee1 -- 展期前贷款末期手续费
    ,o.resch_first_term_fee1 -- 展期后首期手续费
    ,o.loan_fee_method -- 贷款手续费收取方式
    ,o.interest_rate -- 基础利率
    ,o.penalty_rate -- 罚息利率
    ,o.compound_rate -- 复利利率
    ,o.float_rate -- 浮动比例
    ,o.loan_receipt_nbr -- 借据号
    ,o.loan_expire_date -- 贷款到期日期
    ,o.loan_cd -- 贷款逾期最大期数
    ,o.payment_hist -- 24个月还款状态
    ,o.ctd_payment_amt -- 当期还款额
    ,o.past_resch_cnt -- 已展期次数
    ,o.past_shorted_cnt -- 已缩期次数
    ,o.adv_pmt_amt -- 提前还款金额
    ,o.last_action_date -- 上次行动日期
    ,o.last_action_type -- 上次行动类型
    ,o.last_modified_datetime -- 修改时间
    ,o.activate_date -- 激活日期
    ,o.interest_calc_base -- 计息基数
    ,o.first_bill_date -- 首个到期还款日
    ,o.age_cd -- 账龄
    ,o.recalc_ind -- 利率重算标志
    ,o.recalc_date -- 利率重算日
    ,o.grace_date -- 宽限日期
    ,o.cancel_date -- 撤销日期
    ,o.cancel_reason -- 贷款撤销原因
    ,o.bank_group_id -- 银团编号
    ,o.due_days -- 当前逾期天数
    ,o.contract_ver -- 合同版本号
    ,o.loan_init_interest -- 贷款总利息
    ,o.bef_init_interest -- 原贷款总利息
    ,o.bank_proportion -- 银行出资比例
    ,o.batchfilename -- 批量文件名
    ,o.seqno -- 序列号
    ,o.three_type_cd -- 资产三分类
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
from ${iol_schema}.mpcs_a0ntm_loan_bk o
    left join ${iol_schema}.mpcs_a0ntm_loan_op n
        on
            o.loan_id = n.loan_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a0ntm_loan_cl d
        on
            o.loan_id = d.loan_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a0ntm_loan;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a0ntm_loan') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a0ntm_loan drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a0ntm_loan add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a0ntm_loan exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a0ntm_loan_cl;
alter table ${iol_schema}.mpcs_a0ntm_loan exchange partition p_20991231 with table ${iol_schema}.mpcs_a0ntm_loan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a0ntm_loan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a0ntm_loan_op purge;
drop table ${iol_schema}.mpcs_a0ntm_loan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a0ntm_loan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a0ntm_loan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
