: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_cds_tran_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_cds_tran_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.tran_id,chr(13),''),chr(10),'') as tran_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
    ,replace(replace(t.dep_rcpt_acct_id,chr(13),''),chr(10),'') as dep_rcpt_acct_id
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name
    ,replace(replace(t.init_cust_id,chr(13),''),chr(10),'') as init_cust_id
    ,replace(replace(t.prod_acct_id,chr(13),''),chr(10),'') as prod_acct_id
    ,replace(replace(t.init_cust_acct_id,chr(13),''),chr(10),'') as init_cust_acct_id
    ,replace(replace(t.init_acct_name,chr(13),''),chr(10),'') as init_acct_name
    ,replace(replace(t.tran_cust_acct_id,chr(13),''),chr(10),'') as tran_cust_acct_id
    ,replace(replace(t.tran_acct_name,chr(13),''),chr(10),'') as tran_acct_name
    ,t.tran_int_rat as tran_int_rat
    ,t.tran_amt as tran_amt
    ,t.comm_fee as comm_fee
    ,t.expe_yld as expe_yld
    ,t.actl_int_rat as actl_int_rat
    ,t.agt_rat as agt_rat
    ,t.dep_rcpt_bal as dep_rcpt_bal
    ,t.aval_bal as aval_bal
    ,t.paid_int as paid_int
    ,t.acct_dt as acct_dt
    ,t.int_paybl as int_paybl
    ,t.value_tm as value_tm
    ,t.exp_tm as exp_tm
    ,t.exp_days as exp_days
    ,t.tran_start_tm as tran_start_tm
    ,t.tran_end_tm as tran_end_tm
    ,t.revo_tm as revo_tm
    ,replace(replace(t.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd
    ,replace(replace(t.dep_term_cd,chr(13),''),chr(10),'') as dep_term_cd
    ,replace(replace(t.prod_type_cd,chr(13),''),chr(10),'') as prod_type_cd
    ,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
    ,replace(replace(t.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd
    ,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
    ,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,t.start_dt as start_dt
    ,t.end_dt as end_dt
    ,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
    ,replace(replace(t.buyer_cust_id,chr(13),''),chr(10),'') as buyer_cust_id
    ,replace(replace(t.revo_type_cd,chr(13),''),chr(10),'') as revo_type_cd
    ,replace(replace(t.part_tran_liab_id,chr(13),''),chr(10),'') as part_tran_liab_id
from iml.agt_cds_tran_h t 
  where t.start_dt <= to_date('${batch_date}','yyyymmdd') and t.end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_cds_tran_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes