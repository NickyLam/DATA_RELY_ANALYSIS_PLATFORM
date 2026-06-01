: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_mpcs_a56tsmtranslist_f
CreateDate: 20180529
FileName:   ${iel_data_path}/mpcs_a56tsmtranslist.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.optype,chr(13),''),chr(10),'') as optype
,replace(replace(t.cmdtype,chr(13),''),chr(10),'') as cmdtype
,replace(replace(t.seid,chr(13),''),chr(10),'') as seid
,replace(replace(t.appid,chr(13),''),chr(10),'') as appid
,replace(replace(t.appversion,chr(13),''),chr(10),'') as appversion
,replace(replace(t.processid,chr(13),''),chr(10),'') as processid
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.pin,chr(13),''),chr(10),'') as pin
,replace(replace(t.accttype,chr(13),''),chr(10),'') as accttype
,replace(replace(t.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t.ecashbalance,chr(13),''),chr(10),'') as ecashbalance
,replace(replace(t.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t.idno,chr(13),''),chr(10),'') as idno
,replace(replace(t.acctname,chr(13),''),chr(10),'') as acctname
,replace(replace(t.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t.smsauthcode,chr(13),''),chr(10),'') as smsauthcode
,replace(replace(t.mobilestate,chr(13),''),chr(10),'') as mobilestate
,replace(replace(t.bindacctno,chr(13),''),chr(10),'') as bindacctno
,replace(replace(t.relacctno,chr(13),''),chr(10),'') as relacctno
,replace(replace(t.sharedtype,chr(13),''),chr(10),'') as sharedtype
,replace(replace(t.acctstate,chr(13),''),chr(10),'') as acctstate
,replace(replace(t.applocked,chr(13),''),chr(10),'') as applocked
,replace(replace(t.chnlid,chr(13),''),chr(10),'') as chnlid
,replace(replace(t.opendate,chr(13),''),chr(10),'') as opendate
,replace(replace(t.rspcd,chr(13),''),chr(10),'') as rspcd
,replace(replace(t.rspmsg,chr(13),''),chr(10),'') as rspmsg
,replace(replace(t.interfaceversion,chr(13),''),chr(10),'') as interfaceversion
,replace(replace(t.transtimesource,chr(13),''),chr(10),'') as transtimesource
,replace(replace(t.transtimedestination,chr(13),''),chr(10),'') as transtimedestination
,replace(replace(t.transseqsource,chr(13),''),chr(10),'') as transseqsource
,replace(replace(t.transseqdestination,chr(13),''),chr(10),'') as transseqdestination
,replace(replace(t.transtype,chr(13),''),chr(10),'') as transtype
,replace(replace(t.transsource,chr(13),''),chr(10),'') as transsource
,replace(replace(t.transdestination,chr(13),''),chr(10),'') as transdestination
from ${iol_schema}.mpcs_a56tsmtranslist t
where t.etl_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/mpcs_a56tsmtranslist.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes