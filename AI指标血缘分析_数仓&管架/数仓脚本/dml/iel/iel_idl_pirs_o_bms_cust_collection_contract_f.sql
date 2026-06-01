: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_bms_cust_collection_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_bms_cust_collection_contract_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select id
,cust_no
,branch_id
,operator_id
,business_no
,cust_account
,audi_status
,account_status
,colle_date
,cust_bank_no
,cust_name
,cust_acct_bank_name
,last_upd_oper_id
,last_upd_time
,cust_address from idl.pirs_o_bms_cust_collection_contract where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_bms_cust_collection_contract_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes