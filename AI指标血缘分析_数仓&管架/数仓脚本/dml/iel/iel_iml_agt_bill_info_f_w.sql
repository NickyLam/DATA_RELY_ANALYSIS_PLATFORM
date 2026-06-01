: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bill_info_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_bill_info_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
        t1.ETL_DT as ETL_DT
,replace(replace(t1.VOUCH_ID,chr(13),''),chr(10),'') as VOUCH_ID
,replace(replace(t1.BILL_ID,chr(13),''),chr(10),'') as BILL_ID
,replace(replace(t1.LP_ID,chr(13),''),chr(10),'') as LP_ID
,replace(replace(t1.BILL_NUM,chr(13),''),chr(10),'') as BILL_NUM
,replace(replace(t1.ROLE_SRC_CD,chr(13),''),chr(10),'') as ROLE_SRC_CD
,replace(replace(t1.DISCNT_BATCH_ID,chr(13),''),chr(10),'') as DISCNT_BATCH_ID
,replace(replace(t1.PBC_TRANBL_FLG,chr(13),''),chr(10),'') as PBC_TRANBL_FLG
,replace(replace(t1.HXB_ACPT_FLG,chr(13),''),chr(10),'') as HXB_ACPT_FLG
,replace(replace(t1.BILL_MED_CD,chr(13),''),chr(10),'') as BILL_MED_CD
,replace(replace(t1.BILL_TYPE_CD,chr(13),''),chr(10),'') as BILL_TYPE_CD
,t1.DRAW_DT as DRAW_DT
,t1.FAC_VAL_EXP_DT as FAC_VAL_EXP_DT
,replace(replace(t1.DRAWER_CATE_CD,chr(13),''),chr(10),'') as DRAWER_CATE_CD
,replace(replace(t1.DRAWER_ORGNZ_CD,chr(13),''),chr(10),'') as DRAWER_ORGNZ_CD
,replace(replace(t1.DRAWER_NAME,chr(13),''),chr(10),'') as DRAWER_NAME
,replace(replace(t1.DRAWER_ACCT_NUM,chr(13),''),chr(10),'') as DRAWER_ACCT_NUM
,replace(replace(t1.DRAWER_OPEN_BANK_NUM,chr(13),''),chr(10),'') as DRAWER_OPEN_BANK_NUM
,replace(replace(t1.ACCPTOR_OPEN_BANK_NAME,chr(13),''),chr(10),'') as ACCPTOR_OPEN_BANK_NAME
,replace(replace(t1.DRAWER_OPEN_BANK_NAME,chr(13),''),chr(10),'') as DRAWER_OPEN_BANK_NAME
,replace(replace(t1.ACCPTOR_CATE_CD,chr(13),''),chr(10),'') as ACCPTOR_CATE_CD
,replace(replace(t1.ACCPTOR_NAME,chr(13),''),chr(10),'') as ACCPTOR_NAME
,replace(replace(t1.ACCPTOR_OPEN_BANK_NUM,chr(13),''),chr(10),'') as ACCPTOR_OPEN_BANK_NUM
,replace(replace(t1.ACCPTOR_ACCT_NUM,chr(13),''),chr(10),'') as ACCPTOR_ACCT_NUM
,replace(replace(t1.RECVER_NAME,chr(13),''),chr(10),'') as RECVER_NAME
,replace(replace(t1.RECVER_ACCT_NUM,chr(13),''),chr(10),'') as RECVER_ACCT_NUM
,replace(replace(t1.RECVER_OPEN_BANK_NUM,chr(13),''),chr(10),'') as RECVER_OPEN_BANK_NUM
,replace(replace(t1.RECVER_OPEN_BANK_NAME,chr(13),''),chr(10),'') as RECVER_OPEN_BANK_NAME
,t1.BILL_AMT as BILL_AMT
,replace(replace(t1.BILL_BELONG_ORG_ID,chr(13),''),chr(10),'') as BILL_BELONG_ORG_ID
,replace(replace(t1.BILL_STATUS_CD,chr(13),''),chr(10),'') as BILL_STATUS_CD
,replace(replace(t1.LOSS_FLG,chr(13),''),chr(10),'') as LOSS_FLG
,replace(replace(t1.FINAL_MODIF_OPERR_ID,chr(13),''),chr(10),'') as FINAL_MODIF_OPERR_ID
,t1.FINAL_MODIF_TM as FINAL_MODIF_TM
,replace(replace(t1.RECEIPT_FLG,chr(13),''),chr(10),'') as RECEIPT_FLG
,replace(replace(t1.REDCST_FLG,chr(13),''),chr(10),'') as REDCST_FLG
,replace(replace(t1.H_DATA_FLG,chr(13),''),chr(10),'') as H_DATA_FLG
,t1.CREATE_DT as CREATE_DT
,t1.UPDATE_DT as UPDATE_DT
,replace(replace(t1.ID_MARK,chr(13),''),chr(10),'') as ID_MARK
,replace(replace(t1.SRC_TABLE_NAME,chr(13),''),chr(10),'') as SRC_TABLE_NAME
,replace(replace(t1.job_cd,chr(13),''),chr(10),'') as job_cd
from ${iml_schema}.agt_bill_info t1 
where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bill_info_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes