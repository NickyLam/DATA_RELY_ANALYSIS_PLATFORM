: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbcontrolflagdesc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbcontrolflagdesc_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
position
,table_value
,remark1
,field_name
,input_type
,prompt
,option_visible
,table_label
,table_name
,table_index
,default_value
from ${idl_schema}.crms_ifm_tbcontrolflagdesc
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbcontrolflagdesc_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes