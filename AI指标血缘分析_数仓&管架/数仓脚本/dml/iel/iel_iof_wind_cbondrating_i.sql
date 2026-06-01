: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_wind_cbondrating_i
CreateDate: 20230629
FileName:   ${iel_data_path}/wind_cbondrating.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.b_rate_style,chr(13),''),chr(10),'') as b_rate_style
,replace(replace(t1.b_info_creditrating,chr(13),''),chr(10),'') as b_info_creditrating
,replace(replace(t1.b_info_creditratingagency,chr(13),''),chr(10),'') as b_info_creditratingagency
,replace(replace(t1.b_info_creditratingexplain,chr(13),''),chr(10),'') as b_info_creditratingexplain
,replace(replace(t1.b_info_precreditrating,chr(13),''),chr(10),'') as b_info_precreditrating
,replace(replace(t1.b_creditrating_change,chr(13),''),chr(10),'') as b_creditrating_change
,replace(replace(t1.ann_dt2,chr(13),''),chr(10),'') as ann_dt2

from ${iol_schema}.wind_cbondrating t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondrating.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
