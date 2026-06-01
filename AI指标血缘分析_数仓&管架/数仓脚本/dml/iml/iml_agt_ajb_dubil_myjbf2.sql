/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ajb_dubil_myjbf2
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
drop table ${iml_schema}.agt_ajb_dubil_myjbf2_tm purge;
drop table ${iml_schema}.agt_ajb_dubil_myjbf2_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ajb_dubil add partition p_myjbf2 values ('myjbf2')(
        subpartition p_myjbf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ajb_dubil modify partition p_myjbf2
    add subpartition p_myjbf2_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ajb_dubil_myjbf2_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ajb_dubil partition for ('myjbf2')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ajb_dubil_myjbf2_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,loan_status_cd -- 贷款状态代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_cap_use_position_cd -- 贷款资金使用位置代码
    ,distr_dt -- 放款日期
    ,curr_cd -- 币种代码
    ,distr_amt -- 放款金额
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_cont_tenor -- 贷款合同期限
    ,repay_way_cd -- 还款方式代码
    ,grace_period_days -- 宽限期天数
    ,src_int_rat_type_cd -- 源利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq -- 利率调整周期频率
    ,loan_actl_day_int_rat -- 贷款实际日利率
    ,pric_repay_freq_cd -- 本金还款频率代码
    ,int_repay_freq_cd -- 利息还款频率代码
    ,guar_type_cd -- 担保类型代码
    ,crdt_appl_id -- 授信申请编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,repay_num_type_cd -- 还款帐号类型代码
    ,repay_acct_id -- 还款账户编号
    ,acctnt_dt -- 会计日期
    ,payoff_dt -- 结清日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,next_repay_dt -- 下一还款日期
    ,int_ovdue_days -- 利息逾期天数
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,unpayoff_perds -- 未结清期数
    ,ovdue_pd_cnt -- 逾期期次数
    ,pric_ovdue_days -- 本金逾期天数
    ,cust_id -- 客户编号
    ,cont_status_cd -- 合约状态代码
    ,acru_non_acru_flg -- 应计非应计标志
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,loan_exec_year_int_rat -- 贷款执行年利率
    ,lpr_int_rat -- LPR利率
    ,int_rat_float_spread_val -- 利率浮动点差值
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,white_list_cust_flg -- 白户标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ajb_dubil
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ajb_dubil_myjbf2_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ajb_dubil partition for ('myjbf2') where 0=1;

-- 2.1 insert data to tm table
-- icms_myjb_acc_loan-
insert into ${iml_schema}.agt_ajb_dubil_myjbf2_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,loan_status_cd -- 贷款状态代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_cap_use_position_cd -- 贷款资金使用位置代码
    ,distr_dt -- 放款日期
    ,curr_cd -- 币种代码
    ,distr_amt -- 放款金额
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_cont_tenor -- 贷款合同期限
    ,repay_way_cd -- 还款方式代码
    ,grace_period_days -- 宽限期天数
    ,src_int_rat_type_cd -- 源利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq -- 利率调整周期频率
    ,loan_actl_day_int_rat -- 贷款实际日利率
    ,pric_repay_freq_cd -- 本金还款频率代码
    ,int_repay_freq_cd -- 利息还款频率代码
    ,guar_type_cd -- 担保类型代码
    ,crdt_appl_id -- 授信申请编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,repay_num_type_cd -- 还款帐号类型代码
    ,repay_acct_id -- 还款账户编号
    ,acctnt_dt -- 会计日期
    ,payoff_dt -- 结清日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,next_repay_dt -- 下一还款日期
    ,int_ovdue_days -- 利息逾期天数
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,unpayoff_perds -- 未结清期数
    ,ovdue_pd_cnt -- 逾期期次数
    ,pric_ovdue_days -- 本金逾期天数
    ,cust_id -- 客户编号
    ,cont_status_cd -- 合约状态代码
    ,acru_non_acru_flg -- 应计非应计标志
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,loan_exec_year_int_rat -- 贷款执行年利率
    ,lpr_int_rat -- LPR利率
    ,int_rat_float_spread_val -- 利率浮动点差值
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,white_list_cust_flg -- 白户标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222620'||P1.BILLNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BILLNO -- 借据编号
    ,P1.BIZTYPE -- 产品编号
    ,P1.LOANSTATUS -- 贷款状态代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.LOANUSE END -- 贷款用途代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.USEAREA END -- 贷款资金使用位置代码
    ,${iml_schema}.dateformat_min(substr(P1.ENCASHDATE,1,10)) -- 放款日期
    ,NVL(TRIM(P1.CURRENCY),'CNY') -- 币种代码
    ,P1.LOANAMOUNT -- 放款金额
    ,${iml_schema}.dateformat_min(P1.LOANSTARTDATE) -- 贷款起息日期
    ,${iml_schema}.dateformat_max(P1.LOANENDDATE) -- 贷款到期日期
    ,P1.TOTALTERMS -- 贷款合同期限
    ,P1.REPAYMODE -- 还款方式代码
    ,P1.GRACEDAY -- 宽限期天数
    ,P1.RATETYPE -- 源利率类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||SUBSTR(P1.RATETYPE,1,1) END -- 利率调整方式代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||NVL(SUBSTR(P1.RATETYPE,2),' ') END -- 利率调整周期单位代码
    ,CASE WHEN P1.RATETYPE='F' THEN '0'
     WHEN P1.RATETYPE ='L4' THEN '4' 
     ELSE '1' END -- 利率调整周期频率
    ,P1.DAYRATE*100 -- 贷款实际日利率
    ,NVL(TRIM(P1.PRINREPAYFREQUENCY),'00') -- 本金还款频率代码
    ,NVL(TRIM(P1.INTREPAYFREQUENCY),'00') -- 利息还款频率代码
    ,P1.GUARANTEETYPE -- 担保类型代码
    ,P1.CREDITNO -- 授信申请编号
    ,P1.ENCASHACCTTYPE -- 收款账号类型代码
    ,P1.ENCASHACCTNO -- 收款账户编号
    ,P1.REPAYACCTTYPE -- 还款帐号类型代码
    ,P1.REPAYACCTNO -- 还款账户编号
    ,${iml_schema}.dateformat_max2(P1.SETTLEDATE) -- 会计日期
    ,${iml_schema}.dateformat_max(P1.CLEARDATE) -- 结清日期
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.ASSETCLASS END -- 贷款五级分类代码
    ,${iml_schema}.dateformat_max2(P1.NEXTREPAYDATE) -- 下一还款日期
    ,P1.CAPOVERDUEDAYS -- 利息逾期天数
    ,P1.NORMALBALANCE -- 正常本金余额
    ,P1.OVERDUEBALANCE -- 逾期本金余额
    ,P1.UNCLEARTERMS -- 未结清期数
    ,P1.OVDTERMS -- 逾期期次数
    ,P1.PRINOVDDAYS -- 本金逾期天数
    ,P1.CUSID -- 客户编号
    ,NVL(TRIM(P1.ACCOUNTSTATUS),'-') -- 合约状态代码
    ,P1.ACCRUEDSTATUS -- 应计非应计标志
    ,P1.INTBAL -- 正常利息余额
    ,P1.OVDINTBAL -- 逾期利息余额
    ,P1.OVDPRINPNLTBAL -- 逾期本金罚息余额
    ,P1.OVDINTPNLTBAL -- 逾期利息罚息余额
    ,P1.EXECRATE*100 -- 贷款执行年利率
    ,P1.LPR*100 -- LPR利率
    ,P1.FLOATRATEBP/100 -- 利率浮动点差值
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.RATEFLOATMODE END -- 利率浮动方向代码
    ,nvl(trim(p1.RATELPRTYPE),'-') -- 基准利率类型代码
    ,NVL(TRIM(P1.ASSETTHREETYPECD),'XXX') -- 资产三分类代码
    ,nvl(trim(p1.ISWHITE),'-') -- 白户标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_myjb_acc_loan' -- 源表名称
    ,'myjbf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_myjb_acc_loan p1
    left join ${iol_schema}.rcrs_myjb_acc_loan_clear p2 on p2.BILL_NO=p1.BILLNO and p2.start_dt <= to_date('${batch_date}','yyyymmdd') and p2.end_dt > to_date('${batch_date}','yyyymmdd')
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.LOANUSE = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'ICMS'
        AND R8.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN'
        AND R8.SRC_FIELD_EN_NAME= 'LOANUSE'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'LOAN_USAGE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.USEAREA =R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ICMS'
        AND R5.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN'
        AND R5.SRC_FIELD_EN_NAME= 'USEAREA'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'LOAN_CAP_USE_POSITION_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on SUBSTR(P1.RATETYPE,1,1) = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN'
        AND R3.SRC_FIELD_EN_NAME= 'RATETYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on NVL(SUBSTR(P1.RATETYPE,2),' ') = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ICMS'
        AND R4.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN'
        AND R4.SRC_FIELD_EN_NAME= 'RATETYPE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_PED_CORP_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.ASSETCLASS = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'ICMS'
        AND R7.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN'
        AND R7.SRC_FIELD_EN_NAME= 'ASSETCLASS'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'LOAN_LEVEL5_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.RATEFLOATMODE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'ICMS'
        AND R6.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN'
        AND R6.SRC_FIELD_EN_NAME= 'RATEFLOATMODE'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_FLOAT_DIR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
    and p2.BILL_NO is null 
;
commit;

-- rcrs_myjb_acc_loan_clear-
insert into ${iml_schema}.agt_ajb_dubil_myjbf2_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,loan_status_cd -- 贷款状态代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_cap_use_position_cd -- 贷款资金使用位置代码
    ,distr_dt -- 放款日期
    ,curr_cd -- 币种代码
    ,distr_amt -- 放款金额
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_cont_tenor -- 贷款合同期限
    ,repay_way_cd -- 还款方式代码
    ,grace_period_days -- 宽限期天数
    ,src_int_rat_type_cd -- 源利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq -- 利率调整周期频率
    ,loan_actl_day_int_rat -- 贷款实际日利率
    ,pric_repay_freq_cd -- 本金还款频率代码
    ,int_repay_freq_cd -- 利息还款频率代码
    ,guar_type_cd -- 担保类型代码
    ,crdt_appl_id -- 授信申请编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,repay_num_type_cd -- 还款帐号类型代码
    ,repay_acct_id -- 还款账户编号
    ,acctnt_dt -- 会计日期
    ,payoff_dt -- 结清日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,next_repay_dt -- 下一还款日期
    ,int_ovdue_days -- 利息逾期天数
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,unpayoff_perds -- 未结清期数
    ,ovdue_pd_cnt -- 逾期期次数
    ,pric_ovdue_days -- 本金逾期天数
    ,cust_id -- 客户编号
    ,cont_status_cd -- 合约状态代码
    ,acru_non_acru_flg -- 应计非应计标志
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,loan_exec_year_int_rat -- 贷款执行年利率
    ,lpr_int_rat -- LPR利率
    ,int_rat_float_spread_val -- 利率浮动点差值
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,white_list_cust_flg -- 白户标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222620'||P1.BILL_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BILL_NO -- 借据编号
    ,'202010100001' -- 产品编号
    ,P1.LOAN_STATUS -- 贷款状态代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.LOAN_USE END -- 贷款用途代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.USE_AREA END -- 贷款资金使用位置代码
    ,${iml_schema}.dateformat_min(substr(P1.ENCASH_DATE,1,10)) -- 放款日期
    ,NVL(TRIM(P1.CURRENCY),'CNY') -- 币种代码
    ,P1.LOAN_AMOUNT -- 放款金额
    ,${iml_schema}.dateformat_min(P1.LOAN_START_DATE) -- 贷款起息日期
    ,${iml_schema}.dateformat_max(P1.LOAN_END_DATE) -- 贷款到期日期
    ,P1.TOTAL_TERMS -- 贷款合同期限
    ,P1.REPAY_MODE -- 还款方式代码
    ,P1.GRACE_DAY -- 宽限期天数
    ,P1.RATE_TYPE -- 源利率类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||SUBSTR(P1.RATE_TYPE,1,1) END -- 利率调整方式代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||NVL(SUBSTR(P1.RATE_TYPE,2),' ') END -- 利率调整周期单位代码
    ,CASE WHEN P1.RATE_TYPE='F' THEN '0'
     WHEN P1.RATE_TYPE ='L4' THEN '4' 
     ELSE '1' END -- 利率调整周期频率
    ,P1.DAY_RATE*100 -- 贷款实际日利率
    ,NVL(TRIM(P1.PRIN_REPAY_FREQUENCY),'00') -- 本金还款频率代码
    ,NVL(TRIM(P1.INT_REPAY_FREQUENCY),'00') -- 利息还款频率代码
    ,P1.GUARANTEE_TYPE -- 担保类型代码
    ,P1.CREDIT_NO -- 授信申请编号
    ,P1.ENCASH_ACCT_TYPE -- 收款账号类型代码
    ,P1.ENCASH_ACCT_NO -- 收款账户编号
    ,P1.REPAY_ACCT_TYPE -- 还款帐号类型代码
    ,P1.REPAY_ACCT_NO -- 还款账户编号
    ,${iml_schema}.dateformat_max2(P1.SETTLE_DATE) -- 会计日期
    ,${iml_schema}.dateformat_max(P1.CLEAR_DATE) -- 结清日期
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.ASSET_CLASS END -- 贷款五级分类代码
    ,${iml_schema}.dateformat_max2(P1.NEXT_REPAY_DATE) -- 下一还款日期
    ,P1.CAP_OVERDUE_DAYS -- 利息逾期天数
    ,P1.NORMAL_BALANCE -- 正常本金余额
    ,P1.OVERDUE_BALANCE -- 逾期本金余额
    ,P1.UNCLEAR_TERMS -- 未结清期数
    ,P1.OVD_TERMS -- 逾期期次数
    ,P1.PRIN_OVD_DAYS -- 本金逾期天数
    ,P1.CUS_ID -- 客户编号
    ,NVL(TRIM(P1.ACCOUNT_STATUS),'-') -- 合约状态代码
    ,P1.ACCRUED_STATUS -- 应计非应计标志
    ,P1.INT_BAL -- 正常利息余额
    ,P1.OVD_INT_BAL -- 逾期利息余额
    ,P1.OVD_PRIN_PNLT_BAL -- 逾期本金罚息余额
    ,P1.OVD_INT_PNLT_BAL -- 逾期利息罚息余额
    ,P1.EXEC_RATE*100 -- 贷款执行年利率
    ,P1.LPR*100 -- LPR利率
    ,P1.FLOAT_RATE_BP/100 -- 利率浮动点差值
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.RATE_FLOAT_MODE END -- 利率浮动方向代码
    ,case when p1.RATE_LPRTYPE='1' then '4000' when p1.RATE_LPRTYPE='2' then '2231' else '-' end -- 基准利率类型代码
    ,NVL(TRIM(P1.ASSET_THREE_TYPE_CD),'XXX') -- 资产三分类代码
    ,nvl(trim(p1.IS_WHITE),'-') -- 白户标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_myjb_acc_loan_clear' -- 源表名称
    ,'myjbf2' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_myjb_acc_loan_clear p1
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.LOAN_USE = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'ICMS'
        AND R8.SRC_TAB_EN_NAME= 'RCRS_MYJB_ACC_LOAN_CLEAR'
        AND R8.SRC_FIELD_EN_NAME= 'LOAN_USE'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'LOAN_USAGE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.USE_AREA = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'ICMS'
        AND R5.SRC_TAB_EN_NAME= 'RCRS_MYJB_ACC_LOAN_CLEAR'
        AND R5.SRC_FIELD_EN_NAME= 'USE_AREA'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'LOAN_CAP_USE_POSITION_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on SUBSTR(P1.RATE_TYPE,1,1) = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'RCRS_MYJB_ACC_LOAN_CLEAR'
        AND R3.SRC_FIELD_EN_NAME= 'RATE_TYPE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on NVL(SUBSTR(P1.RATE_TYPE,2),' ') = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ICMS'
        AND R4.SRC_TAB_EN_NAME= 'RCRS_MYJB_ACC_LOAN_CLEAR'
        AND R4.SRC_FIELD_EN_NAME= 'RATE_TYPE'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_PED_CORP_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.ASSET_CLASS = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'ICMS'
        AND R7.SRC_TAB_EN_NAME= 'RCRS_MYJB_ACC_LOAN_CLEAR'
        AND R7.SRC_FIELD_EN_NAME= 'ASSET_CLASS'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'LOAN_LEVEL5_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.RATE_FLOAT_MODE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'ICMS'
        AND R6.SRC_TAB_EN_NAME= 'RCRS_MYJB_ACC_LOAN_CLEAR'
        AND R6.SRC_FIELD_EN_NAME= 'RATE_FLOAT_MODE'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_AJB_DUBIL'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_FLOAT_DIR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ajb_dubil_myjbf2_tm 
  	                                group by 
  	                                        agt_id
  	                                        ,lp_id
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

-- 2.2 chage data and update_dt, create_dt, etl_dt
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iml_schema}.agt_ajb_dubil_myjbf2_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,loan_status_cd -- 贷款状态代码
    ,loan_usage_cd -- 贷款用途代码
    ,loan_cap_use_position_cd -- 贷款资金使用位置代码
    ,distr_dt -- 放款日期
    ,curr_cd -- 币种代码
    ,distr_amt -- 放款金额
    ,loan_value_dt -- 贷款起息日期
    ,loan_exp_dt -- 贷款到期日期
    ,loan_cont_tenor -- 贷款合同期限
    ,repay_way_cd -- 还款方式代码
    ,grace_period_days -- 宽限期天数
    ,src_int_rat_type_cd -- 源利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_ped_freq -- 利率调整周期频率
    ,loan_actl_day_int_rat -- 贷款实际日利率
    ,pric_repay_freq_cd -- 本金还款频率代码
    ,int_repay_freq_cd -- 利息还款频率代码
    ,guar_type_cd -- 担保类型代码
    ,crdt_appl_id -- 授信申请编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,repay_num_type_cd -- 还款帐号类型代码
    ,repay_acct_id -- 还款账户编号
    ,acctnt_dt -- 会计日期
    ,payoff_dt -- 结清日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,next_repay_dt -- 下一还款日期
    ,int_ovdue_days -- 利息逾期天数
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,unpayoff_perds -- 未结清期数
    ,ovdue_pd_cnt -- 逾期期次数
    ,pric_ovdue_days -- 本金逾期天数
    ,cust_id -- 客户编号
    ,cont_status_cd -- 合约状态代码
    ,acru_non_acru_flg -- 应计非应计标志
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,loan_exec_year_int_rat -- 贷款执行年利率
    ,lpr_int_rat -- LPR利率
    ,int_rat_float_spread_val -- 利率浮动点差值
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,white_list_cust_flg -- 白户标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.agt_id, o.agt_id) as agt_id -- 协议编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.loan_status_cd, o.loan_status_cd) as loan_status_cd -- 贷款状态代码
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.loan_cap_use_position_cd, o.loan_cap_use_position_cd) as loan_cap_use_position_cd -- 贷款资金使用位置代码
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 放款日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.distr_amt, o.distr_amt) as distr_amt -- 放款金额
    ,nvl(n.loan_value_dt, o.loan_value_dt) as loan_value_dt -- 贷款起息日期
    ,nvl(n.loan_exp_dt, o.loan_exp_dt) as loan_exp_dt -- 贷款到期日期
    ,nvl(n.loan_cont_tenor, o.loan_cont_tenor) as loan_cont_tenor -- 贷款合同期限
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.grace_period_days, o.grace_period_days) as grace_period_days -- 宽限期天数
    ,nvl(n.src_int_rat_type_cd, o.src_int_rat_type_cd) as src_int_rat_type_cd -- 源利率类型代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_adj_ped_corp_cd, o.int_rat_adj_ped_corp_cd) as int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,nvl(n.int_rat_adj_ped_freq, o.int_rat_adj_ped_freq) as int_rat_adj_ped_freq -- 利率调整周期频率
    ,nvl(n.loan_actl_day_int_rat, o.loan_actl_day_int_rat) as loan_actl_day_int_rat -- 贷款实际日利率
    ,nvl(n.pric_repay_freq_cd, o.pric_repay_freq_cd) as pric_repay_freq_cd -- 本金还款频率代码
    ,nvl(n.int_repay_freq_cd, o.int_repay_freq_cd) as int_repay_freq_cd -- 利息还款频率代码
    ,nvl(n.guar_type_cd, o.guar_type_cd) as guar_type_cd -- 担保类型代码
    ,nvl(n.crdt_appl_id, o.crdt_appl_id) as crdt_appl_id -- 授信申请编号
    ,nvl(n.recvbl_num_type_cd, o.recvbl_num_type_cd) as recvbl_num_type_cd -- 收款账号类型代码
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.repay_num_type_cd, o.repay_num_type_cd) as repay_num_type_cd -- 还款帐号类型代码
    ,nvl(n.repay_acct_id, o.repay_acct_id) as repay_acct_id -- 还款账户编号
    ,nvl(n.acctnt_dt, o.acctnt_dt) as acctnt_dt -- 会计日期
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.loan_level5_cls_cd, o.loan_level5_cls_cd) as loan_level5_cls_cd -- 贷款五级分类代码
    ,nvl(n.next_repay_dt, o.next_repay_dt) as next_repay_dt -- 下一还款日期
    ,nvl(n.int_ovdue_days, o.int_ovdue_days) as int_ovdue_days -- 利息逾期天数
    ,nvl(n.nomal_pric_bal, o.nomal_pric_bal) as nomal_pric_bal -- 正常本金余额
    ,nvl(n.ovdue_pric_bal, o.ovdue_pric_bal) as ovdue_pric_bal -- 逾期本金余额
    ,nvl(n.unpayoff_perds, o.unpayoff_perds) as unpayoff_perds -- 未结清期数
    ,nvl(n.ovdue_pd_cnt, o.ovdue_pd_cnt) as ovdue_pd_cnt -- 逾期期次数
    ,nvl(n.pric_ovdue_days, o.pric_ovdue_days) as pric_ovdue_days -- 本金逾期天数
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cont_status_cd, o.cont_status_cd) as cont_status_cd -- 合约状态代码
    ,nvl(n.acru_non_acru_flg, o.acru_non_acru_flg) as acru_non_acru_flg -- 应计非应计标志
    ,nvl(n.nomal_int_bal, o.nomal_int_bal) as nomal_int_bal -- 正常利息余额
    ,nvl(n.ovdue_int_bal, o.ovdue_int_bal) as ovdue_int_bal -- 逾期利息余额
    ,nvl(n.ovdue_pric_pnlt_bal, o.ovdue_pric_pnlt_bal) as ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,nvl(n.ovdue_int_pnlt_bal, o.ovdue_int_pnlt_bal) as ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,nvl(n.loan_exec_year_int_rat, o.loan_exec_year_int_rat) as loan_exec_year_int_rat -- 贷款执行年利率
    ,nvl(n.lpr_int_rat, o.lpr_int_rat) as lpr_int_rat -- LPR利率
    ,nvl(n.int_rat_float_spread_val, o.int_rat_float_spread_val) as int_rat_float_spread_val -- 利率浮动点差值
    ,nvl(n.int_rat_float_dir_cd, o.int_rat_float_dir_cd) as int_rat_float_dir_cd -- 利率浮动方向代码
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.white_list_cust_flg, o.white_list_cust_flg) as white_list_cust_flg -- 白户标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.dubil_id <> n.dubil_id
                or o.prod_id <> n.prod_id
                or o.loan_status_cd <> n.loan_status_cd
                or o.loan_usage_cd <> n.loan_usage_cd
                or o.loan_cap_use_position_cd <> n.loan_cap_use_position_cd
                or o.distr_dt <> n.distr_dt
                or o.curr_cd <> n.curr_cd
                or o.distr_amt <> n.distr_amt
                or o.loan_value_dt <> n.loan_value_dt
                or o.loan_exp_dt <> n.loan_exp_dt
                or o.loan_cont_tenor <> n.loan_cont_tenor
                or o.repay_way_cd <> n.repay_way_cd
                or o.grace_period_days <> n.grace_period_days
                or o.src_int_rat_type_cd <> n.src_int_rat_type_cd
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.int_rat_adj_ped_corp_cd <> n.int_rat_adj_ped_corp_cd
                or o.int_rat_adj_ped_freq <> n.int_rat_adj_ped_freq
                or o.loan_actl_day_int_rat <> n.loan_actl_day_int_rat
                or o.pric_repay_freq_cd <> n.pric_repay_freq_cd
                or o.int_repay_freq_cd <> n.int_repay_freq_cd
                or o.guar_type_cd <> n.guar_type_cd
                or o.crdt_appl_id <> n.crdt_appl_id
                or o.recvbl_num_type_cd <> n.recvbl_num_type_cd
                or o.recvbl_acct_id <> n.recvbl_acct_id
                or o.repay_num_type_cd <> n.repay_num_type_cd
                or o.repay_acct_id <> n.repay_acct_id
                or o.acctnt_dt <> n.acctnt_dt
                or o.payoff_dt <> n.payoff_dt
                or o.loan_level5_cls_cd <> n.loan_level5_cls_cd
                or o.next_repay_dt <> n.next_repay_dt
                or o.int_ovdue_days <> n.int_ovdue_days
                or o.nomal_pric_bal <> n.nomal_pric_bal
                or o.ovdue_pric_bal <> n.ovdue_pric_bal
                or o.unpayoff_perds <> n.unpayoff_perds
                or o.ovdue_pd_cnt <> n.ovdue_pd_cnt
                or o.pric_ovdue_days <> n.pric_ovdue_days
                or o.cust_id <> n.cust_id
                or o.cont_status_cd <> n.cont_status_cd
                or o.acru_non_acru_flg <> n.acru_non_acru_flg
                or o.nomal_int_bal <> n.nomal_int_bal
                or o.ovdue_int_bal <> n.ovdue_int_bal
                or o.ovdue_pric_pnlt_bal <> n.ovdue_pric_pnlt_bal
                or o.ovdue_int_pnlt_bal <> n.ovdue_int_pnlt_bal
                or o.loan_exec_year_int_rat <> n.loan_exec_year_int_rat
                or o.lpr_int_rat <> n.lpr_int_rat
                or o.int_rat_float_spread_val <> n.int_rat_float_spread_val
                or o.int_rat_float_dir_cd <> n.int_rat_float_dir_cd
                or o.base_rat_type_cd <> n.base_rat_type_cd
                or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
                or o.white_list_cust_flg <> n.white_list_cust_flg
            ) or (
                 case when (
                           n.agt_id is null
                           and n.lp_id is null
                         )
                      then 'D'
                 else 'I'
                 end
            )<> o.id_mark
        then to_date('${batch_date}', 'yyyymmdd')
        else o.update_dt
     end as update_dt -- 更新日期
    ,to_date('${batch_date}', 'yyyymmdd') as etl_dt -- ETL处理日期
    ,case when (
                n.agt_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_ajb_dubil_myjbf2_tm n
    full join ${iml_schema}.agt_ajb_dubil_myjbf2_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ajb_dubil truncate partition for ('myjbf2') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ajb_dubil exchange subpartition p_myjbf2_${batch_date} with table ${iml_schema}.agt_ajb_dubil_myjbf2_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ajb_dubil drop subpartition p_myjbf2_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ajb_dubil to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_ajb_dubil_myjbf2_tm purge;
drop table ${iml_schema}.agt_ajb_dubil_myjbf2_ex purge;
drop table ${iml_schema}.agt_ajb_dubil_myjbf2_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ajb_dubil', partname => 'p_myjbf2_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);