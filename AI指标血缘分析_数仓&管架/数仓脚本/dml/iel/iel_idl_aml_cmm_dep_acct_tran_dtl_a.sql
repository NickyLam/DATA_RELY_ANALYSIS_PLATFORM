: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_cmm_dep_acct_tran_dtl_a
CreateDate: 20220916
FileName:   ${iel_data_path}/aml_cmm_dep_acct_tran_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   sundexin
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,lp_id
,tran_flow_num
,tran_dt
,tran_timestamp
,acct_bill_flow_num
,ova_flow_num
,acct_org_id
,dep_sub_acct_id
,cust_acct_id
,sub_acct_id
,cust_id
,cust_name
,cust_type_cd
,tran_kind_cd
,tran_status_cd
,debit_crdt_dir_cd
,tran_vouch_id
,vouch_kind_cd
,memo_cd
,memo_cd_descb
,chn_cd
,cntpty_acct_id
,cntpty_sub_acct_id
,cntpty_acct_name
,cntpty_open_bank_id
,cntpty_open_bank_name
,tran_org_id
,tran_curr_cd
,tran_amt
,tran_bal
,tran_teller_id
,check_teller_id
,auth_teller_id
,entry_teller_id
,erase_acct_flg
,revs_flg
,cash_trans_flg
,unexp_draw_flg
,beps_unpasew_flg
,bal_chk_flg
,termn_id
,tran_cd
,tran_descb
,rece_type_cd
,tran_name
,rece_id
,rece_descb_info
,agent_name
,agent_cert_type_cd
,agent_cert_no
,agent_gender_cd
,agent_nation_cd
,agent_cert_start_dt
,agent_cert_exp_dt
,agent_phone
,agent_licen_issue_autho_site
,agent_rs
,agent_type_cd
,operr_cert_type_cd
,operr_cert_no
,operr_name
,job_cd
from idl.aml_cmm_dep_acct_tran_dtl 
  where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_cmm_dep_acct_tran_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes