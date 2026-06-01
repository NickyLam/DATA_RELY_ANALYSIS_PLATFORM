: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cmm_finc_acct_bal_info_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_finc_acct_bal_info_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,t.lp_id
,t.tran_acct_id
,t.prod_id
,t.std_prod_id
,t.prod_name
,t.subj_id
,t.prft_adj_subj_id
,t.cust_id
,t.cust_type_cd
,t.finc_acct_id
,t.cont_id
,t.open_dt
,t.last_activ_acct_dt
,t.acct_status_cd
,t.open_org_id
,t.cust_mgr_id
,t.cap_stl_acct_num
,t.seller_cd
,t.bank_id
,t.prft_fea_cd
,t.divd_way_cd
,t.tard_way_cd
,t.prod_status_cd
,t.prod_risk_level_cd
,t.prft_embody_way_cd
,t.charge_way_cd
,t.ctrl_flg_comb
,t.prod_found_dt
,t.prod_ped_days
,t.expe_yld_rat
,t.annual_yld_rat
,t.open_flg
,t.ec_flg
,t.indv_allow_buy_flg
,t.prod_tepla_id
,t.prod_tepla_comnt
,t.brkevn_flg
,t.purch_dt
,t.exp_dt
,t.value_dt
,t.prft_exp_day
,case when trim(t.actl_value_dt) is null then to_date('00010101','yyyymmdd') else t.actl_value_dt end
,t.actl_exp_dt
,t.curr_cd
,t.acct_bal
,t.mk_val_bal
,t.subscr_tot_amt
,t.subscr_tot_lot
,t.redem_lot
,t.redem_amt
,t.curr_lot
,t.aval_lot
,t.tran_froz_lot
,t.lonterm_froz_lot
,t.loc_froz_lot
,t.prod_fee_f_unit_nv
,t.prod_fee_post_corp_nv
,t.td_cust_yld_rat
,t.prod_fee_bf_ten_thous_prft
,t.td_prft
,t.invest_prft
,t.curr_issue_prft
,t.cl_curr_acct_bal
,t.ear_d_bal
,t.ear_m_bal
,t.ear_s_bal
,t.ear_y_bal
,t.m_acm_bal
,t.s_acm_bal
,t.y_acm_bal
,t.cl_curr_ear_d_bal
,t.cl_curr_ear_m_bal
,t.cl_curr_ear_s_bal
,t.cl_curr_ear_y_bal
,t.cl_curr_y_acm_bal
,t.cl_curr_ear_d_y_acm_bal
,t.cl_curr_ear_m_y_acm_bal
,t.cl_curr_ear_s_y_acm_bal
,t.cl_curr_ear_y_y_acm_bal
,t.cl_curr_s_acm_bal
,t.cl_curr_ear_d_s_acm_bal
,t.cl_curr_ear_s_s_acm_bal
,t.cl_curr_ear_y_s_acm_bal
,t.cl_curr_m_acm_bal
,t.cl_curr_ear_d_m_acm_bal
,t.cl_curr_ear_m_m_acm_bal
,t.cl_curr_ear_y_m_acm_bal
,t.y_avg_bal
,t.q_avg_bal
,t.m_avg_bal
,t.cl_curr_y_avg_bal
,t.cl_curr_q_avg_bal
,t.cl_curr_m_avg_bal
,t.cl_curr_mk_val_bal
,t.ear_d_mk_val_bal
,t.ear_m_mk_val_bal
,t.ear_s_mk_val_bal
,t.ear_y_mk_val_bal
,t.m_acm_mk_val_bal
,t.s_acm_mk_val_bal
,t.y_acm_mk_val_bal
,t.cl_curr_ear_d_mk_val_bal
,t.cl_curr_ear_m_mk_val_bal
,t.cl_curr_ear_s_mk_val_bal
,t.cl_curr_ear_y_mk_val_bal
,t.cl_curr_y_acm_mk_val_bal
,t.cl_curr_ear_d_y_acm_mk_val_bal
,t.cl_curr_ear_m_y_acm_mk_val_bal
,t.cl_curr_ear_s_y_acm_mk_val_bal
,t.cl_curr_ear_y_y_acm_mk_val_bal
,t.cl_curr_s_acm_mk_val_bal
,t.cl_curr_ear_d_s_acm_mk_val_bal
,t.cl_curr_ear_s_s_acm_mk_val_bal
,t.cl_curr_ear_y_s_acm_mk_val_bal
,t.cl_curr_m_acm_mk_val_bal
,t.cl_curr_ear_d_m_acm_mk_val_bal
,t.cl_curr_ear_m_m_acm_mk_val_bal
,t.cl_curr_ear_y_m_acm_mk_val_bal
,t.y_avg_mk_val_bal
,t.q_avg_mk_val_bal
,t.m_avg_mk_val_bal
,t.cl_curr_y_avg_mk_val_bal
,t.cl_curr_q_avg_mk_val_bal
,t.cl_curr_m_avg_mk_val_bal
from ${idl_schema}.cmm_finc_acct_bal_info t
where etl_dt = to_date('${batch_date}','yyyymmdd') ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_finc_acct_bal_info_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes