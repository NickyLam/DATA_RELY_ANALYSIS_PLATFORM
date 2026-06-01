/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol mpcs_a0ntm_loan
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.mpcs_a0ntm_loan
whenever sqlerror continue none;
drop table ${iol_schema}.mpcs_a0ntm_loan purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a0ntm_loan(
    org varchar2(18) -- 机构号
    ,loan_id number(20,0) -- 借据id
    ,acct_no number(20,0) -- 账户编号
    ,acct_type varchar2(2) -- 账户类型
    ,ref_nbr varchar2(35) -- 交易参考号
    ,logical_card_no varchar2(29) -- 逻辑卡号
    ,card_no varchar2(29) -- 卡号
    ,register_date date -- 贷款注册日期
    ,request_time date -- 请求日期时间
    ,loan_type varchar2(8) -- 贷款类型
    ,loan_status varchar2(2) -- 贷款状态
    ,last_loan_status varchar2(2) -- 贷款上次状态
    ,loan_init_term number(22) -- 贷款总期数
    ,curr_term number(22) -- 当前期数
    ,remain_term number(22) -- 剩余期数
    ,loan_init_prin number(15,2) -- 贷款总本金
    ,loan_fixed_pmt_prin number(15,2) -- 贷款每期应还本金
    ,loan_first_term_prin number(15,2) -- 贷款首期应还本金
    ,loan_final_term_prin number(15,2) -- 贷款末期应还本金
    ,loan_init_fee1 number(15,2) -- 贷款总手续费
    ,loan_fixed_fee1 number(15,2) -- 贷款每期手续费
    ,loan_first_term_fee1 number(15,2) -- 贷款首期手续费
    ,loan_final_term_fee1 number(15,2) -- 贷款末期手续费
    ,unearned_prin number(15,2) -- 贷款账单的本金
    ,unearned_fee1 number(15,2) -- 贷款账单手续费
    ,paid_out_date date -- 还清日期
    ,terminate_date date -- 提前终止日期
    ,terminate_reason_cd varchar2(2) -- 贷款终止原因代码
    ,prin_paid number(15,2) -- 已偿还本金
    ,int_paid number(15,2) -- 已偿还利息
    ,fee_paid number(15,2) -- 已偿还费用
    ,loan_curr_bal number(15,2) -- 贷款当前总余额
    ,loan_bal_xfrout number(15,2) -- 贷款未到期余额
    ,loan_bal_xfrin number(15,2) -- 贷款已到期余额
    ,loan_bal_principal number(15,2) -- 欠款总本金
    ,loan_bal_interest number(15,2) -- 欠款总利息
    ,loan_bal_penalty number(15,2) -- 欠款总罚息
    ,loan_prin_xfrout number(15,2) -- 贷款未到期本金
    ,loan_prin_xfrin number(15,2) -- 贷款已到期本金
    ,loan_fee1_xfrout number(15,2) -- 贷款未到期手续费
    ,loan_fee1_xfrin number(15,2) -- 贷款已到期手续费
    ,orig_txn_amt number(15,2) -- 原始交易币种金额
    ,orig_trans_date date -- 原始交易日期
    ,orig_auth_code varchar2(9) -- 原始交易授权码
    ,jpa_version number(22) -- 乐观锁版本号
    ,loan_code varchar2(6) -- 贷款产品号
    ,register_id number(20,0) -- 贷款申请顺序号
    ,resch_init_prin number(15,2) -- 展期本金金额
    ,resch_date date -- 展期生效日期
    ,bef_resch_fixed_pmt_prin number(15,2) -- 展期前每期应还本金
    ,bef_resch_init_term number(22) -- 展期前总期数
    ,bef_resch_first_term_prin number(15,2) -- 展期前贷款首期应还本金
    ,bef_resch_final_term_prin number(15,2) -- 展期前贷款末期应还本金
    ,bef_resch_init_fee1 number(15,2) -- 展期前贷款总手续费
    ,bef_resch_fixed_fee1 number(15,2) -- 贷款每期手续费
    ,bef_resch_first_term_fee1 number(15,2) -- 展期前贷款首期手续费
    ,bef_resch_final_term_fee1 number(15,2) -- 展期前贷款末期手续费
    ,resch_first_term_fee1 number(15,2) -- 展期后首期手续费
    ,loan_fee_method varchar2(2) -- 贷款手续费收取方式
    ,interest_rate number(19,6) -- 基础利率
    ,penalty_rate number(19,6) -- 罚息利率
    ,compound_rate number(19,6) -- 复利利率
    ,float_rate number(19,6) -- 浮动比例
    ,loan_receipt_nbr varchar2(30) -- 借据号
    ,loan_expire_date date -- 贷款到期日期
    ,loan_cd varchar2(3) -- 贷款逾期最大期数
    ,payment_hist varchar2(36) -- 24个月还款状态
    ,ctd_payment_amt number(15,2) -- 当期还款额
    ,past_resch_cnt number(22) -- 已展期次数
    ,past_shorted_cnt number(22) -- 已缩期次数
    ,adv_pmt_amt number(15,2) -- 提前还款金额
    ,last_action_date date -- 上次行动日期
    ,last_action_type varchar2(2) -- 上次行动类型
    ,last_modified_datetime date -- 修改时间
    ,activate_date date -- 激活日期
    ,interest_calc_base varchar2(2) -- 计息基数
    ,first_bill_date date -- 首个到期还款日
    ,age_cd varchar2(2) -- 账龄
    ,recalc_ind varchar2(2) -- 利率重算标志
    ,recalc_date date -- 利率重算日
    ,grace_date date -- 宽限日期
    ,cancel_date date -- 撤销日期
    ,cancel_reason varchar2(150) -- 贷款撤销原因
    ,bank_group_id varchar2(8) -- 银团编号
    ,due_days number(22) -- 当前逾期天数
    ,contract_ver varchar2(600) -- 合同版本号
    ,loan_init_interest number(15,2) -- 贷款总利息
    ,bef_init_interest number(15,2) -- 原贷款总利息
    ,bank_proportion number(5,2) -- 银行出资比例
    ,batchfilename varchar2(90) -- 批量文件名
    ,seqno varchar2(30) -- 序列号
    ,three_type_cd varchar2(15) -- 资产三分类
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
grant select on ${iol_schema}.mpcs_a0ntm_loan to ${iml_schema};
grant select on ${iol_schema}.mpcs_a0ntm_loan to ${icl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_loan to ${idl_schema};
grant select on ${iol_schema}.mpcs_a0ntm_loan to ${iel_schema};

-- comment
comment on table ${iol_schema}.mpcs_a0ntm_loan is '分期信息表';
comment on column ${iol_schema}.mpcs_a0ntm_loan.org is '机构号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_id is '借据id';
comment on column ${iol_schema}.mpcs_a0ntm_loan.acct_no is '账户编号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.acct_type is '账户类型';
comment on column ${iol_schema}.mpcs_a0ntm_loan.ref_nbr is '交易参考号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.logical_card_no is '逻辑卡号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.card_no is '卡号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.register_date is '贷款注册日期';
comment on column ${iol_schema}.mpcs_a0ntm_loan.request_time is '请求日期时间';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_type is '贷款类型';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_status is '贷款状态';
comment on column ${iol_schema}.mpcs_a0ntm_loan.last_loan_status is '贷款上次状态';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_init_term is '贷款总期数';
comment on column ${iol_schema}.mpcs_a0ntm_loan.curr_term is '当前期数';
comment on column ${iol_schema}.mpcs_a0ntm_loan.remain_term is '剩余期数';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_init_prin is '贷款总本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_fixed_pmt_prin is '贷款每期应还本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_first_term_prin is '贷款首期应还本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_final_term_prin is '贷款末期应还本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_init_fee1 is '贷款总手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_fixed_fee1 is '贷款每期手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_first_term_fee1 is '贷款首期手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_final_term_fee1 is '贷款末期手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.unearned_prin is '贷款账单的本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.unearned_fee1 is '贷款账单手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.paid_out_date is '还清日期';
comment on column ${iol_schema}.mpcs_a0ntm_loan.terminate_date is '提前终止日期';
comment on column ${iol_schema}.mpcs_a0ntm_loan.terminate_reason_cd is '贷款终止原因代码';
comment on column ${iol_schema}.mpcs_a0ntm_loan.prin_paid is '已偿还本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.int_paid is '已偿还利息';
comment on column ${iol_schema}.mpcs_a0ntm_loan.fee_paid is '已偿还费用';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_curr_bal is '贷款当前总余额';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_bal_xfrout is '贷款未到期余额';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_bal_xfrin is '贷款已到期余额';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_bal_principal is '欠款总本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_bal_interest is '欠款总利息';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_bal_penalty is '欠款总罚息';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_prin_xfrout is '贷款未到期本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_prin_xfrin is '贷款已到期本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_fee1_xfrout is '贷款未到期手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_fee1_xfrin is '贷款已到期手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.orig_txn_amt is '原始交易币种金额';
comment on column ${iol_schema}.mpcs_a0ntm_loan.orig_trans_date is '原始交易日期';
comment on column ${iol_schema}.mpcs_a0ntm_loan.orig_auth_code is '原始交易授权码';
comment on column ${iol_schema}.mpcs_a0ntm_loan.jpa_version is '乐观锁版本号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_code is '贷款产品号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.register_id is '贷款申请顺序号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.resch_init_prin is '展期本金金额';
comment on column ${iol_schema}.mpcs_a0ntm_loan.resch_date is '展期生效日期';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bef_resch_fixed_pmt_prin is '展期前每期应还本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bef_resch_init_term is '展期前总期数';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bef_resch_first_term_prin is '展期前贷款首期应还本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bef_resch_final_term_prin is '展期前贷款末期应还本金';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bef_resch_init_fee1 is '展期前贷款总手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bef_resch_fixed_fee1 is '贷款每期手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bef_resch_first_term_fee1 is '展期前贷款首期手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bef_resch_final_term_fee1 is '展期前贷款末期手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.resch_first_term_fee1 is '展期后首期手续费';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_fee_method is '贷款手续费收取方式';
comment on column ${iol_schema}.mpcs_a0ntm_loan.interest_rate is '基础利率';
comment on column ${iol_schema}.mpcs_a0ntm_loan.penalty_rate is '罚息利率';
comment on column ${iol_schema}.mpcs_a0ntm_loan.compound_rate is '复利利率';
comment on column ${iol_schema}.mpcs_a0ntm_loan.float_rate is '浮动比例';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_receipt_nbr is '借据号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_expire_date is '贷款到期日期';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_cd is '贷款逾期最大期数';
comment on column ${iol_schema}.mpcs_a0ntm_loan.payment_hist is '24个月还款状态';
comment on column ${iol_schema}.mpcs_a0ntm_loan.ctd_payment_amt is '当期还款额';
comment on column ${iol_schema}.mpcs_a0ntm_loan.past_resch_cnt is '已展期次数';
comment on column ${iol_schema}.mpcs_a0ntm_loan.past_shorted_cnt is '已缩期次数';
comment on column ${iol_schema}.mpcs_a0ntm_loan.adv_pmt_amt is '提前还款金额';
comment on column ${iol_schema}.mpcs_a0ntm_loan.last_action_date is '上次行动日期';
comment on column ${iol_schema}.mpcs_a0ntm_loan.last_action_type is '上次行动类型';
comment on column ${iol_schema}.mpcs_a0ntm_loan.last_modified_datetime is '修改时间';
comment on column ${iol_schema}.mpcs_a0ntm_loan.activate_date is '激活日期';
comment on column ${iol_schema}.mpcs_a0ntm_loan.interest_calc_base is '计息基数';
comment on column ${iol_schema}.mpcs_a0ntm_loan.first_bill_date is '首个到期还款日';
comment on column ${iol_schema}.mpcs_a0ntm_loan.age_cd is '账龄';
comment on column ${iol_schema}.mpcs_a0ntm_loan.recalc_ind is '利率重算标志';
comment on column ${iol_schema}.mpcs_a0ntm_loan.recalc_date is '利率重算日';
comment on column ${iol_schema}.mpcs_a0ntm_loan.grace_date is '宽限日期';
comment on column ${iol_schema}.mpcs_a0ntm_loan.cancel_date is '撤销日期';
comment on column ${iol_schema}.mpcs_a0ntm_loan.cancel_reason is '贷款撤销原因';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bank_group_id is '银团编号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.due_days is '当前逾期天数';
comment on column ${iol_schema}.mpcs_a0ntm_loan.contract_ver is '合同版本号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.loan_init_interest is '贷款总利息';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bef_init_interest is '原贷款总利息';
comment on column ${iol_schema}.mpcs_a0ntm_loan.bank_proportion is '银行出资比例';
comment on column ${iol_schema}.mpcs_a0ntm_loan.batchfilename is '批量文件名';
comment on column ${iol_schema}.mpcs_a0ntm_loan.seqno is '序列号';
comment on column ${iol_schema}.mpcs_a0ntm_loan.three_type_cd is '资产三分类';
comment on column ${iol_schema}.mpcs_a0ntm_loan.start_dt is '开始时间';
comment on column ${iol_schema}.mpcs_a0ntm_loan.end_dt is '结束时间';
comment on column ${iol_schema}.mpcs_a0ntm_loan.id_mark is '增删标志';
comment on column ${iol_schema}.mpcs_a0ntm_loan.etl_timestamp is 'ETL处理时间戳';
