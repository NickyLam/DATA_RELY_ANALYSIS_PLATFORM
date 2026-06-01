: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a86mpanmapinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a86mpanmapinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.paysys,chr(13),''),chr(10),'') as paysys
,replace(replace(t.seid,chr(13),''),chr(10),'') as seid
,replace(replace(t.span,chr(13),''),chr(10),'') as span
,replace(replace(t.spanid,chr(13),''),chr(10),'') as spanid
,replace(replace(t.mpan,chr(13),''),chr(10),'') as mpan
,replace(replace(t.mpanid,chr(13),''),chr(10),'') as mpanid
,replace(replace(t.mstpan,chr(13),''),chr(10),'') as mstpan
,replace(replace(t.mstpanid,chr(13),''),chr(10),'') as mstpanid
,replace(replace(t.mappingstatus,chr(13),''),chr(10),'') as mappingstatus
,replace(replace(t.mpanpersoresult,chr(13),''),chr(10),'') as mpanpersoresult
,replace(replace(t.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t.opechannelid,chr(13),''),chr(10),'') as opechannelid
,replace(replace(t.quota,chr(13),''),chr(10),'') as quota
,replace(replace(t.setype,chr(13),''),chr(10),'') as setype
,replace(replace(t.seissuer,chr(13),''),chr(10),'') as seissuer
,replace(replace(t.termconditionid,chr(13),''),chr(10),'') as termconditionid
,replace(replace(t.termconditionaccepteddate,chr(13),''),chr(10),'') as termconditionaccepteddate
,replace(replace(t.cardartid,chr(13),''),chr(10),'') as cardartid
,replace(replace(t.invaluedate,chr(13),''),chr(10),'') as invaluedate
,replace(replace(t.storeidentifier,chr(13),''),chr(10),'') as storeidentifier
,replace(replace(t.applicationid,chr(13),''),chr(10),'') as applicationid
,replace(replace(t.otpresolutionid,chr(13),''),chr(10),'') as otpresolutionid
,replace(replace(t.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t.remark5,chr(13),''),chr(10),'') as remark5
,replace(replace(t.remark6,chr(13),''),chr(10),'') as remark6
,replace(replace(t.remark7,chr(13),''),chr(10),'') as remark7
,replace(replace(t.remark8,chr(13),''),chr(10),'') as remark8
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.MPCS_A86MPANMAPINFO t 
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a86mpanmapinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes