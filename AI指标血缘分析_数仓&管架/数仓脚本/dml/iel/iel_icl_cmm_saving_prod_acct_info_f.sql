: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_saving_prod_acct_info_f
CreateDate: 20221122
FileName:   ${iel_data_path}/cmm_saving_prod_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.prod_acct_id,chr(13),''),chr(10),'') as prod_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.dep_term,chr(13),''),chr(10),'') as dep_term
,replace(replace(t1.dep_kind_cd,chr(13),''),chr(10),'') as dep_kind_cd
,replace(replace(t1.acct_cls_cd,chr(13),''),chr(10),'') as acct_cls_cd
,replace(replace(t1.acct_type_cd,chr(13),''),chr(10),'') as acct_type_cd
,replace(replace(t1.dep_acct_status_cd,chr(13),''),chr(10),'') as dep_acct_status_cd
,replace(replace(t1.stop_pay_status_cd,chr(13),''),chr(10),'') as stop_pay_status_cd
,replace(replace(t1.rc_flg,chr(13),''),chr(10),'') as rc_flg
,replace(replace(t1.general_exch_flg,chr(13),''),chr(10),'') as general_exch_flg
,replace(replace(t1.advise_dep_flg,chr(13),''),chr(10),'') as advise_dep_flg
,replace(replace(t1.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t1.sleep_acct_flg,chr(13),''),chr(10),'') as sleep_acct_flg
,replace(replace(t1.froz_flg,chr(13),''),chr(10),'') as froz_flg
,replace(replace(t1.int_accr_flg,chr(13),''),chr(10),'') as int_accr_flg
,replace(replace(t1.auto_redt_flg,chr(13),''),chr(10),'') as auto_redt_flg
,replace(replace(t1.redt_way_cd,chr(13),''),chr(10),'') as redt_way_cd
,replace(replace(t1.int_accr_base_cd,chr(13),''),chr(10),'') as int_accr_base_cd
,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd
,replace(replace(t1.int_accr_way_cd,chr(13),''),chr(10),'') as int_accr_way_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,open_acct_dt
,open_acct_tm
,clos_acct_dt
,value_dt
,exp_dt
,final_activ_acct_dt
,froz_dt
,unfrz_dt
,replace(replace(t1.base_rat_type_cd,chr(13),''),chr(10),'') as base_rat_type_cd
,base_rat
,exec_int_rat
,td_acru_int
,currt_acru_int
,replace(replace(t1.open_acct_teller_id,chr(13),''),chr(10),'') as open_acct_teller_id
,replace(replace(t1.clos_acct_teller_id,chr(13),''),chr(10),'') as clos_acct_teller_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.close_acct_org_id,chr(13),''),chr(10),'') as close_acct_org_id
,currt_bal
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
,y_avg_bal
,q_avg_bal
,m_avg_bal
,cl_curr_y_avg_bal
,cl_curr_q_avg_bal
,cl_curr_m_avg_bal

from ${icl_schema}.cmm_saving_prod_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_saving_prod_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
