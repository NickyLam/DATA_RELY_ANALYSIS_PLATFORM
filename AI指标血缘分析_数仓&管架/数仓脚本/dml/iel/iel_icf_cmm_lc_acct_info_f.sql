: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_lc_acct_info_f
CreateDate: 20241106
FileName:   ${iel_data_path}/cmm_lc_acct_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.lc_id,chr(13),''),chr(10),'') as lc_id
,replace(replace(t1.issue_bank_lc_id,chr(13),''),chr(10),'') as issue_bank_lc_id
,replace(replace(t1.dubil_num,chr(13),''),chr(10),'') as dubil_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.stl_acct_num,chr(13),''),chr(10),'') as stl_acct_num
,replace(replace(t1.subj_id,chr(13),''),chr(10),'') as subj_id
,replace(replace(t1.fwd_flg,chr(13),''),chr(10),'') as fwd_flg
,replace(replace(t1.circl_flg,chr(13),''),chr(10),'') as circl_flg
,replace(replace(t1.mx_lc_flg,chr(13),''),chr(10),'') as mx_lc_flg
,replace(replace(t1.lc_type_cd,chr(13),''),chr(10),'') as lc_type_cd
,replace(replace(t1.lc_pay_type_cd,chr(13),''),chr(10),'') as lc_pay_type_cd
,replace(replace(t1.issue_chn_cd,chr(13),''),chr(10),'') as issue_chn_cd
,replace(replace(t1.bus_breed_id,chr(13),''),chr(10),'') as bus_breed_id
,replace(replace(t1.lc_status_cd,chr(13),''),chr(10),'') as lc_status_cd
,replace(replace(t1.issue_bank_cfm_status_cd,chr(13),''),chr(10),'') as issue_bank_cfm_status_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.sign_org_id,chr(13),''),chr(10),'') as sign_org_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.oper_org_id,chr(13),''),chr(10),'') as oper_org_id
,effect_dt
,wrtoff_dt
,issue_dt
,exp_dt
,cfm_dt
,replace(replace(t1.issue_bank_name,chr(13),''),chr(10),'') as issue_bank_name
,replace(replace(t1.advise_bank_name,chr(13),''),chr(10),'') as advise_bank_name
,replace(replace(t1.applit_name,chr(13),''),chr(10),'') as applit_name
,replace(replace(t1.benefc_name,chr(13),''),chr(10),'') as benefc_name
,replace(replace(t1.benefc_cty_cd,chr(13),''),chr(10),'') as benefc_cty_cd
,replace(replace(t1.cargo_descb,chr(13),''),chr(10),'') as cargo_descb
,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
,fwd_tenor
,comm_fee_rat
,comm_fee_amt
,lc_higt_lmt
,issue_amt
,acpty_bal
,lc_bal
,cl_curr_lc_bal
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
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.issue_bank_cn_name,chr(13),''),chr(10),'') as issue_bank_cn_name
,replace(replace(t1.issue_bank_swiftcode,chr(13),''),chr(10),'') as issue_bank_swiftcode
,acpty_tot
,replace(replace(t1.issue_bank_bic,chr(13),''),chr(10),'') as issue_bank_bic
,replace(replace(t1.advise_bank_bic,chr(13),''),chr(10),'') as advise_bank_bic
,replace(replace(t1.open_bk_bic,chr(13),''),chr(10),'') as open_bk_bic
,replace(replace(t1.cfm_bank_bic,chr(13),''),chr(10),'') as cfm_bank_bic
,replace(replace(t1.recv_bank_bic,chr(13),''),chr(10),'') as recv_bank_bic
,replace(replace(t1.pay_bank_bic,chr(13),''),chr(10),'') as pay_bank_bic
,tran_cmplt_tm
,usd_tran_amt
,replace(replace(t1.elec_lc_flg,chr(13),''),chr(10),'') as elec_lc_flg
,replace(replace(t1.cpty_cust_id,chr(13),''),chr(10),'') as cpty_cust_id

from ${icl_schema}.cmm_lc_acct_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_lc_acct_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
