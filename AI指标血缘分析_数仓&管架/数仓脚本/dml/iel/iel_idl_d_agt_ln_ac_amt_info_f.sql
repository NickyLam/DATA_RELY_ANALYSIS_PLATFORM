: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_d_agt_ln_ac_amt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/d_agt_ln_ac_amt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.loan_acct_id
,'' as agt_modf
,t1.etl_dt
,t1.last_update_dt
,t1.loan_total_term
,t1.loan_new_term
,t1.ccy_cd
,t1.loan_total_bal
,t1.loan_bal
,t1.day_accr_int
,t1.paid_prcp
,t1.paid_int
,t1.paid_pnlt
,t1.paid_compd_int
,t1.paid_cost
,t1.aggr_rcvable_int_amt
,t1.int_on_bs_bal
,t1.int_off_bs_bal
,t1.on_int
,t1.off_int
,t1.provn
,t1.prev_adj_int_dt
,t1.next_adj_int_dt
,t1.next_stl_dt
,t1.actl_write_off_prcp
,t1.actl_write_off_int
,t1.rcva_acr_intr
,t1.rcva_owe_int
,t1.rcva_accr_pnlt
,t1.rcva_pnlt
,t1.accr_cmpd_intr
,t1.rcva_cmpd_intr
,t1.dun_acr_intr
,t1.dun_owe_int
,t1.dun_accr_pnlt
,t1.dun_pnlt
,t1.data_src_cd
,t1.del_flg
,t1.etl_task_name
,t1.pkg_bef_rcva_int_val
,t1.pkg_after_rcva_int_total_amt
,t1.pkg_after_rcva_int_bal
,t1.has_retn_pkg_after_rcva_int
,t1.tfr_loan_int_total_amt
from ${idl_schema}.hdws_iml_agt_ln_ac_amt_info t1 
where etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd in ('CRSS','CBSS');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/d_agt_ln_ac_amt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes