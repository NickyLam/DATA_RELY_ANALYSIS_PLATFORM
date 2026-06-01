: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_gl_bal_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_gl_bal.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.etl_dt as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.acct_set_id,chr(13),''),chr(10),'') as acct_set_id
,replace(replace(t.acct_duran,chr(13),''),chr(10),'') as acct_duran
,replace(replace(t.acct_comb_id,chr(13),''),chr(10),'') as acct_comb_id
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t.subj_name,chr(13),''),chr(10),'') as subj_name
,replace(replace(t.subj_lev_cd,chr(13),''),chr(10),'') as subj_lev_cd
,replace(replace(t.subj_dir_cd,chr(13),''),chr(10),'') as subj_dir_cd
,replace(replace(t.subj_char_cd,chr(13),''),chr(10),'') as subj_char_cd
,replace(replace(t.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t.in_out_tab_flg,chr(13),''),chr(10),'') as in_out_tab_flg
,t.yd_oc_dr_bal as yd_oc_dr_bal
,t.yd_oc_cr_bal as yd_oc_cr_bal
,t.yd_dc_dr_bal as yd_dc_dr_bal
,t.yd_dc_cr_bal as yd_dc_cr_bal
,t.td_oc_dr_bal as td_oc_dr_bal
,t.td_oc_cr_bal as td_oc_cr_bal
,t.td_dc_dr_bal as td_dc_dr_bal
,t.td_dc_cr_bal as td_dc_cr_bal
,t.td_oc_dr_amt as td_oc_dr_amt
,t.td_oc_cr_amt as td_oc_cr_amt
,t.td_dc_dr_amt as td_dc_dr_amt
,t.td_dc_cr_amt as td_dc_cr_amt
,t.ten_dys_bg_dr_oc_bal as ten_dys_bg_dr_oc_bal
,t.ten_dys_bg_cr_oc_bal as ten_dys_bg_cr_oc_bal
,t.ten_dys_bg_dr_dc_bal as ten_dys_bg_dr_dc_bal
,t.ten_dys_bg_cr_dc_bal as ten_dys_bg_cr_dc_bal
,t.ear_m_dr_oc_bal as ear_m_dr_oc_bal
,t.ear_m_cr_oc_bal as ear_m_cr_oc_bal
,t.ear_m_dr_dc_bal as ear_m_dr_dc_bal
,t.ear_m_cr_dc_bal as ear_m_cr_dc_bal
,t.mon_oc_dr_amt as mon_oc_dr_amt
,t.mon_oc_cr_amt as mon_oc_cr_amt
,t.mon_dc_dr_amt as mon_dc_dr_amt
,t.mon_dc_cr_amt as mon_dc_cr_amt
,t.ear_s_dr_oc_bal as ear_s_dr_oc_bal
,t.ear_s_cr_oc_bal as ear_s_cr_oc_bal
,t.ear_s_dr_dc_bal as ear_s_dr_dc_bal
,t.ear_s_cr_dc_bal as ear_s_cr_dc_bal
,t.ssn_oc_dr_amt as ssn_oc_dr_amt
,t.ssn_oc_cr_amt as ssn_oc_cr_amt
,t.ssn_dc_dr_amt as ssn_dc_dr_amt
,t.ssn_dc_cr_amt as ssn_dc_cr_amt
,t.ear_y_dr_oc_bal as ear_y_dr_oc_bal
,t.ear_y_cr_oc_bal as ear_y_cr_oc_bal
,t.ear_y_dr_dc_bal as ear_y_dr_dc_bal
,t.ear_y_cr_dc_bal as ear_y_cr_dc_bal
,t.year_oc_dr_amt as year_oc_dr_amt
,t.year_oc_cr_amt as year_oc_cr_amt
,t.year_dc_dr_amt as year_dc_dr_amt
,t.year_dc_cr_amt as year_dc_cr_amt
from icl.cmm_gl_bal t
where t.etl_dt >= to_date('20201201','yyyymmdd') and t.etl_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_gl_bal.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes