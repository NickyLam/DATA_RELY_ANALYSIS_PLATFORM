: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_fzss_mod_fzs_unit_info_f
CreateDate: 20260304
FileName:   ${iel_data_path}/fzss_mod_fzs_unit_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.corp_id,chr(13),''),chr(10),'') as corp_id
,replace(replace(t1.mybank,chr(13),''),chr(10),'') as mybank
,replace(replace(t1.zone_no,chr(13),''),chr(10),'') as zone_no
,replace(replace(t1.vbrno,chr(13),''),chr(10),'') as vbrno
,replace(replace(t1.tellerno,chr(13),''),chr(10),'') as tellerno
,replace(replace(t1.open_brno,chr(13),''),chr(10),'') as open_brno
,replace(replace(t1.cache_status,chr(13),''),chr(10),'') as cache_status
,replace(replace(t1.data_version,chr(13),''),chr(10),'') as data_version
,replace(replace(t1.data_cache_version,chr(13),''),chr(10),'') as data_cache_version
,create_timestamp
,update_timestamp

from ${iol_schema}.fzss_mod_fzs_unit_info t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fzss_mod_fzs_unit_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
