: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_neeqssecindustriesclass_f
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_neeqssecindustriesclass.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.s_info_compcode,chr(13),''),chr(10),'') as s_info_compcode
,replace(replace(t.wind_ind_code,chr(13),''),chr(10),'') as wind_ind_code
,replace(replace(t.entry_dt,chr(13),''),chr(10),'') as entry_dt
,replace(replace(t.remove_dt,chr(13),''),chr(10),'') as remove_dt
,t.cur_sign as cur_sign
,t.opdate as opdate
,replace(replace(t.opmode,chr(13),''),chr(10),'') as opmode
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.wind_neeqssecindustriesclass t
where start_dt <=to_date('${batch_date}','yyyymmdd') and end_dt >to_date('${batch_date}','yyyymmdd') ;
" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_neeqssecindustriesclass.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes