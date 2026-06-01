: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondissuerrating_a1
CreateDate: 20250102
FileName:   ${iel_data_path}/wind_cbondissuerrating.i.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id 
,replace(replace(t1.s_info_compname,chr(13),''),chr(10),'') as s_info_compname 
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt 
,replace(replace(t1.b_rate_style,chr(13),''),chr(10),'') as b_rate_style 
,replace(replace(t1.b_info_creditrating,chr(13),''),chr(10),'') as b_info_creditrating 
,t1.b_rate_ratingoutlook as b_rate_ratingoutlook 
,replace(replace(t1.b_info_creditratingagency,chr(13),''),chr(10),'') as b_info_creditratingagency 
,replace(replace(t1.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode 
,replace(replace(t1.b_info_creditratingexplain,chr(13),''),chr(10),'') as b_info_creditratingexplain 
,replace(replace(t1.b_info_precreditrating,chr(13),''),chr(10),'') as b_info_precreditrating 
,replace(replace(t1.b_creditrating_change,chr(13),''),chr(10),'') as b_creditrating_change 
,t1.b_info_issuerratetype as b_info_issuerratetype 
,replace(replace(t1.ann_dt2,chr(13),''),chr(10),'') as ann_dt2 
from ${iol_schema}.wind_cbondissuerrating t1 
where ann_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondissuerrating.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes