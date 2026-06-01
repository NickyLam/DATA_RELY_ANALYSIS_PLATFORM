: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_bms_draft_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_bms_draft_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select id
,draft_number
,voucher_no
,draft_class
,draft_term
,dfcls_ctl
,src_type
,buy_contract_id
,end_or_sement_mk
,draft_attr
,draft_type
,remit_date
,maturity_date
,remitter_id
,remitter_role
,remitter_cmonid
,remitter_name
,remitter_account
,remitter_bank_id
,remitter_bank_name
,acceptor_role
,acceptor
,acceptor_bank_id
,acceptor_actno
,acceptor_bank_name
,payee_name
,payee_account
,payee_bank_id
,payee_bank_name
,payee_id
,payee_organ_code
,face_amount
,drawer_bank_flag
,belong_branch_id
,store_status
,status
,tmp_status
,collztn_status
,collztn_id
,loss_status
,rploss_id
,debit_order
,misc
,last_upd_oper_id
,last_upd_time
,drft_remark
,df_drwr_cdtratgs
,df_drwr_cdtratgsagcy
,df_drwr_cdtratgduedt
,payee_bank_no
,oner_brid
,rp_status
,draft_number_rp from idl.pirs_o_bms_draft_info where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_bms_draft_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes