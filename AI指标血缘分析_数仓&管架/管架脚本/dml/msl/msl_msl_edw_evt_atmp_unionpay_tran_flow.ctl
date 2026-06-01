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
infile '${data_path}/evt_atmp_unionpay_tran_flow.i.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_evt_atmp_unionpay_tran_flow
fields terminated by x'1b' 
trailing nullcols
(
    ETL_DT date "yyyy-mm-dd hh24:mi:ss" nullif ETL_DT=blanks 
    ,EVT_ID char(4000) nullif EVT_ID=blanks 
    ,LP_ID char(4000) nullif LP_ID=blanks 
    ,SEND_ORG_ID char(4000) nullif SEND_ORG_ID=blanks 
    ,SYS_FOLLOW_ID char(4000) nullif SYS_FOLLOW_ID=blanks 
    ,TRAN_TM char(4000) nullif TRAN_TM=blanks 
    ,TRAN_CD char(4000) nullif TRAN_CD=blanks 
    ,TRAN_TYPE_CD char(4000) nullif TRAN_TYPE_CD=blanks 
    ,PROC_ORG_ID char(4000) nullif PROC_ORG_ID=blanks 
    ,TRAN_DT date "yyyy-mm-dd hh24:mi:ss" nullif TRAN_DT=blanks 
    ,TELLER_ID char(4000) nullif TELLER_ID=blanks 
    ,TRAN_ORG_ID char(4000) nullif TRAN_ORG_ID=blanks 
    ,CHN_CD char(4000) nullif CHN_CD=blanks 
    ,MSG_TYPE_CD char(4000) nullif MSG_TYPE_CD=blanks 
    ,MAIN_ACCT_ID char(4000) nullif MAIN_ACCT_ID=blanks 
    ,PROC_CD char(4000) nullif PROC_CD=blanks 
    ,INTNAL_PROC_CD char(4000) nullif INTNAL_PROC_CD=blanks 
    ,TRAN_AMT char(4000) nullif TRAN_AMT=blanks 
    ,ONL_ACCT_BAL char(4000) nullif ONL_ACCT_BAL=blanks 
    ,ACCT_TD_AVAL_BAL char(4000) nullif ACCT_TD_AVAL_BAL=blanks 
    ,ATM_DRAW_TD_AVAL_BAL char(4000) nullif ATM_DRAW_TD_AVAL_BAL=blanks 
    ,TRAN_FEE char(4000) nullif TRAN_FEE=blanks 
    ,PROC_ORG_SITE_TM char(4000) nullif PROC_ORG_SITE_TM=blanks 
    ,PROC_ORG_SITE_DT char(4000) nullif PROC_ORG_SITE_DT=blanks 
    ,CLEAR_DT char(4000) nullif CLEAR_DT=blanks 
    ,MERCHT_TYPE_CD char(4000) nullif MERCHT_TYPE_CD=blanks 
    ,TRAN_SERV_INPUT_WAY_CD char(4000) nullif TRAN_SERV_INPUT_WAY_CD=blanks 
    ,TRAN_SERV_COND_CD char(4000) nullif TRAN_SERV_COND_CD=blanks 
    ,RETRIV_REF_ID char(4000) nullif RETRIV_REF_ID=blanks 
    ,APPRV_TRAN_AUTH_ID char(4000) nullif APPRV_TRAN_AUTH_ID=blanks 
    ,RETURN_CODE char(4000) nullif RETURN_CODE=blanks 
    ,PROC_TERMN_ID char(4000) nullif PROC_TERMN_ID=blanks 
    ,PROC_MERCHT_ID char(4000) nullif PROC_MERCHT_ID=blanks 
    ,PROC_MERCHT_NAME char(4000) nullif PROC_MERCHT_NAME=blanks 
    ,ADDIT_RESP_DESCB char(4000) nullif ADDIT_RESP_DESCB=blanks 
    ,ADDIT_PRIV char(4000) nullif ADDIT_PRIV=blanks 
    ,CURR_CD char(4000) nullif CURR_CD=blanks 
    ,RESV_REGION char(4000) nullif RESV_REGION=blanks 
    ,RECV_ORG_ID char(4000) nullif RECV_ORG_ID=blanks 
    ,CUPS_RESV_NUM char(4000) nullif CUPS_RESV_NUM=blanks 
    ,INIT_PROC_ORG_ID char(4000) nullif INIT_PROC_ORG_ID=blanks 
    ,INIT_SEND_ORG_ID char(4000) nullif INIT_SEND_ORG_ID=blanks 
    ,INIT_SYS_FOLLOW_ID char(4000) nullif INIT_SYS_FOLLOW_ID=blanks 
    ,INIT_TRAN_TM timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif INIT_TRAN_TM=blanks 
    ,UNIONPAY_EXCH_RAT char(4000) nullif UNIONPAY_EXCH_RAT=blanks 
    ,EXPNS_ACCT_ID char(4000) nullif EXPNS_ACCT_ID=blanks 
    ,DEPOT_ACCT_ID char(4000) nullif DEPOT_ACCT_ID=blanks 
    ,ATMC_TRAN_FLOW_NUM char(4000) nullif ATMC_TRAN_FLOW_NUM=blanks 
    ,MSG_HEAD_INFO char(4000) nullif MSG_HEAD_INFO=blanks 
    ,TRAN_STATUS_CD char(4000) nullif TRAN_STATUS_CD=blanks 
    ,ERR_CD char(4000) nullif ERR_CD=blanks 
    ,ERR_INFO char(4000) nullif ERR_INFO=blanks 
    ,TERMN_TYPE_CD char(4000) nullif TERMN_TYPE_CD=blanks 
    ,INIT_WAY_CD char(4000) nullif INIT_WAY_CD=blanks 
    ,MERCHT_CTY_RG_CD char(4000) nullif MERCHT_CTY_RG_CD=blanks 
    ,DEDUCT_AMT char(4000) nullif DEDUCT_AMT=blanks 
    ,DEDUCT_EXCH_RAT char(4000) nullif DEDUCT_EXCH_RAT=blanks 
    ,CLEAR_AMT char(4000) nullif CLEAR_AMT=blanks 
    ,SEND_ORG_ACTL_ID char(4000) nullif SEND_ORG_ACTL_ID=blanks 
    ,CROSS_BOR_FLG char(4000) nullif CROSS_BOR_FLG=blanks 
    ,CARD_SER_NUM char(4000) nullif CARD_SER_NUM=blanks 
    ,ACCESS_IC_DATA_REGION char(4000) nullif ACCESS_IC_DATA_REGION=blanks 
    ,SEND_IC_DATA_REGION char(4000) nullif SEND_IC_DATA_REGION=blanks 
    ,INTNAL_TRAN_CD char(4000) nullif INTNAL_TRAN_CD=blanks 
    ,FCURR_TRAN_AMT char(4000) nullif FCURR_TRAN_AMT=blanks 
    ,BANK_ACCT_TYPE_CD char(4000) nullif BANK_ACCT_TYPE_CD=blanks 
    ,OPEN_ACCT_ORG_ID char(4000) nullif OPEN_ACCT_ORG_ID=blanks 
    ,COMM_FEE char(4000) nullif COMM_FEE=blanks 
    ,CARD_TYPE_CD char(4000) nullif CARD_TYPE_CD=blanks 
    ,CARD_TRAN_TYPE_CD char(4000) nullif CARD_TRAN_TYPE_CD=blanks 
    ,QR_CODE_PAY_SCENE_CD char(4000) nullif QR_CODE_PAY_SCENE_CD=blanks 
    ,CROSS_BANK_FLG char(4000) nullif CROSS_BANK_FLG=blanks 
    ,DEGR_FLG char(4000) nullif DEGR_FLG=blanks 
    ,BEPS_UNPASEW_FLG char(4000) nullif BEPS_UNPASEW_FLG=blanks 
    ,SUBCLASS_RETURN_CODE char(4000) nullif SUBCLASS_RETURN_CODE=blanks 
    ,MEMO_CD char(4000) nullif MEMO_CD=blanks 
    ,OVA_FLOW_NUM char(4000) nullif OVA_FLOW_NUM=blanks 
    ,TRAN_FLOW_NUM char(4000) nullif TRAN_FLOW_NUM=blanks 
    ,INIT_TRAN_FLOW_NUM char(4000) nullif INIT_TRAN_FLOW_NUM=blanks 
    ,UPP_ENTER_STATUS_CD char(4000) nullif UPP_ENTER_STATUS_CD=blanks 
    ,ENTRY_FLOW_NUM char(4000) nullif ENTRY_FLOW_NUM=blanks 
    ,ENTRY_DT date "yyyy-mm-dd hh24:mi:ss" nullif ENTRY_DT=blanks 
    ,DELAY_DEDUCT_TRAN_FLOW_NUM char(4000) nullif DELAY_DEDUCT_TRAN_FLOW_NUM=blanks 
    ,DELAY_DEDUCT_TRAN_DT date "yyyy-mm-dd hh24:mi:ss" nullif DELAY_DEDUCT_TRAN_DT=blanks 
    ,UNIONPAY_DELAY_TRAN_RETURN_CD char(4000) nullif UNIONPAY_DELAY_TRAN_RETURN_CD=blanks 
    ,DELAY_TRAN_RETURN_CD char(4000) nullif DELAY_TRAN_RETURN_CD=blanks 
    ,TERMN_EQUIP_ID char(4000) nullif TERMN_EQUIP_ID=blanks 
    ,TERMN_IP_ADDR char(4000) nullif TERMN_IP_ADDR=blanks 
    ,TERMN_SIM_NUM char(4000) nullif TERMN_SIM_NUM=blanks 
    ,TERMN_GPS_POSITION char(4000) nullif TERMN_GPS_POSITION=blanks 
    ,RSRV_MOBILE_NO char(4000) nullif RSRV_MOBILE_NO=blanks 
    ,CUST_ID char(4000) nullif CUST_ID=blanks 
    ,CUST_NAME char(4000) nullif CUST_NAME=blanks 
    ,MIDGROD_TRAN_DT timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif MIDGROD_TRAN_DT=blanks 
    ,ACCT_DT date "yyyy-mm-dd hh24:mi:ss" nullif ACCT_DT=blanks 
    ,INIT_TRAN_CD char(4000) nullif INIT_TRAN_CD=blanks 
)
