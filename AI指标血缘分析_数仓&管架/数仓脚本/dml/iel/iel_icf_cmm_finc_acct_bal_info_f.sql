: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_finc_acct_bal_info_f
CreateDate: 20240530
FileName:   ${iel_data_path}/cmm_finc_acct_bal_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.prft_adj_subj_id,chr(13),''),chr(10),'') as prft_adj_subj_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,open_dt
,last_activ_acct_dt
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t1.open_org_id,chr(13),''),chr(10),'') as open_org_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.cap_stl_acct_num,chr(13),''),chr(10),'') as cap_stl_acct_num
,replace(replace(t1.seller_cd,chr(13),''),chr(10),'') as seller_cd
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t1.prft_fea_cd,chr(13),''),chr(10),'') as prft_fea_cd
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t1.tard_way_cd,chr(13),''),chr(10),'') as tard_way_cd
,replace(replace(t1.prod_status_cd,chr(13),''),chr(10),'') as prod_status_cd
,replace(replace(t1.prod_risk_level_cd,chr(13),''),chr(10),'') as prod_risk_level_cd
,replace(replace(t1.prft_embody_way_cd,chr(13),''),chr(10),'') as prft_embody_way_cd
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,prod_found_dt
,prod_ped_days
,expe_yld_rat
,annual_yld_rat
,replace(replace(t1.open_flg,chr(13),''),chr(10),'') as open_flg
,replace(replace(t1.brkevn_flg,chr(13),''),chr(10),'') as brkevn_flg
,purch_dt
,exp_dt
,value_dt
,prft_exp_day
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,acct_bal
,subscr_tot_amt
,subscr_tot_lot
,redem_lot
,redem_amt
,curr_lot
,aval_lot
,tran_froz_lot
,lonterm_froz_lot
,loc_froz_lot
,invest_prft
,curr_issue_prft
,cl_curr_acct_bal
,ear_d_bal
,ear_m_bal
,ear_s_bal
,ear_y_bal
,m_acm_bal
,s_acm_bal
,y_acm_bal
,cl_curr_ear_d_bal
,cl_curr_ear_m_bal
,cl_curr_ear_s_bal
,cl_curr_ear_y_bal
,cl_curr_y_acm_bal
,cl_curr_ear_d_y_acm_bal
,cl_curr_ear_m_y_acm_bal
,cl_curr_ear_s_y_acm_bal
,cl_curr_ear_y_y_acm_bal
,cl_curr_s_acm_bal
,cl_curr_ear_d_s_acm_bal
,cl_curr_ear_s_s_acm_bal
,cl_curr_ear_y_s_acm_bal
,cl_curr_m_acm_bal
,cl_curr_ear_d_m_acm_bal
,cl_curr_ear_m_m_acm_bal
,cl_curr_ear_y_m_acm_bal
,y_avg_bal
,q_avg_bal
,m_avg_bal
,cl_curr_y_avg_bal
,cl_curr_q_avg_bal
,cl_curr_m_avg_bal
,replace(replace(t1.prod_tepla_id,chr(13),''),chr(10),'') as prod_tepla_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,actl_value_dt
,actl_exp_dt
,mk_val_bal
,cl_curr_mk_val_bal
,ear_d_mk_val_bal
,ear_m_mk_val_bal
,ear_s_mk_val_bal
,ear_y_mk_val_bal
,m_acm_mk_val_bal
,s_acm_mk_val_bal
,y_acm_mk_val_bal
,cl_curr_ear_d_mk_val_bal
,cl_curr_ear_m_mk_val_bal
,cl_curr_ear_s_mk_val_bal
,cl_curr_ear_y_mk_val_bal
,cl_curr_y_acm_mk_val_bal
,cl_curr_ear_d_y_acm_mk_val_bal
,cl_curr_ear_m_y_acm_mk_val_bal
,cl_curr_ear_s_y_acm_mk_val_bal
,cl_curr_ear_y_y_acm_mk_val_bal
,cl_curr_s_acm_mk_val_bal
,cl_curr_ear_d_s_acm_mk_val_bal
,cl_curr_ear_s_s_acm_mk_val_bal
,cl_curr_ear_y_s_acm_mk_val_bal
,cl_curr_m_acm_mk_val_bal
,cl_curr_ear_d_m_acm_mk_val_bal
,cl_curr_ear_m_m_acm_mk_val_bal
,cl_curr_ear_y_m_acm_mk_val_bal
,y_avg_mk_val_bal
,q_avg_mk_val_bal
,m_avg_mk_val_bal
,cl_curr_y_avg_mk_val_bal
,cl_curr_q_avg_mk_val_bal
,cl_curr_m_avg_mk_val_bal
,replace(replace(t1.prod_tepla_comnt,chr(13),''),chr(10),'') as prod_tepla_comnt
,prod_fee_f_unit_nv
,td_cust_yld_rat
,prod_fee_bf_ten_thous_prft
,td_prft
,replace(replace(t1.ctrl_flg_comb,chr(13),''),chr(10),'') as ctrl_flg_comb
,replace(replace(t1.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t1.indv_allow_buy_flg,chr(13),''),chr(10),'') as indv_allow_buy_flg
,prod_fee_post_corp_nv
,allow_buy_begin_day
,allow_buy_exp_day
,replace(replace(t1.inpwn_flg,chr(13),''),chr(10),'') as inpwn_flg
,clos_acct_dt

from ${icl_schema}.cmm_finc_acct_bal_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_finc_acct_bal_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
