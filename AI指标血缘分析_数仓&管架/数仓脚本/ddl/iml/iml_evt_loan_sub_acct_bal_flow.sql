/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_loan_sub_acct_bal_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_loan_sub_acct_bal_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_loan_sub_acct_bal_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_sub_acct_bal_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,sob_id varchar2(100) -- 账套编号
    ,src_sys_cd varchar2(30) -- 源系统代码
    ,core_loan_num varchar2(100) -- 核心贷款号
    ,tran_dt date -- 交易日期
    ,tran_flow_num varchar2(100) -- 交易流水号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,sub_tran_cate_cd varchar2(30) -- 子交易类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,org_id varchar2(100) -- 机构编号
    ,dubil_id varchar2(100) -- 借据编号
    ,bus_type_cd varchar2(60) -- 业务类型代码
    ,prod_id varchar2(100) -- 产品编号
    ,cont_id varchar2(100) -- 合同编号
    ,cont_exec_int_rat number(18,8) -- 合同执行利率
    ,init_loan_num varchar2(100) -- 原贷款号
    ,nomal_pric number(30,2) -- 正常本金
    ,log_pric number(30,2) -- 保函本金
    ,wrtn_off_pric number(30,2) -- 已核销本金
    ,wrtn_off_advc_money number(30,2) -- 已核销垫付款
    ,int_sub_flg varchar2(10) -- 贴息标志
    ,pre_recv_int_flg varchar2(10) -- 预收息标志
    ,int_accr_flg varchar2(10) -- 计息标志
    ,value_dt date -- 起息日期
    ,next_int_set_dt date -- 下次结息日期
    ,wrtn_off_int number(30,2) -- 已核销利息
    ,acru_flg varchar2(10) -- 应计标志
    ,acru_int number(30,2) -- 应计利息
    ,off_bs_acru_comp_int number(30,2) -- 表外应计复利
    ,acru_aldy_impam_int number(30,2) -- 应计已减值利息
    ,non_acru_int_recvbl number(30,2) -- 非应计应收利息
    ,int_recvbl number(30,2) -- 应收利息
    ,recvbl_uncol_int number(30,2) -- 应收未收利息
    ,taxable_colled_int number(30,2) -- 应税已收回利息
    ,int_recvbl_taxable number(30,2) -- 应收利息应税
    ,off_bs_int_recvbl number(30,2) -- 表外应收利息
    ,off_bs_recvbl_comp_int number(30,2) -- 表外应收复利
    ,off_bs_acru_int number(30,2) -- 表外应计利息
    ,int_income number(30,2) -- 利息收入
    ,impam_flg varchar2(10) -- 减值标志
    ,asset_impam_loss_amt number(30,2) -- 资产减值损失金额
    ,aldy_impam_int number(30,2) -- 已减值利息
    ,aldy_impam_int_income number(30,2) -- 已减值利息收入
    ,loan_impam_resv_lmt number(30,2) -- 贷款减值准备金额
    ,other_acct_recvbl_impam_resv_lmt number(30,2) -- 其他应收款减值准备金额
    ,th_year_aldy_impam_int_income number(30,2) -- 本年已减值利息收入
    ,renew_flg varchar2(10) -- 展期标志
    ,abs_flg varchar2(10) -- 资产证券化标志
    ,abs_pric number(30,2) -- 资产证券化本金
    ,discnt_int number(30,2) -- 贴现利息
    ,merge_flg varchar2(10) -- 撤并标志
    ,nomal_int_rat_ped_cd varchar2(30) -- 正常利率周期代码
    ,ovdue_int_rat number(18,8) -- 逾期利率
    ,ovdue_int_rat_ped_cd varchar2(30) -- 逾期利率周期代码
    ,comp_int_int_rat number(18,8) -- 复利利率
    ,comp_int_int_rat_ped_cd varchar2(30) -- 复利利率周期代码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,acct_status_cd varchar2(30) -- 账户状态代码
    ,indus_type_cd varchar2(250) -- 国民经济类型代码
    ,chn_cd varchar2(250) -- 渠道代码
    ,loan_level5_cls_cd varchar2(30) -- 贷款五级分类代码
    ,loan_stage varchar2(500) -- 贷款阶段
    ,loan_distr_dt date -- 贷款放款日期
    ,loan_distr_amt number(30,2) -- 贷款放款金额
    ,actl_distr_amt number(30,2) -- 实际发放金额
    ,loan_exp_dt date -- 贷款到期日期
    ,tran_way_cd varchar2(30) -- 转让方式代码
    ,wrtn_off_bad_debt_pric number(30,2) -- 已核销呆账本金
    ,wrtn_off_bad_debt_aldy_impam_int number(30,2) -- 已核销呆账已减值利息
    ,wrtn_off_bad_debt_int number(30,2) -- 已核销呆账利息
    ,wrtn_off_int_not_tax number(30,2) -- 已核销利息_未计税
    ,circl_lon_fir_distr_flg varchar2(250) -- 循环贷首次放款标志
    ,circl_lon_flg varchar2(250) -- 循环贷标志
    ,amort_flg varchar2(10) -- 摊销标志
    ,amort_freq_cd varchar2(30) -- 摊销频度代码
    ,amort_cost number(30,2) -- 摊余成本
    ,indv_bus_flg varchar2(250) -- 个体工商户标志
    ,corp_size_cd varchar2(250) -- 企业规模代码
    ,cap_char_cd varchar2(30) -- 资金性质代码
    ,th_year_int_income number(30,2) -- 本年利息收入
    ,acm_int_income number(30,2) -- 累计利息收入
    ,th_quar_degree_vat number(30,2) -- 当季度增值税
    ,output_tax_lmt number(30,2) -- 销项税额
    ,adv_vat_amt number(30,2) -- 代垫增值税金额
    ,invest_prft number(30,2) -- 投资收益
    ,th_year_invest_prft number(30,2) -- 本年投资收益
    ,acm_invest_prft number(30,2) -- 累计投资收益
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_loan_sub_acct_bal_flow to ${icl_schema};
grant select on ${iml_schema}.evt_loan_sub_acct_bal_flow to ${idl_schema};
grant select on ${iml_schema}.evt_loan_sub_acct_bal_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_loan_sub_acct_bal_flow is '贷款分户余额变动流水';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.sob_id is '账套编号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.src_sys_cd is '源系统代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.core_loan_num is '核心贷款号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.tran_flow_num is '交易流水号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.sub_tran_cate_cd is '子交易类型代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.dubil_id is '借据编号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.bus_type_cd is '业务类型代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.prod_id is '产品编号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.cont_id is '合同编号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.cont_exec_int_rat is '合同执行利率';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.init_loan_num is '原贷款号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.nomal_pric is '正常本金';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.log_pric is '保函本金';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.wrtn_off_pric is '已核销本金';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.wrtn_off_advc_money is '已核销垫付款';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.int_sub_flg is '贴息标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.pre_recv_int_flg is '预收息标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.int_accr_flg is '计息标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.value_dt is '起息日期';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.next_int_set_dt is '下次结息日期';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.wrtn_off_int is '已核销利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.acru_flg is '应计标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.acru_int is '应计利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.off_bs_acru_comp_int is '表外应计复利';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.acru_aldy_impam_int is '应计已减值利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.non_acru_int_recvbl is '非应计应收利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.int_recvbl is '应收利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.recvbl_uncol_int is '应收未收利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.taxable_colled_int is '应税已收回利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.int_recvbl_taxable is '应收利息应税';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.off_bs_int_recvbl is '表外应收利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.off_bs_recvbl_comp_int is '表外应收复利';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.off_bs_acru_int is '表外应计利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.int_income is '利息收入';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.impam_flg is '减值标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.asset_impam_loss_amt is '资产减值损失金额';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.aldy_impam_int is '已减值利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.aldy_impam_int_income is '已减值利息收入';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.loan_impam_resv_lmt is '贷款减值准备金额';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.other_acct_recvbl_impam_resv_lmt is '其他应收款减值准备金额';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.th_year_aldy_impam_int_income is '本年已减值利息收入';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.renew_flg is '展期标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.abs_flg is '资产证券化标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.abs_pric is '资产证券化本金';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.discnt_int is '贴现利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.merge_flg is '撤并标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.nomal_int_rat_ped_cd is '正常利率周期代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.ovdue_int_rat is '逾期利率';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.ovdue_int_rat_ped_cd is '逾期利率周期代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.comp_int_int_rat is '复利利率';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.comp_int_int_rat_ped_cd is '复利利率周期代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.acct_status_cd is '账户状态代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.indus_type_cd is '国民经济类型代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.chn_cd is '渠道代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.loan_level5_cls_cd is '贷款五级分类代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.loan_stage is '贷款阶段';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.loan_distr_dt is '贷款放款日期';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.loan_distr_amt is '贷款放款金额';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.actl_distr_amt is '实际发放金额';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.loan_exp_dt is '贷款到期日期';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.tran_way_cd is '转让方式代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.wrtn_off_bad_debt_pric is '已核销呆账本金';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.wrtn_off_bad_debt_aldy_impam_int is '已核销呆账已减值利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.wrtn_off_bad_debt_int is '已核销呆账利息';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.wrtn_off_int_not_tax is '已核销利息_未计税';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.circl_lon_fir_distr_flg is '循环贷首次放款标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.circl_lon_flg is '循环贷标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.amort_flg is '摊销标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.amort_freq_cd is '摊销频度代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.amort_cost is '摊余成本';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.indv_bus_flg is '个体工商户标志';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.corp_size_cd is '企业规模代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.cap_char_cd is '资金性质代码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.th_year_int_income is '本年利息收入';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.acm_int_income is '累计利息收入';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.th_quar_degree_vat is '当季度增值税';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.output_tax_lmt is '销项税额';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.adv_vat_amt is '代垫增值税金额';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.invest_prft is '投资收益';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.th_year_invest_prft is '本年投资收益';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.acm_invest_prft is '累计投资收益';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_loan_sub_acct_bal_flow.etl_timestamp is 'ETL处理时间戳';
