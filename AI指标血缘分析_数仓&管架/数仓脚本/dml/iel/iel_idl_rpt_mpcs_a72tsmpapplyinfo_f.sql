: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a72tsmpapplyinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a72tsmpapplyinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.transdate,chr(13),''),chr(10),'') as transdate
,replace(replace(t1.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t1.applystate,chr(13),''),chr(10),'') as applystate
,replace(replace(t1.persnlstate,chr(13),''),chr(10),'') as persnlstate
,replace(replace(t1.rspcd,chr(13),''),chr(10),'') as rspcd
,replace(replace(t1.rspmsg,chr(13),''),chr(10),'') as rspmsg
,replace(replace(t1.msgid,chr(13),''),chr(10),'') as msgid
,replace(replace(t1.pamid,chr(13),''),chr(10),'') as pamid
,replace(replace(t1.instpaid,chr(13),''),chr(10),'') as instpaid
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.periddata,chr(13),''),chr(10),'') as periddata
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.certidtype,chr(13),''),chr(10),'') as certidtype
,replace(replace(t1.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t1.pername,chr(13),''),chr(10),'') as pername
,replace(replace(t1.phoneid,chr(13),''),chr(10),'') as phoneid
,replace(replace(t1.cardnm,chr(13),''),chr(10),'') as cardnm
,replace(replace(t1.stepnum,chr(13),''),chr(10),'') as stepnum
,replace(replace(t1.stepindex,chr(13),''),chr(10),'') as stepindex
,replace(replace(t1.dgifilename,chr(13),''),chr(10),'') as dgifilename
 from iol.mpcs_a72tsmpapplyinfo T1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a72tsmpapplyinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes