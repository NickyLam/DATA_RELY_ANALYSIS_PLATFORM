: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcrs_bj_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcrs_bj_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.serno,chr(13),''),chr(10),'') as serno
    ,replace(replace(t.cus_name,chr(13),''),chr(10),'') as cus_name
    ,replace(replace(t.cert_type,chr(13),''),chr(10),'') as cert_type
    ,replace(replace(t.cert_code,chr(13),''),chr(10),'') as cert_code
    ,replace(replace(t.certno_result_flag,chr(13),''),chr(10),'') as certno_result_flag
    ,replace(replace(t.input_date,chr(13),''),chr(10),'') as input_date
    ,replace(replace(t.update_date,chr(13),''),chr(10),'') as update_date
    ,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
    ,replace(replace(t.tz_result_flag,chr(13),''),chr(10),'') as tz_result_flag
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.rcrs_bj_info t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcrs_bj_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes