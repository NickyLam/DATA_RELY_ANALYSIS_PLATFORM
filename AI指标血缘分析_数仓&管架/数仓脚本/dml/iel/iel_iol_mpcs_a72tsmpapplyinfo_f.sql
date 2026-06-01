: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a72tsmpapplyinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a72tsmpapplyinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.transdate,chr(13),''),chr(10),'') as transdate
,replace(replace(t.transtime,chr(13),''),chr(10),'') as transtime
,replace(replace(t.applystate,chr(13),''),chr(10),'') as applystate
,replace(replace(t.persnlstate,chr(13),''),chr(10),'') as persnlstate
,replace(replace(t.rspcd,chr(13),''),chr(10),'') as rspcd
,replace(replace(t.rspmsg,chr(13),''),chr(10),'') as rspmsg
,replace(replace(t.msgid,chr(13),''),chr(10),'') as msgid
,replace(replace(t.pamid,chr(13),''),chr(10),'') as pamid
,replace(replace(t.instpaid,chr(13),''),chr(10),'') as instpaid
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.periddata,chr(13),''),chr(10),'') as periddata
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.certidtype,chr(13),''),chr(10),'') as certidtype
,replace(replace(t.certid,chr(13),''),chr(10),'') as certid
,replace(replace(t.pername,chr(13),''),chr(10),'') as pername
,replace(replace(t.phoneid,chr(13),''),chr(10),'') as phoneid
,replace(replace(t.cardnm,chr(13),''),chr(10),'') as cardnm
,replace(replace(t.stepnum,chr(13),''),chr(10),'') as stepnum
,replace(replace(t.stepindex,chr(13),''),chr(10),'') as stepindex
,replace(replace(t.dgifilename,chr(13),''),chr(10),'') as dgifilename
from ${iol_schema}.mpcs_a72tsmpapplyinfo t
where t.etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a72tsmpapplyinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes