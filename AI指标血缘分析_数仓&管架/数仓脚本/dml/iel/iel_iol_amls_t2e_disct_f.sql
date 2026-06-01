: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_amls_t2e_disct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/amls_t2e_disct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.dct_id,chr(13),''),chr(10),'') as dct_id
    ,replace(replace(t.trans_id,chr(13),''),chr(10),'') as trans_id
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,t.dct_dt as dct_dt
    ,replace(replace(t.contract_id,chr(13),''),chr(10),'') as contract_id
    ,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
    ,replace(replace(t.acct_org_id,chr(13),''),chr(10),'') as acct_org_id
    ,replace(replace(t.subject_id,chr(13),''),chr(10),'') as subject_id
    ,t.dct_day as dct_day
    ,t.dct_amt as dct_amt
    ,t.dct_int as dct_int
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
    ,replace(replace(t.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
    ,replace(replace(t.agent_cert_type,chr(13),''),chr(10),'') as agent_cert_type
    ,replace(replace(t.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
    ,replace(replace(t.agent_name,chr(13),''),chr(10),'') as agent_name
    ,replace(replace(t.bill_type,chr(13),''),chr(10),'') as bill_type
    ,replace(replace(t.bill_seq,chr(13),''),chr(10),'') as bill_seq
    ,replace(replace(t.bill_no,chr(13),''),chr(10),'') as bill_no
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.bill_amt as bill_amt
    ,t.bill_bal as bill_bal
    ,replace(replace(t.issue_dt,chr(13),''),chr(10),'') as issue_dt
    ,replace(replace(t.due_dt,chr(13),''),chr(10),'') as due_dt
    ,replace(replace(t.transfer_ind,chr(13),''),chr(10),'') as transfer_ind
    ,replace(replace(t.issue_cust_id,chr(13),''),chr(10),'') as issue_cust_id
    ,replace(replace(t.issue_cust_name,chr(13),''),chr(10),'') as issue_cust_name
    ,replace(replace(t.issue_org_type,chr(13),''),chr(10),'') as issue_org_type
    ,replace(replace(t.issue_org_id,chr(13),''),chr(10),'') as issue_org_id
    ,replace(replace(t.issue_org_name,chr(13),''),chr(10),'') as issue_org_name
    ,replace(replace(t.issue_acct_id,chr(13),''),chr(10),'') as issue_acct_id
    ,replace(replace(t.rcv_cust_id,chr(13),''),chr(10),'') as rcv_cust_id
    ,replace(replace(t.rcv_cust_name,chr(13),''),chr(10),'') as rcv_cust_name
    ,replace(replace(t.rcv_org_type,chr(13),''),chr(10),'') as rcv_org_type
    ,replace(replace(t.rcv_org_id,chr(13),''),chr(10),'') as rcv_org_id
    ,replace(replace(t.rcv_org_name,chr(13),''),chr(10),'') as rcv_org_name
    ,replace(replace(t.rcv_acct_id,chr(13),''),chr(10),'') as rcv_acct_id
    ,replace(replace(t.acpt_org_type,chr(13),''),chr(10),'') as acpt_org_type
    ,replace(replace(t.acpt_org_id,chr(13),''),chr(10),'') as acpt_org_id
    ,replace(replace(t.acpt_org_name,chr(13),''),chr(10),'') as acpt_org_name
    ,replace(replace(t.bill_sts,chr(13),''),chr(10),'') as bill_sts
    ,replace(replace(t.bill_opr_id,chr(13),''),chr(10),'') as bill_opr_id
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
from iol.amls_t2e_disct t
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/amls_t2e_disct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes