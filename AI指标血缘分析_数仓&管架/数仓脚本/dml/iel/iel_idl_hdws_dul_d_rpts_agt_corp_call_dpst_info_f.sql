: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_corp_call_dpst_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_corp_call_dpst_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.dpst_acct_id,chr(13),''),chr(10),'') as dpst_acct_id
,t1.etl_dt as etl_dt
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.dps_type_cd,chr(13),''),chr(10),'') as dps_type_cd
,replace(replace(t1.peri_typ_cd,chr(13),''),chr(10),'') as peri_typ_cd
,replace(replace(t1.fre_prec_flg,chr(13),''),chr(10),'') as fre_prec_flg
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg
,t1.last_update_dt as last_update_dt
,NVL2(t1.data_src_cd,'D_RPTS_AGT_CORP_CALL_DPST_INFO'||'_'||DECODE(T1.DATA_SRC_CD,'LHWD',UPPER(SUBSTR(T1.JOB_CD,1,4)),T1.DATA_SRC_CD),'D_RPTS_AGT_CORP_CALL_DPST_INFO') as etl_task_name
from ${idl_schema}.hdws_dul_d_rpts_agt_corp_call_dpst_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_corp_call_dpst_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes