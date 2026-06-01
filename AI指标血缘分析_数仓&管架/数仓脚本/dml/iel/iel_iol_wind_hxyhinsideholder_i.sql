: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_hxyhinsideholder_i
CreateDate: 20221110
FileName:   ${iel_data_path}/wind_hxyhinsideholder.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t1.comp_id,chr(13),''),chr(10),'') as comp_id
,replace(replace(t1.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t1.s_holder_enddate,chr(13),''),chr(10),'') as s_holder_enddate
,replace(replace(t1.s_holder_holdercategory,chr(13),''),chr(10),'') as s_holder_holdercategory
,replace(replace(t1.s_holder_aname,chr(13),''),chr(10),'') as s_holder_aname
,s_holder_quantity
,s_holder_pct
,replace(replace(t1.s_holder_sharecategory,chr(13),''),chr(10),'') as s_holder_sharecategory
,replace(replace(t1.crncy_code,chr(13),''),chr(10),'') as crncy_code
,replace(replace(t1.s_holder_memo,chr(13),''),chr(10),'') as s_holder_memo
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.wind_hxyhinsideholder t1
where start_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_hxyhinsideholder.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
