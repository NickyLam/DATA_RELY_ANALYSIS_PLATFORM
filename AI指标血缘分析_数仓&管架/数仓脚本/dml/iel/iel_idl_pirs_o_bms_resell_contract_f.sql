: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_bms_resell_contract_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_bms_resell_contract_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select id
,branch_id
,acct_branch_id
,resell_type
,business_no
,central_bankflg
,draft_type
,draft_attr
,customer_type
,customer_union_bank_no
,customer_brch_code
,buy_back_begin_date
,buy_back_end_date
,customer_id
,come_and_go_acct
,resell_date
,repurchase_date
,resell_rate
,resell_rate_type
,buy_back_rate
,rate_calculate_type
,imitate_sell_flag
,inner_flag
,two_way_flag
,two_way_date
,sttlm_mk
,operator_id
,txn_date
,manager_id
,depart_id
,account_status
,audit_status
,maturity_status
,calc_status
,logic_check_status
,rate_audit
,misc
,appno
,last_upd_oper_id
,last_upd_time
,customer_account
,core_account from idl.pirs_o_bms_resell_contract where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_bms_resell_contract_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes