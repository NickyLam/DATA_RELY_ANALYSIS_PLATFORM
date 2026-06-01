: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_tmrs_hdws_iml_evt_change_card_schr_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/tmrs_hdws_iml_evt_change_card_schr_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,t1.etl_dt as etl_dt
,t1.trn_dt as trn_dt
,replace(replace(t1.new_dpst_acct_num,chr(13),''),chr(10),'') as new_dpst_acct_num
,replace(replace(t1.new_sub_num,chr(13),''),chr(10),'') as new_sub_num
,replace(replace(t1.new_vchr_num,chr(13),''),chr(10),'') as new_vchr_num
,replace(replace(t1.new_vchr_typ_cd,chr(13),''),chr(10),'') as new_vchr_typ_cd
,replace(replace(t1.status_cd,chr(13),''),chr(10),'') as status_cd
,replace(replace(t1.old_dpst_acct_num,chr(13),''),chr(10),'') as old_dpst_acct_num
,replace(replace(t1.old_sub_num,chr(13),''),chr(10),'') as old_sub_num
,replace(replace(t1.old_vchr_num,chr(13),''),chr(10),'') as old_vchr_num
,replace(replace(t1.old_vchr_typ_cd,chr(13),''),chr(10),'') as old_vchr_typ_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,NVL2(t1.data_src_cd,'EVT_CHANGE_CARD_SCHR_DTL'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'EVT_CHANGE_CARD_SCHR_DTL') as etl_task_name
from ${idl_schema}.hdws_iml_evt_change_card_schr_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmrs_hdws_iml_evt_change_card_schr_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes