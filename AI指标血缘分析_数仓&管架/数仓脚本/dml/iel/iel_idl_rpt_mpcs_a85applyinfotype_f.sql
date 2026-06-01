: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a85applyinfotype_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a85applyinfotype.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.serviceid,chr(13),''),chr(10),'') as serviceid
,replace(replace(t1.userid,chr(13),''),chr(10),'') as userid
,replace(replace(t1.username,chr(13),''),chr(10),'') as username
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idvalue,chr(13),''),chr(10),'') as idvalue
,replace(replace(t1.msisdn,chr(13),''),chr(10),'') as msisdn
,replace(replace(t1.email,chr(13),''),chr(10),'') as email
,replace(replace(t1.pan,chr(13),''),chr(10),'') as pan
,replace(replace(t1.validdate,chr(13),''),chr(10),'') as validdate
,replace(replace(t1.cvn2,chr(13),''),chr(10),'') as cvn2
,replace(replace(t1.pin,chr(13),''),chr(10),'') as pin
,replace(replace(t1.state,chr(13),''),chr(10),'') as state
,replace(replace(t1.cpsid,chr(13),''),chr(10),'') as cpsid
,replace(replace(t1.applydate,chr(13),''),chr(10),'') as applydate
,replace(replace(t1.activatedate,chr(13),''),chr(10),'') as activatedate
,replace(replace(t1.validatelukcount,chr(13),''),chr(10),'') as validatelukcount
,replace(replace(t1.tokenpan,chr(13),''),chr(10),'') as tokenpan
,replace(replace(t1.expiredate,chr(13),''),chr(10),'') as expiredate
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.statustime,chr(13),''),chr(10),'') as statustime
,replace(replace(t1.panstatus,chr(13),''),chr(10),'') as panstatus
,replace(replace(t1.locked,chr(13),''),chr(10),'') as locked
,replace(replace(t1.lost,chr(13),''),chr(10),'') as lost
,replace(replace(t1.devicemodel,chr(13),''),chr(10),'') as devicemodel
,replace(replace(t1.devicesn,chr(13),''),chr(10),'') as devicesn
,replace(replace(t1.ostype,chr(13),''),chr(10),'') as ostype
,replace(replace(t1.osversion,chr(13),''),chr(10),'') as osversion
,replace(replace(t1.deviceid,chr(13),''),chr(10),'') as deviceid
,replace(replace(t1.imei,chr(13),''),chr(10),'') as imei
,replace(replace(t1.walletname,chr(13),''),chr(10),'') as walletname
,replace(replace(t1.walletsignature,chr(13),''),chr(10),'') as walletsignature
,replace(replace(t1.walletversion,chr(13),''),chr(10),'') as walletversion
,replace(replace(t1.ifpwd,chr(13),''),chr(10),'') as ifpwd
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
 from iol.mpcs_a85applyinfotype T1
where etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a85applyinfotype.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes