: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_vs_accentry2_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_vs_accentry2_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(accentry2_id,chr(10),''),chr(13),'') as accentry2_id
,replace(replace(aspclient_id,chr(10),''),chr(13),'') as aspclient_id
,replace(replace(keepfolder_id,chr(10),''),chr(13),'') as keepfolder_id
,replace(replace(acccode,chr(10),''),chr(13),'') as acccode
,replace(replace(settledate,chr(10),''),chr(13),'') as settledate
,replace(replace(inouttype,chr(10),''),chr(13),'') as inouttype
,replace(replace(debitcredit,chr(10),''),chr(13),'') as debitcredit
,replace(replace(accountingcode,chr(10),''),chr(13),'') as accountingcode
,replace(replace(amount,chr(10),''),chr(13),'') as amount
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(lastmodified,chr(10),''),chr(13),'') as lastmodified
,replace(replace(send_time,chr(10),''),chr(13),'') as send_time
,replace(replace(batchcode,chr(10),''),chr(13),'') as batchcode
,replace(replace(cptycode,chr(10),''),chr(13),'') as cptycode
,replace(replace(accountingdesc,chr(10),''),chr(13),'') as accountingdesc
,replace(replace(bundlecode,chr(10),''),chr(13),'') as bundlecode
,replace(replace(note,chr(10),''),chr(13),'') as note
,replace(replace(accentry2_id_rev,chr(10),''),chr(13),'') as accentry2_id_rev
,replace(replace(rev_flag,chr(10),''),chr(13),'') as rev_flag
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ctms_tbs_vs_accentry2
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_vs_accentry2_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes