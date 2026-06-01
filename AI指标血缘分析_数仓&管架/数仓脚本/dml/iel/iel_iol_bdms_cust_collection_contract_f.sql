: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_bdms_cust_collection_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/bdms_cust_collection_contract.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.id as id
,replace(replace(t.cust_no,chr(13),''),chr(10),'') as cust_no
,t.branch_id as branch_id
,t.operator_id as operator_id
,replace(replace(t.business_no,chr(13),''),chr(10),'') as business_no
,replace(replace(t.cust_account,chr(13),''),chr(10),'') as cust_account
,replace(replace(t.audi_status,chr(13),''),chr(10),'') as audi_status
,replace(replace(t.account_status,chr(13),''),chr(10),'') as account_status
,replace(replace(t.colle_date,chr(13),''),chr(10),'') as colle_date
,replace(replace(t.cust_bank_no,chr(13),''),chr(10),'') as cust_bank_no
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.cust_acct_bank_name,chr(13),''),chr(10),'') as cust_acct_bank_name
,replace(replace(t.last_upd_oper_id,chr(13),''),chr(10),'') as last_upd_oper_id
,replace(replace(t.last_upd_time,chr(13),''),chr(10),'') as last_upd_time
,replace(replace(t.cust_address,chr(13),''),chr(10),'') as cust_address
,t.start_dt as start_dt
,t.end_dt as end_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iol_schema}.bdms_cust_collection_contract t
where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/bdms_cust_collection_contract.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes