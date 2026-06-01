: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icf_cmm_bank_card_basic_info_f
CreateDate: 20240704
FileName:   ${iel_data_path}/cmm_bank_card_basic_info.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.card_no,chr(13),''),chr(10),'') as card_no
,replace(replace(t1.vouch_no,chr(13),''),chr(10),'') as vouch_no
,replace(replace(t1.vouch_mgmt_id,chr(13),''),chr(10),'') as vouch_mgmt_id
,replace(replace(t1.nc_card_no,chr(13),''),chr(10),'') as nc_card_no
,replace(replace(t1.magt_ctrl_id,chr(13),''),chr(10),'') as magt_ctrl_id
,replace(replace(t1.card_name,chr(13),''),chr(10),'') as card_name
,replace(replace(t1.start_use_flg,chr(13),''),chr(10),'') as start_use_flg
,replace(replace(t1.vtual_card_flg,chr(13),''),chr(10),'') as vtual_card_flg
,replace(replace(t1.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd
,replace(replace(t1.card_type_cd,chr(13),''),chr(10),'') as card_type_cd
,replace(replace(t1.co_card_type_cd,chr(13),''),chr(10),'') as co_card_type_cd
,replace(replace(t1.card_status_cd,chr(13),''),chr(10),'') as card_status_cd
,replace(replace(t1.card_level_cd,chr(13),''),chr(10),'') as card_level_cd
,replace(replace(t1.make_card_flow_num,chr(13),''),chr(10),'') as make_card_flow_num
,t1.make_card_dt as make_card_dt
,t1.effect_dt as effect_dt
,t1.invalid_dt as invalid_dt
,replace(replace(t1.use_brch_range,chr(13),''),chr(10),'') as use_brch_range
,replace(replace(t1.card_holder_name,chr(13),''),chr(10),'') as card_holder_name
,replace(replace(t1.card_holder_cert_type_cd,chr(13),''),chr(10),'') as card_holder_cert_type_cd
,replace(replace(t1.card_holder_cert_no,chr(13),''),chr(10),'') as card_holder_cert_no
,t1.final_tran_dt as final_tran_dt
,replace(replace(t1.final_tran_flow,chr(13),''),chr(10),'') as final_tran_flow
,t1.final_offline_tran_dt as final_offline_tran_dt
,t1.offline_tran_tot_amt as offline_tran_tot_amt
,t1.bal_uplmi as bal_uplmi
,t1.sig_cash_tran_lmt as sig_cash_tran_lmt
,t1.auto_load_tshold as auto_load_tshold
,t1.auto_load_amt as auto_load_amt
,t1.acm_load_amt as acm_load_amt
,t1.acm_unload_amt as acm_unload_amt
,t1.curr_bal as curr_bal
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.main_card_flg,chr(13),''),chr(10),'') as main_card_flg
,replace(replace(t1.card_bin,chr(13),''),chr(10),'') as card_bin
,replace(replace(t1.main_card_card_no,chr(13),''),chr(10),'') as main_card_card_no
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.corp_stl_card_flg,chr(13),''),chr(10),'') as corp_stl_card_flg
,replace(replace(t1.card_psbook_merge_one_flg,chr(13),''),chr(10),'') as card_psbook_merge_one_flg
,replace(replace(t1.nomi_card_flg,chr(13),''),chr(10),'') as nomi_card_flg
,replace(replace(t1.make_card_appl_id,chr(13),''),chr(10),'') as make_card_appl_id
,replace(replace(t1.card_iss_org_id,chr(13),''),chr(10),'') as card_iss_org_id
,replace(replace(t1.card_iss_teller_id,chr(13),''),chr(10),'') as card_iss_teller_id
,t1.card_iss_dt as card_iss_dt
,replace(replace(t1.pin_card_teller_id,chr(13),''),chr(10),'') as pin_card_teller_id
,t1.pin_card_dt as pin_card_dt
,replace(replace(t1.pin_card_rs_descb,chr(13),''),chr(10),'') as pin_card_rs_descb
,t1.change_card_cnt as change_card_cnt
,replace(replace(t1.invalid_dt_pwd,chr(13),''),chr(10),'') as invalid_dt_pwd
from ${icl_schema}.cmm_bank_card_basic_info t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_bank_card_basic_info.f.${batch_date}.dat" \
        charset=utf8
        safe=yes