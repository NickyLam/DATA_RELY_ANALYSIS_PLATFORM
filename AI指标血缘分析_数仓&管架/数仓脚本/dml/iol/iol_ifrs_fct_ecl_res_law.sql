/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifrs_fct_ecl_res_law
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifrs_fct_ecl_res_law_ex purge;
alter table ${iol_schema}.ifrs_fct_ecl_res_law add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifrs_fct_ecl_res_law truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifrs_fct_ecl_res_law_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifrs_fct_ecl_res_law where 0=1;

insert /*+ append */ into ${iol_schema}.ifrs_fct_ecl_res_law_ex(
    d_date_dt -- 数据日期
    ,n_asset_class_cd -- 敞口代码
    ,v_id_number -- 借据号
    ,v_cust_cd -- 客户名
    ,v_cust_name -- 客户号
    ,v_pd_internal -- PD模型
    ,v_regul_classif_cd -- 五级分类
    ,v_internal_rating -- 内部评级
    ,v_issuer_rating -- 发行人评级
    ,v_obligation_rating -- 债项评级
    ,n_odus_days -- 逾期天数
    ,n_phase_division_cd -- 阶段划分
    ,n_cur -- 余额
    ,n_int -- 利息
    ,n_slow -- 缓释品金额
    ,n_ead_fin -- EAD
    ,n_pd -- PD
    ,n_lgd_fin -- LGD
    ,n_ecl -- ECL
    ,v_three_stage_cd -- 三分类
    ,v_produck_type_cd -- 产品大类
    ,v_produck_type_s_cd -- 产品小类
    ,v_ccy_cd -- 币种(CNY)
    ,d_acct_open_date -- 起息日
    ,d_acct_expire_date -- 到期日
    ,n_residual_maturity -- 剩余期限
    ,n_odue_days_cur -- 本金逾期天数
    ,n_odue_days_int -- 利息逾期天数
    ,v_blick -- 铁骑清单
    ,v_sub_cd -- 科目号
    ,v_sub_name -- 科目名称
    ,v_org_cd -- 机构号
    ,v_org_name -- 机构名称
    ,before_adjustment_coefficient -- 输入系数
    ,before_n_adjustment_ecl -- 调整后的ECL
    ,n_ead_fin_before -- 原币EAD
    ,n_ecl_before -- 原币ECL
    ,v_ccy_cd_before -- 原币币种
    ,n_cur_before -- 原币本金余额
    ,n_int_before -- 原币利息
    ,n_slow_before -- 原币缓释品金额
    ,v_around_sign -- 表内外标识
    ,v_invest_indust_cd -- 国际行业
    ,n_lgd_before -- 基础LGD
    ,v_account_ageing -- 账龄
    ,v_dfc_ecl_cd -- 调整后：’DCF‘ 未调整： ’ECL‘
    ,industry_name -- 国际行业（报表用）
    ,n_ecl_dcf -- DCF调整后的ECL
    ,n_ecl_before_dcf -- DCF调整后的原币ECL
    ,issue_bank_cn_name -- 开证行
    ,rate_fin -- 最终评级
    ,v_financial_id -- 金融工具表编号
    ,v_bond_id -- 债券编号
    ,v_forecast_mod -- 旧版模型分组 预测用
    ,v_bill_no -- 汇票号
    ,execu_org_no -- 经办机构
    ,execu_org_name -- 经办机构名称
    ,n_pv_variation -- 公允价值变动_折人民币
    ,n_balance_face -- 面值_展示
    ,n_int_adj_bal -- 利息调整_展示
    ,n_int_receivable -- 应收利息_展示
    ,n_int_accrued -- 应计利息_展示
    ,fin_instm_name -- 金融工具名称
    ,asset_type_name -- 产品分类
    ,guartor_cust_name -- 担保客户名称
    ,v_value_model_name -- 估值模型名称
    ,pv_variation -- 原币公允价值
    ,intnal_secu_acct_id -- 内部证券账户编号
    ,n_pv_variation_lastday -- 前一天公允价值变动_折人民币
    ,pv_variation_lastday -- 前一天公允价值变动_原币
    ,v_serialno -- 减值借据号_物理展示
    ,biz_no -- 贴现转贴现主键
    ,level5_class_cd -- 五级分类代码
    ,product_no -- 产品编码
    ,v_tx_cust_name -- 票据贴现人
    ,v_group_cust_no -- 集团客户号
    ,v_group_cust_name -- 集团客户名
    ,bill_no -- 票据编号BILL_NO
    ,bill_sub_intrv_id -- 子票据区间编号
    ,glob_seq_num -- 全局流水号
    ,unique_seq_num -- 业务流水号
    ,tax_ecl -- 垫付增值税ECL
    ,tax_ecl_before -- 垫付增值税原币ECL
    ,tax_balance_before -- 垫付增值税原币余额
    ,tax_balance -- 垫付增值税余额
    ,total_ecl -- ECL汇总
    ,total_ecl_before -- 原币ECL汇总
    ,market_type_id -- 交易市场编号
    ,separate_code -- 分池代码
    ,v_pd_mode -- PD新模型名称
    ,n_cur_ead -- 本金EAD
    ,n_int_ead -- 利息EAD
    ,n_off_ead -- 表外EAD
    ,n_cur_ecl -- 本金ECL
    ,n_int_ecl -- 利息ECL
    ,n_off_ecl -- 表外ECL
    ,bond_item_no -- 借据号（获取押品使用）
    ,add_pd_mul_lgd -- 管理层叠加PD*LGD
    ,before_pd_mul_lgd -- 管理层叠加前PD
    ,before_ecl -- 管理层叠加前ECL
    ,add_ecl -- 管理层叠加后ECL
    ,add_n_cur_ecl -- 管理层叠加后本金ECL
    ,before_n_cur_ecl -- 管理层叠加前本金ECL
    ,add_n_int_ecl -- 管理层叠加后利息ECL
    ,before_n_int_ecl -- 管理层叠加前利息ECL
    ,add_n_off_ecl -- 管理层叠加后表外ECL
    ,before_n_off_ecl -- 管理层叠加前表外ECL
    ,add_n_pd -- 管理层叠加N_PD
    ,before_n_pd -- 管理层叠加前N_PD
    ,recvbl_uncol_int -- 应收未收利息
    ,recvbl_uncol_int_ecl -- 应收未收利息ECL
    ,int_recvbl_ecl -- 应收利息ECL
    ,n_int_accrued_ecl -- 应计利息ECL
    ,law_ecl -- 代垫诉讼费ECL
    ,law_ecl_before -- 代垫诉讼费原币ECL
    ,law_balance_before -- 代垫诉讼费原币余额
    ,law_balance -- 代垫诉讼费本币余额
    ,n_int_receivable_before -- 应收利息原币
    ,recvbl_uncol_int_before -- 应收未收利息原币
    ,n_int_accrued_before -- 应计利息原币
    ,n_int_receivable_ecl_before -- 应收利息ECL原币
    ,recvbl_uncol_int_ecl_before -- 应收未收利息ECL原币
    ,n_int_accrued_ecl_before -- 应计利息ECL原币
    ,exec_int_rate -- 执行利率
    ,remark -- 备注
    ,edit_ecl -- 预期信用损失ECL_审计调整
    ,edit_phase_division -- 阶段划分_审计调整
    ,edit_regul_classif_cd -- 五级分类_审计调整
    ,edit_three_stage_cd -- 三分类_审计调整
    ,v_book_val -- 账面价值
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    d_date_dt -- 数据日期
    ,n_asset_class_cd -- 敞口代码
    ,v_id_number -- 借据号
    ,v_cust_cd -- 客户名
    ,v_cust_name -- 客户号
    ,v_pd_internal -- PD模型
    ,v_regul_classif_cd -- 五级分类
    ,v_internal_rating -- 内部评级
    ,v_issuer_rating -- 发行人评级
    ,v_obligation_rating -- 债项评级
    ,n_odus_days -- 逾期天数
    ,n_phase_division_cd -- 阶段划分
    ,n_cur -- 余额
    ,n_int -- 利息
    ,n_slow -- 缓释品金额
    ,n_ead_fin -- EAD
    ,n_pd -- PD
    ,n_lgd_fin -- LGD
    ,n_ecl -- ECL
    ,v_three_stage_cd -- 三分类
    ,v_produck_type_cd -- 产品大类
    ,v_produck_type_s_cd -- 产品小类
    ,v_ccy_cd -- 币种(CNY)
    ,d_acct_open_date -- 起息日
    ,d_acct_expire_date -- 到期日
    ,n_residual_maturity -- 剩余期限
    ,n_odue_days_cur -- 本金逾期天数
    ,n_odue_days_int -- 利息逾期天数
    ,v_blick -- 铁骑清单
    ,v_sub_cd -- 科目号
    ,v_sub_name -- 科目名称
    ,v_org_cd -- 机构号
    ,v_org_name -- 机构名称
    ,before_adjustment_coefficient -- 输入系数
    ,before_n_adjustment_ecl -- 调整后的ECL
    ,n_ead_fin_before -- 原币EAD
    ,n_ecl_before -- 原币ECL
    ,v_ccy_cd_before -- 原币币种
    ,n_cur_before -- 原币本金余额
    ,n_int_before -- 原币利息
    ,n_slow_before -- 原币缓释品金额
    ,v_around_sign -- 表内外标识
    ,v_invest_indust_cd -- 国际行业
    ,n_lgd_before -- 基础LGD
    ,v_account_ageing -- 账龄
    ,v_dfc_ecl_cd -- 调整后：’DCF‘ 未调整： ’ECL‘
    ,industry_name -- 国际行业（报表用）
    ,n_ecl_dcf -- DCF调整后的ECL
    ,n_ecl_before_dcf -- DCF调整后的原币ECL
    ,issue_bank_cn_name -- 开证行
    ,rate_fin -- 最终评级
    ,v_financial_id -- 金融工具表编号
    ,v_bond_id -- 债券编号
    ,v_forecast_mod -- 旧版模型分组 预测用
    ,v_bill_no -- 汇票号
    ,execu_org_no -- 经办机构
    ,execu_org_name -- 经办机构名称
    ,n_pv_variation -- 公允价值变动_折人民币
    ,n_balance_face -- 面值_展示
    ,n_int_adj_bal -- 利息调整_展示
    ,n_int_receivable -- 应收利息_展示
    ,n_int_accrued -- 应计利息_展示
    ,fin_instm_name -- 金融工具名称
    ,asset_type_name -- 产品分类
    ,guartor_cust_name -- 担保客户名称
    ,v_value_model_name -- 估值模型名称
    ,pv_variation -- 原币公允价值
    ,intnal_secu_acct_id -- 内部证券账户编号
    ,n_pv_variation_lastday -- 前一天公允价值变动_折人民币
    ,pv_variation_lastday -- 前一天公允价值变动_原币
    ,v_serialno -- 减值借据号_物理展示
    ,biz_no -- 贴现转贴现主键
    ,level5_class_cd -- 五级分类代码
    ,product_no -- 产品编码
    ,v_tx_cust_name -- 票据贴现人
    ,v_group_cust_no -- 集团客户号
    ,v_group_cust_name -- 集团客户名
    ,bill_no -- 票据编号BILL_NO
    ,bill_sub_intrv_id -- 子票据区间编号
    ,glob_seq_num -- 全局流水号
    ,unique_seq_num -- 业务流水号
    ,tax_ecl -- 垫付增值税ECL
    ,tax_ecl_before -- 垫付增值税原币ECL
    ,tax_balance_before -- 垫付增值税原币余额
    ,tax_balance -- 垫付增值税余额
    ,total_ecl -- ECL汇总
    ,total_ecl_before -- 原币ECL汇总
    ,market_type_id -- 交易市场编号
    ,separate_code -- 分池代码
    ,v_pd_mode -- PD新模型名称
    ,n_cur_ead -- 本金EAD
    ,n_int_ead -- 利息EAD
    ,n_off_ead -- 表外EAD
    ,n_cur_ecl -- 本金ECL
    ,n_int_ecl -- 利息ECL
    ,n_off_ecl -- 表外ECL
    ,bond_item_no -- 借据号（获取押品使用）
    ,add_pd_mul_lgd -- 管理层叠加PD*LGD
    ,before_pd_mul_lgd -- 管理层叠加前PD
    ,before_ecl -- 管理层叠加前ECL
    ,add_ecl -- 管理层叠加后ECL
    ,add_n_cur_ecl -- 管理层叠加后本金ECL
    ,before_n_cur_ecl -- 管理层叠加前本金ECL
    ,add_n_int_ecl -- 管理层叠加后利息ECL
    ,before_n_int_ecl -- 管理层叠加前利息ECL
    ,add_n_off_ecl -- 管理层叠加后表外ECL
    ,before_n_off_ecl -- 管理层叠加前表外ECL
    ,add_n_pd -- 管理层叠加N_PD
    ,before_n_pd -- 管理层叠加前N_PD
    ,recvbl_uncol_int -- 应收未收利息
    ,recvbl_uncol_int_ecl -- 应收未收利息ECL
    ,int_recvbl_ecl -- 应收利息ECL
    ,n_int_accrued_ecl -- 应计利息ECL
    ,law_ecl -- 代垫诉讼费ECL
    ,law_ecl_before -- 代垫诉讼费原币ECL
    ,law_balance_before -- 代垫诉讼费原币余额
    ,law_balance -- 代垫诉讼费本币余额
    ,n_int_receivable_before -- 应收利息原币
    ,recvbl_uncol_int_before -- 应收未收利息原币
    ,n_int_accrued_before -- 应计利息原币
    ,n_int_receivable_ecl_before -- 应收利息ECL原币
    ,recvbl_uncol_int_ecl_before -- 应收未收利息ECL原币
    ,n_int_accrued_ecl_before -- 应计利息ECL原币
    ,exec_int_rate -- 执行利率
    ,remark -- 备注
    ,edit_ecl -- 预期信用损失ECL_审计调整
    ,edit_phase_division -- 阶段划分_审计调整
    ,edit_regul_classif_cd -- 五级分类_审计调整
    ,edit_three_stage_cd -- 三分类_审计调整
    ,v_book_val -- 账面价值
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifrs_fct_ecl_res_law
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifrs_fct_ecl_res_law exchange partition p_${batch_date} with table ${iol_schema}.ifrs_fct_ecl_res_law_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifrs_fct_ecl_res_law to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifrs_fct_ecl_res_law_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifrs_fct_ecl_res_law',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);