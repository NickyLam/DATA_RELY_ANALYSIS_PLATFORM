/*
Purpose:    整合模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_loan_acct_info_h_ncbsf1
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
alter table ${iml_schema}.agt_loan_acct_info_h add partition p_ncbsf1 values ('ncbsf1')(
        subpartition p_ncbsf1_19000101 values (to_date('19000101','yyyymmdd'))
        ,subpartition p_ncbsf1_20991231 values (to_date('20991231','yyyymmdd'))
    )
;

-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_info_h partition for ('ncbsf1')
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')
;

-- 2.2 drop temp table
whenever sqlerror continue none ;
-- it is no need to check when this segment SQL was return faied
drop table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_cl purge;

-- 2.3 create temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_tm nologging
compress ${option_switch} for query high
as select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,dubil_id -- 借据编号
    ,distr_flow_num -- 放款流水号
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,open_acct_dt -- 开户日期
    ,effect_dt -- 生效日期
    ,fir_tran_dt -- 首次交易日期
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,init_open_acct_dt -- 原始开户日期
    ,init_exp_dt -- 原始到期日期
    ,cust_mgr_id -- 客户经理编号
    ,bal_type_cd -- 钞汇余额代码
    ,off_shore_flg -- 离岸标志
    ,ftz_flg -- 自贸区标志
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,exp_dt -- 到期日期
    ,appl_org_id -- 申请机构编号
    ,mgmt_org_id -- 管理机构编号
    ,cust_name -- 客户名称
    ,level5_cls_cd -- 五级分类代码
    ,loan_rs_cd -- 贷款原因代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,check_dt -- 复核日期
    ,repay_way_cd -- 还款方式代码
    ,sub_plan_way_cd -- 子计划方式代码
    ,open_acct_chn_id -- 开户渠道编号
    ,src_module_type_cd -- 源模块类型代码
    ,sob_cate_cd -- 账套类别代码
    ,indv_bus_flg -- 个体工商户标志
    ,int_accr_flg -- 计息标志
    ,curr_pd -- 当前期次
    ,final_tran_dt -- 最后交易日期
    ,anew_create_repay_plan_flg -- 重新生成还款计划标志
    ,init_prod_id -- 原产品编号
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,loan_auto_repay_type_cd -- 贷款自动还款类型代码
    ,loan_pric_repay_seq_num -- 贷款本金还款顺序号
    ,loan_int_repay_seq_num -- 贷款利息还款顺序号
    ,loan_pnlt_repay_seq_num -- 贷款罚息还款顺序号
    ,loan_comp_int_repay_seq_num -- 贷款复利还款顺序号
    ,loan_fee_repay_seq_num -- 贷款费用还款顺序号
    ,earliest_ovdue_dt -- 最早逾期日期
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,contri_ratio -- 出资比例
    ,init_loan_num -- 原贷款号
    ,init_distr_flow_num -- 原放款流水号
    ,int_sub_closing_dt -- 贴息截止日期
    ,chg_term_not_chg_lmt_final_chg_dt -- 变期不变额最后变化日期
    ,ftz_acct_flg -- 自贸区账户标志
    ,ftz_cd -- 自贸区代码
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,loan_usage_cd -- 贷款用途代码
    ,other_consm_descb -- 其他消费描述
    ,repay_plan_modif_way_cd -- 还款计划变更方式代码
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,wrt_off_post_auto_turn_money_flg -- 核销后自动转款标志
    ,clos_acct_teller_id -- 销户柜员编号
    ,check_teller_id -- 复核柜员编号
    ,open_acct_teller_id -- 开户柜员编号
    ,accrd_hours_int_rat -- 按小时利率
    ,cust_econ_type_cd -- 客户经济类型代码
    ,accrd_hours_file_flg_cd -- 按小时靠档标志代码
    ,check_entry_code -- 对账编码
    ,auto_comb_repay_flg -- 自动组合还款标志
    ,free_int_closing_dt -- 免息截止日期
    ,abs_flg -- 资产证券化标志
    ,auto_revs_flg -- 自动冲正标志
    ,flg_cd -- 资产转让标志
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,clos_acct_type_cd -- 销户类型代码
    ,loan_clos_acct_rs -- 贷款销户原因
    ,auto_payoff_flg -- 自动结清标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,init_bus_id -- 原业务编号
    ,bar_flg -- 随借随还标志
    ,file_int_accr_flg -- 靠档计息标志
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,ld_accti_status_cd -- 上日核算状态代码
    ,ld_acct_status_cd -- 上日账户状态代码
    ,late_merge_flg -- 末期合并标志
    ,refactor_flg -- 再保理标志
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_info_h partition for ('ncbsf1')
where 0=1
;

create table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_op nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_info_h partition for ('ncbsf1') where 0=1;

create table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_cl nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_loan_acct_info_h partition for ('ncbsf1') where 0=1;

-- 3.1 get new data into table
-- ncbs_cl_acct-1
insert into ${iml_schema}.agt_loan_acct_info_h_ncbsf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,dubil_id -- 借据编号
    ,distr_flow_num -- 放款流水号
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,open_acct_dt -- 开户日期
    ,effect_dt -- 生效日期
    ,fir_tran_dt -- 首次交易日期
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,init_open_acct_dt -- 原始开户日期
    ,init_exp_dt -- 原始到期日期
    ,cust_mgr_id -- 客户经理编号
    ,bal_type_cd -- 钞汇余额代码
    ,off_shore_flg -- 离岸标志
    ,ftz_flg -- 自贸区标志
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,exp_dt -- 到期日期
    ,appl_org_id -- 申请机构编号
    ,mgmt_org_id -- 管理机构编号
    ,cust_name -- 客户名称
    ,level5_cls_cd -- 五级分类代码
    ,loan_rs_cd -- 贷款原因代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,check_dt -- 复核日期
    ,repay_way_cd -- 还款方式代码
    ,sub_plan_way_cd -- 子计划方式代码
    ,open_acct_chn_id -- 开户渠道编号
    ,src_module_type_cd -- 源模块类型代码
    ,sob_cate_cd -- 账套类别代码
    ,indv_bus_flg -- 个体工商户标志
    ,int_accr_flg -- 计息标志
    ,curr_pd -- 当前期次
    ,final_tran_dt -- 最后交易日期
    ,anew_create_repay_plan_flg -- 重新生成还款计划标志
    ,init_prod_id -- 原产品编号
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,loan_auto_repay_type_cd -- 贷款自动还款类型代码
    ,loan_pric_repay_seq_num -- 贷款本金还款顺序号
    ,loan_int_repay_seq_num -- 贷款利息还款顺序号
    ,loan_pnlt_repay_seq_num -- 贷款罚息还款顺序号
    ,loan_comp_int_repay_seq_num -- 贷款复利还款顺序号
    ,loan_fee_repay_seq_num -- 贷款费用还款顺序号
    ,earliest_ovdue_dt -- 最早逾期日期
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,contri_ratio -- 出资比例
    ,init_loan_num -- 原贷款号
    ,init_distr_flow_num -- 原放款流水号
    ,int_sub_closing_dt -- 贴息截止日期
    ,chg_term_not_chg_lmt_final_chg_dt -- 变期不变额最后变化日期
    ,ftz_acct_flg -- 自贸区账户标志
    ,ftz_cd -- 自贸区代码
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,loan_usage_cd -- 贷款用途代码
    ,other_consm_descb -- 其他消费描述
    ,repay_plan_modif_way_cd -- 还款计划变更方式代码
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,wrt_off_post_auto_turn_money_flg -- 核销后自动转款标志
    ,clos_acct_teller_id -- 销户柜员编号
    ,check_teller_id -- 复核柜员编号
    ,open_acct_teller_id -- 开户柜员编号
    ,accrd_hours_int_rat -- 按小时利率
    ,cust_econ_type_cd -- 客户经济类型代码
    ,accrd_hours_file_flg_cd -- 按小时靠档标志代码
    ,check_entry_code -- 对账编码
    ,auto_comb_repay_flg -- 自动组合还款标志
    ,free_int_closing_dt -- 免息截止日期
    ,abs_flg -- 资产证券化标志
    ,auto_revs_flg -- 自动冲正标志
    ,flg_cd -- 资产转让标志
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,clos_acct_type_cd -- 销户类型代码
    ,loan_clos_acct_rs -- 贷款销户原因
    ,auto_payoff_flg -- 自动结清标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,init_bus_id -- 原业务编号
    ,bar_flg -- 随借随还标志
    ,file_int_accr_flg -- 靠档计息标志
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,ld_accti_status_cd -- 上日核算状态代码
    ,ld_acct_status_cd -- 上日账户状态代码
    ,late_merge_flg -- 末期合并标志
    ,refactor_flg -- 再保理标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '300001'||P1.INTERNAL_KEY -- 协议编号
    ,'9999' -- 法人编号
    ,P1.INTERNAL_KEY -- 账户编号
    ,P1.LOAN_NO -- 贷款号
    ,P1.PROD_TYPE -- 产品编号
    ,P1.ACCT_NAME -- 账户名称
    ,P1.CCY -- 币种代码
    ,P1.CMISLOAN_NO -- 借据编号
    ,P1.DD_NO -- 放款流水号
    ,P1.BRANCH -- 开户机构编号
    ,P1.CLIENT_NO -- 客户编号
    ,P1.ACCT_OPEN_DATE -- 开户日期
    ,P1.EFFECT_DATE -- 生效日期
    ,P1.OPEN_TRAN_DATE -- 首次交易日期
    ,P1.ACCT_STATUS -- 账户状态代码
    ,nvl(trim(P1.ACCT_STATUS_PREV),'-') -- 上一账户状态代码
    ,P1.ACCT_STATUS_UPD_DATE -- 账户状态变更日期
    ,P1.ACCOUNTING_STATUS -- 核算状态代码
    ,nvl(trim(P1.ACCOUNTING_STATUS_PREV),'ZHC') -- 上一核算状态代码
    ,P1.ACCOUNTING_STATUS_UPD_DATE -- 核算状态变更日期
    ,decode(P1.CLOSED_DATE,to_date('00010101','yyyymmdd'),to_date('29991231','yyyymmdd'),P1.CLOSED_DATE) -- 销户日期
    ,P1.ACCT_CLOSE_REASON -- 销户原因
    ,P1.ORIG_ACCT_OPEN_DATE -- 原始开户日期
    ,P1.ORI_MATURITY_DATE -- 原始到期日期
    ,P1.ACCT_EXEC -- 客户经理编号
    ,P1.BAL_TYPE -- 钞汇余额代码
    ,DECODE(P1.OSA_FLAG,'I','1','O','0') -- 离岸标志
    ,DECODE(P1.REGION_FLAG,'I','1','O','0') -- 自贸区标志
    ,NVL(TRIM(P1.TERM),0) -- 贷款期限
    ,nvl(trim(P1.TERM_TYPE),'-') -- 期限类型代码
    ,P1.MATURITY_DATE -- 到期日期
    ,P1.APPLY_BRANCH -- 申请机构编号
    ,P1.HOME_BRANCH -- 管理机构编号
    ,P1.LENDER -- 客户名称
    ,P1.FIVE_CATEGORY -- 五级分类代码
    ,P1.REASON_CODE -- 贷款原因代码
    ,DECODE(P1.APPR_FLAG,'Y','1','N','0') -- 账户已复核标志
    ,P1.APPROVAL_DATE -- 复核日期
    ,P1.SCHED_MODE -- 还款方式代码
    ,P1.SUB_SCHED_MODE -- 子计划方式代码
    ,P1.SOURCE_TYPE -- 开户渠道编号
    ,P1.SOURCE_MODULE -- 源模块类型代码
    ,P1.BUSINESS_UNIT -- 账套类别代码
    ,DECODE(P1.IS_INDIVIDUAL,'Y','1','N','0') -- 个体工商户标志
    ,DECODE(P1.INT_IND_FLAG,'Y','1','N','0') -- 计息标志
    ,NVL(TRIM(P1.CUR_STAGE_NO),0) -- 当前期次
    ,P1.LAST_TRAN_DATE -- 最后交易日期
    ,DECODE(P1.REGEN_SCHEDULE_FLAG,'Y','1','N','0') -- 重新生成还款计划标志
    ,P1.OLD_PROD_TYPE -- 原产品编号
    ,NVL(TRIM(P1.FIR_PERIOD),0) -- 首段期数
    ,NVL(TRIM(P1.MID_PERIOD),0) -- 累进间隔期数
    ,P1.ADD_AMT -- 累进金额
    ,P1.ADD_RATIO -- 累进比例
    ,nvl(trim(P1.ALLOC_SEQ_TYPE),'-') -- 贷款自动还款类型代码
    ,P1.ALLOC_SEQ_PRI -- 贷款本金还款顺序号
    ,P1.ALLOC_SEQ_INT -- 贷款利息还款顺序号
    ,P1.ALLOC_SEQ_ODP -- 贷款罚息还款顺序号
    ,P1.ALLOC_SEQ_ODI -- 贷款复利还款顺序号
    ,P1.ALLOC_SEQ_FEE -- 贷款费用还款顺序号
    ,P1.FIRST_OVERDUE_DATE -- 最早逾期日期
    ,decode(trim(p1.MANUAL_CHANGE_SCHEDULE_FLAG),'','-','Y','1','N','0',p1.MANUAL_CHANGE_SCHEDULE_FLAG) -- 需要手工录入还款计划标志
    ,P1.CONTRIBUTIVE_RATIO -- 出资比例
    ,P1.OLD_LOAN_NO -- 原贷款号
    ,P1.OLD_DD_NO -- 原放款流水号
    ,decode(p1.SSI_END_DATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.SSI_END_DATE) -- 贴息截止日期
    ,P1.CONTRACTION_DATE -- 变期不变额最后变化日期
    ,decode(trim(p1.FTA_ACCT_FLAG),'','-','Y','1','N','0',p1.FTA_ACCT_FLAG) -- 自贸区账户标志
    ,P1.FTA_CODE -- 自贸区代码
    ,P1.CALC_TIMES -- 气球贷计算期次
    ,P1.MARKETING_PROD -- 营销产品编号
    ,P1.MARKETING_PROD_DESC -- 营销产品名称
    ,P1.FORMULA_AMT -- 每期计划还款金额
    ,nvl(trim(P1.PURPOSE_ID),'000000')  -- 贷款用途代码
    ,P1.OTHER_CONSUMPTION -- 其他消费描述
    ,nvl(trim(P1.PRE_REPAY_DEAL),'-') -- 还款计划变更方式代码
    ,decode(trim(p1.RECOVER_FLAG),'','-','Y','1','N','0',p1.RECOVER_FLAG) -- 实时追缴标志
    ,decode(trim(p1.AUTO_TRANSFER_FLAG),'','-','Y','1','N','0',p1.AUTO_TRANSFER_FLAG) -- 核销后自动转款标志
    ,P1.ACCT_CLOSE_USER_ID -- 销户柜员编号
    ,P1.APPR_USER_ID -- 复核柜员编号
    ,P1.USER_ID -- 开户柜员编号
    ,P1.HOUR_INT_RATE -- 按小时利率
    ,P1.CLIENT_ECON_TYPE -- 客户经济类型代码
    ,nvl(trim(P1.GEAR_BY_HOUR_FLAG),'-') -- 按小时靠档标志代码
    ,P1.REACCOUNT_CD -- 对账编码
    ,decode(trim(p1.SCHED_ASSEMBLE_FLAG),'','-','Y','1','N','0',p1.SCHED_ASSEMBLE_FLAG) -- 自动组合还款标志
    ,decode(p1.OD_GRACE_END_DATE,to_date('0001/1/1','yyyy/mm/dd'),to_date('2999/12/31','yyyy/mm/dd'),p1.OD_GRACE_END_DATE) -- 免息截止日期
    ,decode(trim(P1.ABS_FLAG),'Y','1','N','0','','-',trim(P1.ABS_FLAG)) -- 资产证券化标志
    ,NVL(TRIM(P1.AUTO_REVERSAL_FLAG),'-') -- 自动冲正标志
    ,decode(trim(P1.IS_TRF_FLAG),'Y','1','N','0','','-',trim(P1.IS_TRF_FLAG)) -- 资产转让标志
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.CLIENT_TYPE END -- 客户类型代码
    ,nvl(trim(P1.ACCT_TYPE),'-') -- 账户类型代码
    ,nvl(trim(P1.PAY_OFF_TYPE),'-') -- 销户类型代码
    ,P1.PAY_OFF_REASON -- 贷款销户原因
    ,decode(P1.AUTO_SETTLE_FLAG,'Y','1','N','0',' ','-',P1.AUTO_SETTLE_FLAG) -- 自动结清标志
    ,P1.LAST_CHANGE_USER_ID -- 最后修改柜员编号
    ,P1.LAST_CHANGE_DATE -- 最后修改日期
    ,P1.EXT_TRADE_NO -- 原业务编号
    ,decode(P1.ANYTIME_REC_FLAG,'Y','1','N','0',' ','-',P1.ANYTIME_REC_FLAG) -- 随借随还标志
    ,decode(P1.GEAR_PROD_FLAG,'Y','1','N','0',' ','-',P1.GEAR_PROD_FLAG) -- 靠档计息标志
    ,P1.DOCUMENT_ID -- 证件号码
    ,nvl(trim(P1.DOCUMENT_TYPE),'0000') -- 证件类型代码
    ,nvl(trim(P1.ACCOUNTING_STATUS_YESTERDAY),'-') -- 上日核算状态代码
    ,nvl(trim(P1.ACCT_STATUS_YESTERDAY),'-') -- 上日账户状态代码
    ,decode(P1.LAST_MERGE_FLAG,'Y','1','N','0',' ','-',P1.LAST_MERGE_FLAG) -- 末期合并标志
    ,decode(P1.RENEW_FACT_FLG,'Y','1','N','0',' ','-',P1.RENEW_FACT_FLG) -- 再保理标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'ncbs_cl_acct' -- 源表名称
    ,'ncbsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.ncbs_cl_acct p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.CLIENT_TYPE = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'NCBS'
        AND R1.SRC_TAB_EN_NAME= 'NCBS_CL_ACCT'
        AND R1.SRC_FIELD_EN_NAME= 'CLIENT_TYPE'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_LOAN_ACCT_INFO_H'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'CUST_TYPE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;

whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_loan_acct_info_h_ncbsf1_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
  	                                        ,acct_id
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
        into ${iml_schema}.agt_loan_acct_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,dubil_id -- 借据编号
    ,distr_flow_num -- 放款流水号
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,open_acct_dt -- 开户日期
    ,effect_dt -- 生效日期
    ,fir_tran_dt -- 首次交易日期
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,init_open_acct_dt -- 原始开户日期
    ,init_exp_dt -- 原始到期日期
    ,cust_mgr_id -- 客户经理编号
    ,bal_type_cd -- 钞汇余额代码
    ,off_shore_flg -- 离岸标志
    ,ftz_flg -- 自贸区标志
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,exp_dt -- 到期日期
    ,appl_org_id -- 申请机构编号
    ,mgmt_org_id -- 管理机构编号
    ,cust_name -- 客户名称
    ,level5_cls_cd -- 五级分类代码
    ,loan_rs_cd -- 贷款原因代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,check_dt -- 复核日期
    ,repay_way_cd -- 还款方式代码
    ,sub_plan_way_cd -- 子计划方式代码
    ,open_acct_chn_id -- 开户渠道编号
    ,src_module_type_cd -- 源模块类型代码
    ,sob_cate_cd -- 账套类别代码
    ,indv_bus_flg -- 个体工商户标志
    ,int_accr_flg -- 计息标志
    ,curr_pd -- 当前期次
    ,final_tran_dt -- 最后交易日期
    ,anew_create_repay_plan_flg -- 重新生成还款计划标志
    ,init_prod_id -- 原产品编号
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,loan_auto_repay_type_cd -- 贷款自动还款类型代码
    ,loan_pric_repay_seq_num -- 贷款本金还款顺序号
    ,loan_int_repay_seq_num -- 贷款利息还款顺序号
    ,loan_pnlt_repay_seq_num -- 贷款罚息还款顺序号
    ,loan_comp_int_repay_seq_num -- 贷款复利还款顺序号
    ,loan_fee_repay_seq_num -- 贷款费用还款顺序号
    ,earliest_ovdue_dt -- 最早逾期日期
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,contri_ratio -- 出资比例
    ,init_loan_num -- 原贷款号
    ,init_distr_flow_num -- 原放款流水号
    ,int_sub_closing_dt -- 贴息截止日期
    ,chg_term_not_chg_lmt_final_chg_dt -- 变期不变额最后变化日期
    ,ftz_acct_flg -- 自贸区账户标志
    ,ftz_cd -- 自贸区代码
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,loan_usage_cd -- 贷款用途代码
    ,other_consm_descb -- 其他消费描述
    ,repay_plan_modif_way_cd -- 还款计划变更方式代码
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,wrt_off_post_auto_turn_money_flg -- 核销后自动转款标志
    ,clos_acct_teller_id -- 销户柜员编号
    ,check_teller_id -- 复核柜员编号
    ,open_acct_teller_id -- 开户柜员编号
    ,accrd_hours_int_rat -- 按小时利率
    ,cust_econ_type_cd -- 客户经济类型代码
    ,accrd_hours_file_flg_cd -- 按小时靠档标志代码
    ,check_entry_code -- 对账编码
    ,auto_comb_repay_flg -- 自动组合还款标志
    ,free_int_closing_dt -- 免息截止日期
    ,abs_flg -- 资产证券化标志
    ,auto_revs_flg -- 自动冲正标志
    ,flg_cd -- 资产转让标志
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,clos_acct_type_cd -- 销户类型代码
    ,loan_clos_acct_rs -- 贷款销户原因
    ,auto_payoff_flg -- 自动结清标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,init_bus_id -- 原业务编号
    ,bar_flg -- 随借随还标志
    ,file_int_accr_flg -- 靠档计息标志
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,ld_accti_status_cd -- 上日核算状态代码
    ,ld_acct_status_cd -- 上日账户状态代码
    ,late_merge_flg -- 末期合并标志
    ,refactor_flg -- 再保理标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,dubil_id -- 借据编号
    ,distr_flow_num -- 放款流水号
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,open_acct_dt -- 开户日期
    ,effect_dt -- 生效日期
    ,fir_tran_dt -- 首次交易日期
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,init_open_acct_dt -- 原始开户日期
    ,init_exp_dt -- 原始到期日期
    ,cust_mgr_id -- 客户经理编号
    ,bal_type_cd -- 钞汇余额代码
    ,off_shore_flg -- 离岸标志
    ,ftz_flg -- 自贸区标志
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,exp_dt -- 到期日期
    ,appl_org_id -- 申请机构编号
    ,mgmt_org_id -- 管理机构编号
    ,cust_name -- 客户名称
    ,level5_cls_cd -- 五级分类代码
    ,loan_rs_cd -- 贷款原因代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,check_dt -- 复核日期
    ,repay_way_cd -- 还款方式代码
    ,sub_plan_way_cd -- 子计划方式代码
    ,open_acct_chn_id -- 开户渠道编号
    ,src_module_type_cd -- 源模块类型代码
    ,sob_cate_cd -- 账套类别代码
    ,indv_bus_flg -- 个体工商户标志
    ,int_accr_flg -- 计息标志
    ,curr_pd -- 当前期次
    ,final_tran_dt -- 最后交易日期
    ,anew_create_repay_plan_flg -- 重新生成还款计划标志
    ,init_prod_id -- 原产品编号
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,loan_auto_repay_type_cd -- 贷款自动还款类型代码
    ,loan_pric_repay_seq_num -- 贷款本金还款顺序号
    ,loan_int_repay_seq_num -- 贷款利息还款顺序号
    ,loan_pnlt_repay_seq_num -- 贷款罚息还款顺序号
    ,loan_comp_int_repay_seq_num -- 贷款复利还款顺序号
    ,loan_fee_repay_seq_num -- 贷款费用还款顺序号
    ,earliest_ovdue_dt -- 最早逾期日期
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,contri_ratio -- 出资比例
    ,init_loan_num -- 原贷款号
    ,init_distr_flow_num -- 原放款流水号
    ,int_sub_closing_dt -- 贴息截止日期
    ,chg_term_not_chg_lmt_final_chg_dt -- 变期不变额最后变化日期
    ,ftz_acct_flg -- 自贸区账户标志
    ,ftz_cd -- 自贸区代码
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,loan_usage_cd -- 贷款用途代码
    ,other_consm_descb -- 其他消费描述
    ,repay_plan_modif_way_cd -- 还款计划变更方式代码
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,wrt_off_post_auto_turn_money_flg -- 核销后自动转款标志
    ,clos_acct_teller_id -- 销户柜员编号
    ,check_teller_id -- 复核柜员编号
    ,open_acct_teller_id -- 开户柜员编号
    ,accrd_hours_int_rat -- 按小时利率
    ,cust_econ_type_cd -- 客户经济类型代码
    ,accrd_hours_file_flg_cd -- 按小时靠档标志代码
    ,check_entry_code -- 对账编码
    ,auto_comb_repay_flg -- 自动组合还款标志
    ,free_int_closing_dt -- 免息截止日期
    ,abs_flg -- 资产证券化标志
    ,auto_revs_flg -- 自动冲正标志
    ,flg_cd -- 资产转让标志
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,clos_acct_type_cd -- 销户类型代码
    ,loan_clos_acct_rs -- 贷款销户原因
    ,auto_payoff_flg -- 自动结清标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,init_bus_id -- 原业务编号
    ,bar_flg -- 随借随还标志
    ,file_int_accr_flg -- 靠档计息标志
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,ld_accti_status_cd -- 上日核算状态代码
    ,ld_acct_status_cd -- 上日账户状态代码
    ,late_merge_flg -- 末期合并标志
    ,refactor_flg -- 再保理标志
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
    ,nvl(n.acct_id, o.acct_id) as acct_id -- 账户编号
    ,nvl(n.loan_num, o.loan_num) as loan_num -- 贷款号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 账户名称
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.distr_flow_num, o.distr_flow_num) as distr_flow_num -- 放款流水号
    ,nvl(n.open_acct_org_id, o.open_acct_org_id) as open_acct_org_id -- 开户机构编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.open_acct_dt, o.open_acct_dt) as open_acct_dt -- 开户日期
    ,nvl(n.effect_dt, o.effect_dt) as effect_dt -- 生效日期
    ,nvl(n.fir_tran_dt, o.fir_tran_dt) as fir_tran_dt -- 首次交易日期
    ,nvl(n.acct_status_cd, o.acct_status_cd) as acct_status_cd -- 账户状态代码
    ,nvl(n.last_acct_status_cd, o.last_acct_status_cd) as last_acct_status_cd -- 上一账户状态代码
    ,nvl(n.acct_status_modif_dt, o.acct_status_modif_dt) as acct_status_modif_dt -- 账户状态变更日期
    ,nvl(n.accti_status_cd, o.accti_status_cd) as accti_status_cd -- 核算状态代码
    ,nvl(n.last_accti_status_cd, o.last_accti_status_cd) as last_accti_status_cd -- 上一核算状态代码
    ,nvl(n.accti_status_modif_dt, o.accti_status_modif_dt) as accti_status_modif_dt -- 核算状态变更日期
    ,nvl(n.clos_acct_dt, o.clos_acct_dt) as clos_acct_dt -- 销户日期
    ,nvl(n.clos_acct_rs, o.clos_acct_rs) as clos_acct_rs -- 销户原因
    ,nvl(n.init_open_acct_dt, o.init_open_acct_dt) as init_open_acct_dt -- 原始开户日期
    ,nvl(n.init_exp_dt, o.init_exp_dt) as init_exp_dt -- 原始到期日期
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.bal_type_cd, o.bal_type_cd) as bal_type_cd -- 钞汇余额代码
    ,nvl(n.off_shore_flg, o.off_shore_flg) as off_shore_flg -- 离岸标志
    ,nvl(n.ftz_flg, o.ftz_flg) as ftz_flg -- 自贸区标志
    ,nvl(n.loan_tenor, o.loan_tenor) as loan_tenor -- 贷款期限
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.appl_org_id, o.appl_org_id) as appl_org_id -- 申请机构编号
    ,nvl(n.mgmt_org_id, o.mgmt_org_id) as mgmt_org_id -- 管理机构编号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
    ,nvl(n.level5_cls_cd, o.level5_cls_cd) as level5_cls_cd -- 五级分类代码
    ,nvl(n.loan_rs_cd, o.loan_rs_cd) as loan_rs_cd -- 贷款原因代码
    ,nvl(n.acct_aldy_check_flg, o.acct_aldy_check_flg) as acct_aldy_check_flg -- 账户已复核标志
    ,nvl(n.check_dt, o.check_dt) as check_dt -- 复核日期
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.sub_plan_way_cd, o.sub_plan_way_cd) as sub_plan_way_cd -- 子计划方式代码
    ,nvl(n.open_acct_chn_id, o.open_acct_chn_id) as open_acct_chn_id -- 开户渠道编号
    ,nvl(n.src_module_type_cd, o.src_module_type_cd) as src_module_type_cd -- 源模块类型代码
    ,nvl(n.sob_cate_cd, o.sob_cate_cd) as sob_cate_cd -- 账套类别代码
    ,nvl(n.indv_bus_flg, o.indv_bus_flg) as indv_bus_flg -- 个体工商户标志
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.curr_pd, o.curr_pd) as curr_pd -- 当前期次
    ,nvl(n.final_tran_dt, o.final_tran_dt) as final_tran_dt -- 最后交易日期
    ,nvl(n.anew_create_repay_plan_flg, o.anew_create_repay_plan_flg) as anew_create_repay_plan_flg -- 重新生成还款计划标志
    ,nvl(n.init_prod_id, o.init_prod_id) as init_prod_id -- 原产品编号
    ,nvl(n.perds, o.perds) as perds -- 首段期数
    ,nvl(n.prog_intrv_perds, o.prog_intrv_perds) as prog_intrv_perds -- 累进间隔期数
    ,nvl(n.prog_amt, o.prog_amt) as prog_amt -- 累进金额
    ,nvl(n.prog_ratio, o.prog_ratio) as prog_ratio -- 累进比例
    ,nvl(n.loan_auto_repay_type_cd, o.loan_auto_repay_type_cd) as loan_auto_repay_type_cd -- 贷款自动还款类型代码
    ,nvl(n.loan_pric_repay_seq_num, o.loan_pric_repay_seq_num) as loan_pric_repay_seq_num -- 贷款本金还款顺序号
    ,nvl(n.loan_int_repay_seq_num, o.loan_int_repay_seq_num) as loan_int_repay_seq_num -- 贷款利息还款顺序号
    ,nvl(n.loan_pnlt_repay_seq_num, o.loan_pnlt_repay_seq_num) as loan_pnlt_repay_seq_num -- 贷款罚息还款顺序号
    ,nvl(n.loan_comp_int_repay_seq_num, o.loan_comp_int_repay_seq_num) as loan_comp_int_repay_seq_num -- 贷款复利还款顺序号
    ,nvl(n.loan_fee_repay_seq_num, o.loan_fee_repay_seq_num) as loan_fee_repay_seq_num -- 贷款费用还款顺序号
    ,nvl(n.earliest_ovdue_dt, o.earliest_ovdue_dt) as earliest_ovdue_dt -- 最早逾期日期
    ,nvl(n.need_manual_input_repay_plan_flg, o.need_manual_input_repay_plan_flg) as need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,nvl(n.contri_ratio, o.contri_ratio) as contri_ratio -- 出资比例
    ,nvl(n.init_loan_num, o.init_loan_num) as init_loan_num -- 原贷款号
    ,nvl(n.init_distr_flow_num, o.init_distr_flow_num) as init_distr_flow_num -- 原放款流水号
    ,nvl(n.int_sub_closing_dt, o.int_sub_closing_dt) as int_sub_closing_dt -- 贴息截止日期
    ,nvl(n.chg_term_not_chg_lmt_final_chg_dt, o.chg_term_not_chg_lmt_final_chg_dt) as chg_term_not_chg_lmt_final_chg_dt -- 变期不变额最后变化日期
    ,nvl(n.ftz_acct_flg, o.ftz_acct_flg) as ftz_acct_flg -- 自贸区账户标志
    ,nvl(n.ftz_cd, o.ftz_cd) as ftz_cd -- 自贸区代码
    ,nvl(n.blon_loan_calc_pd, o.blon_loan_calc_pd) as blon_loan_calc_pd -- 气球贷计算期次
    ,nvl(n.camp_prod_id, o.camp_prod_id) as camp_prod_id -- 营销产品编号
    ,nvl(n.camp_prod_name, o.camp_prod_name) as camp_prod_name -- 营销产品名称
    ,nvl(n.eh_issue_plan_repay_amt, o.eh_issue_plan_repay_amt) as eh_issue_plan_repay_amt -- 每期计划还款金额
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.other_consm_descb, o.other_consm_descb) as other_consm_descb -- 其他消费描述
    ,nvl(n.repay_plan_modif_way_cd, o.repay_plan_modif_way_cd) as repay_plan_modif_way_cd -- 还款计划变更方式代码
    ,nvl(n.realtm_chase_capt_flg, o.realtm_chase_capt_flg) as realtm_chase_capt_flg -- 实时追缴标志
    ,nvl(n.wrt_off_post_auto_turn_money_flg, o.wrt_off_post_auto_turn_money_flg) as wrt_off_post_auto_turn_money_flg -- 核销后自动转款标志
    ,nvl(n.clos_acct_teller_id, o.clos_acct_teller_id) as clos_acct_teller_id -- 销户柜员编号
    ,nvl(n.check_teller_id, o.check_teller_id) as check_teller_id -- 复核柜员编号
    ,nvl(n.open_acct_teller_id, o.open_acct_teller_id) as open_acct_teller_id -- 开户柜员编号
    ,nvl(n.accrd_hours_int_rat, o.accrd_hours_int_rat) as accrd_hours_int_rat -- 按小时利率
    ,nvl(n.cust_econ_type_cd, o.cust_econ_type_cd) as cust_econ_type_cd -- 客户经济类型代码
    ,nvl(n.accrd_hours_file_flg_cd, o.accrd_hours_file_flg_cd) as accrd_hours_file_flg_cd -- 按小时靠档标志代码
    ,nvl(n.check_entry_code, o.check_entry_code) as check_entry_code -- 对账编码
    ,nvl(n.auto_comb_repay_flg, o.auto_comb_repay_flg) as auto_comb_repay_flg -- 自动组合还款标志
    ,nvl(n.free_int_closing_dt, o.free_int_closing_dt) as free_int_closing_dt -- 免息截止日期
    ,nvl(n.abs_flg, o.abs_flg) as abs_flg -- 资产证券化标志
    ,nvl(n.auto_revs_flg, o.auto_revs_flg) as auto_revs_flg -- 自动冲正标志
    ,nvl(n.flg_cd, o.flg_cd) as flg_cd -- 资产转让标志
    ,nvl(n.cust_type_cd, o.cust_type_cd) as cust_type_cd -- 客户类型代码
    ,nvl(n.acct_type_cd, o.acct_type_cd) as acct_type_cd -- 账户类型代码
    ,nvl(n.clos_acct_type_cd, o.clos_acct_type_cd) as clos_acct_type_cd -- 销户类型代码
    ,nvl(n.loan_clos_acct_rs, o.loan_clos_acct_rs) as loan_clos_acct_rs -- 贷款销户原因
    ,nvl(n.auto_payoff_flg, o.auto_payoff_flg) as auto_payoff_flg -- 自动结清标志
    ,nvl(n.final_modif_teller_id, o.final_modif_teller_id) as final_modif_teller_id -- 最后修改柜员编号
    ,nvl(n.final_modif_dt, o.final_modif_dt) as final_modif_dt -- 最后修改日期
    ,nvl(n.init_bus_id, o.init_bus_id) as init_bus_id -- 原业务编号
    ,nvl(n.bar_flg, o.bar_flg) as bar_flg -- 随借随还标志
    ,nvl(n.file_int_accr_flg, o.file_int_accr_flg) as file_int_accr_flg -- 靠档计息标志
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.cert_type_cd, o.cert_type_cd) as cert_type_cd -- 证件类型代码
    ,nvl(n.ld_accti_status_cd, o.ld_accti_status_cd) as ld_accti_status_cd -- 上日核算状态代码
    ,nvl(n.ld_acct_status_cd, o.ld_acct_status_cd) as ld_acct_status_cd -- 上日账户状态代码
    ,nvl(n.late_merge_flg, o.late_merge_flg) as late_merge_flg -- 末期合并标志
    ,nvl(n.refactor_flg, o.refactor_flg) as refactor_flg -- 再保理标志
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.agt_id is null
            and n.lp_id is null
            and n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,nvl(n.etl_timestamp, o.etl_timestamp) as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_loan_acct_info_h_ncbsf1_tm n
    full join (select * from ${iml_schema}.agt_loan_acct_info_h_ncbsf1_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
where (
        o.agt_id is null
        and o.lp_id is null
        and o.acct_id is null
    )
    or (
        n.agt_id is null
        and n.lp_id is null
        and n.acct_id is null
    )
    or (
        o.loan_num <> n.loan_num
        or o.prod_id <> n.prod_id
        or o.acct_name <> n.acct_name
        or o.curr_cd <> n.curr_cd
        or o.dubil_id <> n.dubil_id
        or o.distr_flow_num <> n.distr_flow_num
        or o.open_acct_org_id <> n.open_acct_org_id
        or o.cust_id <> n.cust_id
        or o.open_acct_dt <> n.open_acct_dt
        or o.effect_dt <> n.effect_dt
        or o.fir_tran_dt <> n.fir_tran_dt
        or o.acct_status_cd <> n.acct_status_cd
        or o.last_acct_status_cd <> n.last_acct_status_cd
        or o.acct_status_modif_dt <> n.acct_status_modif_dt
        or o.accti_status_cd <> n.accti_status_cd
        or o.last_accti_status_cd <> n.last_accti_status_cd
        or o.accti_status_modif_dt <> n.accti_status_modif_dt
        or o.clos_acct_dt <> n.clos_acct_dt
        or o.clos_acct_rs <> n.clos_acct_rs
        or o.init_open_acct_dt <> n.init_open_acct_dt
        or o.init_exp_dt <> n.init_exp_dt
        or o.cust_mgr_id <> n.cust_mgr_id
        or o.bal_type_cd <> n.bal_type_cd
        or o.off_shore_flg <> n.off_shore_flg
        or o.ftz_flg <> n.ftz_flg
        or o.loan_tenor <> n.loan_tenor
        or o.tenor_type_cd <> n.tenor_type_cd
        or o.exp_dt <> n.exp_dt
        or o.appl_org_id <> n.appl_org_id
        or o.mgmt_org_id <> n.mgmt_org_id
        or o.cust_name <> n.cust_name
        or o.level5_cls_cd <> n.level5_cls_cd
        or o.loan_rs_cd <> n.loan_rs_cd
        or o.acct_aldy_check_flg <> n.acct_aldy_check_flg
        or o.check_dt <> n.check_dt
        or o.repay_way_cd <> n.repay_way_cd
        or o.sub_plan_way_cd <> n.sub_plan_way_cd
        or o.open_acct_chn_id <> n.open_acct_chn_id
        or o.src_module_type_cd <> n.src_module_type_cd
        or o.sob_cate_cd <> n.sob_cate_cd
        or o.indv_bus_flg <> n.indv_bus_flg
        or o.int_accr_flg <> n.int_accr_flg
        or o.curr_pd <> n.curr_pd
        or o.final_tran_dt <> n.final_tran_dt
        or o.anew_create_repay_plan_flg <> n.anew_create_repay_plan_flg
        or o.init_prod_id <> n.init_prod_id
        or o.perds <> n.perds
        or o.prog_intrv_perds <> n.prog_intrv_perds
        or o.prog_amt <> n.prog_amt
        or o.prog_ratio <> n.prog_ratio
        or o.loan_auto_repay_type_cd <> n.loan_auto_repay_type_cd
        or o.loan_pric_repay_seq_num <> n.loan_pric_repay_seq_num
        or o.loan_int_repay_seq_num <> n.loan_int_repay_seq_num
        or o.loan_pnlt_repay_seq_num <> n.loan_pnlt_repay_seq_num
        or o.loan_comp_int_repay_seq_num <> n.loan_comp_int_repay_seq_num
        or o.loan_fee_repay_seq_num <> n.loan_fee_repay_seq_num
        or o.earliest_ovdue_dt <> n.earliest_ovdue_dt
        or o.need_manual_input_repay_plan_flg <> n.need_manual_input_repay_plan_flg
        or o.contri_ratio <> n.contri_ratio
        or o.init_loan_num <> n.init_loan_num
        or o.init_distr_flow_num <> n.init_distr_flow_num
        or o.int_sub_closing_dt <> n.int_sub_closing_dt
        or o.chg_term_not_chg_lmt_final_chg_dt <> n.chg_term_not_chg_lmt_final_chg_dt
        or o.ftz_acct_flg <> n.ftz_acct_flg
        or o.ftz_cd <> n.ftz_cd
        or o.blon_loan_calc_pd <> n.blon_loan_calc_pd
        or o.camp_prod_id <> n.camp_prod_id
        or o.camp_prod_name <> n.camp_prod_name
        or o.eh_issue_plan_repay_amt <> n.eh_issue_plan_repay_amt
        or o.loan_usage_cd <> n.loan_usage_cd
        or o.other_consm_descb <> n.other_consm_descb
        or o.repay_plan_modif_way_cd <> n.repay_plan_modif_way_cd
        or o.realtm_chase_capt_flg <> n.realtm_chase_capt_flg
        or o.wrt_off_post_auto_turn_money_flg <> n.wrt_off_post_auto_turn_money_flg
        or o.clos_acct_teller_id <> n.clos_acct_teller_id
        or o.check_teller_id <> n.check_teller_id
        or o.open_acct_teller_id <> n.open_acct_teller_id
        or o.accrd_hours_int_rat <> n.accrd_hours_int_rat
        or o.cust_econ_type_cd <> n.cust_econ_type_cd
        or o.accrd_hours_file_flg_cd <> n.accrd_hours_file_flg_cd
        or o.check_entry_code <> n.check_entry_code
        or o.auto_comb_repay_flg <> n.auto_comb_repay_flg
        or o.free_int_closing_dt <> n.free_int_closing_dt
        or o.abs_flg <> n.abs_flg
        or o.auto_revs_flg <> n.auto_revs_flg
        or o.flg_cd <> n.flg_cd
        or o.cust_type_cd <> n.cust_type_cd
        or o.acct_type_cd <> n.acct_type_cd
        or o.clos_acct_type_cd <> n.clos_acct_type_cd
        or o.loan_clos_acct_rs <> n.loan_clos_acct_rs
        or o.auto_payoff_flg <> n.auto_payoff_flg
        or o.final_modif_teller_id <> n.final_modif_teller_id
        or o.final_modif_dt <> n.final_modif_dt
        or o.init_bus_id <> n.init_bus_id
        or o.bar_flg <> n.bar_flg
        or o.file_int_accr_flg <> n.file_int_accr_flg
        or o.cert_no <> n.cert_no
        or o.cert_type_cd <> n.cert_type_cd
        or o.ld_accti_status_cd <> n.ld_accti_status_cd
        or o.ld_acct_status_cd <> n.ld_acct_status_cd
        or o.late_merge_flg <> n.late_merge_flg
        or o.refactor_flg <> n.refactor_flg
    )
;
commit;

-- 3.3 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iml_schema}.agt_loan_acct_info_h_ncbsf1_cl(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,dubil_id -- 借据编号
    ,distr_flow_num -- 放款流水号
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,open_acct_dt -- 开户日期
    ,effect_dt -- 生效日期
    ,fir_tran_dt -- 首次交易日期
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,init_open_acct_dt -- 原始开户日期
    ,init_exp_dt -- 原始到期日期
    ,cust_mgr_id -- 客户经理编号
    ,bal_type_cd -- 钞汇余额代码
    ,off_shore_flg -- 离岸标志
    ,ftz_flg -- 自贸区标志
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,exp_dt -- 到期日期
    ,appl_org_id -- 申请机构编号
    ,mgmt_org_id -- 管理机构编号
    ,cust_name -- 客户名称
    ,level5_cls_cd -- 五级分类代码
    ,loan_rs_cd -- 贷款原因代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,check_dt -- 复核日期
    ,repay_way_cd -- 还款方式代码
    ,sub_plan_way_cd -- 子计划方式代码
    ,open_acct_chn_id -- 开户渠道编号
    ,src_module_type_cd -- 源模块类型代码
    ,sob_cate_cd -- 账套类别代码
    ,indv_bus_flg -- 个体工商户标志
    ,int_accr_flg -- 计息标志
    ,curr_pd -- 当前期次
    ,final_tran_dt -- 最后交易日期
    ,anew_create_repay_plan_flg -- 重新生成还款计划标志
    ,init_prod_id -- 原产品编号
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,loan_auto_repay_type_cd -- 贷款自动还款类型代码
    ,loan_pric_repay_seq_num -- 贷款本金还款顺序号
    ,loan_int_repay_seq_num -- 贷款利息还款顺序号
    ,loan_pnlt_repay_seq_num -- 贷款罚息还款顺序号
    ,loan_comp_int_repay_seq_num -- 贷款复利还款顺序号
    ,loan_fee_repay_seq_num -- 贷款费用还款顺序号
    ,earliest_ovdue_dt -- 最早逾期日期
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,contri_ratio -- 出资比例
    ,init_loan_num -- 原贷款号
    ,init_distr_flow_num -- 原放款流水号
    ,int_sub_closing_dt -- 贴息截止日期
    ,chg_term_not_chg_lmt_final_chg_dt -- 变期不变额最后变化日期
    ,ftz_acct_flg -- 自贸区账户标志
    ,ftz_cd -- 自贸区代码
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,loan_usage_cd -- 贷款用途代码
    ,other_consm_descb -- 其他消费描述
    ,repay_plan_modif_way_cd -- 还款计划变更方式代码
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,wrt_off_post_auto_turn_money_flg -- 核销后自动转款标志
    ,clos_acct_teller_id -- 销户柜员编号
    ,check_teller_id -- 复核柜员编号
    ,open_acct_teller_id -- 开户柜员编号
    ,accrd_hours_int_rat -- 按小时利率
    ,cust_econ_type_cd -- 客户经济类型代码
    ,accrd_hours_file_flg_cd -- 按小时靠档标志代码
    ,check_entry_code -- 对账编码
    ,auto_comb_repay_flg -- 自动组合还款标志
    ,free_int_closing_dt -- 免息截止日期
    ,abs_flg -- 资产证券化标志
    ,auto_revs_flg -- 自动冲正标志
    ,flg_cd -- 资产转让标志
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,clos_acct_type_cd -- 销户类型代码
    ,loan_clos_acct_rs -- 贷款销户原因
    ,auto_payoff_flg -- 自动结清标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,init_bus_id -- 原业务编号
    ,bar_flg -- 随借随还标志
    ,file_int_accr_flg -- 靠档计息标志
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,ld_accti_status_cd -- 上日核算状态代码
    ,ld_acct_status_cd -- 上日账户状态代码
    ,late_merge_flg -- 末期合并标志
    ,refactor_flg -- 再保理标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,src_table_name -- 源表名称
            ,job_cd -- 任务编码
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iml_schema}.agt_loan_acct_info_h_ncbsf1_op(
            agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,acct_id -- 账户编号
    ,loan_num -- 贷款号
    ,prod_id -- 产品编号
    ,acct_name -- 账户名称
    ,curr_cd -- 币种代码
    ,dubil_id -- 借据编号
    ,distr_flow_num -- 放款流水号
    ,open_acct_org_id -- 开户机构编号
    ,cust_id -- 客户编号
    ,open_acct_dt -- 开户日期
    ,effect_dt -- 生效日期
    ,fir_tran_dt -- 首次交易日期
    ,acct_status_cd -- 账户状态代码
    ,last_acct_status_cd -- 上一账户状态代码
    ,acct_status_modif_dt -- 账户状态变更日期
    ,accti_status_cd -- 核算状态代码
    ,last_accti_status_cd -- 上一核算状态代码
    ,accti_status_modif_dt -- 核算状态变更日期
    ,clos_acct_dt -- 销户日期
    ,clos_acct_rs -- 销户原因
    ,init_open_acct_dt -- 原始开户日期
    ,init_exp_dt -- 原始到期日期
    ,cust_mgr_id -- 客户经理编号
    ,bal_type_cd -- 钞汇余额代码
    ,off_shore_flg -- 离岸标志
    ,ftz_flg -- 自贸区标志
    ,loan_tenor -- 贷款期限
    ,tenor_type_cd -- 期限类型代码
    ,exp_dt -- 到期日期
    ,appl_org_id -- 申请机构编号
    ,mgmt_org_id -- 管理机构编号
    ,cust_name -- 客户名称
    ,level5_cls_cd -- 五级分类代码
    ,loan_rs_cd -- 贷款原因代码
    ,acct_aldy_check_flg -- 账户已复核标志
    ,check_dt -- 复核日期
    ,repay_way_cd -- 还款方式代码
    ,sub_plan_way_cd -- 子计划方式代码
    ,open_acct_chn_id -- 开户渠道编号
    ,src_module_type_cd -- 源模块类型代码
    ,sob_cate_cd -- 账套类别代码
    ,indv_bus_flg -- 个体工商户标志
    ,int_accr_flg -- 计息标志
    ,curr_pd -- 当前期次
    ,final_tran_dt -- 最后交易日期
    ,anew_create_repay_plan_flg -- 重新生成还款计划标志
    ,init_prod_id -- 原产品编号
    ,perds -- 首段期数
    ,prog_intrv_perds -- 累进间隔期数
    ,prog_amt -- 累进金额
    ,prog_ratio -- 累进比例
    ,loan_auto_repay_type_cd -- 贷款自动还款类型代码
    ,loan_pric_repay_seq_num -- 贷款本金还款顺序号
    ,loan_int_repay_seq_num -- 贷款利息还款顺序号
    ,loan_pnlt_repay_seq_num -- 贷款罚息还款顺序号
    ,loan_comp_int_repay_seq_num -- 贷款复利还款顺序号
    ,loan_fee_repay_seq_num -- 贷款费用还款顺序号
    ,earliest_ovdue_dt -- 最早逾期日期
    ,need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,contri_ratio -- 出资比例
    ,init_loan_num -- 原贷款号
    ,init_distr_flow_num -- 原放款流水号
    ,int_sub_closing_dt -- 贴息截止日期
    ,chg_term_not_chg_lmt_final_chg_dt -- 变期不变额最后变化日期
    ,ftz_acct_flg -- 自贸区账户标志
    ,ftz_cd -- 自贸区代码
    ,blon_loan_calc_pd -- 气球贷计算期次
    ,camp_prod_id -- 营销产品编号
    ,camp_prod_name -- 营销产品名称
    ,eh_issue_plan_repay_amt -- 每期计划还款金额
    ,loan_usage_cd -- 贷款用途代码
    ,other_consm_descb -- 其他消费描述
    ,repay_plan_modif_way_cd -- 还款计划变更方式代码
    ,realtm_chase_capt_flg -- 实时追缴标志
    ,wrt_off_post_auto_turn_money_flg -- 核销后自动转款标志
    ,clos_acct_teller_id -- 销户柜员编号
    ,check_teller_id -- 复核柜员编号
    ,open_acct_teller_id -- 开户柜员编号
    ,accrd_hours_int_rat -- 按小时利率
    ,cust_econ_type_cd -- 客户经济类型代码
    ,accrd_hours_file_flg_cd -- 按小时靠档标志代码
    ,check_entry_code -- 对账编码
    ,auto_comb_repay_flg -- 自动组合还款标志
    ,free_int_closing_dt -- 免息截止日期
    ,abs_flg -- 资产证券化标志
    ,auto_revs_flg -- 自动冲正标志
    ,flg_cd -- 资产转让标志
    ,cust_type_cd -- 客户类型代码
    ,acct_type_cd -- 账户类型代码
    ,clos_acct_type_cd -- 销户类型代码
    ,loan_clos_acct_rs -- 贷款销户原因
    ,auto_payoff_flg -- 自动结清标志
    ,final_modif_teller_id -- 最后修改柜员编号
    ,final_modif_dt -- 最后修改日期
    ,init_bus_id -- 原业务编号
    ,bar_flg -- 随借随还标志
    ,file_int_accr_flg -- 靠档计息标志
    ,cert_no -- 证件号码
    ,cert_type_cd -- 证件类型代码
    ,ld_accti_status_cd -- 上日核算状态代码
    ,ld_acct_status_cd -- 上日账户状态代码
    ,late_merge_flg -- 末期合并标志
    ,refactor_flg -- 再保理标志
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
    ,o.acct_id -- 账户编号
    ,o.loan_num -- 贷款号
    ,o.prod_id -- 产品编号
    ,o.acct_name -- 账户名称
    ,o.curr_cd -- 币种代码
    ,o.dubil_id -- 借据编号
    ,o.distr_flow_num -- 放款流水号
    ,o.open_acct_org_id -- 开户机构编号
    ,o.cust_id -- 客户编号
    ,o.open_acct_dt -- 开户日期
    ,o.effect_dt -- 生效日期
    ,o.fir_tran_dt -- 首次交易日期
    ,o.acct_status_cd -- 账户状态代码
    ,o.last_acct_status_cd -- 上一账户状态代码
    ,o.acct_status_modif_dt -- 账户状态变更日期
    ,o.accti_status_cd -- 核算状态代码
    ,o.last_accti_status_cd -- 上一核算状态代码
    ,o.accti_status_modif_dt -- 核算状态变更日期
    ,o.clos_acct_dt -- 销户日期
    ,o.clos_acct_rs -- 销户原因
    ,o.init_open_acct_dt -- 原始开户日期
    ,o.init_exp_dt -- 原始到期日期
    ,o.cust_mgr_id -- 客户经理编号
    ,o.bal_type_cd -- 钞汇余额代码
    ,o.off_shore_flg -- 离岸标志
    ,o.ftz_flg -- 自贸区标志
    ,o.loan_tenor -- 贷款期限
    ,o.tenor_type_cd -- 期限类型代码
    ,o.exp_dt -- 到期日期
    ,o.appl_org_id -- 申请机构编号
    ,o.mgmt_org_id -- 管理机构编号
    ,o.cust_name -- 客户名称
    ,o.level5_cls_cd -- 五级分类代码
    ,o.loan_rs_cd -- 贷款原因代码
    ,o.acct_aldy_check_flg -- 账户已复核标志
    ,o.check_dt -- 复核日期
    ,o.repay_way_cd -- 还款方式代码
    ,o.sub_plan_way_cd -- 子计划方式代码
    ,o.open_acct_chn_id -- 开户渠道编号
    ,o.src_module_type_cd -- 源模块类型代码
    ,o.sob_cate_cd -- 账套类别代码
    ,o.indv_bus_flg -- 个体工商户标志
    ,o.int_accr_flg -- 计息标志
    ,o.curr_pd -- 当前期次
    ,o.final_tran_dt -- 最后交易日期
    ,o.anew_create_repay_plan_flg -- 重新生成还款计划标志
    ,o.init_prod_id -- 原产品编号
    ,o.perds -- 首段期数
    ,o.prog_intrv_perds -- 累进间隔期数
    ,o.prog_amt -- 累进金额
    ,o.prog_ratio -- 累进比例
    ,o.loan_auto_repay_type_cd -- 贷款自动还款类型代码
    ,o.loan_pric_repay_seq_num -- 贷款本金还款顺序号
    ,o.loan_int_repay_seq_num -- 贷款利息还款顺序号
    ,o.loan_pnlt_repay_seq_num -- 贷款罚息还款顺序号
    ,o.loan_comp_int_repay_seq_num -- 贷款复利还款顺序号
    ,o.loan_fee_repay_seq_num -- 贷款费用还款顺序号
    ,o.earliest_ovdue_dt -- 最早逾期日期
    ,o.need_manual_input_repay_plan_flg -- 需要手工录入还款计划标志
    ,o.contri_ratio -- 出资比例
    ,o.init_loan_num -- 原贷款号
    ,o.init_distr_flow_num -- 原放款流水号
    ,o.int_sub_closing_dt -- 贴息截止日期
    ,o.chg_term_not_chg_lmt_final_chg_dt -- 变期不变额最后变化日期
    ,o.ftz_acct_flg -- 自贸区账户标志
    ,o.ftz_cd -- 自贸区代码
    ,o.blon_loan_calc_pd -- 气球贷计算期次
    ,o.camp_prod_id -- 营销产品编号
    ,o.camp_prod_name -- 营销产品名称
    ,o.eh_issue_plan_repay_amt -- 每期计划还款金额
    ,o.loan_usage_cd -- 贷款用途代码
    ,o.other_consm_descb -- 其他消费描述
    ,o.repay_plan_modif_way_cd -- 还款计划变更方式代码
    ,o.realtm_chase_capt_flg -- 实时追缴标志
    ,o.wrt_off_post_auto_turn_money_flg -- 核销后自动转款标志
    ,o.clos_acct_teller_id -- 销户柜员编号
    ,o.check_teller_id -- 复核柜员编号
    ,o.open_acct_teller_id -- 开户柜员编号
    ,o.accrd_hours_int_rat -- 按小时利率
    ,o.cust_econ_type_cd -- 客户经济类型代码
    ,o.accrd_hours_file_flg_cd -- 按小时靠档标志代码
    ,o.check_entry_code -- 对账编码
    ,o.auto_comb_repay_flg -- 自动组合还款标志
    ,o.free_int_closing_dt -- 免息截止日期
    ,o.abs_flg -- 资产证券化标志
    ,o.auto_revs_flg -- 自动冲正标志
    ,o.flg_cd -- 资产转让标志
    ,o.cust_type_cd -- 客户类型代码
    ,o.acct_type_cd -- 账户类型代码
    ,o.clos_acct_type_cd -- 销户类型代码
    ,o.loan_clos_acct_rs -- 贷款销户原因
    ,o.auto_payoff_flg -- 自动结清标志
    ,o.final_modif_teller_id -- 最后修改柜员编号
    ,o.final_modif_dt -- 最后修改日期
    ,o.init_bus_id -- 原业务编号
    ,o.bar_flg -- 随借随还标志
    ,o.file_int_accr_flg -- 靠档计息标志
    ,o.cert_no -- 证件号码
    ,o.cert_type_cd -- 证件类型代码
    ,o.ld_accti_status_cd -- 上日核算状态代码
    ,o.ld_acct_status_cd -- 上日账户状态代码
    ,o.late_merge_flg -- 末期合并标志
    ,o.refactor_flg -- 再保理标志
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
from ${iml_schema}.agt_loan_acct_info_h_ncbsf1_bk o
    left join ${iml_schema}.agt_loan_acct_info_h_ncbsf1_op n
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
            and o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.agt_loan_acct_info_h_ncbsf1_cl d
        on
            o.agt_id = d.agt_id
            and o.lp_id = d.lp_id
            and o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;
-- 4.1 truncate target table
--truncate table ${iml_schema}.agt_loan_acct_info_h;
--alter table ${iml_schema}.agt_loan_acct_info_h truncate partition for ('ncbsf1') reuse storage;

-- 4.2 rebuild partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
declare
v_sql varchar2(100);
begin
for cur in (select subpartition_name 
              from all_tab_subpartitions 
             where table_owner=upper('${iml_schema}') 
               and table_name=upper('agt_loan_acct_info_h') 
               and substr(subpartition_name,1,8)=upper('p_ncbsf1')
               and substr(subpartition_name,10) >= '${batch_date}' 
               and substr(subpartition_name,10) < '20991231') loop
    v_sql := 'alter table ${iml_schema}.agt_loan_acct_info_h drop subpartition ' || cur.subpartition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/

whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_loan_acct_info_h modify partition p_ncbsf1 
add subpartition p_ncbsf1_${batch_date} values(to_date('${batch_date}','YYYYMMDD')) ;

-- 4.3 exchange partition
alter table ${iml_schema}.agt_loan_acct_info_h exchange subpartition p_ncbsf1_${batch_date} with table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_cl;
alter table ${iml_schema}.agt_loan_acct_info_h exchange subpartition p_ncbsf1_20991231 with table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_loan_acct_info_h to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_tm purge;
drop table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_op purge;
drop table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iml_schema}.agt_loan_acct_info_h_ncbsf1_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_loan_acct_info_h', partname => 'p_ncbsf1_20991231',ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);
