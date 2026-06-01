: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_buy_sell_back_f
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_buy_sell_back_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
	ID
	,BRANCH_ID
	,CONTRACT_ID
	,AUDIT_STATUS
	,ACCOUNT_STATUS
	,CALC_STATUS
	,BUY_SELL_RATE_TYPE
	,BUY_SELL_RATE
	,EXP_STATUS
	,RETURN_DATE
	,STTLM_MK
	,OPERATOR_ID
	,TXN_DATE
	,APPNO
	,MISC
	,LAST_UPD_OPER_ID
	,LAST_UPD_TIME
	,CAPITAL_ACCOUNT
	
from ${idl_schema}.ODSS_BUY_SELL_BACK
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_buy_sell_back_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes