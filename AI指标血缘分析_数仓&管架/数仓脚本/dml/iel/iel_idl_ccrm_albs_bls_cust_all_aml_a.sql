: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_ccrm_albs_bls_cust_all_aml_a
CreateDate: 20180529
FileName:   ${iel_data_path}/ccrm_albs_bls_cust_all_aml.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,id
,customer_no
,customer_name
,customer_address
,customer_type
,identity_type
,identity_no
,state
,org_code
,org_name
,crt_date
,op_user_id
,detection_name
,input_type
,record_id
,block_reason
,black_source_type
from idl.ccrm_albs_bls_cust_all_aml
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ccrm_albs_bls_cust_all_aml.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes