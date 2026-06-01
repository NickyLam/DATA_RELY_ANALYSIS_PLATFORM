: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbps_cpr_menu_group_rel_f
CreateDate: 20231110
FileName:   ${iel_data_path}/tbps_cpr_menu_group_rel.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.mgr_groupid,chr(13),''),chr(10),'') as mgr_groupid
,replace(replace(t1.mgr_menuid,chr(13),''),chr(10),'') as mgr_menuid
,replace(replace(t1.mgr_state,chr(13),''),chr(10),'') as mgr_state

from ${iol_schema}.tbps_cpr_menu_group_rel t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbps_cpr_menu_group_rel.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
