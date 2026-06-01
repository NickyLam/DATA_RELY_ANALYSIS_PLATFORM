: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_dep_acct_info_a
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_dep_acct_info.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.etl_dt as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id 
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name 
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id 
,replace(replace(t1.cust_acct_sub_acct_num,chr(13),''),chr(10),'') as cust_acct_sub_acct_num 
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id 
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id 
,replace(replace(t1.dep_kind_cd,chr(13),''),chr(10),'') as dep_kind_cd 
,replace(replace(t1.acct_cls_cd,chr(13),''),chr(10),'') as acct_cls_cd 
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd 
,replace(replace(t1.acct_attr_cd,chr(13),''),chr(10),'') as acct_attr_cd 
,replace(replace(t1.dep_term,chr(13),''),chr(10),'') as dep_term 
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id 
,replace(replace(t1.ext_prod_id,chr(13),''),chr(10),'') as ext_prod_id 
,replace(replace(t1.intnal_prod_id,chr(13),''),chr(10),'') as intnal_prod_id 
,replace(replace(t1.open_oa_apv_form_num,chr(13),''),chr(10),'') as open_oa_apv_form_num 
,replace(replace(t1.dep_acct_status_cd,chr(13),''),chr(10),'') as dep_acct_status_cd 
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd 
,replace(replace(t1.corp_acct_flg,chr(13),''),chr(10),'') as corp_acct_flg 
,replace(replace(t1.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd 
,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg 
,replace(replace(t1.advise_dep_flg,chr(13),''),chr(10),'') as advise_dep_flg 
,replace(replace(t1.agt_dep_flg,chr(13),''),chr(10),'') as agt_dep_flg 
,replace(replace(t1.float_int_rat_flg,chr(13),''),chr(10),'') as float_int_rat_flg 
,replace(replace(t1.int_rat_float_way_cd,chr(13),''),chr(10),'') as int_rat_float_way_cd 
,replace(replace(t1.int_rat_adj_ped_corp_cd,chr(13),''),chr(10),'') as int_rat_adj_ped_corp_cd 
,t1.int_rat_adj_ped_freq as int_rat_adj_ped_freq 
,replace(replace(t1.rc_flg,chr(13),''),chr(10),'') as rc_flg 
,replace(replace(t1.margin_flg,chr(13),''),chr(10),'') as margin_flg 
,replace(replace(t1.agree_dep_flg,chr(13),''),chr(10),'') as agree_dep_flg 
,replace(replace(t1.ibank_dep_flg,chr(13),''),chr(10),'') as ibank_dep_flg 
,replace(replace(t1.dep_basic_acct_flg,chr(13),''),chr(10),'') as dep_basic_acct_flg 
,replace(replace(t1.ec_flg,chr(13),''),chr(10),'') as ec_flg 
,replace(replace(t1.privavy_acct_flg,chr(13),''),chr(10),'') as privavy_acct_flg 
,replace(replace(t1.legal_acct_flg,chr(13),''),chr(10),'') as legal_acct_flg 
,replace(replace(t1.auto_redt_flg,chr(13),''),chr(10),'') as auto_redt_flg 
,replace(replace(t1.redted_cnt,chr(13),''),chr(10),'') as redted_cnt 
,t1.itg_dep_earliest_drawbl_dt as itg_dep_earliest_drawbl_dt 
,replace(replace(t1.sleep_acct_flg,chr(13),''),chr(10),'') as sleep_acct_flg 
,replace(replace(t1.dormt_acct_flg,chr(13),''),chr(10),'') as dormt_acct_flg 
,replace(replace(t1.sal_acct_flg,chr(13),''),chr(10),'') as sal_acct_flg 
,replace(replace(t1.froz_flg,chr(13),''),chr(10),'') as froz_flg 
,replace(replace(t1.advd_draw_flg,chr(13),''),chr(10),'') as advd_draw_flg 
,replace(replace(t1.tranbl_flg,chr(13),''),chr(10),'') as tranbl_flg 
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd 
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg 
,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd 
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd 
,replace(replace(t1.allow_od_flg,chr(13),''),chr(10),'') as allow_od_flg 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.redt_way_cd,chr(13),''),chr(10),'') as redt_way_cd 
,replace(replace(t1.open_acct_chn_type_cd,chr(13),''),chr(10),'') as open_acct_chn_type_cd 
,replace(replace(t1.tran_chn_status_cd,chr(13),''),chr(10),'') as tran_chn_status_cd 
,t1.open_acct_dt as open_acct_dt 
,t1.open_acct_tm as open_acct_tm 
,t1.clos_acct_dt as clos_acct_dt 
,t1.clos_acct_tm as clos_acct_tm 
,t1.actv_dt as actv_dt 
,t1.value_dt as value_dt 
,t1.exp_dt as exp_dt 
,t1.final_activ_acct_dt as final_activ_acct_dt 
,t1.agree_dep_value_dt as agree_dep_value_dt 
,t1.agree_dep_exp_dt as agree_dep_exp_dt 
,t1.froz_dt as froz_dt 
,t1.unfrz_dt as unfrz_dt 
,t1.last_int_set_dt as last_int_set_dt 
,t1.next_int_set_dt as next_int_set_dt 
,t1.fir_value_dt as fir_value_dt 
,t1.agree_int_rat as agree_int_rat 
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd 
,t1.base_rat as base_rat 
,t1.exec_int_rat as exec_int_rat 
,t1.td_acru_int as td_acru_int 
,t1.currt_acru_int as currt_acru_int 
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id 
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id 
,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id 
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id 
,replace(replace(t1.close_acct_org_id,chr(13),''),chr(10),'') as close_acct_org_id 
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id 
,replace(replace(t1.loc_flg,chr(13),''),chr(10),'') as loc_flg 
,t1.expe_higt_yld_rat as expe_higt_yld_rat 
,t1.agree_dep_init_amt as agree_dep_init_amt 
,t1.open_acct_amt as open_acct_amt 
,t1.currt_bal as currt_bal 
,t1.aval_bal as aval_bal 
,t1.froz_amt as froz_amt 
,t1.stop_pay_amt as stop_pay_amt 
,t1.cl_curr_currt_bal as cl_curr_currt_bal 
,t1.ear_d_bal as ear_d_bal 
,t1.ear_m_bal as ear_m_bal 
,t1.ear_s_bal as ear_s_bal 
,t1.ear_y_bal as ear_y_bal 
,t1.y_acm_bal as y_acm_bal 
,t1.s_acm_bal as s_acm_bal 
,t1.m_acm_bal as m_acm_bal 
,t1.cl_curr_ear_d_bal as cl_curr_ear_d_bal 
,t1.cl_curr_ear_m_bal as cl_curr_ear_m_bal 
,t1.cl_curr_ear_s_bal as cl_curr_ear_s_bal 
,t1.cl_curr_ear_y_bal as cl_curr_ear_y_bal 
,t1.cl_curr_y_acm_bal as cl_curr_y_acm_bal 
,t1.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal 
,t1.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal 
,t1.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal 
,t1.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal 
,t1.cl_curr_s_acm_bal as cl_curr_s_acm_bal 
,t1.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal 
,t1.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal 
,t1.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal 
,t1.cl_curr_m_acm_bal as cl_curr_m_acm_bal 
,t1.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal 
,t1.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal 
,t1.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal 
,replace(replace(t1.cds_liab_acct_num,chr(13),''),chr(10),'') as cds_liab_acct_num 
,replace(replace(t1.corp_supv_acct_flg,chr(13),''),chr(10),'') as corp_supv_acct_flg 
,t1.y_avg_bal as y_avg_bal 
,t1.q_avg_bal as q_avg_bal 
,t1.m_avg_bal as m_avg_bal 
,t1.cl_curr_y_avg_bal as cl_curr_y_avg_bal 
,t1.cl_curr_q_avg_bal as cl_curr_q_avg_bal 
,t1.cl_curr_m_avg_bal as cl_curr_m_avg_bal 
,replace(replace(t1.web_dep_flg,chr(13),''),chr(10),'') as web_dep_flg 
,replace(replace(t1.bill_pool_margin_flg,chr(13),''),chr(10),'') as bill_pool_margin_flg 
,replace(replace(t1.bill_pool_type_cd,chr(13),''),chr(10),'') as bill_pool_type_cd 
from icl.cmm_dep_acct_info t1 
where t1.etl_dt >= to_date('20201201','yyyymmdd') and t1.etl_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_acct_info.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes