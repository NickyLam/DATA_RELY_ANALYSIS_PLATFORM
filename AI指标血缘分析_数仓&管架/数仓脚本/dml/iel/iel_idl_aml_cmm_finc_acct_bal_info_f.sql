: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_finc_acct_bal_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_finc_acct_bal_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,lp_id
,tran_acct_id
,prod_id
,prod_name
,subj_id
,cust_id
,cust_type_cd
,finc_acct_id
,open_dt
,last_activ_acct_dt
,acct_status_cd
,open_org_id
,cust_mgr_id
,cap_stl_acct_num
,seller_cd
,bank_id
,prft_fea_cd
,divd_way_cd
,tard_way_cd
,prod_status_cd
,prod_risk_level_cd
,prft_embody_way_cd
,charge_way_cd
,prod_found_dt
,prod_ped_days
,expe_yld_rat
,annual_yld_rat
,open_flg
,brkevn_flg
,purch_dt
,exp_dt
,value_dt
,prft_exp_day
,curr_cd
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
,job_cd
,etl_timestamp
,actl_value_dt
,ec_flg
from idl.aml_cmm_finc_acct_bal_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_finc_acct_bal_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes