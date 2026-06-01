: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_wind_fxrmbmidrate_i
CreateDate: 20180529
FileName:   ${iel_data_path}/wind_fxrmbmidrate.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.object_id,chr(13),''),chr(10),'') as object_id
,replace(replace(t.crncy_code,chr(13),''),chr(10),'') as crncy_code
,replace(replace(t.trade_dt,chr(13),''),chr(10),'') as trade_dt
,t.crncy_midrate as crncy_midrate
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.wind_fxrmbmidrate t
where start_dt =to_date('${batch_date}','yyyymmdd') ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/wind_fxrmbmidrate.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes