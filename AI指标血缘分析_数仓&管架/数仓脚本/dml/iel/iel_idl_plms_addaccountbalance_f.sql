: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_plms_addaccountbalance_f
CreateDate: 20180529
FileName:   ${iel_data_path}/plms_addaccountbalance_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select cust_no
,acct_no
,acct_tp
,subs_ac
,curr_code
,dp_bal
,dp_mon_avl
,acct_st
,debt_tp from idl.plms_addaccountbalance where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/plms_addaccountbalance_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes