: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_ifs_acct_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_ifs_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_acct_sub_acct_num,chr(13),''),chr(10),'') as cust_acct_sub_acct_num
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.bind_webank_card_no,chr(13),''),chr(10),'') as bind_webank_card_no
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.ext_prod_id,chr(13),''),chr(10),'') as ext_prod_id
,replace(replace(t1.dep_acct_status_cd,chr(13),''),chr(10),'') as dep_acct_status_cd
,replace(replace(t1.acpt_pay_status_cd,chr(13),''),chr(10),'') as acpt_pay_status_cd
,replace(replace(t1.froz_status_cd,chr(13),''),chr(10),'') as froz_status_cd
,replace(replace(t1.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd
,replace(replace(t1.dep_term,chr(13),''),chr(10),'') as dep_term
,replace(replace(t1.sav_type_cd,chr(13),''),chr(10),'') as sav_type_cd
,replace(replace(t1.exec_int_rat_cate_cd,chr(13),''),chr(10),'') as exec_int_rat_cate_cd
,replace(replace(t1.pa_ext_int_rat_cate_cd,chr(13),''),chr(10),'') as pa_ext_int_rat_cate_cd
,replace(replace(t1.ovdue_int_rat_cate_cd,chr(13),''),chr(10),'') as ovdue_int_rat_cate_cd
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.corp_acct_flg,chr(13),''),chr(10),'') as corp_acct_flg
,replace(replace(t1.rc_flg,chr(13),''),chr(10),'') as rc_flg
,replace(replace(t1.web_dep_flg,chr(13),''),chr(10),'') as web_dep_flg
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,t1.part_draw_cnt as part_draw_cnt
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id
,replace(replace(t1.open_acct_flow_num,chr(13),''),chr(10),'') as open_acct_flow_num
,replace(replace(t1.open_acct_chn_cd,chr(13),''),chr(10),'') as open_acct_chn_cd
,t1.open_acct_dt as open_acct_dt
,t1.open_acct_tm as open_acct_tm
,replace(replace(t1.close_acct_org_id,chr(13),''),chr(10),'') as close_acct_org_id
,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id
,replace(replace(t1.clos_acct_flow_num,chr(13),''),chr(10),'') as clos_acct_flow_num
,t1.clos_acct_dt as clos_acct_dt
,t1.clos_acct_tm as clos_acct_tm
,t1.acct_dt as acct_dt
,t1.value_dt as value_dt
,t1.exp_dt as exp_dt
,t1.final_activ_acct_dt as final_activ_acct_dt
,t1.last_int_set_dt as last_int_set_dt
,t1.next_int_set_dt as next_int_set_dt
,t1.fir_value_dt as fir_value_dt
,t1.base_rat as base_rat
,t1.exec_int_rat as exec_int_rat
,t1.int_rat_flo_val as int_rat_flo_val
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.td_acru_int as td_acru_int
,t1.currt_acru_int as currt_acru_int
,t1.currt_bal as currt_bal
,t1.froz_amt as froz_amt
,t1.aval_bal as aval_bal
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
,t1.y_avg_bal as y_avg_bal
,t1.q_avg_bal as q_avg_bal
,t1.m_avg_bal as m_avg_bal
,t1.cl_curr_y_avg_bal as cl_curr_y_avg_bal
,t1.cl_curr_q_avg_bal as cl_curr_q_avg_bal
,t1.cl_curr_m_avg_bal as cl_curr_m_avg_bal
from ${icl_schema}.cmm_ifs_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ifs_acct_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes