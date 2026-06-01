: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_customer_sign_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_customer_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
,replace(replace(t.cust_type,chr(13),''),chr(10),'') as cust_type
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.br_code,chr(13),''),chr(10),'') as br_code
,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t.flag,chr(13),''),chr(10),'') as flag
,t.last_upd_oper_id as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.f1,chr(13),''),chr(10),'') as f1
,replace(replace(t.f2,chr(13),''),chr(10),'') as f2
,replace(replace(t.f3,chr(13),''),chr(10),'') as f3
,replace(replace(t.cust_address,chr(13),''),chr(10),'') as cust_address
,replace(replace(t.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t.sign_br_code,chr(13),''),chr(10),'') as sign_br_code
,replace(replace(t.sign_date,chr(13),''),chr(10),'') as sign_date
,replace(replace(t.cancel_date,chr(13),''),chr(10),'') as cancel_date
,t.union_id as union_id
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_customer_sign_info t
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_customer_sign_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes