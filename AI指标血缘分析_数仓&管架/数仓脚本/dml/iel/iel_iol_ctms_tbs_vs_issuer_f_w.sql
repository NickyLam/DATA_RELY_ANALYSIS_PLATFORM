: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_vs_issuer_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ctms_tbs_vs_issuer_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(issuer_id,chr(10),''),chr(13),'') as issuer_id
,replace(replace(status,chr(10),''),chr(13),'') as status
,replace(replace(issuer_name_zh,chr(10),''),chr(13),'') as issuer_name_zh
,replace(replace(issuer_name_en,chr(10),''),chr(13),'') as issuer_name_en
,replace(replace(modify_date,chr(10),''),chr(13),'') as modify_date
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ctms_tbs_vs_issuer
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_vs_issuer_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes