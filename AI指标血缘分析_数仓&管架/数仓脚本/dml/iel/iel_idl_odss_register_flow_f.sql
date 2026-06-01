: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_register_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_register_flow_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 1 from dual where 1=0" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_register_flow_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes