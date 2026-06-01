: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_e_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_e_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
    to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.acct_id,chr(13),''),chr(10),'') as acct_id
    ,replace(replace(t.acct_name,chr(13),''),chr(10),'') as acct_name
    ,replace(replace(t.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
    ,replace(replace(t.cust_sub_acct_num,chr(13),''),chr(10),'') as cust_sub_acct_num
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.subj_id,chr(13),''),chr(10),'') as subj_id
    ,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
    ,replace(replace(t.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
    ,replace(replace(t.dep_term,chr(13),''),chr(10),'') as dep_term
    ,replace(replace(t.dep_kind_cd,chr(13),''),chr(10),'') as dep_kind_cd
    ,replace(replace(t.acct_cls_cd,chr(13),''),chr(10),'') as acct_cls_cd
    ,replace(replace(t.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
    ,replace(replace(t.e_acct_type_cd,chr(13),''),chr(10),'') as e_acct_type_cd
    ,replace(replace(t.dep_acct_status_cd,chr(13),''),chr(10),'') as dep_acct_status_cd
    ,replace(replace(t.corp_acct_flg,chr(13),''),chr(10),'') as corp_acct_flg
    ,replace(replace(t.rc_flg,chr(13),''),chr(10),'') as rc_flg
    ,replace(replace(t.web_dep_flg,chr(13),''),chr(10),'') as web_dep_flg
    ,replace(replace(t.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg
    ,replace(replace(t.margin_flg,chr(13),''),chr(10),'') as margin_flg
    ,replace(replace(t.advise_dep_flg,chr(13),''),chr(10),'') as advise_dep_flg
    ,replace(replace(t.ec_flg,chr(13),''),chr(10),'') as ec_flg
    ,replace(replace(t.privavy_acct_flg,chr(13),''),chr(10),'') as privavy_acct_flg
    ,replace(replace(t.legal_acct_flg,chr(13),''),chr(10),'') as legal_acct_flg
    ,replace(replace(t.sleep_acct_flg,chr(13),''),chr(10),'') as sleep_acct_flg
    ,replace(replace(t.froz_flg,chr(13),''),chr(10),'') as froz_flg
    ,replace(replace(t.bind_acct_flg,chr(13),''),chr(10),'') as bind_acct_flg
    ,replace(replace(t.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
    ,replace(replace(t.auto_redt_flg,chr(13),''),chr(10),'') as auto_redt_flg
    ,replace(replace(t.redt_way_cd,chr(13),''),chr(10),'') as redt_way_cd
    ,replace(replace(t.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
    ,replace(replace(t.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd
    ,replace(replace(t.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,replace(replace(t.open_acct_chn_type_cd,chr(13),''),chr(10),'') as open_acct_chn_type_cd
    ,replace(replace(t.tran_chn_status_cd,chr(13),''),chr(10),'') as tran_chn_status_cd
    ,t.open_acct_dt as open_acct_dt
    ,t.open_acct_tm as open_acct_tm
    ,t.clos_acct_dt as clos_acct_dt
    ,t.clos_acct_tm as clos_acct_tm
    ,t.actv_dt as actv_dt
    ,t.value_dt as value_dt
    ,t.exp_dt as exp_dt
    ,t.final_activ_acct_dt as final_activ_acct_dt
    ,t.froz_dt as froz_dt
    ,t.unfrz_dt as unfrz_dt
    ,t.last_int_set_dt as last_int_set_dt
    ,t.next_int_set_dt as next_int_set_dt
    ,t.fir_value_dt as fir_value_dt
    ,replace(replace(t.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
    ,t.base_rat as base_rat
    ,t.exec_int_rat as exec_int_rat
    ,t.td_acru_int as td_acru_int
    ,t.currt_acru_int as currt_acru_int
    ,replace(replace(t.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id
    ,replace(replace(t.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id
    ,replace(replace(t.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
    ,replace(replace(t.close_acct_org_id,chr(13),''),chr(10),'') as close_acct_org_id
    ,replace(replace(t.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
    ,replace(replace(t.camp_activ_id,chr(13),''),chr(10),'') as camp_activ_id
    ,replace(replace(t.referrer_type_cd,chr(13),''),chr(10),'') as referrer_type_cd
    ,replace(replace(t.referrer_num,chr(13),''),chr(10),'') as referrer_num
    ,replace(replace(t.vtual_acct_flg,chr(13),''),chr(10),'') as vtual_acct_flg
    ,replace(replace(t.mercht_id,chr(13),''),chr(10),'') as mercht_id
    ,t.currt_bal as currt_bal
    ,t.aval_bal as aval_bal
    ,t.froz_amt as froz_amt
    ,t.cl_curr_currt_bal as cl_curr_currt_bal
    ,t.ear_d_bal as ear_d_bal
    ,t.ear_m_bal as ear_m_bal
    ,t.ear_s_bal as ear_s_bal
    ,t.ear_y_bal as ear_y_bal
    ,t.y_acm_bal as y_acm_bal
    ,t.s_acm_bal as s_acm_bal
    ,t.m_acm_bal as m_acm_bal
    ,t.cl_curr_ear_d_bal as cl_curr_ear_d_bal
    ,t.cl_curr_ear_m_bal as cl_curr_ear_m_bal
    ,t.cl_curr_ear_s_bal as cl_curr_ear_s_bal
    ,t.cl_curr_ear_y_bal as cl_curr_ear_y_bal
    ,t.cl_curr_y_acm_bal as cl_curr_y_acm_bal
    ,t.cl_curr_ear_d_y_acm_bal as cl_curr_ear_d_y_acm_bal
    ,t.cl_curr_ear_m_y_acm_bal as cl_curr_ear_m_y_acm_bal
    ,t.cl_curr_ear_s_y_acm_bal as cl_curr_ear_s_y_acm_bal
    ,t.cl_curr_ear_y_y_acm_bal as cl_curr_ear_y_y_acm_bal
    ,t.cl_curr_s_acm_bal as cl_curr_s_acm_bal
    ,t.cl_curr_ear_d_s_acm_bal as cl_curr_ear_d_s_acm_bal
    ,t.cl_curr_ear_s_s_acm_bal as cl_curr_ear_s_s_acm_bal
    ,t.cl_curr_ear_y_s_acm_bal as cl_curr_ear_y_s_acm_bal
    ,t.cl_curr_m_acm_bal as cl_curr_m_acm_bal
    ,t.cl_curr_ear_d_m_acm_bal as cl_curr_ear_d_m_acm_bal
    ,t.cl_curr_ear_m_m_acm_bal as cl_curr_ear_m_m_acm_bal
    ,t.cl_curr_ear_y_m_acm_bal as cl_curr_ear_y_m_acm_bal
    ,replace(replace(t.entry_flg,chr(13),''),chr(10),'') as entry_flg
    ,t.y_avg_bal as y_avg_bal
    ,t.q_avg_bal as q_avg_bal
    ,t.m_avg_bal as m_avg_bal
    ,t.cl_curr_y_avg_bal as cl_curr_y_avg_bal
    ,t.cl_curr_q_avg_bal as cl_curr_q_avg_bal
    ,t.cl_curr_m_avg_bal as cl_curr_m_avg_bal
    ,replace(replace(t.liab_acct_id,chr(13),''),chr(10),'') as liab_acct_id
    ,t.open_amt as open_amt
    ,replace(replace(t.old_acct_id,chr(13),''),chr(10),'') as old_acct_id
    ,replace(replace(t.int_paybl_subj_id,chr(13),''),chr(10),'') as int_paybl_subj_id
    ,replace(replace(t.int_paybl_adj_subj_id,chr(13),''),chr(10),'') as int_paybl_adj_subj_id
    ,replace(replace(t.int_expns_subj_id,chr(13),''),chr(10),'') as int_expns_subj_id
    ,replace(replace(t.int_expns_adj_subj_id,chr(13),''),chr(10),'') as int_expns_adj_subj_id
    ,t.currt_int_paybl_adj as currt_int_paybl_adj
    ,t.td_int_expns as td_int_expns
    ,t.td_int_expns_adj as td_int_expns_adj
    ,replace(replace(t.intnal_acct_id,chr(13),''),chr(10),'') as intnal_acct_id
    ,replace(replace(t.e_acct_med_id,chr(13),''),chr(10),'') as e_acct_med_id
    ,replace(replace(t.e_acct_med_type_cd,chr(13),''),chr(10),'') as e_acct_med_type_cd
    ,replace(replace(t.bd_card_card_no,chr(13),''),chr(10),'') as bd_card_card_no
    ,replace(replace(t.bd_card_open_bank_id,chr(13),''),chr(10),'') as bd_card_open_bank_id
    ,replace(replace(t.bd_card_open_bank_name,chr(13),''),chr(10),'') as bd_card_open_bank_name
from icl.cmm_e_acct_info t
where t.etl_dt = to_date('${batch_date}','yyyymmdd') and t.entry_flg = '1' " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_e_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes