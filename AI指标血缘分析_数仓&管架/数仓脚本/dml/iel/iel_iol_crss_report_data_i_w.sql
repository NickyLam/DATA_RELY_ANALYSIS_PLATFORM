: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_report_data_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_report_data_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(reportno,chr(10),''),chr(13),'') as reportno
,replace(replace(rowno,chr(10),''),chr(13),'') as rowno
,replace(replace(rowname,chr(10),''),chr(13),'') as rowname
,replace(replace(rowsubject,chr(10),''),chr(13),'') as rowsubject
,replace(replace(displayorder,chr(10),''),chr(13),'') as displayorder
,replace(replace(rowdimtype,chr(10),''),chr(13),'') as rowdimtype
,replace(replace(rowattribute,chr(10),''),chr(13),'') as rowattribute
,replace(replace(col1value,chr(10),''),chr(13),'') as col1value
,replace(replace(col2value,chr(10),''),chr(13),'') as col2value
,replace(replace(col3value,chr(10),''),chr(13),'') as col3value
,replace(replace(col4value,chr(10),''),chr(13),'') as col4value
,replace(replace(standardvalue,chr(10),''),chr(13),'') as standardvalue
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_report_data 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_report_data_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes