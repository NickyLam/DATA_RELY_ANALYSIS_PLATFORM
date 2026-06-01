/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol rwas_rpt_asset_manager_result
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.rwas_rpt_asset_manager_result
whenever sqlerror continue none;
drop table ${iol_schema}.rwas_rpt_asset_manager_result purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rwas_rpt_asset_manager_result(
    data_date date -- 数据日期
    ,pk_col varchar2(150) -- PK_COL
    ,loan_ref_no varchar2(150) -- 债项编号
    ,fund_cd varchar2(90) -- 资产管理产品编号
    ,fund_name varchar2(300) -- 资产管理产品名称
    ,sa_calculate_id varchar2(30) -- 标准法计量方法标识
    ,sa_calculate_name varchar2(60) -- 标准法计量方法名称
    ,on_off_id varchar2(15) -- 表内外标志
    ,accorg_no varchar2(30) -- 入账机构
    ,accorg_name varchar2(383) -- 入账机构名称
    ,product_cd varchar2(60) -- 产品编号
    ,product_name varchar2(600) -- 产品名称
    ,five_class_name varchar2(30) -- 五级分类名称
    ,overdue_days number(22) -- 逾期天数
    ,std_default_flag varchar2(15) -- 逾期标志
    ,cust_no varchar2(150) -- 客户号
    ,cust_name varchar2(384) -- 客户名称
    ,ccp_type_cd varchar2(60) -- 交易对手类型
    ,ccp_type_name varchar2(300) -- 交易对手类型名称
    ,scale_cd varchar2(60) -- 企业规模代码
    ,scale_name varchar2(90) -- 企业规模代码名称
    ,ead_tot number(18,2) -- 客户总风险暴露(万)
    ,fm_asset_amt number(18,2) -- 资管产品总资产
    ,fm_hold_ratio number(18,6) -- 资管产品持有比例
    ,fm_fin_product_amt number(18,2) -- 资管产品净资产
    ,fm_lvg number(18,6) -- 资管产品杠杆率
    ,fm_rwa_ccp number(18,2) -- 资管产品CCP风险加权资产
    ,fm_rwa_cva number(18,2) -- 资管产品CVA
    ,fm_flag varchar2(3) -- 资管产品标志
    ,fm_avg_rw number(18,6) -- 资管产品基础资产平均权重
    ,fm_alvg_rw number(18,6) -- 资管产品调整杠杆率后的权重
    ,ccf number(18,6) -- 表外信用风险转换系数
    ,ccy_cd varchar2(15) -- 币种代码
    ,subject_cd varchar2(24) -- 本金科目代码
    ,subject_name varchar2(300) -- 本金科目名称
    ,pric_bal_origcurr number(18,2) -- 本金余额（原币）
    ,pric_bal number(18,2) -- 本金余额（本币）
    ,asset_balance number(18,2) -- 资产余额（本币）
    ,accrued_subject_cd varchar2(24) -- 应计利息科目
    ,accrued_subject_name varchar2(300) -- 应计利息科目名称
    ,accrued_int number(18,2) -- 应计利息（本币）
    ,receivable_subject_cd varchar2(24) -- 应收利息科目
    ,receivable_subject_name varchar2(300) -- 应收利息科目名称
    ,receivable_int number(18,2) -- 应收利息（本币）
    ,accrued_receiv_subject_cd varchar2(24) -- 应收未收利息科目
    ,accrued_receiv_subject_name varchar2(300) -- 应收未收利息名称
    ,accrued_receiv_int number(18,2) -- 应收未收利息（本币）
    ,intadj_subject_cd varchar2(24) -- 利息调整科目
    ,intadj_subject_name varchar2(300) -- 利息调整科目名称
    ,int_adj number(18,2) -- 利息调整（本币）
    ,fairchange_subject_cd varchar2(24) -- 公允价值变动科目
    ,fairchange_subject_name varchar2(300) -- 公允价值变动科目名称
    ,fairvalue_changes number(18,2) -- 公允价值变动（本币）
    ,provision_subject_cd varchar2(24) -- 准备金科目代码
    ,provision_subject_name varchar2(300) -- 准备金科目名称
    ,provision number(18,2) -- 准备金（本币）
    ,provesion_ratio number(18,6) -- 准备金计提比例
    ,ead_orig number(18,2) -- 原始风险暴露本币
    ,ead_pen number(18,2) -- 穿透法扣减准备金后EAD
    ,rwa_pen number(18,2) -- 穿透法RWA
    ,ead_pen_third number(18,2) -- 第三方穿透法EAD
    ,rwa_pen_third number(18,2) -- 第三方穿透法RWA
    ,ead_abl number(18,2) -- 授权基础法扣减准备金后EAD
    ,rwa_abl number(18,2) -- 授权基础法RWA
    ,ead_pullb number(18,2) -- 适用于1250%部分扣减准备金后EAD
    ,rwa_pullb number(18,2) -- 适用于1250%部分RWA
    ,rwa_before_adj number(18,2) -- 调整前风险加权资产
    ,rwa_after_adj number(18,2) -- 调整后风险加权资产
    ,adj_flag varchar2(15) -- 是否调整标志
    ,g4b_r_item_code varchar2(150) -- G4B-5项目
    ,investment_vaild_flag varchar2(15) -- 投资级认定是否在有效期内
    ,recognition_date date -- 认定日期
    ,load_date varchar2(30) -- 加载日期
    ,final_weight varchar2(30) -- 最终风险权重
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
grant select on ${iol_schema}.rwas_rpt_asset_manager_result to ${iml_schema};
grant select on ${iol_schema}.rwas_rpt_asset_manager_result to ${icl_schema};
grant select on ${iol_schema}.rwas_rpt_asset_manager_result to ${idl_schema};
grant select on ${iol_schema}.rwas_rpt_asset_manager_result to ${iel_schema};

-- comment
comment on table ${iol_schema}.rwas_rpt_asset_manager_result is '内部管理报表_资管产品计量明细';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.data_date is '数据日期';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.pk_col is 'PK_COL';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.loan_ref_no is '债项编号';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fund_cd is '资产管理产品编号';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fund_name is '资产管理产品名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.sa_calculate_id is '标准法计量方法标识';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.sa_calculate_name is '标准法计量方法名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.on_off_id is '表内外标志';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.accorg_no is '入账机构';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.accorg_name is '入账机构名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.product_cd is '产品编号';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.product_name is '产品名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.five_class_name is '五级分类名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.overdue_days is '逾期天数';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.std_default_flag is '逾期标志';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.cust_no is '客户号';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.cust_name is '客户名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.ccp_type_cd is '交易对手类型';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.ccp_type_name is '交易对手类型名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.scale_cd is '企业规模代码';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.scale_name is '企业规模代码名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.ead_tot is '客户总风险暴露(万)';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fm_asset_amt is '资管产品总资产';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fm_hold_ratio is '资管产品持有比例';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fm_fin_product_amt is '资管产品净资产';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fm_lvg is '资管产品杠杆率';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fm_rwa_ccp is '资管产品CCP风险加权资产';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fm_rwa_cva is '资管产品CVA';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fm_flag is '资管产品标志';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fm_avg_rw is '资管产品基础资产平均权重';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fm_alvg_rw is '资管产品调整杠杆率后的权重';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.ccf is '表外信用风险转换系数';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.ccy_cd is '币种代码';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.subject_cd is '本金科目代码';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.subject_name is '本金科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.pric_bal_origcurr is '本金余额（原币）';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.pric_bal is '本金余额（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.asset_balance is '资产余额（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.accrued_subject_cd is '应计利息科目';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.accrued_subject_name is '应计利息科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.accrued_int is '应计利息（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.receivable_subject_cd is '应收利息科目';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.receivable_subject_name is '应收利息科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.receivable_int is '应收利息（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.accrued_receiv_subject_cd is '应收未收利息科目';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.accrued_receiv_subject_name is '应收未收利息名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.accrued_receiv_int is '应收未收利息（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.intadj_subject_cd is '利息调整科目';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.intadj_subject_name is '利息调整科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.int_adj is '利息调整（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fairchange_subject_cd is '公允价值变动科目';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fairchange_subject_name is '公允价值变动科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.fairvalue_changes is '公允价值变动（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.provision_subject_cd is '准备金科目代码';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.provision_subject_name is '准备金科目名称';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.provision is '准备金（本币）';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.provesion_ratio is '准备金计提比例';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.ead_orig is '原始风险暴露本币';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.ead_pen is '穿透法扣减准备金后EAD';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.rwa_pen is '穿透法RWA';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.ead_pen_third is '第三方穿透法EAD';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.rwa_pen_third is '第三方穿透法RWA';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.ead_abl is '授权基础法扣减准备金后EAD';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.rwa_abl is '授权基础法RWA';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.ead_pullb is '适用于1250%部分扣减准备金后EAD';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.rwa_pullb is '适用于1250%部分RWA';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.rwa_before_adj is '调整前风险加权资产';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.rwa_after_adj is '调整后风险加权资产';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.adj_flag is '是否调整标志';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.g4b_r_item_code is 'G4B-5项目';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.investment_vaild_flag is '投资级认定是否在有效期内';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.recognition_date is '认定日期';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.load_date is '加载日期';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.final_weight is '最终风险权重';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.rwas_rpt_asset_manager_result.etl_timestamp is 'ETL处理时间戳';
