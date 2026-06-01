/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_hgls_loan_branch_website
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_hgls_loan_branch_website
whenever sqlerror continue none;
drop table ${msl_schema}.msl_hgls_loan_branch_website purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_hgls_loan_branch_website(
  id                       NUMBER(11) not null,
  bank_name                VARCHAR2(600),
  bank_phone               VARCHAR2(240),
  province_region          VARCHAR2(600),
  address                  VARCHAR2(3060),
  start_time               VARCHAR2(240),
  end_time                 VARCHAR2(240),
  system_type              VARCHAR2(24),
  enterprise_code          VARCHAR2(120),
  org_num                  VARCHAR2(240),
  busi_cover_area          CLOB,
  create_date              TIMESTAMP(6),
  update_date              TIMESTAMP(6),
  isdel                    VARCHAR2(16),
  code                     VARCHAR2(480),
  bank_credit_accounts     VARCHAR2(1440),
  bank_credit_recheck_user VARCHAR2(1440),
  parent_code              VARCHAR2(480),
  org_type                 VARCHAR2(24),
  org_level                NUMBER(11),
  corporcate_bank_num      VARCHAR2(384),
  corporate_name           VARCHAR2(3060),
  core_org_num             VARCHAR2(240),
  business_label           VARCHAR2(600),
  IS_SHOW                  NUMBER
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_hgls_loan_branch_website to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_hgls_loan_branch_website is '机构管理表';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.ID is '主键id';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.BANK_NAME is '支行名称';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.BANK_PHONE is '支行电话';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.PROVINCE_REGION is '支行住址的省市区,多级斜杠隔开';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.ADDRESS is '支行具体地址';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.START_TIME is '营业开始时间';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.END_TIME is '营业结束时间';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.SYSTEM_TYPE is '系统类型，1，业务系统，2营销系统';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.ENTERPRISE_CODE is '企业注册码';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.ORG_NUM is '机构号';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.BUSI_COVER_AREA is '业务覆盖区域';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.CREATE_DATE is '申请日期';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.UPDATE_DATE is '更新时间';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.ISDEL is '删除标识';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.CODE is '唯一编码';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.BANK_CREDIT_ACCOUNTS is '机构征信查询账户';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.BANK_CREDIT_RECHECK_USER is '机构征信复核用户';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.PARENT_CODE is '上级机构code';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.ORG_TYPE is '机构类型，1：总行2：分行3：支行';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.ORG_LEVEL is '机构层级，总行一级，下级依次递增，最多不超过六级';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.CORPORCATE_BANK_NUM is '法人行行号';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.CORPORATE_NAME is '企业名称（合同用）';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.CORE_ORG_NUM is '核心机构号';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.BUSINESS_LABEL is '行业客群标签';
comment on column ${msl_schema}.msl_hgls_loan_branch_website.IS_SHOW is '展示机构';

alter table ${msl_schema}.msl_hgls_loan_branch_website add primary key (ID);
