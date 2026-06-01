: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_tbps_cpr_menu_inf_f
CreateDate: 20231110
FileName:   ${iel_data_path}/tbps_cpr_menu_inf.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.cmi_id,chr(13),''),chr(10),'') as cmi_id
,replace(replace(t1.cmi_name,chr(13),''),chr(10),'') as cmi_name
,replace(replace(t1.cmi_channel,chr(13),''),chr(10),'') as cmi_channel
,replace(replace(t1.cmi_authenabled,chr(13),''),chr(10),'') as cmi_authenabled
,replace(replace(t1.cmi_state,chr(13),''),chr(10),'') as cmi_state
,replace(replace(t1.cmi_type,chr(13),''),chr(10),'') as cmi_type
,replace(replace(t1.cmi_authtype,chr(13),''),chr(10),'') as cmi_authtype
,replace(replace(t1.cmi_authmode,chr(13),''),chr(10),'') as cmi_authmode
,replace(replace(t1.cmi_router,chr(13),''),chr(10),'') as cmi_router
,replace(replace(t1.cmi_showtype,chr(13),''),chr(10),'') as cmi_showtype
,replace(replace(t1.cmi_only,chr(13),''),chr(10),'') as cmi_only
,replace(replace(t1.cmi_actions,chr(13),''),chr(10),'') as cmi_actions
,replace(replace(t1.cmi_trancode,chr(13),''),chr(10),'') as cmi_trancode

from ${iol_schema}.tbps_cpr_menu_inf t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/tbps_cpr_menu_inf.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
