: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_lc_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_lc_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,acct_id
,lc_id
,issue_bank_lc_id
,dubil_num
,cust_id
,stl_acct_num
,subj_id
,fwd_flg
,circl_flg
,mx_lc_flg
,lc_type_cd
,lc_pay_type_cd
,issue_chn_cd
,bus_breed_id
,lc_status_cd
,issue_bank_cfm_status_cd
,curr_cd
,oper_teller_id
,sign_org_id
,mgmt_org_id
,acct_instit_id
,oper_org_id
,effect_dt
,wrtoff_dt
,issue_dt
,exp_dt
,cfm_dt
,issue_bank_name
,advise_bank_name
,applit_name
,benefc_name
,benefc_cty_cd
,cargo_descb
,open_bank_name
,fwd_tenor
,comm_fee_rat
,comm_fee_amt
,lc_higt_lmt
,issue_amt
,acpty_bal
,lc_bal
,cl_curr_lc_bal
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
from ${idl_schema}.aml_cmm_lc_acct_info
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_lc_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes