/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_hgls_loan_req
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_hgls_loan_req
whenever sqlerror continue none;
drop table ${msl_schema}.msl_hgls_loan_req purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_hgls_loan_req(
  req_id                     NUMBER(11) not null,
  prod_id                    NUMBER(11),
  prod_code                  VARCHAR2(480),
  code                       VARCHAR2(480),
  prd_type                   NUMBER(11),
  loan_apply_type            VARCHAR2(120),
  prod_name                  VARCHAR2(1020),
  credit_on                  VARCHAR2(16),
  cust_id                    NUMBER(11),
  cust_name                  VARCHAR2(1020),
  ent_name                   VARCHAR2(400),
  credit_code                VARCHAR2(200),
  cust_type                  VARCHAR2(24),
  file_code                  VARCHAR2(480),
  id_card_no                 VARCHAR2(216),
  manage_code                VARCHAR2(600),
  survey_user_id             NUMBER(11),
  transator_id               NUMBER(11),
  examiner_ids               VARCHAR2(1020),
  auditor_ids                VARCHAR2(1020),
  reconsider_ids             VARCHAR2(1020),
  share_user_id              NUMBER(11),
  req_date                   TIMESTAMP(6),
  audit_date                 TIMESTAMP(6),
  loan_use                   VARCHAR2(120),
  loan_use_other             VARCHAR2(1020),
  reject_reason              NUMBER(11),
  reject_reason_other        VARCHAR2(1020),
  auth_money                 NUMBER(10,2),
  audit_status               NUMBER(11),
  label_status               VARCHAR2(600),
  process_info               VARCHAR2(600),
  is_cancel                  VARCHAR2(16),
  req_type                   VARCHAR2(120),
  is_self                    VARCHAR2(16),
  survey_status              NUMBER(11),
  survey_date                TIMESTAMP(6),
  loan_amount                NUMBER(7,3),
  update_date                TIMESTAMP(6),
  repayment_kind             NUMBER(11),
  comment1                   CLOB,
  is_credit_submit           VARCHAR2(16),
  ismanual_audit             VARCHAR2(16),
  intervene_status           VARCHAR2(16),
  reconsider_num             VARCHAR2(600),
  enterprise_code            VARCHAR2(120),
  approve_num                NUMBER(11),
  examine_num                NUMBER(11),
  isfixed_rate               VARCHAR2(16),
  loan_rate                  NUMBER(4,2),
  channel                    NUMBER(11),
  category                   VARCHAR2(24),
  final_price                NUMBER(15,2),
  access_rule                VARCHAR2(1020),
  final_loan_money           NUMBER(15,2),
  branch_code                VARCHAR2(480),
  home_branch                VARCHAR2(480),
  is_house_audit_submit      VARCHAR2(16),
  isdel                      VARCHAR2(16),
  remarks                    VARCHAR2(3600),
  risk_ele_submit            VARCHAR2(480),
  collect_ele_submit         VARCHAR2(480),
  query_number               VARCHAR2(1200),
  year_rate                  NUMBER(4,2),
  sync_result                VARCHAR2(1200),
  exclude_count              VARCHAR2(16),
  next_req_code              VARCHAR2(480),
  change_product_user_id     NUMBER(11),
  change_product_user_name   VARCHAR2(600),
  is_renew_loan              VARCHAR2(16),
  biz_breed_encode           VARCHAR2(600),
  is_first_loan              VARCHAR2(1),
  renew_ori_req_code         VARCHAR2(384),
  comprehensive_money        NUMBER(10,2),
  minor_survey_user_id       VARCHAR2(256),
  marital_status             VARCHAR2(120),
  apply_balance              NUMBER(18,2),
  telephone                  VARCHAR2(39),
  model_version              NUMBER(11),
  is_pos_cust                VARCHAR2(16),
  is_stock_cust              VARCHAR2(16),
  biz_cust_no                VARCHAR2(768),
  biz_cust_create_date       VARCHAR2(384),
  biz_contract_no            VARCHAR2(384),
  is_ji_nong_dan             VARCHAR2(24),
  business_license_type      VARCHAR2(240),
  relationship_of_enterprise VARCHAR2(240),
  scale_judgment             VARCHAR2(240),
  agri_loan_type             VARCHAR2(48),
  contrac_no                 VARCHAR2(120),
  applyorderno               VARCHAR2(128),
  referrer_id                VARCHAR2(256),
  is_revolving_loan          VARCHAR2(1),
  retail_rate_value          VARCHAR2(400),
  after_last_time            TIMESTAMP(6),
  business_label             VARCHAR2(200)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_hgls_loan_req to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_hgls_loan_req is '进件表';
comment on column ${msl_schema}.msl_hgls_loan_req.REQ_ID is '申请ID:主键';
comment on column ${msl_schema}.msl_hgls_loan_req.PROD_ID is '产品ID:外键';
comment on column ${msl_schema}.msl_hgls_loan_req.PROD_CODE is '产品编码';
comment on column ${msl_schema}.msl_hgls_loan_req.CODE is '唯一编码';
comment on column ${msl_schema}.msl_hgls_loan_req.PRD_TYPE is '产品类型:1.网贷,2.经营贷';
comment on column ${msl_schema}.msl_hgls_loan_req.LOAN_APPLY_TYPE is '贷款类型';
comment on column ${msl_schema}.msl_hgls_loan_req.PROD_NAME is '产品名称';
comment on column ${msl_schema}.msl_hgls_loan_req.CREDIT_ON is '预授信模式:0.关闭,１.开启';
comment on column ${msl_schema}.msl_hgls_loan_req.CUST_ID is '申请客户ID';
comment on column ${msl_schema}.msl_hgls_loan_req.CUST_NAME is '客户姓名';
comment on column ${msl_schema}.msl_hgls_loan_req.ENT_NAME is '企业名称';
comment on column ${msl_schema}.msl_hgls_loan_req.CREDIT_CODE is '统一信用代码证';
comment on column ${msl_schema}.msl_hgls_loan_req.CUST_TYPE is '客户类型：A，按揭白名单';
comment on column ${msl_schema}.msl_hgls_loan_req.FILE_CODE is '白名单文件编码';
comment on column ${msl_schema}.msl_hgls_loan_req.ID_CARD_NO is '身份证号码';
comment on column ${msl_schema}.msl_hgls_loan_req.MANAGE_CODE is '分享人（系统用户）code';
comment on column ${msl_schema}.msl_hgls_loan_req.SURVEY_USER_ID is '调查员id（归属人）';
comment on column ${msl_schema}.msl_hgls_loan_req.TRANSATOR_ID is '经办人ID';
comment on column ${msl_schema}.msl_hgls_loan_req.EXAMINER_IDS is '审查者id';
comment on column ${msl_schema}.msl_hgls_loan_req.AUDITOR_IDS is '审批者id';
comment on column ${msl_schema}.msl_hgls_loan_req.RECONSIDER_IDS is '人工复议人员id';
comment on column ${msl_schema}.msl_hgls_loan_req.SHARE_USER_ID is '分享者ID';
comment on column ${msl_schema}.msl_hgls_loan_req.REQ_DATE is '申请日期';
comment on column ${msl_schema}.msl_hgls_loan_req.AUDIT_DATE is '审核日期';
comment on column ${msl_schema}.msl_hgls_loan_req.LOAN_USE is '借款用途';
comment on column ${msl_schema}.msl_hgls_loan_req.LOAN_USE_OTHER is '借款用途';
comment on column ${msl_schema}.msl_hgls_loan_req.REJECT_REASON is '审批拒绝原因';
comment on column ${msl_schema}.msl_hgls_loan_req.REJECT_REASON_OTHER is '审批拒绝原因';
comment on column ${msl_schema}.msl_hgls_loan_req.AUTH_MONEY is '授信金额';
comment on column ${msl_schema}.msl_hgls_loan_req.AUDIT_STATUS is '审批状态:1 待审批 2 审批通过 3审批拒绝';
comment on column ${msl_schema}.msl_hgls_loan_req.LABEL_STATUS is '标签状态，0无标签 1已撤销 2担保人信息待补充 3担保人征信待审核';
comment on column ${msl_schema}.msl_hgls_loan_req.PROCESS_INFO is '流程记录信息，多个流程以逗号分隔';
comment on column ${msl_schema}.msl_hgls_loan_req.IS_CANCEL is '贷款是否取消，0否1是';
comment on column ${msl_schema}.msl_hgls_loan_req.REQ_TYPE is '进件类型：1，公共进件，2，自主营销，3，渠道进件';
comment on column ${msl_schema}.msl_hgls_loan_req.IS_SELF is '是否自主营销';
comment on column ${msl_schema}.msl_hgls_loan_req.SURVEY_STATUS is '调查状态(1 准备调查 2 正在调查 3现场调查完成4调查完成）';
comment on column ${msl_schema}.msl_hgls_loan_req.SURVEY_DATE is '准备调查时间';
comment on column ${msl_schema}.msl_hgls_loan_req.LOAN_AMOUNT is '申请金额,单位(万元),最大不超过产品定义的额度';
comment on column ${msl_schema}.msl_hgls_loan_req.UPDATE_DATE is '更新时间';
comment on column ${msl_schema}.msl_hgls_loan_req.REPAYMENT_KIND is '还款方式:1.本金自定,2.等额本金,3.等额本息,4.定期还款,5.分期还款,6.一次性还款，字典编码hkfs';
comment on column ${msl_schema}.msl_hgls_loan_req.COMMENT1 is '备注信息';
comment on column ${msl_schema}.msl_hgls_loan_req.IS_CREDIT_SUBMIT is '信贷历史是否提交0否1是';
comment on column ${msl_schema}.msl_hgls_loan_req.ISMANUAL_AUDIT is '是否开启人工审核，0否1是';
comment on column ${msl_schema}.msl_hgls_loan_req.INTERVENE_STATUS is '复议成功状态 0失败1成功';
comment on column ${msl_schema}.msl_hgls_loan_req.RECONSIDER_NUM is '复议通过次数，0主借人1配偶 ,2个0表示主借人复议通过次数为2';
comment on column ${msl_schema}.msl_hgls_loan_req.ENTERPRISE_CODE is '企业编码';
comment on column ${msl_schema}.msl_hgls_loan_req.APPROVE_NUM is '审批人数';
comment on column ${msl_schema}.msl_hgls_loan_req.EXAMINE_NUM is '审查人数';
comment on column ${msl_schema}.msl_hgls_loan_req.ISFIXED_RATE is '是否固定利率，0否1是';
comment on column ${msl_schema}.msl_hgls_loan_req.LOAN_RATE is '贷款日利率（%）无锡需求，可以为空';
comment on column ${msl_schema}.msl_hgls_loan_req.CHANNEL is '渠道';
comment on column ${msl_schema}.msl_hgls_loan_req.CATEGORY is '类别:(1.短信 2.软文 3.图片 4.中介)';
comment on column ${msl_schema}.msl_hgls_loan_req.FINAL_PRICE is '实际成交价';
comment on column ${msl_schema}.msl_hgls_loan_req.ACCESS_RULE is '贷款准入规则';
comment on column ${msl_schema}.msl_hgls_loan_req.FINAL_LOAN_MONEY is '实际放款金额';
comment on column ${msl_schema}.msl_hgls_loan_req.BRANCH_CODE is '支行信息code';
comment on column ${msl_schema}.msl_hgls_loan_req.HOME_BRANCH is '归属支行code';
comment on column ${msl_schema}.msl_hgls_loan_req.IS_HOUSE_AUDIT_SUBMIT is '房贷初审是否提交，0否1是';
comment on column ${msl_schema}.msl_hgls_loan_req.ISDEL is '删除标识:0.未删除,1.已删除';
comment on column ${msl_schema}.msl_hgls_loan_req.REMARKS is '备注';
comment on column ${msl_schema}.msl_hgls_loan_req.RISK_ELE_SUBMIT is '风险核查要素提交状态，0否1电调提交2二次补充信息提交';
comment on column ${msl_schema}.msl_hgls_loan_req.COLLECT_ELE_SUBMIT is '信息收集核查要素是否提交，0否1是';
comment on column ${msl_schema}.msl_hgls_loan_req.QUERY_NUMBER is '调查报告查询编码-为随机数合字母组成，无特殊规律';
comment on column ${msl_schema}.msl_hgls_loan_req.YEAR_RATE is '年利率';
comment on column ${msl_schema}.msl_hgls_loan_req.SYNC_RESULT is '信贷同步结果';
comment on column ${msl_schema}.msl_hgls_loan_req.EXCLUDE_COUNT is '业务量均分，统计排除标记，默认不排除';
comment on column ${msl_schema}.msl_hgls_loan_req.NEXT_REQ_CODE is '更换产品后的code';
comment on column ${msl_schema}.msl_hgls_loan_req.CHANGE_PRODUCT_USER_ID is '更换产品操作人id';
comment on column ${msl_schema}.msl_hgls_loan_req.CHANGE_PRODUCT_USER_NAME is '更换产品操作人姓名';
comment on column ${msl_schema}.msl_hgls_loan_req.IS_RENEW_LOAN is '是否为续贷：0.否 1.是';
comment on column ${msl_schema}.msl_hgls_loan_req.BIZ_BREED_ENCODE is '业务编号（智慧零售唯一标识）';
comment on column ${msl_schema}.msl_hgls_loan_req.IS_FIRST_LOAN is '是否是首贷户，0否1是';
comment on column ${msl_schema}.msl_hgls_loan_req.RENEW_ORI_REQ_CODE is '续贷原进件CODE';
comment on column ${msl_schema}.msl_hgls_loan_req.COMPREHENSIVE_MONEY is '综合授信额度';
comment on column ${msl_schema}.msl_hgls_loan_req.MINOR_SURVEY_USER_ID is '陪调员id';
comment on column ${msl_schema}.msl_hgls_loan_req.MARITAL_STATUS is '婚姻状况';
comment on column ${msl_schema}.msl_hgls_loan_req.APPLY_BALANCE is '申请金额(元)';
comment on column ${msl_schema}.msl_hgls_loan_req.TELEPHONE is '联系方式';
comment on column ${msl_schema}.msl_hgls_loan_req.MODEL_VERSION is '是否走续贷模型，0不走续贷模型，1走续贷模型';
comment on column ${msl_schema}.msl_hgls_loan_req.IS_POS_CUST is '是否POS贷客户 true:是';
comment on column ${msl_schema}.msl_hgls_loan_req.IS_STOCK_CUST is '是否存量客户 true:是';
comment on column ${msl_schema}.msl_hgls_loan_req.BIZ_CUST_NO is '信贷客户编号';
comment on column ${msl_schema}.msl_hgls_loan_req.BIZ_CUST_CREATE_DATE is '信贷客户创建时间';
comment on column ${msl_schema}.msl_hgls_loan_req.BIZ_CONTRACT_NO is '信贷合同编号';
comment on column ${msl_schema}.msl_hgls_loan_req.IS_JI_NONG_DAN is '是否冀农担客户：0:否  1:是';
comment on column ${msl_schema}.msl_hgls_loan_req.BUSINESS_LICENSE_TYPE is '营业执照类型：1个体工商户、2企业、3无营业执照';
comment on column ${msl_schema}.msl_hgls_loan_req.RELATIONSHIP_OF_ENTERPRISE is '借款人与企业关系：1法人、2法人配偶、3主要股东、4实际控制人、5共同借款人、6无关联';
comment on column ${msl_schema}.msl_hgls_loan_req.SCALE_JUDGMENT is '规模判断：1大型、2中型、3小型、4微型、5其它';
comment on column ${msl_schema}.msl_hgls_loan_req.AGRI_LOAN_TYPE is '涉农贷款类型，字典：sndklx';
comment on column ${msl_schema}.msl_hgls_loan_req.CONTRAC_NO is '安心签项目编号';
comment on column ${msl_schema}.msl_hgls_loan_req.APPLYORDERNO is '唯一申请编号（信贷交互使用）';
comment on column ${msl_schema}.msl_hgls_loan_req.REFERRER_ID is '推荐员id';
comment on column ${msl_schema}.msl_hgls_loan_req.IS_REVOLVING_LOAN is '是否循环贷款';
comment on column ${msl_schema}.msl_hgls_loan_req.RETAIL_RATE_VALUE is '零售评级返回分数';
comment on column ${msl_schema}.msl_hgls_loan_req.AFTER_LAST_TIME is '上次过贷后模型时间';
comment on column ${msl_schema}.msl_hgls_loan_req.BUSINESS_LABEL is '行业群码值';
alter table ${msl_schema}.msl_hgls_loan_req add primary key (REQ_ID);
