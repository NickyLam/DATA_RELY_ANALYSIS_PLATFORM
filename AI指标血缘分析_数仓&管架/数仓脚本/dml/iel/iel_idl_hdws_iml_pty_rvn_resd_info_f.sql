: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_pty_rvn_resd_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_pty_rvn_resd_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,t.etl_dt as etl_dt
,replace(replace(t.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t.rvn_resd_cnr_and_zone_cd,chr(13),''),chr(10),'') as rvn_resd_cnr_and_zone_cd
,replace(replace(t.taxp_iden_id,chr(13),''),chr(10),'') as taxp_iden_id
,replace(replace(t.spe_reas,chr(13),''),chr(10),'') as spe_reas
from ${idl_schema}.hdws_iml_pty_rvn_resd_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_pty_rvn_resd_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes