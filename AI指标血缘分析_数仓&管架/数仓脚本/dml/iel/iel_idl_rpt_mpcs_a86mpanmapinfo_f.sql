: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a86mpanmapinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a86mpanmapinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.paysys,chr(13),''),chr(10),'') as paysys
,replace(replace(t1.seid,chr(13),''),chr(10),'') as seid
,replace(replace(t1.span,chr(13),''),chr(10),'') as span
,replace(replace(t1.spanid,chr(13),''),chr(10),'') as spanid
,replace(replace(t1.mpan,chr(13),''),chr(10),'') as mpan
,replace(replace(t1.mpanid,chr(13),''),chr(10),'') as mpanid
,replace(replace(t1.mstpan,chr(13),''),chr(10),'') as mstpan
,replace(replace(t1.mstpanid,chr(13),''),chr(10),'') as mstpanid
,replace(replace(t1.mappingstatus,chr(13),''),chr(10),'') as mappingstatus
,replace(replace(t1.mpanpersoresult,chr(13),''),chr(10),'') as mpanpersoresult
,replace(replace(t1.custname,chr(13),''),chr(10),'') as custname
,replace(replace(t1.phone,chr(13),''),chr(10),'') as phone
,replace(replace(t1.opechannelid,chr(13),''),chr(10),'') as opechannelid
,replace(replace(t1.quota,chr(13),''),chr(10),'') as quota
,replace(replace(t1.setype,chr(13),''),chr(10),'') as setype
,replace(replace(t1.seissuer,chr(13),''),chr(10),'') as seissuer
,replace(replace(t1.termconditionid,chr(13),''),chr(10),'') as termconditionid
,replace(replace(t1.termconditionaccepteddate,chr(13),''),chr(10),'') as termconditionaccepteddate
,replace(replace(t1.cardartid,chr(13),''),chr(10),'') as cardartid
,replace(replace(t1.invaluedate,chr(13),''),chr(10),'') as invaluedate
,replace(replace(t1.storeidentifier,chr(13),''),chr(10),'') as storeidentifier
,replace(replace(t1.applicationid,chr(13),''),chr(10),'') as applicationid
,replace(replace(t1.otpresolutionid,chr(13),''),chr(10),'') as otpresolutionid
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.remark3,chr(13),''),chr(10),'') as remark3
,replace(replace(t1.remark4,chr(13),''),chr(10),'') as remark4
,replace(replace(t1.remark5,chr(13),''),chr(10),'') as remark5
,replace(replace(t1.remark6,chr(13),''),chr(10),'') as remark6
,replace(replace(t1.remark7,chr(13),''),chr(10),'') as remark7
,replace(replace(t1.remark8,chr(13),''),chr(10),'') as remark8
 from iol.mpcs_a86mpanmapinfo T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a86mpanmapinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes