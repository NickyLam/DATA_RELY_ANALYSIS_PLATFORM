/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_itnet_stud_loan_cont_rnetf1
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
drop table ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_tm purge;
drop table ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_itnet_stud_loan_cont add partition p_rnetf1 values ('rnetf1')(
        subpartition p_rnetf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_itnet_stud_loan_cont modify partition p_rnetf1
    add subpartition p_rnetf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_itnet_stud_loan_cont partition for ('rnetf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_tm
compress ${option_switch} for query high
as
select
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,crdt_appl_id -- 授信申请编号
    ,cust_id -- 客户编号
    ,cont_type_cd -- 合同类型代码
    ,cont_name -- 合同名称
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,cont_aval_amt -- 合同可用金额
    ,tenor_type_cd -- 期限类型代码
    ,loan_cont_tenor -- 贷款合同期限
    ,cont_value_dt -- 合同起息日期
    ,cont_exp_dt -- 合同到期日期
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,quote_lmt_flg -- 引用额度标志
    ,acct_instit_id -- 账务机构编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_emply_id -- 登记员工编号
    ,cust_mgr_id -- 客户经理编号
    ,director_cust_mgr_id -- 主管客户经理编号
    ,repay_acct_id -- 还款账户编号
    ,enter_acct_id -- 入账账户编号
    ,loan_usage_cd -- 贷款用途代码
    ,main_guar_way_cd -- 主担保方式代码
    ,cont_status_cd -- 合同状态代码
    ,cont_sign_dt -- 合同签约日期
    ,cont_create_dt -- 合同生成日期
    ,repay_way_cd -- 还款方式代码
    ,repay_day_cfm_cd -- 还款日确定代码
    ,repay_day -- 还款日
    ,e_acct_id -- E账户编号
    ,bind_card_card_no -- 绑定卡卡号
    ,bind_card_card_name -- 绑定卡卡名称
    ,enty_c_cors_open_bank_no -- 实体卡对应的开户行行号
    ,enty_c_cors_open_bank_name -- 实体卡对应的开户行名称
    ,recver_open_clear_bk_no -- 收款方开户行清算行行号
    ,acm_distr_amt -- 累计发放金额
    ,acm_callbk_amt -- 累计回收金额
    ,lmt_agt_id -- 额度协议编号
    ,guar_way_cd_2 -- 担保方式代码2
    ,guar_way_cd_3 -- 担保方式代码3
    ,mode_pay_cd -- 支付方式代码
    ,repay_intrv -- 还款间隔
    ,loan_distr_way_cd -- 贷款发放方式代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,exec_int_rat -- 执行利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,incre_crdt_mode_cd -- 增信模式代码
    ,dir_indus_cd -- 投向行业代码
    ,vehic_type_cd -- 车辆类型代码
    ,green_crdt_flg -- 绿色信贷标志
    ,green_loan_usage_cd -- 绿色贷款用途代码
    ,green_loan_usage_level2_cls_cd -- 绿色贷款用途二级分类代码
    ,green_loan_usage_level3_cls_cd -- 绿色贷款用途三级分类代码
    ,agclt_flg -- 涉农标志
    ,high_tech_property_type_cd -- 高技术产业类型代码
    ,digit_econ_property_type_cd -- 数字经济产业类型代码
    ,intel_prop_property_type_cd -- 知识产权产业类型代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,cul_and_rela_property_type_cd -- 文化及相关产业类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_itnet_stud_loan_cont
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_itnet_stud_loan_cont partition for ('rnetf1') where 0=1;

-- 2.1 insert data to tm table
-- rcrs_net_ctr_loan_cont-
insert into ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_tm(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,crdt_appl_id -- 授信申请编号
    ,cust_id -- 客户编号
    ,cont_type_cd -- 合同类型代码
    ,cont_name -- 合同名称
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,cont_aval_amt -- 合同可用金额
    ,tenor_type_cd -- 期限类型代码
    ,loan_cont_tenor -- 贷款合同期限
    ,cont_value_dt -- 合同起息日期
    ,cont_exp_dt -- 合同到期日期
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,quote_lmt_flg -- 引用额度标志
    ,acct_instit_id -- 账务机构编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_emply_id -- 登记员工编号
    ,cust_mgr_id -- 客户经理编号
    ,director_cust_mgr_id -- 主管客户经理编号
    ,repay_acct_id -- 还款账户编号
    ,enter_acct_id -- 入账账户编号
    ,loan_usage_cd -- 贷款用途代码
    ,main_guar_way_cd -- 主担保方式代码
    ,cont_status_cd -- 合同状态代码
    ,cont_sign_dt -- 合同签约日期
    ,cont_create_dt -- 合同生成日期
    ,repay_way_cd -- 还款方式代码
    ,repay_day_cfm_cd -- 还款日确定代码
    ,repay_day -- 还款日
    ,e_acct_id -- E账户编号
    ,bind_card_card_no -- 绑定卡卡号
    ,bind_card_card_name -- 绑定卡卡名称
    ,enty_c_cors_open_bank_no -- 实体卡对应的开户行行号
    ,enty_c_cors_open_bank_name -- 实体卡对应的开户行名称
    ,recver_open_clear_bk_no -- 收款方开户行清算行行号
    ,acm_distr_amt -- 累计发放金额
    ,acm_callbk_amt -- 累计回收金额
    ,lmt_agt_id -- 额度协议编号
    ,guar_way_cd_2 -- 担保方式代码2
    ,guar_way_cd_3 -- 担保方式代码3
    ,mode_pay_cd -- 支付方式代码
    ,repay_intrv -- 还款间隔
    ,loan_distr_way_cd -- 贷款发放方式代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,exec_int_rat -- 执行利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,incre_crdt_mode_cd -- 增信模式代码
    ,dir_indus_cd -- 投向行业代码
    ,vehic_type_cd -- 车辆类型代码
    ,green_crdt_flg -- 绿色信贷标志
    ,green_loan_usage_cd -- 绿色贷款用途代码
    ,green_loan_usage_level2_cls_cd -- 绿色贷款用途二级分类代码
    ,green_loan_usage_level3_cls_cd -- 绿色贷款用途三级分类代码
    ,agclt_flg -- 涉农标志
    ,high_tech_property_type_cd -- 高技术产业类型代码
    ,digit_econ_property_type_cd -- 数字经济产业类型代码
    ,intel_prop_property_type_cd -- 知识产权产业类型代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,cul_and_rela_property_type_cd -- 文化及相关产业类型代码
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '222511'||P1.CONT_NO -- 协议编号
    ,'9999' -- 法人编号
    ,P1.CONT_NO -- 合同编号
    ,P1.SERNO -- 授信申请编号
    ,P1.CUS_ID -- 客户编号
    ,NVL(TRIM(P1.CONT_TYPE),'000') -- 合同类型代码
    ,P1.CN_CONT_NO -- 合同名称
    ,NVL(TRIM(P1.CUR_TYPE),'CNY') -- 币种代码
    ,P1.CONT_AMT -- 合同金额
    ,P1.AVAIL_AMT -- 合同可用金额
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.TERM_TYPE END -- 期限类型代码
    ,TO_NUMBER(NVL(TRIM(P1.TERM),0)) -- 贷款合同期限
    ,${iml_schema}.DATEFORMAT_MIN(P1.LOAN_START_DATE) -- 合同起息日期
    ,${iml_schema}.DATEFORMAT_MAX(P1.LOAN_END_DATE) -- 合同到期日期
    ,P1.PRD_CODE -- 产品编号
    ,P1.PRD_NAME -- 产品名称
    ,case when P1.LIMIT_IND ='1' then '1'
     else '0'
end -- 引用额度标志
    ,P1.FINA_BR_ID -- 账务机构编号
    ,P1.INPUT_BR_ID -- 登记机构编号
    ,P1.INPUT_ID -- 登记员工编号
    ,P1.CUS_MANAGER -- 客户经理编号
    ,P1.MNG_BR_ID -- 主管客户经理编号
    ,P1.REPAYMENT_ACCOUNT -- 还款账户编号
    ,P1.ENTER_ACCOUNT -- 入账账户编号
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.LOAN_USE_TYPE END -- 贷款用途代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.ASSURE_MEANS_MAIN END -- 主担保方式代码
    ,P1.CONT_STATE -- 合同状态代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.SIGN_DATE) -- 合同签约日期
    ,${iml_schema}.DATEFORMAT_MIN(P1.CREATION_DATE) -- 合同生成日期
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.REPAYMENT_MODE END -- 还款方式代码
    ,NVL(TRIM(P1.REPAYMENT_DATE_CONFIRM),'0') -- 还款日确定代码
    ,P1.RETURN_DATE -- 还款日
    ,P1.E_ACCOUNT_NO -- E账户编号
    ,P1.ACCOUNT_END -- 绑定卡卡号
    ,P1.ACCOUNT_NAME_END -- 绑定卡卡名称
    ,P1.BANK_CODE_END -- 实体卡对应的开户行行号
    ,P1.BANK_NAME_END -- 实体卡对应的开户行名称
    ,P1.ACCOFOPEN_BANK1_END -- 收款方开户行清算行行号
    ,P1.TOTAL_ISSUE_AMT -- 累计发放金额
    ,P1.TOTAL_RECYLE_AMT -- 累计回收金额
    ,P1.LMT_SERNO -- 额度协议编号
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.ASSURE_MEANS2 END -- 担保方式代码2
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.ASSURE_MEANS3 END -- 担保方式代码3
    ,NVL(TRIM(P1.PAY_TYPE),'0') -- 支付方式代码
    ,P1.REPAYMENT_INTERVAL -- 还款间隔
    ,P1.LOAN_MODE -- 贷款发放方式代码
    ,nvl(trim(P1.RULING_IR)*100,0) -- 基准利率
    ,CASE WHEN R8.TARGET_CD_VAL IS NOT NULL THEN R8.TARGET_CD_VAL ELSE '@'||P1.INT_RATE_INC_OPT END -- 利率浮动方式代码
    ,trim(P1.REALITY_IR_Y)*100 -- 执行利率
    ,nvl(trim(P1.IR_ADJUST_MODE),'-') -- 利率调整方式代码
    ,P1.rate_type -- 利率类型代码
    ,nvl(trim(p1.CREDIT_INCR_CODE),'-') -- 增信模式代码
    ,CASE WHEN R11.TARGET_CD_VAL IS NOT NULL THEN R11.TARGET_CD_VAL ELSE '@'||P1.LOAN_DIRECTION END -- 投向行业代码
    ,nvl(trim(p1.CAR_TYPE),'-') -- 车辆类型代码
    ,case when trim(p1.GREEN_LOAN_FLAG)='2'then '0' else nvl(trim(p1.GREEN_LOAN_FLAG),'-') end -- 绿色信贷标志
    ,nvl(trim(p1.GREEN_LOAN_USE),'-') -- 绿色贷款用途代码
    ,nvl(trim(p1.GREEN_LOAN_USE_SND),'-') -- 绿色贷款用途二级分类代码
    ,nvl(trim(p1.GREEN_LOAN_USE_THD),'-') -- 绿色贷款用途三级分类代码
    ,case when trim(p1.SFSN_FLAG)='2'then '0' else nvl(trim(p1.SFSN_FLAG),'-') end -- 涉农标志
    ,nvl(trim(p1.HIGN_TECH_INDUSTRY),'-') -- 高技术产业类型代码
    ,nvl(trim(p1.NUM_CORE_INDUSTRY),'-') -- 数字经济产业类型代码
    ,nvl(trim(p1.KNOW_MORE_INDUSTRY),'-') -- 知识产权产业类型代码
    ,nvl(trim(p1.STATEGIC_INDUSTRY),'-') -- 战略新兴产业类型代码
    ,nvl(trim(p1.CULTURE_INDUSTRY),'-') -- 文化及相关产业类型代码
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'rcrs_net_ctr_loan_cont' -- 源表名称
    ,'rnetf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.rcrs_net_ctr_loan_cont p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.TERM_TYPE = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'RCRS'
        AND R2.SRC_TAB_EN_NAME= 'RCRS_NET_CTR_LOAN_CONT'
        AND R2.SRC_FIELD_EN_NAME= 'TERM_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_CONT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'TENOR_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.LOAN_USE_TYPE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'RCRS'
        AND R5.SRC_TAB_EN_NAME= 'RCRS_NET_CTR_LOAN_CONT'
        AND R5.SRC_FIELD_EN_NAME= 'LOAN_USE_TYPE'
        AND R5.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_CONT'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'LOAN_USAGE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.ASSURE_MEANS_MAIN = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'RCRS'
        AND R4.SRC_TAB_EN_NAME= 'RCRS_NET_CTR_LOAN_CONT'
        AND R4.SRC_FIELD_EN_NAME= 'ASSURE_MEANS_MAIN'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_CONT'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'MAIN_GUAR_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.REPAYMENT_MODE = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'RCRS'
        AND R3.SRC_TAB_EN_NAME= 'RCRS_NET_CTR_LOAN_CONT'
        AND R3.SRC_FIELD_EN_NAME= 'REPAYMENT_MODE'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_CONT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'REPAY_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.ASSURE_MEANS2 = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'RCRS'
        AND R6.SRC_TAB_EN_NAME= 'RCRS_NET_CTR_LOAN_CONT'
        AND R6.SRC_FIELD_EN_NAME= 'ASSURE_MEANS2'
        AND R6.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_CONT'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'GUAR_WAY_CD_2'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.ASSURE_MEANS3 = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'RCRS'
        AND R7.SRC_TAB_EN_NAME= 'RCRS_NET_CTR_LOAN_CONT'
        AND R7.SRC_FIELD_EN_NAME= 'ASSURE_MEANS3'
        AND R7.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_CONT'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'GUAR_WAY_CD_3'
    left join ${iml_schema}.ref_pub_cd_map r8 on P1.INT_RATE_INC_OPT = R8.SRC_CODE_VAL
        AND R8.SORC_SYS_CD= 'RCRS'
        AND R8.SRC_TAB_EN_NAME= 'RCRS_NET_CTR_LOAN_CONT'
        AND R8.SRC_FIELD_EN_NAME= 'INT_RATE_INC_OPT'
        AND R8.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_CONT'
        AND R8.TARGET_TAB_FIELD_EN_NAME= 'INT_RAT_FLOAT_WAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r11 on P1.LOAN_DIRECTION = R11.SRC_CODE_VAL
        AND R11.SORC_SYS_CD= 'RCRS'
        AND R11.SRC_TAB_EN_NAME= 'RCRS_NET_CTR_LOAN_CONT'
        AND R11.SRC_FIELD_EN_NAME= 'LOAN_DIRECTION'
        AND R11.TARGET_TAB_EN_NAME= 'AGT_ITNET_STUD_LOAN_CONT'
        AND R11.TARGET_TAB_FIELD_EN_NAME= 'DIR_INDUS_CD'

where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_tm 
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
insert /*+ append */ into ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_ex(
    agt_id -- 协议编号
    ,lp_id -- 法人编号
    ,cont_id -- 合同编号
    ,crdt_appl_id -- 授信申请编号
    ,cust_id -- 客户编号
    ,cont_type_cd -- 合同类型代码
    ,cont_name -- 合同名称
    ,curr_cd -- 币种代码
    ,cont_amt -- 合同金额
    ,cont_aval_amt -- 合同可用金额
    ,tenor_type_cd -- 期限类型代码
    ,loan_cont_tenor -- 贷款合同期限
    ,cont_value_dt -- 合同起息日期
    ,cont_exp_dt -- 合同到期日期
    ,prod_id -- 产品编号
    ,prod_name -- 产品名称
    ,quote_lmt_flg -- 引用额度标志
    ,acct_instit_id -- 账务机构编号
    ,rgst_org_id -- 登记机构编号
    ,rgst_emply_id -- 登记员工编号
    ,cust_mgr_id -- 客户经理编号
    ,director_cust_mgr_id -- 主管客户经理编号
    ,repay_acct_id -- 还款账户编号
    ,enter_acct_id -- 入账账户编号
    ,loan_usage_cd -- 贷款用途代码
    ,main_guar_way_cd -- 主担保方式代码
    ,cont_status_cd -- 合同状态代码
    ,cont_sign_dt -- 合同签约日期
    ,cont_create_dt -- 合同生成日期
    ,repay_way_cd -- 还款方式代码
    ,repay_day_cfm_cd -- 还款日确定代码
    ,repay_day -- 还款日
    ,e_acct_id -- E账户编号
    ,bind_card_card_no -- 绑定卡卡号
    ,bind_card_card_name -- 绑定卡卡名称
    ,enty_c_cors_open_bank_no -- 实体卡对应的开户行行号
    ,enty_c_cors_open_bank_name -- 实体卡对应的开户行名称
    ,recver_open_clear_bk_no -- 收款方开户行清算行行号
    ,acm_distr_amt -- 累计发放金额
    ,acm_callbk_amt -- 累计回收金额
    ,lmt_agt_id -- 额度协议编号
    ,guar_way_cd_2 -- 担保方式代码2
    ,guar_way_cd_3 -- 担保方式代码3
    ,mode_pay_cd -- 支付方式代码
    ,repay_intrv -- 还款间隔
    ,loan_distr_way_cd -- 贷款发放方式代码
    ,base_rat -- 基准利率
    ,int_rat_float_way_cd -- 利率浮动方式代码
    ,exec_int_rat -- 执行利率
    ,int_rat_adj_way_cd -- 利率调整方式代码
    ,int_rat_type_cd -- 利率类型代码
    ,incre_crdt_mode_cd -- 增信模式代码
    ,dir_indus_cd -- 投向行业代码
    ,vehic_type_cd -- 车辆类型代码
    ,green_crdt_flg -- 绿色信贷标志
    ,green_loan_usage_cd -- 绿色贷款用途代码
    ,green_loan_usage_level2_cls_cd -- 绿色贷款用途二级分类代码
    ,green_loan_usage_level3_cls_cd -- 绿色贷款用途三级分类代码
    ,agclt_flg -- 涉农标志
    ,high_tech_property_type_cd -- 高技术产业类型代码
    ,digit_econ_property_type_cd -- 数字经济产业类型代码
    ,intel_prop_property_type_cd -- 知识产权产业类型代码
    ,strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,cul_and_rela_property_type_cd -- 文化及相关产业类型代码
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
    ,nvl(n.crdt_appl_id, o.crdt_appl_id) as crdt_appl_id -- 授信申请编号
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户编号
    ,nvl(n.cont_type_cd, o.cont_type_cd) as cont_type_cd -- 合同类型代码
    ,nvl(n.cont_name, o.cont_name) as cont_name -- 合同名称
    ,nvl(n.curr_cd, o.curr_cd) as curr_cd -- 币种代码
    ,nvl(n.cont_amt, o.cont_amt) as cont_amt -- 合同金额
    ,nvl(n.cont_aval_amt, o.cont_aval_amt) as cont_aval_amt -- 合同可用金额
    ,nvl(n.tenor_type_cd, o.tenor_type_cd) as tenor_type_cd -- 期限类型代码
    ,nvl(n.loan_cont_tenor, o.loan_cont_tenor) as loan_cont_tenor -- 贷款合同期限
    ,nvl(n.cont_value_dt, o.cont_value_dt) as cont_value_dt -- 合同起息日期
    ,nvl(n.cont_exp_dt, o.cont_exp_dt) as cont_exp_dt -- 合同到期日期
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 产品编号
    ,nvl(n.prod_name, o.prod_name) as prod_name -- 产品名称
    ,nvl(n.quote_lmt_flg, o.quote_lmt_flg) as quote_lmt_flg -- 引用额度标志
    ,nvl(n.acct_instit_id, o.acct_instit_id) as acct_instit_id -- 账务机构编号
    ,nvl(n.rgst_org_id, o.rgst_org_id) as rgst_org_id -- 登记机构编号
    ,nvl(n.rgst_emply_id, o.rgst_emply_id) as rgst_emply_id -- 登记员工编号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.director_cust_mgr_id, o.director_cust_mgr_id) as director_cust_mgr_id -- 主管客户经理编号
    ,nvl(n.repay_acct_id, o.repay_acct_id) as repay_acct_id -- 还款账户编号
    ,nvl(n.enter_acct_id, o.enter_acct_id) as enter_acct_id -- 入账账户编号
    ,nvl(n.loan_usage_cd, o.loan_usage_cd) as loan_usage_cd -- 贷款用途代码
    ,nvl(n.main_guar_way_cd, o.main_guar_way_cd) as main_guar_way_cd -- 主担保方式代码
    ,nvl(n.cont_status_cd, o.cont_status_cd) as cont_status_cd -- 合同状态代码
    ,nvl(n.cont_sign_dt, o.cont_sign_dt) as cont_sign_dt -- 合同签约日期
    ,nvl(n.cont_create_dt, o.cont_create_dt) as cont_create_dt -- 合同生成日期
    ,nvl(n.repay_way_cd, o.repay_way_cd) as repay_way_cd -- 还款方式代码
    ,nvl(n.repay_day_cfm_cd, o.repay_day_cfm_cd) as repay_day_cfm_cd -- 还款日确定代码
    ,nvl(n.repay_day, o.repay_day) as repay_day -- 还款日
    ,nvl(n.e_acct_id, o.e_acct_id) as e_acct_id -- E账户编号
    ,nvl(n.bind_card_card_no, o.bind_card_card_no) as bind_card_card_no -- 绑定卡卡号
    ,nvl(n.bind_card_card_name, o.bind_card_card_name) as bind_card_card_name -- 绑定卡卡名称
    ,nvl(n.enty_c_cors_open_bank_no, o.enty_c_cors_open_bank_no) as enty_c_cors_open_bank_no -- 实体卡对应的开户行行号
    ,nvl(n.enty_c_cors_open_bank_name, o.enty_c_cors_open_bank_name) as enty_c_cors_open_bank_name -- 实体卡对应的开户行名称
    ,nvl(n.recver_open_clear_bk_no, o.recver_open_clear_bk_no) as recver_open_clear_bk_no -- 收款方开户行清算行行号
    ,nvl(n.acm_distr_amt, o.acm_distr_amt) as acm_distr_amt -- 累计发放金额
    ,nvl(n.acm_callbk_amt, o.acm_callbk_amt) as acm_callbk_amt -- 累计回收金额
    ,nvl(n.lmt_agt_id, o.lmt_agt_id) as lmt_agt_id -- 额度协议编号
    ,nvl(n.guar_way_cd_2, o.guar_way_cd_2) as guar_way_cd_2 -- 担保方式代码2
    ,nvl(n.guar_way_cd_3, o.guar_way_cd_3) as guar_way_cd_3 -- 担保方式代码3
    ,nvl(n.mode_pay_cd, o.mode_pay_cd) as mode_pay_cd -- 支付方式代码
    ,nvl(n.repay_intrv, o.repay_intrv) as repay_intrv -- 还款间隔
    ,nvl(n.loan_distr_way_cd, o.loan_distr_way_cd) as loan_distr_way_cd -- 贷款发放方式代码
    ,nvl(n.base_rat, o.base_rat) as base_rat -- 基准利率
    ,nvl(n.int_rat_float_way_cd, o.int_rat_float_way_cd) as int_rat_float_way_cd -- 利率浮动方式代码
    ,nvl(n.exec_int_rat, o.exec_int_rat) as exec_int_rat -- 执行利率
    ,nvl(n.int_rat_adj_way_cd, o.int_rat_adj_way_cd) as int_rat_adj_way_cd -- 利率调整方式代码
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.incre_crdt_mode_cd, o.incre_crdt_mode_cd) as incre_crdt_mode_cd -- 增信模式代码
    ,nvl(n.dir_indus_cd, o.dir_indus_cd) as dir_indus_cd -- 投向行业代码
    ,nvl(n.vehic_type_cd, o.vehic_type_cd) as vehic_type_cd -- 车辆类型代码
    ,nvl(n.green_crdt_flg, o.green_crdt_flg) as green_crdt_flg -- 绿色信贷标志
    ,nvl(n.green_loan_usage_cd, o.green_loan_usage_cd) as green_loan_usage_cd -- 绿色贷款用途代码
    ,nvl(n.green_loan_usage_level2_cls_cd, o.green_loan_usage_level2_cls_cd) as green_loan_usage_level2_cls_cd -- 绿色贷款用途二级分类代码
    ,nvl(n.green_loan_usage_level3_cls_cd, o.green_loan_usage_level3_cls_cd) as green_loan_usage_level3_cls_cd -- 绿色贷款用途三级分类代码
    ,nvl(n.agclt_flg, o.agclt_flg) as agclt_flg -- 涉农标志
    ,nvl(n.high_tech_property_type_cd, o.high_tech_property_type_cd) as high_tech_property_type_cd -- 高技术产业类型代码
    ,nvl(n.digit_econ_property_type_cd, o.digit_econ_property_type_cd) as digit_econ_property_type_cd -- 数字经济产业类型代码
    ,nvl(n.intel_prop_property_type_cd, o.intel_prop_property_type_cd) as intel_prop_property_type_cd -- 知识产权产业类型代码
    ,nvl(n.strtg_new_indus_type_cd, o.strtg_new_indus_type_cd) as strtg_new_indus_type_cd -- 战略新兴产业类型代码
    ,nvl(n.cul_and_rela_property_type_cd, o.cul_and_rela_property_type_cd) as cul_and_rela_property_type_cd -- 文化及相关产业类型代码
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.agt_id is null
                and o.lp_id is null
            ) or (
                o.cont_id <> n.cont_id
                or o.crdt_appl_id <> n.crdt_appl_id
                or o.cust_id <> n.cust_id
                or o.cont_type_cd <> n.cont_type_cd
                or o.cont_name <> n.cont_name
                or o.curr_cd <> n.curr_cd
                or o.cont_amt <> n.cont_amt
                or o.cont_aval_amt <> n.cont_aval_amt
                or o.tenor_type_cd <> n.tenor_type_cd
                or o.loan_cont_tenor <> n.loan_cont_tenor
                or o.cont_value_dt <> n.cont_value_dt
                or o.cont_exp_dt <> n.cont_exp_dt
                or o.prod_id <> n.prod_id
                or o.prod_name <> n.prod_name
                or o.quote_lmt_flg <> n.quote_lmt_flg
                or o.acct_instit_id <> n.acct_instit_id
                or o.rgst_org_id <> n.rgst_org_id
                or o.rgst_emply_id <> n.rgst_emply_id
                or o.cust_mgr_id <> n.cust_mgr_id
                or o.director_cust_mgr_id <> n.director_cust_mgr_id
                or o.repay_acct_id <> n.repay_acct_id
                or o.enter_acct_id <> n.enter_acct_id
                or o.loan_usage_cd <> n.loan_usage_cd
                or o.main_guar_way_cd <> n.main_guar_way_cd
                or o.cont_status_cd <> n.cont_status_cd
                or o.cont_sign_dt <> n.cont_sign_dt
                or o.cont_create_dt <> n.cont_create_dt
                or o.repay_way_cd <> n.repay_way_cd
                or o.repay_day_cfm_cd <> n.repay_day_cfm_cd
                or o.repay_day <> n.repay_day
                or o.e_acct_id <> n.e_acct_id
                or o.bind_card_card_no <> n.bind_card_card_no
                or o.bind_card_card_name <> n.bind_card_card_name
                or o.enty_c_cors_open_bank_no <> n.enty_c_cors_open_bank_no
                or o.enty_c_cors_open_bank_name <> n.enty_c_cors_open_bank_name
                or o.recver_open_clear_bk_no <> n.recver_open_clear_bk_no
                or o.acm_distr_amt <> n.acm_distr_amt
                or o.acm_callbk_amt <> n.acm_callbk_amt
                or o.lmt_agt_id <> n.lmt_agt_id
                or o.guar_way_cd_2 <> n.guar_way_cd_2
                or o.guar_way_cd_3 <> n.guar_way_cd_3
                or o.mode_pay_cd <> n.mode_pay_cd
                or o.repay_intrv <> n.repay_intrv
                or o.loan_distr_way_cd <> n.loan_distr_way_cd
                or o.base_rat <> n.base_rat
                or o.int_rat_float_way_cd <> n.int_rat_float_way_cd
                or o.exec_int_rat <> n.exec_int_rat
                or o.int_rat_adj_way_cd <> n.int_rat_adj_way_cd
                or o.int_rat_type_cd <> n.int_rat_type_cd
                or o.incre_crdt_mode_cd <> n.incre_crdt_mode_cd
                or o.dir_indus_cd <> n.dir_indus_cd
                or o.vehic_type_cd <> n.vehic_type_cd
                or o.green_crdt_flg <> n.green_crdt_flg
                or o.green_loan_usage_cd <> n.green_loan_usage_cd
                or o.green_loan_usage_level2_cls_cd <> n.green_loan_usage_level2_cls_cd
                or o.green_loan_usage_level3_cls_cd <> n.green_loan_usage_level3_cls_cd
                or o.agclt_flg <> n.agclt_flg
                or o.high_tech_property_type_cd <> n.high_tech_property_type_cd
                or o.digit_econ_property_type_cd <> n.digit_econ_property_type_cd
                or o.intel_prop_property_type_cd <> n.intel_prop_property_type_cd
                or o.strtg_new_indus_type_cd <> n.strtg_new_indus_type_cd
                or o.cul_and_rela_property_type_cd <> n.cul_and_rela_property_type_cd
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
from ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_tm n
    full join ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_bk o
        on
            o.agt_id = n.agt_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_itnet_stud_loan_cont truncate partition for ('rnetf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_itnet_stud_loan_cont exchange subpartition p_rnetf1_${batch_date} with table ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_itnet_stud_loan_cont drop subpartition p_rnetf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_itnet_stud_loan_cont to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_tm purge;
drop table ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_ex purge;
drop table ${iml_schema}.agt_itnet_stud_loan_cont_rnetf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_itnet_stud_loan_cont', partname => 'p_rnetf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);