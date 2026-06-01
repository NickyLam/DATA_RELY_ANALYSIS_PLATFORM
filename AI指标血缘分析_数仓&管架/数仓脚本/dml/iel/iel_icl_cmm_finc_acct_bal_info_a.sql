: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_finc_acct_bal_info_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_finc_acct_bal_info.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.etl_dt as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t.prft_adj_subj_id,chr(13),''),chr(10),'') as prft_adj_subj_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,t.open_dt as open_dt
,t.last_activ_acct_dt as last_activ_acct_dt
,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t.cap_stl_acct_num,chr(13),''),chr(10),'') as cap_stl_acct_num
,replace(replace(t.seller_cd,chr(13),''),chr(10),'') as seller_cd
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.prft_fea_cd,chr(13),''),chr(10),'') as prft_fea_cd
,replace(replace(t.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t.tard_way_cd,chr(13),''),chr(10),'') as tard_way_cd
,replace(replace(t.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,replace(replace(t.prod_risk_level_cd,chr(13),''),chr(10),'') as prod_risk_level_cd
,replace(replace(t.prft_embody_way_cd,chr(13),''),chr(10),'') as prft_embody_way_cd
,replace(replace(t.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,t.prod_found_dt as prod_found_dt
,t.prod_ped_days as prod_ped_days
,t.expe_yld_rat as expe_yld_rat
,t.annual_yld_rat as annual_yld_rat
,replace(replace(t.open_flg,chr(13),''),chr(10),'') as open_flg
,replace(replace(t.brkevn_flg,chr(13),''),chr(10),'') as brkevn_flg
,t.purch_dt as purch_dt
,t.exp_dt as exp_dt
,t.value_dt as value_dt
,t.prft_exp_day as prft_exp_day
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.acct_bal as acct_bal
,t.subscr_tot_amt as subscr_tot_amt
,t.subscr_tot_lot as subscr_tot_lot
,t.redem_lot as redem_lot
,t.redem_amt as redem_amt
,t.curr_lot as curr_lot
,t.aval_lot as aval_lot
,t.tran_froz_lot as tran_froz_lot
,t.lonterm_froz_lot as lonterm_froz_lot
,t.loc_froz_lot as loc_froz_lot
,t.invest_prft as invest_prft
,t.curr_issue_prft as curr_issue_prft
,t.cl_curr_acct_bal as cl_curr_acct_bal
,t.ear_d_bal as ear_d_bal
,t.ear_m_bal as ear_m_bal
,t.ear_s_bal as ear_s_bal
,t.ear_y_bal as ear_y_bal
,t.m_acm_bal as m_acm_bal
,t.s_acm_bal as s_acm_bal
,t.y_acm_bal as y_acm_bal
,t.cl_curr_ear_d_bal as cl_curr_ear_d_bal
,t.cl_curr_ear_m_bal as cl_curr_ear_m_bal
,t.cl_curr_ear_s_bal as cl_curr_ear_s_bal
,t.cl_curr_ear_y_bal as cl_curr_ear_y_bal
,t.cl_curr_y_acm_bal as cl_curr_y_acm_bal
,t.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal
,t.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal
,t.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal
,t.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal
,t.cl_curr_s_acm_bal as cl_curr_s_acm_bal
,t.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal
,t.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal
,t.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal
,t.cl_curr_m_acm_bal as cl_curr_m_acm_bal
,t.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal
,t.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal
,t.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal
,t.y_avg_bal as y_avg_bal
,t.q_avg_bal as q_avg_bal
,t.m_avg_bal as m_avg_bal
,t.cl_curr_y_avg_bal as cl_curr_y_avg_bal
,t.cl_curr_q_avg_bal as cl_curr_q_avg_bal
,t.cl_curr_m_avg_bal as cl_curr_m_avg_bal
,replace(replace(t.prod_tepla_id,chr(13),''),chr(10),'') as prod_tepla_id
,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,t.actl_value_dt as actl_value_dt
,t.actl_exp_dt as actl_exp_dt
,t.mk_val_bal as mk_val_bal
,t.cl_curr_mk_val_bal as cl_curr_mk_val_bal
,t.ear_d_mk_val_bal as ear_d_mk_val_bal
,t.ear_m_mk_val_bal as ear_m_mk_val_bal
,t.ear_s_mk_val_bal as ear_s_mk_val_bal
,t.ear_y_mk_val_bal as ear_y_mk_val_bal
,t.m_acm_mk_val_bal as m_acm_mk_val_bal
,t.s_acm_mk_val_bal as s_acm_mk_val_bal
,t.y_acm_mk_val_bal as y_acm_mk_val_bal
,t.cl_curr_ear_d_mk_val_bal as cl_curr_ear_d_mk_val_bal
,t.cl_curr_ear_m_mk_val_bal as cl_curr_ear_m_mk_val_bal
,t.cl_curr_ear_s_mk_val_bal as cl_curr_ear_s_mk_val_bal
,t.cl_curr_ear_y_mk_val_bal as cl_curr_ear_y_mk_val_bal
,t.cl_curr_y_acm_mk_val_bal as cl_curr_y_acm_mk_val_bal
,t.cl_curr_ear_d_y_acm_mk_val_bal as cl_curr_ear_d_y_acm_mk_val_bal
,t.cl_curr_ear_m_y_acm_mk_val_bal as cl_curr_ear_m_y_acm_mk_val_bal
,t.cl_curr_ear_s_y_acm_mk_val_bal as cl_curr_ear_s_y_acm_mk_val_bal
,t.cl_curr_ear_y_y_acm_mk_val_bal as cl_curr_ear_y_y_acm_mk_val_bal
,t.cl_curr_s_acm_mk_val_bal as cl_curr_s_acm_mk_val_bal
,t.cl_curr_ear_d_s_acm_mk_val_bal as cl_curr_ear_d_s_acm_mk_val_bal
,t.cl_curr_ear_s_s_acm_mk_val_bal as cl_curr_ear_s_s_acm_mk_val_bal
,t.cl_curr_ear_y_s_acm_mk_val_bal as cl_curr_ear_y_s_acm_mk_val_bal
,t.cl_curr_m_acm_mk_val_bal as cl_curr_m_acm_mk_val_bal
,t.cl_curr_ear_d_m_acm_mk_val_bal as cl_curr_ear_d_m_acm_mk_val_bal
,t.cl_curr_ear_m_m_acm_mk_val_bal as cl_curr_ear_m_m_acm_mk_val_bal
,t.cl_curr_ear_y_m_acm_mk_val_bal as cl_curr_ear_y_m_acm_mk_val_bal
,t.y_avg_mk_val_bal as y_avg_mk_val_bal
,t.q_avg_mk_val_bal as q_avg_mk_val_bal
,t.m_avg_mk_val_bal as m_avg_mk_val_bal
,t.cl_curr_y_avg_mk_val_bal as cl_curr_y_avg_mk_val_bal
,t.cl_curr_q_avg_mk_val_bal as cl_curr_q_avg_mk_val_bal
,t.cl_curr_m_avg_mk_val_bal as cl_curr_m_avg_mk_val_bal
,replace(replace(t.prod_tepla_comnt,chr(13),''),chr(10),'') as prod_tepla_comnt
,t.prod_fee_f_unit_nv as prod_fee_f_unit_nv
,t.td_cust_yld_rat as td_cust_yld_rat
,t.prod_fee_bf_ten_thous_prft as prod_fee_bf_ten_thous_prft
,t.td_prft as td_prft
from icl.cmm_finc_acct_bal_info t
where t.etl_dt >= to_date('20210101','yyyymmdd') and t.etl_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_finc_acct_bal_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes