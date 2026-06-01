: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_report_record_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_report_record.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.reportno,chr(13),''),chr(10),'') as reportno
    ,replace(replace(t.objecttype,chr(13),''),chr(10),'') as objecttype
    ,replace(replace(t.objectno,chr(13),''),chr(10),'') as objectno
    ,replace(replace(t.reportscope,chr(13),''),chr(10),'') as reportscope
    ,replace(replace(t.modelno,chr(13),''),chr(10),'') as modelno
    ,replace(replace(t.reportname,chr(13),''),chr(10),'') as reportname
    ,replace(replace(t.reportdate,chr(13),''),chr(10),'') as reportdate
    ,replace(replace(t.inputtime,chr(13),''),chr(10),'') as inputtime
    ,replace(replace(t.orgid,chr(13),''),chr(10),'') as orgid
    ,replace(replace(t.userid,chr(13),''),chr(10),'') as userid
    ,replace(replace(t.updatetime,chr(13),''),chr(10),'') as updatetime
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_report_record t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_report_record.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes