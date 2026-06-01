: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idf_aml_albs_bls_cust_all_aml_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_albs_bls_cust_all_aml.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select id
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
,etl_dt
,etl_timestamp from idl.aml_albs_bls_cust_all_aml where crt_date = '${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_albs_bls_cust_all_aml.i.${batch_date}.dat" \
        charset=utf8
        safe=yes