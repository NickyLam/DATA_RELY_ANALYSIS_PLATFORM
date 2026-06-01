/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_hgls_loan_borrow_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_hgls_loan_borrow_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_hgls_loan_borrow_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_hgls_loan_borrow_info(
  id                    NUMBER(11) not null,
  cust_id               NUMBER(11),
  cust_name             VARCHAR2(360),
  ent_name              VARCHAR2(400),
  credit_code           VARCHAR2(200),
  id_card_no            VARCHAR2(216),
  prd_type              NUMBER(11),
  prd_code              VARCHAR2(480),
  req_code              VARCHAR2(480),
  repayment_period      NUMBER(11),
  repayment_kind        VARCHAR2(24),
  daily_rate            NUMBER(6,4),
  repayment_date        DATE,
  account_id            NUMBER(11),
  bank_no               VARCHAR2(240),
  bank_name             VARCHAR2(240),
  borrow_use            VARCHAR2(120),
  borrow_money          NUMBER(13,2),
  lend_money            NUMBER(13,2),
  borrow_interest       NUMBER(18,2),
  loan_status           VARCHAR2(24),
  is_cancel             VARCHAR2(16),
  reject_reason         VARCHAR2(1200),
  survey_user_id        NUMBER(11),
  approver_user_id      NUMBER(11),
  approver_user_name    VARCHAR2(300),
  make_loan_user_id     NUMBER(11),
  make_loan_date        TIMESTAMP(6),
  close_account_user_id NUMBER(11),
  enterprise_code       VARCHAR2(120),
  examiner_ids          VARCHAR2(3060),
  auditor_ids           VARCHAR2(3060),
  audit_num             NUMBER(11),
  examine_num           NUMBER(11),
  is_fk_sync            VARCHAR2(16),
  is_jq_sync            VARCHAR2(16),
  loan_balance          NUMBER(18,2),
  is_apply_letter       VARCHAR2(16),
  apply_letter_date     TIMESTAMP(6),
  create_date           TIMESTAMP(6),
  update_date           TIMESTAMP(6),
  is_mortgage           VARCHAR2(16),
  isdel                 VARCHAR2(16),
  label                 VARCHAR2(1200),
  back_msg              CLOB,
  code                  VARCHAR2(480),
  back_pages            VARCHAR2(120),
  branch_code           VARCHAR2(600),
  whether_type          VARCHAR2(24),
  loan_no               VARCHAR2(480),
  loan_type             VARCHAR2(24),
  year_rate             NUMBER(10,4),
  prd_name              VARCHAR2(768),
  pact_amt              NUMBER(22,2),
  end_date              TIMESTAMP(6),
  settle_date           TIMESTAMP(6),
  credit_pact_no        VARCHAR2(360),
  loan_pact_no          VARCHAR2(360),
  ac_id                 VARCHAR2(288),
  over_amt              NUMBER(22,2),
  ovre_in_intst         NUMBER(22,2),
  over_out_intst        NUMBER(22,2),
  org_num               VARCHAR2(240),
  credit_beg_date       TIMESTAMP(6),
  credit_end_date       TIMESTAMP(6),
  beg_date              TIMESTAMP(6),
  overdue_date          VARCHAR2(120),
  over_amt_date         TIMESTAMP(6),
  over_intst_date       TIMESTAMP(6),
  cur_payment_amt       NUMBER(22,2),
  cur_payment_intst     NUMBER(22,2),
  dzhx_status           VARCHAR2(40),
  five_sts              VARCHAR2(12),
  five_level_class_des  VARCHAR2(120),
  loan_id               NUMBER(11),
  over_due_days         NUMBER(11),
  write_off_date        TIMESTAMP(6),
  write_off_amount      NUMBER(30,2),
  financial_number      VARCHAR2(510)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_hgls_loan_borrow_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_hgls_loan_borrow_info is '借据管理表';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.ID is '主键id';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CUST_ID is '借款人id';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CUST_NAME is '用户姓名';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.ENT_NAME is '企业名称';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CREDIT_CODE is '企业统一社会信用代码';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.ID_CARD_NO is '身份证号码';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.PRD_TYPE is '产品类型，字典值cplx';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.PRD_CODE is '借款对应的产品编码';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.REQ_CODE is '借款对应的进件编码';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.REPAYMENT_PERIOD is '还款期数';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.REPAYMENT_KIND is '还款方式';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.DAILY_RATE is '日利率，万分之一';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.REPAYMENT_DATE is '首月还款日';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.ACCOUNT_ID is '收款账户id';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.BANK_NO is '银行卡号';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.BANK_NAME is '银行名称';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.BORROW_USE is '借款用途';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.BORROW_MONEY is '借款金额，元';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.LEND_MONEY is '实际放款金额';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.BORROW_INTEREST is '借款总利息，元';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.LOAN_STATUS is '借款状态，1待审批2审批通过3审批拒绝4已放款5已结清7待审查8逾期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.IS_CANCEL is '贷款是否取消，0否1是';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.REJECT_REASON is '审批拒绝原因';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.SURVEY_USER_ID is '调查员id';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.APPROVER_USER_ID is '审批人ID';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.APPROVER_USER_NAME is '审批人名字';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.MAKE_LOAN_USER_ID is '放款人id';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.MAKE_LOAN_DATE is '申请日期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CLOSE_ACCOUNT_USER_ID is '结清人id';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.ENTERPRISE_CODE is '企业注册码';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.EXAMINER_IDS is '审查者id';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.AUDITOR_IDS is '审批者id';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.AUDIT_NUM is '审批人数';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.EXAMINE_NUM is '审查人数';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.IS_FK_SYNC is '是否放款同步';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.IS_JQ_SYNC is '是否结清同步';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.LOAN_BALANCE is '贷款余额（本金），单位元';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.IS_APPLY_LETTER is '是否申请用信，0否1是';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.APPLY_LETTER_DATE is '申请用信时间';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CREATE_DATE is '创建时间';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.UPDATE_DATE is '更新时间';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.IS_MORTGAGE is '是否抵押完成';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.ISDEL is '删除标识';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.LABEL is '标签状态';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.BACK_MSG is '驳回原因';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CODE is '借款表内码';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.BACK_PAGES is '驳回页面（补充资料类型：1，申请信息，2，视频信息）多选逗号隔开';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.BRANCH_CODE is '支行code';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.WHETHER_TYPE is '随借随还类型:A，综合授信；B，富民卡';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.LOAN_NO is '借据编号';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.LOAN_TYPE is '贷款类型:1.微贷 2.信贷';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.YEAR_RATE is '年利率';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.PRD_NAME is '授信产品名称';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.PACT_AMT is '授信额度';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.END_DATE is '到期日期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.SETTLE_DATE is '结清日期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CREDIT_PACT_NO is '授信合同号';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.LOAN_PACT_NO is '授信合同号';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.AC_ID is '贷款账户ID（借据号）';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.OVER_AMT is '逾期本金';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.OVRE_IN_INTST is '表内欠息';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.OVER_OUT_INTST is '表外欠息';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.ORG_NUM is '登记机构号';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CREDIT_BEG_DATE is '授信起始日期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CREDIT_END_DATE is '授信到期日期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.BEG_DATE is '借据起始日期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.OVERDUE_DATE is '首次逾期日期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.OVER_AMT_DATE is '本金逾期日期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.OVER_INTST_DATE is '利息逾期日期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CUR_PAYMENT_AMT is '当期应还本金';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.CUR_PAYMENT_INTST is '当期应还利息';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.DZHX_STATUS is '客户核销状态';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.FIVE_STS is '五级分类状态';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.FIVE_LEVEL_CLASS_DES is '五级分类状态描述';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.LOAN_ID is '进件ID';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.OVER_DUE_DAYS is '当前逾期天数';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.WRITE_OFF_DATE is '核销日期';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.WRITE_OFF_AMOUNT is '核销金额';
comment on column ${msl_schema}.msl_hgls_loan_borrow_info.FINANCIAL_NUMBER is '财务机构编号';
alter table ${msl_schema}.msl_hgls_loan_borrow_info add primary key (ID);
