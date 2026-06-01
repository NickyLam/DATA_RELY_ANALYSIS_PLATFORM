: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_iat_bill_fin_acc_assoc_f
CreateDate: 20180529
FileName:   ${iel_data_path}/IAT_BILL_FIN_ACC_ASSOC_${batch_date}_ALL.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
billing_account_id
,fin_account_id
,party_id
,third_party_id
,product_id
,account_role_type_id
,imprinted_name
,from_date
,thru_date
from idl.crms_iat_bill_fin_acc_assoc
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/IAT_BILL_FIN_ACC_ASSOC_${batch_date}_ALL.dat" \
        charset=zhs16gbk
        safe=yes