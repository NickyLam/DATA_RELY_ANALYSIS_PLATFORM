/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol ifrs_fct_ecl_res_dtl
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.ifrs_fct_ecl_res_dtl
whenever sqlerror continue none;
drop table ${iol_schema}.ifrs_fct_ecl_res_dtl purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_fct_ecl_res_dtl(
    d_date_dt date -- 数据日期
    ,n_asset_class_cd number(10,0) -- 敞口类型划分代码
    ,v_id_number varchar2(450) -- 借据号(唯一标识)
    ,v_cust_cd varchar2(90) -- 客户号
    ,v_cust_name varchar2(1500) -- 客户名
    ,v_pd_internal varchar2(30) -- pd模型
    ,v_regul_classif_cd varchar2(15) -- 五级分类
    ,v_internal_rating varchar2(15) -- 内部评级
    ,v_issuer_rating varchar2(15) -- 发行人评级
    ,v_obligation_rating varchar2(15) -- 债项评级
    ,n_odus_days number(22,0) -- 逾期天数
    ,n_phase_division_cd number(4,0) -- 阶段划分
    ,n_cur number(26,2) -- 折币后本期余额
    ,n_int number(26,2) -- 折币后本期利息
    ,n_slow number(26,2) -- 缓释品金额
    ,n_ead_fin number(26,5) -- ead
    ,n_pd number(10,5) -- pd
    ,n_lgd_fin number(10,5) -- lgd
    ,n_ecl number(26,5) -- ecl
    ,v_three_stage_cd varchar2(150) -- 三分类代码
    ,v_produck_type_cd varchar2(90) -- 产品大类
    ,v_produck_type_s_cd varchar2(90) -- 产品小类
    ,v_ccy_cd varchar2(15) -- 折币后币种
    ,d_acct_open_date date -- 起息日
    ,d_acct_expire_date date -- 到期日
    ,n_residual_maturity number(20,0) -- 剩余期限
    ,n_odue_days_cur number(22,0) -- 本金逾期天数
    ,n_odue_days_int number(22,0) -- 利息逾期天数
    ,v_blick varchar2(15) -- 是否铁骑清单
    ,v_sub_cd varchar2(30) -- 科目代码
    ,v_sub_name varchar2(75) -- 科目名称
    ,v_org_cd varchar2(30) -- 机构代码
    ,v_org_name varchar2(75) -- 结构名称
    ,before_adjustment_coefficient number(24,5) -- 调整ecl系数(old)
    ,before_n_adjustment_ecl number(32,5) -- 调整后ecl(old)
    ,n_ead_fin_before number(30,5) -- 原币ead
    ,n_ecl_before number(26,5) -- 原币ecl
    ,v_ccy_cd_before varchar2(15) -- 原币币种
    ,n_cur_before number(26,2) -- 原币本期余额
    ,n_int_before number(26,2) -- 原币利息
    ,n_slow_before number(26,2) -- 原币缓释品金额
    ,v_around_sign varchar2(15) -- 表内外标识
    ,v_invest_indust_cd varchar2(45) -- 国际行业
    ,n_lgd_before number(26,5) -- 基础lgd
    ,v_account_ageing varchar2(15) -- 账龄(网贷业务)
    ,v_dfc_ecl_cd varchar2(15) -- 是否dcf规则调整标识
    ,industry_name varchar2(150) -- 行业名称(报表用)
    ,n_ecl_dcf number(26,5) -- dcf调整后的折币后ecl
    ,n_ecl_before_dcf number(26,5) -- dcf调整后的原币ecl
    ,issue_bank_cn_name varchar2(563) -- 开证行名称
    ,rate_fin varchar2(30) -- 最终评级
    ,v_financial_id varchar2(60) -- 金融工具表编号
    ,v_bond_id varchar2(60) -- 债券编号
    ,v_forecast_mod varchar2(30) -- 旧版模型分组 预测用
    ,v_bill_no varchar2(150) -- 
    ,execu_org_no varchar2(90) -- 经办机构
    ,execu_org_name varchar2(300) -- 经办机构名称
    ,n_pv_variation number(26,2) -- 公允价值变动
    ,n_balance_face number(26,2) -- 面值
    ,n_int_adj_bal number(26,2) -- 利息调整
    ,n_int_receivable number(26,2) -- 应收利息
    ,n_int_accrued number(26,2) -- 应计利息
    ,n_pv_variation_lastday number(26,2) -- 前一天公允价值变动_折人民币
    ,pv_variation_lastday number(26,2) -- 前一天公允价值变动_原币
    ,v_serialno varchar2(450) -- 减值借据号_物理展示
    ,biz_no varchar2(150) -- 贴现转贴现主键
    ,level5_class_cd varchar2(15) -- 五级分类代码
    ,product_no varchar2(90) -- 产品编号
    ,fin_instm_name varchar2(375) -- 金融工具名称
    ,asset_type_name varchar2(90) -- 产品分类
    ,guartor_cust_name varchar2(300) -- 担保客户名称
    ,v_value_model_name varchar2(150) -- 估值模型名称
    ,pv_variation number(26,2) -- 原币公允价值
    ,intnal_secu_acct_id varchar2(90) -- 内部证券账户编号
    ,glob_seq_num varchar2(50) -- 全局流水号
    ,unique_seq_num varchar2(50) -- 业务流水号
    ,v_tx_cust_name varchar2(750) -- 贴现人客户名称
    ,v_group_cust_no varchar2(90) -- 集团客户号
    ,v_group_cust_name varchar2(750) -- 集团客户名称
    ,bill_no varchar2(90) -- 票据编号bill_no
    ,bill_sub_intrv_id varchar2(90) -- 子票据区间编号
    ,tax_ecl number(30,2) -- 垫付增值税ecl
    ,tax_ecl_before number(30,2) -- 垫付增值税原币ecl
    ,tax_balance_before number(30,2) -- 垫付增值税原币余额
    ,tax_balance number(30,2) -- 垫付增值税余额
    ,law_ecl number(30,2) -- 代垫诉讼费ECL
    ,law_ecl_before number(30,2) -- 代垫诉讼费原币ECL
    ,law_balance_before number(30,2) -- 代垫诉讼费原币余额
    ,law_balance number(30,2) -- 代垫诉讼费本币余额
    ,int_recvbl_ecl number(30,2) -- 应收利息ECL
    ,n_int_receivable_before number(30,2) -- 应收利息原币
    ,recvbl_uncol_int_before number(30,2) -- 应收未收利息原币
    ,n_int_accrued_before number(30,2) -- 应计利息原币
    ,n_int_receivable_ecl_before number(30,2) -- 应收利息ECL原币
    ,recvbl_uncol_int_ecl_before number(30,2) -- 应收未收利息ECL原币
    ,n_int_accrued_ecl_before number(30,2) -- 应计利息ECL原币
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
grant select on ${iol_schema}.ifrs_fct_ecl_res_dtl to ${iml_schema};
grant select on ${iol_schema}.ifrs_fct_ecl_res_dtl to ${icl_schema};
grant select on ${iol_schema}.ifrs_fct_ecl_res_dtl to ${idl_schema};
grant select on ${iol_schema}.ifrs_fct_ecl_res_dtl to ${iel_schema};

-- comment
comment on table ${iol_schema}.ifrs_fct_ecl_res_dtl is '减值结果表';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.d_date_dt is '数据日期';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_asset_class_cd is '敞口类型划分代码';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_id_number is '借据号(唯一标识)';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_cust_cd is '客户号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_cust_name is '客户名';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_pd_internal is 'pd模型';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_regul_classif_cd is '五级分类';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_internal_rating is '内部评级';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_issuer_rating is '发行人评级';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_obligation_rating is '债项评级';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_odus_days is '逾期天数';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_phase_division_cd is '阶段划分';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_cur is '折币后本期余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_int is '折币后本期利息';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_slow is '缓释品金额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_ead_fin is 'ead';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_pd is 'pd';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_lgd_fin is 'lgd';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_ecl is 'ecl';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_three_stage_cd is '三分类代码';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_produck_type_cd is '产品大类';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_produck_type_s_cd is '产品小类';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_ccy_cd is '折币后币种';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.d_acct_open_date is '起息日';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.d_acct_expire_date is '到期日';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_residual_maturity is '剩余期限';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_odue_days_cur is '本金逾期天数';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_odue_days_int is '利息逾期天数';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_blick is '是否铁骑清单';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_sub_cd is '科目代码';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_sub_name is '科目名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_org_cd is '机构代码';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_org_name is '结构名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.before_adjustment_coefficient is '调整ecl系数(old)';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.before_n_adjustment_ecl is '调整后ecl(old)';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_ead_fin_before is '原币ead';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_ecl_before is '原币ecl';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_ccy_cd_before is '原币币种';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_cur_before is '原币本期余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_int_before is '原币利息';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_slow_before is '原币缓释品金额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_around_sign is '表内外标识';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_invest_indust_cd is '国际行业';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_lgd_before is '基础lgd';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_account_ageing is '账龄(网贷业务)';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_dfc_ecl_cd is '是否dcf规则调整标识';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.industry_name is '行业名称(报表用)';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_ecl_dcf is 'dcf调整后的折币后ecl';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_ecl_before_dcf is 'dcf调整后的原币ecl';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.issue_bank_cn_name is '开证行名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.rate_fin is '最终评级';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_financial_id is '金融工具表编号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_bond_id is '债券编号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_forecast_mod is '旧版模型分组 预测用';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_bill_no is '';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.execu_org_no is '经办机构';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.execu_org_name is '经办机构名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_pv_variation is '公允价值变动';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_balance_face is '面值';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_int_adj_bal is '利息调整';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_int_receivable is '应收利息';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_int_accrued is '应计利息';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_pv_variation_lastday is '前一天公允价值变动_折人民币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.pv_variation_lastday is '前一天公允价值变动_原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_serialno is '减值借据号_物理展示';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.biz_no is '贴现转贴现主键';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.level5_class_cd is '五级分类代码';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.product_no is '产品编号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.fin_instm_name is '金融工具名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.asset_type_name is '产品分类';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.guartor_cust_name is '担保客户名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_value_model_name is '估值模型名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.pv_variation is '原币公允价值';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.intnal_secu_acct_id is '内部证券账户编号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.glob_seq_num is '全局流水号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.unique_seq_num is '业务流水号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_tx_cust_name is '贴现人客户名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_group_cust_no is '集团客户号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.v_group_cust_name is '集团客户名称';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.bill_no is '票据编号bill_no';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.bill_sub_intrv_id is '子票据区间编号';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.tax_ecl is '垫付增值税ecl';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.tax_ecl_before is '垫付增值税原币ecl';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.tax_balance_before is '垫付增值税原币余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.tax_balance is '垫付增值税余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.law_ecl is '代垫诉讼费ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.law_ecl_before is '代垫诉讼费原币ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.law_balance_before is '代垫诉讼费原币余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.law_balance is '代垫诉讼费本币余额';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.int_recvbl_ecl is '应收利息ECL';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_int_receivable_before is '应收利息原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.recvbl_uncol_int_before is '应收未收利息原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_int_accrued_before is '应计利息原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_int_receivable_ecl_before is '应收利息ECL原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.recvbl_uncol_int_ecl_before is '应收未收利息ECL原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.n_int_accrued_ecl_before is '应计利息ECL原币';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.ifrs_fct_ecl_res_dtl.etl_timestamp is 'ETL处理时间戳';
