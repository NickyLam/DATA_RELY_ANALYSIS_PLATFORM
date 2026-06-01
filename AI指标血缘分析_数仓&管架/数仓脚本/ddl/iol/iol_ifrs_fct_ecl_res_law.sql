/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_fct_ecl_res_law
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_fct_ecl_res_law
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_fct_ecl_res_law purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_fct_ecl_res_law(
    d_date_dt date -- 数据日期
    ,n_asset_class_cd number(10) -- 敞口代码
    ,v_id_number varchar2(450) -- 借据号
    ,v_cust_cd varchar2(90) -- 客户名
    ,v_cust_name varchar2(1500) -- 客户号
    ,v_pd_internal varchar2(30) -- PD模型
    ,v_regul_classif_cd varchar2(15) -- 五级分类
    ,v_internal_rating varchar2(15) -- 内部评级
    ,v_issuer_rating varchar2(15) -- 发行人评级
    ,v_obligation_rating varchar2(15) -- 债项评级
    ,n_odus_days number(20) -- 逾期天数
    ,n_phase_division_cd number(4) -- 阶段划分
    ,n_cur number(26,2) -- 余额
    ,n_int number(26,2) -- 利息
    ,n_slow number(26,2) -- 缓释品金额
    ,n_ead_fin number(26,5) -- EAD
    ,n_pd number(10,5) -- PD
    ,n_lgd_fin number(10,5) -- LGD
    ,n_ecl number(26,5) -- ECL
    ,v_three_stage_cd varchar2(150) -- 三分类
    ,v_produck_type_cd varchar2(90) -- 产品大类
    ,v_produck_type_s_cd varchar2(750) -- 产品小类
    ,v_ccy_cd varchar2(15) -- 币种(CNY)
    ,d_acct_open_date date -- 起息日
    ,d_acct_expire_date date -- 到期日
    ,n_residual_maturity number(20) -- 剩余期限
    ,n_odue_days_cur number(10) -- 本金逾期天数
    ,n_odue_days_int number(10) -- 利息逾期天数
    ,v_blick varchar2(15) -- 铁骑清单
    ,v_sub_cd varchar2(30) -- 科目号
    ,v_sub_name varchar2(75) -- 科目名称
    ,v_org_cd varchar2(30) -- 机构号
    ,v_org_name varchar2(75) -- 机构名称
    ,before_adjustment_coefficient number(24,5) -- 输入系数
    ,before_n_adjustment_ecl number(32,5) -- 调整后的ECL
    ,n_ead_fin_before number(30,5) -- 原币EAD
    ,n_ecl_before number(26,5) -- 原币ECL
    ,v_ccy_cd_before varchar2(15) -- 原币币种
    ,n_cur_before number(26,2) -- 原币本金余额
    ,n_int_before number(26,2) -- 原币利息
    ,n_slow_before number(26,2) -- 原币缓释品金额
    ,v_around_sign varchar2(15) -- 表内外标识
    ,v_invest_indust_cd varchar2(45) -- 国际行业
    ,n_lgd_before number(26,5) -- 基础LGD
    ,v_account_ageing varchar2(15) -- 账龄
    ,v_dfc_ecl_cd varchar2(15) -- 调整后：’DCF‘ 未调整： ’ECL‘
    ,industry_name varchar2(150) -- 国际行业（报表用）
    ,n_ecl_dcf number(26,5) -- DCF调整后的ECL
    ,n_ecl_before_dcf number(26,5) -- DCF调整后的原币ECL
    ,issue_bank_cn_name varchar2(563) -- 开证行
    ,rate_fin varchar2(30) -- 最终评级
    ,v_financial_id varchar2(150) -- 金融工具表编号
    ,v_bond_id varchar2(60) -- 债券编号
    ,v_forecast_mod varchar2(30) -- 旧版模型分组 预测用
    ,v_bill_no varchar2(150) -- 汇票号
    ,execu_org_no varchar2(90) -- 经办机构
    ,execu_org_name varchar2(300) -- 经办机构名称
    ,n_pv_variation number(26,2) -- 公允价值变动_折人民币
    ,n_balance_face number(26,2) -- 面值_展示
    ,n_int_adj_bal number(26,2) -- 利息调整_展示
    ,n_int_receivable number(26,2) -- 应收利息_展示
    ,n_int_accrued number(26,2) -- 应计利息_展示
    ,fin_instm_name varchar2(375) -- 金融工具名称
    ,asset_type_name varchar2(90) -- 产品分类
    ,guartor_cust_name varchar2(300) -- 担保客户名称
    ,v_value_model_name varchar2(150) -- 估值模型名称
    ,pv_variation number(26,2) -- 原币公允价值
    ,intnal_secu_acct_id varchar2(90) -- 内部证券账户编号
    ,n_pv_variation_lastday number(26,2) -- 前一天公允价值变动_折人民币
    ,pv_variation_lastday number(26,2) -- 前一天公允价值变动_原币
    ,v_serialno varchar2(450) -- 减值借据号_物理展示
    ,biz_no varchar2(90) -- 贴现转贴现主键
    ,level5_class_cd varchar2(15) -- 五级分类代码
    ,product_no varchar2(90) -- 产品编码
    ,v_tx_cust_name varchar2(750) -- 票据贴现人
    ,v_group_cust_no varchar2(90) -- 集团客户号
    ,v_group_cust_name varchar2(750) -- 集团客户名
    ,bill_no varchar2(90) -- 票据编号BILL_NO
    ,bill_sub_intrv_id varchar2(90) -- 子票据区间编号
    ,glob_seq_num varchar2(50) -- 全局流水号
    ,unique_seq_num varchar2(50) -- 业务流水号
    ,tax_ecl number(30,2) -- 垫付增值税ECL
    ,tax_ecl_before number(30,2) -- 垫付增值税原币ECL
    ,tax_balance_before number(30,2) -- 垫付增值税原币余额
    ,tax_balance number(30,2) -- 垫付增值税余额
    ,total_ecl number(30,2) -- ECL汇总
    ,total_ecl_before number(30,2) -- 原币ECL汇总
    ,market_type_id varchar2(15) -- 交易市场编号
    ,separate_code varchar2(150) -- 分池代码
    ,v_pd_mode varchar2(30) -- PD新模型名称
    ,n_cur_ead number(26,5) -- 本金EAD
    ,n_int_ead number(26,5) -- 利息EAD
    ,n_off_ead number(26,5) -- 表外EAD
    ,n_cur_ecl number(26,5) -- 本金ECL
    ,n_int_ecl number(26,5) -- 利息ECL
    ,n_off_ecl number(26,5) -- 表外ECL
    ,bond_item_no varchar2(150) -- 借据号（获取押品使用）
    ,add_pd_mul_lgd number(10,5) -- 管理层叠加PD*LGD
    ,before_pd_mul_lgd number(10,5) -- 管理层叠加前PD
    ,before_ecl number(26,5) -- 管理层叠加前ECL
    ,add_ecl number(26,5) -- 管理层叠加后ECL
    ,add_n_cur_ecl number(26,5) -- 管理层叠加后本金ECL
    ,before_n_cur_ecl number(26,5) -- 管理层叠加前本金ECL
    ,add_n_int_ecl number(26,5) -- 管理层叠加后利息ECL
    ,before_n_int_ecl number(26,5) -- 管理层叠加前利息ECL
    ,add_n_off_ecl number(26,5) -- 管理层叠加后表外ECL
    ,before_n_off_ecl number(26,5) -- 管理层叠加前表外ECL
    ,add_n_pd number(10,5) -- 管理层叠加N_PD
    ,before_n_pd number(10,5) -- 管理层叠加前N_PD
    ,recvbl_uncol_int number(30,2) -- 应收未收利息
    ,recvbl_uncol_int_ecl number(30,2) -- 应收未收利息ECL
    ,int_recvbl_ecl number(30,2) -- 应收利息ECL
    ,n_int_accrued_ecl number(30,2) -- 应计利息ECL
    ,law_ecl number(30,2) -- 代垫诉讼费ECL
    ,law_ecl_before number(30,2) -- 代垫诉讼费原币ECL
    ,law_balance_before number(30,2) -- 代垫诉讼费原币余额
    ,law_balance number(30,2) -- 代垫诉讼费本币余额
    ,n_int_receivable_before number(30,2) -- 应收利息原币
    ,recvbl_uncol_int_before number(30,2) -- 应收未收利息原币
    ,n_int_accrued_before number(30,2) -- 应计利息原币
    ,n_int_receivable_ecl_before number(30,2) -- 应收利息ECL原币
    ,recvbl_uncol_int_ecl_before number(30,2) -- 应收未收利息ECL原币
    ,n_int_accrued_ecl_before number(30,2) -- 应计利息ECL原币
    ,exec_int_rate number(18,6) -- 执行利率
    ,remark varchar2(4000) -- 备注
    ,edit_ecl number(26,5) -- 预期信用损失ECL_审计调整
    ,edit_phase_division varchar2(2) -- 阶段划分_审计调整
    ,edit_regul_classif_cd varchar2(15) -- 五级分类_审计调整
    ,edit_three_stage_cd varchar2(15) -- 三分类_审计调整
    ,v_book_val number(26,2) -- 账面价值
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
grant select on ${iol_schema}.ifrs_fct_ecl_res_law to ${iml_schema};
grant select on ${iol_schema}.ifrs_fct_ecl_res_law to ${icl_schema};
grant select on ${iol_schema}.ifrs_fct_ecl_res_law to ${idl_schema};
grant select on ${iol_schema}.ifrs_fct_ecl_res_law to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_fct_ecl_res_law is '减值系统诉讼费表';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.d_date_dt is '数据日期';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_asset_class_cd is '敞口代码';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_id_number is '借据号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_cust_cd is '客户名';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_cust_name is '客户号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_pd_internal is 'PD模型';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_regul_classif_cd is '五级分类';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_internal_rating is '内部评级';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_issuer_rating is '发行人评级';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_obligation_rating is '债项评级';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_odus_days is '逾期天数';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_phase_division_cd is '阶段划分';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_cur is '余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int is '利息';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_slow is '缓释品金额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_ead_fin is 'EAD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_pd is 'PD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_lgd_fin is 'LGD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_ecl is 'ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_three_stage_cd is '三分类';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_produck_type_cd is '产品大类';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_produck_type_s_cd is '产品小类';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_ccy_cd is '币种(CNY)';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.d_acct_open_date is '起息日';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.d_acct_expire_date is '到期日';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_residual_maturity is '剩余期限';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_odue_days_cur is '本金逾期天数';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_odue_days_int is '利息逾期天数';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_blick is '铁骑清单';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_sub_cd is '科目号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_sub_name is '科目名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_org_cd is '机构号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_org_name is '机构名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.before_adjustment_coefficient is '输入系数';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.before_n_adjustment_ecl is '调整后的ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_ead_fin_before is '原币EAD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_ecl_before is '原币ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_ccy_cd_before is '原币币种';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_cur_before is '原币本金余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_before is '原币利息';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_slow_before is '原币缓释品金额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_around_sign is '表内外标识';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_invest_indust_cd is '国际行业';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_lgd_before is '基础LGD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_account_ageing is '账龄';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_dfc_ecl_cd is '调整后：’DCF‘ 未调整： ’ECL‘';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.industry_name is '国际行业（报表用）';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_ecl_dcf is 'DCF调整后的ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_ecl_before_dcf is 'DCF调整后的原币ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.issue_bank_cn_name is '开证行';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.rate_fin is '最终评级';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_financial_id is '金融工具表编号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_bond_id is '债券编号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_forecast_mod is '旧版模型分组 预测用';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_bill_no is '汇票号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.execu_org_no is '经办机构';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.execu_org_name is '经办机构名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_pv_variation is '公允价值变动_折人民币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_balance_face is '面值_展示';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_adj_bal is '利息调整_展示';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_receivable is '应收利息_展示';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_accrued is '应计利息_展示';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.fin_instm_name is '金融工具名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.asset_type_name is '产品分类';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.guartor_cust_name is '担保客户名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_value_model_name is '估值模型名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.pv_variation is '原币公允价值';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_pv_variation_lastday is '前一天公允价值变动_折人民币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.pv_variation_lastday is '前一天公允价值变动_原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_serialno is '减值借据号_物理展示';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.biz_no is '贴现转贴现主键';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.level5_class_cd is '五级分类代码';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.product_no is '产品编码';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_tx_cust_name is '票据贴现人';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_group_cust_no is '集团客户号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_group_cust_name is '集团客户名';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.bill_no is '票据编号BILL_NO';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.bill_sub_intrv_id is '子票据区间编号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.unique_seq_num is '业务流水号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.tax_ecl is '垫付增值税ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.tax_ecl_before is '垫付增值税原币ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.tax_balance_before is '垫付增值税原币余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.tax_balance is '垫付增值税余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.total_ecl is 'ECL汇总';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.total_ecl_before is '原币ECL汇总';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.market_type_id is '交易市场编号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.separate_code is '分池代码';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_pd_mode is 'PD新模型名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_cur_ead is '本金EAD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_ead is '利息EAD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_off_ead is '表外EAD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_cur_ecl is '本金ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_ecl is '利息ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_off_ecl is '表外ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.bond_item_no is '借据号（获取押品使用）';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.add_pd_mul_lgd is '管理层叠加PD*LGD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.before_pd_mul_lgd is '管理层叠加前PD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.before_ecl is '管理层叠加前ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.add_ecl is '管理层叠加后ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.add_n_cur_ecl is '管理层叠加后本金ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.before_n_cur_ecl is '管理层叠加前本金ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.add_n_int_ecl is '管理层叠加后利息ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.before_n_int_ecl is '管理层叠加前利息ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.add_n_off_ecl is '管理层叠加后表外ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.before_n_off_ecl is '管理层叠加前表外ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.add_n_pd is '管理层叠加N_PD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.before_n_pd is '管理层叠加前N_PD';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.recvbl_uncol_int is '应收未收利息';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.recvbl_uncol_int_ecl is '应收未收利息ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.int_recvbl_ecl is '应收利息ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_accrued_ecl is '应计利息ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.law_ecl is '代垫诉讼费ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.law_ecl_before is '代垫诉讼费原币ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.law_balance_before is '代垫诉讼费原币余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.law_balance is '代垫诉讼费本币余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_receivable_before is '应收利息原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.recvbl_uncol_int_before is '应收未收利息原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_accrued_before is '应计利息原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_receivable_ecl_before is '应收利息ECL原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.recvbl_uncol_int_ecl_before is '应收未收利息ECL原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.n_int_accrued_ecl_before is '应计利息ECL原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.exec_int_rate is '执行利率';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.remark is '备注';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.edit_ecl is '预期信用损失ECL_审计调整';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.edit_phase_division is '阶段划分_审计调整';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.edit_regul_classif_cd is '五级分类_审计调整';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.edit_three_stage_cd is '三分类_审计调整';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.v_book_val is '账面价值';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_fct_ecl_res_law.etl_timestamp is 'ETL处理时间戳';
