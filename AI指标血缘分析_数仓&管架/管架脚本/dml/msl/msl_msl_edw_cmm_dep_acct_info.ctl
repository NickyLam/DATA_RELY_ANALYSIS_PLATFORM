-- SQL* Unloader: Fast Oracle TetUnloader (Gzip),Release 3.0.1
-- (@) Copyright Lou Fangxin (AnySQL.net) 2004 -2010, all rigths reserved.
-- Purpose:    Sqlldr Control File
-- Author:     Sunline
-- CreateDate: 20190705
-- FileType:   Control-File
-- Logs:
--     luzd 2019-07-05 create template

options(bindsize=2097152,readsize=2097152,errors=0,rows=5000)
load data
infile '${data_path}/cmm_dep_acct_info.f.${yyyymmdd}.dat'
truncate into table ${msl_schema}.msl_edw_cmm_dep_acct_info
fields terminated by x'1b' 
trailing nullcols
(
    etl_dt date "yyyy-mm-dd hh24:mi:ss" nullif etl_dt=blanks 
    ,lp_id char(4000) nullif lp_id=blanks 
    ,acct_id char(4000) nullif acct_id=blanks 
    ,acct_name char(4000) nullif acct_name=blanks 
    ,cust_acct_id char(4000) nullif cust_acct_id=blanks 
    ,cust_acct_sub_acct_num char(4000) nullif cust_acct_sub_acct_num=blanks 
    ,cust_id char(4000) nullif cust_id=blanks 
    ,subj_id char(4000) nullif subj_id=blanks 
    ,dep_kind_cd char(4000) nullif dep_kind_cd=blanks 
    ,acct_cls_cd char(4000) nullif acct_cls_cd=blanks 
    ,acct_type_cd char(4000) nullif acct_type_cd=blanks 
    ,acct_attr_cd char(4000) nullif acct_attr_cd=blanks 
    ,dep_term char(4000) nullif dep_term=blanks 
    ,std_prod_id char(4000) nullif std_prod_id=blanks 
    ,ext_prod_id char(4000) nullif ext_prod_id=blanks 
    ,intnal_prod_id char(4000) nullif intnal_prod_id=blanks 
    ,open_oa_apv_form_num char(4000) nullif open_oa_apv_form_num=blanks 
    ,dep_acct_status_cd char(4000) nullif dep_acct_status_cd=blanks 
    ,cust_type_cd char(4000) nullif cust_type_cd=blanks 
    ,corp_acct_flg char(4000) nullif corp_acct_flg=blanks 
    ,stop_pay_status_cd char(4000) nullif stop_pay_status_cd=blanks 
    ,general_exch_flg char(4000) nullif general_exch_flg=blanks 
    ,advise_dep_flg char(4000) nullif advise_dep_flg=blanks 
    ,agt_dep_flg char(4000) nullif agt_dep_flg=blanks 
    ,float_int_rat_flg char(4000) nullif float_int_rat_flg=blanks 
    ,int_rat_float_way_cd char(4000) nullif int_rat_float_way_cd=blanks 
    ,int_rat_adj_ped_corp_cd char(4000) nullif int_rat_adj_ped_corp_cd=blanks 
    ,int_rat_adj_ped_freq char(4000) nullif int_rat_adj_ped_freq=blanks 
    ,rc_flg char(4000) nullif rc_flg=blanks 
    ,margin_flg char(4000) nullif margin_flg=blanks 
    ,agree_dep_flg char(4000) nullif agree_dep_flg=blanks 
    ,ibank_dep_flg char(4000) nullif ibank_dep_flg=blanks 
    ,dep_basic_acct_flg char(4000) nullif dep_basic_acct_flg=blanks 
    ,ec_flg char(4000) nullif ec_flg=blanks 
    ,privavy_acct_flg char(4000) nullif privavy_acct_flg=blanks 
    ,legal_acct_flg char(4000) nullif legal_acct_flg=blanks 
    ,auto_redt_flg char(4000) nullif auto_redt_flg=blanks 
    ,redted_cnt char(4000) nullif redted_cnt=blanks 
    ,itg_dep_earliest_drawbl_dt date "yyyy-mm-dd hh24:mi:ss" nullif itg_dep_earliest_drawbl_dt=blanks 
    ,sleep_acct_flg char(4000) nullif sleep_acct_flg=blanks 
    ,dormt_acct_flg char(4000) nullif dormt_acct_flg=blanks 
    ,sal_acct_flg char(4000) nullif sal_acct_flg=blanks 
    ,froz_flg char(4000) nullif froz_flg=blanks 
    ,advd_draw_flg char(4000) nullif advd_draw_flg=blanks 
    ,tranbl_flg char(4000) nullif tranbl_flg=blanks 
    ,int_accr_base_cd char(4000) nullif int_accr_base_cd=blanks 
    ,int_accr_flg char(4000) nullif int_accr_flg=blanks 
    ,int_set_way_cd char(4000) nullif int_set_way_cd=blanks 
    ,int_accr_way_cd char(4000) nullif int_accr_way_cd=blanks 
    ,allow_od_flg char(4000) nullif allow_od_flg=blanks 
    ,curr_cd char(4000) nullif curr_cd=blanks 
    ,redt_way_cd char(4000) nullif redt_way_cd=blanks 
    ,open_acct_chn_type_cd char(4000) nullif open_acct_chn_type_cd=blanks 
    ,tran_chn_status_cd char(4000) nullif tran_chn_status_cd=blanks 
    ,open_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif open_acct_dt=blanks 
    ,open_acct_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif open_acct_tm=blanks 
    ,clos_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif clos_acct_dt=blanks 
    ,clos_acct_tm timestamp "yyyy-mm-dd hh24:mi:ss.ff6" nullif clos_acct_tm=blanks 
    ,actv_dt date "yyyy-mm-dd hh24:mi:ss" nullif actv_dt=blanks 
    ,value_dt date "yyyy-mm-dd hh24:mi:ss" nullif value_dt=blanks 
    ,exp_dt date "yyyy-mm-dd hh24:mi:ss" nullif exp_dt=blanks 
    ,final_activ_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif final_activ_acct_dt=blanks 
    ,agree_dep_value_dt date "yyyy-mm-dd hh24:mi:ss" nullif agree_dep_value_dt=blanks 
    ,agree_dep_exp_dt date "yyyy-mm-dd hh24:mi:ss" nullif agree_dep_exp_dt=blanks 
    ,froz_dt date "yyyy-mm-dd hh24:mi:ss" nullif froz_dt=blanks 
    ,unfrz_dt date "yyyy-mm-dd hh24:mi:ss" nullif unfrz_dt=blanks 
    ,last_int_set_dt date "yyyy-mm-dd hh24:mi:ss" nullif last_int_set_dt=blanks 
    ,next_int_set_dt date "yyyy-mm-dd hh24:mi:ss" nullif next_int_set_dt=blanks 
    ,fir_value_dt date "yyyy-mm-dd hh24:mi:ss" nullif fir_value_dt=blanks 
    ,agree_int_rat char(4000) nullif agree_int_rat=blanks 
    ,base_rat_type_cd char(4000) nullif base_rat_type_cd=blanks 
    ,base_rat char(4000) nullif base_rat=blanks 
    ,exec_int_rat char(4000) nullif exec_int_rat=blanks 
    ,td_acru_int char(4000) nullif td_acru_int=blanks 
    ,currt_acru_int char(4000) nullif currt_acru_int=blanks 
    ,cust_mgr_id char(4000) nullif cust_mgr_id=blanks 
    ,open_acct_teller_id char(4000) nullif open_acct_teller_id=blanks 
    ,clos_acct_teller_id char(4000) nullif clos_acct_teller_id=blanks 
    ,open_acct_org_id char(4000) nullif open_acct_org_id=blanks 
    ,close_acct_org_id char(4000) nullif close_acct_org_id=blanks 
    ,belong_org_id char(4000) nullif belong_org_id=blanks 
    ,loc_flg char(4000) nullif loc_flg=blanks 
    ,expe_higt_yld_rat char(4000) nullif expe_higt_yld_rat=blanks 
    ,agree_dep_init_amt char(4000) nullif agree_dep_init_amt=blanks 
    ,open_acct_amt char(4000) nullif open_acct_amt=blanks 
    ,currt_bal char(4000) nullif currt_bal=blanks 
    ,aval_bal char(4000) nullif aval_bal=blanks 
    ,froz_amt char(4000) nullif froz_amt=blanks 
    ,stop_pay_amt char(4000) nullif stop_pay_amt=blanks 
    ,cl_curr_currt_bal char(4000) nullif cl_curr_currt_bal=blanks 
    ,ear_d_bal char(4000) nullif ear_d_bal=blanks 
    ,ear_m_bal char(4000) nullif ear_m_bal=blanks 
    ,ear_s_bal char(4000) nullif ear_s_bal=blanks 
    ,ear_y_bal char(4000) nullif ear_y_bal=blanks 
    ,y_acm_bal char(4000) nullif y_acm_bal=blanks 
    ,s_acm_bal char(4000) nullif s_acm_bal=blanks 
    ,m_acm_bal char(4000) nullif m_acm_bal=blanks 
    ,cl_curr_ear_d_bal char(4000) nullif cl_curr_ear_d_bal=blanks 
    ,cl_curr_ear_m_bal char(4000) nullif cl_curr_ear_m_bal=blanks 
    ,cl_curr_ear_s_bal char(4000) nullif cl_curr_ear_s_bal=blanks 
    ,cl_curr_ear_y_bal char(4000) nullif cl_curr_ear_y_bal=blanks 
    ,cl_curr_y_acm_bal char(4000) nullif cl_curr_y_acm_bal=blanks 
    ,cl_curr_ear_d_y_acm_bal char(4000) nullif cl_curr_ear_d_y_acm_bal=blanks 
    ,cl_curr_ear_m_y_acm_bal char(4000) nullif cl_curr_ear_m_y_acm_bal=blanks 
    ,cl_curr_ear_s_y_acm_bal char(4000) nullif cl_curr_ear_s_y_acm_bal=blanks 
    ,cl_curr_ear_y_y_acm_bal char(4000) nullif cl_curr_ear_y_y_acm_bal=blanks 
    ,cl_curr_s_acm_bal char(4000) nullif cl_curr_s_acm_bal=blanks 
    ,cl_curr_ear_d_s_acm_bal char(4000) nullif cl_curr_ear_d_s_acm_bal=blanks 
    ,cl_curr_ear_s_s_acm_bal char(4000) nullif cl_curr_ear_s_s_acm_bal=blanks 
    ,cl_curr_ear_y_s_acm_bal char(4000) nullif cl_curr_ear_y_s_acm_bal=blanks 
    ,cl_curr_m_acm_bal char(4000) nullif cl_curr_m_acm_bal=blanks 
    ,cl_curr_ear_d_m_acm_bal char(4000) nullif cl_curr_ear_d_m_acm_bal=blanks 
    ,cl_curr_ear_m_m_acm_bal char(4000) nullif cl_curr_ear_m_m_acm_bal=blanks 
    ,cl_curr_ear_y_m_acm_bal char(4000) nullif cl_curr_ear_y_m_acm_bal=blanks 
    ,cds_liab_acct_num char(4000) nullif cds_liab_acct_num=blanks 
    ,corp_supv_acct_flg char(4000) nullif corp_supv_acct_flg=blanks 
    ,y_avg_bal char(4000) nullif y_avg_bal=blanks 
    ,q_avg_bal char(4000) nullif q_avg_bal=blanks 
    ,m_avg_bal char(4000) nullif m_avg_bal=blanks 
    ,cl_curr_y_avg_bal char(4000) nullif cl_curr_y_avg_bal=blanks 
    ,cl_curr_q_avg_bal char(4000) nullif cl_curr_q_avg_bal=blanks 
    ,cl_curr_m_avg_bal char(4000) nullif cl_curr_m_avg_bal=blanks 
    ,web_dep_flg char(4000) nullif web_dep_flg=blanks 
    ,bill_pool_margin_flg char(4000) nullif bill_pool_margin_flg=blanks 
    ,bill_pool_type_cd char(4000) nullif bill_pool_type_cd=blanks 
    ,old_acct_id char(4000) nullif old_acct_id=blanks 
    ,int_paybl_subj_id char(4000) nullif int_paybl_subj_id=blanks 
    ,int_paybl_adj_subj_id char(4000) nullif int_paybl_adj_subj_id=blanks 
    ,int_expns_subj_id char(4000) nullif int_expns_subj_id=blanks 
    ,int_expns_adj_subj_id char(4000) nullif int_expns_adj_subj_id=blanks 
    ,open_flow_num char(4000) nullif open_flow_num=blanks 
    ,clos_flow_num char(4000) nullif clos_flow_num=blanks 
    ,currt_int_paybl_adj char(4000) nullif currt_int_paybl_adj=blanks 
    ,td_int_expns char(4000) nullif td_int_expns=blanks 
    ,td_int_expns_adj char(4000) nullif td_int_expns_adj=blanks 
    ,long_hang_acct_flg char(4000) nullif long_hang_acct_flg=blanks 
    ,acct_usage_cd char(4000) nullif acct_usage_cd=blanks 
    ,agt_dep_earliest_drawbl_dt date "yyyy-mm-dd hh24:mi:ss" nullif agt_dep_earliest_drawbl_dt=blanks 
    ,lowt_bal char(4000) nullif lowt_bal=blanks 
    ,cash_flg char(4000) nullif cash_flg=blanks 
    ,cust_acct_card_no char(4000) nullif cust_acct_card_no=blanks 
    ,dep_char_cd char(4000) nullif dep_char_cd=blanks 
    ,agree_dep_rels_dt date "yyyy-mm-dd hh24:mi:ss" nullif agree_dep_rels_dt=blanks 
    ,mater_acct_flg char(4000) nullif mater_acct_flg=blanks 
    ,delay_pay_int_flg char(4000) nullif delay_pay_int_flg=blanks 
    ,delay_pay_int_days char(4000) nullif delay_pay_int_days=blanks 
    ,old_cust_acct_sub_acct_num char(4000) nullif old_cust_acct_sub_acct_num=blanks 
    ,dep_term_tenor_type_cd char(4000) nullif dep_term_tenor_type_cd=blanks 
    ,pd_id char(4000) nullif pd_id=blanks 
    ,approval_id char(4000) nullif approval_id=blanks 
    ,general_exch_org_id char(4000) nullif general_exch_org_id=blanks 
    ,general_storage_flg char(4000) nullif general_storage_flg=blanks 
    ,vtual_acct_flg char(4000) nullif vtual_acct_flg=blanks 
    ,entry_flg char(4000) nullif entry_flg=blanks 
    ,turn_dormt_acct_dt date "yyyy-mm-dd hh24:mi:ss" nullif turn_dormt_acct_dt=blanks 
    ,main_acct_id char(4000) nullif main_acct_id=blanks 
    ,card_no char(4000) nullif card_no=blanks 
)