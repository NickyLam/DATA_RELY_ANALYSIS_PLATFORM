: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_crss_report_record_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/crss_report_record_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(reportno,chr(10),''),chr(13),'') as reportno
,replace(replace(objecttype,chr(10),''),chr(13),'') as objecttype
,replace(replace(objectno,chr(10),''),chr(13),'') as objectno
,replace(replace(reportscope,chr(10),''),chr(13),'') as reportscope
,replace(replace(modelno,chr(10),''),chr(13),'') as modelno
,replace(replace(reportname,chr(10),''),chr(13),'') as reportname
,replace(replace(reportdate,chr(10),''),chr(13),'') as reportdate
,replace(replace(inputtime,chr(10),''),chr(13),'') as inputtime
,replace(replace(orgid,chr(10),''),chr(13),'') as orgid
,replace(replace(userid,chr(10),''),chr(13),'') as userid
,replace(replace(updatetime,chr(10),''),chr(13),'') as updatetime
,start_dt
,end_dt
,id_mark
,etl_timestamp
 from iol.crss_report_record 
 where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/crss_report_record_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes