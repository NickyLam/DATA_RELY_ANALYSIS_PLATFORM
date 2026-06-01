/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_jd_loan_dubil_info_jdjrf1
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
drop table ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_tm purge;
drop table ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_jd_loan_dubil_info add partition p_jdjrf1 values ('jdjrf1')(
        subpartition p_jdjrf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_jd_loan_dubil_info modify partition p_jdjrf1
    add subpartition p_jdjrf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_jd_loan_dubil_info partition for ('jdjrf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_cust_id -- 外部客户编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,loan_status_cd -- 借据状态代码
    ,distr_dt -- 放款日期
    ,loan_distr_amt -- 放款金额
    ,bus_exp_dt -- 到期日期
    ,loan_cap_use_position_cd -- 资金使用位置代码
    ,pric_repay_freq_cd -- 本金还款频率代码
    ,pric_repay_freq -- 本金还款频率
    ,pric_repay_ped_corp_cd -- 本金还款周期单位代码
    ,int_repay_freq_cd -- 利息还款频率代码
    ,int_repay_freq -- 利息还款频率
    ,int_repay_ped_corp_cd -- 利息还款周期单位代码
    ,self_pay_amt -- 自主支付金额
    ,entr_pay_amt -- 受托支付金额
    ,loan_ovdue_flg -- 逾期标志
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_grace_days -- 逾期宽限天数
    ,pric_ovdue_dt -- 本金逾期日期
    ,int_ovdue_dt -- 利息逾期日期
    ,next_pay_int_day -- 下一付息日
    ,jd_loan_int_rat_type_cd -- 贷款利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_freq -- 利率调整频率
    ,loan_bal -- 贷款余额
    ,ovdue_loan_bal -- 逾期贷款余额
    ,ovdue_int_bal -- 逾期利息
    ,off_bs_over_int_bal -- 表外欠息
    ,int_accr_flg -- 计息标志
    ,acru_int_amt -- 应计利息
    ,td_int_amt -- 当日应计利息
    ,td_pnlt_amt -- 当日罚息
    ,loan_enter_acct_num -- 贷款入账账号
    ,loan_repay_num -- 贷款还款账号
    ,loan_guar_way_cd -- 担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,loan_int_rat -- 贷款利率
    ,loan_pnlt_int_rat -- 贷款罚息利率
    ,borw_int_rat_type_cd -- 贷款利率周期代码
    ,pnlt_int_rat_type_cd -- 罚息利率周期代码
    ,distr_flow_num -- 放款流水号
    ,loan_usage_cd -- 贷款用途代码
    ,loan_exec_int_rat -- 贷款执行利率
    ,borw_exec_int_rat_type_cd -- 执行利率周期代码
    ,loan_perds -- 贷款期数
    ,prep_repay_perds -- 待还期数
    ,ovdue_perds -- 逾期期数
    ,off_bs_perds -- 表外期数
    ,acru_pnlt_amt -- 应计罚息
    ,cust_id -- 客户编号
    ,belong_cust_mgr_id -- 所属客户经理编号
    ,loan_exec_year_int_rat -- 执行年利率
    ,lpr_int_rat -- LPR利率
    ,int_rat_float_spread_val -- 利率浮动点差值
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,prod_id -- 产品编号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,white_list_cust_flg -- 白户标志
    ,payoff_dt -- 结清日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_jd_loan_dubil_info
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_jd_loan_dubil_info partition for ('jdjrf1') where 0=1;

-- 2.1 insert data to tm table
-- icms_jdjr_acc_loan-
insert into ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_cust_id -- 外部客户编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,loan_status_cd -- 借据状态代码
    ,distr_dt -- 放款日期
    ,loan_distr_amt -- 放款金额
    ,bus_exp_dt -- 到期日期
    ,loan_cap_use_position_cd -- 资金使用位置代码
    ,pric_repay_freq_cd -- 本金还款频率代码
    ,pric_repay_freq -- 本金还款频率
    ,pric_repay_ped_corp_cd -- 本金还款周期单位代码
    ,int_repay_freq_cd -- 利息还款频率代码
    ,int_repay_freq -- 利息还款频率
    ,int_repay_ped_corp_cd -- 利息还款周期单位代码
    ,self_pay_amt -- 自主支付金额
    ,entr_pay_amt -- 受托支付金额
    ,loan_ovdue_flg -- 逾期标志
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_grace_days -- 逾期宽限天数
    ,pric_ovdue_dt -- 本金逾期日期
    ,int_ovdue_dt -- 利息逾期日期
    ,next_pay_int_day -- 下一付息日
    ,jd_loan_int_rat_type_cd -- 贷款利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_freq -- 利率调整频率
    ,loan_bal -- 贷款余额
    ,ovdue_loan_bal -- 逾期贷款余额
    ,ovdue_int_bal -- 逾期利息
    ,off_bs_over_int_bal -- 表外欠息
    ,int_accr_flg -- 计息标志
    ,acru_int_amt -- 应计利息
    ,td_int_amt -- 当日应计利息
    ,td_pnlt_amt -- 当日罚息
    ,loan_enter_acct_num -- 贷款入账账号
    ,loan_repay_num -- 贷款还款账号
    ,loan_guar_way_cd -- 担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,loan_int_rat -- 贷款利率
    ,loan_pnlt_int_rat -- 贷款罚息利率
    ,borw_int_rat_type_cd -- 贷款利率周期代码
    ,pnlt_int_rat_type_cd -- 罚息利率周期代码
    ,distr_flow_num -- 放款流水号
    ,loan_usage_cd -- 贷款用途代码
    ,loan_exec_int_rat -- 贷款执行利率
    ,borw_exec_int_rat_type_cd -- 执行利率周期代码
    ,loan_perds -- 贷款期数
    ,prep_repay_perds -- 待还期数
    ,ovdue_perds -- 逾期期数
    ,off_bs_perds -- 表外期数
    ,acru_pnlt_amt -- 应计罚息
    ,cust_id -- 客户编号
    ,belong_cust_mgr_id -- 所属客户经理编号
    ,loan_exec_year_int_rat -- 执行年利率
    ,lpr_int_rat -- LPR利率
    ,int_rat_float_spread_val -- 利率浮动点差值
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,prod_id -- 产品编号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,white_list_cust_flg -- 白户标志
    ,payoff_dt -- 结清日期
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222304'||P1.CONTNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONTNO -- 合同编号
    ,P1.CUSNO -- 外部客户编号
    ,P1.PRDNO -- 京东产品代码
    ,P1.LIMITNO -- 客户额度编号
    ,P1.LOANNO -- 借据编号
    ,nvl(trim(P1.CURRENCY),'-') -- 币种代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.LOANSTATUS END -- 借据状态代码
    ,CASE WHEN P1.PRDNO ='01' THEN ${iml_schema}.dateformat_min(P1.LOANSUCESSRECEIVEDATE)
     WHEN P1.PRDNO ='03' THEN ${iml_schema}.dateformat_min(P1.LOANSTARTDT)
     ELSE ${iml_schema}.dateformat_min(NULL)
     END -- 放款日期
    ,P1.LOANAMT -- 放款金额
    ,${iml_schema}.dateformat_max2(trim(P1.LOANENDDT)) -- 到期日期
    ,P1.LOCALAREA -- 资金使用位置代码
    ,nvl(trim(P1.REPAYPRINHZ),'00') -- 本金还款频率代码
    ,CASE WHEN P1.REPAYPRINHZ='01' THEN '1' WHEN P1.REPAYPRINHZ='02' THEN '1' WHEN P1.REPAYPRINHZ='03' THEN '1' WHEN P1.REPAYPRINHZ='04' THEN '1' WHEN P1.REPAYPRINHZ='05' THEN '6' WHEN P1.REPAYPRINHZ='06' THEN '1'  ELSE '0' END -- 本金还款频率
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.REPAYPRINHZ END -- 本金还款周期单位代码
    ,nvl(trim(P1.REPAYINTHZ),'00') -- 利息还款频率代码
    ,CASE WHEN P1.REPAYINTHZ='01' THEN '1' WHEN P1.REPAYINTHZ='02' THEN '1' WHEN P1.REPAYINTHZ='03' THEN '1' WHEN P1.REPAYINTHZ='04' THEN '1' WHEN P1.REPAYINTHZ='05' THEN '6' WHEN P1.REPAYINTHZ='06' THEN '1'  ELSE '0' END -- 利息还款频率
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.REPAYINTHZ END -- 利息还款周期单位代码
    ,P1.SELFPAYAMT -- 自主支付金额
    ,P1.ENTRUSTEDPAYAMT -- 受托支付金额
    ,P1.OVDFLAG -- 逾期标志
    ,P1.OVDDAYS -- 贷款逾期天数
    ,P1.EXTENDDAYS -- 逾期宽限天数
    ,${iml_schema}.dateformat_max2(trim(P1.PRINOVDSTARTDT)) -- 本金逾期日期
    ,${iml_schema}.dateformat_max2(trim(P1.INTOVDSTARTDT)) -- 利息逾期日期
    ,${iml_schema}.dateformat_max2(trim(P1.INTNEXTPAYDT)) -- 下一付息日
    ,P1.RATETYPE -- 贷款利率类型代码
    ,CASE WHEN R9.TARGET_CD_VAL IS NOT NULL THEN R9.TARGET_CD_VAL ELSE '@'||P1.RATETYPE END -- 利率调整方式代码
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||P1.RATETYPE END -- 利率调整周期单位代码
    ,CASE WHEN P1.RATETYPE='F' THEN '0'
   WHEN P1.RATETYPE='L0' THEN '1'
   WHEN P1.RATETYPE='L1' THEN '1'
   WHEN P1.RATETYPE='L2' THEN '1'
   WHEN P1.RATETYPE='L3' THEN '1'
   WHEN P1.RATETYPE='L4' THEN '6'
   WHEN P1.RATETYPE='L5' THEN '1'
   WHEN P1.RATETYPE='L9' THEN '0'
ELSE P1.RATETYPE END -- 利率调整频率
    ,P1.LOANBALANCE -- 贷款余额
    ,P1.LOANOVDBALANCE -- 逾期贷款余额
    ,P1.LOANOVDINTBALANCE -- 逾期利息
    ,P1.LOANOUTINTBALANCE -- 表外欠息
    ,decode(trim(P1.INTFLAG),'Y','1','N','0','','-' )-- 计息标志
    ,P1.INTAMT -- 应计利息
    ,P1.TODAYINTAMT -- 当日应计利息
    ,P1.TODAYPNLTINTAMT -- 当日罚息
    ,P1.LOANINNERACCOUNT -- 贷款入账账号
    ,P1.LOANREPAYACCOUNT -- 贷款还款账号
    ,nvl(trim(P1.GRANTTYPE),'-') -- 担保方式代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.REPAYTYPE END -- 还款方式代码
    ,P1.LOANRATE*100 -- 贷款利率
    ,P1.PNLTRATE*100 -- 贷款罚息利率
    ,P1.LOANRATETYPE -- 贷款利率周期代码
    ,P1.PNLTRATETYPE -- 罚息利率周期代码
    ,P1.LOANSERNO -- 放款流水号
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.LOANUSEWAY END -- 贷款用途代码
    ,P1.LAONREALITYRATE*100 -- 贷款执行利率
    ,P1.LAONREALITYRATETYPE -- 执行利率周期代码
    ,P1.LOANTERMS -- 贷款期数
    ,P1.UNREPAYSTERMS -- 待还期数
    ,P1.OVDTERMS -- 逾期期数
    ,P1.OUTTERMS -- 表外期数
    ,P1.INPNLTAMT -- 应计罚息
    ,P1.CUSID -- 客户编号
    ,P1.INPUTID -- 所属客户经理编号
    ,P1.EXECRATE*100 -- 执行年利率
    ,P1.LPR*100 -- LPR利率
    ,P1.FLOATRATEBP/100 -- 利率浮动点差值
    ,nvl(trim(P1.RATEFLOATMODE),'-')  -- 利率浮动方向代码
    ,nvl(trim(p1.RATELPRTYPE),'-') -- 基准利率类型代码  
    ,P1.PRDCODE -- 产品编号
    ,NVL(TRIM(P1.ASSETTHREETYPECD),'XXX') -- 资产三分类代码
    ,NVL(TRIM(P1.ISWHITE),'-') -- 白户标志
    ,${iml_schema}.timeformat_max(P1.CLEARDATE) -- 结清日期
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_jdjr_acc_loan' -- 源表名称
    ,'jdjrf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_jdjr_acc_loan p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.LOANSTATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_JDJR_ACC_LOAN'
        AND R1.SRC_FIELD_EN_NAME= 'LOANSTATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_JD_LOAN_DUBIL_INFO'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LOAN_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.REPAYPRINHZ = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'ICMS'
        AND R7.SRC_TAB_EN_NAME= 'ICMS_JDJR_ACC_LOAN'
        AND R7.SRC_FIELD_EN_NAME= 'REPAYPRINHZ'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_JD_LOAN_DUBIL_INFO'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'PRIC_REPAY_PED_CORP_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.REPAYINTHZ = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'ICMS'
        AND R8.SRC_TAB_EN_NAME= 'ICMS_JDJR_ACC_LOAN'
        AND R8.SRC_FIELD_EN_NAME= 'REPAYINTHZ'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_JD_LOAN_DUBIL_INFO'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'INT_REPAY_PED_CORP_CD'
    left join ${iml_schema}.ref_pub_cd_map r9 on P1.RATETYPE = R9.SRC_CODE_VAL
        AND R9.SORC_SYS_CD= 'ICMS'
        AND R9.SRC_TAB_EN_NAME= 'ICMS_JDJR_ACC_LOAN'
        AND R9.SRC_FIELD_EN_NAME= 'RATETYPE'
        AND R9.TARGET_TAB_EN_NAME= 'AGT_JD_LOAN_DUBIL_INFO'
        AND R9.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r10 on P1.RATETYPE = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'ICMS'
        AND R10.SRC_TAB_EN_NAME= 'ICMS_JDJR_ACC_LOAN'
        AND R10.SRC_FIELD_EN_NAME= 'RATETYPE'
        AND R10.TARGET_TAB_EN_NAME= 'AGT_JD_LOAN_DUBIL_INFO'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_PED_CORP_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.REPAYTYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_JDJR_ACC_LOAN'
        AND R2.SRC_FIELD_EN_NAME= 'REPAYTYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_JD_LOAN_DUBIL_INFO'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'REPAY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.LOANUSEWAY = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_JDJR_ACC_LOAN'
        AND R3.SRC_FIELD_EN_NAME= 'LOANUSEWAY'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_JD_LOAN_DUBIL_INFO'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'LOAN_USAGE_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,jd_cust_id -- 外部客户编号
    ,jd_prod_cd -- 京东产品代码
    ,cust_lmt_id -- 客户额度编号
    ,dubil_id -- 借据编号
    ,curr_cd -- 币种代码
    ,loan_status_cd -- 借据状态代码
    ,distr_dt -- 放款日期
    ,loan_distr_amt -- 放款金额
    ,bus_exp_dt -- 到期日期
    ,loan_cap_use_position_cd -- 资金使用位置代码
    ,pric_repay_freq_cd -- 本金还款频率代码
    ,pric_repay_freq -- 本金还款频率
    ,pric_repay_ped_corp_cd -- 本金还款周期单位代码
    ,int_repay_freq_cd -- 利息还款频率代码
    ,int_repay_freq -- 利息还款频率
    ,int_repay_ped_corp_cd -- 利息还款周期单位代码
    ,self_pay_amt -- 自主支付金额
    ,entr_pay_amt -- 受托支付金额
    ,loan_ovdue_flg -- 逾期标志
    ,ovdue_days -- 贷款逾期天数
    ,ovdue_grace_days -- 逾期宽限天数
    ,pric_ovdue_dt -- 本金逾期日期
    ,int_ovdue_dt -- 利息逾期日期
    ,next_pay_int_day -- 下一付息日
    ,jd_loan_int_rat_type_cd -- 贷款利率类型代码
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,int_rat_adj_freq -- 利率调整频率
    ,loan_bal -- 贷款余额
    ,ovdue_loan_bal -- 逾期贷款余额
    ,ovdue_int_bal -- 逾期利息
    ,off_bs_over_int_bal -- 表外欠息
    ,int_accr_flg -- 计息标志
    ,acru_int_amt -- 应计利息
    ,td_int_amt -- 当日应计利息
    ,td_pnlt_amt -- 当日罚息
    ,loan_enter_acct_num -- 贷款入账账号
    ,loan_repay_num -- 贷款还款账号
    ,loan_guar_way_cd -- 担保方式代码
    ,repay_way_cd -- 还款方式代码
    ,loan_int_rat -- 贷款利率
    ,loan_pnlt_int_rat -- 贷款罚息利率
    ,borw_int_rat_type_cd -- 贷款利率周期代码
    ,pnlt_int_rat_type_cd -- 罚息利率周期代码
    ,distr_flow_num -- 放款流水号
    ,loan_usage_cd -- 贷款用途代码
    ,loan_exec_int_rat -- 贷款执行利率
    ,borw_exec_int_rat_type_cd -- 执行利率周期代码
    ,loan_perds -- 贷款期数
    ,prep_repay_perds -- 待还期数
    ,ovdue_perds -- 逾期期数
    ,off_bs_perds -- 表外期数
    ,acru_pnlt_amt -- 应计罚息
    ,cust_id -- 客户编号
    ,belong_cust_mgr_id -- 所属客户经理编号
    ,loan_exec_year_int_rat -- 执行年利率
    ,lpr_int_rat -- LPR利率
    ,int_rat_float_spread_val -- 利率浮动点差值
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,base_rat_type_cd -- 基准利率类型代码
    ,prod_id -- 产品编号
    ,asset_thd_cls_cd -- 资产三分类代码
    ,white_list_cust_flg -- 白户标志
    ,payoff_dt -- 结清日期
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
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.jd_cust_id, o.jd_cust_id) as jd_cust_id -- 外部客户编号
    ,nvl(n.jd_prod_cd, o.jd_prod_cd) as jd_prod_cd -- 京东产品代码
    ,nvl(n.cust_lmt_id, o.cust_lmt_id) as cust_lmt_id -- 客户额度编号
    ,nvl(n.dubil_id, o.dubil_id) as dubil_id -- 借据编号
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.loan_status_cd, o.loan_status_cd) as loan_status_cd -- 借据状态代码
    ,nvl(n.distr_dt, o.distr_dt) as distr_dt -- 放款日期
    ,nvl(n.loan_distr_amt, o.loan_distr_amt) as loan_distr_amt -- 放款金额
    ,nvl(n.bus_exp_dt, o.bus_exp_dt) as bus_exp_dt -- 到期日期
    ,nvl(n.loan_cap_use_position_cd, o.loan_cap_use_position_cd) as loan_cap_use_position_cd -- 资金使用位置代码
    ,nvl(n.pric_repay_freq_cd, o.pric_repay_freq_cd) as pric_repay_freq_cd -- 本金还款频率代码
    ,nvl(n.pric_repay_freq, o.pric_repay_freq) as pric_repay_freq -- 本金还款频率
    ,nvl(n.pric_repay_ped_corp_cd, o.pric_repay_ped_corp_cd) as pric_repay_ped_corp_cd -- 本金还款周期单位代码
    ,nvl(n.int_repay_freq_cd, o.int_repay_freq_cd) as int_repay_freq_cd -- 利息还款频率代码
    ,nvl(n.int_repay_freq, o.int_repay_freq) as int_repay_freq -- 利息还款频率
    ,nvl(n.int_repay_ped_corp_cd, o.int_repay_ped_corp_cd) as int_repay_ped_corp_cd -- 利息还款周期单位代码
    ,nvl(n.self_pay_amt, o.self_pay_amt) as self_pay_amt -- 自主支付金额
    ,nvl(n.entr_pay_amt, o.entr_pay_amt) as entr_pay_amt -- 受托支付金额
    ,nvl(n.loan_ovdue_flg, o.loan_ovdue_flg) as loan_ovdue_flg -- 逾期标志
    ,nvl(n.ovdue_days, o.ovdue_days) as ovdue_days -- 贷款逾期天数
    ,nvl(n.ovdue_grace_days, o.ovdue_grace_days) as ovdue_grace_days -- 逾期宽限天数
    ,nvl(n.pric_ovdue_dt, o.pric_ovdue_dt) as pric_ovdue_dt -- 本金逾期日期
    ,nvl(n.int_ovdue_dt, o.int_ovdue_dt) as int_ovdue_dt -- 利息逾期日期
    ,nvl(n.next_pay_int_day, o.next_pay_int_day) as next_pay_int_day -- 下一付息日
    ,nvl(n.jd_loan_int_rat_type_cd, o.jd_loan_int_rat_type_cd) as jd_loan_int_rat_type_cd -- 贷款利率类型代码
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_adj_ped_corp_cd, o.int_rat_adj_ped_corp_cd) as int_rat_adj_ped_corp_cd -- 利率调整周期单位代码
    ,nvl(n.int_rat_adj_freq, o.int_rat_adj_freq) as int_rat_adj_freq -- 利率调整频率
    ,nvl(n.loan_bal, o.loan_bal) as loan_bal -- 贷款余额
    ,nvl(n.ovdue_loan_bal, o.ovdue_loan_bal) as ovdue_loan_bal -- 逾期贷款余额
    ,nvl(n.ovdue_int_bal, o.ovdue_int_bal) as ovdue_int_bal -- 逾期利息
    ,nvl(n.off_bs_over_int_bal, o.off_bs_over_int_bal) as off_bs_over_int_bal -- 表外欠息
    ,nvl(n.int_accr_flg, o.int_accr_flg) as int_accr_flg -- 计息标志
    ,nvl(n.acru_int_amt, o.acru_int_amt) as acru_int_amt -- 应计利息
    ,nvl(n.td_int_amt, o.td_int_amt) as td_int_amt -- 当日应计利息
    ,nvl(n.td_pnlt_amt, o.td_pnlt_amt) as td_pnlt_amt -- 当日罚息
    ,nvl(n.loan_enter_acct_num, o.loan_enter_acct_num) as loan_enter_acct_num -- 贷款入账账号
    ,nvl(n.loan_repay_num, o.loan_repay_num) as loan_repay_num -- 贷款还款账号
    ,nvl(n.loan_guar_way_cd, o.loan_guar_way_cd) as loan_guar_way_cd -- 担保方式代码
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.loan_int_rat, o.loan_int_rat) as loan_int_rat -- 贷款利率
    ,nvl(n.loan_pnlt_int_rat, o.loan_pnlt_int_rat) as loan_pnlt_int_rat -- 贷款罚息利率
    ,nvl(n.borw_int_rat_type_cd, o.borw_int_rat_type_cd) as borw_int_rat_type_cd -- 贷款利率周期代码
    ,nvl(n.pnlt_int_rat_type_cd, o.pnlt_int_rat_type_cd) as pnlt_int_rat_type_cd -- 罚息利率周期代码
    ,nvl(n.distr_flow_num, o.distr_flow_num) as distr_flow_num -- 放款流水号
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.loan_exec_int_rat, o.loan_exec_int_rat) as loan_exec_int_rat -- 贷款执行利率
    ,nvl(n.borw_exec_int_rat_type_cd, o.borw_exec_int_rat_type_cd) as borw_exec_int_rat_type_cd -- 执行利率周期代码
    ,nvl(n.loan_perds, o.loan_perds) as loan_perds -- 贷款期数
    ,nvl(n.prep_repay_perds, o.prep_repay_perds) as prep_repay_perds -- 待还期数
    ,nvl(n.ovdue_perds, o.ovdue_perds) as ovdue_perds -- 逾期期数
    ,nvl(n.off_bs_perds, o.off_bs_perds) as off_bs_perds -- 表外期数
    ,nvl(n.acru_pnlt_amt, o.acru_pnlt_amt) as acru_pnlt_amt -- 应计罚息
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.belong_cust_mgr_id, o.belong_cust_mgr_id) as belong_cust_mgr_id -- 所属客户经理编号
    ,nvl(n.loan_exec_year_int_rat, o.loan_exec_year_int_rat) as loan_exec_year_int_rat -- 执行年利率
    ,nvl(n.lpr_int_rat, o.lpr_int_rat) as lpr_int_rat -- LPR利率
    ,nvl(n.int_rat_float_spread_val, o.int_rat_float_spread_val) as int_rat_float_spread_val -- 利率浮动点差值
    ,nvl(n.int_rat_float_dir_cd, o.int_rat_float_dir_cd) as int_rat_float_dir_cd -- 利率浮动方向代码
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.white_list_cust_flg, o.white_list_cust_flg) as white_list_cust_flg -- 白户标志
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.cont_id <> n.cont_id
                or o.jd_cust_id <> n.jd_cust_id
                or o.jd_prod_cd <> n.jd_prod_cd
                or o.cust_lmt_id <> n.cust_lmt_id
                or o.dubil_id <> n.dubil_id
                or o.curr_cd <> n.curr_cd
                or o.loan_status_cd <> n.loan_status_cd
                or o.distr_dt <> n.distr_dt
                or o.loan_distr_amt <> n.loan_distr_amt
                or o.bus_exp_dt <> n.bus_exp_dt
                or o.loan_cap_use_position_cd <> n.loan_cap_use_position_cd
                or o.pric_repay_freq_cd <> n.pric_repay_freq_cd
                or o.pric_repay_freq <> n.pric_repay_freq
                or o.pric_repay_ped_corp_cd <> n.pric_repay_ped_corp_cd
                or o.int_repay_freq_cd <> n.int_repay_freq_cd
                or o.int_repay_freq <> n.int_repay_freq
                or o.int_repay_ped_corp_cd <> n.int_repay_ped_corp_cd
                or o.self_pay_amt <> n.self_pay_amt
                or o.entr_pay_amt <> n.entr_pay_amt
                or o.loan_ovdue_flg <> n.loan_ovdue_flg
                or o.ovdue_days <> n.ovdue_days
                or o.ovdue_grace_days <> n.ovdue_grace_days
                or o.pric_ovdue_dt <> n.pric_ovdue_dt
                or o.int_ovdue_dt <> n.int_ovdue_dt
                or o.next_pay_int_day <> n.next_pay_int_day
                or o.jd_loan_int_rat_type_cd <> n.jd_loan_int_rat_type_cd
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.int_rat_adj_ped_corp_cd <> n.int_rat_adj_ped_corp_cd
                or o.int_rat_adj_freq <> n.int_rat_adj_freq
                or o.loan_bal <> n.loan_bal
                or o.ovdue_loan_bal <> n.ovdue_loan_bal
                or o.ovdue_int_bal <> n.ovdue_int_bal
                or o.off_bs_over_int_bal <> n.off_bs_over_int_bal
                or o.int_accr_flg <> n.int_accr_flg
                or o.acru_int_amt <> n.acru_int_amt
                or o.td_int_amt <> n.td_int_amt
                or o.td_pnlt_amt <> n.td_pnlt_amt
                or o.loan_enter_acct_num <> n.loan_enter_acct_num
                or o.loan_repay_num <> n.loan_repay_num
                or o.loan_guar_way_cd <> n.loan_guar_way_cd
                or o.repay_way_cd <> n.repay_way_cd
                or o.loan_int_rat <> n.loan_int_rat
                or o.loan_pnlt_int_rat <> n.loan_pnlt_int_rat
                or o.borw_int_rat_type_cd <> n.borw_int_rat_type_cd
                or o.pnlt_int_rat_type_cd <> n.pnlt_int_rat_type_cd
                or o.distr_flow_num <> n.distr_flow_num
                or o.loan_usage_cd <> n.loan_usage_cd
                or o.loan_exec_int_rat <> n.loan_exec_int_rat
                or o.borw_exec_int_rat_type_cd <> n.borw_exec_int_rat_type_cd
                or o.loan_perds <> n.loan_perds
                or o.prep_repay_perds <> n.prep_repay_perds
                or o.ovdue_perds <> n.ovdue_perds
                or o.off_bs_perds <> n.off_bs_perds
                or o.acru_pnlt_amt <> n.acru_pnlt_amt
                or o.cust_id <> n.cust_id
                or o.belong_cust_mgr_id <> n.belong_cust_mgr_id
                or o.loan_exec_year_int_rat <> n.loan_exec_year_int_rat
                or o.lpr_int_rat <> n.lpr_int_rat
                or o.int_rat_float_spread_val <> n.int_rat_float_spread_val
                or o.int_rat_float_dir_cd <> n.int_rat_float_dir_cd
                or o.base_rat_type_cd <> n.base_rat_type_cd
                or o.prod_id <> n.prod_id
                or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
                or o.white_list_cust_flg <> n.white_list_cust_flg
                or o.payoff_dt <> n.payoff_dt
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
from ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_tm n
    full join ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_jd_loan_dubil_info truncate partition for ('jdjrf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_jd_loan_dubil_info exchange subpartition p_jdjrf1_${batch_date} with table ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_jd_loan_dubil_info drop subpartition p_jdjrf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_jd_loan_dubil_info to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_tm purge;
drop table ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_ex purge;
drop table ${iml_schema}.agt_jd_loan_dubil_info_jdjrf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_jd_loan_dubil_info', partname => 'p_jdjrf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);