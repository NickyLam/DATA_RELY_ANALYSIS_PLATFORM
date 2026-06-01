: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_bdms_customer_sign_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_bdms_customer_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
 t1.id
,t1.cust_no
,t1.cust_type
,t1.cust_name
,t1.bank_id
,t1.br_code
,t1.acct_id
,t1.flag
,t1.last_upd_oper_id
,t1.last_upd_time
,t1.f1
,t1.f2
,t1.f3
,t1.cust_address
,t1.bank_name
,t1.sign_br_code
,t1.sign_date
,t1.cancel_date
,t1.union_id
,t1.start_dt
,t1.end_dt
,t1.id_mark
from ${idl_schema}.hdws_bdms_customer_sign_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_bdms_customer_sign_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes