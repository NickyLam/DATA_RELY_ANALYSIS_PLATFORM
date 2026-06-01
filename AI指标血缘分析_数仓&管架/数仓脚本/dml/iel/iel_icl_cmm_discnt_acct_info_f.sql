: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_discnt_acct_info_f
CreateDate: 20221122
FileName:   ${iel_data_path}/cmm_discnt_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.out_acct_flow_num,chr(13),''),chr(10),'') as out_acct_flow_num
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.discnt_entry_acct_id,chr(13),''),chr(10),'') as discnt_entry_acct_id
,replace(replace(t1.int_adj_acct_id,chr(13),''),chr(10),'') as int_adj_acct_id
,replace(replace(t1.int_income_expns_acct_id,chr(13),''),chr(10),'') as int_income_expns_acct_id
,replace(replace(t1.pay_int_acct_id,chr(13),''),chr(10),'') as pay_int_acct_id
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.int_subj_id,chr(13),''),chr(10),'') as int_subj_id
,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t1.discnt_bus_kind_cd,chr(13),''),chr(10),'') as discnt_bus_kind_cd
,replace(replace(t1.bs_type_cd,chr(13),''),chr(10),'') as bs_type_cd
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.bs_way_cd,chr(13),''),chr(10),'') as bs_way_cd
,replace(replace(t1.clear_way_cd,chr(13),''),chr(10),'') as clear_way_cd
,replace(replace(t1.discnt_status_cd,chr(13),''),chr(10),'') as discnt_status_cd
,replace(replace(t1.int_adj_entry_cd,chr(13),''),chr(10),'') as int_adj_entry_cd
,replace(replace(t1.pay_int_way_cd,chr(13),''),chr(10),'') as pay_int_way_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.rgst_teller_id,chr(13),''),chr(10),'') as rgst_teller_id
,replace(replace(t1.discnt_org_id,chr(13),''),chr(10),'') as discnt_org_id
,replace(replace(t1.draw_org_id,chr(13),''),chr(10),'') as draw_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,discnt_value_dt
,discnt_exp_dt
,draw_dt
,discnt_dt
,replace(replace(t1.discnt_flow_num,chr(13),''),chr(10),'') as discnt_flow_num
,close_dt
,termnt_dt
,replace(replace(t1.close_flow_num,chr(13),''),chr(10),'') as close_flow_num
,last_int_adj_day
,next_int_adj_day
,int_accr_days
,pay_int_amt
,int_recvbl
,int_adj_bal
,wrt_off_amt
,fac_val_amt
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
,cl_curr_ear_y_m_acm_bal
,y_avg_bal
,q_avg_bal
,m_avg_bal
,cl_curr_y_avg_bal
,cl_curr_q_avg_bal
,cl_curr_m_avg_bal

from ${icl_schema}.cmm_discnt_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_discnt_acct_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
