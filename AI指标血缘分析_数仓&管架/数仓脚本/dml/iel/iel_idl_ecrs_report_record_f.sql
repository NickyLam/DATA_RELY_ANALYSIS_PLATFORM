: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_report_record_f
CreateDate: 20180529
FileName:   ${iel_data_path}/ecrs_report_record_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 reportno
,objecttype
,objectno
,reportscope
,modelno
,reportname
,reportdate
,inputtime
,orgid
,userid
,updatetime
from idl.ecrs_report_record
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/ecrs_report_record_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes