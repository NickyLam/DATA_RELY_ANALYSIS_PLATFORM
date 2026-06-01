/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rwa_report_debt_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rwa_report_debt_info
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rwa_report_debt_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rwa_report_debt_info(
    data_date date -- 数据日期
    ,loan_ref_id varchar2(100) -- 债项ID
    ,src_loan_ref_no varchar2(100) -- 借据号
    ,accountrefcd varchar2(100) -- 合同号
    ,product_name varchar2(100) -- 业务类型
    ,start_date date -- 开始日期
    ,due_date date -- 到期日期
    ,org_cd varchar2(60) -- 入账机构
    ,ccy_cd varchar2(1000) -- 币种代码
    ,cust_name varchar2(500) -- 客户名称
    ,ccp_type_cd varchar2(10) -- 客户类型(引擎)
    ,assettype_id varchar2(10) -- 资产类型(引擎)
    ,subject_cd varchar2(60) -- 本金科目代码
    ,interest_receive_subject_cd varchar2(60) -- 应收利息科目代码
    ,accrual_class_subject_cd varchar2(60) -- 应计科目代码
    ,interest_adjust_subject_cd varchar2(60) -- 利息调整科目代码
    ,fairvalue_changes_subject_cd varchar2(60) -- 公允价值变动科目代码
    ,depre_amortizat_subject_cd varchar2(60) -- 折旧科目代码
    ,provision_single_subject_cd varchar2(60) -- 准备金科目代码
    ,asset_balance number(22,2) -- 资产余额(原币)
    ,asset_balance_hcurr number(22,6) -- 资产余额(本币)
    ,receivable_int number(22,6) -- 应收利息(本币)
    ,accrued_int number(22,6) -- 应计利息(本币)
    ,int_adj number(22,6) -- 利息调整(本币)
    ,fair_value_change number(22,6) -- 公允价值变动(本币)
    ,depre_amortizat_assets number(22,6) -- 固定资产折旧(本币)
    ,provision number(22,6) -- 计提准备金(本币)
    ,ead_orig number(22,6) -- 原始风险暴露(本币)
    ,ccf number(22,6) -- 
    ,ccf_ead number(22,6) -- CCF转换后风险暴露
    ,ead_provision number(22,6) -- 扣减准备金后的风险暴露(本币)
    ,portfoliotypedesc varchar2(200) -- 填报项目
    ,rwbandid number(18,3) -- 债项权重
    ,ccy_mismatch number(18,2) -- 缓释币种错配系数
    ,allocatedcrm number(18,2) -- 缓释品金额(折本币)
    ,crm_rwbandid_wtd number(18,3) -- 缓释品加权权重
    ,crm_ncover_rwaamount number(18,2) -- 缓释未覆盖部分RWA
    ,crm_cover_rwaamount number(18,2) -- 缓释覆盖部分RWA
    ,rwaamount number(18,2) -- RWA
    ,on_off_id varchar2(10) -- 表内外标志
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
grant select on ${iol_schema}.rwas_rwa_report_debt_info to ${iml_schema};
grant select on ${iol_schema}.rwas_rwa_report_debt_info to ${icl_schema};
grant select on ${iol_schema}.rwas_rwa_report_debt_info to ${idl_schema};
grant select on ${iol_schema}.rwas_rwa_report_debt_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rwa_report_debt_info is '债项填报信息表';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.data_date is '数据日期';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.loan_ref_id is '债项ID';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.src_loan_ref_no is '借据号';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.accountrefcd is '合同号';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.product_name is '业务类型';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.start_date is '开始日期';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.due_date is '到期日期';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.org_cd is '入账机构';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.ccy_cd is '币种代码';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.cust_name is '客户名称';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.ccp_type_cd is '客户类型(引擎)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.assettype_id is '资产类型(引擎)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.subject_cd is '本金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.interest_receive_subject_cd is '应收利息科目代码';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.accrual_class_subject_cd is '应计科目代码';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.interest_adjust_subject_cd is '利息调整科目代码';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.fairvalue_changes_subject_cd is '公允价值变动科目代码';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.depre_amortizat_subject_cd is '折旧科目代码';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.provision_single_subject_cd is '准备金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.asset_balance is '资产余额(原币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.asset_balance_hcurr is '资产余额(本币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.receivable_int is '应收利息(本币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.accrued_int is '应计利息(本币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.int_adj is '利息调整(本币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.fair_value_change is '公允价值变动(本币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.depre_amortizat_assets is '固定资产折旧(本币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.provision is '计提准备金(本币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.ead_orig is '原始风险暴露(本币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.ccf is '';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.ccf_ead is 'CCF转换后风险暴露';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.ead_provision is '扣减准备金后的风险暴露(本币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.portfoliotypedesc is '填报项目';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.rwbandid is '债项权重';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.ccy_mismatch is '缓释币种错配系数';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.allocatedcrm is '缓释品金额(折本币)';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.crm_rwbandid_wtd is '缓释品加权权重';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.crm_ncover_rwaamount is '缓释未覆盖部分RWA';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.crm_cover_rwaamount is '缓释覆盖部分RWA';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.rwaamount is 'RWA';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.on_off_id is '表内外标志';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_rwa_report_debt_info.etl_timestamp is 'ETL处理时间戳';
