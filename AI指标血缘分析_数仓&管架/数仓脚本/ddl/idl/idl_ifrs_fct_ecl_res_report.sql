/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl ifrs_fct_ecl_res_report
CreateDate: 20250102
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.ifrs_fct_ecl_res_report purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.ifrs_fct_ecl_res_report(
d_date_dt date --数据日期
,n_asset_class_cd number(10) --敞口代码
,v_id_number varchar2(450) --借据号
,v_cust_cd varchar2(90) --客户号
,v_cust_name varchar2(825) --客户名称
,v_pd_internal varchar2(30) --pd模型
,v_regul_classif_cd varchar2(15) --五级分类
,v_internal_rating varchar2(15) --内部评级
,v_issuer_rating varchar2(15) --发行人评级
,v_obligation_rating varchar2(15) --债项评级
,n_odus_days number(22) --逾期天数
,n_phase_division_cd number(4) --阶段划分
,n_cur number(26,2) --余额
,n_int number(26,2) --利息
,n_slow number(26,2) --缓释品金额
,n_ead_fin number(26,5) --ead
,n_pd number(10,5) --pd
,n_lgd_fin number(10,5) --lgd
,n_ecl number(26,5) --ecl
,v_three_stage_cd varchar2(150) --三分类
,v_produck_type_s_cd varchar2(90) --产品/债券类型
,d_acct_open_date date --起息日
,d_acct_expire_date date --到期日
,n_residual_maturity number(20) --剩余期限
,n_odue_days_cur number(22) --本金逾期天数
,n_odue_days_int number(22) --利息逾期天数
,v_sub_cd varchar2(30) --科目号
,v_sub_name varchar2(75) --科目名称
,v_org_cd varchar2(30) --机构号
,v_org_name varchar2(900) --机构名称
,n_ead_fin_before number(30,5) --原币ead
,n_ecl_before number(26,5) --原币ecl
,v_ccy_cd_before varchar2(15) --原币币种
,n_cur_before number(26,2) --原币余额
,n_int_before number(26,2) --原币利息
,n_slow_before number(26,2) --原币缓释品金额
,v_invest_indust_cd varchar2(45) --国际行业
,n_ecl_dcf number(26,5) --dcf调整后的ecl
,n_ecl_before_dcf number(26,5) --dcf调整后的原币ecl
,v_dfc_ecl_cd varchar2(15) --调整后：’dcf‘ 未调整： ’‘
,rate_fin varchar2(30) --
,v_financial_id varchar2(60) --金融工具表编号
,v_bill_no varchar2(150) --汇票号
,execu_org_no varchar2(90) --经办机构
,execu_org_name varchar2(150) --经办机构名称
,n_pv_variation number(26,2) --公允价值变动_折人民币
,n_balance_face number(26,2) --面值_展示
,n_int_adj_bal number(26,2) --利息调整_展示
,n_int_receivable number(26,2) --应收利息_展示
,n_int_accrued number(26,2) --应计利息_展示
,fin_instm_name varchar2(375) --金融工具名称
,guartor_cust_name varchar2(150) --担保客户名称
,v_value_model_name varchar2(150) --估值模型名称
,n_pv_variation_lastday number(26,2) --前一天公允价值变动_折人民币
,level5_class_cd varchar2(15) --五级分类代码
,v_tx_cust_name varchar2(750) --贴现人客户名称
,v_group_cust_no varchar2(90) --集团客户号
,v_group_cust_name varchar2(750) --集团客户名称
,v_book_val number(26,2) --账面价值
,v_produck_type_cd varchar2(90) --产品大类
,asset_type_name varchar2(90) --产品分类
,v_bond_id varchar2(60) --债券编号
,intnal_secu_acct_id varchar2(90) --内部证券账户编号
,separate_code varchar2(150) --分池代码
,tax_ecl number(30,2) --代垫增值税ecl
,tax_ecl_before number(30,2) --代垫增值税原币ecl
,tax_balance number(30,2) --代垫增值税余额
,tax_balance_before number(30,2) --代垫增值税原币余额
,total_ecl number(30,2) --ecl汇总
,total_ecl_before number(30,2) --原币ecl汇总
,v_pd_mode varchar2(30) --pd新模型名称
,law_ecl number(30,2) --代垫诉讼费ecl
,law_ecl_before number(30,2) --代垫诉讼费原币ecl
,law_balance_before number(30,2) --代垫诉讼费原币余额
,law_balance number(30,2) --代垫诉讼费本币余额
,v_serialno varchar2(450) --减值逻辑主键
,recvbl_uncol_int number(30,2) --应收未收利息
,n_int_receivable_before number(30,2) --应收利息原币
,recvbl_uncol_int_before number(30,2) --应收未收利息原币
,n_int_accrued_before number(30,2) --应计利息原币
,int_recvbl_ecl number(30,2) --应收利息ecl
,recvbl_uncol_int_ecl number(30,2) --应收未收利息ecl
,n_int_accrued_ecl number(30,2) --应计利息ecl
,n_int_receivable_ecl_before number(30,2) --应收利息ecl原币
,recvbl_uncol_int_ecl_before number(30,2) --应收未收利息ecl原币
,n_int_accrued_ecl_before number(30,2) --应计利息ecl原币
,etl_dt date --etl处理日期
,etl_timestamp timestamp(6) --etl处理时间戳

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.ifrs_fct_ecl_res_report to ${iel_schema};

-- comment
comment on table ${idl_schema}.ifrs_fct_ecl_res_report is 'I9减值结果历史表';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.d_date_dt is '数据日期';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_asset_class_cd is '敞口代码';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_id_number is '借据号';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_cust_cd is '客户号';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_cust_name is '客户名称';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_pd_internal is 'pd模型';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_regul_classif_cd is '五级分类';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_internal_rating is '内部评级';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_issuer_rating is '发行人评级';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_obligation_rating is '债项评级';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_odus_days is '逾期天数';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_phase_division_cd is '阶段划分';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_cur is '余额';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_int is '利息';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_slow is '缓释品金额';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_ead_fin is 'ead';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_pd is 'pd';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_lgd_fin is 'lgd';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_ecl is 'ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_three_stage_cd is '三分类';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_produck_type_s_cd is '产品/债券类型';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.d_acct_open_date is '起息日';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.d_acct_expire_date is '到期日';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_residual_maturity is '剩余期限';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_odue_days_cur is '本金逾期天数';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_odue_days_int is '利息逾期天数';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_sub_cd is '科目号';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_sub_name is '科目名称';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_org_cd is '机构号';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_org_name is '机构名称';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_ead_fin_before is '原币ead';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_ecl_before is '原币ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_ccy_cd_before is '原币币种';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_cur_before is '原币余额';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_int_before is '原币利息';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_slow_before is '原币缓释品金额';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_invest_indust_cd is '国际行业';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_ecl_dcf is 'dcf调整后的ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_ecl_before_dcf is 'dcf调整后的原币ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_dfc_ecl_cd is '调整后：’dcf‘ 未调整： ’‘';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.rate_fin is '';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_financial_id is '金融工具表编号';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_bill_no is '汇票号';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.execu_org_no is '经办机构';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.execu_org_name is '经办机构名称';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_pv_variation is '公允价值变动_折人民币';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_balance_face is '面值_展示';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_int_adj_bal is '利息调整_展示';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_int_receivable is '应收利息_展示';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_int_accrued is '应计利息_展示';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.fin_instm_name is '金融工具名称';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.guartor_cust_name is '担保客户名称';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_value_model_name is '估值模型名称';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_pv_variation_lastday is '前一天公允价值变动_折人民币';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.level5_class_cd is '五级分类代码';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_tx_cust_name is '贴现人客户名称';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_group_cust_no is '集团客户号';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_group_cust_name is '集团客户名称';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_book_val is '账面价值';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_produck_type_cd is '产品大类';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.asset_type_name is '产品分类';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_bond_id is '债券编号';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.separate_code is '分池代码';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.tax_ecl is '代垫增值税ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.tax_ecl_before is '代垫增值税原币ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.tax_balance is '代垫增值税余额';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.tax_balance_before is '代垫增值税原币余额';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.total_ecl is 'ecl汇总';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.total_ecl_before is '原币ecl汇总';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_pd_mode is 'pd新模型名称';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.law_ecl is '代垫诉讼费ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.law_ecl_before is '代垫诉讼费原币ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.law_balance_before is '代垫诉讼费原币余额';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.law_balance is '代垫诉讼费本币余额';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.v_serialno is '减值逻辑主键';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.recvbl_uncol_int is '应收未收利息';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_int_receivable_before is '应收利息原币';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.recvbl_uncol_int_before is '应收未收利息原币';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_int_accrued_before is '应计利息原币';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.int_recvbl_ecl is '应收利息ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.recvbl_uncol_int_ecl is '应收未收利息ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_int_accrued_ecl is '应计利息ecl';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_int_receivable_ecl_before is '应收利息ecl原币';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.recvbl_uncol_int_ecl_before is '应收未收利息ecl原币';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.n_int_accrued_ecl_before is '应计利息ecl原币';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.etl_dt is 'etl处理日期';
comment on column ${idl_schema}.ifrs_fct_ecl_res_report.etl_timestamp is 'etl处理时间戳';

