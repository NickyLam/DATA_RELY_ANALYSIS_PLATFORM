: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a86mpanmapinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a86mpanmapinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.transtime
,t1.custno
,t1.paysys
,t1.seid
,t1.span
,t1.spanid
,t1.mpan
,t1.mpanid
,t1.mstpan
,t1.mstpanid
,t1.mappingstatus
,t1.mpanpersoresult
,t1.custname
,t1.phone
,t1.opechannelid
,t1.quota
,t1.setype
,t1.seissuer
,t1.termconditionid
,t1.termconditionaccepteddate
,t1.cardartid
,t1.invaluedate
,t1.storeidentifier
,t1.applicationid
,t1.otpresolutionid
,t1.remark1
,t1.remark2
,t1.remark3
,t1.remark4
,t1.remark5
,t1.remark6
,t1.remark7
,t1.remark8
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_mpcs_a86mpanmapinfo t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a86mpanmapinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes