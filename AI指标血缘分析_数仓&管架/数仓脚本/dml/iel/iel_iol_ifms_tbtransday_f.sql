: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ifms_tbtransday_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ifms_tbtransday.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.date_type,chr(13),''),chr(10),'') as date_type
,replace(replace(t.asso_code,chr(13),''),chr(10),'') as asso_code
,t.trans_date as trans_date
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.ifms_tbtransday t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ifms_tbtransday.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes