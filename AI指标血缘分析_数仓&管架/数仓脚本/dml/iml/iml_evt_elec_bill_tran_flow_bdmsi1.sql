/*
Purpose:    整全模型层-增量流水脚本，清空目标表当天分区数据，把当天数据与目标表进行分区交换。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iml_evt_elec_bill_tran_flow_bdmsi1
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
drop table ${iml_schema}.evt_elec_bill_tran_flow_bdmsi1_tm purge;
alter table ${iml_schema}.evt_elec_bill_tran_flow add partition p_bdmsi1 values ('bdmsi1')(
        subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
    )
;
alter table ${iml_schema}.evt_elec_bill_tran_flow modify partition p_bdmsi1
    add subpartition p_bdmsi1_${batch_date} values (to_date('${batch_date}','yyyymmdd'))
;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_elec_bill_tran_flow_bdmsi1_tm
compress ${option_switch} for query high
as
select
    evt_id -- 事件编号
    ,bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,info_type_cd -- 信息类型代码
    ,bus_cd -- 业务代码
    ,bill_num -- 票据号码
    ,tran_dt -- 交易日期
    ,reqer_name -- 请求方名称
    ,reqer_orgnz_cd -- 请求方组织机构代码
    ,reqer_acct_num -- 请求方账号
    ,reqer_open_bank_no -- 请求方开户行行号
    ,recver_name -- 接收方名称
    ,recver_orgnz_cd -- 接收方组织机构代码
    ,recver_acct_num -- 接收方账号
    ,recver_open_bank_no -- 接收方开户行行号
    ,recv_dt -- 签收日期
    ,onl_clear_cd -- 线上清算代码
    ,not_ngbl_cd -- 不得转让代码
    ,int_rat -- 利率
    ,redem_int_rat -- 赎回利率
    ,tran_amt -- 交易金额
    ,redem_actl_amt -- 赎回实付金额
    ,discnt_kind_cd -- 贴现种类代码
    ,appl_dt -- 申请日期
    ,sugst_pay_amt -- 提示付款金额
    ,refuse_pay_cd -- 拒付代码
    ,recs_type_cd -- 追索类型代码
    ,payoff_dt -- 清偿日期
    ,entry_status_cd -- 记账状态代码
    ,revo_flg -- 撤销标志
    ,tran_status_cd -- 交易状态代码
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
from ${iml_schema}.evt_elec_bill_tran_flow
where 0=1;


-- it is no need to check when this segment SQL was return faied
whenever sqlerror exit sql.sqlcode;
-- 3.1 insert data to tm table
-- bdms_tbl_swt_business_log-
insert into ${iml_schema}.evt_elec_bill_tran_flow_bdmsi1_tm(
    evt_id -- 事件编号
    ,bill_id -- 票据编号
    ,lp_id -- 法人编号
    ,info_type_cd -- 信息类型代码
    ,bus_cd -- 业务代码
    ,bill_num -- 票据号码
    ,tran_dt -- 交易日期
    ,reqer_name -- 请求方名称
    ,reqer_orgnz_cd -- 请求方组织机构代码
    ,reqer_acct_num -- 请求方账号
    ,reqer_open_bank_no -- 请求方开户行行号
    ,recver_name -- 接收方名称
    ,recver_orgnz_cd -- 接收方组织机构代码
    ,recver_acct_num -- 接收方账号
    ,recver_open_bank_no -- 接收方开户行行号
    ,recv_dt -- 签收日期
    ,onl_clear_cd -- 线上清算代码
    ,not_ngbl_cd -- 不得转让代码
    ,int_rat -- 利率
    ,redem_int_rat -- 赎回利率
    ,tran_amt -- 交易金额
    ,redem_actl_amt -- 赎回实付金额
    ,discnt_kind_cd -- 贴现种类代码
    ,appl_dt -- 申请日期
    ,sugst_pay_amt -- 提示付款金额
    ,refuse_pay_cd -- 拒付代码
    ,recs_type_cd -- 追索类型代码
    ,payoff_dt -- 清偿日期
    ,entry_status_cd -- 记账状态代码
    ,revo_flg -- 撤销标志
    ,tran_status_cd -- 交易状态代码
    ,final_modif_tm -- 最后修改时间
    ,etl_dt-- ETL处理日期
    ,src_table_name -- 源表名称
    ,job_cd -- 任务编码
    ,etl_timestamp -- ETL处理时间戳
)
select
    '102020'||P1.TXN_DATE||TO_CHAR(P1.ID) -- 事件编号
    ,TO_CHAR(P1.ID) -- 票据编号
    ,'9999' -- 法人编号
    ,NVL(TRIM(P1.MSG_TYPE),'00') -- 信息类型代码
    ,NVL(TRIM(P1.BUSS_FLAG),'00') -- 业务代码
    ,P1.ELECTRIC_DRAFT_ID -- 票据号码
    ,${iml_schema}.DATEFORMAT_MIN(P1.TXN_DATE) -- 交易日期
    ,P1.REQ_NAME -- 请求方名称
    ,P1.REQ_BRCH_CODE -- 请求方组织机构代码
    ,P1.REQ_ACCOUNT -- 请求方账号
    ,P1.REQ_BANK_ID -- 请求方开户行行号
    ,P1.RCV_NAME -- 接收方名称
    ,P1.RCV_BRCH_CODE -- 接收方组织机构代码
    ,P1.RCV_ACCOUNT -- 接收方账号
    ,P1.RCV_BANK_ID -- 接收方开户行行号
    ,${iml_schema}.DATEFORMAT_MAX(P1.SIGN_DATE) -- 签收日期
    ,CASE WHEN R2.TARGET_CD_VAL IS NOT NULL THEN R2.TARGET_CD_VAL ELSE '@'||P1.ONL_STLM_FLAG END -- 线上清算代码
    ,CASE WHEN R3.TARGET_CD_VAL IS NOT NULL THEN R3.TARGET_CD_VAL ELSE '@'||P1.TRANSFER_FLAG END -- 不得转让代码
    ,P1.RATE -- 利率
    ,P1.REPURCHASE_RATE -- 赎回利率
    ,P1.AMOUNT -- 交易金额
    ,P1.REPURCHASE_AMT -- 赎回实付金额
    ,CASE WHEN R4.TARGET_CD_VAL IS NOT NULL THEN R4.TARGET_CD_VAL ELSE '@'||P1.DISCOUNT_TYPE END -- 贴现种类代码
    ,${iml_schema}.DATEFORMAT_MIN(P1.REQ_DATE) -- 申请日期
    ,P1.PROMPT_PAY_AMT -- 提示付款金额
    ,CASE WHEN R5.TARGET_CD_VAL IS NOT NULL THEN R5.TARGET_CD_VAL ELSE '@'||P1.REJECT_CODE END -- 拒付代码
    ,CASE WHEN R6.TARGET_CD_VAL IS NOT NULL THEN R6.TARGET_CD_VAL ELSE '@'||P1.HOLDER_TYPE END -- 追索类型代码
    ,${iml_schema}.DATEFORMAT_MAX(P1.SOLUTOR_DATE) -- 清偿日期
    ,CASE WHEN R7.TARGET_CD_VAL IS NOT NULL THEN R7.TARGET_CD_VAL ELSE '@'||P1.ACCOUNT_STATUS END -- 记账状态代码
    ,P1.CANCEL_FLAG -- 撤销标志
    ,NVL(TRIM(P1.TXN_STATUS),'00') -- 交易状态代码
    ,to_timestamp(to_char(${iml_schema}.dateformat_max(P1.LAST_UPD_TS),'yyyy/mm/dd HH24:MI:SS'),'yyyy/mm/dd HH24:MI:SS.FF6') -- 最后修改时间
    ,to_date('${batch_date}','yyyymmdd') as etl_dt -- ETL处理日期
    ,'bdms_tbl_swt_business_log' -- 源表名称
    ,'bdmsi1' -- 任务编码
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间戳
from ${iol_schema}.bdms_tbl_swt_business_log p1
    left join ${iml_schema}.ref_pub_cd_map r2 on P1.ONL_STLM_FLAG = R2.SRC_CODE_VAL
        AND R2.SORC_SYS_CD= 'BDMS'
        AND R2.SRC_TAB_EN_NAME= 'BDMS_TBL_SWT_BUSINESS_LOG'
        AND R2.SRC_FIELD_EN_NAME= 'ONL_STLM_FLAG'
        AND R2.TARGET_TAB_EN_NAME= 'EVT_ELEC_BILL_TRAN_FLOW'
        AND R2.TARGET_TAB_FIELD_EN_NAME= 'ONL_CLEAR_CD'
    left join ${iml_schema}.ref_pub_cd_map r3 on P1.TRANSFER_FLAG = R3.SRC_CODE_VAL
        AND R3.SORC_SYS_CD= 'BDMS'
        AND R3.SRC_TAB_EN_NAME= 'BDMS_TBL_SWT_BUSINESS_LOG'
        AND R3.SRC_FIELD_EN_NAME= 'TRANSFER_FLAG'
        AND R3.TARGET_TAB_EN_NAME= 'EVT_ELEC_BILL_TRAN_FLOW'
        AND R3.TARGET_TAB_FIELD_EN_NAME= 'NOT_NGBL_CD'
    left join ${iml_schema}.ref_pub_cd_map r4 on P1.DISCOUNT_TYPE = R4.SRC_CODE_VAL
        AND R4.SORC_SYS_CD= 'BDMS'
        AND R4.SRC_TAB_EN_NAME= 'BDMS_TBL_SWT_BUSINESS_LOG'
        AND R4.SRC_FIELD_EN_NAME= 'DISCOUNT_TYPE'
        AND R4.TARGET_TAB_EN_NAME= 'EVT_ELEC_BILL_TRAN_FLOW'
        AND R4.TARGET_TAB_FIELD_EN_NAME= 'DISCNT_KIND_CD'
    left join ${iml_schema}.ref_pub_cd_map r5 on P1.REJECT_CODE = R5.SRC_CODE_VAL
        AND R5.SORC_SYS_CD= 'BDMS'
        AND R5.SRC_TAB_EN_NAME= 'BDMS_TBL_SWT_BUSINESS_LOG'
        AND R5.SRC_FIELD_EN_NAME= 'REJECT_CODE'
        AND R5.TARGET_TAB_EN_NAME= 'EVT_ELEC_BILL_TRAN_FLOW'
        AND R5.TARGET_TAB_FIELD_EN_NAME= 'REFUSE_PAY_CD'
    left join ${iml_schema}.ref_pub_cd_map r6 on P1.HOLDER_TYPE = R6.SRC_CODE_VAL
        AND R6.SORC_SYS_CD= 'BDMS'
        AND R6.SRC_TAB_EN_NAME= 'BDMS_TBL_SWT_BUSINESS_LOG'
        AND R6.SRC_FIELD_EN_NAME= 'HOLDER_TYPE'
        AND R6.TARGET_TAB_EN_NAME= 'EVT_ELEC_BILL_TRAN_FLOW'
        AND R6.TARGET_TAB_FIELD_EN_NAME= 'RECS_TYPE_CD'
    left join ${iml_schema}.ref_pub_cd_map r7 on P1.ACCOUNT_STATUS = R7.SRC_CODE_VAL
        AND R7.SORC_SYS_CD= 'BDMS'
        AND R7.SRC_TAB_EN_NAME= 'BDMS_TBL_SWT_BUSINESS_LOG'
        AND R7.SRC_FIELD_EN_NAME= 'ACCOUNT_STATUS'
        AND R7.TARGET_TAB_EN_NAME= 'EVT_ELEC_BILL_TRAN_FLOW'
        AND R7.TARGET_TAB_FIELD_EN_NAME= 'ENTRY_STATUS_CD'
where  1 = 1 
    AND P1.TXN_DATE='${batch_date}'
;
commit;



-- 3.2 truncate target table batch_date partition
alter table ${iml_schema}.evt_elec_bill_tran_flow truncate subpartition p_bdmsi1_${batch_date} reuse storage;


-- 3.3 exchage tm table and target table
alter table ${iml_schema}.evt_elec_bill_tran_flow exchange subpartition p_bdmsi1_${batch_date} with table ${iml_schema}.evt_elec_bill_tran_flow_bdmsi1_tm;

-- 4.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iml_schema}.evt_elec_bill_tran_flow to ${iml_schema};

-- 4.2 drop tm table
drop table ${iml_schema}.evt_elec_bill_tran_flow_bdmsi1_tm purge;

-- 5 gater table status
exec dbms_stats.gather_table_stats(ownname => '${iml_schema}',tabname => 'evt_elec_bill_tran_flow', partname => 'p_bdmsi1_${batch_date}', granularity => 'SUBPARTITION', degree => 8, cascade => true);