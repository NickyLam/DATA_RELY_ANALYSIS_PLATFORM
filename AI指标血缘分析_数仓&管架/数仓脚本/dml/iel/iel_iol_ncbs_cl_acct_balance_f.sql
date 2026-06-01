: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ncbs_cl_acct_balance_f
CreateDate: 20221114
FileName:   ${iel_data_path}/ncbs_cl_acct_balance.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.client_no,chr(13),''),chr(10),'') as client_no
,internal_key
,replace(replace(t1.company,chr(13),''),chr(10),'') as company
,replace(replace(t1.dac_value,chr(13),''),chr(10),'') as dac_value
,last_bal_upd_date
,last_change_date
,replace(replace(t1.tran_timestamp,chr(13),''),chr(10),'') as tran_timestamp
,dd_amt
,dda_amt_prev
,gintp_amt
,gintp_amt_prev
,godip_amt
,godip_amt_prev
,godpp_amt
,godpp_amt_prev
,gprd_amt
,gprd_amt_prev
,intp_amt
,intp_amt_prev
,replace(replace(t1.last_change_user_id,chr(13),''),chr(10),'') as last_change_user_id
,odip_amt
,odip_amt_prev
,odpp_amt
,odpp_amt_prev
,osl_amt
,osl_amt_prev
,prd_amt
,prd_amt_prev
,start_dt
,end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark

from ${iol_schema}.ncbs_cl_acct_balance t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ncbs_cl_acct_balance.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
