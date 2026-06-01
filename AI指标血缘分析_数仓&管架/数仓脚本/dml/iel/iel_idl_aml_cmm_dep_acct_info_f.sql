: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_dep_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_cmm_dep_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,lp_id
,acct_id
,acct_name
,cust_acct_id
,cust_acct_sub_acct_num
,cust_id
,subj_id
,dep_kind_cd
,acct_cls_cd
,acct_type_cd
,acct_attr_cd
,dep_term
,ext_prod_id
,intnal_prod_id
,dep_acct_status_cd
,cust_type_cd
,corp_acct_flg
,stop_pay_status_cd
,general_exch_flg
,advise_dep_flg
,agt_dep_flg
,float_int_rat_flg
,int_rat_float_way_cd
,int_rat_adj_ped_corp_cd
,int_rat_adj_ped_freq
,rc_flg
,margin_flg
,agree_dep_flg
,ibank_dep_flg
,dep_basic_acct_flg
,ec_flg
,privavy_acct_flg
,legal_acct_flg
,auto_redt_flg
,redted_cnt
,itg_dep_earliest_drawbl_dt
,sleep_acct_flg
,dormt_acct_flg
,sal_acct_flg
,froz_flg
,advd_draw_flg
,tranbl_flg
,int_accr_base_cd
,int_accr_flg
,int_set_way_cd
,int_accr_way_cd
,allow_od_flg
,curr_cd
,redt_way_cd
,open_acct_chn_type_cd
,tran_chn_status_cd
,open_acct_dt
,open_acct_tm
,clos_acct_dt
,clos_acct_tm
,actv_dt
,value_dt
,exp_dt
,final_activ_acct_dt
,agree_dep_value_dt
,agree_dep_exp_dt
,froz_dt
,unfrz_dt
,agree_int_rat
,base_rat_type_cd
,base_rat
,exec_int_rat
,td_acru_int
,currt_acru_int
,cust_mgr_id
,open_acct_teller_id
,clos_acct_teller_id
,open_acct_org_id
,close_acct_org_id
,belong_org_id
,loc_flg
,expe_higt_yld_rat
,agree_dep_init_amt
,open_acct_amt
,currt_bal
,aval_bal
,froz_amt
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
,etl_timestamp from idl.aml_cmm_dep_acct_info where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_dep_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes