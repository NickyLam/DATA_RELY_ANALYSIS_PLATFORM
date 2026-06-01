: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_cbss_kna_accs_stl_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_cbss_kna_accs_stl.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.acctno,chr(13),''),chr(10),'') as acctno
,replace(replace(t1.subsac,chr(13),''),chr(10),'') as subsac
,replace(replace(t1.acctid,chr(13),''),chr(10),'') as acctid
,replace(replace(t1.accstp,chr(13),''),chr(10),'') as accstp
,replace(replace(t1.basetg,chr(13),''),chr(10),'') as basetg
,replace(replace(t1.crcycd,chr(13),''),chr(10),'') as crcycd
,replace(replace(t1.csextg,chr(13),''),chr(10),'') as csextg
,replace(replace(t1.prodcd,chr(13),''),chr(10),'') as prodcd
,replace(replace(t1.acpdcd,chr(13),''),chr(10),'') as acpdcd
,'' as data_date
from ${iol_schema}.cbss_kna_accs_stl t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd') and t1.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pirs_cbss_kna_accs_stl.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes