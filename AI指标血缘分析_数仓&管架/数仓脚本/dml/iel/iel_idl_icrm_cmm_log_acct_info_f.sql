: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icrm_cmm_log_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/icrm_cmm_log_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,acct_id
,bus_id
,log_cont_id
,log_acct_num
,out_acct_acct_num
,stl_acct_num
,crdt_contr_no
,recvbl_num
,subj_cd
,log_kind_cd
,fin_log_flg
,overs_log_flg
,advc_flg
,advc_dubil_id
,log_status
,wrtoff_way
,guar_way_cd
,tenor
,benefc_name
,benefc_acct_num
,benefc_open_bank_name
,guar_org_id
,acct_instit_id
,mgmt_org_id
,oper_org_id
,open_dt
,wrtoff_dt
,start_dt
,exp_dt
,open_flow
,wrtoff_flow
,curr_cd
,ovdue_int_rat
,comm_fee_rat
,comm_fee_amt
,compens_amt
,advc_amt
,margin_acct_num
,margin_curr
,margin_ratio
,margin_amt
,log_amt
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
,cl_curr_ear_y_m_acm_bal from idl.icrm_cmm_log_acct_info where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icrm_cmm_log_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes