: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ctms_tbs_vs_accentry2_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ctms_tbs_vs_accentry2.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.accentry2_id
,t1.aspclient_id
,t1.keepfolder_id
,t1.acccode
,t1.settledate
,t1.inouttype
,t1.debitcredit
,t1.accountingcode
,t1.amount
,t1.status
,t1.lastmodified
,t1.send_time
,t1.batchcode
,t1.cptycode
,t1.accountingdesc
,t1.bundlecode
,t1.note
,t1.accentry2_id_rev
,t1.rev_flag
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_ctms_tbs_vs_accentry2 t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ctms_tbs_vs_accentry2.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes