: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_set_instruction_cash_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_set_instruction_cash_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(cash_inst_id,chr(10),''),chr(13),'') as cash_inst_id
,replace(replace(inst_id,chr(10),''),chr(13),'') as inst_id
,replace(replace(cash_inst_grp_id,chr(10),''),chr(13),'') as cash_inst_grp_id
,replace(replace(biz_type,chr(10),''),chr(13),'') as biz_type
,replace(replace(direction,chr(10),''),chr(13),'') as direction
,replace(replace(cash_acct_id,chr(10),''),chr(13),'') as cash_acct_id
,replace(replace(ext_cash_acct_id,chr(10),''),chr(13),'') as ext_cash_acct_id
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(amount,chr(10),''),chr(13),'') as amount
,replace(replace(freeze_amount,chr(10),''),chr(13),'') as freeze_amount
,replace(replace(set_date,chr(10),''),chr(13),'') as set_date
,replace(replace(set_finish_date,chr(10),''),chr(13),'') as set_finish_date
,replace(replace(transfer_type,chr(10),''),chr(13),'') as transfer_type
,replace(replace(acct_code,chr(10),''),chr(13),'') as acct_code
,replace(replace(acct_name,chr(10),''),chr(13),'') as acct_name
,replace(replace(bank_code,chr(10),''),chr(13),'') as bank_code
,replace(replace(bank_name,chr(10),''),chr(13),'') as bank_name
,replace(replace(party_acct_code,chr(10),''),chr(13),'') as party_acct_code
,replace(replace(party_acct_name,chr(10),''),chr(13),'') as party_acct_name
,replace(replace(party_bank_code,chr(10),''),chr(13),'') as party_bank_code
,replace(replace(party_bank_name,chr(10),''),chr(13),'') as party_bank_name
,replace(replace(create_time,chr(10),''),chr(13),'') as create_time
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,replace(replace(update_user,chr(10),''),chr(13),'') as update_user
,replace(replace(account_time,chr(10),''),chr(13),'') as account_time
,replace(replace(account_user,chr(10),''),chr(13),'') as account_user
,replace(replace(memo,chr(10),''),chr(13),'') as memo
,replace(replace(blc_state,chr(10),''),chr(13),'') as blc_state
,replace(replace(acctg_state,chr(10),''),chr(13),'') as acctg_state
,replace(replace(opr_state,chr(10),''),chr(13),'') as opr_state
,replace(replace(cash_inst_setgrp_id,chr(10),''),chr(13),'') as cash_inst_setgrp_id
,replace(replace(acctg_inst_id,chr(10),''),chr(13),'') as acctg_inst_id
,replace(replace(cancel_flag,chr(10),''),chr(13),'') as cancel_flag
,replace(replace(is_theory_blc,chr(10),''),chr(13),'') as is_theory_blc
,replace(replace(nostro_ref_cash_inst_id,chr(10),''),chr(13),'') as nostro_ref_cash_inst_id
,replace(replace(pending_flow_no,chr(10),''),chr(13),'') as pending_flow_no
,replace(replace(pending_date,chr(10),''),chr(13),'') as pending_date
,replace(replace(is_theory_acct,chr(10),''),chr(13),'') as is_theory_acct
,replace(replace(mid_bank_acct_code,chr(10),''),chr(13),'') as mid_bank_acct_code
,replace(replace(mid_bank_name,chr(10),''),chr(13),'') as mid_bank_name
,replace(replace(mid_swift_code,chr(10),''),chr(13),'') as mid_swift_code
,replace(replace(swift_code,chr(10),''),chr(13),'') as swift_code
,replace(replace(party_swift_code,chr(10),''),chr(13),'') as party_swift_code
,replace(replace(party_mid_bank_acct_code,chr(10),''),chr(13),'') as party_mid_bank_acct_code
,replace(replace(party_mid_bank_name,chr(10),''),chr(13),'') as party_mid_bank_name
,replace(replace(party_mid_swift_code,chr(10),''),chr(13),'') as party_mid_swift_code
,replace(replace(cl_status,chr(10),''),chr(13),'') as cl_status
,replace(replace(party_i_bank_code,chr(10),''),chr(13),'') as party_i_bank_code
,replace(replace(party_i_swift_code,chr(10),''),chr(13),'') as party_i_swift_code
,replace(replace(his_cash_inst_id,chr(10),''),chr(13),'') as his_cash_inst_id
,replace(replace(his_flag,chr(10),''),chr(13),'') as his_flag
,replace(replace(ord_limit_cash_inst_id,chr(10),''),chr(13),'') as ord_limit_cash_inst_id
,replace(replace(hvps_mate_trace_no,chr(10),''),chr(13),'') as hvps_mate_trace_no
,replace(replace(module_type,chr(10),''),chr(13),'') as module_type
,replace(replace(xcc_module_type,chr(10),''),chr(13),'') as xcc_module_type
,replace(replace(is_editable,chr(10),''),chr(13),'') as is_editable
,replace(replace(check_result_box,chr(10),''),chr(13),'') as check_result_box
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_set_instruction_cash
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_set_instruction_cash_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes