: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_ba_acct_info_f
CreateDate: 20241018
FileName:   ${iel_data_path}/cmm_ba_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num
,replace(replace(t1.acpt_org_id,chr(13),''),chr(10),'') as acpt_org_id
,replace(replace(t1.stl_acct_num,chr(13),''),chr(10),'') as stl_acct_num
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd
,replace(replace(t1.margin_acct_num,chr(13),''),chr(10),'') as margin_acct_num
,replace(replace(t1.margin_dep_term,chr(13),''),chr(10),'') as margin_dep_term
,draw_dt
,close_dt
,replace(replace(t1.close_flow,chr(13),''),chr(10),'') as close_flow
,exp_dt
,replace(replace(t1.bill_status,chr(13),''),chr(10),'') as bill_status
,replace(replace(t1.close_way,chr(13),''),chr(10),'') as close_way
,replace(replace(t1.pymc_acct_num,chr(13),''),chr(10),'') as pymc_acct_num
,pymc_dt
,replace(replace(t1.pymc_flow,chr(13),''),chr(10),'') as pymc_flow
,replace(replace(t1.pymc_way,chr(13),''),chr(10),'') as pymc_way
,replace(replace(t1.advc_flg,chr(13),''),chr(10),'') as advc_flg
,replace(replace(t1.advc_dubil_id,chr(13),''),chr(10),'') as advc_dubil_id
,advc_exec_int_rat
,advc_int_rat_cu_ratio
,replace(replace(t1.int_rat_base_type_cd,chr(13),''),chr(10),'') as int_rat_base_type_cd
,replace(replace(t1.fac_val_curr,chr(13),''),chr(10),'') as fac_val_curr
,replace(replace(t1.margin_curr,chr(13),''),chr(10),'') as margin_curr
,margin_ratio
,margin_amt
,advc_amt
,comm_fee
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
,replace(replace(t1.bill_entry_id,chr(13),''),chr(10),'') as bill_entry_id
,replace(replace(t1.acpt_dubil_id,chr(13),''),chr(10),'') as acpt_dubil_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.open_type_cd,chr(13),''),chr(10),'') as open_type_cd
,open_amt

from ${icl_schema}.cmm_ba_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_ba_acct_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
