: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_scfs_agt_ln_ac_amt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_scfs_agt_ln_ac_amt_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="SELECT 
LOAN_ACCT_ID
,ETL_DT
,LOAN_TOTAL_TERM
,LOAN_NEW_TERM
,CCY_CD
,LOAN_TOTAL_BAL
,LOAN_BAL
,DAY_ACCR_INT
,PAID_PRCP
,PAID_INT
,PAID_PNLT
,PAID_COMPD_INT
,PAID_COST
,AGGR_RCVABLE_INT_AMT
,INT_ON_BS_BAL
,INT_OFF_BS_BAL
,ON_INT
,OFF_INT
,PROVN
,PREV_ADJ_INT_DT
,NEXT_ADJ_INT_DT
,NEXT_STL_DT
,ACTL_WRITE_OFF_PRCP
,ACTL_WRITE_OFF_INT
,RCVA_ACR_INTR
,RCVA_OWE_INT
,RCVA_ACCR_PNLT
,RCVA_PNLT
,ACCR_CMPD_INTR
,RCVA_CMPD_INTR
,DUN_ACR_INTR
,DUN_OWE_INT
,DUN_ACCR_PNLT
,DUN_PNLT
,DATA_SRC_CD
,DEL_FLG
,PKG_BEF_RCVA_INT_VAL
,PKG_AFTER_RCVA_INT_TOTAL_AMT
,PKG_AFTER_RCVA_INT_BAL
,HAS_RETN_PKG_AFTER_RCVA_INT
,TFR_LOAN_INT_TOTAL_AMT
FROM IDL.hdws_scfs_agt_ln_ac_amt_info
WHERE ETL_DT=TO_DATE('${batch_date}','yyyymmdd')
;" \
        field="0x1b" record="0x17"  \
        file="${iel_data_path}/hdws_scfs_agt_ln_ac_amt_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes