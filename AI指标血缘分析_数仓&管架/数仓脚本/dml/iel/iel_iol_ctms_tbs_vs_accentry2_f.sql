: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_vs_accentry2_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ctms_tbs_vs_accentry2.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.accentry2_id as accentry2_id
,t1.aspclient_id as aspclient_id
,t1.keepfolder_id as keepfolder_id
,t1.acccode as acccode
,t1.settledate as settledate
,replace(replace(t1.inouttype,chr(13),''),chr(10),'') as inouttype
,replace(replace(t1.debitcredit,chr(13),''),chr(10),'') as debitcredit
,replace(replace(t1.accountingcode,chr(13),''),chr(10),'') as accountingcode
,t1.amount as amount
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,t1.lastmodified as lastmodified
,t1.send_time as send_time
,replace(replace(t1.batchcode,chr(13),''),chr(10),'') as batchcode
,replace(replace(t1.cptycode,chr(13),''),chr(10),'') as cptycode
,replace(replace(t1.accountingdesc,chr(13),''),chr(10),'') as accountingdesc
,t1.bundlecode as bundlecode
,replace(replace(t1.note,chr(13),''),chr(10),'') as note
,t1.accentry2_id_rev as accentry2_id_rev
,replace(replace(t1.rev_flag,chr(13),''),chr(10),'') as rev_flag

from ${iol_schema}.ctms_tbs_vs_accentry2 t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_vs_accentry2.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
