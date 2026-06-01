: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_intnal_acct_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_intnal_acct.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,lp_id
,acct_id
,curr_cd
,acct_name
,belong_org_id
,accting_cd
,subj_id
,bal_dir_cd
,acct_status_cd
,open_acct_dt
,clos_acct_dt
,in_out_tab_flg
,bus_code_ser_num
,gl_acct_flg
,acct_bal
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
,main_acct_id
from idl.aml_cmm_intnal_acct
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_intnal_acct.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes