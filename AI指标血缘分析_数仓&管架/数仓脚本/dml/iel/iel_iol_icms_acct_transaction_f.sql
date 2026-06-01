: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_icms_acct_transaction_f
CreateDate: 20230829
FileName:   ${iel_data_path}/icms_acct_transaction.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.serialno,chr(13),''),chr(10),'') as serialno
,replace(replace(t1.parenttransserialno,chr(13),''),chr(10),'') as parenttransserialno
,replace(replace(t1.transcode,chr(13),''),chr(10),'') as transcode
,replace(replace(t1.relativeobjecttype,chr(13),''),chr(10),'') as relativeobjecttype
,replace(replace(t1.relativeobjectno,chr(13),''),chr(10),'') as relativeobjectno
,replace(replace(t1.documenttype,chr(13),''),chr(10),'') as documenttype
,replace(replace(t1.documentno,chr(13),''),chr(10),'') as documentno
,replace(replace(t1.channelid,chr(13),''),chr(10),'') as channelid
,replace(replace(t1.occurdate,chr(13),''),chr(10),'') as occurdate
,replace(replace(t1.occurtime,chr(13),''),chr(10),'') as occurtime
,replace(replace(t1.transdate,chr(13),''),chr(10),'') as transdate
,replace(replace(t1.transstatus,chr(13),''),chr(10),'') as transstatus
,replace(replace(t1.inputorgid,chr(13),''),chr(10),'') as inputorgid
,replace(replace(t1.inputuserid,chr(13),''),chr(10),'') as inputuserid
,replace(replace(t1.inputtime,chr(13),''),chr(10),'') as inputtime
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.log,chr(13),''),chr(10),'') as log
,replace(replace(t1.fallbacktransserialno,chr(13),''),chr(10),'') as fallbacktransserialno
,replace(replace(t1.tellerserialno,chr(13),''),chr(10),'') as tellerserialno
,transsum
,replace(replace(t1.cnsmrsrlno,chr(13),''),chr(10),'') as cnsmrsrlno
,replace(replace(t1.accountingserialno,chr(13),''),chr(10),'') as accountingserialno
,replace(replace(t1.transtype,chr(13),''),chr(10),'') as transtype
,replace(replace(t1.transoccurtype,chr(13),''),chr(10),'') as transoccurtype
,replace(replace(t1.completeflag,chr(13),''),chr(10),'') as completeflag
,replace(replace(t1.migtflag,chr(13),''),chr(10),'') as migtflag
,replace(replace(t1.graceinterestflag,chr(13),''),chr(10),'') as graceinterestflag
,replace(replace(t1.graceprincipalflag,chr(13),''),chr(10),'') as graceprincipalflag

from ${iol_schema}.icms_acct_transaction t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icms_acct_transaction.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
