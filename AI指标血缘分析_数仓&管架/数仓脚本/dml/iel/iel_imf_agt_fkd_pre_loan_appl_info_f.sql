: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_agt_fkd_pre_loan_appl_info_f
CreateDate: 20230525
FileName:   ${iel_data_path}/agt_fkd_pre_loan_appl_info.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.open_acct_sucs_flg,chr(13),''),chr(10),'') as open_acct_sucs_flg
,replace(replace(t1.netw_vrfction_status_flg,chr(13),''),chr(10),'') as netw_vrfction_status_flg
,replace(replace(t1.belong_org_id,chr(13),''),chr(10),'') as belong_org_id
,replace(replace(t1.belong_brch_id,chr(13),''),chr(10),'') as belong_brch_id
,replace(replace(t1.access_chn_id,chr(13),''),chr(10),'') as access_chn_id
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.crdt_appl_flow_num,chr(13),''),chr(10),'') as crdt_appl_flow_num
,replace(replace(t1.main_debit_ps_cert_type_cd,chr(13),''),chr(10),'') as main_debit_ps_cert_type_cd
,replace(replace(t1.main_debit_ps_cert_id,chr(13),''),chr(10),'') as main_debit_ps_cert_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.loan_usage_cd,chr(13),''),chr(10),'') as loan_usage_cd
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,crdt_amt
,replace(replace(t1.partner_cust_mgr_id,chr(13),''),chr(10),'') as partner_cust_mgr_id
,first_trial_appl_dt
,replace(replace(t1.first_trial_appl_tm,chr(13),''),chr(10),'') as first_trial_appl_tm
,replace(replace(t1.score_val,chr(13),''),chr(10),'') as score_val
,replace(replace(t1.first_trial_apv_status_cd,chr(13),''),chr(10),'') as first_trial_apv_status_cd
,replace(replace(t1.crdtc_que_situ_flg,chr(13),''),chr(10),'') as crdtc_que_situ_flg
,replace(replace(t1.first_trial_advise_sucs_flg,chr(13),''),chr(10),'') as first_trial_advise_sucs_flg
,replace(replace(t1.refuse_rs,chr(13),''),chr(10),'') as refuse_rs
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.acct_instit_id,chr(13),''),chr(10),'') as acct_instit_id
,replace(replace(t1.mgmt_org_id,chr(13),''),chr(10),'') as mgmt_org_id
,apv_end_tm
,replace(replace(t1.blip_doc_flg,chr(13),''),chr(10),'') as blip_doc_flg
,prep_repl_opering_loan_bal
,replace(replace(t1.tax_bur_auth_flow_num,chr(13),''),chr(10),'') as tax_bur_auth_flow_num
,replace(replace(t1.tax_type_cd,chr(13),''),chr(10),'') as tax_type_cd
,replace(replace(t1.taxpayer_idtfy_num,chr(13),''),chr(10),'') as taxpayer_idtfy_num
,corp_anl_inco
,create_dt
,update_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
,replace(replace(t1.white_list_cust_id,chr(13),''),chr(10),'') as white_list_cust_id
,replace(replace(t1.white_list_cert_type_cd,chr(13),''),chr(10),'') as white_list_cert_type_cd
,replace(replace(t1.white_list_cert_no,chr(13),''),chr(10),'') as white_list_cert_no
,replace(replace(t1.main_biz_cd,chr(13),''),chr(10),'') as main_biz_cd
,equip_qtty
,corp_equip_asset_total_val
,corp_fix_asset_loan_bal
,corp_equip_fin_rent_loan_bal
,corp_curt_cap_loan_bal
,replace(replace(t1.dir_line_kins_cert_no,chr(13),''),chr(10),'') as dir_line_kins_cert_no
,replace(replace(t1.brwer_is_actl_ctrler_flg,chr(13),''),chr(10),'') as brwer_is_actl_ctrler_flg
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.city_name,chr(13),''),chr(10),'') as city_name

from ${iml_schema}.agt_fkd_pre_loan_appl_info t1
where create_dt <= to_date('${batch_date}','yyyymmdd') and id_mark<>'D'" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_fkd_pre_loan_appl_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes
