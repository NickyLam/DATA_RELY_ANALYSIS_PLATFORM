: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_cmm_dep_acct_tran_dtl_i
CreateDate: 20241231
FileName:   ${iel_data_path}/cmm_dep_acct_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
t1.etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,tran_dt
,tran_timestamp
,replace(replace(t1.acct_bill_flow_num,chr(13),''),chr(10),'') as acct_bill_flow_num
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.acct_org_id,chr(13),''),chr(10),'') as acct_org_id
,replace(replace(t1.dep_sub_acct_id,chr(13),''),chr(10),'') as dep_sub_acct_id
,replace(replace(t1.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t1.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
,replace(replace(t1.elec_tran_kind_cd,chr(13),''),chr(10),'') as elec_tran_kind_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,replace(replace(t1.tran_vouch_id,chr(13),''),chr(10),'') as tran_vouch_id
,replace(replace(t1.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t1.memo_cd_descb,chr(13),''),chr(10),'') as memo_cd_descb
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t1.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t1.cntpty_sub_acct_id,chr(13),''),chr(10),'') as cntpty_sub_acct_id
,replace(replace(t1.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t1.cntpty_open_bank_id,chr(13),''),chr(10),'') as cntpty_open_bank_id
,replace(replace(t1.cntpty_open_bank_name,chr(13),''),chr(10),'') as cntpty_open_bank_name
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,tran_amt
,tran_bal
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.entry_teller_id,chr(13),''),chr(10),'') as entry_teller_id
,replace(replace(t1.erase_acct_flg,chr(13),''),chr(10),'') as erase_acct_flg
,replace(replace(t1.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t1.cash_trans_flg,chr(13),''),chr(10),'') as cash_trans_flg
,replace(replace(t1.unexp_draw_flg,chr(13),''),chr(10),'') as unexp_draw_flg
,replace(replace(t1.beps_unpasew_flg,chr(13),''),chr(10),'') as beps_unpasew_flg
,replace(replace(t1.bal_chk_flg,chr(13),''),chr(10),'') as bal_chk_flg
,replace(replace(t1.termn_id,chr(13),''),chr(10),'') as termn_id
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.rece_type_cd,chr(13),''),chr(10),'') as rece_type_cd
,replace(replace(t1.tran_name,chr(13),''),chr(10),'') as tran_name
,replace(replace(t1.rece_id,chr(13),''),chr(10),'') as rece_id
,replace(replace(t1.rece_descb_info,chr(13),''),chr(10),'') as rece_descb_info
,replace(replace(t1.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t1.agent_cert_type_cd,chr(13),''),chr(10),'') as agent_cert_type_cd
,replace(replace(t1.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
,replace(replace(t1.agent_gender_cd,chr(13),''),chr(10),'') as agent_gender_cd
,replace(replace(t1.agent_nation_cd,chr(13),''),chr(10),'') as agent_nation_cd
,agent_cert_start_dt
,agent_cert_exp_dt
,replace(replace(t1.agent_phone,chr(13),''),chr(10),'') as agent_phone
,replace(replace(t1.agent_licen_issue_autho_site,chr(13),''),chr(10),'') as agent_licen_issue_autho_site
,replace(replace(t1.agent_rs,chr(13),''),chr(10),'') as agent_rs
,replace(replace(t1.agent_type_cd,chr(13),''),chr(10),'') as agent_type_cd
,replace(replace(t1.operr_cert_type_cd,chr(13),''),chr(10),'') as operr_cert_type_cd
,replace(replace(t1.operr_cert_no,chr(13),''),chr(10),'') as operr_cert_no
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t1.client_ip_addr,chr(13),''),chr(10),'') as client_ip_addr
,replace(replace(t1.cust_termn_mac_addr,chr(13),''),chr(10),'') as cust_termn_mac_addr
,replace(replace(t1.entry_flg,chr(13),''),chr(10),'') as entry_flg
,replace(replace(t1.tran_flg_num,chr(13),''),chr(10),'') as tran_flg_num
,replace(replace(t1.init_dep_sub_acct_id,chr(13),''),chr(10),'') as init_dep_sub_acct_id
,replace(replace(t1.init_sub_acct_id,chr(13),''),chr(10),'') as init_sub_acct_id
,replace(replace(t1.cntpty_acct_open_bank_cd,chr(13),''),chr(10),'') as cntpty_acct_open_bank_cd
,replace(replace(t1.real_cntpty_acct_id,chr(13),''),chr(10),'') as real_cntpty_acct_id
,replace(replace(t1.real_cntpty_acct_name,chr(13),''),chr(10),'') as real_cntpty_acct_name
,replace(replace(t1.real_cntpty_fin_inst_cd,chr(13),''),chr(10),'') as real_cntpty_fin_inst_cd
,replace(replace(t1.real_cntpty_fin_inst_name,chr(13),''),chr(10),'') as real_cntpty_fin_inst_name
,replace(replace(t1.agent_cust_id,chr(13),''),chr(10),'') as agent_cust_id
,replace(replace(t1.cash_proj_cd,chr(13),''),chr(10),'') as cash_proj_cd
,replace(replace(t1.prpery_sys_code,chr(13),''),chr(10),'') as prpery_sys_code
,revs_tran_dt
,replace(replace(t1.revs_tran_flow_num,chr(13),''),chr(10),'') as revs_tran_flow_num
,replace(replace(t1.revs_tran_code,chr(13),''),chr(10),'') as revs_tran_code
,replace(replace(t1.cntpty_inter_acct_id,chr(13),''),chr(10),'') as cntpty_inter_acct_id
,replace(replace(t1.bus_prod_id,chr(13),''),chr(10),'') as bus_prod_id
,init_tran_timestamp
,replace(replace(t1.cross_bor_tran_flg,chr(13),''),chr(10),'') as cross_bor_tran_flg

from ${icl_schema}.cmm_dep_acct_tran_dtl t1
where etl_dt in (to_date('${batch_date}','yyyymmdd'), to_date('${batch_date}','yyyymmdd') - 1) and t1.entry_flg = '1'; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_acct_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
