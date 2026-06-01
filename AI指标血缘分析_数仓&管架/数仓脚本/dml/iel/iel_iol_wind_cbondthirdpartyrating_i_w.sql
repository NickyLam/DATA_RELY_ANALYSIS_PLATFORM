: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondthirdpartyrating_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_cbondthirdpartyrating_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(object_id,chr(10),''),chr(13),'') as object_id
,replace(replace(s_info_compname,chr(10),''),chr(13),'') as s_info_compname
,replace(replace(s_info_compcode,chr(10),''),chr(13),'') as s_info_compcode
,replace(replace(b_rate_style,chr(10),''),chr(13),'') as b_rate_style
,replace(replace(b_info_listdate,chr(10),''),chr(13),'') as b_info_listdate
,replace(replace(b_typcode,chr(10),''),chr(13),'') as b_typcode
,replace(replace(b_est_rating_inst,chr(10),''),chr(13),'') as b_est_rating_inst
,replace(replace(b_est_institute,chr(10),''),chr(13),'') as b_est_institute
,replace(replace(b_rate_ratingoutlook,chr(10),''),chr(13),'') as b_rate_ratingoutlook
,replace(replace(b_est_prerating_inst,chr(10),''),chr(13),'') as b_est_prerating_inst
,replace(replace(b_rate_preratingoutlook,chr(10),''),chr(13),'') as b_rate_preratingoutlook
,replace(replace(b_est_rating_change,chr(10),''),chr(13),'') as b_est_rating_change
,etl_dt
,etl_timestamp
from ${iol_schema}.wind_cbondthirdpartyrating where etl_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondthirdpartyrating_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes