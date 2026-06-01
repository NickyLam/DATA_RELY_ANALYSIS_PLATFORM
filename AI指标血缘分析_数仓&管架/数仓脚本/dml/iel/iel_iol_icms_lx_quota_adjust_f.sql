: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_lx_quota_adjust_f
CreateDate: 20250804
FileName:   ${iel_data_path}/icms_lx_quota_adjust.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.assetid,chr(13),''),chr(10),'') as assetid
,replace(replace(t1.businesssum,chr(13),''),chr(10),'') as businesssum
,replace(replace(t1.presentcreditamount,chr(13),''),chr(10),'') as presentcreditamount
,replace(replace(t1.effectdate,chr(13),''),chr(10),'') as effectdate
,replace(replace(t1.expiredate,chr(13),''),chr(10),'') as expiredate
,replace(replace(t1.increasereason,chr(13),''),chr(10),'') as increasereason
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate

from ${iol_schema}.icms_lx_quota_adjust t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_lx_quota_adjust.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
