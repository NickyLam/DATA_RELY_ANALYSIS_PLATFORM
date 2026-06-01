: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_fkd_other_asset_list_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_fkd_other_asset_list.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.other_asset_type,chr(13),''),chr(10),'') as other_asset_type
,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
,replace(replace(t.pkno,chr(13),''),chr(10),'') as pkno
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_fkd_other_asset_list t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_fkd_other_asset_list.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes