: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_customer_sign_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_customer_sign_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,cust_no
,cust_type
,cust_name
,bank_id
,br_code
,acct_id
,flag
,last_upd_oper_id
,last_upd_time
,f1
,f2
,f3
,cust_address
,bank_name
,sign_br_code
,sign_date
,cancel_date
,union_id
from ${idl_schema}.odss_customer_sign_info
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_customer_sign_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes