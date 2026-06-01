: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_ifm_tbshare0_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_ifm_tbshare0_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
in_client_no
,seller_code
,bank_no
,client_no
,bank_acc
,ta_client
,cash_flag
,trans_account_type
,trans_account
,ta_code
,asset_acc
,prd_code
,contract_no
,last_date
,tot_vol
,frozen_vol
,long_frozen_vol
,group_vol
,div_mode
,old_div_mode
,div_rate
,ystdy_tot_vol
,open_branch
,client_type
,append_flag
,other_frozen
,income
,income_rate
,cost
,tot_income
,income_onway
,income_frozen
,income_new
,manage_agio
,tot_manage_fee
,manage_fee
,manage_date
,reserve1
,reserve2
,reserve3
,reserve4
,reserve5
from ${idl_schema}.crms_ifm_tbshare0
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_ifm_tbshare0_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes