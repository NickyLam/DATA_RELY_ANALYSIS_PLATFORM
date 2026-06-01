/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_dubil_info_h_icmsf1
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 1;

-- 2.1 create backup table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_loan_dubil_info_h add partition p_icmsf1 values ('icmsf1')(
        subpartition p_icmsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_icmsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_info_h partition for ('icmsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,rela_out_acct_flow_num -- 关联出账流水号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sub_prod_id -- 子产品编号
    ,curr_cd -- 币种代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_dt -- 发放日期
    ,enter_id -- 卡号
    ,actl_amt -- 实付金额
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,loan_tot_perds -- 贷款总期数
    ,surp_repay_perds -- 剩余还款期数
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,apot_exp_dt -- 约定到期日期
    ,actl_exp_dt -- 实际到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,ncb_base_rat_type_cd -- 核心基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,exec_year_int_rat -- 执行年利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_range -- 利率浮动幅度
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,float_point -- 浮动百分点
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,margin_acct_id -- 保证金账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_acct_id -- 放款账户编号
    ,distr_acct_name -- 放款账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,out_acct_org_id -- 出账机构编号
    ,rela_pay_appl_form_id -- 关联付款申请书编号
    ,repay_way_cd -- 还款方式代码
    ,deflt_repay_day -- 默认还款日
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,dep_lon_int_set_day -- 存贷结息日
    ,renew_cnt -- 展期次数
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,repay_num_bal -- 还款账号余额
    ,repay_num_aval_bal -- 还款账户可用余额
    ,nomal_bal -- 正常余额
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,ibank_sys_pric_bal -- 同业系统本金余额
    ,comp_int_bal -- 复息余额
    ,file_int_accr_flg -- 靠档计息标志
    ,int_accr_flg -- 计息标志
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复息
    ,recvbl_uncol_comp_int -- 应收未收复息
    ,non_acru_bal -- 非应计余额
    ,advc_flg -- 垫款标志
    ,happ_dt -- 垫款日期
    ,curr_bal -- 垫款余额
    ,comp_amt -- 代偿金额
    ,loan_grace_period -- 贷款宽限期天数
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_exp_dt -- 宽限到期日期
    ,grace_begin_dt -- 宽限起始日期
    ,ovdue_cnt -- 逾期次数
    ,fir_ovdue_dt -- 首次逾期日期
    ,conti_ovdue_dt -- 连续逾期日期
    ,ovdue_dt -- 逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,ovdue_bal -- 逾期本金
    ,pric_ovdue_days -- 本金逾期天数
    ,pric_ovdue_amt -- 本金逾期金额
    ,pric_ovdue_fst_dt -- 本金最早逾期日期
    ,int_ovdue_days -- 利息逾期天数
    ,int_ovdue_amt -- 利息逾期金额
    ,int_ovdue_fst_dt -- 利息最早逾期日期
    ,pnlt_flg -- 罚息标志
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,over_int_dt -- 欠息日期
    ,over_int_days -- 欠息天数
    ,recvbl_over_int -- 应收欠息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_uncol_pnlt -- 应收未收罚息
    ,comp_int_flg -- 复利标志
    ,coll_over_int -- 催收欠息
    ,coll_pnlt -- 催收罚息
    ,coll_acru_int -- 催收应计利息
    ,coll_acru_pnlt -- 催收应计罚息
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_flg -- 表外标志
    ,off_bs_over_int_bal -- 表外欠息余额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,accti_org_id -- 核算机构编号
    ,provi_resv_lmt -- 计提准备金额
    ,pre_loss_amt -- 预测损失金额
    ,move_remark -- 迁移备注
    ,refac_loan_idf_cd -- 支小再贷款标识代码
    ,spcl_refac_idf_cd -- 专项再贷款标识代码
    ,init_bus_id -- 原业务编号
    ,init_dubil_id -- 原始借据编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,old_cust_id -- 旧客户编号
    ,old_prod_id -- 旧产品编号
    ,next_int_set_dt -- 下一结息日期
    ,prob_asset_flg -- 问题资产标志
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,regroup_loan_flg -- 重组贷款标志
    ,regroup_dt -- 重组日期
    ,regroup_loan_type_cd -- 重组贷款类型代码
    ,stl_acct_open_bank_num -- 结算账户开户行号
    ,stl_acct_seq_num -- 结算账户序号
    ,bad_debt_wrt_off_status_cd -- 呆账核销状态代码
    ,wrt_off_dt -- 核销日期
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,wrt_off_callbk_amt -- 核销回收金额
    ,revs_flg -- 冲正标志
    ,termnt_dt -- 终止日期
    ,belong_strip_line_cd -- 所属条线代码
    ,risk_monit_rela_flow_num -- 风险监测关联流水号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,level11_cls_dt -- 十一级分类日期
    ,low_risk_flg -- 低风险标志
    ,level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,last_level10_cls_cd -- 上一十级分类代码
    ,last_level10_cls_dt -- 上一十级分类日期
    ,last_level5_cls_cd -- 上一五级分类代码
    ,last_level5_cls_cmplt_dt -- 上一五级分类完成日期
    ,last_term_level5_cls_modif_dt -- 上一期五级分类变更日期
    ,abs_flg -- 资产证券化标志
    ,cred_rht_advise_cfmed_flg -- 债权通知书已确认标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,prft_cut_amt -- 分润金额
    ,oper_dt -- 经办日期
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_dubil_info_h partition for ('icmsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_info_h partition for ('icmsf1') where 0=1;

create table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_dubil_info_h partition for ('icmsf1') where 0=1;

-- 3.1 get new data into table
-- icms_business_duebill-1
insert into ${iml_schema}.agt_loan_dubil_info_h_icmsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,rela_out_acct_flow_num -- 关联出账流水号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sub_prod_id -- 子产品编号
    ,curr_cd -- 币种代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_dt -- 发放日期
    ,enter_id -- 卡号
    ,actl_amt -- 实付金额
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,loan_tot_perds -- 贷款总期数
    ,surp_repay_perds -- 剩余还款期数
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,apot_exp_dt -- 约定到期日期
    ,actl_exp_dt -- 实际到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,ncb_base_rat_type_cd -- 核心基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,exec_year_int_rat -- 执行年利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_range -- 利率浮动幅度
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,float_point -- 浮动百分点
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,margin_acct_id -- 保证金账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_acct_id -- 放款账户编号
    ,distr_acct_name -- 放款账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,out_acct_org_id -- 出账机构编号
    ,rela_pay_appl_form_id -- 关联付款申请书编号
    ,repay_way_cd -- 还款方式代码
    ,deflt_repay_day -- 默认还款日
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,dep_lon_int_set_day -- 存贷结息日
    ,renew_cnt -- 展期次数
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,repay_num_bal -- 还款账号余额
    ,repay_num_aval_bal -- 还款账户可用余额
    ,nomal_bal -- 正常余额
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,ibank_sys_pric_bal -- 同业系统本金余额
    ,comp_int_bal -- 复息余额
    ,file_int_accr_flg -- 靠档计息标志
    ,int_accr_flg -- 计息标志
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复息
    ,recvbl_uncol_comp_int -- 应收未收复息
    ,non_acru_bal -- 非应计余额
    ,advc_flg -- 垫款标志
    ,happ_dt -- 垫款日期
    ,curr_bal -- 垫款余额
    ,comp_amt -- 代偿金额
    ,loan_grace_period -- 贷款宽限期天数
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_exp_dt -- 宽限到期日期
    ,grace_begin_dt -- 宽限起始日期
    ,ovdue_cnt -- 逾期次数
    ,fir_ovdue_dt -- 首次逾期日期
    ,conti_ovdue_dt -- 连续逾期日期
    ,ovdue_dt -- 逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,ovdue_bal -- 逾期本金
    ,pric_ovdue_days -- 本金逾期天数
    ,pric_ovdue_amt -- 本金逾期金额
    ,pric_ovdue_fst_dt -- 本金最早逾期日期
    ,int_ovdue_days -- 利息逾期天数
    ,int_ovdue_amt -- 利息逾期金额
    ,int_ovdue_fst_dt -- 利息最早逾期日期
    ,pnlt_flg -- 罚息标志
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,over_int_dt -- 欠息日期
    ,over_int_days -- 欠息天数
    ,recvbl_over_int -- 应收欠息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_uncol_pnlt -- 应收未收罚息
    ,comp_int_flg -- 复利标志
    ,coll_over_int -- 催收欠息
    ,coll_pnlt -- 催收罚息
    ,coll_acru_int -- 催收应计利息
    ,coll_acru_pnlt -- 催收应计罚息
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_flg -- 表外标志
    ,off_bs_over_int_bal -- 表外欠息余额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,accti_org_id -- 核算机构编号
    ,provi_resv_lmt -- 计提准备金额
    ,pre_loss_amt -- 预测损失金额
    ,move_remark -- 迁移备注
    ,refac_loan_idf_cd -- 支小再贷款标识代码
    ,spcl_refac_idf_cd -- 专项再贷款标识代码
    ,init_bus_id -- 原业务编号
    ,init_dubil_id -- 原始借据编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,old_cust_id -- 旧客户编号
    ,old_prod_id -- 旧产品编号
    ,next_int_set_dt -- 下一结息日期
    ,prob_asset_flg -- 问题资产标志
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,regroup_loan_flg -- 重组贷款标志
    ,regroup_dt -- 重组日期
    ,regroup_loan_type_cd -- 重组贷款类型代码
    ,stl_acct_open_bank_num -- 结算账户开户行号
    ,stl_acct_seq_num -- 结算账户序号
    ,bad_debt_wrt_off_status_cd -- 呆账核销状态代码
    ,wrt_off_dt -- 核销日期
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,wrt_off_callbk_amt -- 核销回收金额
    ,revs_flg -- 冲正标志
    ,termnt_dt -- 终止日期
    ,belong_strip_line_cd -- 所属条线代码
    ,risk_monit_rela_flow_num -- 风险监测关联流水号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,level11_cls_dt -- 十一级分类日期
    ,low_risk_flg -- 低风险标志
    ,level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,last_level10_cls_cd -- 上一十级分类代码
    ,last_level10_cls_dt -- 上一十级分类日期
    ,last_level5_cls_cd -- 上一五级分类代码
    ,last_level5_cls_cmplt_dt -- 上一五级分类完成日期
    ,last_term_level5_cls_modif_dt -- 上一期五级分类变更日期
    ,abs_flg -- 资产证券化标志
    ,cred_rht_advise_cfmed_flg -- 债权通知书已确认标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,prft_cut_amt -- 分润金额
    ,oper_dt -- 经办日期
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300004'||P1.SERIALNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.SERIALNO -- 借据编号
    ,P1.PUTOUTSERIALNO -- 关联出账流水号
    ,P1.CONTRACTSERIALNO -- 关联合同编号
    ,P1.CUSTOMERID -- 客户编号
    ,P1.CUSTOMERNAME -- 客户名称
    ,P1.PRODUCTID -- 产品编号
    ,nvl(trim(P1.SUBPRODUCTNAME),'-') -- 子产品编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,nvl(trim(P1.LOANSTATUS),'00') -- 贷款状态代码
    ,nvl(trim(P1.OCCURTYPE),'-') -- 贷款发放类型代码
    ,P1.PUTOUTDATE -- 发放日期
    ,P1.LOANNO -- 卡号
    ,P1.REPAYAMT -- 实付金额
    ,nvl(trim(P1.BUSINESSSTATUS),'-') -- 借据状态代码
    ,P1.BUSINESSSUM -- 借据金额
    ,P1.PERIODS -- 贷款总期数
    ,P1.REMAIN_PERIODS -- 剩余还款期数
    ,P1.TERMMONTH -- 月期限
    ,P1.TERMDAY -- 日期限
    ,decode(p1.MATURITY,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.MATURITY) -- 约定到期日期
    ,decode(p1.ACTUALMATURITY,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.ACTUALMATURITY) -- 实际到期日期
    ,nvl(trim(P1.RATEMODEL),'-') -- 利率模式代码
    ,nvl(trim(P1.BASERATETYPE),'-') -- 基准利率类型代码
    ,P1.BASERATE -- 基准利率
    ,nvl(trim(P1.INTTYPE),'-') -- 核心基准利率类型代码
    ,nvl(trim(P1.RATEFLOATTYPE),'-') -- 利率浮动类型代码
    ,P1.EXECUTERATE -- 执行年利率
    ,nvl(trim(P1.RATEADJUSTTYPE),'-') -- 利率调整方式代码
    ,nvl(trim(P1.RATEADJUSTFREQUENCY),'-') -- 利率调整周期代码
    ,P1.FLOATRANGE -- 利率浮动幅度
    ,nvl(trim(P1.RATEFLOATRATIOORBP),'-') -- 利率浮动方式代码
    ,nvl(trim(P1.INTAPPLTYPE),'-') -- 利率启用方式代码
    ,nvl(trim(P1.ROLLFREQ),'-') -- 利率变更周期代码
    ,P1.ACCTSPREADRATE -- 浮动百分点
    ,nvl(trim(P1.VOUCHTYPE),'-') -- 主担保方式代码
    ,nvl(trim(P1.VOUCHTYPE2),'-') -- 担保方式代码二
    ,nvl(trim(P1.VOUCHTYPE3),'-') -- 担保方式代码三
    ,P1.BAILRATIO -- 保证金比例
    ,P1.BAILSUM -- 保证金金额
    ,P1.BAILACCOUNT -- 保证金账户编号
    ,nvl(trim(P1.PAYMENTTYPE),'0') -- 放款支付方式代码
    ,P1.LOANACCOUNTNO -- 放款账户编号
    ,P1.LOANACCOUNTNAME -- 放款账户名称
    ,P1.LOANACCOUNTORGID -- 入账账户开户机构编号
    ,P1.PUTOUTORGID -- 出账机构编号
    ,P1.PAYMENTSERIALNO -- 关联付款申请书编号
    ,nvl(trim(P1.REPAYTYPE),'-') -- 还款方式代码
    ,P1.REPAYDATE -- 默认还款日
    ,case when P1.REPAYCYCLE='06' then '1'  
 else nvl(substr( P1.REPAYCYCLE,2,1),0) end -- 还款周期
    ,case when P1.REPAYCYCLE='06' then 'O'
 else nvl(substr( P1.REPAYCYCLE,1,1),'-') end -- 还款周期单位代码
    ,${iml_schema}.dateformat_max2(P1.INTDAY) -- 存贷结息日
    ,P1.EXTENDTIMES -- 展期次数
    ,P1.SETTLEMENTACCOUNT -- 还款账户编号
    ,P1.SETTLEMENTACCOUNTNAME -- 还款账户名称
    ,P1.ACCOUNTBALANCE -- 还款账号余额
    ,P1.ACCOUNTUSERBALANCE -- 还款账户可用余额
    ,P1.NORMALBALANCE -- 正常余额
    ,P1.PRINCIPALBALANCE -- 本金余额
    ,P1.INTERESTBALANCE -- 利息余额
    ,P1.TYSUMCP -- 同业系统本金余额
    ,P1.INTERESTPENALTYBALANCE -- 复息余额
    ,nvl(trim(P1.GEARPRODFLAG),'-') -- 靠档计息标志
    ,nvl(trim(P1.INTINDFLAG),'-') -- 计息标志
    ,P1.YJINTAMT -- 应计利息
    ,P1.YJODPAMT -- 应计罚息
    ,P1.YJODIAMT -- 应计复息
    ,P1.ODIPOSTEDCTDDR -- 应收未收复息
    ,P1.FYJBALAMT -- 非应计余额
    ,nvl(trim(P1.ADVANCEFLAG),'-') -- 垫款标志
    ,P1.OCCURDATE -- 垫款日期
    ,P1.BALANCE -- 垫款余额
    ,P1.COMPENSATEAMT -- 代偿金额
    ,P1.GRACEPERIOD -- 贷款宽限期天数
    ,nvl(trim(P1.GRACETYPE),'-') -- 宽限期类型代码
    ,P1.COMPENSATEPOTYPE -- 宽限到期日期
    ,P1.GRACESTARTDATE -- 宽限起始日期
    ,P1.OVERDUECOUNT -- 逾期次数
    ,P1.FIRSTOVERDUEDATE -- 首次逾期日期
    ,P1.CONTOVERDUEDATE -- 连续逾期日期
    ,${iml_schema}.dateformat_max2(P1.OVERDUEDATE) -- 逾期日期
    ,P1.OVERDUEDAYS -- 贷款逾期天数
    ,P1.OVERDUEBALANCE -- 逾期本金
    ,P1.PRIOVERDUEDAYS -- 本金逾期天数
    ,P1.PRIOVERDUEAMT -- 本金逾期金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.PRIFIRSTDUEDATE) -- 本金最早逾期日期
    ,P1.INTOVERDUEDAYS -- 利息逾期天数
    ,P1.INTOVERDUEAMT -- 利息逾期金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.INTFIRSTDUEDATE) -- 利息最早逾期日期
    ,decode(P1.ODPFLAG,'N','0','Y','1',' ','-',P1.ODPFLAG) -- 罚息标志
    ,P1.CAPITALPENALTYBALANCE -- 逾期罚息余额
    ,P1.OVERDUERATE -- 逾期利率
    ,nvl(trim(P1.OVERDUERATEFLOATTYPE),'-') -- 逾期利率浮动方式代码
    ,P1.OVERDUERATEFLOATVALUE -- 逾期利率浮动值
    ,${iml_schema}.dateformat_max2(P1.OWEINTERESTDATE) -- 欠息日期
    ,P1.OWNINTERESTDAYS -- 欠息天数
    ,P1.YSINTAMT -- 应收欠息
    ,P1.YSODPAMT -- 应收罚息
    ,P1.ODPPOSTEDCTDDR -- 应收未收罚息
    ,decode(P1.ODIFLAG,'N','0','Y','1',' ','-',P1.ODIFLAG) -- 复利标志
    ,P1.CSINTAMT -- 催收欠息
    ,P1.CSODPAMT -- 催收罚息
    ,P1.CSYJINTAMT -- 催收应计利息
    ,P1.CSYJODPAMT -- 催收应计罚息
    ,P1.INSUM -- 累计归还本金
    ,P1.INTERESTINSUM -- 累计归还利息
    ,P1.INNERINTERESTBALANCE -- 表内欠息余额
    ,nvl(trim(P1.OFFSHEETFLAG),'-') -- 表外标志
    ,P1.OUTERINTERESTBALANCE -- 表外欠息余额
    ,P1.DULLBALANCE -- 呆滞余额
    ,P1.BADBALANCE -- 呆账余额
    ,P1.MAINORGID -- 核算机构编号
    ,P1.REDUCERESERVESUM -- 计提准备金额
    ,P1.PREDICTLOSTSUM -- 预测损失金额
    ,P1.MIGTFLAG -- 迁移备注
    ,nvl(trim(P1.ZXZFLAG),'-') -- 支小再贷款标识代码
    ,nvl(trim(P1.SPECIALLENDFLAG),'-') -- 专项再贷款标识代码
    ,P1.EXTTRADENO -- 原业务编号
    ,P1.RELATIVEDUEBILLNO -- 原始借据编号
    ,P1.ORIGINALLOANDEADLINE -- 原贷款到期日期
    ,P1.MIGTCUSTOMERID -- 旧客户编号
    ,P1.MIGTBUSINESSTYPE -- 旧产品编号
    ,${iml_schema}.dateformat_min(p1.INTDATE) -- 下一结息日期
    ,nvl(trim(P1.ASSETFLAG),'-') -- 问题资产标志
    ,P1.BADCONFIRMDATE -- 首次认定不良日期
    ,decode(P1.WHETHERTORESTRUCTURETHELOAN,'2','0',' ','-',P1.WHETHERTORESTRUCTURETHELOAN) -- 重组贷款标志
    ,P1.RESTRUCTURETHELOANDATE -- 重组日期
    ,nvl(trim(P1.RESTRUCTURETHELOANTYPE),'-') -- 重组贷款类型代码
    ,P1.SETTLEMENTACCOUNTBANK -- 结算账户开户行号
    ,P1.SETTLEMENTACCOUNTNUM -- 结算账户序号
    ,nvl(trim(P1.DZHXSTATUS),'-') -- 呆账核销状态代码
    ,${iml_schema}.dateformat_max2(P1.WRNDATE) -- 核销日期
    ,P1.WRNPRIAMT -- 核销本金
    ,P1.WRNINTAMT -- 核销利息
    ,P1.WRNRECEIPTAMT -- 核销回收金额
    ,decode(P1.REVERSALFLAG,'N','0','Y','1',' ','-',P1.REVERSALFLAG) -- 冲正标志
    ,decode(P1.FINISHDATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.FINISHDATE) -- 终止日期
    ,nvl(trim(P1.BELONGDEPT),'-') -- 所属条线代码
    ,P1.LOANSERIALNO -- 风险监测关联流水号
    ,nvl(trim(P1.REMART),'XXX') -- 资产三分类代码
    ,nvl(trim(P1.CLASSIFYRESULT),'99') -- 五级分类代码
    ,decode(p1.CLASSIFYDATE,to_date('2999/12/31','yyyy/mm/dd'),to_date('0001/01/01','yyyy/mm/dd'),p1.CLASSIFYDATE) -- 五级分类日期
    ,nvl(trim(P1.CLASSIFYRESULTELEVEN),'20') -- 十一级分类代码
    ,decode(p1.CLASSIFYRESULTELEVENDATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.CLASSIFYRESULTELEVENDATE) -- 十一级分类日期
    ,nvl(trim(P1.ISLOWRISK),'-') -- 低风险标志
    ,decode(trim(P1.TENCLAIND),'1','1','2','0','','-') -- 十级分类人工干预标志
    ,nvl(trim(P1.LASTCLASSIFYRESULTTEN),'20') -- 上一十级分类代码
    ,P1.LASTCLASSIFYRESULTTENDATE -- 上一十级分类日期
    ,nvl(trim(P1.LASTCLASSIFYRESULT),'99') -- 上一五级分类代码
    ,${iml_schema}.dateformat_max2(P1.LASTCLASSIFYRESULTDATE) -- 上一五级分类完成日期
    ,P1.CLASSIFYFIVEHCHANGEDATE -- 上一期五级分类变更日期
    ,nvl(trim(P1.ABSFLAG),'-') -- 资产证券化标志
    ,decode(P1.NOTIFICATIONSTATUS,'01','0','02','1',' ','-',P1.NOTIFICATIONSTATUS) -- 债权通知书已确认标志
    ,nvl(trim(P1.ISPENSIONINDUSTRY),'-') -- 养老产业标志
    ,P1.SHAREAMOUNT -- 分润金额
    ,P1.OPERATEDATE -- 经办日期
    ,P1.OPERATEUSERID -- 业务经办人编号
    ,P1.OPERATEORGID -- 经办机构编号
    ,P1.INPUTUSERID -- 登记柜员编号
    ,P1.INPUTORGID -- 登记机构编号
    ,P1.INPUTDATE -- 登记日期
    ,P1.UPDATEUSERID -- 更新柜员编号
    ,P1.UPDATEORGID -- 更新机构编号
    ,to_date('00010101','yyyymmdd') -- 变更日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_business_duebill' -- 源表名称
    ,'icmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_business_duebill p1
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_dubil_info_h_icmsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,dubil_id
  	                               having count(1) > 1);
    if cnt = 0 
      then
        continue;
      else
        raise_application_error(-20001,'primary key is duplication');
    end if;
  end loop;
