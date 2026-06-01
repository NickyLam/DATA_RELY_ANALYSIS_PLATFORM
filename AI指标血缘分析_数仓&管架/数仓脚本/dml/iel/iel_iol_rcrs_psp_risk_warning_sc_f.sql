: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_psp_risk_warning_sc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_psp_risk_warning_sc.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.sign_serno,chr(13),''),chr(10),'') as sign_serno
    ,replace(replace(t.content_code,chr(13),''),chr(10),'') as content_code
    ,replace(replace(t.content,chr(13),''),chr(10),'') as content
    ,replace(replace(t.content_level,chr(13),''),chr(10),'') as content_level
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_psp_risk_warning_sc t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_psp_risk_warning_sc.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes