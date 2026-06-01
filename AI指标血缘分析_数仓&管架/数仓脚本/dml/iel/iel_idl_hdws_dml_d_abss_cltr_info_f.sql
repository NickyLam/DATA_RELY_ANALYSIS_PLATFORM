: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dml_d_abss_cltr_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dml_d_abss_cltr_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.loan_contr_id,chr(13),''),chr(10),'') as loan_contr_id
,replace(replace(t1.asset_src,chr(13),''),chr(10),'') as asset_src
,replace(replace(t1.guar_contr_id,chr(13),''),chr(10),'') as guar_contr_id
,replace(replace(t1.coll_id,chr(13),''),chr(10),'') as coll_id
,replace(replace(t1.coll_name,chr(13),''),chr(10),'') as coll_name
,replace(replace(t1.owns_pers_id,chr(13),''),chr(10),'') as owns_pers_id
,replace(replace(t1.owns_pers_name,chr(13),''),chr(10),'') as owns_pers_name
,t1.ghb_cfm_val as ghb_cfm_val
,t1.pled_est_val as pled_est_val
,replace(replace(t1.guar_status_cd,chr(13),''),chr(10),'') as guar_status_cd
,replace(replace(t1.keep_flag,chr(13),''),chr(10),'') as keep_flag
from ${idl_schema}.hdws_dml_d_abss_cltr_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dml_d_abss_cltr_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes