: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_alert_data_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_alert_data.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,replace(replace(t1.objecttype,chr(13),''),chr(10),'') as objecttype
,replace(replace(t1.objectno,chr(13),''),chr(10),'') as objectno
,replace(replace(t1.signid,chr(13),''),chr(10),'') as signid
,replace(replace(t1.signdescribe,chr(13),''),chr(10),'') as signdescribe
,replace(replace(t1.confirmstatus,chr(13),''),chr(10),'') as confirmstatus
,replace(replace(t1.confirmconment,chr(13),''),chr(10),'') as confirmconment
,replace(replace(t1.relieverexplain,chr(13),''),chr(10),'') as relieverexplain
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,inputdate
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,updatedate
,replace(replace(t1.isreliever,chr(13),''),chr(10),'') as isreliever
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.endstatus,chr(13),''),chr(10),'') as endstatus
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.alerttype,chr(13),''),chr(10),'') as alerttype
,replace(replace(t1.contrtolmeasure,chr(13),''),chr(10),'') as contrtolmeasure
,replace(replace(t1.itemvalue,chr(13),''),chr(10),'') as itemvalue
,replace(replace(t1.signlevel,chr(13),''),chr(10),'') as signlevel
,replace(replace(t1.urgentalarm,chr(13),''),chr(10),'') as urgentalarm

from ${iol_schema}.icms_alert_data t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_alert_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
