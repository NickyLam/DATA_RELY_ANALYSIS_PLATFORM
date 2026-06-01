: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_ibms_ttrd_accounting_cash_obj_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_ibms_ttrd_accounting_cash_obj.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,obj_id
,tsk_id
,beg_date
,end_date
,ext_cash_acct_id
,cash_acct_id
,currency
,real_amount
,real_margin
,open_time
,update_time
from idl.icrm_ibms_ttrd_accounting_cash_obj
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_ibms_ttrd_accounting_cash_obj.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes