: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cash_mgmt_acct_bal_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cash_mgmt_acct_bal_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.bank_intfc_id,chr(13),''),chr(10),'') as bank_intfc_id
,t1.que_req_tm as que_req_tm
,t1.bal_tm as bal_tm
,t1.ld_bal as ld_bal
,t1.bal as bal
,t1.aval_bal as aval_bal
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t1.group_id,chr(13),''),chr(10),'') as group_id
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.agt_cash_mgmt_acct_bal_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cash_mgmt_acct_bal_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes