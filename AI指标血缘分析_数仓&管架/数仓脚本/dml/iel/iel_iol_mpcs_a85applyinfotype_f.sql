: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a85applyinfotype_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a85applyinfotype.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.serviceid,chr(13),''),chr(10),'') as serviceid
,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t.username,chr(13),''),chr(10),'') as username
,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t.idvalue,chr(13),''),chr(10),'') as idvalue
,replace(replace(t.msisdn,chr(13),''),chr(10),'') as msisdn
,replace(replace(t.email,chr(13),''),chr(10),'') as email
,replace(replace(t.pan,chr(13),''),chr(10),'') as pan
,replace(replace(t.validdate,chr(13),''),chr(10),'') as validdate
,replace(replace(t.cvn2,chr(13),''),chr(10),'') as cvn2
,replace(replace(t.pin,chr(13),''),chr(10),'') as pin
,replace(replace(t.state,chr(13),''),chr(10),'') as state
,replace(replace(t.cpsid,chr(13),''),chr(10),'') as cpsid
,replace(replace(t.applydate,chr(13),''),chr(10),'') as applydate
,replace(replace(t.activatedate,chr(13),''),chr(10),'') as activatedate
,replace(replace(t.validatelukcount,chr(13),''),chr(10),'') as validatelukcount
,replace(replace(t.tokenpan,chr(13),''),chr(10),'') as tokenpan
,replace(replace(t.expiredate,chr(13),''),chr(10),'') as expiredate
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.statustime,chr(13),''),chr(10),'') as statustime
,replace(replace(t.panstatus,chr(13),''),chr(10),'') as panstatus
,replace(replace(t.locked,chr(13),''),chr(10),'') as locked
,replace(replace(t.lost,chr(13),''),chr(10),'') as lost
,replace(replace(t.devicemodel,chr(13),''),chr(10),'') as devicemodel
,replace(replace(t.devicesn,chr(13),''),chr(10),'') as devicesn
,replace(replace(t.ostype,chr(13),''),chr(10),'') as ostype
,replace(replace(t.osversion,chr(13),''),chr(10),'') as osversion
,replace(replace(t.deviceid,chr(13),''),chr(10),'') as deviceid
,replace(replace(t.imei,chr(13),''),chr(10),'') as imei
,replace(replace(t.walletname,chr(13),''),chr(10),'') as walletname
,replace(replace(t.walletsignature,chr(13),''),chr(10),'') as walletsignature
,replace(replace(t.walletversion,chr(13),''),chr(10),'') as walletversion
,replace(replace(t.ifpwd,chr(13),''),chr(10),'') as ifpwd
,replace(replace(t.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t.remark4,chr(13),''),chr(10),'') as remark4
from ${iol_schema}.mpcs_a85applyinfotype t
where t.etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a85applyinfotype.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes