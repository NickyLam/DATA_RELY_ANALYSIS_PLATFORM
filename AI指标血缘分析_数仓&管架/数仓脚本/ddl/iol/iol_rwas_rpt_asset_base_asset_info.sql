/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rpt_asset_base_asset_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rpt_asset_base_asset_info
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rpt_asset_base_asset_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rpt_asset_base_asset_info(
    data_date date -- 数据日期
    ,pk_col varchar2(300) -- PK_COL
    ,loan_ref_no varchar2(300) -- 债项编号
    ,fund_cd varchar2(180) -- 资产管理产品编号
    ,fund_name varchar2(600) -- 资产管理产品名称
    ,base_loan_ref_no varchar2(300) -- 基础资产债项编号
    ,base_product_cd varchar2(120) -- 基础资产描述
    ,base_product_type varchar2(300) -- 基础资产产品类型
    ,base_product_name varchar2(1200) -- 基础资产产品名称
    ,financial_asset_class varchar2(120) -- 金融资产三分类
    ,ccy_cd varchar2(30) -- 币种代码
    ,pric_bal number(18,2) -- 本金余额本币
    ,accrued_int number(18,2) -- 应计利息本币
    ,receivable_int number(18,2) -- 应收利息本币
    ,int_adj number(18,2) -- 利息调整本币
    ,fairvalue_changes number(18,2) -- 公允价值变动本币
    ,accrued_receiv_int number(18,2) -- 应收未收利息本币
    ,provision number(18,2) -- 准备金本币
    ,ead_orig number(18,2) -- 原始风险暴露本币
    ,asset_net_per number(8,4) -- 占资产比例%
    ,true_invest_ratio number(18,6) -- 投资比例
    ,min_invest_ratio number(18,6) -- 最小投资比例
    ,max_invest_ratio number(18,6) -- 最大投资比例
    ,authorized_by_third_party varchar2(30) -- 定期报告是否经过第三方托管人确认
    ,risk_weight number(31,6) -- 权重
    ,fm_avg_rw number(18,6) -- 资管产品基础资产平均权重
    ,fm_alvg_rw number(18,6) -- 资管产品调整杠杆率后的权重
    ,base_sec_name varchar2(300) -- 基础资产债券名称
    ,accorg_no varchar2(60) -- 入账机构
    ,accorg_name varchar2(766) -- 入账机构名称
    ,asset_type_name varchar2(180) -- 资产大类名称
    ,report_line_no varchar2(120) -- G4B_1报表栏位号
    ,report_line_name varchar2(600) -- G4B_1栏位名称
    ,load_date varchar2(60) -- 加载日期
    ,rwa_before_adj number(18,2) -- 调整前风险加权资产
    ,rwa_after_adj number(18,2) -- 调整后风险加权资产
    ,g4b_r_item_code varchar2(300) -- G4B-5项目
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
grant select on ${iol_schema}.rwas_rpt_asset_base_asset_info to ${iml_schema};
grant select on ${iol_schema}.rwas_rpt_asset_base_asset_info to ${icl_schema};
grant select on ${iol_schema}.rwas_rpt_asset_base_asset_info to ${idl_schema};
grant select on ${iol_schema}.rwas_rpt_asset_base_asset_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rpt_asset_base_asset_info is '内部管理报表_资管产品基础资产明细';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.data_date is '数据日期';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.pk_col is 'PK_COL';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.loan_ref_no is '债项编号';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.fund_cd is '资产管理产品编号';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.fund_name is '资产管理产品名称';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.base_loan_ref_no is '基础资产债项编号';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.base_product_cd is '基础资产描述';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.base_product_type is '基础资产产品类型';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.base_product_name is '基础资产产品名称';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.financial_asset_class is '金融资产三分类';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.ccy_cd is '币种代码';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.pric_bal is '本金余额本币';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.accrued_int is '应计利息本币';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.receivable_int is '应收利息本币';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.int_adj is '利息调整本币';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.fairvalue_changes is '公允价值变动本币';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.accrued_receiv_int is '应收未收利息本币';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.provision is '准备金本币';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.ead_orig is '原始风险暴露本币';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.asset_net_per is '占资产比例%';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.true_invest_ratio is '投资比例';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.min_invest_ratio is '最小投资比例';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.max_invest_ratio is '最大投资比例';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.authorized_by_third_party is '定期报告是否经过第三方托管人确认';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.risk_weight is '权重';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.fm_avg_rw is '资管产品基础资产平均权重';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.fm_alvg_rw is '资管产品调整杠杆率后的权重';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.base_sec_name is '基础资产债券名称';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.accorg_no is '入账机构';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.accorg_name is '入账机构名称';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.asset_type_name is '资产大类名称';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.report_line_no is 'G4B_1报表栏位号';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.report_line_name is 'G4B_1栏位名称';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.load_date is '加载日期';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.rwa_before_adj is '调整前风险加权资产';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.rwa_after_adj is '调整后风险加权资产';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.g4b_r_item_code is 'G4B-5项目';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_rpt_asset_base_asset_info.etl_timestamp is 'ETL处理时间戳';
