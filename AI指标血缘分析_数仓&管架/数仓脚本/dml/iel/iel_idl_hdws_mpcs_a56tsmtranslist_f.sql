: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a56tsmtranslist_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a56tsmtranslist.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.optype
,t1.cmdtype
,t1.seid
,t1.appid
,t1.appversion
,t1.processid
,t1.acctno
,t1.pin
,t1.accttype
,t1.custno
,t1.ecashbalance
,t1.idtype
,t1.idno
,t1.acctname
,t1.mobile
,t1.smsauthcode
,t1.mobilestate
,t1.bindacctno
,t1.relacctno
,t1.sharedtype
,t1.acctstate
,t1.applocked
,t1.chnlid
,t1.opendate
,t1.rspcd
,t1.rspmsg
,t1.interfaceversion
,t1.transtimesource
,t1.transtimedestination
,t1.transseqsource
,t1.transseqdestination
,t1.transtype
,t1.transsource
,t1.transdestination
from ${idl_schema}.hdws_mpcs_a56tsmtranslist t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a56tsmtranslist.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes