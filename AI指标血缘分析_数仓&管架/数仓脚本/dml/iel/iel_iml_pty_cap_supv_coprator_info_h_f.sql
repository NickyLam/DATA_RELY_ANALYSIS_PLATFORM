: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_pty_cap_supv_coprator_info_h_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pty_cap_supv_coprator_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.coprator_seq_num,chr(13),''),chr(10),'') as coprator_seq_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.coprator_id,chr(13),''),chr(10),'') as coprator_id
,replace(replace(t1.coprator_name,chr(13),''),chr(10),'') as coprator_name
,replace(replace(t1.coprator_abbr,chr(13),''),chr(10),'') as coprator_abbr
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.trdpty_flow_num,chr(13),''),chr(10),'') as trdpty_flow_num
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,t1.cert_exp_dt as cert_exp_dt
,replace(replace(t1.legal_rep_name,chr(13),''),chr(10),'') as legal_rep_name
,replace(replace(t1.legal_rep_cert_type_cd,chr(13),''),chr(10),'') as legal_rep_cert_type_cd
,replace(replace(t1.legal_rep_cert_no,chr(13),''),chr(10),'') as legal_rep_cert_no
,t1.lp_cert_start_dt as lp_cert_start_dt
,t1.lp_cert_exp_dt as lp_cert_exp_dt
,replace(replace(t1.lp_phone_num,chr(13),''),chr(10),'') as lp_phone_num
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t1.operr_cert_type_cd,chr(13),''),chr(10),'') as operr_cert_type_cd
,replace(replace(t1.operr_cert_no,chr(13),''),chr(10),'') as operr_cert_no
,t1.operr_cert_start_dt as operr_cert_start_dt
,t1.operr_cert_exp_dt as operr_cert_exp_dt
,replace(replace(t1.operr_mobile_no,chr(13),''),chr(10),'') as operr_mobile_no
,replace(replace(t1.dtl_addr,chr(13),''),chr(10),'') as dtl_addr
,replace(replace(t1.zip_cd,chr(13),''),chr(10),'') as zip_cd
,replace(replace(t1.phone_num,chr(13),''),chr(10),'') as phone_num
,replace(replace(t1.monit_acct_id,chr(13),''),chr(10),'') as monit_acct_id
,replace(replace(t1.monit_acct_name,chr(13),''),chr(10),'') as monit_acct_name
,replace(replace(t1.monit_acct_org_id,chr(13),''),chr(10),'') as monit_acct_org_id
,replace(replace(t1.monit_acct_org_name,chr(13),''),chr(10),'') as monit_acct_org_name
,replace(replace(t1.mdl_enter_id,chr(13),''),chr(10),'') as mdl_enter_id
,replace(replace(t1.mdl_enter_name,chr(13),''),chr(10),'') as mdl_enter_name
,replace(replace(t1.mdl_enter_org_id,chr(13),''),chr(10),'') as mdl_enter_org_id
,replace(replace(t1.mdl_enter_org_name,chr(13),''),chr(10),'') as mdl_enter_org_name
,replace(replace(t1.trdpty_clear_enter_id,chr(13),''),chr(10),'') as trdpty_clear_enter_id
,replace(replace(t1.trdpty_clear_enter_name,chr(13),''),chr(10),'') as trdpty_clear_enter_name
,replace(replace(t1.trdpty_clear_enter_org_id,chr(13),''),chr(10),'') as trdpty_clear_enter_org_id
,replace(replace(t1.trdpty_clear_enter_org_name,chr(13),''),chr(10),'') as trdpty_clear_enter_org_name
,replace(replace(t1.trdpty_clear_enter_obank_flg,chr(13),''),chr(10),'') as trdpty_clear_enter_obank_flg
,replace(replace(t1.corp_stl_acct_id,chr(13),''),chr(10),'') as corp_stl_acct_id
,replace(replace(t1.corp_stl_acct_name,chr(13),''),chr(10),'') as corp_stl_acct_name
,replace(replace(t1.corp_stl_acct_org_id,chr(13),''),chr(10),'') as corp_stl_acct_org_id
,replace(replace(t1.corp_stl_acct_org_name,chr(13),''),chr(10),'') as corp_stl_acct_org_name
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.coprator_status_cd,chr(13),''),chr(10),'') as coprator_status_cd
,replace(replace(t1.clear_mode_cd,chr(13),''),chr(10),'') as clear_mode_cd
,replace(replace(t1.dmic_st_msg_send_flg,chr(13),''),chr(10),'') as dmic_st_msg_send_flg
,replace(replace(t1.vtual_acct_id,chr(13),''),chr(10),'') as vtual_acct_id
,replace(replace(t1.open_chn_cd,chr(13),''),chr(10),'') as open_chn_cd
,t1.bd_card_qtty_uplmi as bd_card_qtty_uplmi
,replace(replace(t1.operr_id,chr(13),''),chr(10),'') as operr_id
,replace(replace(t1.check_operr_id,chr(13),''),chr(10),'') as check_operr_id
,t1.update_tm as update_tm
,t1.create_tm as create_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.pty_cap_supv_coprator_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/pty_cap_supv_coprator_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes