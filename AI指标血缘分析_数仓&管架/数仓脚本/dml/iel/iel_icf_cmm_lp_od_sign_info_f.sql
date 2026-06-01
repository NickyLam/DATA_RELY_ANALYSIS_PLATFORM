: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_lp_od_sign_info_f
CreateDate: 20230316
FileName:   ${iel_data_path}/cmm_lp_od_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.crdt_appl_id,chr(13),''),chr(10),'') as crdt_appl_id
,replace(replace(t1.dubil_id,chr(13),''),chr(10),'') as dubil_id
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.od_acct_id,chr(13),''),chr(10),'') as od_acct_id
,replace(replace(t1.od_sub_acct_id,chr(13),''),chr(10),'') as od_sub_acct_id
,replace(replace(t1.old_od_sub_acct_id,chr(13),''),chr(10),'') as old_od_sub_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.loan_org_id,chr(13),''),chr(10),'') as loan_org_id
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.sign_flow_num,chr(13),''),chr(10),'') as sign_flow_num
,replace(replace(t1.int_rat_reval_cd,chr(13),''),chr(10),'') as int_rat_reval_cd
,replace(replace(t1.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd
,replace(replace(t1.crdt_status_cd,chr(13),''),chr(10),'') as crdt_status_cd
,replace(replace(t1.od_serv_status_cd,chr(13),''),chr(10),'') as od_serv_status_cd
,replace(replace(t1.lp_od_type_cd,chr(13),''),chr(10),'') as lp_od_type_cd
,replace(replace(t1.tenor,chr(13),''),chr(10),'') as tenor
,replace(replace(t1.tenor_type_cd,chr(13),''),chr(10),'') as tenor_type_cd
,replace(replace(t1.base_rat_cd,chr(13),''),chr(10),'') as base_rat_cd
,sign_dt
,lmt_start_dt
,lmt_exp_dt
,sig_od_valid_days
,od_lmt_uplmi
,start_od_amt
,od_promis_fee
,od_lmt
,used_od_lmt
,surp_od_lmt
,nomal_int_rat_fl_rt
,ovdue_int_rat_fl_rt
,nomal_loan_int_rat
,ovdue_loan_int_rat

from ${icl_schema}.cmm_lp_od_sign_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_lp_od_sign_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
