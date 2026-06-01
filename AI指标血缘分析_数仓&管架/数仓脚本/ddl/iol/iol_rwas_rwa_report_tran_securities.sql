/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rwa_report_tran_securities
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rwa_report_tran_securities
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rwa_report_tran_securities purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rwa_report_tran_securities(
    data_date date -- 数据日期
    ,loan_ref_id number(9) -- 债项ID
    ,loan_ref_no varchar2(100) -- 借据号
    ,sec_no varchar2(100) -- 证券编号
    ,tradetypeid varchar2(4) -- 多空头标志
    ,asset_thd_cls_cd varchar2(10) -- 金融资产分类
    ,s_grade varchar2(20) -- 主体评级
    ,grade varchar2(20) -- 债券评级
    ,int_rat_adj_way_cd varchar2(20) -- 利率类别
    ,coupon varchar2(10) -- 债券利率
    ,start_date date -- 开始日期
    ,due_date date -- 到期日期
    ,next_reval_date date -- 下一重定价日期
    ,rema__reval_date number(18,6) -- 剩余重定价期限(月)
    ,remainingmaturity number(18,6) -- 剩余期限(月)
    ,org_cd varchar2(40) -- 入账机构
    ,cust_name varchar2(100) -- 发行人名称
    ,ccp_type_cd varchar2(10) -- 客户类型(引擎)
    ,sec_type_cd varchar2(20) -- 证券类型
    ,assettype_id varchar2(10) -- 资产类型(引擎)
    ,subject_cd varchar2(40) -- 本金科目代码
    ,interest_receive_subject_cd varchar2(40) -- 应收利息科目代码
    ,accrual_class_subject_cd varchar2(40) -- 应计科目代码
    ,interest_adjust_subject_cd varchar2(40) -- 利息调整科目代码
    ,fairvalue_changes_subject_cd varchar2(40) -- 公允价值变动科目代码
    ,provision_single_subject_cd varchar2(40) -- 准备金科目代码
    ,asset_balance number(18,2) -- 资产余额(原币)
    ,ccy_cd varchar2(10) -- 币种代码
    ,asset_balance_hcurr number(18,2) -- 资产余额(本币)
    ,receivable_int number(18,2) -- 应收利息(本币)
    ,accrued_int number(18,2) -- 应计利息(本币)
    ,int_adj number(18,2) -- 利息调整(本币)
    ,fair_value_change number(18,2) -- 公允价值变动(本币)
    ,provision number(18,2) -- 计提准备金(本币)
    ,amt number(18,2) -- 证券头寸金额(本币)
    ,rate_sec_type_cd varchar2(20) -- 特定利率风险债券类型
    ,specific_risk_ratio number(9,6) -- 利率特定风险资本计提比率
    ,spec_risk_capital_amount number(18,2) -- 利率特定风险资本
    ,coupon_flag varchar2(2) -- 年息票率大于等于3%标志
    ,mat_bucketid varchar2(40) -- 时段
    ,specific_risk_charge varchar2(10) -- 风险权重
    ,exposureamount number(18,2) -- 一般市场风险的资本要求总额
    ,rwaamount number(18,2) -- RWA
    ,sec_name varchar2(500) -- 证券名称
    ,product_name varchar2(500) -- 交易品种
    ,general_risk_capital_amount number(18,2) -- 一般利率风险资本
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
grant select on ${iol_schema}.rwas_rwa_report_tran_securities to ${iml_schema};
grant select on ${iol_schema}.rwas_rwa_report_tran_securities to ${icl_schema};
grant select on ${iol_schema}.rwas_rwa_report_tran_securities to ${idl_schema};
grant select on ${iol_schema}.rwas_rwa_report_tran_securities to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rwa_report_tran_securities is '债项填报信息表';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.data_date is '数据日期';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.loan_ref_id is '债项ID';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.loan_ref_no is '借据号';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.sec_no is '证券编号';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.tradetypeid is '多空头标志';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.asset_thd_cls_cd is '金融资产分类';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.s_grade is '主体评级';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.grade is '债券评级';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.int_rat_adj_way_cd is '利率类别';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.coupon is '债券利率';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.start_date is '开始日期';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.due_date is '到期日期';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.next_reval_date is '下一重定价日期';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.rema__reval_date is '剩余重定价期限(月)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.remainingmaturity is '剩余期限(月)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.org_cd is '入账机构';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.cust_name is '发行人名称';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.ccp_type_cd is '客户类型(引擎)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.sec_type_cd is '证券类型';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.assettype_id is '资产类型(引擎)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.subject_cd is '本金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.interest_receive_subject_cd is '应收利息科目代码';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.accrual_class_subject_cd is '应计科目代码';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.interest_adjust_subject_cd is '利息调整科目代码';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.fairvalue_changes_subject_cd is '公允价值变动科目代码';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.provision_single_subject_cd is '准备金科目代码';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.asset_balance is '资产余额(原币)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.ccy_cd is '币种代码';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.asset_balance_hcurr is '资产余额(本币)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.receivable_int is '应收利息(本币)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.accrued_int is '应计利息(本币)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.int_adj is '利息调整(本币)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.fair_value_change is '公允价值变动(本币)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.provision is '计提准备金(本币)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.amt is '证券头寸金额(本币)';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.rate_sec_type_cd is '特定利率风险债券类型';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.specific_risk_ratio is '利率特定风险资本计提比率';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.spec_risk_capital_amount is '利率特定风险资本';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.coupon_flag is '年息票率大于等于3%标志';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.mat_bucketid is '时段';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.specific_risk_charge is '风险权重';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.exposureamount is '一般市场风险的资本要求总额';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.rwaamount is 'RWA';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.sec_name is '证券名称';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.product_name is '交易品种';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.general_risk_capital_amount is '一般利率风险资本';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.start_dt is '开始时间';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.end_dt is '结束时间';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.id_mark is '增删标志';
comment on column ${iol_schema}.rwas_rwa_report_tran_securities.etl_timestamp is 'ETL处理时间戳';
