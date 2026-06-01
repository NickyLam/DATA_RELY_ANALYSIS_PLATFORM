: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_intercept_item_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_intercept_item.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.item_id,chr(13),''),chr(10),'') as item_id
,replace(replace(t.item_name,chr(13),''),chr(10),'') as item_name
,replace(replace(t.intercept_prompt,chr(13),''),chr(10),'') as intercept_prompt
,replace(replace(t.item_class,chr(13),''),chr(10),'') as item_class
from iol.rcrs_intercept_item t
where t.etl_dt=to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_intercept_item.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes