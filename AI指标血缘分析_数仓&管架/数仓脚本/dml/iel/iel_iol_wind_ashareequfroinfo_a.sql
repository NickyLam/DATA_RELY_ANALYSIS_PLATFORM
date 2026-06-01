: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_ashareequfroinfo_a
CreateDate: 20230822
FileName:   ${iel_data_path}/wind_ashareequfroinfo.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t1.ann_date,chr(13),''),chr(10),'') as ann_date
,replace(replace(t1.s_fro_bgdate,chr(13),''),chr(10),'') as s_fro_bgdate
,replace(replace(t1.s_fro_enddate,chr(13),''),chr(10),'') as s_fro_enddate
,replace(replace(t1.s_holder_name,chr(13),''),chr(10),'') as s_holder_name
,s_fro_shares
,replace(replace(t1.frozen_institution,chr(13),''),chr(10),'') as frozen_institution
,replace(replace(t1.disfrozen_time,chr(13),''),chr(10),'') as disfrozen_time
,s_holder_type_code
,replace(replace(t1.s_holder_id,chr(13),''),chr(10),'') as s_holder_id
,shr_category_code
,is_turn_frozen
,is_disfrozen
,s_total_holding_shr
,s_fro_shr_ratio
,s_total_holding_shr_ratio

from ${iol_schema}.wind_ashareequfroinfo t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_ashareequfroinfo.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
