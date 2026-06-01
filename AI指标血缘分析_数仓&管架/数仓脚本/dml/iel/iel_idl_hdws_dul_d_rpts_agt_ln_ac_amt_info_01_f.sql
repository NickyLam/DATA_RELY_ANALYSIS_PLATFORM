: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_agt_ln_ac_amt_info_01_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_agt_ln_ac_amt_info_01.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(t1.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
,t1.etl_dt as etl_dt 
,t1.loan_total_term as loan_total_term 
,t1.loan_new_term as loan_new_term 
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd 
,t1.loan_total_bal as loan_total_bal 
,t1.loan_bal as loan_bal 
,t1.day_accr_int as day_accr_int 
,t1.paid_prcp as paid_prcp 
,t1.paid_int as paid_int 
,t1.paid_pnlt as paid_pnlt 
,t1.paid_compd_int as paid_compd_int 
,t1.paid_cost as paid_cost 
,t1.aggr_rcvable_int_amt as aggr_rcvable_int_amt 
,t1.int_on_bs_bal as int_on_bs_bal 
,t1.int_off_bs_bal as int_off_bs_bal 
,t1.on_int as on_int 
,t1.off_int as off_int 
,t1.provn as provn 
,t1.prev_adj_int_dt as prev_adj_int_dt 
,t1.next_adj_int_dt as next_adj_int_dt 
,t1.next_stl_dt as next_stl_dt 
,t1.actl_write_off_prcp as actl_write_off_prcp 
,t1.actl_write_off_int as actl_write_off_int 
,t1.rcva_acr_intr as rcva_acr_intr 
,t1.rcva_owe_int as rcva_owe_int 
,t1.rcva_accr_pnlt as rcva_accr_pnlt 
,t1.rcva_pnlt as rcva_pnlt 
,t1.accr_cmpd_intr as accr_cmpd_intr 
,t1.rcva_cmpd_intr as rcva_cmpd_intr 
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd 
,replace(replace(t1.del_flg,chr(13),''),chr(10),'') as del_flg 
from ${idl_schema}.hdws_dul_d_rpts_agt_ln_ac_amt_info_01 t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_agt_ln_ac_amt_info_01.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes