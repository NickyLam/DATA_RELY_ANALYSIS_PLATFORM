: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_dul_d_rpts_c_agt_loan_mild_sum_02_f
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_dul_d_rpts_c_agt_loan_mild_sum_02.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.etl_dt as etl_dt
,replace(replace(t1.dbill_num,chr(13),''),chr(10),'') as dbill_num
,replace(replace(t1.bil_acct_id,chr(13),''),chr(10),'') as bil_acct_id
,replace(replace(t1.accting_org_id,chr(13),''),chr(10),'') as accting_org_id
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.loan_contr_id,chr(13),''),chr(10),'') as loan_contr_id
,replace(replace(t1.pty_id,chr(13),''),chr(10),'') as pty_id
,replace(replace(t1.pty_typ,chr(13),''),chr(10),'') as pty_typ
,replace(replace(t1.pty_indu,chr(13),''),chr(10),'') as pty_indu
,replace(replace(t1.prd_id,chr(13),''),chr(10),'') as prd_id
,replace(replace(t1.accting_coa_id,chr(13),''),chr(10),'') as accting_coa_id
,replace(replace(t1.loan_dir_indu_cd,chr(13),''),chr(10),'') as loan_dir_indu_cd
,replace(replace(t1.dd_mode_cd,chr(13),''),chr(10),'') as dd_mode_cd
,replace(replace(t1.occur_typ_cd,chr(13),''),chr(10),'') as occur_typ_cd
,replace(replace(t1.loan_prop_cd,chr(13),''),chr(10),'') as loan_prop_cd
,replace(replace(t1.loan_typ_cd,chr(13),''),chr(10),'') as loan_typ_cd
,replace(replace(t1.guar_mode_cd,chr(13),''),chr(10),'') as guar_mode_cd
,replace(replace(t1.corp_size,chr(13),''),chr(10),'') as corp_size
,replace(replace(t1.risk_rat_categ_cd,chr(13),''),chr(10),'') as risk_rat_categ_cd
,replace(replace(t1.risk_rat_resu_cd,chr(13),''),chr(10),'') as risk_rat_resu_cd
,replace(replace(t1.loan_categ10,chr(13),''),chr(10),'') as loan_categ10
,replace(replace(t1.rate_base_typ_cd,chr(13),''),chr(10),'') as rate_base_typ_cd
,t1.base_rate as base_rate
,t1.exec_rate as exec_rate
,t1.term_mon as term_mon
,t1.due_dt as due_dt
,t1.loan_issue_dt as loan_issue_dt
,replace(replace(t1.ccy_cd,chr(13),''),chr(10),'') as ccy_cd
,t1.issue_amt as issue_amt
,t1.dull_bal as dull_bal
,t1.bad_debt_bal as bad_debt_bal
,t1.balance as balance
,t1.int_on_bs_bal as int_on_bs_bal
,t1.int_off_bs_bal as int_off_bs_bal
,t1.norm_bal as norm_bal
,t1.ovdue_bal as ovdue_bal
,replace(replace(t1.margin_ccy_cd,chr(13),''),chr(10),'') as margin_ccy_cd
,t1.margin_amt as margin_amt
,replace(replace(t1.non_resident_flg,chr(13),''),chr(10),'') as non_resident_flg
,replace(replace(t1.ovdue_ind,chr(13),''),chr(10),'') as ovdue_ind
,t1.ovdue_days as ovdue_days
,t1.ovdue_dt as ovdue_dt
,t1.aggr_ovdue_cnt as aggr_ovdue_cnt
,t1.curr_ovdue_term as curr_ovdue_term
,t1.curr_ovdue_int as curr_ovdue_int
,t1.curr_rcva_pnlt as curr_rcva_pnlt
,t1.curr_rcva_compd_int as curr_rcva_compd_int
,replace(replace(t1.agt_status_cd,chr(13),''),chr(10),'') as agt_status_cd
,replace(replace(t1.strg_emg_indu_typ_cd,chr(13),''),chr(10),'') as strg_emg_indu_typ_cd
,replace(replace(t1.rate_adj_mode_cd,chr(13),''),chr(10),'') as rate_adj_mode_cd
,replace(replace(t1.corp_hold_typ_cd,chr(13),''),chr(10),'') as corp_hold_typ_cd
,replace(replace(t1.loan_biz_type_cd,chr(13),''),chr(10),'') as loan_biz_type_cd
,replace(replace(t1.loan_biz_type,chr(13),''),chr(10),'') as loan_biz_type
,replace(replace(t1.loan_usage_desc,chr(13),''),chr(10),'') as loan_usage_desc
,t1.loan_bal_mon_accum as loan_bal_mon_accum
,t1.loan_bal_qtr_accum as loan_bal_qtr_accum
,t1.loan_bal_year_accum as loan_bal_year_accum
,t1.loan_bal_mavg as loan_bal_mavg
,t1.loan_bal_qavg as loan_bal_qavg
,t1.loan_bal_yavg as loan_bal_yavg
,t1.norm_bal_mon_accum as norm_bal_mon_accum
,t1.norm_bal_qtr_accum as norm_bal_qtr_accum
,t1.norm_bal_year_accum as norm_bal_year_accum
,t1.norm_bal_mavg as norm_bal_mavg
,t1.norm_bal_qavg as norm_bal_qavg
,t1.norm_bal_yavg as norm_bal_yavg
,t1.ovdue_bal_mon_accum as ovdue_bal_mon_accum
,t1.ovdue_bal_qtr_accum as ovdue_bal_qtr_accum
,t1.ovdue_bal_year_accum as ovdue_bal_year_accum
,t1.ovdue_bal_mavg as ovdue_bal_mavg
,t1.ovdue_bal_qavg as ovdue_bal_qavg
,t1.ovdue_bal_yavg as ovdue_bal_yavg
,t1.aggr_repay_prcp_amt as aggr_repay_prcp_amt
,t1.aggr_repay_prcp_cnt as aggr_repay_prcp_cnt
,t1.aggr_rcvry_int_amt as aggr_rcvry_int_amt
,t1.aggr_rcvry_prcp_pnlt as aggr_rcvry_prcp_pnlt
,t1.aggr_rcvry_int_pnlt as aggr_rcvry_int_pnlt
,t1.mon_aggr_repay_prcp_amt as mon_aggr_repay_prcp_amt
,t1.mon_aggr_repay_prcp_cnt as mon_aggr_repay_prcp_cnt
,t1.mon_aggr_rcvry_int_amt as mon_aggr_rcvry_int_amt
,t1.mon_aggr_rcvry_prcp_pnlt as mon_aggr_rcvry_prcp_pnlt
,t1.mon_aggr_rcvry_int_pnlt as mon_aggr_rcvry_int_pnlt
,t1.mon_aggr_adv_repay_amt as mon_aggr_adv_repay_amt
,t1.mon_aggr_adv_repay_cnt as mon_aggr_adv_repay_cnt
,t1.mon_aggr_int as mon_aggr_int
,t1.year_aggr_adv_repay_amt as year_aggr_adv_repay_amt
,t1.year_aggr_adv_repay_cnt as year_aggr_adv_repay_cnt
,t1.year_aggr_int as year_aggr_int
,t1.write_off_retra_prcp as write_off_retra_prcp
,t1.write_off_retra_int as write_off_retra_int
,t1.write_off_retra_cnt as write_off_retra_cnt
,t1.write_off_retra_dt as write_off_retra_dt
,replace(replace(t1.write_off_retra_tell_num,chr(13),''),chr(10),'') as write_off_retra_tell_num
from ${idl_schema}.hdws_dul_d_rpts_c_agt_loan_mild_sum_02 t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_dul_d_rpts_c_agt_loan_mild_sum_02.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes