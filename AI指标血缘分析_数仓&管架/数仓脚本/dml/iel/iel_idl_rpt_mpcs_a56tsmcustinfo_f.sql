: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a56tsmcustinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a56tsmcustinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.seid,chr(13),''),chr(10),'') as seid
,replace(replace(t1.appid,chr(13),''),chr(10),'') as appid
,replace(replace(t1.appversion,chr(13),''),chr(10),'') as appversion
,replace(replace(t1.processid,chr(13),''),chr(10),'') as processid
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.pin,chr(13),''),chr(10),'') as pin
,replace(replace(t1.acctstate,chr(13),''),chr(10),'') as acctstate
,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idno,chr(13),''),chr(10),'') as idno
,replace(replace(t1.acctname,chr(13),''),chr(10),'') as acctname
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.mobilestate,chr(13),''),chr(10),'') as mobilestate
,replace(replace(t1.bindacctno,chr(13),''),chr(10),'') as bindacctno
,replace(replace(t1.relacctno,chr(13),''),chr(10),'') as relacctno
,replace(replace(t1.relacctnotype,chr(13),''),chr(10),'') as relacctnotype
,replace(replace(t1.relacctnoold,chr(13),''),chr(10),'') as relacctnoold
,replace(replace(t1.relacctnomdl,chr(13),''),chr(10),'') as relacctnomdl
,replace(replace(t1.sharedtype,chr(13),''),chr(10),'') as sharedtype
,replace(replace(t1.chnlid,chr(13),''),chr(10),'') as chnlid
,replace(replace(t1.opendate,chr(13),''),chr(10),'') as opendate
,replace(replace(t1.expirydata,chr(13),''),chr(10),'') as expirydata
 from iol.mpcs_a56tsmcustinfo T1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a56tsmcustinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes