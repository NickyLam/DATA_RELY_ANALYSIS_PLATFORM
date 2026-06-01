/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_itnet_stud_loan_dubil_rnetf1
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
drop table ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_tm purge;
drop table ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_itnet_stud_loan_dubil add partition p_rnetf1 values ('rnetf1')(
        subpartition p_rnetf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_itnet_stud_loan_dubil modify partition p_rnetf1
    add subpartition p_rnetf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_itnet_stud_loan_dubil partition for ('rnetf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,cust_id -- 客户编号
    ,rgst_dt -- 登记日期
    ,rgst_emply_id -- 登记员工编号
    ,acct_instit_id -- 账务机构编号
    ,rgst_org_id -- 登记机构编号
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,enter_acct_id -- 入账账户编号
    ,enter_acct_name -- 入账账户名称
    ,dubil_amt -- 借据金额
    ,dubil_bal -- 借据余额
    ,loan_start_dt -- 贷款起始日期
    ,loan_termnt_dt -- 贷款终止日期
    ,base_rat -- 基准利率
    ,int_rat_fl_rt -- 利率浮动比例
    ,dubil_status_cd -- 借据状态代码
    ,loan_level10_cls_cd -- 贷款十级分类代码
    ,loan_level10_cls_dt -- 贷款十级分类日期
    ,l_ped_level10_cls_cd -- 上期十级分类代码
    ,l_ped_level10_cls_dt -- 上期十级分类日期
    ,curr_cd -- 币种代码
    ,ovdue_days -- 逾期天数
    ,comp_flg -- 代偿标志
    ,comp_amt -- 代偿金额
    ,loan_level4_cls_cd -- 贷款四级分类代码
    ,pric_ovdue_start_dt -- 本金逾期起始日期
    ,int_ovdue_start_dt -- 利息逾期起始日期
    ,payoff_dt -- 结清日期
    ,repay_dt -- 还款日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,l_ped_level5_cls_cd -- 上期五级分类代码
    ,risk_cls_idtfy_ps_id -- 风险分类认定人编号
    ,risk_cls_idtfy_org_id -- 风险分类认定机构编号
    ,l_ped_ovdue_flg -- 上期逾期标志
    ,bind_card_card_no -- 绑定卡卡号
    ,bind_card_card_name -- 绑定卡卡名称
    ,enty_c_cors_open_bank_no -- 实体卡对应的开户行行号
    ,enty_c_cors_open_bank_name -- 实体卡对应的开户行名称
    ,bacct_mode_flg -- 大账户模式标志
    ,risk_cls_final_jud_ps_id -- 风险分类终审人编号
    ,intnal_acct_id -- 内部账户编号
    ,quote_lmt_flg -- 引用额度标志
    ,repay_way_cd -- 还款方式代码
    ,repay_day -- 还款日
    ,exec_int_rat -- 执行利率
    ,level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,level5_cls_cmplt_dt -- 五级分类完成日期
    ,int_rat_float_spread_val -- 利率浮动点差值
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,white_list_cust_flg -- 白户标志
    ,stud_loan_corp_id -- 助贷公司编号
    ,stud_loan_corp_name -- 助贷公司名称
    ,dir_indus_cd -- 投向行业代码
    ,cust_char_cd -- 客户性质代码
    ,farm_flg -- 农户标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_itnet_stud_loan_dubil
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_itnet_stud_loan_dubil partition for ('rnetf1') where 0=1;

-- 2.1 insert data to tm table
-- rcrs_net_acc_loan-
insert into ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,cust_id -- 客户编号
    ,rgst_dt -- 登记日期
    ,rgst_emply_id -- 登记员工编号
    ,acct_instit_id -- 账务机构编号
    ,rgst_org_id -- 登记机构编号
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,enter_acct_id -- 入账账户编号
    ,enter_acct_name -- 入账账户名称
    ,dubil_amt -- 借据金额
    ,dubil_bal -- 借据余额
    ,loan_start_dt -- 贷款起始日期
    ,loan_termnt_dt -- 贷款终止日期
    ,base_rat -- 基准利率
    ,int_rat_fl_rt -- 利率浮动比例
    ,dubil_status_cd -- 借据状态代码
    ,loan_level10_cls_cd -- 贷款十级分类代码
    ,loan_level10_cls_dt -- 贷款十级分类日期
    ,l_ped_level10_cls_cd -- 上期十级分类代码
    ,l_ped_level10_cls_dt -- 上期十级分类日期
    ,curr_cd -- 币种代码
    ,ovdue_days -- 逾期天数
    ,comp_flg -- 代偿标志
    ,comp_amt -- 代偿金额
    ,loan_level4_cls_cd -- 贷款四级分类代码
    ,pric_ovdue_start_dt -- 本金逾期起始日期
    ,int_ovdue_start_dt -- 利息逾期起始日期
    ,payoff_dt -- 结清日期
    ,repay_dt -- 还款日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,l_ped_level5_cls_cd -- 上期五级分类代码
    ,risk_cls_idtfy_ps_id -- 风险分类认定人编号
    ,risk_cls_idtfy_org_id -- 风险分类认定机构编号
    ,l_ped_ovdue_flg -- 上期逾期标志
    ,bind_card_card_no -- 绑定卡卡号
    ,bind_card_card_name -- 绑定卡卡名称
    ,enty_c_cors_open_bank_no -- 实体卡对应的开户行行号
    ,enty_c_cors_open_bank_name -- 实体卡对应的开户行名称
    ,bacct_mode_flg -- 大账户模式标志
    ,risk_cls_final_jud_ps_id -- 风险分类终审人编号
    ,intnal_acct_id -- 内部账户编号
    ,quote_lmt_flg -- 引用额度标志
    ,repay_way_cd -- 还款方式代码
    ,repay_day -- 还款日
    ,exec_int_rat -- 执行利率
    ,level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,level5_cls_cmplt_dt -- 五级分类完成日期
    ,int_rat_float_spread_val -- 利率浮动点差值
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,white_list_cust_flg -- 白户标志
    ,stud_loan_corp_id -- 助贷公司编号
    ,stud_loan_corp_name -- 助贷公司名称
    ,dir_indus_cd -- 投向行业代码
    ,cust_char_cd -- 客户性质代码
    ,farm_flg -- 农户标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222510'||P1.BILL_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.BILL_NO -- 借据编号
    ,P1.CONT_NO -- 合同编号
    ,P1.PRD_CODE -- 产品编号
    ,P1.PRD_NAME -- 产品名称
    ,P1.CUS_ID -- 客户编号
    ,${iml_schema}.DATEFORMAT_MIN(P1.INPUT_DATE) -- 登记日期
    ,P1.INPUT_ID -- 登记员工编号
    ,P1.FINA_BR_ID -- 账务机构编号
    ,P1.INPUT_BR_ID -- 登记机构编号
    ,P1.REPAYMENT_ACCOUNT -- 还款账户编号
    ,P1.REPAYMENT_ACC_NAME -- 还款账户名称
    ,P1.ENTER_ACCOUNT -- 入账账户编号
    ,P1.ENTER_ACCOUNT_NAME -- 入账账户名称
    ,P1.LOAN_AMOUNT -- 借据金额
    ,P1.LOAN_BALANCE -- 借据余额
    ,${iml_schema}.DATEFORMAT_MIN(P1.LOAN_START_DATE) -- 贷款起始日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.LOAN_END_DATE) -- 贷款终止日期
    ,P1.RULING_IR*100 -- 基准利率
    ,P1.INT_RATE_INC -- 利率浮动比例
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 借据状态代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TEN_CLA END -- 贷款十级分类代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.TEN_CLA_DATE) -- 贷款十级分类日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TEN_CLA_PRE END -- 上期十级分类代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TEN_CLA_DATE_PRE) -- 上期十级分类日期
    ,NVL(TRIM(P1.CUR_TYPE),'CNY') -- 币种代码
    ,P1.OVERDUE_DAYS -- 逾期天数
    ,case when p1.IS_LOAN_REPAY = '1' then '1'
     else '0'
     end -- 代偿标志
    ,P1.ASSURE_AMOUNT -- 代偿金额
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.LOAN_FORM4 END -- 贷款四级分类代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.CAP_OVERDUE_DATE) -- 本金逾期起始日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.INT_OVERDUE_DATE) -- 利息逾期起始日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.SETTL_DATE) -- 结清日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.LATEST_REPAY_DATE) -- 还款日期
    ,P1.CAP_OVERDUE_DAYS -- 本金逾期天数
    ,P1.INT_OVERDUE_DAYS -- 利息逾期天数
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.CLA END -- 贷款五级分类代码
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.CLA_PRE END -- 上期五级分类代码
    ,P1.ADJUST_USER -- 风险分类认定人编号
    ,P1.ADJUST_MAIN_BR_ID -- 风险分类认定机构编号
    ,P1.OVERDUE_FLAG -- 上期逾期标志
    ,P1.ACCOUNT_END -- 绑定卡卡号
    ,P1.ACCOUNT_NAME_END -- 绑定卡卡名称
    ,P1.BANK_CODE_END -- 实体卡对应的开户行行号
    ,P1.BANK_NAME_END -- 实体卡对应的开户行名称
    ,P1.IS_BIG_ACCOUNT -- 大账户模式标志
    ,P1.CLA_FINA_UPDATE_ID -- 风险分类终审人编号
    ,P1.INNER_ACCOUNT -- 内部账户编号
    ,case when P1.LIMIT_IND ='1' then '1'
     else '0'
end -- 引用额度标志
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.REPAYMENT_MODE END -- 还款方式代码
    ,P1.RETURN_DATE -- 还款日
    ,P1.REALITY_IR_Y*100 -- 执行利率
    ,P1.TEN_CLA_IND -- 十级分类人工干预标志
    ,${iml_schema}.DATEFORMAT_MAX(P1.CLA_DATE) -- 五级分类完成日期
    ,P1.FLOAT_RATE_BP/100 -- 利率浮动点差值
    ,CASE WHEN R10.TARGET_CD_VAL IS NOT NULL THEN R10.TARGET_CD_VAL ELSE '@'||P1.RATE_TYPE END -- 基准利率类型代码
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.INT_RATE_INC_OPT END -- 利率浮动方向代码
    ,NVL(TRIM(P1.ASSET_THREE_TYPE_CD),'XXX') -- 资产三分类代码
    ,p1.IS_WHITE -- 白户标志
    ,p1.HELP_COMP_ID -- 助贷公司编号
    ,p1.HELP_COMP_NAME -- 助贷公司名称
    ,CASE WHEN R11.TARGET_CD_VAL IS NOT NULL THEN R11.TARGET_CD_VAL ELSE '@'||P1.LOAN_DIRECTION END -- 投向行业代码
    ,CASE WHEN R12.TARGET_CD_VAL IS NOT NULL THEN R12.TARGET_CD_VAL ELSE '@'||P1.BUSINESSES_FLAG END -- 客户性质代码
    ,case when trim(P1.AGRI_FLG)='2' then '0' else nvl(trim(P1.AGRI_FLG),'-') end -- 农户标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_net_acc_loan' -- 源表名称
    ,'rnetf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_net_acc_loan p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCOUNT_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'RCRS'
        AND R1.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R1.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'DUBIL_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TEN_CLA = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'RCRS'
        AND R3.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R3.SRC_FIELD_EN_NAME= 'TEN_CLA'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'LOAN_LEVEL10_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TEN_CLA_PRE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'RCRS'
        AND R2.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R2.SRC_FIELD_EN_NAME= 'TEN_CLA_PRE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'L_PED_LEVEL10_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.LOAN_FORM4 = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'RCRS'
        AND R6.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R6.SRC_FIELD_EN_NAME= 'LOAN_FORM4'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'LOAN_LEVEL4_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CLA = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'RCRS'
        AND R4.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R4.SRC_FIELD_EN_NAME= 'CLA'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'LOAN_LEVEL5_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.CLA_PRE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'RCRS'
        AND R5.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R5.SRC_FIELD_EN_NAME= 'CLA_PRE'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'L_PED_LEVEL5_CLS_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.REPAYMENT_MODE = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'RCRS'
        AND R7.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R7.SRC_FIELD_EN_NAME= 'REPAYMENT_MODE'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'REPAY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r10 on P1.RATE_TYPE = R10.SRC_CODE_VAL
        AND R10.SORC_SYS_CD= 'RCRS'
        AND R10.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R10.SRC_FIELD_EN_NAME= 'RATE_TYPE'
        AND R10.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R10.TARGET_TAB_FIELD_EN_NAME= 'BASE_RAT_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.INT_RATE_INC_OPT = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'RCRS'
        AND R8.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R8.SRC_FIELD_EN_NAME= 'INT_RATE_INC_OPT'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_FLOAT_DIR_CD'
    left join ${iml_schema}.ref_pub_cd_map r11 on P1.LOAN_DIRECTION = R11.SRC_CODE_VAL
        AND R11.SORC_SYS_CD= 'RCRS'
        AND R11.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R11.SRC_FIELD_EN_NAME= 'LOAN_DIRECTION'
        AND R11.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R11.TARGET_TAB_FIELD_EN_NAME= 'DIR_INDUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r12 on P1.BUSINESSES_FLAG = R12.SRC_CODE_VAL
        AND R12.SORC_SYS_CD= 'RCRS'
        AND R12.SRC_TAB_EN_NAME= 'RCRS_NET_ACC_LOAN'
        AND R12.SRC_FIELD_EN_NAME= 'BUSINESSES_FLAG'
        AND R12.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_DUBIL'
        AND R12.TARGET_TAB_FIELD_EN_NAME= 'CUST_CHAR_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,dubil_id -- 借据编号
    ,cont_id -- 合同编号
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,cust_id -- 客户编号
    ,rgst_dt -- 登记日期
    ,rgst_emply_id -- 登记员工编号
    ,acct_instit_id -- 账务机构编号
    ,rgst_org_id -- 登记机构编号
    ,repay_acct_id -- 还款账户编号
    ,repay_acct_name -- 还款账户名称
    ,enter_acct_id -- 入账账户编号
    ,enter_acct_name -- 入账账户名称
    ,dubil_amt -- 借据金额
    ,dubil_bal -- 借据余额
    ,loan_start_dt -- 贷款起始日期
    ,loan_termnt_dt -- 贷款终止日期
    ,base_rat -- 基准利率
    ,int_rat_fl_rt -- 利率浮动比例
    ,dubil_status_cd -- 借据状态代码
    ,loan_level10_cls_cd -- 贷款十级分类代码
    ,loan_level10_cls_dt -- 贷款十级分类日期
    ,l_ped_level10_cls_cd -- 上期十级分类代码
    ,l_ped_level10_cls_dt -- 上期十级分类日期
    ,curr_cd -- 币种代码
    ,ovdue_days -- 逾期天数
    ,comp_flg -- 代偿标志
    ,comp_amt -- 代偿金额
    ,loan_level4_cls_cd -- 贷款四级分类代码
    ,pric_ovdue_start_dt -- 本金逾期起始日期
    ,int_ovdue_start_dt -- 利息逾期起始日期
    ,payoff_dt -- 结清日期
    ,repay_dt -- 还款日期
    ,pric_ovdue_days -- 本金逾期天数
    ,int_ovdue_days -- 利息逾期天数
    ,loan_level5_cls_cd -- 贷款五级分类代码
    ,l_ped_level5_cls_cd -- 上期五级分类代码
    ,risk_cls_idtfy_ps_id -- 风险分类认定人编号
    ,risk_cls_idtfy_org_id -- 风险分类认定机构编号
    ,l_ped_ovdue_flg -- 上期逾期标志
    ,bind_card_card_no -- 绑定卡卡号
    ,bind_card_card_name -- 绑定卡卡名称
    ,enty_c_cors_open_bank_no -- 实体卡对应的开户行行号
    ,enty_c_cors_open_bank_name -- 实体卡对应的开户行名称
    ,bacct_mode_flg -- 大账户模式标志
    ,risk_cls_final_jud_ps_id -- 风险分类终审人编号
    ,intnal_acct_id -- 内部账户编号
    ,quote_lmt_flg -- 引用额度标志
    ,repay_way_cd -- 还款方式代码
    ,repay_day -- 还款日
    ,exec_int_rat -- 执行利率
    ,level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,level5_cls_cmplt_dt -- 五级分类完成日期
    ,int_rat_float_spread_val -- 利率浮动点差值
    ,base_rat_type_cd -- 基准利率类型代码
    ,int_rat_float_dir_cd -- 利率浮动方向代码
    ,asset_thd_cls_cd -- 资产三分类代码
    ,white_list_cust_flg -- 白户标志
    ,stud_loan_corp_id -- 助贷公司编号
    ,stud_loan_corp_name -- 助贷公司名称
    ,dir_indus_cd -- 投向行业代码
    ,cust_char_cd -- 客户性质代码
    ,farm_flg -- 农户标志
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
    ,nvl(n.cont_id, o.cont_id) as cont_id -- 合同编号
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.rgst_dt, o.rgst_dt) as rgst_dt -- 登记日期
    ,nvl(n.rgst_emply_id, o.rgst_emply_id) as rgst_emply_id -- 登记员工编号
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.repay_acct_id, o.repay_acct_id) as repay_acct_id -- 还款账户编号
    ,nvl(n.repay_acct_name, o.repay_acct_name) as repay_acct_name -- 还款账户名称
    ,nvl(n.enter_acct_id, o.enter_acct_id) as enter_acct_id -- 入账账户编号
    ,nvl(n.enter_acct_name, o.enter_acct_name) as enter_acct_name -- 入账账户名称
    ,nvl(n.dubil_amt, o.dubil_amt) as dubil_amt -- 借据金额
    ,nvl(n.dubil_bal, o.dubil_bal) as dubil_bal -- 借据余额
    ,nvl(n.loan_start_dt, o.loan_start_dt) as loan_start_dt -- 贷款起始日期
    ,nvl(n.loan_termnt_dt, o.loan_termnt_dt) as loan_termnt_dt -- 贷款终止日期
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.int_rat_fl_rt, o.int_rat_fl_rt) as int_rat_fl_rt -- 利率浮动比例
    ,nvl(n.dubil_status_cd, o.dubil_status_cd) as dubil_status_cd -- 借据状态代码
    ,nvl(n.loan_level10_cls_cd, o.loan_level10_cls_cd) as loan_level10_cls_cd -- 贷款十级分类代码
    ,nvl(n.loan_level10_cls_dt, o.loan_level10_cls_dt) as loan_level10_cls_dt -- 贷款十级分类日期
    ,nvl(n.l_ped_level10_cls_cd, o.l_ped_level10_cls_cd) as l_ped_level10_cls_cd -- 上期十级分类代码
    ,nvl(n.l_ped_level10_cls_dt, o.l_ped_level10_cls_dt) as l_ped_level10_cls_dt -- 上期十级分类日期
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.ovdue_days, o.ovdue_days) as ovdue_days -- 逾期天数
    ,nvl(n.comp_flg, o.comp_flg) as comp_flg -- 代偿标志
    ,nvl(n.comp_amt, o.comp_amt) as comp_amt -- 代偿金额
    ,nvl(n.loan_level4_cls_cd, o.loan_level4_cls_cd) as loan_level4_cls_cd -- 贷款四级分类代码
    ,nvl(n.pric_ovdue_start_dt, o.pric_ovdue_start_dt) as pric_ovdue_start_dt -- 本金逾期起始日期
    ,nvl(n.int_ovdue_start_dt, o.int_ovdue_start_dt) as int_ovdue_start_dt -- 利息逾期起始日期
    ,nvl(n.payoff_dt, o.payoff_dt) as payoff_dt -- 结清日期
    ,nvl(n.repay_dt, o.repay_dt) as repay_dt -- 还款日期
    ,nvl(n.pric_ovdue_days, o.pric_ovdue_days) as pric_ovdue_days -- 本金逾期天数
    ,nvl(n.int_ovdue_days, o.int_ovdue_days) as int_ovdue_days -- 利息逾期天数
    ,nvl(n.loan_level5_cls_cd, o.loan_level5_cls_cd) as loan_level5_cls_cd -- 贷款五级分类代码
    ,nvl(n.l_ped_level5_cls_cd, o.l_ped_level5_cls_cd) as l_ped_level5_cls_cd -- 上期五级分类代码
    ,nvl(n.risk_cls_idtfy_ps_id, o.risk_cls_idtfy_ps_id) as risk_cls_idtfy_ps_id -- 风险分类认定人编号
    ,nvl(n.risk_cls_idtfy_org_id, o.risk_cls_idtfy_org_id) as risk_cls_idtfy_org_id -- 风险分类认定机构编号
    ,nvl(n.l_ped_ovdue_flg, o.l_ped_ovdue_flg) as l_ped_ovdue_flg -- 上期逾期标志
    ,nvl(n.bind_card_card_no, o.bind_card_card_no) as bind_card_card_no -- 绑定卡卡号
    ,nvl(n.bind_card_card_name, o.bind_card_card_name) as bind_card_card_name -- 绑定卡卡名称
    ,nvl(n.enty_c_cors_open_bank_no, o.enty_c_cors_open_bank_no) as enty_c_cors_open_bank_no -- 实体卡对应的开户行行号
    ,nvl(n.enty_c_cors_open_bank_name, o.enty_c_cors_open_bank_name) as enty_c_cors_open_bank_name -- 实体卡对应的开户行名称
    ,nvl(n.bacct_mode_flg, o.bacct_mode_flg) as bacct_mode_flg -- 大账户模式标志
    ,nvl(n.risk_cls_final_jud_ps_id, o.risk_cls_final_jud_ps_id) as risk_cls_final_jud_ps_id -- 风险分类终审人编号
    ,nvl(n.intnal_acct_id, o.intnal_acct_id) as intnal_acct_id -- 内部账户编号
    ,nvl(n.quote_lmt_flg, o.quote_lmt_flg) as quote_lmt_flg -- 引用额度标志
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_day, o.repay_day) as repay_day -- 还款日
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.level10_cls_manu_med_flg, o.level10_cls_manu_med_flg) as level10_cls_manu_med_flg -- 十级分类人工干预标志
    ,nvl(n.level5_cls_cmplt_dt, o.level5_cls_cmplt_dt) as level5_cls_cmplt_dt -- 五级分类完成日期
    ,nvl(n.int_rat_float_spread_val, o.int_rat_float_spread_val) as int_rat_float_spread_val -- 利率浮动点差值
    ,nvl(n.base_rat_type_cd, o.base_rat_type_cd) as base_rat_type_cd -- 基准利率类型代码
    ,nvl(n.int_rat_float_dir_cd, o.int_rat_float_dir_cd) as int_rat_float_dir_cd -- 利率浮动方向代码
    ,nvl(n.asset_thd_cls_cd, o.asset_thd_cls_cd) as asset_thd_cls_cd -- 资产三分类代码
    ,nvl(n.white_list_cust_flg, o.white_list_cust_flg) as white_list_cust_flg -- 白户标志
    ,nvl(n.stud_loan_corp_id, o.stud_loan_corp_id) as stud_loan_corp_id -- 助贷公司编号
    ,nvl(n.stud_loan_corp_name, o.stud_loan_corp_name) as stud_loan_corp_name -- 助贷公司名称
    ,nvl(n.dir_indus_cd, o.dir_indus_cd) as dir_indus_cd -- 投向行业代码
    ,nvl(n.cust_char_cd, o.cust_char_cd) as cust_char_cd -- 客户性质代码
    ,nvl(n.farm_flg, o.farm_flg) as farm_flg -- 农户标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.dubil_id <> n.dubil_id
                or o.cont_id <> n.cont_id
                or o.prod_id <> n.prod_id
                or o.prod_name <> n.prod_name
                or o.cust_id <> n.cust_id
                or o.rgst_dt <> n.rgst_dt
                or o.rgst_emply_id <> n.rgst_emply_id
                or o.acct_instit_id <> n.acct_instit_id
                or o.rgst_org_id <> n.rgst_org_id
                or o.repay_acct_id <> n.repay_acct_id
                or o.repay_acct_name <> n.repay_acct_name
                or o.enter_acct_id <> n.enter_acct_id
                or o.enter_acct_name <> n.enter_acct_name
                or o.dubil_amt <> n.dubil_amt
                or o.dubil_bal <> n.dubil_bal
                or o.loan_start_dt <> n.loan_start_dt
                or o.loan_termnt_dt <> n.loan_termnt_dt
                or o.base_rat <> n.base_rat
                or o.int_rat_fl_rt <> n.int_rat_fl_rt
                or o.dubil_status_cd <> n.dubil_status_cd
                or o.loan_level10_cls_cd <> n.loan_level10_cls_cd
                or o.loan_level10_cls_dt <> n.loan_level10_cls_dt
                or o.l_ped_level10_cls_cd <> n.l_ped_level10_cls_cd
                or o.l_ped_level10_cls_dt <> n.l_ped_level10_cls_dt
                or o.curr_cd <> n.curr_cd
                or o.ovdue_days <> n.ovdue_days
                or o.comp_flg <> n.comp_flg
                or o.comp_amt <> n.comp_amt
                or o.loan_level4_cls_cd <> n.loan_level4_cls_cd
                or o.pric_ovdue_start_dt <> n.pric_ovdue_start_dt
                or o.int_ovdue_start_dt <> n.int_ovdue_start_dt
                or o.payoff_dt <> n.payoff_dt
                or o.repay_dt <> n.repay_dt
                or o.pric_ovdue_days <> n.pric_ovdue_days
                or o.int_ovdue_days <> n.int_ovdue_days
                or o.loan_level5_cls_cd <> n.loan_level5_cls_cd
                or o.l_ped_level5_cls_cd <> n.l_ped_level5_cls_cd
                or o.risk_cls_idtfy_ps_id <> n.risk_cls_idtfy_ps_id
                or o.risk_cls_idtfy_org_id <> n.risk_cls_idtfy_org_id
                or o.l_ped_ovdue_flg <> n.l_ped_ovdue_flg
                or o.bind_card_card_no <> n.bind_card_card_no
                or o.bind_card_card_name <> n.bind_card_card_name
                or o.enty_c_cors_open_bank_no <> n.enty_c_cors_open_bank_no
                or o.enty_c_cors_open_bank_name <> n.enty_c_cors_open_bank_name
                or o.bacct_mode_flg <> n.bacct_mode_flg
                or o.risk_cls_final_jud_ps_id <> n.risk_cls_final_jud_ps_id
                or o.intnal_acct_id <> n.intnal_acct_id
                or o.quote_lmt_flg <> n.quote_lmt_flg
                or o.repay_way_cd <> n.repay_way_cd
                or o.repay_day <> n.repay_day
                or o.exec_int_rat <> n.exec_int_rat
                or o.level10_cls_manu_med_flg <> n.level10_cls_manu_med_flg
                or o.level5_cls_cmplt_dt <> n.level5_cls_cmplt_dt
                or o.int_rat_float_spread_val <> n.int_rat_float_spread_val
                or o.base_rat_type_cd <> n.base_rat_type_cd
                or o.int_rat_float_dir_cd <> n.int_rat_float_dir_cd
                or o.asset_thd_cls_cd <> n.asset_thd_cls_cd
                or o.white_list_cust_flg <> n.white_list_cust_flg
                or o.stud_loan_corp_id <> n.stud_loan_corp_id
                or o.stud_loan_corp_name <> n.stud_loan_corp_name
                or o.dir_indus_cd <> n.dir_indus_cd
                or o.cust_char_cd <> n.cust_char_cd
                or o.farm_flg <> n.farm_flg
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
from ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_tm n
    full join ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_itnet_stud_loan_dubil truncate partition for ('rnetf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_itnet_stud_loan_dubil exchange subpartition p_rnetf1_${batch_date} with table ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_itnet_stud_loan_dubil drop subpartition p_rnetf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_itnet_stud_loan_dubil to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_tm purge;
drop table ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_ex purge;
drop table ${iml_schema}.agt_itnet_stud_loan_dubil_rnetf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_itnet_stud_loan_dubil', partname => 'p_rnetf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);