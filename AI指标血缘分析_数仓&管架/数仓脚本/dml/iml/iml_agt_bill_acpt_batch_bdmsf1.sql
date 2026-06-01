/*
Purpose:    整全模型层-快照表脚本，备份目标表当月数据（不含当天），用前一天数据与当天数据整合后插入到目标表中。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_agt_bill_acpt_batch_bdmsf1
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
drop table ${iml_schema}.agt_bill_acpt_batch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_acpt_batch_bdmsf1_ex purge;

-- 2.2 add partition for target table
alter table ${iml_schema}.agt_bill_acpt_batch add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.agt_bill_acpt_batch modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

-- 2.3 if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iml_schema}.agt_bill_acpt_batch_bdmsf1_bk nologging
compress ${option_switch} for query high
as
select * from ${iml_schema}.agt_bill_acpt_batch partition for ('bdmsf1')
where create_dt < to_date('${batch_date}','yyyymmdd')
;

-- 2.4 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.agt_bill_acpt_batch_bdmsf1_tm
compress ${option_switch} for query high
as
select
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,acpt_agt_id -- 承兑协议编号
    ,acpt_batch_id -- 承兑批次协议编号
    ,task_type_cd -- 任务类型代码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,drawer_cust_id -- 出票人客户编号
    ,appl_acpt_amt -- 申请承兑金额
    ,appl_draw_dt -- 申请出票日期
    ,exp_dt -- 到期日期
    ,margin_ratio -- 保证金比例
    ,comm_fee_ratio -- 手续费比例
    ,tran_amt -- 交易金额
    ,pay_bank_bank_no -- 付款行行号
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,operr_id -- 操作员编号
    ,tran_dt -- 交易日期
    ,bus_logic_check_status_cd -- 业务逻辑检查状态代码
    ,apv_status_cd -- 审批状态代码
    ,check_status_cd -- 审核状态代码
    ,crdt_check_status_cd -- 授信检查状态代码
    ,final_modif_tm -- 最后修改时间
    ,drawer_acct_num -- 出票人账号
    ,drawer_bank_name -- 出票人行名称
    ,actl_dir_indus_name -- 实际投向行业名称
    ,enter_acct_org_id -- 入账机构编号
    ,acpt_fee -- 承兑费
    ,mgmt_fee -- 管理费
    ,agt_exp_dt -- 协议到期日期
    ,acct_amt -- 账户金额
    ,apprved_use_crdt_open_amt -- 已批准使用授信敞口金额
    ,distr_post_acm_use_open_amt -- 本次放款后累计使用敞口金额
    ,cert_no -- 证件号码
    ,onl_bank_batch_id -- 网银批量批次编号
    ,fst_repay_acct_id -- 第一还款账户编号
    ,margin_tenor_type_cd -- 保证金期限类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_type_cd -- 保证金类型代码
    ,int_rat_type_cd -- 利率类型代码
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_flo_val -- 保证金浮动值
    ,rela_party_que_rest_cd -- 关联方查询结果代码
    ,tgls_entry_status_cd -- 核算中台记账状态代码
    ,ncbs_entry_status_cd -- 核心记账状态代码
    ,h_data_flg -- 历史数据标志
    ,open_type_cd -- 敞口类型代码
    ,open_amt -- 敞口金额
    ,adj_dep_prft_flg -- 调整存款收益标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_acpt_batch
where 0=1;

-- 2.5 create temp table
create table ${iml_schema}.agt_bill_acpt_batch_bdmsf1_ex nologging
compress ${option_switch} for query high
as select * from ${iml_schema}.agt_bill_acpt_batch partition for ('bdmsf1') where 0=1;

-- 2.1 insert data to tm table
-- bdms_bms_accept_contract-
insert into ${iml_schema}.agt_bill_acpt_batch_bdmsf1_tm(
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,acpt_agt_id -- 承兑协议编号
    ,acpt_batch_id -- 承兑批次协议编号
    ,task_type_cd -- 任务类型代码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,drawer_cust_id -- 出票人客户编号
    ,appl_acpt_amt -- 申请承兑金额
    ,appl_draw_dt -- 申请出票日期
    ,exp_dt -- 到期日期
    ,margin_ratio -- 保证金比例
    ,comm_fee_ratio -- 手续费比例
    ,tran_amt -- 交易金额
    ,pay_bank_bank_no -- 付款行行号
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,operr_id -- 操作员编号
    ,tran_dt -- 交易日期
    ,bus_logic_check_status_cd -- 业务逻辑检查状态代码
    ,apv_status_cd -- 审批状态代码
    ,check_status_cd -- 审核状态代码
    ,crdt_check_status_cd -- 授信检查状态代码
    ,final_modif_tm -- 最后修改时间
    ,drawer_acct_num -- 出票人账号
    ,drawer_bank_name -- 出票人行名称
    ,actl_dir_indus_name -- 实际投向行业名称
    ,enter_acct_org_id -- 入账机构编号
    ,acpt_fee -- 承兑费
    ,mgmt_fee -- 管理费
    ,agt_exp_dt -- 协议到期日期
    ,acct_amt -- 账户金额
    ,apprved_use_crdt_open_amt -- 已批准使用授信敞口金额
    ,distr_post_acm_use_open_amt -- 本次放款后累计使用敞口金额
    ,cert_no -- 证件号码
    ,onl_bank_batch_id -- 网银批量批次编号
    ,fst_repay_acct_id -- 第一还款账户编号
    ,margin_tenor_type_cd -- 保证金期限类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_type_cd -- 保证金类型代码
    ,int_rat_type_cd -- 利率类型代码
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_flo_val -- 保证金浮动值
    ,rela_party_que_rest_cd -- 关联方查询结果代码
    ,tgls_entry_status_cd -- 核算中台记账状态代码
    ,ncbs_entry_status_cd -- 核心记账状态代码
    ,h_data_flg -- 历史数据标志
    ,open_type_cd -- 敞口类型代码
    ,open_amt -- 敞口金额
    ,adj_dep_prft_flg -- 调整存款收益标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 批次编号
    ,'9999' -- 法人编号
    ,P1.BUSI_BRANCH_NO -- 机构编号
    ,P1.CREDIT_NO -- 承兑协议编号
    ,P1.PROTOCOL_NO -- 承兑批次协议编号
    ,nvl(trim（P1.TASK_TYPE),'-') -- 任务类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据介质代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,P1.REMITTER_CUST_NO -- 出票人客户编号
    ,P1.APPLY_ACCEPT_AMOUNT -- 申请承兑金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_REMIT_DATE) -- 申请出票日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.MATURITY_DATE) -- 到期日期
    ,P1.BAIL_RATIO -- 保证金比例
    ,P1.CHARGE_RATIO -- 手续费比例
    ,P1.TRANS_AMOUNT -- 交易金额
    ,P1.DRAWEE_BANK_NO -- 付款行行号
    ,P1.MANAGER_NO -- 客户经理编号
    ,P1.DEPARTMENT_NO -- 部门编号
    ,P1.OPERATOR_NO -- 操作员编号
    ,P1.OPERATOR_DATE -- 交易日期
    ,nvl(trim(P1.LOGIC_CHECK_STATUS),0) -- 业务逻辑检查状态代码
    ,CASE WHEN TRIM(P1.PROTOCOL_STATUS)='11'THEN '16'
       WHEN TRIM(P1.PROTOCOL_STATUS)='12' THEN '17'
       WHEN TRIM(P1.PROTOCOL_STATUS)='13' THEN '18' 
       ELSE NVL(TRIM(P1.PROTOCOL_STATUS),'-') END -- 审批状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.AUDIT_STATUS END -- 审核状态代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.CREDIT_CHECK_STATUS END -- 授信检查状态代码
    ,P1.LAST_TXN_DATE -- 最后修改时间
    ,P1.REMITTER_ACCOUNT -- 出票人账号
    ,P1.REMITTER_BANK_NAME -- 出票人行名称
    ,P1.ACTUALLY_INDUSTY -- 实际投向行业名称
    ,P1.TRANS_BRANCH_NO -- 入账机构编号
    ,P1.ACCEPT_FEE -- 承兑费
    ,P1.MANAGE_FEE -- 管理费
    ,${iml_schema}.DATEFORMAT_MAX2(P1.CONTRACT_DATE) -- 协议到期日期
    ,P1.ACCT_AMOUNT -- 账户金额
    ,P1.ALL_CREDIT_EXP -- 已批准使用授信敞口金额
    ,P1.TOTAL_USE_CREDIT_EXP -- 本次放款后累计使用敞口金额
    ,P1.CERT_ID -- 证件号码
    ,P1.BATCH_NO -- 网银批量批次编号
    ,P1.FIRST_REPAYMENT_ACCT -- 第一还款账户编号
    ,nvl(trim(P1.BAIL_TERM),'-') -- 保证金期限类型代码
    ,P1.BAIL_ACCOUNT -- 保证金账户编号
    ,nvl(trim(P1.BAIL_TYPE),'-') -- 保证金类型代码
    ,nvl(trim(P1.RATES_TYPE),'-') -- 利率类型代码
    ,nvl(trim(P1.PDRIFD),'-') -- 保证金利率浮动类型代码
    ,nvl(trim(P1.PDRIFM),'-') -- 保证金利率浮动方式代码
    ,P1.PDRIFV -- 保证金浮动值
    ,nvl(trim(P1.IS_RELATED),'-') -- 关联方查询结果代码
    ,P1.acct_status -- 核算中台记账状态代码
    ,P1.send_file_status -- 核心记账状态代码
    ,p1.RESERVE1 -- 历史数据标志
    ,'-' -- 敞口类型代码
    ,0 -- 敞口金额
    ,'-' -- 调整存款收益标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_bms_accept_contract' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_bms_accept_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DRAFT_ATTR = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_BMS_ACCEPT_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_ACPT_BATCH'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BILL_MED_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DRAFT_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_BMS_ACCEPT_CONTRACT'
        AND R2.SRC_FIELD_EN_NAME= 'DRAFT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_ACPT_BATCH'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.AUDIT_STATUS= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'BDMS'
        AND R4.SRC_TAB_EN_NAME= 'BDMS_BMS_ACCEPT_CONTRACT'
        AND R4.SRC_FIELD_EN_NAME= 'AUDIT_STATUS'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_BILL_ACPT_BATCH'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'CHECK_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.CREDIT_CHECK_STATUS= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_BMS_ACCEPT_CONTRACT'
        AND R3.SRC_FIELD_EN_NAME= 'CREDIT_CHECK_STATUS'
        AND R3.TARGET_TAB_EN_NAME= 'AGT_BILL_ACPT_BATCH'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'CRDT_CHECK_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;

-- bdms_cpes_accept_contract-
insert into ${iml_schema}.agt_bill_acpt_batch_bdmsf1_tm(
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,acpt_agt_id -- 承兑协议编号
    ,acpt_batch_id -- 承兑批次协议编号
    ,task_type_cd -- 任务类型代码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,drawer_cust_id -- 出票人客户编号
    ,appl_acpt_amt -- 申请承兑金额
    ,appl_draw_dt -- 申请出票日期
    ,exp_dt -- 到期日期
    ,margin_ratio -- 保证金比例
    ,comm_fee_ratio -- 手续费比例
    ,tran_amt -- 交易金额
    ,pay_bank_bank_no -- 付款行行号
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,operr_id -- 操作员编号
    ,tran_dt -- 交易日期
    ,bus_logic_check_status_cd -- 业务逻辑检查状态代码
    ,apv_status_cd -- 审批状态代码
    ,check_status_cd -- 审核状态代码
    ,crdt_check_status_cd -- 授信检查状态代码
    ,final_modif_tm -- 最后修改时间
    ,drawer_acct_num -- 出票人账号
    ,drawer_bank_name -- 出票人行名称
    ,actl_dir_indus_name -- 实际投向行业名称
    ,enter_acct_org_id -- 入账机构编号
    ,acpt_fee -- 承兑费
    ,mgmt_fee -- 管理费
    ,agt_exp_dt -- 协议到期日期
    ,acct_amt -- 账户金额
    ,apprved_use_crdt_open_amt -- 已批准使用授信敞口金额
    ,distr_post_acm_use_open_amt -- 本次放款后累计使用敞口金额
    ,cert_no -- 证件号码
    ,onl_bank_batch_id -- 网银批量批次编号
    ,fst_repay_acct_id -- 第一还款账户编号
    ,margin_tenor_type_cd -- 保证金期限类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_type_cd -- 保证金类型代码
    ,int_rat_type_cd -- 利率类型代码
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_flo_val -- 保证金浮动值
    ,rela_party_que_rest_cd -- 关联方查询结果代码
    ,tgls_entry_status_cd -- 核算中台记账状态代码
    ,ncbs_entry_status_cd -- 核心记账状态代码
    ,h_data_flg -- 历史数据标志
    ,open_type_cd -- 敞口类型代码
    ,open_amt -- 敞口金额
    ,adj_dep_prft_flg -- 调整存款收益标志
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    P1.ID -- 批次编号
    ,'9999' -- 法人编号
    ,P1.BUSI_BRANCH_NO -- 机构编号
    ,P1.CREDIT_NO -- 承兑协议编号
    ,P1.CONTRACT_NO -- 承兑批次协议编号
    ,'-' -- 任务类型代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据介质代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.DRAFT_TYPE END -- 票据类型代码
    ,P1.REMITTER_CUST_NO -- 出票人客户编号
    ,P1.APPLY_ACCEPT_AMOUNT -- 申请承兑金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_REMIT_DATE) -- 申请出票日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.MATURITY_DATE) -- 到期日期
    ,P1.DEPOSIT_RATIO -- 保证金比例
    ,P1.CHARGE_RATIO -- 手续费比例
    ,P1.TRANS_AMOUNT -- 交易金额
    ,P1.PAYER_BANK_NO -- 付款行行号
    ,P1.MANAGER_NO -- 客户经理编号
    ,P1.DEPARTMENT_NO -- 部门编号
    ,P1.LAST_OPERATOR -- 操作员编号
    ,${iml_schema}.DATEFORMAT_MAX2(SUBSTR(P1.CREATE_TIME,1,8)) -- 交易日期
    ,'0' -- 业务逻辑检查状态代码
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.CONTRACT_STATUS END -- 审批状态代码
    ,NVL(TRIM(P1.ACCEPT_STATUS),'-') -- 审核状态代码
    ,'-' -- 授信检查状态代码
    ,${iml_schema}.TIMEFORMAT_MAX2(P1.LAST_UPDATE_TIME) -- 最后修改时间
    ,P1.REMITTER_ACCT -- 出票人账号
    ,P1.REMITTER_BANK_NAME -- 出票人行名称
    ,P1.ACTUALLY_INDUSTY -- 实际投向行业名称
    ,P1.ACCOUNT_BRANCH_NO -- 入账机构编号
    ,P1.ACCEPT_FEE -- 承兑费
    ,P1.MANAGE_FEE -- 管理费
    ,${iml_schema}.TIMEFORMAT_MAX2(P1.CONTRACT_DATE) -- 协议到期日期
    ,P1.ACCT_AMOUNT -- 账户金额
    ,P1.ALL_CREDIT_EXP -- 已批准使用授信敞口金额
    ,P1.TOTAL_USE_CREDIT_EXP -- 本次放款后累计使用敞口金额
    ,P1.CERT_ID -- 证件号码
    ,P1.BATCH_NO -- 网银批量批次编号
    ,P1.FIRST_REPAYMENT_ACCT -- 第一还款账户编号
    ,nvl(trim(P1.BAIL_TERM),'-') -- 保证金期限类型代码
    ,P1.BAIL_ACCOUNT -- 保证金账户编号
    ,nvl(trim(P1.BAIL_TYPE),'-') -- 保证金类型代码
    ,nvl(trim(P1.RATES_TYPE),'-') -- 利率类型代码
    ,nvl(trim(P1.PDRIFD),'-') -- 保证金利率浮动类型代码
    ,nvl(trim(P1.PDRIFM),'-') -- 保证金利率浮动方式代码
    ,P1.PDRIFV -- 保证金浮动值
    ,nvl(trim(P1.IS_RELATED),'-') -- 关联方查询结果代码
    ,P1.acct_status -- 核算中台记账状态代码
    ,P1.send_file_status -- 核心记账状态代码
    ,' ' -- 历史数据标志
    ,nvl(trim(P1.EXPOSURE_TYPE),'-') -- 敞口类型代码
    ,P1.EXPOSURE_AMOUNT -- 敞口金额
    ,nvl(trim(P1.IS_ADJUST_DEPOSIT),'-') -- 调整存款收益标志
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_accept_contract' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_accept_contract p1
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.DRAFT_ATTR = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CPES_ACCEPT_CONTRACT'
        AND R1.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R1.TARGET_TAB_EN_NAME= 'AGT_BILL_ACPT_BATCH'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'BILL_MED_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.DRAFT_TYPE= R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_ACCEPT_CONTRACT'
        AND R2.SRC_FIELD_EN_NAME= 'DRAFT_TYPE'
        AND R2.TARGET_TAB_EN_NAME= 'AGT_BILL_ACPT_BATCH'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'BILL_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.CONTRACT_STATUS= R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'BDMS'
        AND R4.SRC_TAB_EN_NAME= 'BDMS_CPES_ACCEPT_CONTRACT'
        AND R4.SRC_FIELD_EN_NAME= 'CONTRACT_STATUS'
        AND R4.TARGET_TAB_EN_NAME= 'AGT_BILL_ACPT_BATCH'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'APV_STATUS_CD'
where p1.start_dt <= to_date('${batch_date}','yyyymmdd') and p1.end_dt > to_date('${batch_date}','yyyymmdd')
;
commit;


commit;



whenever sqlerror exit sql.sqlcode;
declare
cnt integer;
begin
  for cur in (select 1 from dual) loop
  	select count(1) into cnt from (select 1 from ${iml_schema}.agt_bill_acpt_batch_bdmsf1_tm 
  	                                group by 
  	                                        batch_id
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
insert /*+ append */ into ${iml_schema}.agt_bill_acpt_batch_bdmsf1_ex(
    batch_id -- 批次编号
    ,lp_id -- 法人编号
    ,org_id -- 机构编号
    ,acpt_agt_id -- 承兑协议编号
    ,acpt_batch_id -- 承兑批次协议编号
    ,task_type_cd -- 任务类型代码
    ,bill_med_cd -- 票据介质代码
    ,bill_type_cd -- 票据类型代码
    ,drawer_cust_id -- 出票人客户编号
    ,appl_acpt_amt -- 申请承兑金额
    ,appl_draw_dt -- 申请出票日期
    ,exp_dt -- 到期日期
    ,margin_ratio -- 保证金比例
    ,comm_fee_ratio -- 手续费比例
    ,tran_amt -- 交易金额
    ,pay_bank_bank_no -- 付款行行号
    ,cust_mgr_id -- 客户经理编号
    ,dept_id -- 部门编号
    ,operr_id -- 操作员编号
    ,tran_dt -- 交易日期
    ,bus_logic_check_status_cd -- 业务逻辑检查状态代码
    ,apv_status_cd -- 审批状态代码
    ,check_status_cd -- 审核状态代码
    ,crdt_check_status_cd -- 授信检查状态代码
    ,final_modif_tm -- 最后修改时间
    ,drawer_acct_num -- 出票人账号
    ,drawer_bank_name -- 出票人行名称
    ,actl_dir_indus_name -- 实际投向行业名称
    ,enter_acct_org_id -- 入账机构编号
    ,acpt_fee -- 承兑费
    ,mgmt_fee -- 管理费
    ,agt_exp_dt -- 协议到期日期
    ,acct_amt -- 账户金额
    ,apprved_use_crdt_open_amt -- 已批准使用授信敞口金额
    ,distr_post_acm_use_open_amt -- 本次放款后累计使用敞口金额
    ,cert_no -- 证件号码
    ,onl_bank_batch_id -- 网银批量批次编号
    ,fst_repay_acct_id -- 第一还款账户编号
    ,margin_tenor_type_cd -- 保证金期限类型代码
    ,margin_acct_id -- 保证金账户编号
    ,margin_type_cd -- 保证金类型代码
    ,int_rat_type_cd -- 利率类型代码
    ,margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,margin_flo_val -- 保证金浮动值
    ,rela_party_que_rest_cd -- 关联方查询结果代码
    ,tgls_entry_status_cd -- 核算中台记账状态代码
    ,ncbs_entry_status_cd -- 核心记账状态代码
    ,h_data_flg -- 历史数据标志
    ,open_type_cd -- 敞口类型代码
    ,open_amt -- 敞口金额
    ,adj_dep_prft_flg -- 调整存款收益标志
    ,create_dt -- 创建日期
    ,update_dt -- 更新日期
    ,etl_dt -- ETL处理日期
    ,id_mark -- 增删标志
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    nvl(n.batch_id, o.batch_id) as batch_id -- 批次编号
    ,nvl(n.lp_id, o.lp_id) as lp_id -- 法人编号
    ,nvl(n.org_id, o.org_id) as org_id -- 机构编号
    ,nvl(n.acpt_agt_id, o.acpt_agt_id) as acpt_agt_id -- 承兑协议编号
    ,nvl(n.acpt_batch_id, o.acpt_batch_id) as acpt_batch_id -- 承兑批次协议编号
    ,nvl(n.task_type_cd, o.task_type_cd) as task_type_cd -- 任务类型代码
    ,nvl(n.bill_med_cd, o.bill_med_cd) as bill_med_cd -- 票据介质代码
    ,nvl(n.bill_type_cd, o.bill_type_cd) as bill_type_cd -- 票据类型代码
    ,nvl(n.drawer_cust_id, o.drawer_cust_id) as drawer_cust_id -- 出票人客户编号
    ,nvl(n.appl_acpt_amt, o.appl_acpt_amt) as appl_acpt_amt -- 申请承兑金额
    ,nvl(n.appl_draw_dt, o.appl_draw_dt) as appl_draw_dt -- 申请出票日期
    ,nvl(n.exp_dt, o.exp_dt) as exp_dt -- 到期日期
    ,nvl(n.margin_ratio, o.margin_ratio) as margin_ratio -- 保证金比例
    ,nvl(n.comm_fee_ratio, o.comm_fee_ratio) as comm_fee_ratio -- 手续费比例
    ,nvl(n.tran_amt, o.tran_amt) as tran_amt -- 交易金额
    ,nvl(n.pay_bank_bank_no, o.pay_bank_bank_no) as pay_bank_bank_no -- 付款行行号
    ,nvl(n.cust_mgr_id, o.cust_mgr_id) as cust_mgr_id -- 客户经理编号
    ,nvl(n.dept_id, o.dept_id) as dept_id -- 部门编号
    ,nvl(n.operr_id, o.operr_id) as operr_id -- 操作员编号
    ,nvl(n.tran_dt, o.tran_dt) as tran_dt -- 交易日期
    ,nvl(n.bus_logic_check_status_cd, o.bus_logic_check_status_cd) as bus_logic_check_status_cd -- 业务逻辑检查状态代码
    ,nvl(n.apv_status_cd, o.apv_status_cd) as apv_status_cd -- 审批状态代码
    ,nvl(n.check_status_cd, o.check_status_cd) as check_status_cd -- 审核状态代码
    ,nvl(n.crdt_check_status_cd, o.crdt_check_status_cd) as crdt_check_status_cd -- 授信检查状态代码
    ,nvl(n.final_modif_tm, o.final_modif_tm) as final_modif_tm -- 最后修改时间
    ,nvl(n.drawer_acct_num, o.drawer_acct_num) as drawer_acct_num -- 出票人账号
    ,nvl(n.drawer_bank_name, o.drawer_bank_name) as drawer_bank_name -- 出票人行名称
    ,nvl(n.actl_dir_indus_name, o.actl_dir_indus_name) as actl_dir_indus_name -- 实际投向行业名称
    ,nvl(n.enter_acct_org_id, o.enter_acct_org_id) as enter_acct_org_id -- 入账机构编号
    ,nvl(n.acpt_fee, o.acpt_fee) as acpt_fee -- 承兑费
    ,nvl(n.mgmt_fee, o.mgmt_fee) as mgmt_fee -- 管理费
    ,nvl(n.agt_exp_dt, o.agt_exp_dt) as agt_exp_dt -- 协议到期日期
    ,nvl(n.acct_amt, o.acct_amt) as acct_amt -- 账户金额
    ,nvl(n.apprved_use_crdt_open_amt, o.apprved_use_crdt_open_amt) as apprved_use_crdt_open_amt -- 已批准使用授信敞口金额
    ,nvl(n.distr_post_acm_use_open_amt, o.distr_post_acm_use_open_amt) as distr_post_acm_use_open_amt -- 本次放款后累计使用敞口金额
    ,nvl(n.cert_no, o.cert_no) as cert_no -- 证件号码
    ,nvl(n.onl_bank_batch_id, o.onl_bank_batch_id) as onl_bank_batch_id -- 网银批量批次编号
    ,nvl(n.fst_repay_acct_id, o.fst_repay_acct_id) as fst_repay_acct_id -- 第一还款账户编号
    ,nvl(n.margin_tenor_type_cd, o.margin_tenor_type_cd) as margin_tenor_type_cd -- 保证金期限类型代码
    ,nvl(n.margin_acct_id, o.margin_acct_id) as margin_acct_id -- 保证金账户编号
    ,nvl(n.margin_type_cd, o.margin_type_cd) as margin_type_cd -- 保证金类型代码
    ,nvl(n.int_rat_type_cd, o.int_rat_type_cd) as int_rat_type_cd -- 利率类型代码
    ,nvl(n.margin_int_rat_float_type_cd, o.margin_int_rat_float_type_cd) as margin_int_rat_float_type_cd -- 保证金利率浮动类型代码
    ,nvl(n.margin_int_rat_float_way_cd, o.margin_int_rat_float_way_cd) as margin_int_rat_float_way_cd -- 保证金利率浮动方式代码
    ,nvl(n.margin_flo_val, o.margin_flo_val) as margin_flo_val -- 保证金浮动值
    ,nvl(n.rela_party_que_rest_cd, o.rela_party_que_rest_cd) as rela_party_que_rest_cd -- 关联方查询结果代码
    ,nvl(n.tgls_entry_status_cd, o.tgls_entry_status_cd) as tgls_entry_status_cd -- 核算中台记账状态代码
    ,nvl(n.ncbs_entry_status_cd, o.ncbs_entry_status_cd) as ncbs_entry_status_cd -- 核心记账状态代码
    ,nvl(n.h_data_flg, o.h_data_flg) as h_data_flg -- 历史数据标志
    ,nvl(n.open_type_cd, o.open_type_cd) as open_type_cd -- 敞口类型代码
    ,nvl(n.open_amt, o.open_amt) as open_amt -- 敞口金额
    ,nvl(n.adj_dep_prft_flg, o.adj_dep_prft_flg) as adj_dep_prft_flg -- 调整存款收益标志
    ,nvl(o.create_dt, to_date('${batch_date}', 'yyyymmdd')) as create_dt -- 创建日期
    ,case when (
                o.batch_id is null
                and o.lp_id is null
            ) or (
                o.org_id <> n.org_id
                or o.acpt_agt_id <> n.acpt_agt_id
                or o.acpt_batch_id <> n.acpt_batch_id
                or o.task_type_cd <> n.task_type_cd
                or o.bill_med_cd <> n.bill_med_cd
                or o.bill_type_cd <> n.bill_type_cd
                or o.drawer_cust_id <> n.drawer_cust_id
                or o.appl_acpt_amt <> n.appl_acpt_amt
                or o.appl_draw_dt <> n.appl_draw_dt
                or o.exp_dt <> n.exp_dt
                or o.margin_ratio <> n.margin_ratio
                or o.comm_fee_ratio <> n.comm_fee_ratio
                or o.tran_amt <> n.tran_amt
                or o.pay_bank_bank_no <> n.pay_bank_bank_no
                or o.cust_mgr_id <> n.cust_mgr_id
                or o.dept_id <> n.dept_id
                or o.operr_id <> n.operr_id
                or o.tran_dt <> n.tran_dt
                or o.bus_logic_check_status_cd <> n.bus_logic_check_status_cd
                or o.apv_status_cd <> n.apv_status_cd
                or o.check_status_cd <> n.check_status_cd
                or o.crdt_check_status_cd <> n.crdt_check_status_cd
                or o.final_modif_tm <> n.final_modif_tm
                or o.drawer_acct_num <> n.drawer_acct_num
                or o.drawer_bank_name <> n.drawer_bank_name
                or o.actl_dir_indus_name <> n.actl_dir_indus_name
                or o.enter_acct_org_id <> n.enter_acct_org_id
                or o.acpt_fee <> n.acpt_fee
                or o.mgmt_fee <> n.mgmt_fee
                or o.agt_exp_dt <> n.agt_exp_dt
                or o.acct_amt <> n.acct_amt
                or o.apprved_use_crdt_open_amt <> n.apprved_use_crdt_open_amt
                or o.distr_post_acm_use_open_amt <> n.distr_post_acm_use_open_amt
                or o.cert_no <> n.cert_no
                or o.onl_bank_batch_id <> n.onl_bank_batch_id
                or o.fst_repay_acct_id <> n.fst_repay_acct_id
                or o.margin_tenor_type_cd <> n.margin_tenor_type_cd
                or o.margin_acct_id <> n.margin_acct_id
                or o.margin_type_cd <> n.margin_type_cd
                or o.int_rat_type_cd <> n.int_rat_type_cd
                or o.margin_int_rat_float_type_cd <> n.margin_int_rat_float_type_cd
                or o.margin_int_rat_float_way_cd <> n.margin_int_rat_float_way_cd
                or o.margin_flo_val <> n.margin_flo_val
                or o.rela_party_que_rest_cd <> n.rela_party_que_rest_cd
                or o.tgls_entry_status_cd <> n.tgls_entry_status_cd
                or o.ncbs_entry_status_cd <> n.ncbs_entry_status_cd
                or o.h_data_flg <> n.h_data_flg
                or o.open_type_cd <> n.open_type_cd
                or o.open_amt <> n.open_amt
                or o.adj_dep_prft_flg <> n.adj_dep_prft_flg
            ) or (
                 case when (
                           n.batch_id is null
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
                n.batch_id is null
                and n.lp_id is null
            )
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,nvl(n.src_table_name, o.src_table_name) as src_table_name -- 源表名称
    ,nvl(n.job_cd, o.job_cd) as job_cd -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iml_schema}.agt_bill_acpt_batch_bdmsf1_tm n
    full join ${iml_schema}.agt_bill_acpt_batch_bdmsf1_bk o
        on
            o.batch_id = n.batch_id
            and o.lp_id = n.lp_id
;
commit;

-- 3.1 truncate target table batch_date partition
whenever sqlerror exit sql.sqlcode;
alter table ${iml_schema}.agt_bill_acpt_batch truncate partition for ('bdmsf1') reuse storage;

-- 3.2 exchage tm table and target table
alter table ${iml_schema}.agt_bill_acpt_batch exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.agt_bill_acpt_batch_bdmsf1_ex;

-- 3.3 drop subpartition last_date partition
whenever sqlerror continue none ;
alter table ${iml_schema}.agt_bill_acpt_batch drop subpartition p_bdmsf1_${last_date} update global indexes;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.agt_bill_acpt_batch to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.agt_bill_acpt_batch_bdmsf1_tm purge;
drop table ${iml_schema}.agt_bill_acpt_batch_bdmsf1_ex purge;
drop table ${iml_schema}.agt_bill_acpt_batch_bdmsf1_bk purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'agt_bill_acpt_batch', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);