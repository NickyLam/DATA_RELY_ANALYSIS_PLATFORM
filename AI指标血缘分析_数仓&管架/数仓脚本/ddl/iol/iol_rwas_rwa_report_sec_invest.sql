/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rwa_report_sec_invest
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rwa_report_sec_invest
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rwa_report_sec_invest purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rwa_report_sec_invest(
    data_date date -- 数据日期
    ,loan_ref_id number(9) -- 债项ID
    ,loan_ref_no varchar2(100) -- 借据号
    ,sec_items_issue_no varchar2(100) -- 证券编号
    ,book_type_id varchar2(10) -- 账簿类型
    ,asset_thd_cls_cd varchar2(30) -- 金融资产分类
    ,resecuritisation_flag varchar2(5) -- 再资产证券化标志
    ,s_grade varchar2(20) -- 主体评级
    ,grade varchar2(20) -- 债项评级
    ,product_name varchar2(40) -- 业务类型
    ,start_date date -- 开始日期
    ,due_date date -- 到期日期
    ,org_cd varchar2(60) -- 入账机构
    ,cust_name varchar2(200) -- 发行人名称
    ,ccp_type_cd varchar2(10) -- 客户类型(引擎)
    ,assettype_id varchar2(40) -- 资产类型(引擎)
    ,subject_cd varchar2(60) -- 本金科目代码
    ,interest_receive_subject_cd varchar2(60) -- 应收利息科目代码
    ,accrual_class_subject_cd varchar2(60) -- 应计科目代码
    ,interest_adjust_subject_cd varchar2(60) -- 利息调整科目代码
    ,fairvalue_changes_subject_cd varchar2(60) -- 公允价值变动科目代码
    ,provision_single_subject_cd varchar2(60) -- 准备金科目代码
    ,asset_balance number(22,2) -- 资产余额(原币)
    ,ccy_cd varchar2(10) -- 币种代码
    ,asset_balance_hcurr number(22,6) -- 资产余额(本币)
    ,receivable_int number(22,6) -- 应收利息(本币)
    ,accrued_int number(22,6) -- 应计利息(本币)
    ,int_adj number(22,6) -- 利息调整(本币)
    ,fair_value_change number(22,6) -- 公允价值变动(本币)
    ,provision number(18,2) -- 计提准备金(本币)
    ,ead_orig number(18,2) -- 原始风险暴露(本币)
    ,ead_provision number(18,2) -- 扣减准备金后的风险暴露(本币)
    ,portfoliotypedesc varchar2(200) -- 填报项目
    ,rwbandid number(18,3) -- 债项权重
    ,rwaamount number(18,2) -- RWA
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
grant select on ${iol_schema}.rwas_rwa_report_sec_invest to ${iml_schema};
grant select on ${iol_schema}.rwas_rwa_report_sec_invest to ${icl_schema};
grant select on ${iol_schema}.rwas_rwa_report_sec_invest to ${idl_schema};
grant select on ${iol_schema}.rwas_rwa_report_sec_invest to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rwa_report_sec_invest is '债项填报信息表-ABS';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.data_date is '数据日期';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.loan_ref_id is '债项ID';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.loan_ref_no is '借据号';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.sec_items_issue_no is '证券编号';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.book_type_id is '账簿类型';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.asset_thd_cls_cd is '金融资产分类';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.resecuritisation_flag is '再资产证券化标志';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.s_grade is '主体评级';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.grade is '债项评级';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.product_name is '业务类型';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.start_date is '开始日期';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.due_date is '到期日期';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.org_cd is '入账机构';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.cust_name is '发行人名称';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.ccp_type_cd is '客户类型(引擎)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.assettype_id is '资产类型(引擎)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.subject_cd is '本金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.interest_receive_subject_cd is '应收利息科目代码';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.accrual_class_subject_cd is '应计科目代码';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.interest_adjust_subject_cd is '利息调整科目代码';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.fairvalue_changes_subject_cd is '公允价值变动科目代码';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.provision_single_subject_cd is '准备金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.asset_balance is '资产余额(原币)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.ccy_cd is '币种代码';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.asset_balance_hcurr is '资产余额(本币)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.receivable_int is '应收利息(本币)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.accrued_int is '应计利息(本币)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.int_adj is '利息调整(本币)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.fair_value_change is '公允价值变动(本币)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.provision is '计提准备金(本币)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.ead_orig is '原始风险暴露(本币)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.ead_provision is '扣减准备金后的风险暴露(本币)';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.portfoliotypedesc is '填报项目';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.rwbandid is '债项权重';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.rwaamount is 'RWA';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_rwa_report_sec_invest.etl_timestamp is 'ETL处理时间戳';
