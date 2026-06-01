: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_orws_cbss_kna_accs_f
CreateDate: 20180529
FileName:   ${iel_data_path}/orws_cbss_kna_accs.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
replace(replace(t.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t.accstp,chr(13),''),chr(10),'') as accstp
,replace(replace(t.basetg,chr(13),''),chr(10),'') as basetg
,replace(replace(t.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t.csextg,chr(13),''),chr(10),'') as csextg
,replace(replace(t.prodcd,chr(13),''),chr(10),'') as prodcd
,replace(replace(t.acpdcd,chr(13),''),chr(10),'') as acpdcd
from ${iol_schema}.cbss_kna_accs t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/orws_cbss_kna_accs.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes