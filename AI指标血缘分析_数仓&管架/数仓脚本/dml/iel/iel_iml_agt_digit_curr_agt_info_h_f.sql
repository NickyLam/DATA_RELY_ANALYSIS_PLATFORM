: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_digit_curr_agt_info_h_f
CreateDate: 20240307
FileName:   ${iel_data_path}/agt_digit_curr_agt_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.midgrod_flow_num,chr(13),''),chr(10),'') as midgrod_flow_num
,midgrod_tran_dt
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.src_agt_id,chr(13),''),chr(10),'') as src_agt_id
,replace(replace(t1.sign_status_cd,chr(13),''),chr(10),'') as sign_status_cd
,agt_effect_dt
,agt_invalid_dt
,replace(replace(t1.sign_acct_id,chr(13),''),chr(10),'') as sign_acct_id
,replace(replace(t1.sign_acct_name,chr(13),''),chr(10),'') as sign_acct_name
,replace(replace(t1.sign_acct_type_cd,chr(13),''),chr(10),'') as sign_acct_type_cd
,replace(replace(t1.sign_cert_type_cd,chr(13),''),chr(10),'') as sign_cert_type_cd
,replace(replace(t1.sign_cert_no,chr(13),''),chr(10),'') as sign_cert_no
,sign_cert_invalid_dt
,replace(replace(t1.sign_belong_org_id,chr(13),''),chr(10),'') as sign_belong_org_id
,replace(replace(t1.sign_belong_org_name,chr(13),''),chr(10),'') as sign_belong_org_name
,sign_dt
,replace(replace(t1.sign_termn_cd,chr(13),''),chr(10),'') as sign_termn_cd
,replace(replace(t1.sign_teller_id,chr(13),''),chr(10),'') as sign_teller_id
,replace(replace(t1.rsrv_mobile_no,chr(13),''),chr(10),'') as rsrv_mobile_no
,replace(replace(t1.pkg_open_belong_org_id,chr(13),''),chr(10),'') as pkg_open_belong_org_id
,replace(replace(t1.pkg_open_belong_org_name,chr(13),''),chr(10),'') as pkg_open_belong_org_name
,replace(replace(t1.pkg_id,chr(13),''),chr(10),'') as pkg_id
,replace(replace(t1.pkg_type_cd,chr(13),''),chr(10),'') as pkg_type_cd
,replace(replace(t1.pkg_level_cd,chr(13),''),chr(10),'') as pkg_level_cd
,replace(replace(t1.rels_flow_num,chr(13),''),chr(10),'') as rels_flow_num
,rels_dt
,replace(replace(t1.rels_teller_id,chr(13),''),chr(10),'') as rels_teller_id
,replace(replace(t1.aldy_change_card_flg,chr(13),''),chr(10),'') as aldy_change_card_flg
,replace(replace(t1.new_card_acct_id,chr(13),''),chr(10),'') as new_card_acct_id
,change_card_tm
,replace(replace(t1.init_init_org_id,chr(13),''),chr(10),'') as init_init_org_id
,replace(replace(t1.corp_name,chr(13),''),chr(10),'') as corp_name
,replace(replace(t1.corp_princ_name,chr(13),''),chr(10),'') as corp_princ_name
,replace(replace(t1.corp_princ_cert_type_cd,chr(13),''),chr(10),'') as corp_princ_cert_type_cd
,replace(replace(t1.corp_princ_cert_no,chr(13),''),chr(10),'') as corp_princ_cert_no
,sig_acpt_bus_amt_uplmi
,d_acm_acpt_bus_upcnt
,d_acm_acpt_bus_uplmi
,y_acm_acpt_bus_upcnt
,y_acm_acpt_bus_uplmi
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,replace(replace(t1.msg_id,chr(13),''),chr(10),'') as msg_id

from ${iml_schema}.agt_digit_curr_agt_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_digit_curr_agt_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
