: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_scfs_agt_ln_ac_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_scfs_agt_ln_ac_base_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="SELECT
DATA_SRC_CD
,DEL_FLG
,LOAN_ACCT_ID
,ETL_DT
,BLNG_PTY_ID
,ACCT_NAME
,PRD_ID
,OPEN_DT
,LOAN_ISSUE_DT
,INT_DT
,TRMI_DT
,DUE_DT
,OPEN_ORG_ID
,MGMT_ORG_ID
,ACCTING_ORG_ID
,PTY_MGR_ID
,AGT_STATUS_CD
,ACCTING_COA_ID
,TERM_CORP_CD
,LOAN_TERM
,CCY_CD
,ISSUE_AMT
,RATE_BASE_TYP_CD
,RATE_BASE_VAL
,EXEC_RATE
,OVDUE_EXEC_RATE
,FLOAT_RATE_FLG
,RATE_FLOAT_MODE_CD
,FLOAT_FREQ_CD
,RATE_FLOAT_VAL
,OVDUE_RATE_FLOAT
,CURR_RATE_EFF_DAY
,NEXT_RATE_ADJ_DAY
,LOAN_BASE_MON_DAY_QTY
,LOAN_BASE_YEAR_DAY_QTY
,LOAN_COMPD_INT_FLG
,LOAN_STL_MODE_CD
,LOAN_INT_MODE_CD
,LOAN_CALC_FORML
,DD_ACCT_ID
,REPAY_MODE_CD
,REPAY_FREQ_CD
,REPAY_ACCT_ID
,ASSOC_LOAN_CONTR_ID
,BIL_ACCT_ID
,ASSOC_BIL_ID
,LOAN_ASSOC_MARG_ACCT
,MARGIN_CCY_CD
,MARGIN_AMT
,MARG_RATIO
,BLNG_BIZ_LINE_CD
,LOAN_BIZ_TYPE_CD
,SUB_GUAR_MODE_CD
,LOAN_CATE_CD
,GOV_PLATF_LOAN_FLG
,ACCT_CATEG_CD
,LOAN_FLG
,ACPT_FLG
,BOUT_LIQDT_FLG
,COMM_INVO_NUM
,COMM_INV_CCY_CD
,COMM_INV_AMT
,COMM_INV_TYPE_CD
,FFT_TYPE_CD
,INT_ACCT_ID
,WRITE_OFF_FLG
,TRAN_FLG
FROM IDL.hdws_scfs_agt_ln_ac_base_info
WHERE ETL_DT=TO_DATE('${batch_date}','yyyymmdd')
;" \
        field="0x1b" record="0x17"  \
        file="${iel_data_path}/hdws_scfs_agt_ln_ac_base_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes