/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol hgls_loan_borrow_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.hgls_loan_borrow_info
whenever sqlerror continue none;
drop table ${iol_schema}.hgls_loan_borrow_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_borrow_info(
    id number(22,0) -- 主键id
    ,cust_id number(22,0) -- 借款人id
    ,cust_name varchar2(4000) -- 用户姓名
    ,ent_name varchar2(4000) -- 企业名称
    ,credit_code varchar2(4000) -- 企业统一社会信用代码
    ,id_card_no varchar2(4000) -- 身份证号码
    ,prd_type number(22,0) -- 产品类型，字典值cplx
    ,prd_code varchar2(4000) -- 借款对应的产品编码
    ,req_code varchar2(4000) -- 借款对应的进件编码
    ,repayment_period number(22,0) -- 还款期数
    ,repayment_kind varchar2(4000) -- 还款方式
    ,daily_rate number(38,8) -- 日利率，万分之一
    ,repayment_date date -- 首月还款日
    ,account_id number(22,0) -- 收款账户id
    ,bank_no varchar2(4000) -- 银行卡号
    ,bank_name varchar2(4000) -- 银行名称
    ,borrow_use varchar2(4000) -- 借款用途
    ,borrow_money number(38,8) -- 借款金额，元
    ,lend_money number(38,8) -- 实际放款金额
    ,borrow_interest number(38,8) -- 借款总利息，元
    ,loan_status varchar2(4000) -- 借款状态，1待审批2审批通过3审批拒绝4已放款5已结清7待审查8逾期
    ,is_cancel number(22,0) -- 贷款是否取消，0否1是
    ,reject_reason varchar2(4000) -- 审批拒绝原因
    ,survey_user_id number(22,0) -- 调查员id
    ,approver_user_id number(22,0) -- 审批人ID
    ,approver_user_name varchar2(4000) -- 审批人名字
    ,make_loan_user_id number(22,0) -- 放款人id
    ,make_loan_date timestamp -- 申请日期
    ,close_account_user_id number(22,0) -- 结清人id
    ,enterprise_code varchar2(4000) -- 企业注册码
    ,examiner_ids varchar2(4000) -- 审查者id
    ,auditor_ids varchar2(4000) -- 审批者id
    ,audit_num number(22,0) -- 审批人数
    ,examine_num number(22,0) -- 审查人数
    ,is_fk_sync number(22,0) -- 是否放款同步
    ,is_jq_sync number(22,0) -- 是否结清同步
    ,loan_balance number(38,8) -- 贷款余额（本金），单位元
    ,is_apply_letter number(22,0) -- 是否申请用信，0否1是
    ,apply_letter_date timestamp -- 申请用信时间
    ,create_date timestamp -- 创建时间
    ,update_date timestamp -- 更新时间
    ,is_mortgage number(22,0) -- 是否抵押完成
    ,isdel number(22,0) -- 删除标识
    ,label varchar2(4000) -- 标签状态
    ,back_msg varchar2(4000) -- 驳回原因
    ,code varchar2(4000) -- 借款表内码
    ,back_pages varchar2(4000) -- 驳回页面（补充资料类型：1，申请信息，2，视频信息）多选逗号隔开
    ,branch_code varchar2(4000) -- 支行code
    ,whether_type varchar2(4000) -- 随借随还类型:A，综合授信；B，富民卡
    ,loan_no varchar2(4000) -- 借据编号
    ,loan_type varchar2(4000) -- 贷款类型:1.微贷 2.信贷
    ,year_rate number(38,8) -- 年利率
    ,prd_name varchar2(4000) -- 授信产品名称
    ,pact_amt number(38,8) -- 授信额度
    ,end_date timestamp -- 到期日期
    ,settle_date timestamp -- 结清日期
    ,credit_pact_no varchar2(4000) -- 授信合同号
    ,loan_pact_no varchar2(4000) -- 授信合同号
    ,ac_id varchar2(4000) -- 贷款账户ID（借据号）
    ,over_amt number(38,8) -- 逾期本金
    ,ovre_in_intst number(38,8) -- 表内欠息
    ,over_out_intst number(38,8) -- 表外欠息
    ,org_num varchar2(4000) -- 登记机构号
    ,credit_beg_date timestamp -- 授信起始日期
    ,credit_end_date timestamp -- 授信到期日期
    ,beg_date timestamp -- 借据起始日期
    ,overdue_date varchar2(4000) -- 首次逾期日期
    ,over_amt_date timestamp -- 本金逾期日期
    ,over_intst_date timestamp -- 利息逾期日期
    ,cur_payment_amt number(38,8) -- 当期应还本金
    ,cur_payment_intst number(38,8) -- 当期应还利息
    ,dzhx_status varchar2(4000) -- 客户核销状态
    ,five_sts varchar2(4000) -- 五级分类状态
    ,five_level_class_des varchar2(4000) -- 五级分类状态描述
    ,loan_id number(22,0) -- 进件ID
    ,over_due_days number(22,0) -- 当前逾期天数
    ,write_off_date timestamp -- 核销日期
    ,write_off_amount number(38,8) -- 核销金额
    ,financial_number varchar2(4000) -- 财务机构编号
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
grant select on ${iol_schema}.hgls_loan_borrow_info to ${iml_schema};
grant select on ${iol_schema}.hgls_loan_borrow_info to ${icl_schema};
grant select on ${iol_schema}.hgls_loan_borrow_info to ${idl_schema};
grant select on ${iol_schema}.hgls_loan_borrow_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.hgls_loan_borrow_info is '借据信息表';
comment on column ${iol_schema}.hgls_loan_borrow_info.id is '主键id';
comment on column ${iol_schema}.hgls_loan_borrow_info.cust_id is '借款人id';
comment on column ${iol_schema}.hgls_loan_borrow_info.cust_name is '用户姓名';
comment on column ${iol_schema}.hgls_loan_borrow_info.ent_name is '企业名称';
comment on column ${iol_schema}.hgls_loan_borrow_info.credit_code is '企业统一社会信用代码';
comment on column ${iol_schema}.hgls_loan_borrow_info.id_card_no is '身份证号码';
comment on column ${iol_schema}.hgls_loan_borrow_info.prd_type is '产品类型，字典值cplx';
comment on column ${iol_schema}.hgls_loan_borrow_info.prd_code is '借款对应的产品编码';
comment on column ${iol_schema}.hgls_loan_borrow_info.req_code is '借款对应的进件编码';
comment on column ${iol_schema}.hgls_loan_borrow_info.repayment_period is '还款期数';
comment on column ${iol_schema}.hgls_loan_borrow_info.repayment_kind is '还款方式';
comment on column ${iol_schema}.hgls_loan_borrow_info.daily_rate is '日利率，万分之一';
comment on column ${iol_schema}.hgls_loan_borrow_info.repayment_date is '首月还款日';
comment on column ${iol_schema}.hgls_loan_borrow_info.account_id is '收款账户id';
comment on column ${iol_schema}.hgls_loan_borrow_info.bank_no is '银行卡号';
comment on column ${iol_schema}.hgls_loan_borrow_info.bank_name is '银行名称';
comment on column ${iol_schema}.hgls_loan_borrow_info.borrow_use is '借款用途';
comment on column ${iol_schema}.hgls_loan_borrow_info.borrow_money is '借款金额，元';
comment on column ${iol_schema}.hgls_loan_borrow_info.lend_money is '实际放款金额';
comment on column ${iol_schema}.hgls_loan_borrow_info.borrow_interest is '借款总利息，元';
comment on column ${iol_schema}.hgls_loan_borrow_info.loan_status is '借款状态，1待审批2审批通过3审批拒绝4已放款5已结清7待审查8逾期';
comment on column ${iol_schema}.hgls_loan_borrow_info.is_cancel is '贷款是否取消，0否1是';
comment on column ${iol_schema}.hgls_loan_borrow_info.reject_reason is '审批拒绝原因';
comment on column ${iol_schema}.hgls_loan_borrow_info.survey_user_id is '调查员id';
comment on column ${iol_schema}.hgls_loan_borrow_info.approver_user_id is '审批人ID';
comment on column ${iol_schema}.hgls_loan_borrow_info.approver_user_name is '审批人名字';
comment on column ${iol_schema}.hgls_loan_borrow_info.make_loan_user_id is '放款人id';
comment on column ${iol_schema}.hgls_loan_borrow_info.make_loan_date is '申请日期';
comment on column ${iol_schema}.hgls_loan_borrow_info.close_account_user_id is '结清人id';
comment on column ${iol_schema}.hgls_loan_borrow_info.enterprise_code is '企业注册码';
comment on column ${iol_schema}.hgls_loan_borrow_info.examiner_ids is '审查者id';
comment on column ${iol_schema}.hgls_loan_borrow_info.auditor_ids is '审批者id';
comment on column ${iol_schema}.hgls_loan_borrow_info.audit_num is '审批人数';
comment on column ${iol_schema}.hgls_loan_borrow_info.examine_num is '审查人数';
comment on column ${iol_schema}.hgls_loan_borrow_info.is_fk_sync is '是否放款同步';
comment on column ${iol_schema}.hgls_loan_borrow_info.is_jq_sync is '是否结清同步';
comment on column ${iol_schema}.hgls_loan_borrow_info.loan_balance is '贷款余额（本金），单位元';
comment on column ${iol_schema}.hgls_loan_borrow_info.is_apply_letter is '是否申请用信，0否1是';
comment on column ${iol_schema}.hgls_loan_borrow_info.apply_letter_date is '申请用信时间';
comment on column ${iol_schema}.hgls_loan_borrow_info.create_date is '创建时间';
comment on column ${iol_schema}.hgls_loan_borrow_info.update_date is '更新时间';
comment on column ${iol_schema}.hgls_loan_borrow_info.is_mortgage is '是否抵押完成';
comment on column ${iol_schema}.hgls_loan_borrow_info.isdel is '删除标识';
comment on column ${iol_schema}.hgls_loan_borrow_info.label is '标签状态';
comment on column ${iol_schema}.hgls_loan_borrow_info.back_msg is '驳回原因';
comment on column ${iol_schema}.hgls_loan_borrow_info.code is '借款表内码';
comment on column ${iol_schema}.hgls_loan_borrow_info.back_pages is '驳回页面（补充资料类型：1，申请信息，2，视频信息）多选逗号隔开';
comment on column ${iol_schema}.hgls_loan_borrow_info.branch_code is '支行code';
comment on column ${iol_schema}.hgls_loan_borrow_info.whether_type is '随借随还类型:A，综合授信；B，富民卡';
comment on column ${iol_schema}.hgls_loan_borrow_info.loan_no is '借据编号';
comment on column ${iol_schema}.hgls_loan_borrow_info.loan_type is '贷款类型:1.微贷 2.信贷';
comment on column ${iol_schema}.hgls_loan_borrow_info.year_rate is '年利率';
comment on column ${iol_schema}.hgls_loan_borrow_info.prd_name is '授信产品名称';
comment on column ${iol_schema}.hgls_loan_borrow_info.pact_amt is '授信额度';
comment on column ${iol_schema}.hgls_loan_borrow_info.end_date is '到期日期';
comment on column ${iol_schema}.hgls_loan_borrow_info.settle_date is '结清日期';
comment on column ${iol_schema}.hgls_loan_borrow_info.credit_pact_no is '授信合同号';
comment on column ${iol_schema}.hgls_loan_borrow_info.loan_pact_no is '授信合同号';
comment on column ${iol_schema}.hgls_loan_borrow_info.ac_id is '贷款账户ID（借据号）';
comment on column ${iol_schema}.hgls_loan_borrow_info.over_amt is '逾期本金';
comment on column ${iol_schema}.hgls_loan_borrow_info.ovre_in_intst is '表内欠息';
comment on column ${iol_schema}.hgls_loan_borrow_info.over_out_intst is '表外欠息';
comment on column ${iol_schema}.hgls_loan_borrow_info.org_num is '登记机构号';
comment on column ${iol_schema}.hgls_loan_borrow_info.credit_beg_date is '授信起始日期';
comment on column ${iol_schema}.hgls_loan_borrow_info.credit_end_date is '授信到期日期';
comment on column ${iol_schema}.hgls_loan_borrow_info.beg_date is '借据起始日期';
comment on column ${iol_schema}.hgls_loan_borrow_info.overdue_date is '首次逾期日期';
comment on column ${iol_schema}.hgls_loan_borrow_info.over_amt_date is '本金逾期日期';
comment on column ${iol_schema}.hgls_loan_borrow_info.over_intst_date is '利息逾期日期';
comment on column ${iol_schema}.hgls_loan_borrow_info.cur_payment_amt is '当期应还本金';
comment on column ${iol_schema}.hgls_loan_borrow_info.cur_payment_intst is '当期应还利息';
comment on column ${iol_schema}.hgls_loan_borrow_info.dzhx_status is '客户核销状态';
comment on column ${iol_schema}.hgls_loan_borrow_info.five_sts is '五级分类状态';
comment on column ${iol_schema}.hgls_loan_borrow_info.five_level_class_des is '五级分类状态描述';
comment on column ${iol_schema}.hgls_loan_borrow_info.loan_id is '进件ID';
comment on column ${iol_schema}.hgls_loan_borrow_info.over_due_days is '当前逾期天数';
comment on column ${iol_schema}.hgls_loan_borrow_info.write_off_date is '核销日期';
comment on column ${iol_schema}.hgls_loan_borrow_info.write_off_amount is '核销金额';
comment on column ${iol_schema}.hgls_loan_borrow_info.financial_number is '财务机构编号';
comment on column ${iol_schema}.hgls_loan_borrow_info.start_dt is '开始时间';
comment on column ${iol_schema}.hgls_loan_borrow_info.end_dt is '结束时间';
comment on column ${iol_schema}.hgls_loan_borrow_info.id_mark is '增删标志';
comment on column ${iol_schema}.hgls_loan_borrow_info.etl_timestamp is 'ETL处理时间戳';
