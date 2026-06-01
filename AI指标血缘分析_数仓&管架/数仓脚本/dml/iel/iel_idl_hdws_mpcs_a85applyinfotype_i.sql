: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a85applyinfotype_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a85applyinfotype.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.transtime
,t1.custno
,t1.serviceid
,t1.userid
,t1.username
,t1.idtype
,t1.idvalue
,t1.msisdn
,t1.email
,t1.pan
,t1.validdate
,t1.cvn2
,t1.pin
,t1.state
,t1.cpsid
,t1.applydate
,t1.activatedate
,t1.validatelukcount
,t1.tokenpan
,t1.expiredate
,t1.status
,t1.statustime
,t1.panstatus
,t1.locked
,t1.lost
,t1.devicemodel
,t1.devicesn
,t1.ostype
,t1.osversion
,t1.deviceid
,t1.imei
,t1.walletname
,t1.walletsignature
,t1.walletversion
,t1.ifpwd
,t1.remark1
,t1.remark2
,t1.remark3
,t1.remark4
from ${idl_schema}.hdws_mpcs_a85applyinfotype t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a85applyinfotype.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes