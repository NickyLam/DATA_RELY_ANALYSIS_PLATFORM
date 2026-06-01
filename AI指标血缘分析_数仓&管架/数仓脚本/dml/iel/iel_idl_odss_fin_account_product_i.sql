: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_fin_account_product_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_fin_account_product_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
fin_account_id
,product_id
,from_date
,thru_date
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
from ${idl_schema}.odss_fin_account_product
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_fin_account_product_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes