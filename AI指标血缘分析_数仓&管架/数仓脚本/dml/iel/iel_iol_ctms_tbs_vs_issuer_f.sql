: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_vs_issuer_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ctms_tbs_vs_issuer.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.status,chr(13),''),chr(10),'') as status
,replace(replace(t1.issuer_name_zh,chr(13),''),chr(10),'') as issuer_name_zh
,replace(replace(t1.issuer_name_en,chr(13),''),chr(10),'') as issuer_name_en
,t1.modify_date as modify_date

from ${iol_schema}.ctms_tbs_vs_issuer t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_vs_issuer.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
