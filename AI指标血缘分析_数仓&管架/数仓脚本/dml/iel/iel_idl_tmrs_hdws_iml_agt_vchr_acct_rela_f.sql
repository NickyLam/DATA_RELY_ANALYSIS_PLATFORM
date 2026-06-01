: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_tmrs_hdws_iml_agt_vchr_acct_rela_f
CreateDate: 20180529
FileName:   ${iel_data_path}/tmrs_hdws_iml_agt_vchr_acct_rela.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.vchr_id,chr(13),''),chr(10),'') as vchr_id
,replace(replace(t1.vchr_type_cd,chr(13),''),chr(10),'') as vchr_type_cd 
,t1.etl_dt as etl_dt 
,replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id 
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg 
,t1.last_update_dt as last_update_dt 
,NVL2(T1.DATA_SRC_CD,'AGT_VCHR_ACCT_RELA'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'AGT_VCHR_ACCT_RELA') AS ETL_TASK_NAME  
from ${idl_schema}.hdws_iml_agt_vchr_acct_rela t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tmrs_hdws_iml_agt_vchr_acct_rela.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes