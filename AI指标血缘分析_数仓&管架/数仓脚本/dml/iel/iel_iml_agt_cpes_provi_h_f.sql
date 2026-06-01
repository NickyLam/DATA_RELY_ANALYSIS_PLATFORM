: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cpes_provi_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cpes_provi_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.PROVI_MTBL_ID,chr(13),''),chr(10),'') as PROVI_MTBL_ID
,replace(replace(t1.LP_ID,chr(13),''),chr(10),'') as LP_ID
,replace(replace(t1.HQ_ORG_ID,chr(13),''),chr(10),'') as HQ_ORG_ID
,replace(replace(t1.TRAN_ORG_ID,chr(13),''),chr(10),'') as TRAN_ORG_ID
,replace(replace(t1.BATCH_ID,chr(13),''),chr(10),'') as BATCH_ID
,replace(replace(t1.AGT_ID,chr(13),''),chr(10),'') as AGT_ID
,replace(replace(t1.DTL_ID,chr(13),''),chr(10),'') as DTL_ID
,replace(replace(t1.BILL_ID,chr(13),''),chr(10),'') as BILL_ID
,replace(replace(t1.BUS_PROD_ID,chr(13),''),chr(10),'') as BUS_PROD_ID
,t1.INTEREST as INTEREST
,t1.PROVI_START_DT as PROVI_START_DT
,t1.PROVI_END_DT as PROVI_END_DT
,t1.ACTL_END_PROVI_DT as ACTL_END_PROVI_DT
,t1.PROVI_DT as PROVI_DT
,t1.INT_ACCR_EXP_DT as INT_ACCR_EXP_DT
,t1.INT_ACCR_DAYS as INT_ACCR_DAYS
,t1.PROVIED_INT as PROVIED_INT
,t1.SURP_INT as SURP_INT
,t1.DAILY_PROVI_AMT as DAILY_PROVI_AMT
,replace(replace(t1.PROVI_BUS_TYPE_CD,chr(13),''),chr(10),'') as PROVI_BUS_TYPE_CD
,replace(replace(t1.PROVI_STATUS_CD,chr(13),''),chr(10),'') as PROVI_STATUS_CD
,replace(replace(t1.PROVI_EXCEP_CD,chr(13),''),chr(10),'') as PROVI_EXCEP_CD
,replace(replace(t1.ACCT_INSTIT_ID,chr(13),''),chr(10),'') as ACCT_INSTIT_ID
,t1.START_DT as START_DT
,t1.END_DT as END_DT
,replace(replace(t1.ID_MARK,chr(13),''),chr(10),'') as ID_MARK
,replace(replace(t1.SRC_TABLE_NAME,chr(13),''),chr(10),'') as SRC_TABLE_NAME
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num 
,replace(replace(t1.BILL_SUB_INTRV_ID,chr(13),''),chr(10),'') as BILL_SUB_INTRV_ID
from ${iml_schema}.agt_cpes_provi_h t1 
where  t1.start_dt<=to_date('${batch_date}','yyyymmdd') and t1.end_dt>to_date('${batch_date}','yyyymmdd') ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cpes_provi_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes