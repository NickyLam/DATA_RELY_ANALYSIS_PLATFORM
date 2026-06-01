: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_iml_agt_ln_ac_amt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_iml_agt_ln_ac_amt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
loan_acct_id
,etl_dt
,loan_total_term
,loan_new_term
,ccy_cd
,loan_total_bal
,loan_bal
,day_accr_int
,paid_prcp
,paid_int
,paid_pnlt
,paid_compd_int
,paid_cost
,aggr_rcvable_int_amt
,int_on_bs_bal
,int_off_bs_bal
,on_int
,off_int
,provn
,prev_adj_int_dt
,next_adj_int_dt
,next_stl_dt
,actl_write_off_prcp
,actl_write_off_int
,rcva_acr_intr
,rcva_owe_int
,rcva_accr_pnlt
,rcva_pnlt
,accr_cmpd_intr
,rcva_cmpd_intr
,dun_acr_intr
,dun_owe_int
,dun_accr_pnlt
,dun_pnlt
,data_src_cd
,pkg_bef_rcva_int_val
,pkg_after_rcva_int_total_amt
,pkg_after_rcva_int_bal
,has_retn_pkg_after_rcva_int
,tfr_loan_int_total_amt
from ${idl_schema}.hdws_iml_agt_ln_ac_amt_info 
where ((etl_dt = to_date('${batch_date}','yyyymmdd')-1 and data_src_cd = 'LHWD') OR (etl_dt = to_date('${batch_date}','yyyymmdd') and data_src_cd <> 'LHWD'));" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_iml_agt_ln_ac_amt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes