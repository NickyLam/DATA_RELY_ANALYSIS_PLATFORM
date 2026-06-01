: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dml_d_abss_org_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dml_d_abss_org_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.org_cn_short_name,chr(13),''),chr(10),'') as org_cn_short_name
,replace(replace(t1.org_lvl_cd,chr(13),''),chr(10),'') as org_lvl_cd
,replace(replace(t1.mgmt_super_org_id,chr(13),''),chr(10),'') as mgmt_super_org_id
from ${idl_schema}.hdws_dml_d_abss_org_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dml_d_abss_org_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes