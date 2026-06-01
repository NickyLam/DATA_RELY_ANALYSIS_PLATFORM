: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_loan_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/loan_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,acct_id
,acct_name
,cust_id
,cert_type_cd
,cert_no
,open_brac_id
from idl.loan_acct_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/loan_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes