: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_set_instruction_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_set_instruction_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(inst_id,chr(10),''),chr(13),'') as inst_id
,replace(replace(trade_id,chr(10),''),chr(13),'') as trade_id
,replace(replace(inst_type,chr(10),''),chr(13),'') as inst_type
,replace(replace(inst_grp_id,chr(10),''),chr(13),'') as inst_grp_id
,replace(replace(trd_type,chr(10),''),chr(13),'') as trd_type
,replace(replace(set_type,chr(10),''),chr(13),'') as set_type
,replace(replace(theory_set_date,chr(10),''),chr(13),'') as theory_set_date
,replace(replace(real_set_date,chr(10),''),chr(13),'') as real_set_date
,replace(replace(h_m_type,chr(10),''),chr(13),'') as h_m_type
,replace(replace(h_a_type,chr(10),''),chr(13),'') as h_a_type
,replace(replace(h_i_code,chr(10),''),chr(13),'') as h_i_code
,replace(replace(party_id,chr(10),''),chr(13),'') as party_id
,replace(replace(party_name,chr(10),''),chr(13),'') as party_name
,replace(replace(order_id,chr(10),''),chr(13),'') as order_id
,replace(replace(is_theory_payment,chr(10),''),chr(13),'') as is_theory_payment
,replace(replace(bj_market,chr(10),''),chr(13),'') as bj_market
,replace(replace(bj_state,chr(10),''),chr(13),'') as bj_state
,replace(replace(ext_ord_id,chr(10),''),chr(13),'') as ext_ord_id
,replace(replace(exe_market,chr(10),''),chr(13),'') as exe_market
,replace(replace(create_time,chr(10),''),chr(13),'') as create_time
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,replace(replace(update_user,chr(10),''),chr(13),'') as update_user
,replace(replace(account_time,chr(10),''),chr(13),'') as account_time
,replace(replace(account_user,chr(10),''),chr(13),'') as account_user
,replace(replace(memo,chr(10),''),chr(13),'') as memo
,replace(replace(update_user_id,chr(10),''),chr(13),'') as update_user_id
,replace(replace(cal_date,chr(10),''),chr(13),'') as cal_date
,replace(replace(ref_cash_inst_id,chr(10),''),chr(13),'') as ref_cash_inst_id
,replace(replace(ref_secu_inst_id,chr(10),''),chr(13),'') as ref_secu_inst_id
,replace(replace(inst_setgrp_id,chr(10),''),chr(13),'') as inst_setgrp_id
,replace(replace(state,chr(10),''),chr(13),'') as state
,replace(replace(operator_id,chr(10),''),chr(13),'') as operator_id
,replace(replace(operator_name,chr(10),''),chr(13),'') as operator_name
,replace(replace(print_times,chr(10),''),chr(13),'') as print_times
,replace(replace(due_order,chr(10),''),chr(13),'') as due_order
,replace(replace(due_obj_key,chr(10),''),chr(13),'') as due_obj_key
,replace(replace(generate_type,chr(10),''),chr(13),'') as generate_type
,replace(replace(ref_inst_id,chr(10),''),chr(13),'') as ref_inst_id
,replace(replace(is_real_acctg,chr(10),''),chr(13),'') as is_real_acctg
,replace(replace(real_account_inst_id,chr(10),''),chr(13),'') as real_account_inst_id
,replace(replace(is_unknown_price,chr(10),''),chr(13),'') as is_unknown_price
,replace(replace(his_flag,chr(10),''),chr(13),'') as his_flag
,replace(replace(cash_acct_id,chr(10),''),chr(13),'') as cash_acct_id
,replace(replace(his_inst_id,chr(10),''),chr(13),'') as his_inst_id
,replace(replace(his_ref_inst_id,chr(10),''),chr(13),'') as his_ref_inst_id
,replace(replace(is_operator_checked,chr(10),''),chr(13),'') as is_operator_checked
,replace(replace(orddate,chr(10),''),chr(13),'') as orddate
,replace(replace(condate,chr(10),''),chr(13),'') as condate
,replace(replace(is_match,chr(10),''),chr(13),'') as is_match
,replace(replace(settlemode,chr(10),''),chr(13),'') as settlemode
,replace(replace(host_market,chr(10),''),chr(13),'') as host_market
,replace(replace(spv_id,chr(10),''),chr(13),'') as spv_id
,replace(replace(process_type,chr(10),''),chr(13),'') as process_type
,replace(replace(clearing_date,chr(10),''),chr(13),'') as clearing_date
,replace(replace(acctg_estd_completed,chr(10),''),chr(13),'') as acctg_estd_completed
,replace(replace(acctg_real_completed,chr(10),''),chr(13),'') as acctg_real_completed
,replace(replace(clearing_completed,chr(10),''),chr(13),'') as clearing_completed
,replace(replace(is_period_inst,chr(10),''),chr(13),'') as is_period_inst
,replace(replace(tsk_id,chr(10),''),chr(13),'') as tsk_id
,replace(replace(approvestatus,chr(10),''),chr(13),'') as approvestatus
,replace(replace(bind_inst_id,chr(10),''),chr(13),'') as bind_inst_id
,replace(replace(trader,chr(10),''),chr(13),'') as trader
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_set_instruction
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_set_instruction_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes