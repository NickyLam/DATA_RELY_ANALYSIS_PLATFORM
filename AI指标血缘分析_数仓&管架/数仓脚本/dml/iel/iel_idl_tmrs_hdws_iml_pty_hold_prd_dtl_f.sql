: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_tmrs_hdws_iml_pty_hold_prd_dtl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tmrs_hdws_iml_pty_hold_prd_dtl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.sign_agt_id,chr(13),''),chr(10),'') as sign_agt_id
,t1.etl_dt as etl_dt 
,t1.last_update_dt as last_update_dt 
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id 
,replace(replace(t1.prd_typ_cd,chr(13),''),chr(10),'') as prd_typ_cd 
,replace(replace(t1.sign_acct_num,chr(13),''),chr(10),'') as sign_acct_num 
,t1.sign_dt as sign_dt 
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id 
,replace(replace(t1.sign_org_name,chr(13),''),chr(10),'') as sign_org_name 
,replace(replace(t1.sign_tell_id,chr(13),''),chr(10),'') as sign_tell_id 
,replace(replace(t1.status_prd_status_cd,chr(13),''),chr(10),'') as status_prd_status_cd 
,t1.remit_contr_tm as remit_contr_tm 
,replace(replace(t1.remit_org_id,chr(13),''),chr(10),'') as remit_org_id 
,replace(replace(t1.remit_org_name,chr(13),''),chr(10),'') as remit_org_name 
,replace(replace(t1.remit_tell_id,chr(13),''),chr(10),'') as remit_tell_id 
,replace(replace(t1.sign_ceph_num,chr(13),''),chr(10),'') as sign_ceph_num 
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg 
,NVL2(T1.DATA_SRC_CD,'PTY_HOLD_PRD_DTL'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'PTY_HOLD_PRD_DTL') AS ETL_TASK_NAME  
from ${idl_schema}.hdws_iml_pty_hold_prd_dtl t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmrs_hdws_iml_pty_hold_prd_dtl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes