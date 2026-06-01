: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_icp_inv_ctrl_plat_dep_tran_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/icp_inv_ctrl_plat_dep_tran_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,chn
,dtl_seq_num
,acct_name
,tran_type
,debit_crdt_flg
,curr
,tran_amt
,tran_bal
,tran_dt
,tran_tm
,tran_flow_num
,tran_cntpty_name
,tran_cntpty_acct_num
,tran_cntpty_acct_open_bank
,tran_memo
,tran_brac_name
,tran_brac_cd
,tran_brac_addr
,vouch_kind
,vouch_num
,cash_flg
,termn_no
,tran_is_sucs
,ip_addr
,mac_addr
,tran_teller_no
,remark
,acct_seq_num
,cert_type_cd
,cert_no
,open_acct_org
,acct_num
,rev_tran_flg
,revs_tran_idf
,auth_teller_no
,public_agent_phone
,public_agent_name
,public_agent_cert_no
,public_agent_cert_type
from idl.icp_inv_ctrl_plat_dep_tran_dtl
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/icp_inv_ctrl_plat_dep_tran_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes