: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_discnt_acct_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_discnt_acct_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.agt_id
,t1.lp_id
,t1.uniq_idf_id
,t1.bill_id
,t1.cust_acct_id
,t1.discnt_org_id
,t1.bus_kind_cd
,t1.bs_type_cd
,t1.bill_med_cd
,t1.bill_kind_cd
,t1.bs_way_cd
,t1.clear_way_cd
,t1.fac_val_curr_cd
,t1.fac_val_amt
,t1.fac_val_exp_dt
,t1.int_accr_days
,t1.int_recvbl
,t1.discnt_dt
,t1.discnt_flow_id
,t1.close_dt
,t1.close_flow_num
,t1.discnt_status_cd
,t1.bill_acct_id
,t1.int_adj_acct_id
,t1.int_income_expns_acct_id
,t1.last_int_adj_day
,t1.next_int_adj_day
,t1.int_adj_bal
,t1.int_adj_entry_dir_cd
,t1.pay_int_way_cd
,t1.pay_int_acct_id
,t1.pay_int_amt
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_discnt_acct t1 
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_discnt_acct_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes