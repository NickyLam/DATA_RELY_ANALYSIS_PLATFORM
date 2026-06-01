: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_agt_loan_wrt_off_appl_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_loan_wrt_off_appl_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create t1emplate
' \
        query="select 
t1.etl_dt 
,t1.appl_id
,t1.lp_id
,t1.dubil_id
,t1.seq_num
,t1.loan_acct_id
,t1.loan_out_acct_acct_id
,t1.wrt_off_pric
,t1.wrt_off_in_bs_int
,t1.wrt_off_off_bs_int
,t1.advc_money_amt
,t1.suit_fee_advc_inside_acct_id
,t1.appl_teller_id
,t1.appl_dt
,t1.appl_tran_flow_num
,t1.appl_tran_tm
,t1.check_teller_id
,t1.wrt_off_proc_dt
,t1.wrt_off_proc_flow_num
,t1.appl_status_cd
,t1.appl_revo_teller_id
,t1.appl_revo_dt
,t1.appl_revo_flow_num
,t1.create_dt 
,t1.update_dt
,t1.id_mark 
,t1.job_cd
from ${idl_schema}.agt_loan_wrt_off_appl t1
where etl_dt between to_date('${batch_date}','yyyymmdd')-6 and to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_loan_wrt_off_appl_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes