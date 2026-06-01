/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rwa_report_fb_invest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rwa_report_fb_invest
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rwa_report_fb_invest purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rwa_report_fb_invest(
    data_date date -- 数据日期
    ,loan_ref_id number(9) -- 债项ID
    ,loan_ref_no varchar2(100) -- 借据号
    ,i_code varchar2(100) -- 金融工具代码
    ,i_code_name varchar2(100) -- 金融工具名称
    ,product_type varchar2(100) -- 产品分类
    ,asset_thd_cls_cd varchar2(30) -- 金融资产分类
    ,product_name varchar2(100) -- 业务类型
    ,start_date date -- 开始日期
    ,due_date date -- 到期日期
    ,sourceid varchar2(10) -- 所属条线
    ,org_cd varchar2(60) -- 入账机构
    ,subject_cd varchar2(60) -- 本金科目代码
    ,interest_receive_subject_cd varchar2(60) -- 应收利息科目代码
    ,accrual_class_subject_cd varchar2(60) -- 应计科目代码
    ,interest_adjust_subject_cd varchar2(60) -- 利息调整科目代码
    ,fairvalue_changes_subject_cd varchar2(60) -- 公允价值变动科目代码
    ,provision_single_subject_cd varchar2(60) -- 准备金科目代码
    ,asset_balance number(22,2) -- 资产余额(原币)
    ,ccy_name varchar2(1000) -- 币种代码
    ,asset_balance_hcurr number(22,6) -- 资产余额(本币)
    ,receivable_int number(22,6) -- 应收利息(本币)
    ,accrued_int number(22,6) -- 应计利息(本币)
    ,int_adj number(22,6) -- 利息调整(本币)
    ,fair_value_change number(22,6) -- 公允价值变动(本币)
    ,provision number(22,6) -- 计提准备金(本币)
    ,spv_cust_no varchar2(60) -- 交易对手客户号
    ,spv_cust_name varchar2(200) -- 交易对手
    ,spv_cust_type varchar2(1000) -- 客户分类
    ,cust_name varchar2(500) -- 实际融资主体客户名称
    ,uder_actl_finer_cust_char varchar2(100) -- 实际融资客户性质
    ,ccp_type_cd varchar2(50) -- 实际融资主体客户类型(引擎)
    ,ead_orig number(22,6) -- 原始风险暴露(本币)
    ,ead_provision number(22,6) -- 扣减准备金后的风险暴露(本币)
    ,portfoliotypedesc varchar2(200) -- 填报项目
    ,rwbandid number(18,3) -- 债项权重
    ,allocatedcrm number(18,2) -- 缓释品金额(本币)
    ,crm_rwbandid_wtd number(18,3) -- 缓释品加权权重
    ,crm_cover_rwaamount number(18,2) -- 缓释未覆盖部分RWA
    ,crm_ncover_rwaamount number(18,2) -- 缓释覆盖部分RWA
    ,rwaamount number(18,2) -- RWA
    ,register_date date -- 缓释录入日
    ,crm_cash_amt number(18,2) -- 保证金金额
    ,crm_deposit_amt number(18,2) -- 存单金额
    ,crm_national_debt_amt number(18,2) -- 国债金额
    ,crm_policy_bank_amt number(18,2) -- 我国政策性银行
    ,crm_bank_amt number(18,2) -- 我国商业银行
    ,crm_pse_sov_amt number(18,2) -- 我国公共部门实体
    ,crm_oth_amt number(18,2) -- 其他缓释
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.rwas_rwa_report_fb_invest to ${iml_schema};
grant select on ${iol_schema}.rwas_rwa_report_fb_invest to ${icl_schema};
grant select on ${iol_schema}.rwas_rwa_report_fb_invest to ${idl_schema};
grant select on ${iol_schema}.rwas_rwa_report_fb_invest to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rwa_report_fb_invest is '债项填报信息表-非标表';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.data_date is '数据日期';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.loan_ref_id is '债项ID';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.loan_ref_no is '借据号';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.i_code is '金融工具代码';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.i_code_name is '金融工具名称';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.product_type is '产品分类';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.asset_thd_cls_cd is '金融资产分类';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.product_name is '业务类型';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.start_date is '开始日期';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.due_date is '到期日期';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.sourceid is '所属条线';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.org_cd is '入账机构';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.subject_cd is '本金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.interest_receive_subject_cd is '应收利息科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.accrual_class_subject_cd is '应计科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.interest_adjust_subject_cd is '利息调整科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.fairvalue_changes_subject_cd is '公允价值变动科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.provision_single_subject_cd is '准备金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.asset_balance is '资产余额(原币)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.ccy_name is '币种代码';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.asset_balance_hcurr is '资产余额(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.receivable_int is '应收利息(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.accrued_int is '应计利息(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.int_adj is '利息调整(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.fair_value_change is '公允价值变动(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.provision is '计提准备金(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.spv_cust_no is '交易对手客户号';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.spv_cust_name is '交易对手';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.spv_cust_type is '客户分类';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.cust_name is '实际融资主体客户名称';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.uder_actl_finer_cust_char is '实际融资客户性质';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.ccp_type_cd is '实际融资主体客户类型(引擎)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.ead_orig is '原始风险暴露(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.ead_provision is '扣减准备金后的风险暴露(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.portfoliotypedesc is '填报项目';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.rwbandid is '债项权重';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.allocatedcrm is '缓释品金额(本币)';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.crm_rwbandid_wtd is '缓释品加权权重';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.crm_cover_rwaamount is '缓释未覆盖部分RWA';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.crm_ncover_rwaamount is '缓释覆盖部分RWA';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.rwaamount is 'RWA';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.register_date is '缓释录入日';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.crm_cash_amt is '保证金金额';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.crm_deposit_amt is '存单金额';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.crm_national_debt_amt is '国债金额';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.crm_policy_bank_amt is '我国政策性银行';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.crm_bank_amt is '我国商业银行';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.crm_pse_sov_amt is '我国公共部门实体';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.crm_oth_amt is '其他缓释';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_rwa_report_fb_invest.etl_timestamp is 'ETL处理时间戳';
