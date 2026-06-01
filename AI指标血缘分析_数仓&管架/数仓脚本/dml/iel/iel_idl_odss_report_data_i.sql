: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_report_data_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_report_data_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select reportno
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
from ${idl_schema}.odss_report_data
where etl_dt = TO_DATE('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_report_data_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes