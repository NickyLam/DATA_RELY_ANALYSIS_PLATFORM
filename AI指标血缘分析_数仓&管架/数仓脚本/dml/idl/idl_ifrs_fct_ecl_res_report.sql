/*
Purpose:    应用集市层-跑批脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_ifrs_fct_ecl_res_report
CreateDate: 20250211
FileType:   DML
Logs:
*/

set timing on;

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;

-- 2.1 drop timeout partition and add partition
whenever sqlerror continue none;
alter table ${idl_schema}.ifrs_fct_ecl_res_report drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.ifrs_fct_ecl_res_report add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.ifrs_fct_ecl_res_report (
d_date_dt  --数据日期
,n_asset_class_cd  --敞口代码
,v_id_number  --借据号
,v_cust_cd  --客户号
,v_cust_name  --客户名称
,v_pd_internal  --pd模型
,v_regul_classif_cd  --五级分类
,v_internal_rating  --内部评级
,v_issuer_rating  --发行人评级
,v_obligation_rating  --债项评级
,n_odus_days  --逾期天数
,n_phase_division_cd  --阶段划分
,n_cur  --余额
,n_int  --利息
,n_slow  --缓释品金额
,n_ead_fin  --ead
,n_pd  --pd
,n_lgd_fin  --lgd
,n_ecl  --ecl
,v_three_stage_cd  --三分类
,v_produck_type_s_cd  --产品/债券类型
,d_acct_open_date  --起息日
,d_acct_expire_date  --到期日
,n_residual_maturity  --剩余期限
,n_odue_days_cur  --本金逾期天数
,n_odue_days_int  --利息逾期天数
,v_sub_cd  --科目号
,v_sub_name  --科目名称
,v_org_cd  --机构号
,v_org_name  --机构名称
,n_ead_fin_before  --原币ead
,n_ecl_before  --原币ecl
,v_ccy_cd_before  --原币币种
,n_cur_before  --原币余额
,n_int_before  --原币利息
,n_slow_before  --原币缓释品金额
,v_invest_indust_cd  --国际行业
,n_ecl_dcf  --dcf调整后的ecl
,n_ecl_before_dcf  --dcf调整后的原币ecl
,v_dfc_ecl_cd  --调整后：’dcf‘ 未调整： ’‘
,rate_fin  --
,v_financial_id  --金融工具表编号
,v_bill_no  --汇票号
,execu_org_no  --经办机构
,execu_org_name  --经办机构名称
,n_pv_variation  --公允价值变动_折人民币
,n_balance_face  --面值_展示
,n_int_adj_bal  --利息调整_展示
,n_int_receivable  --应收利息_展示
,n_int_accrued  --应计利息_展示
,fin_instm_name  --金融工具名称
,guartor_cust_name  --担保客户名称
,v_value_model_name  --估值模型名称
,n_pv_variation_lastday  --前一天公允价值变动_折人民币
,level5_class_cd  --五级分类代码
,v_tx_cust_name  --贴现人客户名称
,v_group_cust_no  --集团客户号
,v_group_cust_name  --集团客户名称
,v_book_val  --账面价值
,v_produck_type_cd  --产品大类
,asset_type_name  --产品分类
,v_bond_id  --债券编号
,intnal_secu_acct_id  --内部证券账户编号
,separate_code  --分池代码
,tax_ecl  --代垫增值税ecl
,tax_ecl_before  --代垫增值税原币ecl
,tax_balance  --代垫增值税余额
,tax_balance_before  --代垫增值税原币余额
,total_ecl  --ecl汇总
,total_ecl_before  --原币ecl汇总
,v_pd_mode  --pd新模型名称
,law_ecl  --代垫诉讼费ecl
,law_ecl_before  --代垫诉讼费原币ecl
,law_balance_before  --代垫诉讼费原币余额
,law_balance  --代垫诉讼费本币余额
,v_serialno  --减值逻辑主键
,recvbl_uncol_int  --应收未收利息
,n_int_receivable_before  --应收利息原币
,recvbl_uncol_int_before  --应收未收利息原币
,n_int_accrued_before  --应计利息原币
,int_recvbl_ecl  --应收利息ecl
,recvbl_uncol_int_ecl  --应收未收利息ecl
,n_int_accrued_ecl  --应计利息ecl
,n_int_receivable_ecl_before  --应收利息ecl原币
,recvbl_uncol_int_ecl_before  --应收未收利息ecl原币
,n_int_accrued_ecl_before  --应计利息ecl原币
,etl_dt  --etl处理日期
,etl_timestamp  --etl处理时间戳

)
select
t1.d_date_dt --数据日期
,t1.n_asset_class_cd as n_asset_class_cd --敞口代码
,replace(replace(t1.v_id_number,chr(13),''),chr(10),'') as v_id_number --借据号
,replace(replace(t1.v_cust_cd,chr(13),''),chr(10),'') as v_cust_cd --客户号
,replace(replace(t1.v_cust_name,chr(13),''),chr(10),'') as v_cust_name --客户名称
,replace(replace(t1.v_pd_internal,chr(13),''),chr(10),'') as v_pd_internal --pd模型
,replace(replace(t1.v_regul_classif_cd,chr(13),''),chr(10),'') as v_regul_classif_cd --五级分类
,replace(replace(t1.v_internal_rating,chr(13),''),chr(10),'') as v_internal_rating --内部评级
,replace(replace(t1.v_issuer_rating,chr(13),''),chr(10),'') as v_issuer_rating --发行人评级
,replace(replace(t1.v_obligation_rating,chr(13),''),chr(10),'') as v_obligation_rating --债项评级
,t1.n_odus_days as n_odus_days --逾期天数
,t1.n_phase_division_cd as n_phase_division_cd --阶段划分
,t1.n_cur as n_cur --余额
,t1.n_int as n_int --利息
,t1.n_slow as n_slow --缓释品金额
,t1.n_ead_fin as n_ead_fin --ead
,t1.n_pd as n_pd --pd
,t1.n_lgd_fin as n_lgd_fin --lgd
,t1.n_ecl as n_ecl --ecl
,replace(replace(t1.v_three_stage_cd,chr(13),''),chr(10),'') as v_three_stage_cd --三分类
,replace(replace(t1.v_produck_type_s_cd,chr(13),''),chr(10),'') as v_produck_type_s_cd --产品/债券类型
,t1.d_acct_open_date as d_acct_open_date --起息日
,t1.d_acct_expire_date as d_acct_expire_date --到期日
,t1.n_residual_maturity as n_residual_maturity --剩余期限
,t1.n_odue_days_cur as n_odue_days_cur --本金逾期天数
,t1.n_odue_days_int as n_odue_days_int --利息逾期天数
,replace(replace(t1.v_sub_cd,chr(13),''),chr(10),'') as v_sub_cd --科目号
,replace(replace(t1.v_sub_name,chr(13),''),chr(10),'') as v_sub_name --科目名称
,replace(replace(t1.v_org_cd,chr(13),''),chr(10),'') as v_org_cd --机构号
,replace(replace(t1.v_org_name,chr(13),''),chr(10),'') as v_org_name --机构名称
,t1.n_ead_fin_before as n_ead_fin_before --原币ead
,t1.n_ecl_before as n_ecl_before --原币ecl
,replace(replace(t1.v_ccy_cd_before,chr(13),''),chr(10),'') as v_ccy_cd_before --原币币种
,t1.n_cur_before as n_cur_before --原币余额
,t1.n_int_before as n_int_before --原币利息
,t1.n_slow_before as n_slow_before --原币缓释品金额
,replace(replace(t1.v_invest_indust_cd,chr(13),''),chr(10),'') as v_invest_indust_cd --国际行业
,t1.n_ecl_dcf as n_ecl_dcf --dcf调整后的ecl
,t1.n_ecl_before_dcf as n_ecl_before_dcf --dcf调整后的原币ecl
,replace(replace(t1.v_dfc_ecl_cd,chr(13),''),chr(10),'') as v_dfc_ecl_cd --调整后：’dcf‘ 未调整： ’‘
,replace(replace(t1.rate_fin,chr(13),''),chr(10),'') as rate_fin --
,replace(replace(t1.v_financial_id,chr(13),''),chr(10),'') as v_financial_id --金融工具表编号
,replace(replace(t1.v_bill_no,chr(13),''),chr(10),'') as v_bill_no --汇票号
,replace(replace(t1.execu_org_no,chr(13),''),chr(10),'') as execu_org_no --经办机构
,replace(replace(t1.execu_org_name,chr(13),''),chr(10),'') as execu_org_name --经办机构名称
,t1.n_pv_variation as n_pv_variation --公允价值变动_折人民币
,t1.n_balance_face as n_balance_face --面值_展示
,t1.n_int_adj_bal as n_int_adj_bal --利息调整_展示
,t1.n_int_receivable as n_int_receivable --应收利息_展示
,t1.n_int_accrued as n_int_accrued --应计利息_展示
,replace(replace(t1.fin_instm_name,chr(13),''),chr(10),'') as fin_instm_name --金融工具名称
,replace(replace(t1.guartor_cust_name,chr(13),''),chr(10),'') as guartor_cust_name --担保客户名称
,replace(replace(t1.v_value_model_name,chr(13),''),chr(10),'') as v_value_model_name --估值模型名称
,t1.n_pv_variation_lastday as n_pv_variation_lastday --前一天公允价值变动_折人民币
,replace(replace(t1.level5_class_cd,chr(13),''),chr(10),'') as level5_class_cd --五级分类代码
,replace(replace(t1.v_tx_cust_name,chr(13),''),chr(10),'') as v_tx_cust_name --贴现人客户名称
,replace(replace(t1.v_group_cust_no,chr(13),''),chr(10),'') as v_group_cust_no --集团客户号
,replace(replace(t1.v_group_cust_name,chr(13),''),chr(10),'') as v_group_cust_name --集团客户名称
,t1.v_book_val as v_book_val --账面价值
,replace(replace(t1.v_produck_type_cd,chr(13),''),chr(10),'') as v_produck_type_cd --产品大类
,replace(replace(t1.asset_type_name,chr(13),''),chr(10),'') as asset_type_name --产品分类
,replace(replace(t1.v_bond_id,chr(13),''),chr(10),'') as v_bond_id --债券编号
,replace(replace(t1.intnal_secu_acct_id,chr(13),''),chr(10),'') as intnal_secu_acct_id --内部证券账户编号
,replace(replace(t1.separate_code,chr(13),''),chr(10),'') as separate_code --分池代码
,t1.tax_ecl as tax_ecl --代垫增值税ecl
,t1.tax_ecl_before as tax_ecl_before --代垫增值税原币ecl
,t1.tax_balance as tax_balance --代垫增值税余额
,t1.tax_balance_before as tax_balance_before --代垫增值税原币余额
,t1.total_ecl as total_ecl --ecl汇总
,t1.total_ecl_before as total_ecl_before --原币ecl汇总
,replace(replace(t1.v_pd_mode,chr(13),''),chr(10),'') as v_pd_mode --pd新模型名称
,t1.law_ecl as law_ecl --代垫诉讼费ecl
,t1.law_ecl_before as law_ecl_before --代垫诉讼费原币ecl
,t1.law_balance_before as law_balance_before --代垫诉讼费原币余额
,t1.law_balance as law_balance --代垫诉讼费本币余额
,replace(replace(t1.v_serialno,chr(13),''),chr(10),'') as v_serialno --减值逻辑主键
,t1.recvbl_uncol_int as recvbl_uncol_int --应收未收利息
,t1.n_int_receivable_before as n_int_receivable_before --应收利息原币
,t1.recvbl_uncol_int_before as recvbl_uncol_int_before --应收未收利息原币
,t1.n_int_accrued_before as n_int_accrued_before --应计利息原币
,t1.int_recvbl_ecl as int_recvbl_ecl --应收利息ecl
,t1.recvbl_uncol_int_ecl as recvbl_uncol_int_ecl --应收未收利息ecl
,t1.n_int_accrued_ecl as n_int_accrued_ecl --应计利息ecl
,t1.n_int_receivable_ecl_before as n_int_receivable_ecl_before --应收利息ecl原币
,t1.recvbl_uncol_int_ecl_before as recvbl_uncol_int_ecl_before --应收未收利息ecl原币
,t1.n_int_accrued_ecl_before as n_int_accrued_ecl_before --应计利息ecl原币
,to_date('${batch_date}','yyyymmdd') as etl_dt --etl处理日期
,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp --etl处理时间戳
from ${iol_schema}.ifrs_fct_ecl_res_report t1    --I9减值结果历史表
where t1.etl_dt = to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'ifrs_fct_ecl_res_report',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);
