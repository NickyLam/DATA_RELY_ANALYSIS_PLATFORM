: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_archive_imagescan_view_f
CreateDate: 20250909
FileName:   ${iel_data_path}/icms_archive_imagescan_view.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.inputdate,chr(13),''),chr(10),'') as inputdate
,replace(replace(t1.orgname,chr(13),''),chr(10),'') as orgname
,replace(replace(t1.operateuserrole,chr(13),''),chr(10),'') as operateuserrole
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.authuserid,chr(13),''),chr(10),'') as authuserid
,replace(replace(t1.authusername,chr(13),''),chr(10),'') as authusername
,replace(replace(t1.authorgid,chr(13),''),chr(10),'') as authorgid
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.objecttypename,chr(13),''),chr(10),'') as objecttypename
,replace(replace(t1.startdate,chr(13),''),chr(10),'') as startdate
,replace(replace(t1.enddate,chr(13),''),chr(10),'') as enddate
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.system,chr(13),''),chr(10),'') as system

from ${iol_schema}.icms_archive_imagescan_view t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_archive_imagescan_view.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
