: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_mpcs_a56tsmtranslist_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_mpcs_a56tsmtranslist.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
 replace(replace(t1.optype,chr(13),''),chr(10),'') as optype
,replace(replace(t1.cmdtype,chr(13),''),chr(10),'') as cmdtype
,replace(replace(t1.seid,chr(13),''),chr(10),'') as seid
,replace(replace(t1.appid,chr(13),''),chr(10),'') as appid
,replace(replace(t1.appversion,chr(13),''),chr(10),'') as appversion
,replace(replace(t1.processid,chr(13),''),chr(10),'') as processid
,replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.pin,chr(13),''),chr(10),'') as pin
,replace(replace(t1.accttype,chr(13),''),chr(10),'') as accttype
,replace(replace(t1.custno,chr(13),''),chr(10),'') as custno
,replace(replace(t1.ecashbalance,chr(13),''),chr(10),'') as ecashbalance
,replace(replace(t1.idtype,chr(13),''),chr(10),'') as idtype
,replace(replace(t1.idno,chr(13),''),chr(10),'') as idno
,replace(replace(t1.acctname,chr(13),''),chr(10),'') as acctname
,replace(replace(t1.mobile,chr(13),''),chr(10),'') as mobile
,replace(replace(t1.smsauthcode,chr(13),''),chr(10),'') as smsauthcode
,replace(replace(t1.mobilestate,chr(13),''),chr(10),'') as mobilestate
,replace(replace(t1.bindacctno,chr(13),''),chr(10),'') as bindacctno
,replace(replace(t1.relacctno,chr(13),''),chr(10),'') as relacctno
,replace(replace(t1.sharedtype,chr(13),''),chr(10),'') as sharedtype
,replace(replace(t1.acctstate,chr(13),''),chr(10),'') as acctstate
,replace(replace(t1.applocked,chr(13),''),chr(10),'') as applocked
,replace(replace(t1.chnlid,chr(13),''),chr(10),'') as chnlid
,replace(replace(t1.opendate,chr(13),''),chr(10),'') as opendate
,replace(replace(t1.rspcd,chr(13),''),chr(10),'') as rspcd
,replace(replace(t1.rspmsg,chr(13),''),chr(10),'') as rspmsg
,replace(replace(t1.interfaceversion,chr(13),''),chr(10),'') as interfaceversion
,replace(replace(t1.transtimesource,chr(13),''),chr(10),'') as transtimesource
,replace(replace(t1.transtimedestination,chr(13),''),chr(10),'') as transtimedestination
,replace(replace(t1.transseqsource,chr(13),''),chr(10),'') as transseqsource
,replace(replace(t1.transseqdestination,chr(13),''),chr(10),'') as transseqdestination
,replace(replace(t1.transtype,chr(13),''),chr(10),'') as transtype
,replace(replace(t1.transsource,chr(13),''),chr(10),'') as transsource
,replace(replace(t1.transdestination,chr(13),''),chr(10),'') as transdestination
 from iol.mpcs_a56tsmtranslist T1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_mpcs_a56tsmtranslist.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes