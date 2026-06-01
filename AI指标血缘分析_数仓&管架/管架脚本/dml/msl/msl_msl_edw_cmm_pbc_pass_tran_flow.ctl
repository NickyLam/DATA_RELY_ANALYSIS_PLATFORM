-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/cmm_pbc_pass_tran_flow.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_pbc_pass_tran_flow
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,EVT_ID char(4000) nullif EVT_ID=blanks 
    ,LP_ID char(4000) nullif LP_ID=blanks 
    ,PAY_DECL_FORM_ID char(4000) nullif PAY_DECL_FORM_ID=blanks 
    ,TRAN_DT date "yyyy-mm-dd hh24:mi:ss" nullif TRAN_DT=blanks 
    ,OUT_LINE_PAY_TRAN_SEQ_NUM char(4000) nullif OUT_LINE_PAY_TRAN_SEQ_NUM=blanks 
    ,BANK_INT_BUS_SEQ_NUM char(4000) nullif BANK_INT_BUS_SEQ_NUM=blanks 
    ,BUS_ORIGI_BANK_NO char(4000) nullif BUS_ORIGI_BANK_NO=blanks 
    ,MSG_TYPE_ID char(4000) nullif MSG_TYPE_ID=blanks 
    ,SCD_GENER_MSG_TYPE_ID char(4000) nullif SCD_GENER_MSG_TYPE_ID=blanks 
    ,HOST_FLOW_NUM char(4000) nullif HOST_FLOW_NUM=blanks 
    ,TRAN_FLOW_NUM char(4000) nullif TRAN_FLOW_NUM=blanks 
    ,SEND_TRAN_FLOW_NUM char(4000) nullif SEND_TRAN_FLOW_NUM=blanks 
    ,OVA_FLOW_NUM char(4000) nullif OVA_FLOW_NUM=blanks 
    ,HOST_TRAN_CODE char(4000) nullif HOST_TRAN_CODE=blanks 
    ,MIDGROD_TRAN_CODE char(4000) nullif MIDGROD_TRAN_CODE=blanks 
    ,CURR_CD char(4000) nullif CURR_CD=blanks 
    ,PROD_CD char(4000) nullif PROD_CD=blanks 
    ,BUS_KIND_CD char(4000) nullif BUS_KIND_CD=blanks 
    ,BUS_TYPE_CD char(4000) nullif BUS_TYPE_CD=blanks 
    ,PROC_STATUS_CD char(4000) nullif PROC_STATUS_CD=blanks 
    ,NPC_PROC_CD char(4000) nullif NPC_PROC_CD=blanks 
    ,CHECK_ENTRY_STATUS_CD char(4000) nullif CHECK_ENTRY_STATUS_CD=blanks 
    ,DEBIT_CRDT_CD char(4000) nullif DEBIT_CRDT_CD=blanks 
    ,ENTRY_CODE char(4000) nullif ENTRY_CODE=blanks 
    ,ACCT_GEN_CD char(4000) nullif ACCT_GEN_CD=blanks 
    ,ACCT_TYPE_CD char(4000) nullif ACCT_TYPE_CD=blanks 
    ,E_ACCT_CD char(4000) nullif E_ACCT_CD=blanks 
    ,REC_STATUS_CD char(4000) nullif REC_STATUS_CD=blanks 
    ,MODE_PAY_CD char(4000) nullif MODE_PAY_CD=blanks 
    ,EXCH_BUS_TRAN_CHN_CD char(4000) nullif EXCH_BUS_TRAN_CHN_CD=blanks 
    ,GROUND_PROC_STATUS_CD char(4000) nullif GROUND_PROC_STATUS_CD=blanks 
    ,VERIFY_PROC_STATUS_CD char(4000) nullif VERIFY_PROC_STATUS_CD=blanks 
    ,NOSTRO_FLG char(4000) nullif NOSTRO_FLG=blanks 
    ,CHARGE_FLG char(4000) nullif CHARGE_FLG=blanks 
    ,AGENT_FLG char(4000) nullif AGENT_FLG=blanks 
    ,INTNAL_ACCT_FLG char(4000) nullif INTNAL_ACCT_FLG=blanks 
    ,ENTR_DT date "yyyy-mm-dd hh24:mi:ss" nullif ENTR_DT=blanks 
    ,HOST_DT date "yyyy-mm-dd hh24:mi:ss" nullif HOST_DT=blanks 
    ,CLEAR_DT date "yyyy-mm-dd hh24:mi:ss" nullif CLEAR_DT=blanks 
    ,CHECK_ENTRY_DT date "yyyy-mm-dd hh24:mi:ss" nullif CHECK_ENTRY_DT=blanks 
    ,MODIF_DT date "yyyy-mm-dd hh24:mi:ss" nullif MODIF_DT=blanks 
    ,MODIF_TM timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif MODIF_TM=blanks 
    ,INIT_ENTR_DT date "yyyy-mm-dd hh24:mi:ss" nullif INIT_ENTR_DT=blanks 
    ,INIT_PAY_TRAN_SEQ_NUM char(4000) nullif INIT_PAY_TRAN_SEQ_NUM=blanks 
    ,TRAN_AMT char(4000) nullif TRAN_AMT=blanks 
    ,COMM_FEE_AMT char(4000) nullif COMM_FEE_AMT=blanks 
    ,REMIT_TRAN_FEE_AMT char(4000) nullif REMIT_TRAN_FEE_AMT=blanks 
    ,TODOS char(4000) nullif TODOS=blanks 
    ,PAYER_OPEN_BANK_NO char(4000) nullif PAYER_OPEN_BANK_NO=blanks 
    ,PAYER_OPEN_BANK_NAME char(4000) nullif PAYER_OPEN_BANK_NAME=blanks 
    ,PAYER_ACCT_NUM char(4000) nullif PAYER_ACCT_NUM=blanks 
    ,PAYER_NAME char(4000) nullif PAYER_NAME=blanks 
    ,PAYER_ADDR char(4000) nullif PAYER_ADDR=blanks 
    ,RECVER_OPEN_BANK_NO char(4000) nullif RECVER_OPEN_BANK_NO=blanks 
    ,RECVER_OPEN_BANK_NAME char(4000) nullif RECVER_OPEN_BANK_NAME=blanks 
    ,RECVER_ACCT_NUM char(4000) nullif RECVER_ACCT_NUM=blanks 
    ,RECVER_NAME char(4000) nullif RECVER_NAME=blanks 
    ,RECVER_ADDR char(4000) nullif RECVER_ADDR=blanks 
    ,ERR_RETURN_CODE char(4000) nullif ERR_RETURN_CODE=blanks 
    ,ERR_INFO char(4000) nullif ERR_INFO=blanks 
    ,PRIOR_LEVEL char(4000) nullif PRIOR_LEVEL=blanks 
    ,INPUT_TELLER_ID char(4000) nullif INPUT_TELLER_ID=blanks 
    ,CHECK_TELLER_ID char(4000) nullif CHECK_TELLER_ID=blanks 
    ,AUTH_TELLER_ID char(4000) nullif AUTH_TELLER_ID=blanks 
    ,INPUT_CHECK_TELLER_DEPT_ID char(4000) nullif INPUT_CHECK_TELLER_DEPT_ID=blanks 
    ,AUTH_TELLER_DEPT_ID char(4000) nullif AUTH_TELLER_DEPT_ID=blanks 
    ,REG_MAIN_ACCT_NUM char(4000) nullif REG_MAIN_ACCT_NUM=blanks 
    ,REG_MAIN_NAME char(4000) nullif REG_MAIN_NAME=blanks 
    ,MATN_ENTER_ACCT_DT date "yyyy-mm-dd hh24:mi:ss" nullif MATN_ENTER_ACCT_DT=blanks 
    ,MATN_ENTER_ACCT_TELLER_ID char(4000) nullif MATN_ENTER_ACCT_TELLER_ID=blanks 
    ,MATN_ENTER_ACCT_DEPT_ID char(4000) nullif MATN_ENTER_ACCT_DEPT_ID=blanks 
    ,VOUCH_TYPE_CD char(4000) nullif VOUCH_TYPE_CD=blanks 
    ,VOUCH_DT date "yyyy-mm-dd hh24:mi:ss" nullif VOUCH_DT=blanks 
    ,VOUCH_NO char(4000) nullif VOUCH_NO=blanks 
    ,CERT_KIND_CD char(4000) nullif CERT_KIND_CD=blanks 
    ,CERT_NO char(4000) nullif CERT_NO=blanks 
    ,ACTL_DEDUCT_ACCT_NUM char(4000) nullif ACTL_DEDUCT_ACCT_NUM=blanks 
    ,ACTL_DEDUCT_ACCT_NAME char(4000) nullif ACTL_DEDUCT_ACCT_NAME=blanks 
    ,RGST_ADDIT_DATA_TAB_NAME char(4000) nullif RGST_ADDIT_DATA_TAB_NAME=blanks 
    ,ON_ACCT_RS_CD char(4000) nullif ON_ACCT_RS_CD=blanks 
    ,AUTO_REFUND_FLG char(4000) nullif AUTO_REFUND_FLG=blanks 
    ,AUTO_REFUND_CNT char(4000) nullif AUTO_REFUND_CNT=blanks 
    ,VTUAL_BIND_ACCT char(4000) nullif VTUAL_BIND_ACCT=blanks 
    ,VTUAL_BIND_ACCT_NAME char(4000) nullif VTUAL_BIND_ACCT_NAME=blanks 
    ,VTUAL_OPEN_ACCT_ORG_ID char(4000) nullif VTUAL_OPEN_ACCT_ORG_ID=blanks 
)
