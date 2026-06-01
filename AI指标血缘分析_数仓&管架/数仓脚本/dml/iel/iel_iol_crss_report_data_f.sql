: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_report_data_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_report_data.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.reportno,chr(13),''),chr(10),'') as reportno
    ,replace(replace(t.rowno,chr(13),''),chr(10),'') as rowno
    ,replace(replace(t.rowname,chr(13),''),chr(10),'') as rowname
    ,replace(replace(t.rowsubject,chr(13),''),chr(10),'') as rowsubject
    ,replace(replace(t.displayorder,chr(13),''),chr(10),'') as displayorder
    ,replace(replace(t.rowdimtype,chr(13),''),chr(10),'') as rowdimtype
    ,replace(replace(t.rowattribute,chr(13),''),chr(10),'') as rowattribute
    ,t.col1value as col1value
    ,t.col2value as col2value
    ,t.col3value as col3value
    ,t.col4value as col4value
    ,t.standardvalue as standardvalue
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.crss_report_data t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_report_data.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes