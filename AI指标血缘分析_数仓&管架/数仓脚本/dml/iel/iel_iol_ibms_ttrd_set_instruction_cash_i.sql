: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_set_instruction_cash_i
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_set_instruction_cash.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.cash_inst_id as cash_inst_id
,t1.inst_id as inst_id
,t1.cash_inst_grp_id as cash_inst_grp_id
,replace(replace(t1.biz_type,chr(13),''),chr(10),'') as biz_type
,replace(replace(t1.direction,chr(13),''),chr(10),'') as direction
,replace(replace(t1.cash_acct_id,chr(13),''),chr(10),'') as cash_acct_id
,replace(replace(t1.ext_cash_acct_id,chr(13),''),chr(10),'') as ext_cash_acct_id
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.amount as amount
,t1.freeze_amount as freeze_amount
,replace(replace(t1.set_date,chr(13),''),chr(10),'') as set_date
,replace(replace(t1.set_finish_date,chr(13),''),chr(10),'') as set_finish_date
,t1.transfer_type as transfer_type
,replace(replace(t1.acct_code,chr(13),''),chr(10),'') as acct_code
,replace(replace(t1.acct_name,chr(13),''),chr(10),'') as acct_name
,replace(replace(t1.bank_code,chr(13),''),chr(10),'') as bank_code
,replace(replace(t1.bank_name,chr(13),''),chr(10),'') as bank_name
,replace(replace(t1.party_acct_code,chr(13),''),chr(10),'') as party_acct_code
,replace(replace(t1.party_acct_name,chr(13),''),chr(10),'') as party_acct_name
,replace(replace(t1.party_bank_code,chr(13),''),chr(10),'') as party_bank_code
,replace(replace(t1.party_bank_name,chr(13),''),chr(10),'') as party_bank_name
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.account_time,chr(13),''),chr(10),'') as account_time
,replace(replace(t1.account_user,chr(13),''),chr(10),'') as account_user
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,t1.blc_state as blc_state
,t1.acctg_state as acctg_state
,t1.opr_state as opr_state
,t1.cash_inst_setgrp_id as cash_inst_setgrp_id
,t1.acctg_inst_id as acctg_inst_id
,replace(replace(t1.cancel_flag,chr(13),''),chr(10),'') as cancel_flag
,replace(replace(t1.is_theory_blc,chr(13),''),chr(10),'') as is_theory_blc
,t1.nostro_ref_cash_inst_id as nostro_ref_cash_inst_id
,replace(replace(t1.pending_flow_no,chr(13),''),chr(10),'') as pending_flow_no
,replace(replace(t1.pending_date,chr(13),''),chr(10),'') as pending_date
,replace(replace(t1.is_theory_acct,chr(13),''),chr(10),'') as is_theory_acct
,replace(replace(t1.mid_bank_acct_code,chr(13),''),chr(10),'') as mid_bank_acct_code
,replace(replace(t1.mid_bank_name,chr(13),''),chr(10),'') as mid_bank_name
,replace(replace(t1.mid_swift_code,chr(13),''),chr(10),'') as mid_swift_code
,replace(replace(t1.swift_code,chr(13),''),chr(10),'') as swift_code
,replace(replace(t1.party_swift_code,chr(13),''),chr(10),'') as party_swift_code
,replace(replace(t1.party_mid_bank_acct_code,chr(13),''),chr(10),'') as party_mid_bank_acct_code
,replace(replace(t1.party_mid_bank_name,chr(13),''),chr(10),'') as party_mid_bank_name
,replace(replace(t1.party_mid_swift_code,chr(13),''),chr(10),'') as party_mid_swift_code
,t1.cl_status as cl_status
,replace(replace(t1.party_i_bank_code,chr(13),''),chr(10),'') as party_i_bank_code
,replace(replace(t1.party_i_swift_code,chr(13),''),chr(10),'') as party_i_swift_code
,t1.his_cash_inst_id as his_cash_inst_id
,t1.his_flag as his_flag
,t1.ord_limit_cash_inst_id as ord_limit_cash_inst_id
,replace(replace(t1.hvps_mate_trace_no,chr(13),''),chr(10),'') as hvps_mate_trace_no
,t1.module_type as module_type
,t1.xcc_module_type as xcc_module_type
,replace(replace(t1.is_editable,chr(13),''),chr(10),'') as is_editable
,t1.check_result_box as check_result_box

from ${iol_schema}.ibms_ttrd_set_instruction_cash t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_set_instruction_cash.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
