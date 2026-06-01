/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_loan_borrow_info
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
create table ${iol_schema}.hgls_loan_borrow_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_loan_borrow_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_borrow_info_op purge;
drop table ${iol_schema}.hgls_loan_borrow_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_borrow_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_borrow_info where 0=1;

create table ${iol_schema}.hgls_loan_borrow_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_borrow_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_borrow_info_cl(
            id -- 主键id
            ,cust_id -- 借款人id
            ,cust_name -- 用户姓名
            ,ent_name -- 企业名称
            ,credit_code -- 企业统一社会信用代码
            ,id_card_no -- 身份证号码
            ,prd_type -- 产品类型，字典值cplx
            ,prd_code -- 借款对应的产品编码
            ,req_code -- 借款对应的进件编码
            ,repayment_period -- 还款期数
            ,repayment_kind -- 还款方式
            ,daily_rate -- 日利率，万分之一
            ,repayment_date -- 首月还款日
            ,account_id -- 收款账户id
            ,bank_no -- 银行卡号
            ,bank_name -- 银行名称
            ,borrow_use -- 借款用途
            ,borrow_money -- 借款金额，元
            ,lend_money -- 实际放款金额
            ,borrow_interest -- 借款总利息，元
            ,loan_status -- 借款状态，1待审批2审批通过3审批拒绝4已放款5已结清7待审查8逾期
            ,is_cancel -- 贷款是否取消，0否1是
            ,reject_reason -- 审批拒绝原因
            ,survey_user_id -- 调查员id
            ,approver_user_id -- 审批人ID
            ,approver_user_name -- 审批人名字
            ,make_loan_user_id -- 放款人id
            ,make_loan_date -- 申请日期
            ,close_account_user_id -- 结清人id
            ,enterprise_code -- 企业注册码
            ,examiner_ids -- 审查者id
            ,auditor_ids -- 审批者id
            ,audit_num -- 审批人数
            ,examine_num -- 审查人数
            ,is_fk_sync -- 是否放款同步
            ,is_jq_sync -- 是否结清同步
            ,loan_balance -- 贷款余额（本金），单位元
            ,is_apply_letter -- 是否申请用信，0否1是
            ,apply_letter_date -- 申请用信时间
            ,create_date -- 创建时间
            ,update_date -- 更新时间
            ,is_mortgage -- 是否抵押完成
            ,isdel -- 删除标识
            ,label -- 标签状态
            ,back_msg -- 驳回原因
            ,code -- 借款表内码
            ,back_pages -- 驳回页面（补充资料类型：1，申请信息，2，视频信息）多选逗号隔开
            ,branch_code -- 支行code
            ,whether_type -- 随借随还类型:A，综合授信；B，富民卡
            ,loan_no -- 借据编号
            ,loan_type -- 贷款类型:1.微贷 2.信贷
            ,year_rate -- 年利率
            ,prd_name -- 授信产品名称
            ,pact_amt -- 授信额度
            ,end_date -- 到期日期
            ,settle_date -- 结清日期
            ,credit_pact_no -- 授信合同号
            ,loan_pact_no -- 授信合同号
            ,ac_id -- 贷款账户ID（借据号）
            ,over_amt -- 逾期本金
            ,ovre_in_intst -- 表内欠息
            ,over_out_intst -- 表外欠息
            ,org_num -- 登记机构号
            ,credit_beg_date -- 授信起始日期
            ,credit_end_date -- 授信到期日期
            ,beg_date -- 借据起始日期
            ,overdue_date -- 首次逾期日期
            ,over_amt_date -- 本金逾期日期
            ,over_intst_date -- 利息逾期日期
            ,cur_payment_amt -- 当期应还本金
            ,cur_payment_intst -- 当期应还利息
            ,dzhx_status -- 客户核销状态
            ,five_sts -- 五级分类状态
            ,five_level_class_des -- 五级分类状态描述
            ,loan_id -- 进件ID
            ,over_due_days -- 当前逾期天数
            ,write_off_date -- 核销日期
            ,write_off_amount -- 核销金额
            ,financial_number -- 财务机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_borrow_info_op(
            id -- 主键id
            ,cust_id -- 借款人id
            ,cust_name -- 用户姓名
            ,ent_name -- 企业名称
            ,credit_code -- 企业统一社会信用代码
            ,id_card_no -- 身份证号码
            ,prd_type -- 产品类型，字典值cplx
            ,prd_code -- 借款对应的产品编码
            ,req_code -- 借款对应的进件编码
            ,repayment_period -- 还款期数
            ,repayment_kind -- 还款方式
            ,daily_rate -- 日利率，万分之一
            ,repayment_date -- 首月还款日
            ,account_id -- 收款账户id
            ,bank_no -- 银行卡号
            ,bank_name -- 银行名称
            ,borrow_use -- 借款用途
            ,borrow_money -- 借款金额，元
            ,lend_money -- 实际放款金额
            ,borrow_interest -- 借款总利息，元
            ,loan_status -- 借款状态，1待审批2审批通过3审批拒绝4已放款5已结清7待审查8逾期
            ,is_cancel -- 贷款是否取消，0否1是
            ,reject_reason -- 审批拒绝原因
            ,survey_user_id -- 调查员id
            ,approver_user_id -- 审批人ID
            ,approver_user_name -- 审批人名字
            ,make_loan_user_id -- 放款人id
            ,make_loan_date -- 申请日期
            ,close_account_user_id -- 结清人id
            ,enterprise_code -- 企业注册码
            ,examiner_ids -- 审查者id
            ,auditor_ids -- 审批者id
            ,audit_num -- 审批人数
            ,examine_num -- 审查人数
            ,is_fk_sync -- 是否放款同步
            ,is_jq_sync -- 是否结清同步
            ,loan_balance -- 贷款余额（本金），单位元
            ,is_apply_letter -- 是否申请用信，0否1是
            ,apply_letter_date -- 申请用信时间
            ,create_date -- 创建时间
            ,update_date -- 更新时间
            ,is_mortgage -- 是否抵押完成
            ,isdel -- 删除标识
            ,label -- 标签状态
            ,back_msg -- 驳回原因
            ,code -- 借款表内码
            ,back_pages -- 驳回页面（补充资料类型：1，申请信息，2，视频信息）多选逗号隔开
            ,branch_code -- 支行code
            ,whether_type -- 随借随还类型:A，综合授信；B，富民卡
            ,loan_no -- 借据编号
            ,loan_type -- 贷款类型:1.微贷 2.信贷
            ,year_rate -- 年利率
            ,prd_name -- 授信产品名称
            ,pact_amt -- 授信额度
            ,end_date -- 到期日期
            ,settle_date -- 结清日期
            ,credit_pact_no -- 授信合同号
            ,loan_pact_no -- 授信合同号
            ,ac_id -- 贷款账户ID（借据号）
            ,over_amt -- 逾期本金
            ,ovre_in_intst -- 表内欠息
            ,over_out_intst -- 表外欠息
            ,org_num -- 登记机构号
            ,credit_beg_date -- 授信起始日期
            ,credit_end_date -- 授信到期日期
            ,beg_date -- 借据起始日期
            ,overdue_date -- 首次逾期日期
            ,over_amt_date -- 本金逾期日期
            ,over_intst_date -- 利息逾期日期
            ,cur_payment_amt -- 当期应还本金
            ,cur_payment_intst -- 当期应还利息
            ,dzhx_status -- 客户核销状态
            ,five_sts -- 五级分类状态
            ,five_level_class_des -- 五级分类状态描述
            ,loan_id -- 进件ID
            ,over_due_days -- 当前逾期天数
            ,write_off_date -- 核销日期
            ,write_off_amount -- 核销金额
            ,financial_number -- 财务机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键id
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 借款人id
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 用户姓名
    ,nvl(n.ent_name, o.ent_name) as ent_name -- 企业名称
    ,nvl(n.credit_code, o.credit_code) as credit_code -- 企业统一社会信用代码
    ,nvl(n.id_card_no, o.id_card_no) as id_card_no -- 身份证号码
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 产品类型，字典值cplx
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 借款对应的产品编码
    ,nvl(n.req_code, o.req_code) as req_code -- 借款对应的进件编码
    ,nvl(n.repayment_period, o.repayment_period) as repayment_period -- 还款期数
    ,nvl(n.repayment_kind, o.repayment_kind) as repayment_kind -- 还款方式
    ,nvl(n.daily_rate, o.daily_rate) as daily_rate -- 日利率，万分之一
    ,nvl(n.repayment_date, o.repayment_date) as repayment_date -- 首月还款日
    ,nvl(n.account_id, o.account_id) as account_id -- 收款账户id
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 银行卡号
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 银行名称
    ,nvl(n.borrow_use, o.borrow_use) as borrow_use -- 借款用途
    ,nvl(n.borrow_money, o.borrow_money) as borrow_money -- 借款金额，元
    ,nvl(n.lend_money, o.lend_money) as lend_money -- 实际放款金额
    ,nvl(n.borrow_interest, o.borrow_interest) as borrow_interest -- 借款总利息，元
    ,nvl(n.loan_status, o.loan_status) as loan_status -- 借款状态，1待审批2审批通过3审批拒绝4已放款5已结清7待审查8逾期
    ,nvl(n.is_cancel, o.is_cancel) as is_cancel -- 贷款是否取消，0否1是
    ,nvl(n.reject_reason, o.reject_reason) as reject_reason -- 审批拒绝原因
    ,nvl(n.survey_user_id, o.survey_user_id) as survey_user_id -- 调查员id
    ,nvl(n.approver_user_id, o.approver_user_id) as approver_user_id -- 审批人ID
    ,nvl(n.approver_user_name, o.approver_user_name) as approver_user_name -- 审批人名字
    ,nvl(n.make_loan_user_id, o.make_loan_user_id) as make_loan_user_id -- 放款人id
    ,nvl(n.make_loan_date, o.make_loan_date) as make_loan_date -- 申请日期
    ,nvl(n.close_account_user_id, o.close_account_user_id) as close_account_user_id -- 结清人id
    ,nvl(n.enterprise_code, o.enterprise_code) as enterprise_code -- 企业注册码
    ,nvl(n.examiner_ids, o.examiner_ids) as examiner_ids -- 审查者id
    ,nvl(n.auditor_ids, o.auditor_ids) as auditor_ids -- 审批者id
    ,nvl(n.audit_num, o.audit_num) as audit_num -- 审批人数
    ,nvl(n.examine_num, o.examine_num) as examine_num -- 审查人数
    ,nvl(n.is_fk_sync, o.is_fk_sync) as is_fk_sync -- 是否放款同步
    ,nvl(n.is_jq_sync, o.is_jq_sync) as is_jq_sync -- 是否结清同步
    ,nvl(n.loan_balance, o.loan_balance) as loan_balance -- 贷款余额（本金），单位元
    ,nvl(n.is_apply_letter, o.is_apply_letter) as is_apply_letter -- 是否申请用信，0否1是
    ,nvl(n.apply_letter_date, o.apply_letter_date) as apply_letter_date -- 申请用信时间
    ,nvl(n.create_date, o.create_date) as create_date -- 创建时间
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.is_mortgage, o.is_mortgage) as is_mortgage -- 是否抵押完成
    ,nvl(n.isdel, o.isdel) as isdel -- 删除标识
    ,nvl(n.label, o.label) as label -- 标签状态
    ,nvl(n.back_msg, o.back_msg) as back_msg -- 驳回原因
    ,nvl(n.code, o.code) as code -- 借款表内码
    ,nvl(n.back_pages, o.back_pages) as back_pages -- 驳回页面（补充资料类型：1，申请信息，2，视频信息）多选逗号隔开
    ,nvl(n.branch_code, o.branch_code) as branch_code -- 支行code
    ,nvl(n.whether_type, o.whether_type) as whether_type -- 随借随还类型:A，综合授信；B，富民卡
    ,nvl(n.loan_no, o.loan_no) as loan_no -- 借据编号
    ,nvl(n.loan_type, o.loan_type) as loan_type -- 贷款类型:1.微贷 2.信贷
    ,nvl(n.year_rate, o.year_rate) as year_rate -- 年利率
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 授信产品名称
    ,nvl(n.pact_amt, o.pact_amt) as pact_amt -- 授信额度
    ,nvl(n.end_date, o.end_date) as end_date -- 到期日期
    ,nvl(n.settle_date, o.settle_date) as settle_date -- 结清日期
    ,nvl(n.credit_pact_no, o.credit_pact_no) as credit_pact_no -- 授信合同号
    ,nvl(n.loan_pact_no, o.loan_pact_no) as loan_pact_no -- 授信合同号
    ,nvl(n.ac_id, o.ac_id) as ac_id -- 贷款账户ID（借据号）
    ,nvl(n.over_amt, o.over_amt) as over_amt -- 逾期本金
    ,nvl(n.ovre_in_intst, o.ovre_in_intst) as ovre_in_intst -- 表内欠息
    ,nvl(n.over_out_intst, o.over_out_intst) as over_out_intst -- 表外欠息
    ,nvl(n.org_num, o.org_num) as org_num -- 登记机构号
    ,nvl(n.credit_beg_date, o.credit_beg_date) as credit_beg_date -- 授信起始日期
    ,nvl(n.credit_end_date, o.credit_end_date) as credit_end_date -- 授信到期日期
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 借据起始日期
    ,nvl(n.overdue_date, o.overdue_date) as overdue_date -- 首次逾期日期
    ,nvl(n.over_amt_date, o.over_amt_date) as over_amt_date -- 本金逾期日期
    ,nvl(n.over_intst_date, o.over_intst_date) as over_intst_date -- 利息逾期日期
    ,nvl(n.cur_payment_amt, o.cur_payment_amt) as cur_payment_amt -- 当期应还本金
    ,nvl(n.cur_payment_intst, o.cur_payment_intst) as cur_payment_intst -- 当期应还利息
    ,nvl(n.dzhx_status, o.dzhx_status) as dzhx_status -- 客户核销状态
    ,nvl(n.five_sts, o.five_sts) as five_sts -- 五级分类状态
    ,nvl(n.five_level_class_des, o.five_level_class_des) as five_level_class_des -- 五级分类状态描述
    ,nvl(n.loan_id, o.loan_id) as loan_id -- 进件ID
    ,nvl(n.over_due_days, o.over_due_days) as over_due_days -- 当前逾期天数
    ,nvl(n.write_off_date, o.write_off_date) as write_off_date -- 核销日期
    ,nvl(n.write_off_amount, o.write_off_amount) as write_off_amount -- 核销金额
    ,nvl(n.financial_number, o.financial_number) as financial_number -- 财务机构编号
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.hgls_loan_borrow_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_loan_borrow_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.ent_name <> n.ent_name
        or o.credit_code <> n.credit_code
        or o.id_card_no <> n.id_card_no
        or o.prd_type <> n.prd_type
        or o.prd_code <> n.prd_code
        or o.req_code <> n.req_code
        or o.repayment_period <> n.repayment_period
        or o.repayment_kind <> n.repayment_kind
        or o.daily_rate <> n.daily_rate
        or o.repayment_date <> n.repayment_date
        or o.account_id <> n.account_id
        or o.bank_no <> n.bank_no
        or o.bank_name <> n.bank_name
        or o.borrow_use <> n.borrow_use
        or o.borrow_money <> n.borrow_money
        or o.lend_money <> n.lend_money
        or o.borrow_interest <> n.borrow_interest
        or o.loan_status <> n.loan_status
        or o.is_cancel <> n.is_cancel
        or o.reject_reason <> n.reject_reason
        or o.survey_user_id <> n.survey_user_id
        or o.approver_user_id <> n.approver_user_id
        or o.approver_user_name <> n.approver_user_name
        or o.make_loan_user_id <> n.make_loan_user_id
        or o.make_loan_date <> n.make_loan_date
        or o.close_account_user_id <> n.close_account_user_id
        or o.enterprise_code <> n.enterprise_code
        or o.examiner_ids <> n.examiner_ids
        or o.auditor_ids <> n.auditor_ids
        or o.audit_num <> n.audit_num
        or o.examine_num <> n.examine_num
        or o.is_fk_sync <> n.is_fk_sync
        or o.is_jq_sync <> n.is_jq_sync
        or o.loan_balance <> n.loan_balance
        or o.is_apply_letter <> n.is_apply_letter
        or o.apply_letter_date <> n.apply_letter_date
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.is_mortgage <> n.is_mortgage
        or o.isdel <> n.isdel
        or o.label <> n.label
        or o.back_msg <> n.back_msg
        or o.code <> n.code
        or o.back_pages <> n.back_pages
        or o.branch_code <> n.branch_code
        or o.whether_type <> n.whether_type
        or o.loan_no <> n.loan_no
        or o.loan_type <> n.loan_type
        or o.year_rate <> n.year_rate
        or o.prd_name <> n.prd_name
        or o.pact_amt <> n.pact_amt
        or o.end_date <> n.end_date
        or o.settle_date <> n.settle_date
        or o.credit_pact_no <> n.credit_pact_no
        or o.loan_pact_no <> n.loan_pact_no
        or o.ac_id <> n.ac_id
        or o.over_amt <> n.over_amt
        or o.ovre_in_intst <> n.ovre_in_intst
        or o.over_out_intst <> n.over_out_intst
        or o.org_num <> n.org_num
        or o.credit_beg_date <> n.credit_beg_date
        or o.credit_end_date <> n.credit_end_date
        or o.beg_date <> n.beg_date
        or o.overdue_date <> n.overdue_date
        or o.over_amt_date <> n.over_amt_date
        or o.over_intst_date <> n.over_intst_date
        or o.cur_payment_amt <> n.cur_payment_amt
        or o.cur_payment_intst <> n.cur_payment_intst
        or o.dzhx_status <> n.dzhx_status
        or o.five_sts <> n.five_sts
        or o.five_level_class_des <> n.five_level_class_des
        or o.loan_id <> n.loan_id
        or o.over_due_days <> n.over_due_days
        or o.write_off_date <> n.write_off_date
        or o.write_off_amount <> n.write_off_amount
        or o.financial_number <> n.financial_number
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_borrow_info_cl(
            id -- 主键id
            ,cust_id -- 借款人id
            ,cust_name -- 用户姓名
            ,ent_name -- 企业名称
            ,credit_code -- 企业统一社会信用代码
            ,id_card_no -- 身份证号码
            ,prd_type -- 产品类型，字典值cplx
            ,prd_code -- 借款对应的产品编码
            ,req_code -- 借款对应的进件编码
            ,repayment_period -- 还款期数
            ,repayment_kind -- 还款方式
            ,daily_rate -- 日利率，万分之一
            ,repayment_date -- 首月还款日
            ,account_id -- 收款账户id
            ,bank_no -- 银行卡号
            ,bank_name -- 银行名称
            ,borrow_use -- 借款用途
            ,borrow_money -- 借款金额，元
            ,lend_money -- 实际放款金额
            ,borrow_interest -- 借款总利息，元
            ,loan_status -- 借款状态，1待审批2审批通过3审批拒绝4已放款5已结清7待审查8逾期
            ,is_cancel -- 贷款是否取消，0否1是
            ,reject_reason -- 审批拒绝原因
            ,survey_user_id -- 调查员id
            ,approver_user_id -- 审批人ID
            ,approver_user_name -- 审批人名字
            ,make_loan_user_id -- 放款人id
            ,make_loan_date -- 申请日期
            ,close_account_user_id -- 结清人id
            ,enterprise_code -- 企业注册码
            ,examiner_ids -- 审查者id
            ,auditor_ids -- 审批者id
            ,audit_num -- 审批人数
            ,examine_num -- 审查人数
            ,is_fk_sync -- 是否放款同步
            ,is_jq_sync -- 是否结清同步
            ,loan_balance -- 贷款余额（本金），单位元
            ,is_apply_letter -- 是否申请用信，0否1是
            ,apply_letter_date -- 申请用信时间
            ,create_date -- 创建时间
            ,update_date -- 更新时间
            ,is_mortgage -- 是否抵押完成
            ,isdel -- 删除标识
            ,label -- 标签状态
            ,back_msg -- 驳回原因
            ,code -- 借款表内码
            ,back_pages -- 驳回页面（补充资料类型：1，申请信息，2，视频信息）多选逗号隔开
            ,branch_code -- 支行code
            ,whether_type -- 随借随还类型:A，综合授信；B，富民卡
            ,loan_no -- 借据编号
            ,loan_type -- 贷款类型:1.微贷 2.信贷
            ,year_rate -- 年利率
            ,prd_name -- 授信产品名称
            ,pact_amt -- 授信额度
            ,end_date -- 到期日期
            ,settle_date -- 结清日期
            ,credit_pact_no -- 授信合同号
            ,loan_pact_no -- 授信合同号
            ,ac_id -- 贷款账户ID（借据号）
            ,over_amt -- 逾期本金
            ,ovre_in_intst -- 表内欠息
            ,over_out_intst -- 表外欠息
            ,org_num -- 登记机构号
            ,credit_beg_date -- 授信起始日期
            ,credit_end_date -- 授信到期日期
            ,beg_date -- 借据起始日期
            ,overdue_date -- 首次逾期日期
            ,over_amt_date -- 本金逾期日期
            ,over_intst_date -- 利息逾期日期
            ,cur_payment_amt -- 当期应还本金
            ,cur_payment_intst -- 当期应还利息
            ,dzhx_status -- 客户核销状态
            ,five_sts -- 五级分类状态
            ,five_level_class_des -- 五级分类状态描述
            ,loan_id -- 进件ID
            ,over_due_days -- 当前逾期天数
            ,write_off_date -- 核销日期
            ,write_off_amount -- 核销金额
            ,financial_number -- 财务机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_borrow_info_op(
            id -- 主键id
            ,cust_id -- 借款人id
            ,cust_name -- 用户姓名
            ,ent_name -- 企业名称
            ,credit_code -- 企业统一社会信用代码
            ,id_card_no -- 身份证号码
            ,prd_type -- 产品类型，字典值cplx
            ,prd_code -- 借款对应的产品编码
            ,req_code -- 借款对应的进件编码
            ,repayment_period -- 还款期数
            ,repayment_kind -- 还款方式
            ,daily_rate -- 日利率，万分之一
            ,repayment_date -- 首月还款日
            ,account_id -- 收款账户id
            ,bank_no -- 银行卡号
            ,bank_name -- 银行名称
            ,borrow_use -- 借款用途
            ,borrow_money -- 借款金额，元
            ,lend_money -- 实际放款金额
            ,borrow_interest -- 借款总利息，元
            ,loan_status -- 借款状态，1待审批2审批通过3审批拒绝4已放款5已结清7待审查8逾期
            ,is_cancel -- 贷款是否取消，0否1是
            ,reject_reason -- 审批拒绝原因
            ,survey_user_id -- 调查员id
            ,approver_user_id -- 审批人ID
            ,approver_user_name -- 审批人名字
            ,make_loan_user_id -- 放款人id
            ,make_loan_date -- 申请日期
            ,close_account_user_id -- 结清人id
            ,enterprise_code -- 企业注册码
            ,examiner_ids -- 审查者id
            ,auditor_ids -- 审批者id
            ,audit_num -- 审批人数
            ,examine_num -- 审查人数
            ,is_fk_sync -- 是否放款同步
            ,is_jq_sync -- 是否结清同步
            ,loan_balance -- 贷款余额（本金），单位元
            ,is_apply_letter -- 是否申请用信，0否1是
            ,apply_letter_date -- 申请用信时间
            ,create_date -- 创建时间
            ,update_date -- 更新时间
            ,is_mortgage -- 是否抵押完成
            ,isdel -- 删除标识
            ,label -- 标签状态
            ,back_msg -- 驳回原因
            ,code -- 借款表内码
            ,back_pages -- 驳回页面（补充资料类型：1，申请信息，2，视频信息）多选逗号隔开
            ,branch_code -- 支行code
            ,whether_type -- 随借随还类型:A，综合授信；B，富民卡
            ,loan_no -- 借据编号
            ,loan_type -- 贷款类型:1.微贷 2.信贷
            ,year_rate -- 年利率
            ,prd_name -- 授信产品名称
            ,pact_amt -- 授信额度
            ,end_date -- 到期日期
            ,settle_date -- 结清日期
            ,credit_pact_no -- 授信合同号
            ,loan_pact_no -- 授信合同号
            ,ac_id -- 贷款账户ID（借据号）
            ,over_amt -- 逾期本金
            ,ovre_in_intst -- 表内欠息
            ,over_out_intst -- 表外欠息
            ,org_num -- 登记机构号
            ,credit_beg_date -- 授信起始日期
            ,credit_end_date -- 授信到期日期
            ,beg_date -- 借据起始日期
            ,overdue_date -- 首次逾期日期
            ,over_amt_date -- 本金逾期日期
            ,over_intst_date -- 利息逾期日期
            ,cur_payment_amt -- 当期应还本金
            ,cur_payment_intst -- 当期应还利息
            ,dzhx_status -- 客户核销状态
            ,five_sts -- 五级分类状态
            ,five_level_class_des -- 五级分类状态描述
            ,loan_id -- 进件ID
            ,over_due_days -- 当前逾期天数
            ,write_off_date -- 核销日期
            ,write_off_amount -- 核销金额
            ,financial_number -- 财务机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键id
    ,o.cust_id -- 借款人id
    ,o.cust_name -- 用户姓名
    ,o.ent_name -- 企业名称
    ,o.credit_code -- 企业统一社会信用代码
    ,o.id_card_no -- 身份证号码
    ,o.prd_type -- 产品类型，字典值cplx
    ,o.prd_code -- 借款对应的产品编码
    ,o.req_code -- 借款对应的进件编码
    ,o.repayment_period -- 还款期数
    ,o.repayment_kind -- 还款方式
    ,o.daily_rate -- 日利率，万分之一
    ,o.repayment_date -- 首月还款日
    ,o.account_id -- 收款账户id
    ,o.bank_no -- 银行卡号
    ,o.bank_name -- 银行名称
    ,o.borrow_use -- 借款用途
    ,o.borrow_money -- 借款金额，元
    ,o.lend_money -- 实际放款金额
    ,o.borrow_interest -- 借款总利息，元
    ,o.loan_status -- 借款状态，1待审批2审批通过3审批拒绝4已放款5已结清7待审查8逾期
    ,o.is_cancel -- 贷款是否取消，0否1是
    ,o.reject_reason -- 审批拒绝原因
    ,o.survey_user_id -- 调查员id
    ,o.approver_user_id -- 审批人ID
    ,o.approver_user_name -- 审批人名字
    ,o.make_loan_user_id -- 放款人id
    ,o.make_loan_date -- 申请日期
    ,o.close_account_user_id -- 结清人id
    ,o.enterprise_code -- 企业注册码
    ,o.examiner_ids -- 审查者id
    ,o.auditor_ids -- 审批者id
    ,o.audit_num -- 审批人数
    ,o.examine_num -- 审查人数
    ,o.is_fk_sync -- 是否放款同步
    ,o.is_jq_sync -- 是否结清同步
    ,o.loan_balance -- 贷款余额（本金），单位元
    ,o.is_apply_letter -- 是否申请用信，0否1是
    ,o.apply_letter_date -- 申请用信时间
    ,o.create_date -- 创建时间
    ,o.update_date -- 更新时间
    ,o.is_mortgage -- 是否抵押完成
    ,o.isdel -- 删除标识
    ,o.label -- 标签状态
    ,o.back_msg -- 驳回原因
    ,o.code -- 借款表内码
    ,o.back_pages -- 驳回页面（补充资料类型：1，申请信息，2，视频信息）多选逗号隔开
    ,o.branch_code -- 支行code
    ,o.whether_type -- 随借随还类型:A，综合授信；B，富民卡
    ,o.loan_no -- 借据编号
    ,o.loan_type -- 贷款类型:1.微贷 2.信贷
    ,o.year_rate -- 年利率
    ,o.prd_name -- 授信产品名称
    ,o.pact_amt -- 授信额度
    ,o.end_date -- 到期日期
    ,o.settle_date -- 结清日期
    ,o.credit_pact_no -- 授信合同号
    ,o.loan_pact_no -- 授信合同号
    ,o.ac_id -- 贷款账户ID（借据号）
    ,o.over_amt -- 逾期本金
    ,o.ovre_in_intst -- 表内欠息
    ,o.over_out_intst -- 表外欠息
    ,o.org_num -- 登记机构号
    ,o.credit_beg_date -- 授信起始日期
    ,o.credit_end_date -- 授信到期日期
    ,o.beg_date -- 借据起始日期
    ,o.overdue_date -- 首次逾期日期
    ,o.over_amt_date -- 本金逾期日期
    ,o.over_intst_date -- 利息逾期日期
    ,o.cur_payment_amt -- 当期应还本金
    ,o.cur_payment_intst -- 当期应还利息
    ,o.dzhx_status -- 客户核销状态
    ,o.five_sts -- 五级分类状态
    ,o.five_level_class_des -- 五级分类状态描述
    ,o.loan_id -- 进件ID
    ,o.over_due_days -- 当前逾期天数
    ,o.write_off_date -- 核销日期
    ,o.write_off_amount -- 核销金额
    ,o.financial_number -- 财务机构编号
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
from ${iol_schema}.hgls_loan_borrow_info_bk o
    left join ${iol_schema}.hgls_loan_borrow_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_loan_borrow_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.hgls_loan_borrow_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_loan_borrow_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_loan_borrow_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_loan_borrow_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_loan_borrow_info exchange partition p_${batch_date} with table ${iol_schema}.hgls_loan_borrow_info_cl;
alter table ${iol_schema}.hgls_loan_borrow_info exchange partition p_20991231 with table ${iol_schema}.hgls_loan_borrow_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_loan_borrow_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_borrow_info_op purge;
drop table ${iol_schema}.hgls_loan_borrow_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_loan_borrow_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_loan_borrow_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
