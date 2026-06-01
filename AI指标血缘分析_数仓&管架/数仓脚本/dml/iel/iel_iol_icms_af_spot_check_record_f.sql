: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_af_spot_check_record_f
CreateDate: 20260416
FileName:   ${iel_data_path}/icms_af_spot_check_record.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.applyno,chr(13),''),chr(10),'') as applyno
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,signtime
,replace(replace(t1.signaddress,chr(13),''),chr(10),'') as signaddress
,replace(replace(t1.attendeeid,chr(13),''),chr(10),'') as attendeeid
,replace(replace(t1.peersremark,chr(13),''),chr(10),'') as peersremark
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tasktype,chr(13),''),chr(10),'') as tasktype
,workandsigndistance
,registerandsigndistance
,replace(replace(t1.ispresent,chr(13),''),chr(10),'') as ispresent
,replace(replace(t1.signreason,chr(13),''),chr(10),'') as signreason

from ${iol_schema}.icms_af_spot_check_record t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_af_spot_check_record.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
