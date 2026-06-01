: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_risk_warning_operate_f
CreateDate: 20251106
FileName:   ${iel_data_path}/icms_risk_warning_operate.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.cusrisklevel,chr(13),''),chr(10),'') as cusrisklevel
,replace(replace(t1.noteopinion,chr(13),''),chr(10),'') as noteopinion
,replace(replace(t1.describe,chr(13),''),chr(10),'') as describe
,replace(replace(t1.operatetype,chr(13),''),chr(10),'') as operatetype
,replace(replace(t1.riskmeasure,chr(13),''),chr(10),'') as riskmeasure
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,updatedate
,replace(replace(t1.signserno,chr(13),''),chr(10),'') as signserno
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,inputdate

from ${iol_schema}.icms_risk_warning_operate t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_risk_warning_operate.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
