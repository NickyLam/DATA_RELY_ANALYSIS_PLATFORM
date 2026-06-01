: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_osbs_fls_deposit_record_f
CreateDate: 20240311
FileName:   ${iel_data_path}/osbs_fls_deposit_record.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.fdr_flowno,chr(13),''),chr(10),'') as fdr_flowno
,replace(replace(t1.fdr_globalflow,chr(13),''),chr(10),'') as fdr_globalflow
,replace(replace(t1.fdr_transcode,chr(13),''),chr(10),'') as fdr_transcode
,replace(replace(t1.fdr_transdate,chr(13),''),chr(10),'') as fdr_transdate
,replace(replace(t1.fdr_transtime,chr(13),''),chr(10),'') as fdr_transtime
,replace(replace(t1.fdr_ecifno,chr(13),''),chr(10),'') as fdr_ecifno
,replace(replace(t1.fdr_prodtype,chr(13),''),chr(10),'') as fdr_prodtype
,replace(replace(t1.fdr_ccy,chr(13),''),chr(10),'') as fdr_ccy
,replace(replace(t1.fdr_amount,chr(13),''),chr(10),'') as fdr_amount
,replace(replace(t1.fdr_stagecode,chr(13),''),chr(10),'') as fdr_stagecode
,replace(replace(t1.fdr_composeid,chr(13),''),chr(10),'') as fdr_composeid
,replace(replace(t1.fdr_status,chr(13),''),chr(10),'') as fdr_status
,replace(replace(t1.fdr_errorcode,chr(13),''),chr(10),'') as fdr_errorcode
,replace(replace(t1.fdr_errormsg,chr(13),''),chr(10),'') as fdr_errormsg

from ${iol_schema}.osbs_fls_deposit_record t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/osbs_fls_deposit_record.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
