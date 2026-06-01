: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_tmrs_hdws_iml_agt_vchr_base_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tmrs_hdws_iml_agt_vchr_base_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.vchr_id,chr(13),''),chr(10),'') as vchr_id
,t1.etl_dt as etl_dt 
,replace(replace(t1.vchr_type_cd,chr(13),''),chr(10),'') as vchr_type_cd 
,replace(replace(t1.vchr_status_cd,chr(13),''),chr(10),'') as vchr_status_cd 
,replace(replace(t1.issue_org_id,chr(13),''),chr(10),'') as issue_org_id 
,replace(replace(t1.issue_tell_id,chr(13),''),chr(10),'') as issue_tell_id 
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id 
,t1.eff_dt as eff_dt 
,t1.expire_dt as expire_dt 
,t1.due_dt as due_dt 
,replace(replace(t1.mili_secu_card_flg,chr(13),''),chr(10),'') as mili_secu_card_flg 
,replace(replace(t1.soci_secu_card_flg,chr(13),''),chr(10),'') as soci_secu_card_flg 
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg 
,t1.last_update_dt as last_update_dt 
,NVL2(T1.DATA_SRC_CD,'AGT_VCHR_BASE_INFO'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_VCHR_BASE_INFO') AS ETL_TASK_NAME  
from ${idl_schema}.hdws_iml_agt_vchr_base_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmrs_hdws_iml_agt_vchr_base_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes