: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifms_tbinsutransday_f
CreateDate: 20250731
FileName:   ${iel_data_path}/ifms_tbinsutransday.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.date_type,chr(13),''),chr(10),'') as date_type
,replace(replace(t1.asso_code,chr(13),''),chr(10),'') as asso_code
,trans_date

from ${iol_schema}.ifms_tbinsutransday t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbinsutransday.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
