: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_pbs_wx_tourist_info_f
CreateDate: 20260306
FileName:   ${iel_data_path}/osbs_pbs_wx_tourist_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.pwt_unionid,chr(13),''),chr(10),'') as pwt_unionid
,replace(replace(t1.pwt_openid,chr(13),''),chr(10),'') as pwt_openid
,replace(replace(t1.pwt_phone,chr(13),''),chr(10),'') as pwt_phone
,replace(replace(t1.pwt_name,chr(13),''),chr(10),'') as pwt_name
,replace(replace(t1.pwt_certnum,chr(13),''),chr(10),'') as pwt_certnum
,replace(replace(t1.pwt_chanel,chr(13),''),chr(10),'') as pwt_chanel
,replace(replace(t1.pwt_sellsmscontract,chr(13),''),chr(10),'') as pwt_sellsmscontract
,replace(replace(t1.pwt_date,chr(13),''),chr(10),'') as pwt_date
,replace(replace(t1.pwt_status,chr(13),''),chr(10),'') as pwt_status
,replace(replace(t1.pwt_tourist_id,chr(13),''),chr(10),'') as pwt_tourist_id
,replace(replace(t1.pwt_branchid,chr(13),''),chr(10),'') as pwt_branchid

from ${iol_schema}.osbs_pbs_wx_tourist_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_pbs_wx_tourist_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
