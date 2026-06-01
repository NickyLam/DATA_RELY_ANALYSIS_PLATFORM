: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ctms_tbs_v_issuer_rating_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ctms_tbs_v_issuer_rating.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.issuer_id,chr(13),''),chr(10),'') as issuer_id
,replace(replace(t1.issuer_name_zh,chr(13),''),chr(10),'') as issuer_name_zh
,replace(replace(t1.issuer_name_en,chr(13),''),chr(10),'') as issuer_name_en
,replace(replace(t1.firm_id,chr(13),''),chr(10),'') as firm_id
,replace(replace(t1.rating,chr(13),''),chr(10),'') as rating
,t1.modify_time as modify_time
,replace(replace(t1.rating_date,chr(13),''),chr(10),'') as rating_date
,replace(replace(t1.rating_category,chr(13),''),chr(10),'') as rating_category

from ${iol_schema}.ctms_tbs_v_issuer_rating t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ctms_tbs_v_issuer_rating.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
