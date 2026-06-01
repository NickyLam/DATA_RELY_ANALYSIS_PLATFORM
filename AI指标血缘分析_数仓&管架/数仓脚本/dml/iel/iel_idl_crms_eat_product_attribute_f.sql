: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_eat_product_attribute_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_eat_product_attribute_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
product_id
,attr_name
,attr_value
,attr_type
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
from ${idl_schema}.crms_eat_product_attribute
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_eat_product_attribute_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes