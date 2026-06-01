/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_ajb_ped_3_dubil_myjbf3
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
drop table ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_tm purge;
drop table ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_ajb_ped_3_dubil add partition p_myjbf3 values ('myjbf3')(
        subpartition p_myjbf3_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_ajb_ped_3_dubil modify partition p_myjbf3
    add subpartition p_myjbf3_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_ajb_ped_3_dubil partition for ('myjbf3')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,cust_name -- 客户名称
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
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,loan_actl_day_int_rat -- 贷款实际日利率
    ,pric_repay_freq_cd -- 本金还款频率代码
    ,int_repay_freq_cd -- 利息还款频率代码
    ,guar_type_cd -- 担保类型代码
    ,loan_crdt_appl_id -- 贷款授信申请编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,repay_num_type_cd -- 还款账号类型代码
    ,repay_acct_id -- 还款账户编号
    ,acctnt_dt -- 会计日期
    ,cont_status_cd -- 合约状态代码
    ,payoff_dt -- 结清日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,acru_non_acru_flg -- 应计非应计标志
    ,next_repay_dt -- 下一还款日期
    ,int_ovdue_days -- 利息逾期天数
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,unpayoff_perds -- 未结清期数
    ,ovdue_pd_cnt -- 逾期期次数
    ,pric_ovdue_days -- 本金逾期天数
    ,cust_id -- 客户编号
    ,wrt_off_flg -- 核销标志
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
from ${iml_schema}.agt_ajb_ped_3_dubil
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_ajb_ped_3_dubil partition for ('myjbf3') where 0=1;

-- 2.1 insert data to tm table
-- icms_myjb_acc_loan3-
insert into ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,cust_name -- 客户名称
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
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,loan_actl_day_int_rat -- 贷款实际日利率
    ,pric_repay_freq_cd -- 本金还款频率代码
    ,int_repay_freq_cd -- 利息还款频率代码
    ,guar_type_cd -- 担保类型代码
    ,loan_crdt_appl_id -- 贷款授信申请编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,repay_num_type_cd -- 还款账号类型代码
    ,repay_acct_id -- 还款账户编号
    ,acctnt_dt -- 会计日期
    ,cont_status_cd -- 合约状态代码
    ,payoff_dt -- 结清日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,acru_non_acru_flg -- 应计非应计标志
    ,next_repay_dt -- 下一还款日期
    ,int_ovdue_days -- 利息逾期天数
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,unpayoff_perds -- 未结清期数
    ,ovdue_pd_cnt -- 逾期期次数
    ,pric_ovdue_days -- 本金逾期天数
    ,cust_id -- 客户编号
    ,wrt_off_flg -- 核销标志
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
    '222621'||P1.BILLNO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BILLNO -- 借据编号
    ,P1.BIZTYPE -- 产品编号
    ,P1.CUSNAME -- 客户名称
    ,P1.LOANSTATUS -- 贷款状态代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.LOANUSE END -- 贷款用途代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.USEAREA END -- 贷款资金使用位置代码
    ,${iml_schema}.dateformat_min(substr(P1.ENCASHDATE,1,10)) -- 放款日期
    ,NVL(TRIM(P1.CURRENCY),'CNY') -- 币种代码
    ,P1.LOANAMOUNT -- 放款金额
    ,${iml_schema}.dateformat_min(P1.LOANSTARTDATE) -- 贷款起息日期
    ,${iml_schema}.dateformat_max(P1.LOANENDDATE) -- 贷款到期日期
    ,P1.TOTALTERMS -- 贷款合同期限
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.REPAYMODE END -- 还款方式代码 
    ,P1.GRACEDAY -- 宽限期天数
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.RATETYPE END -- 利率调整方式代码
    ,P1.DAYRATE*100 -- 贷款实际日利率
    ,NVL(TRIM(P1.PRINREPAYFREQUENCY),'00') -- 本金还款频率代码
    ,NVL(TRIM(P1.INTREPAYFREQUENCY),'00') -- 利息还款频率代码
    ,P1.GUARANTEETYPE -- 担保类型代码
    ,P1.CREDITNO -- 贷款授信申请编号
    ,P1.ENCASHACCTTYPE -- 收款账号类型代码
    ,P1.ENCASHACCTNO -- 收款账户编号
    ,P1.REPAYACCTTYPE -- 还款账号类型代码
    ,P1.REPAYACCTNO -- 还款账户编号
    ,${iml_schema}.dateformat_max2(P1.SETTLEDATE) -- 会计日期
    ,NVL(TRIM(P1.ACCOUNTSTATUS),'-') -- 合约状态代码
    ,${iml_schema}.dateformat_max2(P1.CLEARDATE) -- 结清日期
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'|| P1.ASSETCLASS END -- 贷款五级分类代码
    ,P1.ACCRUEDSTATUS -- 应计非应计标志
    ,${iml_schema}.dateformat_max2(P1.NEXTREPAYDATE) -- 下一还款日期
    ,P1.CAPOVERDUEDAYS -- 利息逾期天数
    ,P1.NORMALBALANCE -- 正常本金余额
    ,P1.OVERDUEBALANCE -- 逾期本金余额
    ,P1.INTBAL -- 正常利息余额
    ,P1.OVDINTBAL -- 逾期利息余额
    ,P1.OVDPRINPNLTBAL -- 逾期本金罚息余额
    ,P1.OVDINTPNLTBAL -- 逾期利息罚息余额
    ,P1.UNCLEARTERMS -- 未结清期数
    ,P1.OVDTERMS -- 逾期期次数
    ,P1.PRINOVDDAYS -- 本金逾期天数
    ,P1.CUSID -- 客户编号
    ,P1.WRITEOFF -- 核销标志
    ,P1.EXECRATE*100 -- 贷款执行年利率
    ,P1.LPR*100 -- LPR利率
    ,P1.FLOATRATEBP/100 -- 利率浮动点差值
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.RATEFLOATMODE END -- 利率浮动方向代码
    ,nvl(trim(p1.RATELPRTYPE),'-') -- 基准利率类型代码
    ,NVL(TRIM(P1.ASSETTHREETYPECD),'XXX') -- 资产三分类代码
    ,nvl(trim(p1.ISWHITE),'-') -- 白户标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'icms_myjb_acc_loan3' -- 源表名称
    ,'myjbf3' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.icms_myjb_acc_loan3 p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ASSETCLASS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'ICMS'
        AND R1.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN3'
        AND R1.SRC_FIELD_EN_NAME= 'ASSETCLASS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_AJB_PED_3_DUBIL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'LOAN_LEVEL5_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.REPAYMODE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'ICMS'
        AND R2.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN3'
        AND R2.SRC_FIELD_EN_NAME= 'REPAYMODE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_AJB_PED_3_DUBIL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'REPAY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.LOANUSE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'ICMS'
        AND R3.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN3'
        AND R3.SRC_FIELD_EN_NAME= 'LOANUSE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_AJB_PED_3_DUBIL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'LOAN_USAGE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.USEAREA = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'ICMS'
        AND R4.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN3'
        AND R4.SRC_FIELD_EN_NAME= 'USEAREA'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_AJB_PED_3_DUBIL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'LOAN_CAP_USE_POSITION_CD'
	left join ${iml_schema}.ref_pub_cd_map r5 on P1.RATEFLOATMODE = R5.SRC_CODE_VAL
        AND r5.SORC_SYS_CD= 'ICMS'
        AND r5.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN3'
        AND r5.SRC_FIELD_EN_NAME= 'RATEFLOATMODE'
        AND r5.TARGET_TAB_EN_NAME= 'AGT_AJB_PED_3_DUBIL'
        AND r5.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_FLOAT_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.RATETYPE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'ICMS'
        AND R6.SRC_TAB_EN_NAME= 'ICMS_MYJB_ACC_LOAN3'
        AND R6.SRC_FIELD_EN_NAME= 'RATETYPE'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_AJB_PED_3_DUBIL'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_ADJ_WAY_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_tm 
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
insert /*+ append */ into ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,prod_id -- 产品编号
    ,cust_name -- 客户名称
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
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,loan_actl_day_int_rat -- 贷款实际日利率
    ,pric_repay_freq_cd -- 本金还款频率代码
    ,int_repay_freq_cd -- 利息还款频率代码
    ,guar_type_cd -- 担保类型代码
    ,loan_crdt_appl_id -- 贷款授信申请编号
    ,recvbl_num_type_cd -- 收款账号类型代码
    ,recvbl_acct_id -- 收款账户编号
    ,repay_num_type_cd -- 还款账号类型代码
    ,repay_acct_id -- 还款账户编号
    ,acctnt_dt -- 会计日期
    ,cont_status_cd -- 合约状态代码
    ,payoff_dt -- 结清日期
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,acru_non_acru_flg -- 应计非应计标志
    ,next_repay_dt -- 下一还款日期
    ,int_ovdue_days -- 利息逾期天数
    ,nomal_pric_bal -- 正常本金余额
    ,ovdue_pric_bal -- 逾期本金余额
    ,nomal_int_bal -- 正常利息余额
    ,ovdue_int_bal -- 逾期利息余额
    ,ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,unpayoff_perds -- 未结清期数
    ,ovdue_pd_cnt -- 逾期期次数
    ,pric_ovdue_days -- 本金逾期天数
    ,cust_id -- 客户编号
    ,wrt_off_flg -- 核销标志
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
    ,nvl(n.cust_name, o.cust_name) as cust_name -- 客户名称
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
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.loan_actl_day_int_rat, o.loan_actl_day_int_rat) as loan_actl_day_int_rat -- 贷款实际日利率
    ,nvl(n.pric_repay_freq_cd, o.pric_repay_freq_cd) as pric_repay_freq_cd -- 本金还款频率代码
    ,nvl(n.int_repay_freq_cd, o.int_repay_freq_cd) as int_repay_freq_cd -- 利息还款频率代码
    ,nvl(n.guar_type_cd, o.guar_type_cd) as guar_type_cd -- 担保类型代码
    ,nvl(n.loan_crdt_appl_id, o.loan_crdt_appl_id) as loan_crdt_appl_id -- 贷款授信申请编号
    ,nvl(n.recvbl_num_type_cd, o.recvbl_num_type_cd) as recvbl_num_type_cd -- 收款账号类型代码
    ,nvl(n.recvbl_acct_id, o.recvbl_acct_id) as recvbl_acct_id -- 收款账户编号
    ,nvl(n.repay_num_type_cd, o.repay_num_type_cd) as repay_num_type_cd -- 还款账号类型代码
    ,nvl(n.repay_acct_id, o.repay_acct_id) as repay_acct_id -- 还款账户编号
    ,nvl(n.acctnt_dt, o.acctnt_dt) as acctnt_dt -- 会计日期
    ,nvl(n.cont_status_cd, o.cont_status_cd) as cont_status_cd -- 合约状态代码
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.loan_level5_cls_cd, o.loan_level5_cls_cd) as loan_level5_cls_cd -- 贷款五级分类代码
    ,nvl(n.acru_non_acru_flg, o.acru_non_acru_flg) as acru_non_acru_flg -- 应计非应计标志
    ,nvl(n.next_repay_dt, o.next_repay_dt) as next_repay_dt -- 下一还款日期
    ,nvl(n.int_ovdue_days, o.int_ovdue_days) as int_ovdue_days -- 利息逾期天数
    ,nvl(n.nomal_pric_bal, o.nomal_pric_bal) as nomal_pric_bal -- 正常本金余额
    ,nvl(n.ovdue_pric_bal, o.ovdue_pric_bal) as ovdue_pric_bal -- 逾期本金余额
    ,nvl(n.nomal_int_bal, o.nomal_int_bal) as nomal_int_bal -- 正常利息余额
    ,nvl(n.ovdue_int_bal, o.ovdue_int_bal) as ovdue_int_bal -- 逾期利息余额
    ,nvl(n.ovdue_pric_pnlt_bal, o.ovdue_pric_pnlt_bal) as ovdue_pric_pnlt_bal -- 逾期本金罚息余额
    ,nvl(n.ovdue_int_pnlt_bal, o.ovdue_int_pnlt_bal) as ovdue_int_pnlt_bal -- 逾期利息罚息余额
    ,nvl(n.unpayoff_perds, o.unpayoff_perds) as unpayoff_perds -- 未结清期数
    ,nvl(n.ovdue_pd_cnt, o.ovdue_pd_cnt) as ovdue_pd_cnt -- 逾期期次数
    ,nvl(n.pric_ovdue_days, o.pric_ovdue_days) as pric_ovdue_days -- 本金逾期天数
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.wrt_off_flg, o.wrt_off_flg) as wrt_off_flg -- 核销标志
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
                or o.cust_name <> n.cust_name
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
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.loan_actl_day_int_rat <> n.loan_actl_day_int_rat
                or o.pric_repay_freq_cd <> n.pric_repay_freq_cd
                or o.int_repay_freq_cd <> n.int_repay_freq_cd
                or o.guar_type_cd <> n.guar_type_cd
                or o.loan_crdt_appl_id <> n.loan_crdt_appl_id
                or o.recvbl_num_type_cd <> n.recvbl_num_type_cd
                or o.recvbl_acct_id <> n.recvbl_acct_id
                or o.repay_num_type_cd <> n.repay_num_type_cd
                or o.repay_acct_id <> n.repay_acct_id
                or o.acctnt_dt <> n.acctnt_dt
                or o.cont_status_cd <> n.cont_status_cd
                or o.payoff_dt <> n.payoff_dt
                or o.loan_level5_cls_cd <> n.loan_level5_cls_cd
                or o.acru_non_acru_flg <> n.acru_non_acru_flg
                or o.next_repay_dt <> n.next_repay_dt
                or o.int_ovdue_days <> n.int_ovdue_days
                or o.nomal_pric_bal <> n.nomal_pric_bal
                or o.ovdue_pric_bal <> n.ovdue_pric_bal
                or o.nomal_int_bal <> n.nomal_int_bal
                or o.ovdue_int_bal <> n.ovdue_int_bal
                or o.ovdue_pric_pnlt_bal <> n.ovdue_pric_pnlt_bal
                or o.ovdue_int_pnlt_bal <> n.ovdue_int_pnlt_bal
                or o.unpayoff_perds <> n.unpayoff_perds
                or o.ovdue_pd_cnt <> n.ovdue_pd_cnt
                or o.pric_ovdue_days <> n.pric_ovdue_days
                or o.cust_id <> n.cust_id
                or o.wrt_off_flg <> n.wrt_off_flg
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
from ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_tm n
    full join ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_ajb_ped_3_dubil truncate partition for ('myjbf3') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_ajb_ped_3_dubil exchange subpartition p_myjbf3_${batch_date} with table ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_ajb_ped_3_dubil drop subpartition p_myjbf3_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_ajb_ped_3_dubil to ${iml_schema};

-- 4.2 drop tm table
--drop table ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_tm purge;
--drop table ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_ex purge;
drop table ${iml_schema}.agt_ajb_ped_3_dubil_myjbf3_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_ajb_ped_3_dubil', partname => 'p_myjbf3_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);