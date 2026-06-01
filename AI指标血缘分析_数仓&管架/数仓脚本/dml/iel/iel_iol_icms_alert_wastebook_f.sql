: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_alert_wastebook_f
CreateDate: 20251112
FileName:   ${iel_data_path}/icms_alert_wastebook.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,updatedate
,replace(replace(t1.delstatus,chr(13),''),chr(10),'') as delstatus
,cutdate
,replace(replace(t1.isoutfinish,chr(13),''),chr(10),'') as isoutfinish
,replace(replace(t1.confirmstatus,chr(13),''),chr(10),'') as confirmstatus
,replace(replace(t1.effectflag,chr(13),''),chr(10),'') as effectflag
,replace(replace(t1.updateorgid,chr(13),''),chr(10),'') as updateorgid
,replace(replace(t1.relativeserialno,chr(13),''),chr(10),'') as relativeserialno
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.customertype,chr(13),''),chr(10),'') as customertype
,replace(replace(t1.accountmonth,chr(13),''),chr(10),'') as accountmonth
,replace(replace(t1.orgid,chr(13),''),chr(10),'') as orgid
,replace(replace(t1.certtype,chr(13),''),chr(10),'') as certtype
,replace(replace(t1.buildtype,chr(13),''),chr(10),'') as buildtype
,replace(replace(t1.isoverdue,chr(13),''),chr(10),'') as isoverdue
,replace(replace(t1.alerttype,chr(13),''),chr(10),'') as alerttype
,finishdate
,replace(replace(t1.approvestatus,chr(13),''),chr(10),'') as approvestatus
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.customername,chr(13),''),chr(10),'') as customername
,replace(replace(t1.endstatus,chr(13),''),chr(10),'') as endstatus
,balance
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.customerid,chr(13),''),chr(10),'') as customerid
,inputdate
,replace(replace(t1.updateuserid,chr(13),''),chr(10),'') as updateuserid
,replace(replace(t1.alertcontent,chr(13),''),chr(10),'') as alertcontent
,replace(replace(t1.alertinfosource,chr(13),''),chr(10),'') as alertinfosource
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.belongdept,chr(13),''),chr(10),'') as belongdept

from ${iol_schema}.icms_alert_wastebook t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_alert_wastebook.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