end;
/


-- 3.2 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_dubil_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,rela_out_acct_flow_num -- 关联出账流水号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sub_prod_id -- 子产品编号
    ,curr_cd -- 币种代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_dt -- 发放日期
    ,enter_id -- 卡号
    ,actl_amt -- 实付金额
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,loan_tot_perds -- 贷款总期数
    ,surp_repay_perds -- 剩余还款期数
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,apot_exp_dt -- 约定到期日期
    ,actl_exp_dt -- 实际到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,ncb_base_rat_type_cd -- 核心基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,exec_year_int_rat -- 执行年利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_range -- 利率浮动幅度
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,float_point -- 浮动百分点
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,margin_acct_id -- 保证金账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_acct_id -- 放款账户编号
    ,distr_acct_name -- 放款账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,out_acct_org_id -- 出账机构编号
    ,rela_pay_appl_form_id -- 关联付款申请书编号
    ,repay_way_cd -- 还款方式代码
    ,deflt_repay_day -- 默认还款日
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,dep_lon_int_set_day -- 存贷结息日
    ,renew_cnt -- 展期次数
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,repay_num_bal -- 还款账号余额
    ,repay_num_aval_bal -- 还款账户可用余额
    ,nomal_bal -- 正常余额
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,ibank_sys_pric_bal -- 同业系统本金余额
    ,comp_int_bal -- 复息余额
    ,file_int_accr_flg -- 靠档计息标志
    ,int_accr_flg -- 计息标志
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复息
    ,recvbl_uncol_comp_int -- 应收未收复息
    ,non_acru_bal -- 非应计余额
    ,advc_flg -- 垫款标志
    ,happ_dt -- 垫款日期
    ,curr_bal -- 垫款余额
    ,comp_amt -- 代偿金额
    ,loan_grace_period -- 贷款宽限期天数
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_exp_dt -- 宽限到期日期
    ,grace_begin_dt -- 宽限起始日期
    ,ovdue_cnt -- 逾期次数
    ,fir_ovdue_dt -- 首次逾期日期
    ,conti_ovdue_dt -- 连续逾期日期
    ,ovdue_dt -- 逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,ovdue_bal -- 逾期本金
    ,pric_ovdue_days -- 本金逾期天数
    ,pric_ovdue_amt -- 本金逾期金额
    ,pric_ovdue_fst_dt -- 本金最早逾期日期
    ,int_ovdue_days -- 利息逾期天数
    ,int_ovdue_amt -- 利息逾期金额
    ,int_ovdue_fst_dt -- 利息最早逾期日期
    ,pnlt_flg -- 罚息标志
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,over_int_dt -- 欠息日期
    ,over_int_days -- 欠息天数
    ,recvbl_over_int -- 应收欠息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_uncol_pnlt -- 应收未收罚息
    ,comp_int_flg -- 复利标志
    ,coll_over_int -- 催收欠息
    ,coll_pnlt -- 催收罚息
    ,coll_acru_int -- 催收应计利息
    ,coll_acru_pnlt -- 催收应计罚息
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_flg -- 表外标志
    ,off_bs_over_int_bal -- 表外欠息余额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,accti_org_id -- 核算机构编号
    ,provi_resv_lmt -- 计提准备金额
    ,pre_loss_amt -- 预测损失金额
    ,move_remark -- 迁移备注
    ,refac_loan_idf_cd -- 支小再贷款标识代码
    ,spcl_refac_idf_cd -- 专项再贷款标识代码
    ,init_bus_id -- 原业务编号
    ,init_dubil_id -- 原始借据编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,old_cust_id -- 旧客户编号
    ,old_prod_id -- 旧产品编号
    ,next_int_set_dt -- 下一结息日期
    ,prob_asset_flg -- 问题资产标志
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,regroup_loan_flg -- 重组贷款标志
    ,regroup_dt -- 重组日期
    ,regroup_loan_type_cd -- 重组贷款类型代码
    ,stl_acct_open_bank_num -- 结算账户开户行号
    ,stl_acct_seq_num -- 结算账户序号
    ,bad_debt_wrt_off_status_cd -- 呆账核销状态代码
    ,wrt_off_dt -- 核销日期
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,wrt_off_callbk_amt -- 核销回收金额
    ,revs_flg -- 冲正标志
    ,termnt_dt -- 终止日期
    ,belong_strip_line_cd -- 所属条线代码
    ,risk_monit_rela_flow_num -- 风险监测关联流水号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,level11_cls_dt -- 十一级分类日期
    ,low_risk_flg -- 低风险标志
    ,level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,last_level10_cls_cd -- 上一十级分类代码
    ,last_level10_cls_dt -- 上一十级分类日期
    ,last_level5_cls_cd -- 上一五级分类代码
    ,last_level5_cls_cmplt_dt -- 上一五级分类完成日期
    ,last_term_level5_cls_modif_dt -- 上一期五级分类变更日期
    ,abs_flg -- 资产证券化标志
    ,cred_rht_advise_cfmed_flg -- 债权通知书已确认标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,prft_cut_amt -- 分润金额
    ,oper_dt -- 经办日期
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_dubil_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,rela_out_acct_flow_num -- 关联出账流水号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sub_prod_id -- 子产品编号
    ,curr_cd -- 币种代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_dt -- 发放日期
    ,enter_id -- 卡号
    ,actl_amt -- 实付金额
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,loan_tot_perds -- 贷款总期数
    ,surp_repay_perds -- 剩余还款期数
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,apot_exp_dt -- 约定到期日期
    ,actl_exp_dt -- 实际到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,ncb_base_rat_type_cd -- 核心基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,exec_year_int_rat -- 执行年利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_range -- 利率浮动幅度
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,float_point -- 浮动百分点
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,margin_acct_id -- 保证金账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_acct_id -- 放款账户编号
    ,distr_acct_name -- 放款账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,out_acct_org_id -- 出账机构编号
    ,rela_pay_appl_form_id -- 关联付款申请书编号
    ,repay_way_cd -- 还款方式代码
    ,deflt_repay_day -- 默认还款日
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,dep_lon_int_set_day -- 存贷结息日
    ,renew_cnt -- 展期次数
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,repay_num_bal -- 还款账号余额
    ,repay_num_aval_bal -- 还款账户可用余额
    ,nomal_bal -- 正常余额
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,ibank_sys_pric_bal -- 同业系统本金余额
    ,comp_int_bal -- 复息余额
    ,file_int_accr_flg -- 靠档计息标志
    ,int_accr_flg -- 计息标志
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复息
    ,recvbl_uncol_comp_int -- 应收未收复息
    ,non_acru_bal -- 非应计余额
    ,advc_flg -- 垫款标志
    ,happ_dt -- 垫款日期
    ,curr_bal -- 垫款余额
    ,comp_amt -- 代偿金额
    ,loan_grace_period -- 贷款宽限期天数
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_exp_dt -- 宽限到期日期
    ,grace_begin_dt -- 宽限起始日期
    ,ovdue_cnt -- 逾期次数
    ,fir_ovdue_dt -- 首次逾期日期
    ,conti_ovdue_dt -- 连续逾期日期
    ,ovdue_dt -- 逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,ovdue_bal -- 逾期本金
    ,pric_ovdue_days -- 本金逾期天数
    ,pric_ovdue_amt -- 本金逾期金额
    ,pric_ovdue_fst_dt -- 本金最早逾期日期
    ,int_ovdue_days -- 利息逾期天数
    ,int_ovdue_amt -- 利息逾期金额
    ,int_ovdue_fst_dt -- 利息最早逾期日期
    ,pnlt_flg -- 罚息标志
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,over_int_dt -- 欠息日期
    ,over_int_days -- 欠息天数
    ,recvbl_over_int -- 应收欠息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_uncol_pnlt -- 应收未收罚息
    ,comp_int_flg -- 复利标志
    ,coll_over_int -- 催收欠息
    ,coll_pnlt -- 催收罚息
    ,coll_acru_int -- 催收应计利息
    ,coll_acru_pnlt -- 催收应计罚息
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_flg -- 表外标志
    ,off_bs_over_int_bal -- 表外欠息余额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,accti_org_id -- 核算机构编号
    ,provi_resv_lmt -- 计提准备金额
    ,pre_loss_amt -- 预测损失金额
    ,move_remark -- 迁移备注
    ,refac_loan_idf_cd -- 支小再贷款标识代码
    ,spcl_refac_idf_cd -- 专项再贷款标识代码
    ,init_bus_id -- 原业务编号
    ,init_dubil_id -- 原始借据编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,old_cust_id -- 旧客户编号
    ,old_prod_id -- 旧产品编号
    ,next_int_set_dt -- 下一结息日期
    ,prob_asset_flg -- 问题资产标志
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,regroup_loan_flg -- 重组贷款标志
    ,regroup_dt -- 重组日期
    ,regroup_loan_type_cd -- 重组贷款类型代码
    ,stl_acct_open_bank_num -- 结算账户开户行号
    ,stl_acct_seq_num -- 结算账户序号
    ,bad_debt_wrt_off_status_cd -- 呆账核销状态代码
    ,wrt_off_dt -- 核销日期
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,wrt_off_callbk_amt -- 核销回收金额
    ,revs_flg -- 冲正标志
    ,termnt_dt -- 终止日期
    ,belong_strip_line_cd -- 所属条线代码
    ,risk_monit_rela_flow_num -- 风险监测关联流水号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,level11_cls_dt -- 十一级分类日期
    ,low_risk_flg -- 低风险标志
    ,level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,last_level10_cls_cd -- 上一十级分类代码
    ,last_level10_cls_dt -- 上一十级分类日期
    ,last_level5_cls_cd -- 上一五级分类代码
    ,last_level5_cls_cmplt_dt -- 上一五级分类完成日期
    ,last_term_level5_cls_modif_dt -- 上一期五级分类变更日期
    ,abs_flg -- 资产证券化标志
    ,cred_rht_advise_cfmed_flg -- 债权通知书已确认标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,prft_cut_amt -- 分润金额
    ,oper_dt -- 经办日期
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.rela_out_acct_flow_num, o.rela_out_acct_flow_num) as rela_out_acct_flow_num -- 关联出账流水号
    ,nvl(n.rela_cont_id, o.rela_cont_id) as rela_cont_id -- 关联合同编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.sub_prod_id, o.sub_prod_id) as sub_prod_id -- 子产品编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.loan_status_cd, o.loan_status_cd) as loan_status_cd -- 贷款状态代码
    ,nvl(n.loan_distr_type_cd, o.loan_distr_type_cd) as loan_distr_type_cd -- 贷款发放类型代码
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 发放日期
    ,nvl(n.enter_id, o.enter_id) as enter_id -- 卡号
    ,nvl(n.actl_amt, o.actl_amt) as actl_amt -- 实付金额
    ,nvl(n.dubil_status_cd, o.dubil_status_cd) as dubil_status_cd -- 借据状态代码
    ,nvl(n.dubil_amt, o.dubil_amt) as dubil_amt -- 借据金额
    ,nvl(n.loan_tot_perds, o.loan_tot_perds) as loan_tot_perds -- 贷款总期数
    ,nvl(n.surp_repay_perds, o.surp_repay_perds) as surp_repay_perds -- 剩余还款期数
    ,nvl(n.mon_tenor, o.mon_tenor) as mon_tenor -- 月期限
    ,nvl(n.day_tenor, o.day_tenor) as day_tenor -- 日期限
    ,nvl(n.apot_exp_dt, o.apot_exp_dt) as apot_exp_dt -- 约定到期日期
    ,nvl(n.actl_exp_dt, o.actl_exp_dt) as actl_exp_dt -- 实际到期日期
    ,nvl(n.int_rat_mode_cd, o.int_rat_mode_cd) as int_rat_mode_cd -- 利率模式代码
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.ncb_base_rat_type_cd, o.ncb_base_rat_type_cd) as ncb_base_rat_type_cd -- 核心基准利率类型代码
    ,nvl(n.int_rat_float_type_cd, o.int_rat_float_type_cd) as int_rat_float_type_cd -- 利率浮动类型代码
    ,nvl(n.exec_year_int_rat, o.exec_year_int_rat) as exec_year_int_rat -- 执行年利率
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_adj_ped_cd, o.int_rat_adj_ped_cd) as int_rat_adj_ped_cd -- 利率调整周期代码
    ,nvl(n.int_rat_float_range, o.int_rat_float_range) as int_rat_float_range -- 利率浮动幅度
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.int_rat_start_use_way_cd, o.int_rat_start_use_way_cd) as int_rat_start_use_way_cd -- 利率启用方式代码
    ,nvl(n.int_rat_modif_ped_cd, o.int_rat_modif_ped_cd) as int_rat_modif_ped_cd -- 利率变更周期代码
    ,nvl(n.float_point, o.float_point) as float_point -- 浮动百分点
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.guar_way_cd_two, o.guar_way_cd_two) as guar_way_cd_two -- 担保方式代码二
    ,nvl(n.guar_way_cd_three, o.guar_way_cd_three) as guar_way_cd_three -- 担保方式代码三
    ,nvl(n.margin_ratio, o.margin_ratio) as margin_ratio -- 保证金比例
    ,nvl(n.margin_amt, o.margin_amt) as margin_amt -- 保证金金额
    ,nvl(n.margin_acct_id, o.margin_acct_id) as margin_acct_id -- 保证金账户编号
    ,nvl(n.distr_mode_pay_cd, o.distr_mode_pay_cd) as distr_mode_pay_cd -- 放款支付方式代码
    ,nvl(n.distr_acct_id, o.distr_acct_id) as distr_acct_id -- 放款账户编号
    ,nvl(n.distr_acct_name, o.distr_acct_name) as distr_acct_name -- 放款账户名称
    ,nvl(n.enter_open_acct_org_id, o.enter_open_acct_org_id) as enter_open_acct_org_id -- 入账账户开户机构编号
    ,nvl(n.out_acct_org_id, o.out_acct_org_id) as out_acct_org_id -- 出账机构编号
    ,nvl(n.rela_pay_appl_form_id, o.rela_pay_appl_form_id) as rela_pay_appl_form_id -- 关联付款申请书编号
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.deflt_repay_day, o.deflt_repay_day) as deflt_repay_day -- 默认还款日
    ,nvl(n.repay_ped, o.repay_ped) as repay_ped -- 还款周期
    ,nvl(n.repay_ped_cd, o.repay_ped_cd) as repay_ped_cd -- 还款周期单位代码
    ,nvl(n.dep_lon_int_set_day, o.dep_lon_int_set_day) as dep_lon_int_set_day -- 存贷结息日
    ,nvl(n.renew_cnt, o.renew_cnt) as renew_cnt -- 展期次数
    ,nvl(n.repay_acct_id, o.repay_acct_id) as repay_acct_id -- 还款账户编号
    ,nvl(n.repay_acct_name, o.repay_acct_name) as repay_acct_name -- 还款账户名称
    ,nvl(n.repay_num_bal, o.repay_num_bal) as repay_num_bal -- 还款账号余额
    ,nvl(n.repay_num_aval_bal, o.repay_num_aval_bal) as repay_num_aval_bal -- 还款账户可用余额
    ,nvl(n.nomal_bal, o.nomal_bal) as nomal_bal -- 正常余额
    ,nvl(n.pric_bal, o.pric_bal) as pric_bal -- 本金余额
    ,nvl(n.int_bal, o.int_bal) as int_bal -- 利息余额
    ,nvl(n.ibank_sys_pric_bal, o.ibank_sys_pric_bal) as ibank_sys_pric_bal -- 同业系统本金余额
    ,nvl(n.comp_int_bal, o.comp_int_bal) as comp_int_bal -- 复息余额
    ,nvl(n.file_int_accr_flg, o.file_int_accr_flg) as file_int_accr_flg -- 靠档计息标志
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.acru_int, o.acru_int) as acru_int -- 应计利息
    ,nvl(n.acru_pnlt, o.acru_pnlt) as acru_pnlt -- 应计罚息
    ,nvl(n.acru_comp_int, o.acru_comp_int) as acru_comp_int -- 应计复息
    ,nvl(n.recvbl_uncol_comp_int, o.recvbl_uncol_comp_int) as recvbl_uncol_comp_int -- 应收未收复息
    ,nvl(n.non_acru_bal, o.non_acru_bal) as non_acru_bal -- 非应计余额
    ,nvl(n.advc_flg, o.advc_flg) as advc_flg -- 垫款标志
    ,nvl(n.happ_dt, o.happ_dt) as happ_dt -- 垫款日期
    ,nvl(n.curr_bal, o.curr_bal) as curr_bal -- 垫款余额
    ,nvl(n.comp_amt, o.comp_amt) as comp_amt -- 代偿金额
    ,nvl(n.loan_grace_period, o.loan_grace_period) as loan_grace_period -- 贷款宽限期天数
    ,nvl(n.grace_period_type_cd, o.grace_period_type_cd) as grace_period_type_cd -- 宽限期类型代码
    ,nvl(n.grace_exp_dt, o.grace_exp_dt) as grace_exp_dt -- 宽限到期日期
    ,nvl(n.grace_begin_dt, o.grace_begin_dt) as grace_begin_dt -- 宽限起始日期
    ,nvl(n.ovdue_cnt, o.ovdue_cnt) as ovdue_cnt -- 逾期次数
    ,nvl(n.fir_ovdue_dt, o.fir_ovdue_dt) as fir_ovdue_dt -- 首次逾期日期
    ,nvl(n.conti_ovdue_dt, o.conti_ovdue_dt) as conti_ovdue_dt -- 连续逾期日期
    ,nvl(n.ovdue_dt, o.ovdue_dt) as ovdue_dt -- 逾期日期
    ,nvl(n.loan_ovdue_days, o.loan_ovdue_days) as loan_ovdue_days -- 贷款逾期天数
    ,nvl(n.ovdue_bal, o.ovdue_bal) as ovdue_bal -- 逾期本金
    ,nvl(n.pric_ovdue_days, o.pric_ovdue_days) as pric_ovdue_days -- 本金逾期天数
    ,nvl(n.pric_ovdue_amt, o.pric_ovdue_amt) as pric_ovdue_amt -- 本金逾期金额
    ,nvl(n.pric_ovdue_fst_dt, o.pric_ovdue_fst_dt) as pric_ovdue_fst_dt -- 本金最早逾期日期
    ,nvl(n.int_ovdue_days, o.int_ovdue_days) as int_ovdue_days -- 利息逾期天数
    ,nvl(n.int_ovdue_amt, o.int_ovdue_amt) as int_ovdue_amt -- 利息逾期金额
    ,nvl(n.int_ovdue_fst_dt, o.int_ovdue_fst_dt) as int_ovdue_fst_dt -- 利息最早逾期日期
    ,nvl(n.pnlt_flg, o.pnlt_flg) as pnlt_flg -- 罚息标志
    ,nvl(n.ovdue_pnlt_bal, o.ovdue_pnlt_bal) as ovdue_pnlt_bal -- 逾期罚息余额
    ,nvl(n.ovdue_int_rat, o.ovdue_int_rat) as ovdue_int_rat -- 逾期利率
    ,nvl(n.ovdue_int_rat_float_way_cd, o.ovdue_int_rat_float_way_cd) as ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,nvl(n.ovdue_int_rat_flo_val, o.ovdue_int_rat_flo_val) as ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,nvl(n.over_int_dt, o.over_int_dt) as over_int_dt -- 欠息日期
    ,nvl(n.over_int_days, o.over_int_days) as over_int_days -- 欠息天数
    ,nvl(n.recvbl_over_int, o.recvbl_over_int) as recvbl_over_int -- 应收欠息
    ,nvl(n.recvbl_pnlt, o.recvbl_pnlt) as recvbl_pnlt -- 应收罚息
    ,nvl(n.recvbl_uncol_pnlt, o.recvbl_uncol_pnlt) as recvbl_uncol_pnlt -- 应收未收罚息
    ,nvl(n.comp_int_flg, o.comp_int_flg) as comp_int_flg -- 复利标志
    ,nvl(n.coll_over_int, o.coll_over_int) as coll_over_int -- 催收欠息
    ,nvl(n.coll_pnlt, o.coll_pnlt) as coll_pnlt -- 催收罚息
    ,nvl(n.coll_acru_int, o.coll_acru_int) as coll_acru_int -- 催收应计利息
    ,nvl(n.coll_acru_pnlt, o.coll_acru_pnlt) as coll_acru_pnlt -- 催收应计罚息
    ,nvl(n.acm_rtn_pric, o.acm_rtn_pric) as acm_rtn_pric -- 累计归还本金
    ,nvl(n.acm_rtn_int, o.acm_rtn_int) as acm_rtn_int -- 累计归还利息
    ,nvl(n.in_bs_over_int_bal, o.in_bs_over_int_bal) as in_bs_over_int_bal -- 表内欠息余额
    ,nvl(n.off_bs_flg, o.off_bs_flg) as off_bs_flg -- 表外标志
    ,nvl(n.off_bs_over_int_bal, o.off_bs_over_int_bal) as off_bs_over_int_bal -- 表外欠息余额
    ,nvl(n.idle_bal, o.idle_bal) as idle_bal -- 呆滞余额
    ,nvl(n.bad_debt_bal, o.bad_debt_bal) as bad_debt_bal -- 呆账余额
    ,nvl(n.accti_org_id, o.accti_org_id) as accti_org_id -- 核算机构编号
    ,nvl(n.provi_resv_lmt, o.provi_resv_lmt) as provi_resv_lmt -- 计提准备金额
    ,nvl(n.pre_loss_amt, o.pre_loss_amt) as pre_loss_amt -- 预测损失金额
    ,nvl(n.move_remark, o.move_remark) as move_remark -- 迁移备注
    ,nvl(n.refac_loan_idf_cd, o.refac_loan_idf_cd) as refac_loan_idf_cd -- 支小再贷款标识代码
    ,nvl(n.spcl_refac_idf_cd, o.spcl_refac_idf_cd) as spcl_refac_idf_cd -- 专项再贷款标识代码
    ,nvl(n.init_bus_id, o.init_bus_id) as init_bus_id -- 原业务编号
    ,nvl(n.init_dubil_id, o.init_dubil_id) as init_dubil_id -- 原始借据编号
    ,nvl(n.init_loan_exp_dt, o.init_loan_exp_dt) as init_loan_exp_dt -- 原贷款到期日期
    ,nvl(n.old_cust_id, o.old_cust_id) as old_cust_id -- 旧客户编号
    ,nvl(n.old_prod_id, o.old_prod_id) as old_prod_id -- 旧产品编号
    ,nvl(n.next_int_set_dt, o.next_int_set_dt) as next_int_set_dt -- 下一结息日期
    ,nvl(n.prob_asset_flg, o.prob_asset_flg) as prob_asset_flg -- 问题资产标志
    ,nvl(n.fir_idtfy_non_dt, o.fir_idtfy_non_dt) as fir_idtfy_non_dt -- 首次认定不良日期
    ,nvl(n.regroup_loan_flg, o.regroup_loan_flg) as regroup_loan_flg -- 重组贷款标志
    ,nvl(n.regroup_dt, o.regroup_dt) as regroup_dt -- 重组日期
    ,nvl(n.regroup_loan_type_cd, o.regroup_loan_type_cd) as regroup_loan_type_cd -- 重组贷款类型代码
    ,nvl(n.stl_acct_open_bank_num, o.stl_acct_open_bank_num) as stl_acct_open_bank_num -- 结算账户开户行号
    ,nvl(n.stl_acct_seq_num, o.stl_acct_seq_num) as stl_acct_seq_num -- 结算账户序号
    ,nvl(n.bad_debt_wrt_off_status_cd, o.bad_debt_wrt_off_status_cd) as bad_debt_wrt_off_status_cd -- 呆账核销状态代码
    ,nvl(n.wrt_off_dt, o.wrt_off_dt) as wrt_off_dt -- 核销日期
    ,nvl(n.wrt_off_pric, o.wrt_off_pric) as wrt_off_pric -- 核销本金
    ,nvl(n.wrt_off_int, o.wrt_off_int) as wrt_off_int -- 核销利息
    ,nvl(n.wrt_off_callbk_amt, o.wrt_off_callbk_amt) as wrt_off_callbk_amt -- 核销回收金额
    ,nvl(n.revs_flg, o.revs_flg) as revs_flg -- 冲正标志
    ,nvl(n.termnt_dt, o.termnt_dt) as termnt_dt -- 终止日期
    ,nvl(n.belong_strip_line_cd, o.belong_strip_line_cd) as belong_strip_line_cd -- 所属条线代码
    ,nvl(n.risk_monit_rela_flow_num, o.risk_monit_rela_flow_num) as risk_monit_rela_flow_num -- 风险监测关联流水号
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.level5_cls_cd, o.level5_cls_cd) as level5_cls_cd -- 五级分类代码
    ,nvl(n.level5_cls_dt, o.level5_cls_dt) as level5_cls_dt -- 五级分类日期
    ,nvl(n.level11_cls_cd, o.level11_cls_cd) as level11_cls_cd -- 十一级分类代码
    ,nvl(n.level11_cls_dt, o.level11_cls_dt) as level11_cls_dt -- 十一级分类日期
    ,nvl(n.low_risk_flg, o.low_risk_flg) as low_risk_flg -- 低风险标志
    ,nvl(n.level10_cls_manu_med_flg, o.level10_cls_manu_med_flg) as level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,nvl(n.last_level10_cls_cd, o.last_level10_cls_cd) as last_level10_cls_cd -- 上一十级分类代码
    ,nvl(n.last_level10_cls_dt, o.last_level10_cls_dt) as last_level10_cls_dt -- 上一十级分类日期
    ,nvl(n.last_level5_cls_cd, o.last_level5_cls_cd) as last_level5_cls_cd -- 上一五级分类代码
    ,nvl(n.last_level5_cls_cmplt_dt, o.last_level5_cls_cmplt_dt) as last_level5_cls_cmplt_dt -- 上一五级分类完成日期
    ,nvl(n.last_term_level5_cls_modif_dt, o.last_term_level5_cls_modif_dt) as last_term_level5_cls_modif_dt -- 上一期五级分类变更日期
    ,nvl(n.abs_flg, o.abs_flg) as abs_flg -- 资产证券化标志
    ,nvl(n.cred_rht_advise_cfmed_flg, o.cred_rht_advise_cfmed_flg) as cred_rht_advise_cfmed_flg -- 债权通知书已确认标志
    ,nvl(n.provi_for_aged_property_flg, o.provi_for_aged_property_flg) as provi_for_aged_property_flg -- 养老产业标志
    ,nvl(n.prft_cut_amt, o.prft_cut_amt) as prft_cut_amt -- 分润金额
    ,nvl(n.oper_dt, o.oper_dt) as oper_dt -- 经办日期
    ,nvl(n.bus_oper_teller_id, o.bus_oper_teller_id) as bus_oper_teller_id -- 业务经办人编号
    ,nvl(n.oper_org_id, o.oper_org_id) as oper_org_id -- 经办机构编号
    ,nvl(n.rgst_teller_id, o.rgst_teller_id) as rgst_teller_id -- 登记柜员编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.update_teller_id, o.update_teller_id) as update_teller_id -- 更新柜员编号
    ,nvl(n.update_org_id, o.update_org_id) as update_org_id -- 更新机构编号
    ,nvl(n.modif_dt, o.modif_dt) as modif_dt -- 变更日期
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.dubil_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_dubil_info_h_icmsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_dubil_info_h_icmsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.dubil_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.dubil_id is null
    )
    or (
        o.rela_out_acct_flow_num <> n.rela_out_acct_flow_num
        or o.rela_cont_id <> n.rela_cont_id
        or o.cust_id <> n.cust_id
        or o.cust_name <> n.cust_name
        or o.prod_id <> n.prod_id
        or o.sub_prod_id <> n.sub_prod_id
        or o.curr_cd <> n.curr_cd
        or o.loan_status_cd <> n.loan_status_cd
        or o.loan_distr_type_cd <> n.loan_distr_type_cd
        or o.distr_dt <> n.distr_dt
        or o.enter_id <> n.enter_id
        or o.actl_amt <> n.actl_amt
        or o.dubil_status_cd <> n.dubil_status_cd
        or o.dubil_amt <> n.dubil_amt
        or o.loan_tot_perds <> n.loan_tot_perds
        or o.surp_repay_perds <> n.surp_repay_perds
        or o.mon_tenor <> n.mon_tenor
        or o.day_tenor <> n.day_tenor
        or o.apot_exp_dt <> n.apot_exp_dt
        or o.actl_exp_dt <> n.actl_exp_dt
        or o.int_rat_mode_cd <> n.int_rat_mode_cd
        or o.base_rat_type_cd <> n.base_rat_type_cd
        or o.base_rat <> n.base_rat
        or o.ncb_base_rat_type_cd <> n.ncb_base_rat_type_cd
        or o.int_rat_float_type_cd <> n.int_rat_float_type_cd
        or o.exec_year_int_rat <> n.exec_year_int_rat
        or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
        or o.int_rat_adj_ped_cd <> n.int_rat_adj_ped_cd
        or o.int_rat_float_range <> n.int_rat_float_range
        or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
        or o.int_rat_start_use_way_cd <> n.int_rat_start_use_way_cd
        or o.int_rat_modif_ped_cd <> n.int_rat_modif_ped_cd
        or o.float_point <> n.float_point
        or o.main_guar_way_cd <> n.main_guar_way_cd
        or o.guar_way_cd_two <> n.guar_way_cd_two
        or o.guar_way_cd_three <> n.guar_way_cd_three
        or o.margin_ratio <> n.margin_ratio
        or o.margin_amt <> n.margin_amt
        or o.margin_acct_id <> n.margin_acct_id
        or o.distr_mode_pay_cd <> n.distr_mode_pay_cd
        or o.distr_acct_id <> n.distr_acct_id
        or o.distr_acct_name <> n.distr_acct_name
        or o.enter_open_acct_org_id <> n.enter_open_acct_org_id
        or o.out_acct_org_id <> n.out_acct_org_id
        or o.rela_pay_appl_form_id <> n.rela_pay_appl_form_id
        or o.repay_way_cd <> n.repay_way_cd
        or o.deflt_repay_day <> n.deflt_repay_day
        or o.repay_ped <> n.repay_ped
        or o.repay_ped_cd <> n.repay_ped_cd
        or o.dep_lon_int_set_day <> n.dep_lon_int_set_day
        or o.renew_cnt <> n.renew_cnt
        or o.repay_acct_id <> n.repay_acct_id
        or o.repay_acct_name <> n.repay_acct_name
        or o.repay_num_bal <> n.repay_num_bal
        or o.repay_num_aval_bal <> n.repay_num_aval_bal
        or o.nomal_bal <> n.nomal_bal
        or o.pric_bal <> n.pric_bal
        or o.int_bal <> n.int_bal
        or o.ibank_sys_pric_bal <> n.ibank_sys_pric_bal
        or o.comp_int_bal <> n.comp_int_bal
        or o.file_int_accr_flg <> n.file_int_accr_flg
        or o.int_accr_flg <> n.int_accr_flg
        or o.acru_int <> n.acru_int
        or o.acru_pnlt <> n.acru_pnlt
        or o.acru_comp_int <> n.acru_comp_int
        or o.recvbl_uncol_comp_int <> n.recvbl_uncol_comp_int
        or o.non_acru_bal <> n.non_acru_bal
        or o.advc_flg <> n.advc_flg
        or o.happ_dt <> n.happ_dt
        or o.curr_bal <> n.curr_bal
        or o.comp_amt <> n.comp_amt
        or o.loan_grace_period <> n.loan_grace_period
        or o.grace_period_type_cd <> n.grace_period_type_cd
        or o.grace_exp_dt <> n.grace_exp_dt
        or o.grace_begin_dt <> n.grace_begin_dt
        or o.ovdue_cnt <> n.ovdue_cnt
        or o.fir_ovdue_dt <> n.fir_ovdue_dt
        or o.conti_ovdue_dt <> n.conti_ovdue_dt
        or o.ovdue_dt <> n.ovdue_dt
        or o.loan_ovdue_days <> n.loan_ovdue_days
        or o.ovdue_bal <> n.ovdue_bal
        or o.pric_ovdue_days <> n.pric_ovdue_days
        or o.pric_ovdue_amt <> n.pric_ovdue_amt
        or o.pric_ovdue_fst_dt <> n.pric_ovdue_fst_dt
        or o.int_ovdue_days <> n.int_ovdue_days
        or o.int_ovdue_amt <> n.int_ovdue_amt
        or o.int_ovdue_fst_dt <> n.int_ovdue_fst_dt
        or o.pnlt_flg <> n.pnlt_flg
        or o.ovdue_pnlt_bal <> n.ovdue_pnlt_bal
        or o.ovdue_int_rat <> n.ovdue_int_rat
        or o.ovdue_int_rat_float_way_cd <> n.ovdue_int_rat_float_way_cd
        or o.ovdue_int_rat_flo_val <> n.ovdue_int_rat_flo_val
        or o.over_int_dt <> n.over_int_dt
        or o.over_int_days <> n.over_int_days
        or o.recvbl_over_int <> n.recvbl_over_int
        or o.recvbl_pnlt <> n.recvbl_pnlt
        or o.recvbl_uncol_pnlt <> n.recvbl_uncol_pnlt
        or o.comp_int_flg <> n.comp_int_flg
        or o.coll_over_int <> n.coll_over_int
        or o.coll_pnlt <> n.coll_pnlt
        or o.coll_acru_int <> n.coll_acru_int
        or o.coll_acru_pnlt <> n.coll_acru_pnlt
        or o.acm_rtn_pric <> n.acm_rtn_pric
        or o.acm_rtn_int <> n.acm_rtn_int
        or o.in_bs_over_int_bal <> n.in_bs_over_int_bal
        or o.off_bs_flg <> n.off_bs_flg
        or o.off_bs_over_int_bal <> n.off_bs_over_int_bal
        or o.idle_bal <> n.idle_bal
        or o.bad_debt_bal <> n.bad_debt_bal
        or o.accti_org_id <> n.accti_org_id
        or o.provi_resv_lmt <> n.provi_resv_lmt
        or o.pre_loss_amt <> n.pre_loss_amt
        or o.move_remark <> n.move_remark
        or o.refac_loan_idf_cd <> n.refac_loan_idf_cd
        or o.spcl_refac_idf_cd <> n.spcl_refac_idf_cd
        or o.init_bus_id <> n.init_bus_id
        or o.init_dubil_id <> n.init_dubil_id
        or o.init_loan_exp_dt <> n.init_loan_exp_dt
        or o.old_cust_id <> n.old_cust_id
        or o.old_prod_id <> n.old_prod_id
        or o.next_int_set_dt <> n.next_int_set_dt
        or o.prob_asset_flg <> n.prob_asset_flg
        or o.fir_idtfy_non_dt <> n.fir_idtfy_non_dt
        or o.regroup_loan_flg <> n.regroup_loan_flg
        or o.regroup_dt <> n.regroup_dt
        or o.regroup_loan_type_cd <> n.regroup_loan_type_cd
        or o.stl_acct_open_bank_num <> n.stl_acct_open_bank_num
        or o.stl_acct_seq_num <> n.stl_acct_seq_num
        or o.bad_debt_wrt_off_status_cd <> n.bad_debt_wrt_off_status_cd
        or o.wrt_off_dt <> n.wrt_off_dt
        or o.wrt_off_pric <> n.wrt_off_pric
        or o.wrt_off_int <> n.wrt_off_int
        or o.wrt_off_callbk_amt <> n.wrt_off_callbk_amt
        or o.revs_flg <> n.revs_flg
        or o.termnt_dt <> n.termnt_dt
        or o.belong_strip_line_cd <> n.belong_strip_line_cd
        or o.risk_monit_rela_flow_num <> n.risk_monit_rela_flow_num
        or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
        or o.level5_cls_cd <> n.level5_cls_cd
        or o.level5_cls_dt <> n.level5_cls_dt
        or o.level11_cls_cd <> n.level11_cls_cd
        or o.level11_cls_dt <> n.level11_cls_dt
        or o.low_risk_flg <> n.low_risk_flg
        or o.level10_cls_manu_med_flg <> n.level10_cls_manu_med_flg
        or o.last_level10_cls_cd <> n.last_level10_cls_cd
        or o.last_level10_cls_dt <> n.last_level10_cls_dt
        or o.last_level5_cls_cd <> n.last_level5_cls_cd
        or o.last_level5_cls_cmplt_dt <> n.last_level5_cls_cmplt_dt
        or o.last_term_level5_cls_modif_dt <> n.last_term_level5_cls_modif_dt
        or o.abs_flg <> n.abs_flg
        or o.cred_rht_advise_cfmed_flg <> n.cred_rht_advise_cfmed_flg
        or o.provi_for_aged_property_flg <> n.provi_for_aged_property_flg
        or o.prft_cut_amt <> n.prft_cut_amt
        or o.oper_dt <> n.oper_dt
        or o.bus_oper_teller_id <> n.bus_oper_teller_id
        or o.oper_org_id <> n.oper_org_id
        or o.rgst_teller_id <> n.rgst_teller_id
        or o.rgst_org_id <> n.rgst_org_id
        or o.rgst_dt <> n.rgst_dt
        or o.update_teller_id <> n.update_teller_id
        or o.update_org_id <> n.update_org_id
        or o.modif_dt <> n.modif_dt
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_dubil_info_h_icmsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,rela_out_acct_flow_num -- 关联出账流水号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sub_prod_id -- 子产品编号
    ,curr_cd -- 币种代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_dt -- 发放日期
    ,enter_id -- 卡号
    ,actl_amt -- 实付金额
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,loan_tot_perds -- 贷款总期数
    ,surp_repay_perds -- 剩余还款期数
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,apot_exp_dt -- 约定到期日期
    ,actl_exp_dt -- 实际到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,ncb_base_rat_type_cd -- 核心基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,exec_year_int_rat -- 执行年利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_range -- 利率浮动幅度
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,float_point -- 浮动百分点
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,margin_acct_id -- 保证金账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_acct_id -- 放款账户编号
    ,distr_acct_name -- 放款账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,out_acct_org_id -- 出账机构编号
    ,rela_pay_appl_form_id -- 关联付款申请书编号
    ,repay_way_cd -- 还款方式代码
    ,deflt_repay_day -- 默认还款日
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,dep_lon_int_set_day -- 存贷结息日
    ,renew_cnt -- 展期次数
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,repay_num_bal -- 还款账号余额
    ,repay_num_aval_bal -- 还款账户可用余额
    ,nomal_bal -- 正常余额
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,ibank_sys_pric_bal -- 同业系统本金余额
    ,comp_int_bal -- 复息余额
    ,file_int_accr_flg -- 靠档计息标志
    ,int_accr_flg -- 计息标志
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复息
    ,recvbl_uncol_comp_int -- 应收未收复息
    ,non_acru_bal -- 非应计余额
    ,advc_flg -- 垫款标志
    ,happ_dt -- 垫款日期
    ,curr_bal -- 垫款余额
    ,comp_amt -- 代偿金额
    ,loan_grace_period -- 贷款宽限期天数
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_exp_dt -- 宽限到期日期
    ,grace_begin_dt -- 宽限起始日期
    ,ovdue_cnt -- 逾期次数
    ,fir_ovdue_dt -- 首次逾期日期
    ,conti_ovdue_dt -- 连续逾期日期
    ,ovdue_dt -- 逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,ovdue_bal -- 逾期本金
    ,pric_ovdue_days -- 本金逾期天数
    ,pric_ovdue_amt -- 本金逾期金额
    ,pric_ovdue_fst_dt -- 本金最早逾期日期
    ,int_ovdue_days -- 利息逾期天数
    ,int_ovdue_amt -- 利息逾期金额
    ,int_ovdue_fst_dt -- 利息最早逾期日期
    ,pnlt_flg -- 罚息标志
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,over_int_dt -- 欠息日期
    ,over_int_days -- 欠息天数
    ,recvbl_over_int -- 应收欠息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_uncol_pnlt -- 应收未收罚息
    ,comp_int_flg -- 复利标志
    ,coll_over_int -- 催收欠息
    ,coll_pnlt -- 催收罚息
    ,coll_acru_int -- 催收应计利息
    ,coll_acru_pnlt -- 催收应计罚息
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_flg -- 表外标志
    ,off_bs_over_int_bal -- 表外欠息余额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,accti_org_id -- 核算机构编号
    ,provi_resv_lmt -- 计提准备金额
    ,pre_loss_amt -- 预测损失金额
    ,move_remark -- 迁移备注
    ,refac_loan_idf_cd -- 支小再贷款标识代码
    ,spcl_refac_idf_cd -- 专项再贷款标识代码
    ,init_bus_id -- 原业务编号
    ,init_dubil_id -- 原始借据编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,old_cust_id -- 旧客户编号
    ,old_prod_id -- 旧产品编号
    ,next_int_set_dt -- 下一结息日期
    ,prob_asset_flg -- 问题资产标志
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,regroup_loan_flg -- 重组贷款标志
    ,regroup_dt -- 重组日期
    ,regroup_loan_type_cd -- 重组贷款类型代码
    ,stl_acct_open_bank_num -- 结算账户开户行号
    ,stl_acct_seq_num -- 结算账户序号
    ,bad_debt_wrt_off_status_cd -- 呆账核销状态代码
    ,wrt_off_dt -- 核销日期
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,wrt_off_callbk_amt -- 核销回收金额
    ,revs_flg -- 冲正标志
    ,termnt_dt -- 终止日期
    ,belong_strip_line_cd -- 所属条线代码
    ,risk_monit_rela_flow_num -- 风险监测关联流水号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,level11_cls_dt -- 十一级分类日期
    ,low_risk_flg -- 低风险标志
    ,level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,last_level10_cls_cd -- 上一十级分类代码
    ,last_level10_cls_dt -- 上一十级分类日期
    ,last_level5_cls_cd -- 上一五级分类代码
    ,last_level5_cls_cmplt_dt -- 上一五级分类完成日期
    ,last_term_level5_cls_modif_dt -- 上一期五级分类变更日期
    ,abs_flg -- 资产证券化标志
    ,cred_rht_advise_cfmed_flg -- 债权通知书已确认标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,prft_cut_amt -- 分润金额
    ,oper_dt -- 经办日期
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_dubil_info_h_icmsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,rela_out_acct_flow_num -- 关联出账流水号
    ,rela_cont_id -- 关联合同编号
    ,cust_id -- 客户编号
    ,cust_name -- 客户名称
    ,prod_id -- 产品编号
    ,sub_prod_id -- 子产品编号
    ,curr_cd -- 币种代码
    ,loan_status_cd -- 贷款状态代码
    ,loan_distr_type_cd -- 贷款发放类型代码
    ,distr_dt -- 发放日期
    ,enter_id -- 卡号
    ,actl_amt -- 实付金额
    ,dubil_status_cd -- 借据状态代码
    ,dubil_amt -- 借据金额
    ,loan_tot_perds -- 贷款总期数
    ,surp_repay_perds -- 剩余还款期数
    ,mon_tenor -- 月期限
    ,day_tenor -- 日期限
    ,apot_exp_dt -- 约定到期日期
    ,actl_exp_dt -- 实际到期日期
    ,int_rat_mode_cd -- 利率模式代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,base_rat -- 基准利率
    ,ncb_base_rat_type_cd -- 核心基准利率类型代码
    ,int_rat_float_type_cd -- 利率浮动类型代码
    ,exec_year_int_rat -- 执行年利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_cd -- 利率调整周期代码
    ,int_rat_float_range -- 利率浮动幅度
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,int_rat_start_use_way_cd -- 利率启用方式代码
    ,int_rat_modif_ped_cd -- 利率变更周期代码
    ,float_point -- 浮动百分点
    ,main_guar_way_cd -- 主担保方式代码
    ,guar_way_cd_two -- 担保方式代码二
    ,guar_way_cd_three -- 担保方式代码三
    ,margin_ratio -- 保证金比例
    ,margin_amt -- 保证金金额
    ,margin_acct_id -- 保证金账户编号
    ,distr_mode_pay_cd -- 放款支付方式代码
    ,distr_acct_id -- 放款账户编号
    ,distr_acct_name -- 放款账户名称
    ,enter_open_acct_org_id -- 入账账户开户机构编号
    ,out_acct_org_id -- 出账机构编号
    ,rela_pay_appl_form_id -- 关联付款申请书编号
    ,repay_way_cd -- 还款方式代码
    ,deflt_repay_day -- 默认还款日
    ,repay_ped -- 还款周期
    ,repay_ped_cd -- 还款周期单位代码
    ,dep_lon_int_set_day -- 存贷结息日
    ,renew_cnt -- 展期次数
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,repay_num_bal -- 还款账号余额
    ,repay_num_aval_bal -- 还款账户可用余额
    ,nomal_bal -- 正常余额
    ,pric_bal -- 本金余额
    ,int_bal -- 利息余额
    ,ibank_sys_pric_bal -- 同业系统本金余额
    ,comp_int_bal -- 复息余额
    ,file_int_accr_flg -- 靠档计息标志
    ,int_accr_flg -- 计息标志
    ,acru_int -- 应计利息
    ,acru_pnlt -- 应计罚息
    ,acru_comp_int -- 应计复息
    ,recvbl_uncol_comp_int -- 应收未收复息
    ,non_acru_bal -- 非应计余额
    ,advc_flg -- 垫款标志
    ,happ_dt -- 垫款日期
    ,curr_bal -- 垫款余额
    ,comp_amt -- 代偿金额
    ,loan_grace_period -- 贷款宽限期天数
    ,grace_period_type_cd -- 宽限期类型代码
    ,grace_exp_dt -- 宽限到期日期
    ,grace_begin_dt -- 宽限起始日期
    ,ovdue_cnt -- 逾期次数
    ,fir_ovdue_dt -- 首次逾期日期
    ,conti_ovdue_dt -- 连续逾期日期
    ,ovdue_dt -- 逾期日期
    ,loan_ovdue_days -- 贷款逾期天数
    ,ovdue_bal -- 逾期本金
    ,pric_ovdue_days -- 本金逾期天数
    ,pric_ovdue_amt -- 本金逾期金额
    ,pric_ovdue_fst_dt -- 本金最早逾期日期
    ,int_ovdue_days -- 利息逾期天数
    ,int_ovdue_amt -- 利息逾期金额
    ,int_ovdue_fst_dt -- 利息最早逾期日期
    ,pnlt_flg -- 罚息标志
    ,ovdue_pnlt_bal -- 逾期罚息余额
    ,ovdue_int_rat -- 逾期利率
    ,ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,over_int_dt -- 欠息日期
    ,over_int_days -- 欠息天数
    ,recvbl_over_int -- 应收欠息
    ,recvbl_pnlt -- 应收罚息
    ,recvbl_uncol_pnlt -- 应收未收罚息
    ,comp_int_flg -- 复利标志
    ,coll_over_int -- 催收欠息
    ,coll_pnlt -- 催收罚息
    ,coll_acru_int -- 催收应计利息
    ,coll_acru_pnlt -- 催收应计罚息
    ,acm_rtn_pric -- 累计归还本金
    ,acm_rtn_int -- 累计归还利息
    ,in_bs_over_int_bal -- 表内欠息余额
    ,off_bs_flg -- 表外标志
    ,off_bs_over_int_bal -- 表外欠息余额
    ,idle_bal -- 呆滞余额
    ,bad_debt_bal -- 呆账余额
    ,accti_org_id -- 核算机构编号
    ,provi_resv_lmt -- 计提准备金额
    ,pre_loss_amt -- 预测损失金额
    ,move_remark -- 迁移备注
    ,refac_loan_idf_cd -- 支小再贷款标识代码
    ,spcl_refac_idf_cd -- 专项再贷款标识代码
    ,init_bus_id -- 原业务编号
    ,init_dubil_id -- 原始借据编号
    ,init_loan_exp_dt -- 原贷款到期日期
    ,old_cust_id -- 旧客户编号
    ,old_prod_id -- 旧产品编号
    ,next_int_set_dt -- 下一结息日期
    ,prob_asset_flg -- 问题资产标志
    ,fir_idtfy_non_dt -- 首次认定不良日期
    ,regroup_loan_flg -- 重组贷款标志
    ,regroup_dt -- 重组日期
    ,regroup_loan_type_cd -- 重组贷款类型代码
    ,stl_acct_open_bank_num -- 结算账户开户行号
    ,stl_acct_seq_num -- 结算账户序号
    ,bad_debt_wrt_off_status_cd -- 呆账核销状态代码
    ,wrt_off_dt -- 核销日期
    ,wrt_off_pric -- 核销本金
    ,wrt_off_int -- 核销利息
    ,wrt_off_callbk_amt -- 核销回收金额
    ,revs_flg -- 冲正标志
    ,termnt_dt -- 终止日期
    ,belong_strip_line_cd -- 所属条线代码
    ,risk_monit_rela_flow_num -- 风险监测关联流水号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,level5_cls_cd -- 五级分类代码
    ,level5_cls_dt -- 五级分类日期
    ,level11_cls_cd -- 十一级分类代码
    ,level11_cls_dt -- 十一级分类日期
    ,low_risk_flg -- 低风险标志
    ,level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,last_level10_cls_cd -- 上一十级分类代码
    ,last_level10_cls_dt -- 上一十级分类日期
    ,last_level5_cls_cd -- 上一五级分类代码
    ,last_level5_cls_cmplt_dt -- 上一五级分类完成日期
    ,last_term_level5_cls_modif_dt -- 上一期五级分类变更日期
    ,abs_flg -- 资产证券化标志
    ,cred_rht_advise_cfmed_flg -- 债权通知书已确认标志
    ,provi_for_aged_property_flg -- 养老产业标志
    ,prft_cut_amt -- 分润金额
    ,oper_dt -- 经办日期
    ,bus_oper_teller_id -- 业务经办人编号
    ,oper_org_id -- 经办机构编号
    ,rgst_teller_id -- 登记柜员编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_dt -- 登记日期
    ,update_teller_id -- 更新柜员编号
    ,update_org_id -- 更新机构编号
    ,modif_dt -- 变更日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.agt_id -- 协议编号
    ,o.lp_id -- 法人编号
    ,o.dubil_id -- 借据编号
    ,o.rela_out_acct_flow_num -- 关联出账流水号
    ,o.rela_cont_id -- 关联合同编号
    ,o.cust_id -- 客户编号
    ,o.cust_name -- 客户名称
    ,o.prod_id -- 产品编号
    ,o.sub_prod_id -- 子产品编号
    ,o.curr_cd -- 币种代码
    ,o.loan_status_cd -- 贷款状态代码
    ,o.loan_distr_type_cd -- 贷款发放类型代码
    ,o.distr_dt -- 发放日期
    ,o.enter_id -- 卡号
    ,o.actl_amt -- 实付金额
    ,o.dubil_status_cd -- 借据状态代码
    ,o.dubil_amt -- 借据金额
    ,o.loan_tot_perds -- 贷款总期数
    ,o.surp_repay_perds -- 剩余还款期数
    ,o.mon_tenor -- 月期限
    ,o.day_tenor -- 日期限
    ,o.apot_exp_dt -- 约定到期日期
    ,o.actl_exp_dt -- 实际到期日期
    ,o.int_rat_mode_cd -- 利率模式代码
    ,o.base_rat_type_cd -- 基准利率类型代码
    ,o.base_rat -- 基准利率
    ,o.ncb_base_rat_type_cd -- 核心基准利率类型代码
    ,o.int_rat_float_type_cd -- 利率浮动类型代码
    ,o.exec_year_int_rat -- 执行年利率
    ,o.int_rat_adj_way_cd -- 利率调整方式代码
    ,o.int_rat_adj_ped_cd -- 利率调整周期代码
    ,o.int_rat_float_range -- 利率浮动幅度
    ,o.int_rat_float_way_cd -- 利率浮动方式代码
    ,o.int_rat_start_use_way_cd -- 利率启用方式代码
    ,o.int_rat_modif_ped_cd -- 利率变更周期代码
    ,o.float_point -- 浮动百分点
    ,o.main_guar_way_cd -- 主担保方式代码
    ,o.guar_way_cd_two -- 担保方式代码二
    ,o.guar_way_cd_three -- 担保方式代码三
    ,o.margin_ratio -- 保证金比例
    ,o.margin_amt -- 保证金金额
    ,o.margin_acct_id -- 保证金账户编号
    ,o.distr_mode_pay_cd -- 放款支付方式代码
    ,o.distr_acct_id -- 放款账户编号
    ,o.distr_acct_name -- 放款账户名称
    ,o.enter_open_acct_org_id -- 入账账户开户机构编号
    ,o.out_acct_org_id -- 出账机构编号
    ,o.rela_pay_appl_form_id -- 关联付款申请书编号
    ,o.repay_way_cd -- 还款方式代码
    ,o.deflt_repay_day -- 默认还款日
    ,o.repay_ped -- 还款周期
    ,o.repay_ped_cd -- 还款周期单位代码
    ,o.dep_lon_int_set_day -- 存贷结息日
    ,o.renew_cnt -- 展期次数
    ,o.repay_acct_id -- 还款账户编号
    ,o.repay_acct_name -- 还款账户名称
    ,o.repay_num_bal -- 还款账号余额
    ,o.repay_num_aval_bal -- 还款账户可用余额
    ,o.nomal_bal -- 正常余额
    ,o.pric_bal -- 本金余额
    ,o.int_bal -- 利息余额
    ,o.ibank_sys_pric_bal -- 同业系统本金余额
    ,o.comp_int_bal -- 复息余额
    ,o.file_int_accr_flg -- 靠档计息标志
    ,o.int_accr_flg -- 计息标志
    ,o.acru_int -- 应计利息
    ,o.acru_pnlt -- 应计罚息
    ,o.acru_comp_int -- 应计复息
    ,o.recvbl_uncol_comp_int -- 应收未收复息
    ,o.non_acru_bal -- 非应计余额
    ,o.advc_flg -- 垫款标志
    ,o.happ_dt -- 垫款日期
    ,o.curr_bal -- 垫款余额
    ,o.comp_amt -- 代偿金额
    ,o.loan_grace_period -- 贷款宽限期天数
    ,o.grace_period_type_cd -- 宽限期类型代码
    ,o.grace_exp_dt -- 宽限到期日期
    ,o.grace_begin_dt -- 宽限起始日期
    ,o.ovdue_cnt -- 逾期次数
    ,o.fir_ovdue_dt -- 首次逾期日期
    ,o.conti_ovdue_dt -- 连续逾期日期
    ,o.ovdue_dt -- 逾期日期
    ,o.loan_ovdue_days -- 贷款逾期天数
    ,o.ovdue_bal -- 逾期本金
    ,o.pric_ovdue_days -- 本金逾期天数
    ,o.pric_ovdue_amt -- 本金逾期金额
    ,o.pric_ovdue_fst_dt -- 本金最早逾期日期
    ,o.int_ovdue_days -- 利息逾期天数
    ,o.int_ovdue_amt -- 利息逾期金额
    ,o.int_ovdue_fst_dt -- 利息最早逾期日期
    ,o.pnlt_flg -- 罚息标志
    ,o.ovdue_pnlt_bal -- 逾期罚息余额
    ,o.ovdue_int_rat -- 逾期利率
    ,o.ovdue_int_rat_float_way_cd -- 逾期利率浮动方式代码
    ,o.ovdue_int_rat_flo_val -- 逾期利率浮动值
    ,o.over_int_dt -- 欠息日期
    ,o.over_int_days -- 欠息天数
    ,o.recvbl_over_int -- 应收欠息
    ,o.recvbl_pnlt -- 应收罚息
    ,o.recvbl_uncol_pnlt -- 应收未收罚息
    ,o.comp_int_flg -- 复利标志
    ,o.coll_over_int -- 催收欠息
    ,o.coll_pnlt -- 催收罚息
    ,o.coll_acru_int -- 催收应计利息
    ,o.coll_acru_pnlt -- 催收应计罚息
    ,o.acm_rtn_pric -- 累计归还本金
    ,o.acm_rtn_int -- 累计归还利息
    ,o.in_bs_over_int_bal -- 表内欠息余额
    ,o.off_bs_flg -- 表外标志
    ,o.off_bs_over_int_bal -- 表外欠息余额
    ,o.idle_bal -- 呆滞余额
    ,o.bad_debt_bal -- 呆账余额
    ,o.accti_org_id -- 核算机构编号
    ,o.provi_resv_lmt -- 计提准备金额
    ,o.pre_loss_amt -- 预测损失金额
    ,o.move_remark -- 迁移备注
    ,o.refac_loan_idf_cd -- 支小再贷款标识代码
    ,o.spcl_refac_idf_cd -- 专项再贷款标识代码
    ,o.init_bus_id -- 原业务编号
    ,o.init_dubil_id -- 原始借据编号
    ,o.init_loan_exp_dt -- 原贷款到期日期
    ,o.old_cust_id -- 旧客户编号
    ,o.old_prod_id -- 旧产品编号
    ,o.next_int_set_dt -- 下一结息日期
    ,o.prob_asset_flg -- 问题资产标志
    ,o.fir_idtfy_non_dt -- 首次认定不良日期
    ,o.regroup_loan_flg -- 重组贷款标志
    ,o.regroup_dt -- 重组日期
    ,o.regroup_loan_type_cd -- 重组贷款类型代码
    ,o.stl_acct_open_bank_num -- 结算账户开户行号
    ,o.stl_acct_seq_num -- 结算账户序号
    ,o.bad_debt_wrt_off_status_cd -- 呆账核销状态代码
    ,o.wrt_off_dt -- 核销日期
    ,o.wrt_off_pric -- 核销本金
    ,o.wrt_off_int -- 核销利息
    ,o.wrt_off_callbk_amt -- 核销回收金额
    ,o.revs_flg -- 冲正标志
    ,o.termnt_dt -- 终止日期
    ,o.belong_strip_line_cd -- 所属条线代码
    ,o.risk_monit_rela_flow_num -- 风险监测关联流水号
    ,o.asset_thd_cls_cd -- 资产三分类代码
    ,o.level5_cls_cd -- 五级分类代码
    ,o.level5_cls_dt -- 五级分类日期
    ,o.level11_cls_cd -- 十一级分类代码
    ,o.level11_cls_dt -- 十一级分类日期
    ,o.low_risk_flg -- 低风险标志
    ,o.level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,o.last_level10_cls_cd -- 上一十级分类代码
    ,o.last_level10_cls_dt -- 上一十级分类日期
    ,o.last_level5_cls_cd -- 上一五级分类代码
    ,o.last_level5_cls_cmplt_dt -- 上一五级分类完成日期
    ,o.last_term_level5_cls_modif_dt -- 上一期五级分类变更日期
    ,o.abs_flg -- 资产证券化标志
    ,o.cred_rht_advise_cfmed_flg -- 债权通知书已确认标志
    ,o.provi_for_aged_property_flg -- 养老产业标志
    ,o.prft_cut_amt -- 分润金额
    ,o.oper_dt -- 经办日期
    ,o.bus_oper_teller_id -- 业务经办人编号
    ,o.oper_org_id -- 经办机构编号
    ,o.rgst_teller_id -- 登记柜员编号
    ,o.rgst_org_id -- 登记机构编号
    ,o.rgst_dt -- 登记日期
    ,o.update_teller_id -- 更新柜员编号
    ,o.update_org_id -- 更新机构编号
    ,o.modif_dt -- 变更日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    , case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.src_table_name -- 源表名称
    ,o.job_cd -- 任务编码
    ,o.etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_dubil_info_h_icmsf1_bk o
    left join ${iml_schema}.agt_loan_dubil_info_h_icmsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.dubil_id = n.dubil_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_dubil_info_h_icmsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.dubil_id = d.dubil_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_dubil_info_h;
--alter table ${iml_schema}.agt_loan_dubil_info_h truncate partition for ('icmsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_dubil_info_h') 
               and substr(subpartition_name,1,8)=upper('p_icmsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_dubil_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_dubil_info_h modify partition p_icmsf1 
add subpartition p_icmsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_dubil_info_h exchange subpartition p_icmsf1_${batch_date} with table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_cl;
alter table ${iml_schema}.agt_loan_dubil_info_h exchange subpartition p_icmsf1_20991231 with table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_dubil_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_tm purge;
drop table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_op purge;
drop table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_dubil_info_h_icmsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_dubil_info_h', partname => 'p_icmsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
