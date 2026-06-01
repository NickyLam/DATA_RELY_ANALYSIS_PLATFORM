: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_gl_bal_f
CreateDate: 20240425
FileName:   ${iel_data_path}/cmm_gl_bal.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
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
,yd_oc_dr_bal
,yd_oc_cr_bal
,yd_dc_dr_bal
,yd_dc_cr_bal
,td_oc_dr_bal
,td_oc_cr_bal
,td_dc_dr_bal
,td_dc_cr_bal
,td_oc_dr_amt
,td_oc_cr_amt
,td_dc_dr_amt
,td_dc_cr_amt
,ten_dys_bg_dr_oc_bal
,ten_dys_bg_cr_oc_bal
,ten_dys_bg_dr_dc_bal
,ten_dys_bg_cr_dc_bal
,ear_m_dr_oc_bal
,ear_m_cr_oc_bal
,ear_m_dr_dc_bal
,ear_m_cr_dc_bal
,mon_oc_dr_amt
,mon_oc_cr_amt
,mon_dc_dr_amt
,mon_dc_cr_amt
,ear_s_dr_oc_bal
,ear_s_cr_oc_bal
,ear_s_dr_dc_bal
,ear_s_cr_dc_bal
,ssn_oc_dr_amt
,ssn_oc_cr_amt
,ssn_dc_dr_amt
,ssn_dc_cr_amt
,ear_y_dr_oc_bal
,ear_y_cr_oc_bal
,ear_y_dr_dc_bal
,ear_y_cr_dc_bal
,year_oc_dr_amt
,year_oc_cr_amt
,year_dc_dr_amt
,year_dc_cr_amt
,replace(replace(t1.budget_subj_id,chr(13),''),chr(10),'') as budget_subj_id
,half_y_tm_bg_dr_oc_bal
,half_y_tm_bg_cr_oc_bal
,half_y_tm_bg_dr_dc_bal
,half_y_tm_bg_cr_dc_bal
,half_y_oc_dr_amt
,half_y_oc_cr_amt
,half_y_dc_dr_amt
,half_y_dc_cr_amt
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.td_bal_dir_cd,chr(13),''),chr(10),'') as td_bal_dir_cd
,replace(replace(t1.dtl_subj_flg,chr(13),''),chr(10),'') as dtl_subj_flg
,td_oc_bal
,ten_dys_bg_oc_dr_amt
,ten_dys_bg_oc_cr_amt
,ten_dys_bg_dc_dr_amt
,ten_dys_bg_dc_cr_amt
,replace(replace(t1.new_move_subj_id,chr(13),''),chr(10),'') as new_move_subj_id

from ${icl_schema}.cmm_gl_bal t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_gl_bal.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
