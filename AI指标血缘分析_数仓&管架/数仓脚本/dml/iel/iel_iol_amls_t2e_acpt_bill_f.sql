: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t2e_acpt_bill_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t2e_acpt_bill.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.acpt_id,chr(13),''),chr(10),'') as acpt_id
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.contract_no,chr(13),''),chr(10),'') as contract_no
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.acct_org_id,chr(13),''),chr(10),'') as acct_org_id
    ,replace(replace(t.subject_id,chr(13),''),chr(10),'') as subject_id
    ,replace(replace(t.bill_seq,chr(13),''),chr(10),'') as bill_seq
    ,replace(replace(t.bill_no,chr(13),''),chr(10),'') as bill_no
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.bill_amt as bill_amt
    ,replace(replace(t.issue_dt,chr(13),''),chr(10),'') as issue_dt
    ,replace(replace(t.due_dt,chr(13),''),chr(10),'') as due_dt
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.guar_acct_id,chr(13),''),chr(10),'') as guar_acct_id
    ,t.guar_ratio as guar_ratio
    ,t.guar_amt as guar_amt
    ,replace(replace(t.rcv_org_type,chr(13),''),chr(10),'') as rcv_org_type
    ,replace(replace(t.rcv_org_id,chr(13),''),chr(10),'') as rcv_org_id
    ,replace(replace(t.rcv_org_name,chr(13),''),chr(10),'') as rcv_org_name
    ,replace(replace(t.rcv_acct_id,chr(13),''),chr(10),'') as rcv_acct_id
    ,replace(replace(t.pay_dt,chr(13),''),chr(10),'') as pay_dt
    ,replace(replace(t.close_dt,chr(13),''),chr(10),'') as close_dt
    ,replace(replace(t.is_trans,chr(13),''),chr(10),'') as is_trans
    ,replace(replace(t.bill_sts,chr(13),''),chr(10),'') as bill_sts
    ,replace(replace(t.bill_opr_id,chr(13),''),chr(10),'') as bill_opr_id
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amls_t2e_acpt_bill t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t2e_acpt_bill.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes