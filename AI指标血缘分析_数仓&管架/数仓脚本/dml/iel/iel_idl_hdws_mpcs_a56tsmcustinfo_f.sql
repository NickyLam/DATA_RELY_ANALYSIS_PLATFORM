: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_mpcs_a56tsmcustinfo_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_mpcs_a56tsmcustinfo.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.seid
,t1.appid
,t1.appversion
,t1.processid
,t1.acctno
,t1.pin
,t1.acctstate
,t1.accttype
,t1.custno
,t1.idtype
,t1.idno
,t1.acctname
,t1.mobile
,t1.mobilestate
,t1.bindacctno
,t1.relacctno
,t1.relacctnotype
,t1.relacctnoold
,t1.relacctnomdl
,t1.sharedtype
,t1.chnlid
,t1.opendate
,t1.expirydata
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_mpcs_a56tsmcustinfo t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_mpcs_a56tsmcustinfo.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes