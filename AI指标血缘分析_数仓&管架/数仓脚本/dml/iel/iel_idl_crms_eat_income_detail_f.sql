: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_crms_eat_income_detail_f
CreateDate: 20180529
FileName:   ${iel_data_path}/crms_eat_iome_detail_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
detail_id
,batch_id
,fund_account
,fund_tran_account
,financing_account
,total_share
,pay_for_income
,fund_code
,charge_type
,last_day_income
,income_share
,redemption_share
,status_id
,last_updated_stamp
,last_updated_tx_stamp
,created_stamp
,created_tx_stamp
from ${idl_schema}.crms_eat_income_detail
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/crms_eat_iome_detail_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes