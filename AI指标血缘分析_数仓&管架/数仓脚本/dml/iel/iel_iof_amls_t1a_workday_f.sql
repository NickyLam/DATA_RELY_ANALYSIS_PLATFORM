: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iof_amls_t1a_workday_f
CreateDate: 20230106
FileName:   ${iel_data_path}/amls_t1a_workday.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,day_dt
,replace(replace(t1.is_holiday,chr(13),''),chr(10),'') as is_holiday
,replace(replace(t1.is_week_first,chr(13),''),chr(10),'') as is_week_first
,replace(replace(t1.day_desc,chr(13),''),chr(10),'') as day_desc
,replace(replace(t1.create_tm,chr(13),''),chr(10),'') as create_tm
,replace(replace(t1.creator,chr(13),''),chr(10),'') as creator
,replace(replace(t1.modify_tm,chr(13),''),chr(10),'') as modify_tm
,replace(replace(t1.modifier,chr(13),''),chr(10),'') as modifier

from ${iol_schema}.amls_t1a_workday t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t1a_workday.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
