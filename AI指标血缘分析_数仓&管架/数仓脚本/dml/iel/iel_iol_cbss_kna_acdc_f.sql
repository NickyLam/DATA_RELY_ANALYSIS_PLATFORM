: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_cbss_kna_acdc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cbss_kna_acdc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.dcmttp,chr(13),''),chr(10),'') as dcmttp
,replace(replace(t.dcmtno,chr(13),''),chr(10),'') as dcmtno
,replace(replace(t.dctpid,chr(13),''),chr(10),'') as dctpid
,replace(replace(t.status,chr(13),''),chr(10),'') as status
,replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.subsac,chr(13),''),chr(10),'') as subsac
,t.seqnno as seqnno
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.cbss_kna_acdc t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cbss_kna_acdc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes