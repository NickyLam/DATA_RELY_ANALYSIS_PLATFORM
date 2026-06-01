/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_loan_sub_acct_measure_flow_tglsi1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create table for exchage and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.evt_loan_sub_acct_measure_flow_tglsi1_tm purge;
alter table ${iml_schema}.evt_loan_sub_acct_measure_flow add partition p_tglsi1 values ('tglsi1')(
        subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_loan_sub_acct_measure_flow modify partition p_tglsi1
    add subpartition p_tglsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_loan_sub_acct_measure_flow_tglsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,sob_id -- 账套编号
    ,src_sys_cd -- 源系统代码
    ,core_loan_num -- 核心贷款号
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,tran_flow_seq_num -- 交易流水序号
    ,sub_tran_cate_cd -- 子交易类别代码
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,bus_type_cd -- 业务类型代码
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,init_loan_num -- 原贷款号
    ,loan_impam_resv_lmt -- 贷款减值准备金额
    ,discnt_int -- 贴现利息
    ,int_income -- 利息收入
    ,nomal_pric -- 正常本金
    ,abs_pric -- 资产证券化本金
    ,other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,output_tax_lmt -- 销项税额
    ,adv_vat_amt -- 代垫增值税金额
    ,wrtn_off_pric -- 已核销本金
    ,wrtn_off_advc_money -- 已核销垫付款
    ,int_recvbl -- 应收利息
    ,acru_aldy_impam_int -- 应计已减值利息
    ,log_pric -- 保函本金
    ,non_acru_int_recvbl -- 非应计应收利息
    ,wrtn_off_int -- 已核销利息
    ,recvbl_uncol_int -- 应收未收利息
    ,int_paybl -- 应付利息
    ,acct_status_cd -- 账户状态代码
    ,ova_flow_num -- 全局流水号
    ,int_sub_flg -- 贴息标志
    ,renew_flg -- 展期标志
    ,abs_flg -- 资产证券化标志
    ,merge_flg -- 撤并标志
    ,pre_recv_int_flg -- 预收息标志
    ,cont_exec_int_rat -- 合同执行利率
    ,nomal_int_rat_ped_cd -- 正常利率周期代码
    ,ovdue_pric -- 逾期本金
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_ped_cd -- 逾期利率周期代码
    ,comp_int -- 复利
    ,curr_exp_comp_int -- 当前到期的复利
    ,comp_int_int_rat -- 复利利率
    ,comp_int_int_rat_ped_cd -- 复利利率周期代码
    ,grace_period_int_rat_ped_cd -- 宽限期利率周期代码
    ,int_accr_flg -- 计息标志
    ,value_dt -- 起息日期
    ,next_int_set_dt -- 下次结息日期
    ,td_exp_pnlt -- 当天到期的罚息
    ,pnlt -- 罚息
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,loan_stage -- 贷款阶段
    ,loan_distr_dt -- 贷款放款日期
    ,loan_distr_amt -- 贷款放款金额
    ,actl_distr_amt -- 实际发放金额
    ,loan_exp_dt -- 贷款到期日期
    ,tran_way_cd -- 转让方式代码
    ,cap_char_cd -- 资金性质代码
    ,acru_flg -- 应计标志
    ,acru_int -- 应计利息
    ,off_bs_acru_comp_int -- 表外应计复利
    ,taxable_colled_int -- 应税已收回利息
    ,impam_flg -- 减值标志
    ,asset_impam_loss_amt -- 资产减值损失金额
    ,aldy_impam_int -- 已减值利息
    ,aldy_impam_int_income -- 已减值利息收入
    ,int_recvbl_taxable -- 应收利息应税
    ,off_bs_int_recvbl -- 表外应收利息
    ,off_bs_recvbl_comp_int -- 表外应收复利
    ,off_bs_acru_int -- 表外应计利息
    ,wrtn_off_bad_debt_pric -- 已核销呆账本金
    ,wrtn_off_bad_debt_aldy_impam_int -- 已核销呆账已减值利息
    ,wrtn_off_bad_debt_int -- 已核销呆账利息
    ,th_year_int_income -- 本年利息收入
    ,wrtn_off_int_not_tax -- 已核销利息_未计税
    ,th_year_aldy_impam_int_income -- 本年已减值利息收入
    ,acm_int_income -- 累计利息收入
    ,th_quar_degree_vat -- 当季度增值税
    ,indv_bus_flg -- 个体工商户标志
    ,corp_size_cd -- 企业规模代码
    ,circl_lon_fir_distr_flg -- 循环贷首次放款标志
    ,circl_lon_flg -- 循环贷标志
    ,indus_type_cd -- 国门经济类别代码
    ,chn_cd -- 渠道代码
    ,amort_flg -- 摊销标志
    ,amort_freq_cd -- 摊销频度代码
    ,amort_cost -- 摊余成本
    ,invest_prft -- 投资收益
    ,th_year_invest_prft -- 本年投资收益
    ,acm_invest_prft -- 累计投资收益
    ,batch_no -- 批次号
    ,tran_org_id -- 交易机构编号
    ,tran_type_cd -- 交易类型代码
    ,bus_happ_dt -- 业务发生日期
    ,revs_bus_flg -- 冲正业务标志
    ,brevs_dt -- 被冲正日期
    ,brevs_flow_num -- 被冲正流水号
    ,stdby_amt -- 备用金额
    ,update_org_id -- 更新机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_loan_sub_acct_measure_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- tgls_ama_loan_acct_h-1
insert into ${iml_schema}.evt_loan_sub_acct_measure_flow_tglsi1_tm(
    evt_id -- 事件编号
    ,sob_id -- 账套编号
    ,src_sys_cd -- 源系统代码
    ,core_loan_num -- 核心贷款号
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,tran_flow_seq_num -- 交易流水序号
    ,sub_tran_cate_cd -- 子交易类别代码
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,bus_type_cd -- 业务类型代码
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,init_loan_num -- 原贷款号
    ,loan_impam_resv_lmt -- 贷款减值准备金额
    ,discnt_int -- 贴现利息
    ,int_income -- 利息收入
    ,nomal_pric -- 正常本金
    ,abs_pric -- 资产证券化本金
    ,other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,output_tax_lmt -- 销项税额
    ,adv_vat_amt -- 代垫增值税金额
    ,wrtn_off_pric -- 已核销本金
    ,wrtn_off_advc_money -- 已核销垫付款
    ,int_recvbl -- 应收利息
    ,acru_aldy_impam_int -- 应计已减值利息
    ,log_pric -- 保函本金
    ,non_acru_int_recvbl -- 非应计应收利息
    ,wrtn_off_int -- 已核销利息
    ,recvbl_uncol_int -- 应收未收利息
    ,int_paybl -- 应付利息
    ,acct_status_cd -- 账户状态代码
    ,ova_flow_num -- 全局流水号
    ,int_sub_flg -- 贴息标志
    ,renew_flg -- 展期标志
    ,abs_flg -- 资产证券化标志
    ,merge_flg -- 撤并标志
    ,pre_recv_int_flg -- 预收息标志
    ,cont_exec_int_rat -- 合同执行利率
    ,nomal_int_rat_ped_cd -- 正常利率周期代码
    ,ovdue_pric -- 逾期本金
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_ped_cd -- 逾期利率周期代码
    ,comp_int -- 复利
    ,curr_exp_comp_int -- 当前到期的复利
    ,comp_int_int_rat -- 复利利率
    ,comp_int_int_rat_ped_cd -- 复利利率周期代码
    ,grace_period_int_rat_ped_cd -- 宽限期利率周期代码
    ,int_accr_flg -- 计息标志
    ,value_dt -- 起息日期
    ,next_int_set_dt -- 下次结息日期
    ,td_exp_pnlt -- 当天到期的罚息
    ,pnlt -- 罚息
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,loan_stage -- 贷款阶段
    ,loan_distr_dt -- 贷款放款日期
    ,loan_distr_amt -- 贷款放款金额
    ,actl_distr_amt -- 实际发放金额
    ,loan_exp_dt -- 贷款到期日期
    ,tran_way_cd -- 转让方式代码
    ,cap_char_cd -- 资金性质代码
    ,acru_flg -- 应计标志
    ,acru_int -- 应计利息
    ,off_bs_acru_comp_int -- 表外应计复利
    ,taxable_colled_int -- 应税已收回利息
    ,impam_flg -- 减值标志
    ,asset_impam_loss_amt -- 资产减值损失金额
    ,aldy_impam_int -- 已减值利息
    ,aldy_impam_int_income -- 已减值利息收入
    ,int_recvbl_taxable -- 应收利息应税
    ,off_bs_int_recvbl -- 表外应收利息
    ,off_bs_recvbl_comp_int -- 表外应收复利
    ,off_bs_acru_int -- 表外应计利息
    ,wrtn_off_bad_debt_pric -- 已核销呆账本金
    ,wrtn_off_bad_debt_aldy_impam_int -- 已核销呆账已减值利息
    ,wrtn_off_bad_debt_int -- 已核销呆账利息
    ,th_year_int_income -- 本年利息收入
    ,wrtn_off_int_not_tax -- 已核销利息_未计税
    ,th_year_aldy_impam_int_income -- 本年已减值利息收入
    ,acm_int_income -- 累计利息收入
    ,th_quar_degree_vat -- 当季度增值税
    ,indv_bus_flg -- 个体工商户标志
    ,corp_size_cd -- 企业规模代码
    ,circl_lon_fir_distr_flg -- 循环贷首次放款标志
    ,circl_lon_flg -- 循环贷标志
    ,indus_type_cd -- 国门经济类别代码
    ,chn_cd -- 渠道代码
    ,amort_flg -- 摊销标志
    ,amort_freq_cd -- 摊销频度代码
    ,amort_cost -- 摊余成本
    ,invest_prft -- 投资收益
    ,th_year_invest_prft -- 本年投资收益
    ,acm_invest_prft -- 累计投资收益
    ,batch_no -- 批次号
    ,tran_org_id -- 交易机构编号
    ,tran_type_cd -- 交易类型代码
    ,bus_happ_dt -- 业务发生日期
    ,revs_bus_flg -- 冲正业务标志
    ,brevs_dt -- 被冲正日期
    ,brevs_flow_num -- 被冲正流水号
    ,stdby_amt -- 备用金额
    ,update_org_id -- 更新机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401010'||P1.STACID||P1.SYSTID||P1.LOANNO||P1.TRANDT||P1.TRANSQ -- 事件编号
    ,P1.STACID -- 账套编号
    ,P1.SYSTID -- 源系统代码
    ,P1.LOANNO -- 核心贷款号
    ,P1.TRANDT -- 交易日期
    ,P1.TRANSQ -- 交易流水号
    ,to_char(P1.ACCOIN) -- 交易流水序号
    ,nvl(trim(P1.TRANCD),'-'） -- 子交易类别代码
    ,P1.CRCYCD -- 币种代码
    ,P1.DEPTCD -- 机构编号
    ,P1.DEBTNO -- 借据编号
    ,nvl(trim(P1.BUSITP),'-'） -- 业务类型代码
    ,P1.PRDUCD -- 产品编号
    ,P1.LNCTNO -- 合同编号
    ,P1.ODLNNO -- 原贷款号
    ,P1.DEVAAM -- 贷款减值准备金额
    ,P1.INTEAD -- 贴现利息
    ,P1.INTEIN -- 利息收入
    ,P1.NORMPR -- 正常本金
    ,P1.VERIPR -- 资产证券化本金
    ,P1.ACIMII -- 其他应收款减值准备金额
    ,P1.VATAXM -- 销项税额
    ,P1.OPPOTR -- 代垫增值税金额
    ,P1.ACCUTO -- 已核销本金
    ,P1.ACASIL -- 已核销垫付款
    ,P1.REINRE -- 应收利息
    ,P1.REGCIR -- 应计已减值利息
    ,P1.REACIN -- 保函本金
    ,P1.REACCI -- 非应计应收利息
    ,P1.REGACI -- 已核销利息
    ,P1.REGICR -- 应收未收利息
    ,P1.COLLPE -- 应付利息
    ,nvl(trim(p1.STATUS),'-') -- 账户状态代码
    ,P1.BSNSSQ -- 全局流水号
    ,decode(P1.DSCTTG,'Y','1','N','0',' ','-',P1.DSCTTG) -- 贴息标志
    ,decode(P1.EXTETG,'Y','1','N','0',' ','-',P1.EXTETG) -- 展期标志
    ,decode(P1.SECUTG,'Y','1','N','0',' ','-',P1.SECUTG) -- 资产证券化标志
    ,decode(P1.INCOTG,'Y','1','N','0',' ','-',P1.INCOTG) -- 撤并标志
    ,decode(P1.ADITTG,'Y','1','N','0',' ','-',P1.ADITTG) -- 预收息标志
    ,decode(P1.RATENR,'Y','1','N','0',' ','-',P1.RATENR) -- 合同执行利率
    ,nvl(trim(P1.RATECY),'-') -- 正常利率周期代码
    ,P1.OVDUPR -- 逾期本金
    ,P1.OVDURT -- 逾期利率
    ,nvl(trim(P1.OVDUCY),'-') -- 逾期利率周期代码
    ,P1.RECEDE -- 复利
    ,P1.COMPIN -- 当前到期的复利
    ,P1.COMPRA -- 复利利率
    ,nvl(trim(P1.COMPCY),'-') -- 复利利率周期代码
    ,nvl(trim(P1.GRACCY),'-') -- 宽限期利率周期代码
    ,decode(P1.INTETG,'Y','1','N','0',' ','-',P1.INTETG) -- 计息标志
    ,${iml_schema}.dateformat_min(P1.STINDT) -- 起息日期
    ,${iml_schema}.dateformat_max2(P1.NESEDT) -- 下次结息日期
    ,P1.ACCOIN -- 当天到期的罚息
    ,P1.COACIN -- 罚息
    ,P1.CUSTCD -- 客户编号
    ,P1.CUSTNA -- 客户名称
    ,nvl(trim(P1.RISKCD),'99') -- 贷款五级分类代码
    ,P1.PHASCD -- 贷款阶段
    ,${iml_schema}.dateformat_max2(P1.ISSUDT) -- 贷款放款日期
    ,P1.ISSUAM -- 贷款放款金额
    ,P1.ACTUAM -- 实际发放金额
    ,${iml_schema}.dateformat_max2(P1.EXPIDT) -- 贷款到期日期
    ,nvl(trim(P1.RETUWY),'-') -- 转让方式代码
    ,decode(P1.PRODP1,'*','-',' ','-',P1.PRODP1) -- 资金性质代码
    ,decode(P1.ACCRTG,'Y','1','N','0',' ','-',P1.ACCRTG) -- 应计标志
    ,P1.ACCRIN -- 应计利息
    ,P1.OFBSCI -- 表外应计复利
    ,P1.ASSEIP -- 应税已收回利息
    ,decode(P1.DEVATG,'Y','1','N','0','*','-',' ','-',P1.DEVATG) -- 减值标志
    ,P1.ASSELO -- 资产减值损失金额
    ,P1.INTEIM -- 已减值利息
    ,P1.IMPAII -- 已减值利息收入
    ,P1.INTERE -- 应收利息应税
    ,P1.OFBSIR -- 表外应收利息
    ,P1.OFBSRC -- 表外应收复利
    ,P1.OFBSAI -- 表外应计利息
    ,P1.WROFBD -- 已核销呆账本金
    ,P1.WROFDE -- 已核销呆账已减值利息
    ,P1.WRINBD -- 已核销呆账利息
    ,P1.IMINYE -- 本年利息收入
    ,P1.ACININ -- 已核销利息_未计税
    ,P1.IMIIYE -- 本年已减值利息收入
    ,P1.AMOU02 -- 累计利息收入
    ,P1.AMOU03 -- 当季度增值税
    ,decode(P1.ATTRA1,'Y','1','N','0',' ','-',P1.ATTRA1) -- 个体工商户标志
    ,decode(P1.ATTRA2,'*','0',' ','0',P1.ATTRA2)-- 企业规模代码
    ,P1.ATTRA5 -- 循环贷首次放款标志
    ,P1.ATTRA6 -- 循环贷标志
    ,decode(trim(P1.ATTRA7),'','000','*','000',P1.ATTRA7) -- 国门经济类别代码
    ,nvl(trim(P1.ATTRA8),'0000') -- 渠道代码
    ,decode(P1.AMORTG,'Y','1','N','0',' ','-',P1.AMORTG) -- 摊销标志
    ,nvl(trim(P1.AMORFR),'-') -- 摊销频度代码
    ,P1.AMORCO -- 摊余成本
    ,P1.INVEIN -- 投资收益
    ,P1.INVEYE -- 本年投资收益
    ,P1.INVETO -- 累计投资收益
    ,P1.BATHID -- 批次号
    ,P1.TRANBR -- 交易机构编号
    ,nvl(trim(P1.EVENTP),'-') -- 交易类型代码
    ,${iml_schema}.dateformat_min(P1.NCBSTRANTI) -- 业务发生日期
    ,nvl(trim(P1.STRKST),'-') -- 冲正业务标志
    ,${iml_schema}.dateformat_max2(P1.STRKDT) -- 被冲正日期
    ,P1.STRKSQ -- 被冲正流水号
    ,P1.AMOU13 -- 备用金额
    ,P1.AFTDEPT -- 更新机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_ama_loan_acct_h' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.tgls_ama_loan_acct_h p1
where  1 = 1 
    and P1.trandt = '${batch_date}'
    and P1.etl_dt = to_date('${batch_date}','yyyymmdd')
;
commit;

-- tgls_ama_loan_acct-1
insert into ${iml_schema}.evt_loan_sub_acct_measure_flow_tglsi1_tm(
    evt_id -- 事件编号
    ,sob_id -- 账套编号
    ,src_sys_cd -- 源系统代码
    ,core_loan_num -- 核心贷款号
    ,tran_dt -- 交易日期
    ,tran_flow_num -- 交易流水号
    ,tran_flow_seq_num -- 交易流水序号
    ,sub_tran_cate_cd -- 子交易类别代码
    ,curr_cd -- 币种代码
    ,org_id -- 机构编号
    ,dubil_id -- 借据编号
    ,bus_type_cd -- 业务类型代码
    ,prod_id -- 产品编号
    ,cont_id -- 合同编号
    ,init_loan_num -- 原贷款号
    ,loan_impam_resv_lmt -- 贷款减值准备金额
    ,discnt_int -- 贴现利息
    ,int_income -- 利息收入
    ,nomal_pric -- 正常本金
    ,abs_pric -- 资产证券化本金
    ,other_acct_recvbl_impam_resv_lmt -- 其他应收款减值准备金额
    ,output_tax_lmt -- 销项税额
    ,adv_vat_amt -- 代垫增值税金额
    ,wrtn_off_pric -- 已核销本金
    ,wrtn_off_advc_money -- 已核销垫付款
    ,int_recvbl -- 应收利息
    ,acru_aldy_impam_int -- 应计已减值利息
    ,log_pric -- 保函本金
    ,non_acru_int_recvbl -- 非应计应收利息
    ,wrtn_off_int -- 已核销利息
    ,recvbl_uncol_int -- 应收未收利息
    ,int_paybl -- 应付利息
    ,acct_status_cd -- 账户状态代码
    ,ova_flow_num -- 全局流水号
    ,int_sub_flg -- 贴息标志
    ,renew_flg -- 展期标志
    ,abs_flg -- 资产证券化标志
    ,merge_flg -- 撤并标志
    ,pre_recv_int_flg -- 预收息标志
    ,cont_exec_int_rat -- 合同执行利率
    ,nomal_int_rat_ped_cd -- 正常利率周期代码
    ,ovdue_pric -- 逾期本金
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_ped_cd -- 逾期利率周期代码
    ,comp_int -- 复利
    ,curr_exp_comp_int -- 当前到期的复利
    ,comp_int_int_rat -- 复利利率
    ,comp_int_int_rat_ped_cd -- 复利利率周期代码
    ,grace_period_int_rat_ped_cd -- 宽限期利率周期代码
    ,int_accr_flg -- 计息标志
    ,value_dt -- 起息日期
    ,next_int_set_dt -- 下次结息日期
    ,td_exp_pnlt -- 当天到期的罚息
    ,pnlt -- 罚息
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,loan_stage -- 贷款阶段
    ,loan_distr_dt -- 贷款放款日期
    ,loan_distr_amt -- 贷款放款金额
    ,actl_distr_amt -- 实际发放金额
    ,loan_exp_dt -- 贷款到期日期
    ,tran_way_cd -- 转让方式代码
    ,cap_char_cd -- 资金性质代码
    ,acru_flg -- 应计标志
    ,acru_int -- 应计利息
    ,off_bs_acru_comp_int -- 表外应计复利
    ,taxable_colled_int -- 应税已收回利息
    ,impam_flg -- 减值标志
    ,asset_impam_loss_amt -- 资产减值损失金额
    ,aldy_impam_int -- 已减值利息
    ,aldy_impam_int_income -- 已减值利息收入
    ,int_recvbl_taxable -- 应收利息应税
    ,off_bs_int_recvbl -- 表外应收利息
    ,off_bs_recvbl_comp_int -- 表外应收复利
    ,off_bs_acru_int -- 表外应计利息
    ,wrtn_off_bad_debt_pric -- 已核销呆账本金
    ,wrtn_off_bad_debt_aldy_impam_int -- 已核销呆账已减值利息
    ,wrtn_off_bad_debt_int -- 已核销呆账利息
    ,th_year_int_income -- 本年利息收入
    ,wrtn_off_int_not_tax -- 已核销利息_未计税
    ,th_year_aldy_impam_int_income -- 本年已减值利息收入
    ,acm_int_income -- 累计利息收入
    ,th_quar_degree_vat -- 当季度增值税
    ,indv_bus_flg -- 个体工商户标志
    ,corp_size_cd -- 企业规模代码
    ,circl_lon_fir_distr_flg -- 循环贷首次放款标志
    ,circl_lon_flg -- 循环贷标志
    ,indus_type_cd -- 国门经济类别代码
    ,chn_cd -- 渠道代码
    ,amort_flg -- 摊销标志
    ,amort_freq_cd -- 摊销频度代码
    ,amort_cost -- 摊余成本
    ,invest_prft -- 投资收益
    ,th_year_invest_prft -- 本年投资收益
    ,acm_invest_prft -- 累计投资收益
    ,batch_no -- 批次号
    ,tran_org_id -- 交易机构编号
    ,tran_type_cd -- 交易类型代码
    ,bus_happ_dt -- 业务发生日期
    ,revs_bus_flg -- 冲正业务标志
    ,brevs_dt -- 被冲正日期
    ,brevs_flow_num -- 被冲正流水号
    ,stdby_amt -- 备用金额
    ,update_org_id -- 更新机构编号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '401010'||P1.STACID||P1.SYSTID||P1.LOANNO||P1.TRANDT||P1.TRANSQ -- 事件编号
    ,P1.STACID -- 账套编号
    ,P1.SYSTID -- 源系统代码
    ,P1.LOANNO -- 核心贷款号
    ,P1.TRANDT -- 交易日期
    ,P1.TRANSQ -- 交易流水号
    ,to_char(P1.ACCOIN) -- 交易流水序号
    ,nvl(trim(P1.TRANCD),'-'） -- 子交易类别代码
    ,P1.CRCYCD -- 币种代码
    ,P1.DEPTCD -- 机构编号
    ,P1.DEBTNO -- 借据编号
    ,nvl(trim(P1.BUSITP),'-'） -- 业务类型代码
    ,P1.PRDUCD -- 产品编号
    ,P1.LNCTNO -- 合同编号
    ,P1.ODLNNO -- 原贷款号
    ,P1.DEVAAM -- 贷款减值准备金额
    ,P1.INTEAD -- 贴现利息
    ,P1.INTEIN -- 利息收入
    ,P1.NORMPR -- 正常本金
    ,P1.VERIPR -- 资产证券化本金
    ,P1.ACIMII -- 其他应收款减值准备金额
    ,P1.VATAXM -- 销项税额
    ,P1.OPPOTR -- 代垫增值税金额
    ,P1.ACCUTO -- 已核销本金
    ,P1.ACASIL -- 已核销垫付款
    ,P1.REINRE -- 应收利息
    ,P1.REGCIR -- 应计已减值利息
    ,P1.REACIN -- 保函本金
    ,P1.REACCI -- 非应计应收利息
    ,P1.REGACI -- 已核销利息
    ,P1.REGICR -- 应收未收利息
    ,P1.COLLPE -- 应付利息
    ,nvl(trim(p1.STATUS),'-') -- 账户状态代码
    ,P1.BSNSSQ -- 全局流水号
    ,decode(P1.DSCTTG,'Y','1','N','0',' ','-',P1.DSCTTG) -- 贴息标志
    ,decode(P1.EXTETG,'Y','1','N','0',' ','-',P1.EXTETG) -- 展期标志
    ,decode(P1.SECUTG,'Y','1','N','0',' ','-',P1.SECUTG) -- 资产证券化标志
    ,decode(P1.INCOTG,'Y','1','N','0',' ','-',P1.INCOTG) -- 撤并标志
    ,decode(P1.ADITTG,'Y','1','N','0',' ','-',P1.ADITTG) -- 预收息标志
    ,decode(P1.RATENR,'Y','1','N','0',' ','-',P1.RATENR) -- 合同执行利率
    ,nvl(trim(P1.RATECY),'-') -- 正常利率周期代码
    ,P1.OVDUPR -- 逾期本金
    ,P1.OVDURT -- 逾期利率
    ,nvl(trim(P1.OVDUCY),'-') -- 逾期利率周期代码
    ,P1.RECEDE -- 复利
    ,P1.COMPIN -- 当前到期的复利
    ,P1.COMPRA -- 复利利率
    ,nvl(trim(P1.COMPCY),'-') -- 复利利率周期代码
    ,nvl(trim(P1.GRACCY),'-') -- 宽限期利率周期代码
    ,decode(P1.INTETG,'Y','1','N','0',' ','-',P1.INTETG) -- 计息标志
    ,${iml_schema}.dateformat_min(P1.STINDT) -- 起息日期
    ,${iml_schema}.dateformat_max2(P1.NESEDT) -- 下次结息日期
    ,P1.ACCOIN -- 当天到期的罚息
    ,P1.COACIN -- 罚息
    ,P1.CUSTCD -- 客户编号
    ,P1.CUSTNA -- 客户名称
    ,nvl(trim(P1.RISKCD),'99') -- 贷款五级分类代码
    ,P1.PHASCD -- 贷款阶段
    ,${iml_schema}.dateformat_max2(P1.ISSUDT) -- 贷款放款日期
    ,P1.ISSUAM -- 贷款放款金额
    ,P1.ACTUAM -- 实际发放金额
    ,${iml_schema}.dateformat_max2(P1.EXPIDT) -- 贷款到期日期
    ,nvl(trim(P1.RETUWY),'-') -- 转让方式代码
    ,decode(P1.PRODP1,'*','-',' ','-',P1.PRODP1)  -- 资金性质代码
    ,decode(P1.ACCRTG,'Y','1','N','0',' ','-',P1.ACCRTG) -- 应计标志
    ,P1.ACCRIN -- 应计利息
    ,P1.OFBSCI -- 表外应计复利
    ,P1.ASSEIP -- 应税已收回利息
    ,decode(P1.DEVATG,'Y','1','N','0','*','-',' ','-',P1.DEVATG) -- 减值标志
    ,P1.ASSELO -- 资产减值损失金额
    ,P1.INTEIM -- 已减值利息
    ,P1.IMPAII -- 已减值利息收入
    ,P1.INTERE -- 应收利息应税
    ,P1.OFBSIR -- 表外应收利息
    ,P1.OFBSRC -- 表外应收复利
    ,P1.OFBSAI -- 表外应计利息
    ,P1.WROFBD -- 已核销呆账本金
    ,P1.WROFDE -- 已核销呆账已减值利息
    ,P1.WRINBD -- 已核销呆账利息
    ,P1.IMINYE -- 本年利息收入
    ,P1.ACININ -- 已核销利息_未计税
    ,P1.IMIIYE -- 本年已减值利息收入
    ,P1.AMOU02 -- 累计利息收入
    ,P1.AMOU03 -- 当季度增值税
    ,decode(P1.ATTRA1,'Y','1','N','0',' ','-',P1.ATTRA1) -- 个体工商户标志
    ,decode(P1.ATTRA2,'*','0',' ','0',P1.ATTRA2)-- 企业规模代码 
    ,P1.ATTRA5 -- 循环贷首次放款标志
    ,P1.ATTRA6 -- 循环贷标志
    ,decode(trim(P1.ATTRA7),'','000','*','000',P1.ATTRA7) -- 国门经济类别代码
    ,nvl(trim(P1.ATTRA8),'0000') -- 渠道代码
    ,decode(P1.AMORTG,'Y','1','N','0',' ','-',P1.AMORTG) -- 摊销标志
    ,nvl(trim(P1.AMORFR),'-') -- 摊销频度代码
    ,P1.AMORCO -- 摊余成本
    ,P1.INVEIN -- 投资收益
    ,P1.INVEYE -- 本年投资收益
    ,P1.INVETO -- 累计投资收益
    ,P1.BATHID -- 批次号
    ,P1.TRANBR -- 交易机构编号
    ,nvl(trim(P1.EVENTP),'-') -- 交易类型代码
    ,${iml_schema}.dateformat_min(P1.NCBSTRANTI) -- 业务发生日期
    ,nvl(trim(P1.STRKST),'-') -- 冲正业务标志
    ,${iml_schema}.dateformat_max2(P1.STRKDT) -- 被冲正日期
    ,P1.STRKSQ -- 被冲正流水号
    ,P1.AMOU13 -- 备用金额
    ,P1.AFTDEPT -- 更新机构编号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'tgls_ama_loan_acct' -- 源表名称
    ,'tglsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
 from ${iol_schema}.tgls_ama_loan_acct p1
where 1 = 1
  and not exists
(select 1
         from ${iol_schema}.tgls_ama_loan_acct_h p2
        where p1.stacid = p2.stacid
          and p1.systid = p2.systid
          and p1.loanno = p2.loanno
          and p2.trandt = '${batch_date}'
          and p2.etl_dt = to_date('${batch_date}', 'yyyymmdd'))
  and p1.start_dt <= to_date('${batch_date}', 'yyyymmdd')
  and p1.end_dt > to_date('${batch_date}', 'yyyymmdd')
;
commit;


-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_loan_sub_acct_measure_flow truncate subpartition p_tglsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_loan_sub_acct_measure_flow exchange subpartition p_tglsi1_${batch_date} with table ${iml_schema}.evt_loan_sub_acct_measure_flow_tglsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_loan_sub_acct_measure_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_loan_sub_acct_measure_flow_tglsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_loan_sub_acct_measure_flow', partname => 'p_tglsi1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);