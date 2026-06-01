: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_o_bms_sp_draft_info_f
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_o_bms_sp_draft_info_${batch_date}_f.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select id
,draft_number
,remitter_name
,remitter_account
,remitter_bank_id
,remitter_bank_name
,acceptor_bank_id
,acceptor_bank_name
,invoice_account
,invoice_name
,invoice_bank_id
,invoice_bank_name
,face_amount
,remit_date
,maturity_date
,payee_account
,payee_name
,payee_bank_id
,payee_bank_name
,status
,remark
,branch_id
,inner_user_account
,inner_user_name
,account_flag
,jie_fu_date
,account_date
,jie_fu_time from idl.pirs_o_bms_sp_draft_info where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_o_bms_sp_draft_info_${batch_date}_f.dat" \
        charset=zhs16gbk
        safe=yes