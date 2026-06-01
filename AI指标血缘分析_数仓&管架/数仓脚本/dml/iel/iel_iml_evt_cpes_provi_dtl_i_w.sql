: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_cpes_provi_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_cpes_provi_dtl_w.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.EVT_ID,chr(13),''),chr(10),'') as EVT_ID
,replace(replace(t1.LP_ID,chr(13),''),chr(10),'') as LP_ID
,replace(replace(t1.PROVI_DTL_ID,chr(13),''),chr(10),'') as PROVI_DTL_ID
,replace(replace(t1.PROVI_MTBL_ID,chr(13),''),chr(10),'') as PROVI_MTBL_ID
,replace(replace(t1.PROVI_ENTRY_ID,chr(13),''),chr(10),'') as PROVI_ENTRY_ID
,replace(replace(t1.BILL_ID,chr(13),''),chr(10),'') as BILL_ID
,t1.TD_PROVI_INT as TD_PROVI_INT
,replace(replace(t1.ENTRY_SUCS_FLG,chr(13),''),chr(10),'') as ENTRY_SUCS_FLG
,t1.ENTRY_DT as ENTRY_DT
,replace(replace(t1.ORG_ID,chr(13),''),chr(10),'') as ORG_ID
,replace(replace(t1.BUS_PROD_ID,chr(13),''),chr(10),'') as BUS_PROD_ID
,replace(replace(t1.INT_INCOME_SUBJ_ID,chr(13),''),chr(10),'') as INT_INCOME_SUBJ_ID
,replace(replace(t1.PROVI_POST_SUBJ_ID,chr(13),''),chr(10),'') as PROVI_POST_SUBJ_ID
,replace(replace(t1.SYS_TRACK_NO,chr(13),''),chr(10),'') as SYS_TRACK_NO
,replace(replace(t1.PROVI_TYPE_CD,chr(13),''),chr(10),'') as PROVI_TYPE_CD
,replace(replace(t1.BILL_SUB_INTRV_ID,chr(13),''),chr(10),'') as BILL_SUB_INTRV_ID
,t1.ETL_DT as ETL_DT
,replace(replace(t1.SRC_TABLE_NAME,chr(13),''),chr(10),'') as SRC_TABLE_NAME
from ${iml_schema}.evt_cpes_provi_dtl t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6  ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cpes_provi_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes