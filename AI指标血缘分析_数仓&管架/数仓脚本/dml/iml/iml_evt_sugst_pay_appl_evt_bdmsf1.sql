/*
Purpose:    整合模型层-全量流水脚本，清空目标表，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_sugst_pay_appl_evt_bdmsf1
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
drop table ${iml_schema}.evt_sugst_pay_appl_evt_bdmsf1_tm purge;
alter table ${iml_schema}.evt_sugst_pay_appl_evt add partition p_bdmsf1 values ('bdmsf1')(
        subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_sugst_pay_appl_evt modify partition p_bdmsf1
    add subpartition p_bdmsf1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_sugst_pay_appl_evt_bdmsf1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,hq_org_id -- 总行机构编号
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,appl_tran_type_cd -- 申请交易类型代码
    ,appl_dt -- 申请日期
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,bill_id -- 票据编号
    ,fac_val_amt -- 票面金额
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_payer_soci_crdt_cd -- 提示付款人社会信用代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_open_bank_num -- 提示付款人开户行号
    ,sugst_payer_org_cd -- 提示付款人机构代码
    ,pay_bank_no -- 付款行行号
    ,pay_bank_reply_cd -- 付款行回复代码
    ,pay_bank_refuse_rs_cd -- 付款行拒绝原因代码
    ,proc_status_cd -- 处理状态代码
    ,bill_status_cd -- 票据状态代码
    ,entry_status_cd -- 记账状态代码
    ,clear_rest_cd -- 清算结果代码
    ,cash_org_role_type_cd -- 兑付机构角色类型代码
    ,err_cd -- 错误码
    ,modif_teller_id -- 修改柜员编号
    ,final_modif_tm -- 最后修改时间
    ,final_modif_dt -- 最后修改日期
    ,recver_acct_num -- 收款人账号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_sugst_pay_appl_evt
where 0=1;

-- it is no need to check when this segment SQL was return faied
-- 3.1 insert data to tm table
whenever sqlerror exit sql.sqlcode;
-- bdms_cpes_prmtpay_apply-
insert into ${iml_schema}.evt_sugst_pay_appl_evt_bdmsf1_tm(
    evt_id -- 事件编号
    ,lp_id -- 法人编号
    ,appl_flow_num -- 申请流水号
    ,hq_org_id -- 总行机构编号
    ,org_id -- 机构编号
    ,prod_id -- 产品编号
    ,appl_tran_type_cd -- 申请交易类型代码
    ,appl_dt -- 申请日期
    ,bill_type_cd -- 票据类型代码
    ,bill_med_cd -- 票据介质代码
    ,bill_id -- 票据编号
    ,fac_val_amt -- 票面金额
    ,draw_dt -- 出票日期
    ,exp_dt -- 到期日期
    ,sugst_payer_cate_cd -- 提示付款人类别代码
    ,sugst_payer_soci_crdt_cd -- 提示付款人社会信用代码
    ,sugst_payer_name -- 提示付款人名称
    ,sugst_payer_open_bank_num -- 提示付款人开户行号
    ,sugst_payer_org_cd -- 提示付款人机构代码
    ,pay_bank_no -- 付款行行号
    ,pay_bank_reply_cd -- 付款行回复代码
    ,pay_bank_refuse_rs_cd -- 付款行拒绝原因代码
    ,proc_status_cd -- 处理状态代码
    ,bill_status_cd -- 票据状态代码
    ,entry_status_cd -- 记账状态代码
    ,clear_rest_cd -- 清算结果代码
    ,cash_org_role_type_cd -- 兑付机构角色类型代码
    ,err_cd -- 错误码
    ,modif_teller_id -- 修改柜员编号
    ,final_modif_tm -- 最后修改时间
    ,final_modif_dt -- 最后修改日期
    ,recver_acct_num -- 收款人账号
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102072'||P1.ID -- 事件编号
    ,'9999' -- 法人编号
    ,P1.ID -- 申请流水号
    ,P1.TOP_BRANCH_NO -- 总行机构编号
    ,P1.BRANCH_NO -- 机构编号
    ,P1.PRODUCT_NO -- 产品编号
    ,nvl(trim(P1.BUSS_FLAG),'RBT00') -- 申请交易类型代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.APPLY_DATE) -- 申请日期
    ,nvl(trim(P1.DRAFT_TYPE),'-') -- 票据类型代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.DRAFT_ATTR END -- 票据介质代码
    ,P1.DRAFT_ID -- 票据编号
    ,P1.DRAFT_AMOUNT -- 票面金额
    ,${iml_schema}.DATEFORMAT_MIN(P1.REMIT_DATE) -- 出票日期
    ,${iml_schema}.DATEFORMAT_MAX2(P1.MATURITY_DATE) -- 到期日期
    ,nvl(trim(P1.PRMT_PAYER_ROLE),'0') -- 提示付款人类别代码
    ,P1.PRMT_PAYER_CRT_NO -- 提示付款人社会信用代码
    ,P1.PRMT_PAYER_NAME -- 提示付款人名称
    ,P1.PRMT_PAYER_BANK_NO -- 提示付款人开户行号
    ,P1.PRMT_PAYER_BRH_NO -- 提示付款人机构代码
    ,P1.PAYER_BANK_NO -- 付款行行号
    ,nvl(trim(P1.PAYER_SIG_NK),'-') -- 付款行回复代码
    ,nvl(trim(P1.PAYER_REFUSE_RSN),'-') -- 付款行拒绝原因代码
    ,nvl(trim(P1.DEAL_STATUS),'00') -- 处理状态代码
    ,nvl(trim(P1.STATUS),'-') -- 票据状态代码
    ,CASE WHEN R1.TARGET_CD_VAL IS NOT NULL THEN R1.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 记账状态代码
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.SETTLE_RESULT END -- 清算结果代码
    ,nvl(trim(P1.CASH_ROLE),'-') -- 兑付机构角色类型代码
    ,P1.ERR_CODE -- 错误码
    ,P1.LAST_UPD_OPR -- 修改柜员编号
    ,coalesce(SUBSTR(P1.LAST_UPD_TIME,9,2)||':'||SUBSTR(P1.LAST_UPD_TIME,11,2)||':'||SUBSTR(P1.LAST_UPD_TIME,13,2),'') -- 最后修改时间
    ,${iml_schema}.DATEFORMAT_MIN(SUBSTR(P1.LAST_UPD_TIME, 1, 8)) -- 最后修改日期
    ,p1.RCV_ACCT_NO -- 收款人账号
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_cpes_prmtpay_apply' -- 源表名称
    ,'bdmsf1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_cpes_prmtpay_apply p1
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.DRAFT_ATTR= R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_CPES_PRMTPAY_APPLY'
        AND R3.SRC_FIELD_EN_NAME= 'DRAFT_ATTR'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_SUGST_PAY_APPL_EVT'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'BILL_MED_CD'
    left join ${iml_schema}.ref_pub_cd_map r1 on P1.ACCOUNT_STATUS = R1.SRC_CODE_VAL
        AND R1.SORC_SYS_CD= 'BDMS'
        AND R1.SRC_TAB_EN_NAME= 'BDMS_CPES_PRMTPAY_APPLY'
        AND R1.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R1.TARGET_TAB_EN_NAME= 'EVT_SUGST_PAY_APPL_EVT'
        AND R1.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.SETTLE_RESULT = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_CPES_PRMTPAY_APPLY'
        AND R2.SRC_FIELD_EN_NAME= 'SETTLE_RESULT'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_SUGST_PAY_APPL_EVT'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'CLEAR_REST_CD'
where  1 = 1 
;
commit;



-- 3.2 truncate target table
alter table ${iml_schema}.evt_sugst_pay_appl_evt truncate partition p_bdmsf1;

-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_sugst_pay_appl_evt exchange subpartition p_bdmsf1_${batch_date} with table ${iml_schema}.evt_sugst_pay_appl_evt_bdmsf1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_sugst_pay_appl_evt to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_sugst_pay_appl_evt_bdmsf1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_sugst_pay_appl_evt', partname => 'p_bdmsf1_${batch_date}', ESTIMATE_PERCENT=>10, method_opt=>'for all columns size 1',no_invalidate=>false, force=>true, granularity => 'SUBPARTITION', degree => 8, cascade => true);