: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_cbondinsideholder_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_cbondinsideholder.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t.s_info_compname,chr(13),''),chr(10),'') as s_info_compname
,replace(replace(t.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t.b_holder_enddate,chr(13),''),chr(10),'') as b_holder_enddate
,replace(replace(t.b_holder_holdercategory,chr(13),''),chr(10),'') as b_holder_holdercategory
,replace(replace(t.b_holder_name,chr(13),''),chr(10),'') as b_holder_name
,t.b_holder_quantity as b_holder_quantity
,t.b_holder_pct as b_holder_pct
,replace(replace(t.b_holder_sharecategory,chr(13),''),chr(10),'') as b_holder_sharecategory
,replace(replace(t.b_holder_aname,chr(13),''),chr(10),'') as b_holder_aname
,t.opdate as opdate
,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
from iol.wind_cbondinsideholder t
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_cbondinsideholder.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes