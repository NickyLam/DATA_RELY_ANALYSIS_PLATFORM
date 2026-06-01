: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_odss_fin_account_auth_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_odss_fin_account_auth_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
fin_account_auth_id
,fin_account_id
,amount
,currency_uom_id
,authorization_date
,from_date
,thru_date
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
,fin_account_auth_type
,parent_auth_id
,source_sys_id
,consumer_sys_id
,auth_ref_num
from ${idl_schema}.hdws_odss_fin_account_auth
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_odss_fin_account_auth_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes