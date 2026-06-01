: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_ba_acct_info_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_ba_acct_info.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt 
,lp_id 
,acct_id 
,bill_num 
,acpt_org_id 
,stl_acct_num 
,subj_id 
,bill_med_cd 
,bill_type_cd 
,margin_acct_num 
,margin_dep_term 
,draw_dt 
,close_dt 
,close_flow 
,exp_dt 
,bill_status 
,close_way 
,pymc_acct_num 
,pymc_dt 
,pymc_flow 
,pymc_way 
,advc_flg 
,advc_dubil_id 
,advc_exec_int_rat 
,advc_int_rat_cu_ratio 
,int_rat_base_type_cd 
,fac_val_curr 
,margin_curr 
,margin_ratio 
,margin_amt 
,advc_amt 
,comm_fee 
,fac_val_amt 
,currt_bal 
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
,etl_timestamp from idl.aml_cmm_ba_acct_info where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_ba_acct_info.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes