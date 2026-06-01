: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_lp_od_sign_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/agt_lp_od_sign_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date(${batch_date},'yyyymmdd') as etl_dt
,replace(replace(t.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.crdt_cont_id,chr(13),''),chr(10),'') as crdt_cont_id
,replace(replace(t.od_acct_id,chr(13),''),chr(10),'') as od_acct_id
,replace(replace(t.od_sub_acct_id,chr(13),''),chr(10),'') as od_sub_acct_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.loan_org_id,chr(13),''),chr(10),'') as loan_org_id
,t.od_lmt_uplmi as od_lmt_uplmi
,t.od_lmt as od_lmt
,t.used_od_lmt as used_od_lmt
,t.surp_od_lmt as surp_od_lmt
,t.sig_od_valid_days as sig_od_valid_days
,replace(replace(t.tenor_cd,chr(13),''),chr(10),'') as tenor_cd
,replace(replace(t.base_rat_cd,chr(13),''),chr(10),'') as base_rat_cd
,t.nomal_int_rat_fl_rt as nomal_int_rat_fl_rt
,t.ovdue_int_rat_fl_rt as ovdue_int_rat_fl_rt
,t.nomal_loan_int_rat as nomal_loan_int_rat
,t.ovdue_loan_int_rat as ovdue_loan_int_rat
,replace(replace(t.int_rat_reval_cd,chr(13),''),chr(10),'') as int_rat_reval_cd
,replace(replace(t.int_set_way_cd,chr(13),''),chr(10),'') as int_set_way_cd
,t.lmt_start_dt as lmt_start_dt
,t.lmt_exp_dt as lmt_exp_dt
,t.od_promis_fee as od_promis_fee
,t.start_od_amt as start_od_amt
,replace(replace(t.crdt_status_cd,chr(13),''),chr(10),'') as crdt_status_cd
,replace(replace(t.od_serv_status_cd,chr(13),''),chr(10),'') as od_serv_status_cd
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,t.sign_dt as sign_dt
,replace(replace(t.sign_flow_num,chr(13),''),chr(10),'') as sign_flow_num
,replace(replace(t.lp_od_type_cd,chr(13),''),chr(10),'') as lp_od_type_cd
,t.create_dt as create_dt
,t.update_dt as update_dt
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark
 from iml.agt_lp_od_sign_info t 
 where t.etl_dt = to_date(${batch_date},'yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_lp_od_sign_info.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes