/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_hgls_loan_req_audit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_hgls_loan_req_audit
whenever sqlerror continue none;
drop table ${msl_schema}.msl_hgls_loan_req_audit purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_hgls_loan_req_audit(
  audit_id             NUMBER(11) not null,
  loan_id              NUMBER(11),
  approver_user_id     NUMBER(11),
  approver_user_name   VARCHAR2(300),
  daily_rate           NUMBER(6,4),
  fnl_store            NUMBER(6,2),
  repayment_period     VARCHAR2(120),
  repayment_kind       CLOB,
  auth_money           NUMBER(10,2),
  rank                 VARCHAR2(120),
  audit_status         VARCHAR2(36),
  history_audit_status VARCHAR2(16),
  repulse_reason       CLOB,
  audit_date           TIMESTAMP(6),
  need_escort          VARCHAR2(1),
  credit_guaranty      VARCHAR2(1),
  inquiry_way          VARCHAR2(120),
  credit_company       VARCHAR2(1),
  pledge_type          VARCHAR2(120),
  assess_price         NUMBER(10,2),
  year_rate            NUMBER(10,4),
  resolution           CLOB,
  remark               VARCHAR2(4000),
  custom_capital       VARCHAR2(120),
  allow_one_sign       VARCHAR2(1),
  loan_proof           VARCHAR2(720),
  mark                 VARCHAR2(4000),
  biz_type             NUMBER(11),
  model_frequency      NUMBER(11)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_hgls_loan_req_audit to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_hgls_loan_req_audit is '审批记录表';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.AUDIT_ID is '主键id';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.LOAN_ID is '进件id';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.APPROVER_USER_ID is '审批人ID';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.APPROVER_USER_NAME is '审批人名字';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.DAILY_RATE is '日利率（百分之一）';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.FNL_STORE is '综合授信评分';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.REPAYMENT_PERIOD is '最高返款期数1、3期，2、6期，3、12期，4、24期，5、36期，6、60期，7、120期';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.REPAYMENT_KIND is '还款方式';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.AUTH_MONEY is '授信金额';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.RANK is '评级（A-F）';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.AUDIT_STATUS is '';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.HISTORY_AUDIT_STATUS is '是否历史审批0否，1是';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.REPULSE_REASON is '审批打回原因';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.AUDIT_DATE is '申请日期';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.NEED_ESCORT is '是否需要陪调客户经理';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.CREDIT_GUARANTY is '是否需要担保人';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.INQUIRY_WAY is '调查方式；1，简单，2，一般，3，复杂';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.CREDIT_COMPANY is '是否需要上传征信';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.PLEDGE_TYPE is '抵押分类';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.ASSESS_PRICE is '评估价格';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.YEAR_RATE is '年利率';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.RESOLUTION is '信息复合会办决议';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.REMARK is '会办决议备注';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.CUSTOM_CAPITAL is '是否自定义本金';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.ALLOW_ONE_SIGN is '是否允许单签';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.LOAN_PROOF is '放款凭证';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.MARK is '模型标记信息';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.BIZ_TYPE is '业务类型，0主借人1配偶';
comment on column ${msl_schema}.msl_hgls_loan_req_audit.MODEL_FREQUENCY is '监测周期';
alter table ${msl_schema}.msl_hgls_loan_req_audit add primary key (AUDIT_ID);
