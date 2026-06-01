: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_scps_corp_bus_flow_f
CreateDate: 20221229
FileName:   ${iel_data_path}/evt_scps_corp_bus_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.task_no,chr(13),''),chr(10),'') as task_no
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,cust_open_acct_dt
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id
,replace(replace(t1.open_acct_status_cd,chr(13),''),chr(10),'') as open_acct_status_cd
,temp_acct_valid_dt
,replace(replace(t1.super_corp_name,chr(13),''),chr(10),'') as super_corp_name
,replace(replace(t1.super_director_cert_type_cd,chr(13),''),chr(10),'') as super_director_cert_type_cd
,replace(replace(t1.super_director_cert_no,chr(13),''),chr(10),'') as super_director_cert_no
,replace(replace(t1.depositr_name,chr(13),''),chr(10),'') as depositr_name
,replace(replace(t1.pre_proc_id,chr(13),''),chr(10),'') as pre_proc_id
,replace(replace(t1.fst_proof_doc_type_cd,chr(13),''),chr(10),'') as fst_proof_doc_type_cd
,replace(replace(t1.fst_proof_doc_id,chr(13),''),chr(10),'') as fst_proof_doc_id
,fst_proof_doc_exp_dt
,replace(replace(t1.fst_cert_type_cd,chr(13),''),chr(10),'') as fst_cert_type_cd
,replace(replace(t1.bus_flow_set,chr(13),''),chr(10),'') as bus_flow_set
,replace(replace(t1.sign_mobile_no,chr(13),''),chr(10),'') as sign_mobile_no
,replace(replace(t1.bkcp_seal_way_cd,chr(13),''),chr(10),'') as bkcp_seal_way_cd
,replace(replace(t1.post_addr_desc,chr(13),''),chr(10),'') as post_addr_desc
,replace(replace(t1.bkcp_zip_cd,chr(13),''),chr(10),'') as bkcp_zip_cd
,replace(replace(t1.bkcp_cotas,chr(13),''),chr(10),'') as bkcp_cotas
,replace(replace(t1.bkcp_phone_num,chr(13),''),chr(10),'') as bkcp_phone_num
,replace(replace(t1.bkcp_check_entry_way_cd,chr(13),''),chr(10),'') as bkcp_check_entry_way_cd
,replace(replace(t1.bkcp_check_entry_ped_cd,chr(13),''),chr(10),'') as bkcp_check_entry_ped_cd
,y_acm_lmt
,daily_accum_lmt
,daily_accum_cnt
,replace(replace(t1.basic_serv_appl_type_cd,chr(13),''),chr(10),'') as basic_serv_appl_type_cd
,replace(replace(t1.verify_type_cd,chr(13),''),chr(10),'') as verify_type_cd
,replace(replace(t1.checker_seq_num,chr(13),''),chr(10),'') as checker_seq_num
,replace(replace(t1.cap_verify_teller_id,chr(13),''),chr(10),'') as cap_verify_teller_id
,replace(replace(t1.legal_rep_mobile_no,chr(13),''),chr(10),'') as legal_rep_mobile_no
,replace(replace(t1.legal_rep_fixline_tel_num,chr(13),''),chr(10),'') as legal_rep_fixline_tel_num
,replace(replace(t1.fin_princ_name,chr(13),''),chr(10),'') as fin_princ_name
,replace(replace(t1.fin_princ_mobile_no,chr(13),''),chr(10),'') as fin_princ_mobile_no
,replace(replace(t1.fin_princ_fixline_tel_num,chr(13),''),chr(10),'') as fin_princ_fixline_tel_num
,replace(replace(t1.org_name,chr(13),''),chr(10),'') as org_name
,replace(replace(t1.org_addr,chr(13),''),chr(10),'') as org_addr
,replace(replace(t1.legal_rep_name,chr(13),''),chr(10),'') as legal_rep_name
,replace(replace(t1.main_acct_id,chr(13),''),chr(10),'') as main_acct_id
,replace(replace(t1.corp_stop_pay_status_cd,chr(13),''),chr(10),'') as corp_stop_pay_status_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.corp_acct_char_cd,chr(13),''),chr(10),'') as corp_acct_char_cd
,visit_serv_flg
,replace(replace(t1.apprv_way_cd,chr(13),''),chr(10),'') as apprv_way_cd
,replace(replace(t1.acct_actv_idf_cd,chr(13),''),chr(10),'') as acct_actv_idf_cd
,replace(replace(t1.corp_bus_type_cd,chr(13),''),chr(10),'') as corp_bus_type_cd
,replace(replace(t1.share_seal_flg,chr(13),''),chr(10),'') as share_seal_flg
,replace(replace(t1.back_check_flg,chr(13),''),chr(10),'') as back_check_flg
,replace(replace(t1.agent_flg,chr(13),''),chr(10),'') as agent_flg
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t1.agent_cert_type,chr(13),''),chr(10),'') as agent_cert_type
,replace(replace(t1.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
,replace(replace(t1.agent_tel_num,chr(13),''),chr(10),'') as agent_tel_num
,agent_cert_vp
,replace(replace(t1.corp_proc_status_cd,chr(13),''),chr(10),'') as corp_proc_status_cd
,cust_clos_acct_dt
,replace(replace(t1.double_remote_flg,chr(13),''),chr(10),'') as double_remote_flg
,replace(replace(t1.open_acct_chn_id,chr(13),''),chr(10),'') as open_acct_chn_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.blip_batch_no,chr(13),''),chr(10),'') as blip_batch_no
,replace(replace(t1.apprv_flg,chr(13),''),chr(10),'') as apprv_flg
,replace(replace(t1.rg_cd,chr(13),''),chr(10),'') as rg_cd
,replace(replace(t1.rgst_cap_curr_cd,chr(13),''),chr(10),'') as rgst_cap_curr_cd
,replace(replace(t1.super_lp_org_cd,chr(13),''),chr(10),'') as super_lp_org_cd
,replace(replace(t1.super_director_corp_post_type_cd,chr(13),''),chr(10),'') as super_director_corp_post_type_cd
,replace(replace(t1.recd_type_cd,chr(13),''),chr(10),'') as recd_type_cd
,replace(replace(t1.backup_cmplt_flg,chr(13),''),chr(10),'') as backup_cmplt_flg
,replace(replace(t1.pass_rapvrfction_flg,chr(13),''),chr(10),'') as pass_rapvrfction_flg
,bus_lics_found_dt
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.rgst_addr,chr(13),''),chr(10),'') as rgst_addr
,replace(replace(t1.work_addr,chr(13),''),chr(10),'') as work_addr
,replace(replace(t1.mang_range_descb,chr(13),''),chr(10),'') as mang_range_descb
,replace(replace(t1.dist_cd,chr(13),''),chr(10),'') as dist_cd
,rgst_cap
,replace(replace(t1.legal_rep_cert_no,chr(13),''),chr(10),'') as legal_rep_cert_no
,replace(replace(t1.legal_rep_cert_type_cd,chr(13),''),chr(10),'') as legal_rep_cert_type_cd
,replace(replace(t1.acct_open_acct_lics_apprv_num,chr(13),''),chr(10),'') as acct_open_acct_lics_apprv_num
,replace(replace(t1.depositr_cate_cd,chr(13),''),chr(10),'') as depositr_cate_cd
,replace(replace(t1.cust_mgr_teller_id,chr(13),''),chr(10),'') as cust_mgr_teller_id

from ${iml_schema}.evt_scps_corp_bus_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_scps_corp_bus_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
