: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_dep_acct_tran_dtl_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_dep_acct_tran_dtl_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,t.tran_dt as tran_dt
,t.tran_timestamp as tran_timestamp
,replace(replace(t.acct_bill_flow_num,chr(13),''),chr(10),'') as acct_bill_flow_num
,replace(replace(t.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t.acct_org_id,chr(13),''),chr(10),'') as acct_org_id
,replace(replace(t.dep_sub_acct_id,chr(13),''),chr(10),'') as dep_sub_acct_id
,replace(replace(t.cust_acct_id,chr(13),''),chr(10),'') as cust_acct_id
,replace(replace(t.sub_acct_id,chr(13),''),chr(10),'') as sub_acct_id
,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t.cust_name,chr(13),''),chr(10),'') as cust_name
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.tran_kind_cd,chr(13),''),chr(10),'') as tran_kind_cd
,replace(replace(t.elec_tran_kind_cd,chr(13),''),chr(10),'') as elec_tran_kind_cd
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t.debit_crdt_dir_cd,chr(13),''),chr(10),'') as debit_crdt_dir_cd
,replace(replace(t.tran_vouch_id,chr(13),''),chr(10),'') as tran_vouch_id
,replace(replace(t.vouch_kind_cd,chr(13),''),chr(10),'') as vouch_kind_cd
,replace(replace(t.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t.memo_cd_descb,chr(13),''),chr(10),'') as memo_cd_descb
,replace(replace(t.chn_cd,chr(13),''),chr(10),'') as chn_cd
,replace(replace(t.cntpty_acct_id,chr(13),''),chr(10),'') as cntpty_acct_id
,replace(replace(t.cntpty_sub_acct_id,chr(13),''),chr(10),'') as cntpty_sub_acct_id
,replace(replace(t.cntpty_acct_name,chr(13),''),chr(10),'') as cntpty_acct_name
,replace(replace(t.cntpty_open_bank_id,chr(13),''),chr(10),'') as cntpty_open_bank_id
,replace(replace(t.cntpty_open_bank_name,chr(13),''),chr(10),'') as cntpty_open_bank_name
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.tran_curr_cd,chr(13),''),chr(10),'') as tran_curr_cd
,t.tran_amt as tran_amt
,t.tran_bal as tran_bal
,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t.entry_teller_id,chr(13),''),chr(10),'') as entry_teller_id
,replace(replace(t.erase_acct_flg,chr(13),''),chr(10),'') as erase_acct_flg
,replace(replace(t.revs_flg,chr(13),''),chr(10),'') as revs_flg
,replace(replace(t.cash_trans_flg,chr(13),''),chr(10),'') as cash_trans_flg
,replace(replace(t.unexp_draw_flg,chr(13),''),chr(10),'') as unexp_draw_flg
,replace(replace(t.beps_unpasew_flg,chr(13),''),chr(10),'') as beps_unpasew_flg
,replace(replace(t.bal_chk_flg,chr(13),''),chr(10),'') as bal_chk_flg
,replace(replace(t.termn_id,chr(13),''),chr(10),'') as termn_id
,replace(replace(t.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t.rece_type_cd,chr(13),''),chr(10),'') as rece_type_cd
,replace(replace(t.tran_name,chr(13),''),chr(10),'') as tran_name
,replace(replace(t.rece_id,chr(13),''),chr(10),'') as rece_id
,replace(replace(t.rece_descb_info,chr(13),''),chr(10),'') as rece_descb_info
,replace(replace(t.agent_name,chr(13),''),chr(10),'') as agent_name
,replace(replace(t.agent_cert_type_cd,chr(13),''),chr(10),'') as agent_cert_type_cd
,replace(replace(t.agent_cert_no,chr(13),''),chr(10),'') as agent_cert_no
,replace(replace(t.agent_gender_cd,chr(13),''),chr(10),'') as agent_gender_cd
,replace(replace(t.agent_nation_cd,chr(13),''),chr(10),'') as agent_nation_cd
,t.agent_cert_start_dt as agent_cert_start_dt
,t.agent_cert_exp_dt as agent_cert_exp_dt
,replace(replace(t.agent_phone,chr(13),''),chr(10),'') as agent_phone
,replace(replace(t.agent_licen_issue_autho_site,chr(13),''),chr(10),'') as agent_licen_issue_autho_site
,replace(replace(t.agent_rs,chr(13),''),chr(10),'') as agent_rs
,replace(replace(t.agent_type_cd,chr(13),''),chr(10),'') as agent_type_cd
,replace(replace(t.operr_cert_type_cd,chr(13),''),chr(10),'') as operr_cert_type_cd
,replace(replace(t.operr_cert_no,chr(13),''),chr(10),'') as operr_cert_no
,replace(replace(t.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t.client_ip_addr,chr(13),''),chr(10),'') as client_ip_addr
,replace(replace(t.cust_termn_mac_addr,chr(13),''),chr(10),'') as cust_termn_mac_addr
,replace(replace(t.entry_flg,chr(13),''),chr(10),'') as entry_flg
from ${icl_schema}.cmm_dep_acct_tran_dtl t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6   ; " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_dep_acct_tran_dtl_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes