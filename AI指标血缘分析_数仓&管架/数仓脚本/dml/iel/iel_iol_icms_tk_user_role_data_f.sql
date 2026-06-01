: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_tk_user_role_data_f
CreateDate: 20251114
FileName:   ${iel_data_path}/icms_tk_user_role_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.roleid,chr(13),''),chr(10),'') as roleid
,inputdate

from ${iol_schema}.icms_tk_user_role_data t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_tk_user_role_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
