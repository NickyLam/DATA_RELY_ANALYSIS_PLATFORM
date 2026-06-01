: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_gl_bal_m_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_gl_bal_m.f.${batch_date}.dat
IF_mark:    m_f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_set_id,chr(13),''),chr(10),'') as acct_set_id
,replace(replace(t1.acct_duran,chr(13),''),chr(10),'') as acct_duran
,replace(replace(t1.acct_comb_id,chr(13),''),chr(10),'') as acct_comb_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.subj_name,chr(13),''),chr(10),'') as subj_name
,replace(replace(t1.subj_lev_cd,chr(13),''),chr(10),'') as subj_lev_cd
,replace(replace(t1.subj_dir_cd,chr(13),''),chr(10),'') as subj_dir_cd
,replace(replace(t1.subj_char_cd,chr(13),''),chr(10),'') as subj_char_cd
,replace(replace(t1.data_src_cd,chr(13),''),chr(10),'') as data_src_cd
,replace(replace(t1.in_out_tab_flg,chr(13),''),chr(10),'') as in_out_tab_flg
,t1.yd_oc_dr_bal as yd_oc_dr_bal
,t1.yd_oc_cr_bal as yd_oc_cr_bal
,t1.yd_dc_dr_bal as yd_dc_dr_bal
,t1.yd_dc_cr_bal as yd_dc_cr_bal
,t1.td_oc_dr_bal as td_oc_dr_bal
,t1.td_oc_cr_bal as td_oc_cr_bal
,t1.td_dc_dr_bal as td_dc_dr_bal
,t1.td_dc_cr_bal as td_dc_cr_bal
,t1.td_oc_dr_amt as td_oc_dr_amt
,t1.td_oc_cr_amt as td_oc_cr_amt
,t1.td_dc_dr_amt as td_dc_dr_amt
,t1.td_dc_cr_amt as td_dc_cr_amt
,t1.ten_dys_bg_dr_oc_bal as ten_dys_bg_dr_oc_bal
,t1.ten_dys_bg_cr_oc_bal as ten_dys_bg_cr_oc_bal
,t1.ten_dys_bg_dr_dc_bal as ten_dys_bg_dr_dc_bal
,t1.ten_dys_bg_cr_dc_bal as ten_dys_bg_cr_dc_bal
,t1.ear_m_dr_oc_bal as ear_m_dr_oc_bal
,t1.ear_m_cr_oc_bal as ear_m_cr_oc_bal
,t1.ear_m_dr_dc_bal as ear_m_dr_dc_bal
,t1.ear_m_cr_dc_bal as ear_m_cr_dc_bal
,t1.mon_oc_dr_amt as mon_oc_dr_amt
,t1.mon_oc_cr_amt as mon_oc_cr_amt
,t1.mon_dc_dr_amt as mon_dc_dr_amt
,t1.mon_dc_cr_amt as mon_dc_cr_amt
,t1.ear_s_dr_oc_bal as ear_s_dr_oc_bal
,t1.ear_s_cr_oc_bal as ear_s_cr_oc_bal
,t1.ear_s_dr_dc_bal as ear_s_dr_dc_bal
,t1.ear_s_cr_dc_bal as ear_s_cr_dc_bal
,t1.ssn_oc_dr_amt as ssn_oc_dr_amt
,t1.ssn_oc_cr_amt as ssn_oc_cr_amt
,t1.ssn_dc_dr_amt as ssn_dc_dr_amt
,t1.ssn_dc_cr_amt as ssn_dc_cr_amt
,t1.ear_y_dr_oc_bal as ear_y_dr_oc_bal
,t1.ear_y_cr_oc_bal as ear_y_cr_oc_bal
,t1.ear_y_dr_dc_bal as ear_y_dr_dc_bal
,t1.ear_y_cr_dc_bal as ear_y_cr_dc_bal
,t1.year_oc_dr_amt as year_oc_dr_amt
,t1.year_oc_cr_amt as year_oc_cr_amt
,t1.year_dc_dr_amt as year_dc_dr_amt
,t1.year_dc_cr_amt as year_dc_cr_amt
,replace(replace(t1.budget_subj_id,chr(13),''),chr(10),'') as budget_subj_id
,t1.half_y_tm_bg_dr_oc_bal as half_y_tm_bg_dr_oc_bal
,t1.half_y_tm_bg_cr_oc_bal as half_y_tm_bg_cr_oc_bal
,t1.half_y_tm_bg_dr_dc_bal as half_y_tm_bg_dr_dc_bal
,t1.half_y_tm_bg_cr_dc_bal as half_y_tm_bg_cr_dc_bal
,t1.half_y_oc_dr_amt as half_y_oc_dr_amt
,t1.half_y_oc_cr_amt as half_y_oc_cr_amt
,t1.half_y_dc_dr_amt as half_y_dc_dr_amt
,t1.half_y_dc_cr_amt as half_y_dc_cr_amt
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.td_bal_dir_cd,chr(13),''),chr(10),'') as td_bal_dir_cd
,replace(replace(t1.dtl_subj_flg,chr(13),''),chr(10),'') as dtl_subj_flg
,t1.td_oc_bal as td_oc_bal
,t1.ten_dys_bg_oc_dr_amt as ten_dys_bg_oc_dr_amt
,t1.ten_dys_bg_oc_cr_amt as ten_dys_bg_oc_cr_amt
,t1.ten_dys_bg_dc_dr_amt as ten_dys_bg_dc_dr_amt
,t1.ten_dys_bg_dc_cr_amt as ten_dys_bg_dc_cr_amt
from ${icl_schema}.cmm_gl_bal t1
where to_char(etl_dt,'yyyymm') = to_char(to_date('${batch_date}','yyyymmdd'),'yyyymm')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_gl_bal_m.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes