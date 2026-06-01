: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ecrs_report_data_f
CreateDate: 20180529
FileName:   ${iel_data_path}/report_data_${batch_date}_inc.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 reportno
,rowno
,rowname
,rowsubject
,displayorder
,rowdimtype
,rowattribute
,col1value
,col2value
,col3value
,col4value
,standardvalue
from idl.ecrs_report_data
where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/report_data_${batch_date}_inc.dat" \
        charset=zhs16gbk
        safe=yes