: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_sell_repurchase_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_sell_repurchase_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,branch_id
,contract_id
,audit_status
,account_status
,calc_status
,buy_back_rate_type
,buy_back_rate
,repurchase_end_date
,exp_status
,operator_id
,txn_date
,appno
,misc
,last_upd_oper_id
,last_upd_time
,capital_account
from ${idl_schema}.odss_sell_repurchase
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_sell_repurchase_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes