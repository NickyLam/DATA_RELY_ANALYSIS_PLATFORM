: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondthirdpartyrating_i
CreateDate: 20230423
FileName:   ${iel_data_path}/wind_cbondthirdpartyrating.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_compname,chr(13),''),chr(10),'') as s_info_compname
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,b_rate_style
,replace(replace(t1.b_info_listdate,chr(13),''),chr(10),'') as b_info_listdate
,b_typcode
,replace(replace(t1.b_est_rating_inst,chr(13),''),chr(10),'') as b_est_rating_inst
,replace(replace(t1.b_est_institute,chr(13),''),chr(10),'') as b_est_institute
,replace(replace(t1.b_rate_ratingoutlook,chr(13),''),chr(10),'') as b_rate_ratingoutlook
,replace(replace(t1.b_est_prerating_inst,chr(13),''),chr(10),'') as b_est_prerating_inst
,replace(replace(t1.b_rate_preratingoutlook,chr(13),''),chr(10),'') as b_rate_preratingoutlook
,replace(replace(t1.b_est_rating_change,chr(13),''),chr(10),'') as b_est_rating_change

from ${iol_schema}.wind_cbondthirdpartyrating t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondthirdpartyrating.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
