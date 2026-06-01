: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_ashareinsideholder_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_ashareinsideholder.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_windcode,chr(13),''),chr(10),'') as s_info_windcode
,replace(replace(t.ann_dt,chr(13),''),chr(10),'') as ann_dt
,replace(replace(t.s_holder_enddate,chr(13),''),chr(10),'') as s_holder_enddate
,replace(replace(t.s_holder_holdercategory,chr(13),''),chr(10),'') as s_holder_holdercategory
,replace(replace(t.s_holder_name,chr(13),''),chr(10),'') as s_holder_name
,t.s_holder_quantity as s_holder_quantity
,t.s_holder_pct as s_holder_pct
,replace(replace(t.s_holder_sharecategory,chr(13),''),chr(10),'') as s_holder_sharecategory
,t.s_holder_restrictedquantity as s_holder_restrictedquantity
,replace(replace(t.s_holder_aname,chr(13),''),chr(10),'') as s_holder_aname
,replace(replace(t.s_holder_sequence,chr(13),''),chr(10),'') as s_holder_sequence
,replace(replace(t.s_holder_sharecategoryname,chr(13),''),chr(10),'') as s_holder_sharecategoryname
,replace(replace(t.s_holder_memo,chr(13),''),chr(10),'') as s_holder_memo
,t.opdate as opdate
,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
,replace(replace(t.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t.report_period,chr(13),''),chr(10),'') as report_period  
,replace(replace(t.s_holder_nat,chr(13),''),chr(10),'') as s_holder_nat   
from iol.wind_ashareinsideholder t
where etl_dt =to_date('${batch_date}','yyyymmdd');
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_ashareinsideholder.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes