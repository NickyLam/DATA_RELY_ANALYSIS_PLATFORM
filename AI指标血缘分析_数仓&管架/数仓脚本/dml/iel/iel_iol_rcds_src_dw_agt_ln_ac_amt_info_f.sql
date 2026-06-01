: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_rcds_src_dw_agt_ln_ac_amt_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/rcds_src_dw_agt_ln_ac_amt_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.loan_acct_id,chr(13),''),chr(10),'') as loan_acct_id
    ,t.etl_dt_ora as etl_dt_ora
    ,t.loan_total_term as loan_total_term
    ,t.loan_new_term as loan_new_term
    ,replace(replace(t.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
    ,t.loan_total_bal as loan_total_bal
    ,t.loan_bal as loan_bal
    ,t.day_accr_int as day_accr_int
    ,t.paid_prcp as paid_prcp
    ,t.paid_int as paid_int
    ,t.paid_pnlt as paid_pnlt
    ,t.paid_compd_int as paid_compd_int
    ,t.paid_cost as paid_cost
    ,t.aggr_rcvable_int_amt as aggr_rcvable_int_amt
    ,t.int_on_bs_bal as int_on_bs_bal
    ,t.int_off_bs_bal as int_off_bs_bal
    ,t.on_int as on_int
    ,t.off_int as off_int
    ,t.provn as provn
    ,t.prev_adj_int_dt as prev_adj_int_dt
    ,t.next_adj_int_dt as next_adj_int_dt
    ,t.next_stl_dt as next_stl_dt
    ,t.actl_write_off_prcp as actl_write_off_prcp
    ,t.actl_write_off_int as actl_write_off_int
    ,t.rcva_acr_intr as rcva_acr_intr
    ,t.rcva_owe_int as rcva_owe_int
    ,t.rcva_accr_pnlt as rcva_accr_pnlt
    ,t.rcva_pnlt as rcva_pnlt
    ,t.accr_cmpd_intr as accr_cmpd_intr
    ,t.rcva_cmpd_intr as rcva_cmpd_intr
    ,t.dun_acr_intr as dun_acr_intr
    ,t.dun_owe_int as dun_owe_int
    ,t.dun_accr_pnlt as dun_accr_pnlt
    ,t.dun_pnlt as dun_pnlt
    ,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
    ,replace(replace(t.del_flg,chr(13),''),chr(10),'') as del_flg
from iol.rcds_src_dw_agt_ln_ac_amt_info t    
  where t.etl_dt = to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rcds_src_dw_agt_ln_ac_amt_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes