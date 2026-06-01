: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_saving_prod_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_saving_prod_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt 
,lp_id 
,acct_id 
,acct_name 
,cust_acct_id 
,cust_id 
,subj_id 
,prod_id 
,dep_term 
,dep_kind_cd 
,acct_cls_cd 
,dep_acct_status_cd 
,stop_pay_status_cd 
,rc_flg 
,general_exch_flg 
,advise_dep_flg 
,ec_flg 
,sleep_acct_flg 
,froz_flg 
,int_accr_base_cd 
,int_set_way_cd 
,int_accr_way_cd 
,curr_cd 
,open_acct_dt 
,open_acct_tm 
,clos_acct_dt 
,value_dt 
,exp_dt 
,final_activ_acct_dt 
,froz_dt 
,unfrz_dt 
,base_rat_type_cd 
,base_rat 
,exec_int_rat 
,td_acru_int 
,currt_acru_int 
,open_acct_teller_id 
,clos_acct_teller_id 
,open_acct_org_id 
,close_acct_org_id 
,currt_bal 
,aval_bal 
,stop_pay_amt 
,cl_curr_currt_bal 
,ear_d_bal 
,ear_m_bal 
,ear_s_bal 
,ear_y_bal 
,y_acm_bal 
,s_acm_bal 
,m_acm_bal 
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
,etl_timestamp from idl.aml_cmm_saving_prod_acct_info where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_saving_prod_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes