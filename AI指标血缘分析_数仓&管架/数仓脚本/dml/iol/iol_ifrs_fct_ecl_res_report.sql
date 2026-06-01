/*
Purpose:    偏源模型层-增量流水脚本，清空目标表当天分区，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifrs_fct_ecl_res_report
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
drop table ${iol_schema}.ifrs_fct_ecl_res_report_ex purge;
alter table ${iol_schema}.ifrs_fct_ecl_res_report add partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.2 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iol_schema}.ifrs_fct_ecl_res_report truncate partition p_${batch_date};

-- 2.3 insert data to ex table
create table ${iol_schema}.ifrs_fct_ecl_res_report_ex nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifrs_fct_ecl_res_report where 0=1;

insert /*+ append */ into ${iol_schema}.ifrs_fct_ecl_res_report_ex(
    d_date_dt -- 数据日期
    ,n_asset_class_cd -- 敞口代码
    ,v_id_number -- 借据号
    ,v_cust_cd -- 客户号
    ,v_cust_name -- 客户名称
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
    ,v_produck_type_s_cd -- 产品/债券类型
    ,d_acct_open_date -- 起息日
    ,d_acct_expire_date -- 到期日
    ,n_residual_maturity -- 剩余期限
    ,n_odue_days_cur -- 本金逾期天数
    ,n_odue_days_int -- 利息逾期天数
    ,v_sub_cd -- 科目号
    ,v_sub_name -- 科目名称
    ,v_org_cd -- 机构号
    ,v_org_name -- 机构名称
    ,n_ead_fin_before -- 原币ead
    ,n_ecl_before -- 原币ecl
    ,v_ccy_cd_before -- 原币币种
    ,n_cur_before -- 原币余额
    ,n_int_before -- 原币利息
    ,n_slow_before -- 原币缓释品金额
    ,v_invest_indust_cd -- 国际行业
    ,n_ecl_dcf -- dcf调整后的ecl
    ,n_ecl_before_dcf -- dcf调整后的原币ecl
    ,v_dfc_ecl_cd -- 调整后：’dcf‘ 未调整： ’‘
    ,rate_fin -- 
    ,v_financial_id -- 金融工具表编号
    ,v_bill_no -- 汇票号
    ,execu_org_no -- 经办机构
    ,execu_org_name -- 经办机构名称
    ,n_pv_variation -- 公允价值变动_折人民币
    ,n_balance_face -- 面值_展示
    ,n_int_adj_bal -- 利息调整_展示
    ,n_int_receivable -- 应收利息_展示
    ,n_int_accrued -- 应计利息_展示
    ,fin_instm_name -- 金融工具名称
    ,guartor_cust_name -- 担保客户名称
    ,v_value_model_name -- 估值模型名称
    ,n_pv_variation_lastday -- 前一天公允价值变动_折人民币
    ,level5_class_cd -- 五级分类代码
    ,v_tx_cust_name -- 贴现人客户名称
    ,v_group_cust_no -- 集团客户号
    ,v_group_cust_name -- 集团客户名称
    ,v_book_val -- 账面价值
    ,v_produck_type_cd -- 产品大类
    ,asset_type_name -- 产品分类
    ,v_bond_id -- 债券编号
    ,intnal_secu_acct_id -- 内部证券账户编号
    ,separate_code -- 分池代码
    ,tax_ecl -- 代垫增值税ECL
    ,tax_ecl_before -- 代垫增值税原币ECL
    ,tax_balance -- 代垫增值税余额
    ,tax_balance_before -- 代垫增值税原币余额
    ,total_ecl -- ECL汇总
    ,total_ecl_before -- 原币ECL汇总
    ,v_pd_mode -- PD新模型名称
    ,law_ecl -- 代垫诉讼费ECL
    ,law_ecl_before -- 代垫诉讼费原币ECL
    ,law_balance_before -- 代垫诉讼费原币余额
    ,law_balance -- 代垫诉讼费本币余额
    ,v_serialno -- 减值逻辑主键
    ,recvbl_uncol_int -- 应收未收利息
    ,n_int_receivable_before -- 应收利息原币
    ,recvbl_uncol_int_before -- 应收未收利息原币
    ,n_int_accrued_before -- 应计利息原币
    ,int_recvbl_ecl -- 应收利息ECL
    ,recvbl_uncol_int_ecl -- 应收未收利息ECL
    ,n_int_accrued_ecl -- 应计利息ECL
    ,n_int_receivable_ecl_before -- 应收利息ECL原币
    ,recvbl_uncol_int_ecl_before -- 应收未收利息ECL原币
    ,n_int_accrued_ecl_before -- 应计利息ECL原币
    ,etl_dt -- ETL处理日期
    ,etl_timestamp -- ETL处理时间戳
)
select
    d_date_dt -- 数据日期
    ,n_asset_class_cd -- 敞口代码
    ,v_id_number -- 借据号
    ,v_cust_cd -- 客户号
    ,v_cust_name -- 客户名称
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
    ,v_produck_type_s_cd -- 产品/债券类型
    ,d_acct_open_date -- 起息日
    ,d_acct_expire_date -- 到期日
    ,n_residual_maturity -- 剩余期限
    ,n_odue_days_cur -- 本金逾期天数
    ,n_odue_days_int -- 利息逾期天数
    ,v_sub_cd -- 科目号
    ,v_sub_name -- 科目名称
    ,v_org_cd -- 机构号
    ,v_org_name -- 机构名称
    ,n_ead_fin_before -- 原币ead
    ,n_ecl_before -- 原币ecl
    ,v_ccy_cd_before -- 原币币种
    ,n_cur_before -- 原币余额
    ,n_int_before -- 原币利息
    ,n_slow_before -- 原币缓释品金额
    ,v_invest_indust_cd -- 国际行业
    ,n_ecl_dcf -- dcf调整后的ecl
    ,n_ecl_before_dcf -- dcf调整后的原币ecl
    ,v_dfc_ecl_cd -- 调整后：’dcf‘ 未调整： ’‘
    ,rate_fin -- 
    ,v_financial_id -- 金融工具表编号
    ,v_bill_no -- 汇票号
    ,execu_org_no -- 经办机构
    ,execu_org_name -- 经办机构名称
    ,n_pv_variation -- 公允价值变动_折人民币
    ,n_balance_face -- 面值_展示
    ,n_int_adj_bal -- 利息调整_展示
    ,n_int_receivable -- 应收利息_展示
    ,n_int_accrued -- 应计利息_展示
    ,fin_instm_name -- 金融工具名称
    ,guartor_cust_name -- 担保客户名称
    ,v_value_model_name -- 估值模型名称
    ,n_pv_variation_lastday -- 前一天公允价值变动_折人民币
    ,level5_class_cd -- 五级分类代码
    ,v_tx_cust_name -- 贴现人客户名称
    ,v_group_cust_no -- 集团客户号
    ,v_group_cust_name -- 集团客户名称
    ,v_book_val -- 账面价值
    ,v_produck_type_cd -- 产品大类
    ,asset_type_name -- 产品分类
    ,v_bond_id -- 债券编号
    ,intnal_secu_acct_id -- 内部证券账户编号
    ,separate_code -- 分池代码
    ,tax_ecl -- 代垫增值税ECL
    ,tax_ecl_before -- 代垫增值税原币ECL
    ,tax_balance -- 代垫增值税余额
    ,tax_balance_before -- 代垫增值税原币余额
    ,total_ecl -- ECL汇总
    ,total_ecl_before -- 原币ECL汇总
    ,v_pd_mode -- PD新模型名称
    ,law_ecl -- 代垫诉讼费ECL
    ,law_ecl_before -- 代垫诉讼费原币ECL
    ,law_balance_before -- 代垫诉讼费原币余额
    ,law_balance -- 代垫诉讼费本币余额
    ,v_serialno -- 减值逻辑主键
    ,recvbl_uncol_int -- 应收未收利息
    ,n_int_receivable_before -- 应收利息原币
    ,recvbl_uncol_int_before -- 应收未收利息原币
    ,n_int_accrued_before -- 应计利息原币
    ,int_recvbl_ecl -- 应收利息ECL
    ,recvbl_uncol_int_ecl -- 应收未收利息ECL
    ,n_int_accrued_ecl -- 应计利息ECL
    ,n_int_receivable_ecl_before -- 应收利息ECL原币
    ,recvbl_uncol_int_ecl_before -- 应收未收利息ECL原币
    ,n_int_accrued_ecl_before -- 应计利息ECL原币
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${itl_schema}.ifrs_fct_ecl_res_report
where etl_dt = to_date('${batch_date}', 'yyyymmdd')
;

-- 2.4 exchage ex table and target table
alter table ${iol_schema}.ifrs_fct_ecl_res_report exchange partition p_${batch_date} with table ${iol_schema}.ifrs_fct_ecl_res_report_ex;

-- 3.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifrs_fct_ecl_res_report to ${iml_schema};

-- 3.2 drop ex table
drop table ${iol_schema}.ifrs_fct_ecl_res_report_ex purge;

-- 4 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifrs_fct_ecl_res_report',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);