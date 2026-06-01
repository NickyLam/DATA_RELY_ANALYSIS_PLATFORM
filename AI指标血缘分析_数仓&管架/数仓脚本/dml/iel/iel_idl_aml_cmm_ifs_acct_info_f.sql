: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_ifs_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_ifs_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,cust_acct_sub_acct_num
,cust_acct_id
,acct_name
,cust_id
,std_prod_id
,prod_id
,bind_webank_card_no
,subj_id
,cust_type_cd
,ext_prod_id
,dep_acct_status_cd
,acpt_pay_status_cd
,froz_status_cd
,stop_pay_status_cd
,dep_term
,sav_type_cd
,exec_int_rat_cate_cd
,pa_ext_int_rat_cate_cd
,ovdue_int_rat_cate_cd
,base_rat_type_cd
,int_set_way_cd
,int_accr_way_cd
,int_accr_base_cd
,corp_acct_flg
,rc_flg
,int_accr_flg
,part_draw_cnt
,acct_instit_id
,open_acct_org_id
,open_acct_teller_id
,open_acct_flow_num
,open_acct_chn_cd
,open_acct_dt
,open_acct_tm
,close_acct_org_id
,clos_acct_teller_id
,clos_acct_flow_num
,clos_acct_dt
,clos_acct_tm
,acct_dt
,value_dt
,exp_dt
,final_activ_acct_dt
,base_rat
,exec_int_rat
,int_rat_flo_val
,curr_cd
,td_acru_int
,currt_acru_int
,currt_bal
,froz_amt
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
,job_cd from idl.aml_cmm_ifs_acct_info where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_ifs_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes