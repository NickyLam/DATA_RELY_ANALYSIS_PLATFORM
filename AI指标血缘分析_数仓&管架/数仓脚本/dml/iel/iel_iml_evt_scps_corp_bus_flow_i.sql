: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_scps_corp_bus_flow_i
CreateDate: 20221021
FileName:   ${iel_data_path}/evt_scps_corp_bus_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(evt_id,chr(13),''),chr(10),'')
,replace(replace(lp_id,chr(13),''),chr(10),'')
,replace(replace(task_no,chr(13),''),chr(10),'')
,replace(replace(ova_flow_num,chr(13),''),chr(10),'')
,cust_open_acct_dt
,replace(replace(org_id,chr(13),''),chr(10),'')
,replace(replace(teller_id,chr(13),''),chr(10),'')
,replace(replace(open_acct_status_cd,chr(13),''),chr(10),'')
,temp_acct_valid_dt
,replace(replace(super_corp_name,chr(13),''),chr(10),'')
,replace(replace(super_director_cert_type_cd,chr(13),''),chr(10),'')
,replace(replace(super_director_cert_no,chr(13),''),chr(10),'')
,replace(replace(depositr_name,chr(13),''),chr(10),'')
,replace(replace(pre_proc_id,chr(13),''),chr(10),'')
,replace(replace(fst_proof_doc_type_cd,chr(13),''),chr(10),'')
,replace(replace(fst_proof_doc_id,chr(13),''),chr(10),'')
,fst_proof_doc_exp_dt
,replace(replace(fst_cert_type_cd,chr(13),''),chr(10),'')
,replace(replace(bus_flow_set,chr(13),''),chr(10),'')
,replace(replace(sign_mobile_no,chr(13),''),chr(10),'')
,replace(replace(bkcp_seal_way_cd,chr(13),''),chr(10),'')
,replace(replace(post_addr_desc,chr(13),''),chr(10),'')
,replace(replace(bkcp_zip_cd,chr(13),''),chr(10),'')
,replace(replace(bkcp_cotas,chr(13),''),chr(10),'')
,replace(replace(bkcp_phone_num,chr(13),''),chr(10),'')
,replace(replace(bkcp_check_entry_way_cd,chr(13),''),chr(10),'')
,replace(replace(bkcp_check_entry_ped_cd,chr(13),''),chr(10),'')
,y_acm_lmt
,daily_accum_lmt
,daily_accum_cnt
,replace(replace(basic_serv_appl_type_cd,chr(13),''),chr(10),'')
,replace(replace(verify_type_cd,chr(13),''),chr(10),'')
,replace(replace(checker_seq_num,chr(13),''),chr(10),'')
,replace(replace(cap_verify_teller_id,chr(13),''),chr(10),'')
,replace(replace(legal_rep_mobile_no,chr(13),''),chr(10),'')
,replace(replace(legal_rep_fixline_tel_num,chr(13),''),chr(10),'')
,replace(replace(fin_princ_name,chr(13),''),chr(10),'')
,replace(replace(fin_princ_mobile_no,chr(13),''),chr(10),'')
,replace(replace(fin_princ_fixline_tel_num,chr(13),''),chr(10),'')
,replace(replace(org_name,chr(13),''),chr(10),'')
,replace(replace(org_addr,chr(13),''),chr(10),'')
,replace(replace(legal_rep_name,chr(13),''),chr(10),'')
,replace(replace(main_acct_id,chr(13),''),chr(10),'')
,replace(replace(corp_stop_pay_status_cd,chr(13),''),chr(10),'')
,replace(replace(acct_id,chr(13),''),chr(10),'')
,replace(replace(cust_id,chr(13),''),chr(10),'')
,replace(replace(cust_name,chr(13),''),chr(10),'')
,replace(replace(corp_acct_char_cd,chr(13),''),chr(10),'')
,visit_serv_flg
,replace(replace(apprv_way_cd,chr(13),''),chr(10),'')
,replace(replace(acct_actv_idf_cd,chr(13),''),chr(10),'')
,replace(replace(corp_bus_type_cd,chr(13),''),chr(10),'')
,replace(replace(share_seal_flg,chr(13),''),chr(10),'')
,replace(replace(back_check_flg,chr(13),''),chr(10),'')
,replace(replace(agent_flg,chr(13),''),chr(10),'')
,replace(replace(agent_name,chr(13),''),chr(10),'')
,replace(replace(agent_cert_type,chr(13),''),chr(10),'')
,replace(replace(agent_cert_no,chr(13),''),chr(10),'')
,replace(replace(agent_tel_num,chr(13),''),chr(10),'')
,agent_cert_vp
,replace(replace(corp_proc_status_cd,chr(13),''),chr(10),'')
,cust_clos_acct_dt
,replace(replace(double_remote_flg,chr(13),''),chr(10),'')
,replace(replace(open_acct_chn_id,chr(13),''),chr(10),'')
,replace(replace(check_teller_id,chr(13),''),chr(10),'')
,replace(replace(blip_batch_no,chr(13),''),chr(10),'')
,replace(replace(apprv_flg,chr(13),''),chr(10),'')
,replace(replace(rg_cd,chr(13),''),chr(10),'')
,replace(replace(rgst_cap_curr_cd,chr(13),''),chr(10),'')
,replace(replace(super_lp_org_cd,chr(13),''),chr(10),'')
,replace(replace(super_director_corp_post_type_cd,chr(13),''),chr(10),'')
,replace(replace(recd_type_cd,chr(13),''),chr(10),'')
,replace(replace(backup_cmplt_flg,chr(13),''),chr(10),'')
,replace(replace(pass_rapvrfction_flg,chr(13),''),chr(10),'')
,bus_lics_found_dt
,replace(replace(acct_name,chr(13),''),chr(10),'')
,replace(replace(rgst_addr,chr(13),''),chr(10),'')
,replace(replace(work_addr,chr(13),''),chr(10),'')
,replace(replace(mang_range_descb,chr(13),''),chr(10),'')
,replace(replace(dist_cd,chr(13),''),chr(10),'')
,rgst_cap
,replace(replace(legal_rep_cert_no,chr(13),''),chr(10),'')
,replace(replace(legal_rep_cert_type_cd,chr(13),''),chr(10),'')
,replace(replace(acct_open_acct_lics_apprv_num,chr(13),''),chr(10),'')
,replace(replace(depositr_cate_cd,chr(13),''),chr(10),'')
,replace(replace(cust_mgr_teller_id,chr(13),''),chr(10),'')

from ${iml_schema}.evt_scps_corp_bus_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_scps_corp_bus_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
