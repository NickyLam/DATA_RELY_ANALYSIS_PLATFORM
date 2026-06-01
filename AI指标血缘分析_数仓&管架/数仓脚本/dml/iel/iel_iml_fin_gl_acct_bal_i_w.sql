: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_fin_gl_acct_bal_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/fin_gl_acct_bal_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.acct_set_id,chr(13),''),chr(10),'') as acct_set_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.acct_dt as acct_dt
,replace(replace(t.acct_duran,chr(13),''),chr(10),'') as acct_duran
,replace(replace(t.subj_comb_id,chr(13),''),chr(10),'') as subj_comb_id
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t.duty_center_id,chr(13),''),chr(10),'') as duty_center_id
,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t.budget_subj_id,chr(13),''),chr(10),'') as budget_subj_id
,replace(replace(t.strip_line_id,chr(13),''),chr(10),'') as strip_line_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,t.yd_oc_dr_bal as yd_oc_dr_bal
,t.yd_oc_cr_bal as yd_oc_cr_bal
,t.yd_dc_dr_bal as yd_dc_dr_bal
,t.yd_dc_cr_bal as yd_dc_cr_bal
,t.yd_usd_dr_bal as yd_usd_dr_bal
,t.yd_usd_cr_bal as yd_usd_cr_bal
,t.yd_oc_rept_dr_bal as yd_oc_rept_dr_bal
,t.yd_oc_rept_cr_bal as yd_oc_rept_cr_bal
,t.yd_dc_rept_dr_bal as yd_dc_rept_dr_bal
,t.yd_dc_rept_cr_bal as yd_dc_rept_cr_bal
,t.yd_usd_rept_dr_bal as yd_usd_rept_dr_bal
,t.yd_usd_rept_cr_bal as yd_usd_rept_cr_bal
,t.td_oc_dr_amt as td_oc_dr_amt
,t.td_oc_cr_amt as td_oc_cr_amt
,t.td_dc_dr_amt as td_dc_dr_amt
,t.td_dc_cr_amt as td_dc_cr_amt
,t.td_usd_dr_amt as td_usd_dr_amt
,t.td_usd_cr_amt as td_usd_cr_amt
,t.td_oc_dr_bal as td_oc_dr_bal
,t.td_oc_cr_bal as td_oc_cr_bal
,t.td_dc_dr_bal as td_dc_dr_bal
,t.td_dc_cr_bal as td_dc_cr_bal
,t.td_usd_dr_bal as td_usd_dr_bal
,t.td_usd_cr_bal as td_usd_cr_bal
,t.td_oc_rept_dr_bal as td_oc_rept_dr_bal
,t.td_oc_rept_cr_bal as td_oc_rept_cr_bal
,t.td_dc_rept_dr_bal as td_dc_rept_dr_bal
,t.td_dc_rept_cr_bal as td_dc_rept_cr_bal
,t.td_usd_rept_dr_bal as td_usd_rept_dr_bal
,t.td_usd_rept_cr_bal as td_usd_rept_cr_bal
,t.ten_dys_bg_dr_oc_bal as ten_dys_bg_dr_oc_bal
,t.ten_dys_bg_cr_oc_bal as ten_dys_bg_cr_oc_bal
,t.ten_dys_bg_dr_dc_bal as ten_dys_bg_dr_dc_bal
,t.ten_dys_bg_cr_dc_bal as ten_dys_bg_cr_dc_bal
,t.ten_dys_bg_dr_usd_bal as ten_dys_bg_dr_usd_bal
,t.ten_dys_bg_cr_usd_bal as ten_dys_bg_cr_usd_bal
,t.mon_tm_bg_dr_oc_bal as mon_tm_bg_dr_oc_bal
,t.mon_tm_bg_cr_oc_bal as mon_tm_bg_cr_oc_bal
,t.mon_tm_bg_dr_dc_bal as mon_tm_bg_dr_dc_bal
,t.mon_tm_bg_cr_dc_bal as mon_tm_bg_cr_dc_bal
,t.mon_tm_bg_dr_usd_bal as mon_tm_bg_dr_usd_bal
,t.mon_tm_bg_cr_usd_bal as mon_tm_bg_cr_usd_bal
,t.mon_tm_bg_dr_rept_oc_bal as mon_tm_bg_dr_rept_oc_bal
,t.mon_tm_bg_cr_rept_oc_bal as mon_tm_bg_cr_rept_oc_bal
,t.mon_tm_bg_dr_rept_dc_bal as mon_tm_bg_dr_rept_dc_bal
,t.mon_tm_bg_cr_rept_dc_bal as mon_tm_bg_cr_rept_dc_bal
,t.mon_tm_bg_dr_rept_usd_bal as mon_tm_bg_dr_rept_usd_bal
,t.mon_tm_bg_cr_rept_usd_bal as mon_tm_bg_cr_rept_usd_bal
,t.th_mon_oc_dr_amt as th_mon_oc_dr_amt
,t.th_mon_oc_cr_amt as th_mon_oc_cr_amt
,t.th_mon_dc_dr_amt as th_mon_dc_dr_amt
,t.th_mon_dc_cr_amt as th_mon_dc_cr_amt
,t.th_mon_usd_dr_amt as th_mon_usd_dr_amt
,t.th_mon_usd_cr_amt as th_mon_usd_cr_amt
,t.ssn_tm_bg_dr_oc_bal as ssn_tm_bg_dr_oc_bal
,t.ssn_tm_bg_cr_oc_bal as ssn_tm_bg_cr_oc_bal
,t.ssn_tm_bg_dr_dc_bal as ssn_tm_bg_dr_dc_bal
,t.ssn_tm_bg_cr_dc_bal as ssn_tm_bg_cr_dc_bal
,t.ssn_tm_bg_dr_usd_bal as ssn_tm_bg_dr_usd_bal
,t.ssn_tm_bg_cr_usd_bal as ssn_tm_bg_cr_usd_bal
,t.ssn_tm_bg_dr_rept_oc_bal as ssn_tm_bg_dr_rept_oc_bal
,t.ssn_tm_bg_cr_rept_oc_bal as ssn_tm_bg_cr_rept_oc_bal
,t.ssn_tm_bg_dr_rept_dc_bal as ssn_tm_bg_dr_rept_dc_bal
,t.ssn_tm_bg_cr_rept_dc_bal as ssn_tm_bg_cr_rept_dc_bal
,t.ssn_tm_bg_dr_rept_usd_bal as ssn_tm_bg_dr_rept_usd_bal
,t.ssn_tm_bg_cr_rept_usd_bal as ssn_tm_bg_cr_rept_usd_bal
,t.th_quar_oc_dr_amt as th_quar_oc_dr_amt
,t.th_quar_oc_cr_amt as th_quar_oc_cr_amt
,t.th_quar_dc_dr_amt as th_quar_dc_dr_amt
,t.th_quar_dc_cr_amt as th_quar_dc_cr_amt
,t.th_quar_usd_dr_amt as th_quar_usd_dr_amt
,t.th_quar_usd_cr_amt as th_quar_usd_cr_amt
,t.half_y_tm_bg_dr_oc_bal as half_y_tm_bg_dr_oc_bal
,t.half_y_tm_bg_cr_oc_bal as half_y_tm_bg_cr_oc_bal
,t.half_y_tm_bg_dr_dc_bal as half_y_tm_bg_dr_dc_bal
,t.half_y_tm_bg_cr_dc_bal as half_y_tm_bg_cr_dc_bal
,t.half_y_tm_bg_dr_usd_bal as half_y_tm_bg_dr_usd_bal
,t.half_y_tm_bg_cr_usd_bal as half_y_tm_bg_cr_usd_bal
,t.half_y_tm_bg_dr_rept_oc_bal as half_y_tm_bg_dr_rept_oc_bal
,t.half_y_tm_bg_cr_rept_oc_bal as half_y_tm_bg_cr_rept_oc_bal
,t.half_y_tm_bg_dr_rept_dc_bal as half_y_tm_bg_dr_rept_dc_bal
,t.half_y_tm_bg_cr_rept_dc_bal as half_y_tm_bg_cr_rept_dc_bal
,t.half_y_tm_bg_dr_rept_usd_bal as half_y_tm_bg_dr_rept_usd_bal
,t.half_y_tm_bg_cr_rept_usd_bal as half_y_tm_bg_cr_rept_usd_bal
,t.half_y_oc_dr_amt as half_y_oc_dr_amt
,t.half_y_oc_cr_amt as half_y_oc_cr_amt
,t.half_y_dc_dr_amt as half_y_dc_dr_amt
,t.half_y_dc_cr_amt as half_y_dc_cr_amt
,t.half_y_usd_dr_amt as half_y_usd_dr_amt
,t.half_y_usd_cr_amt as half_y_usd_cr_amt
,t.year_tm_bg_dr_oc_bal as year_tm_bg_dr_oc_bal
,t.year_tm_bg_cr_oc_bal as year_tm_bg_cr_oc_bal
,t.year_tm_bg_dr_dc_bal as year_tm_bg_dr_dc_bal
,t.year_tm_bg_cr_dc_bal as year_tm_bg_cr_dc_bal
,t.year_tm_bg_dr_usd_bal as year_tm_bg_dr_usd_bal
,t.year_tm_bg_cr_usd_bal as year_tm_bg_cr_usd_bal
,t.year_tm_bg_dr_rept_oc_bal as year_tm_bg_dr_rept_oc_bal
,t.year_tm_bg_cr_rept_oc_bal as year_tm_bg_cr_rept_oc_bal
,t.year_tm_bg_dr_rept_dc_bal as year_tm_bg_dr_rept_dc_bal
,t.year_tm_bg_cr_rept_dc_bal as year_tm_bg_cr_rept_dc_bal
,t.year_tm_bg_dr_rept_usd_bal as year_tm_bg_dr_rept_usd_bal
,t.year_tm_bg_cr_rept_usd_bal as year_tm_bg_cr_rept_usd_bal
,t.th_year_oc_dr_amt as th_year_oc_dr_amt
,t.th_year_oc_cr_amt as th_year_oc_cr_amt
,t.th_year_dc_dr_amt as th_year_dc_dr_amt
,t.th_year_dc_cr_amt as th_year_dc_cr_amt
,t.th_year_usd_dr_amt as th_year_usd_dr_amt
,t.th_year_usd_cr_amt as th_year_usd_cr_amt
,replace(replace(t.src_id,chr(13),''),chr(10),'') as src_id
from ${iml_schema}.fin_gl_acct_bal t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/fin_gl_acct_bal_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes