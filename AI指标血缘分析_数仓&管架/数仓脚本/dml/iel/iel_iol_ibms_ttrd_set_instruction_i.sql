: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_set_instruction_i
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_set_instruction.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.inst_id as inst_id
,replace(replace(t1.trade_id,chr(13),''),chr(10),'') as trade_id
,t1.inst_type as inst_type
,t1.inst_grp_id as inst_grp_id
,replace(replace(t1.trd_type,chr(13),''),chr(10),'') as trd_type
,replace(replace(t1.set_type,chr(13),''),chr(10),'') as set_type
,replace(replace(t1.theory_set_date,chr(13),''),chr(10),'') as theory_set_date
,replace(replace(t1.real_set_date,chr(13),''),chr(10),'') as real_set_date
,replace(replace(t1.h_m_type,chr(13),''),chr(10),'') as h_m_type
,replace(replace(t1.h_a_type,chr(13),''),chr(10),'') as h_a_type
,replace(replace(t1.h_i_code,chr(13),''),chr(10),'') as h_i_code
,t1.party_id as party_id
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name
,replace(replace(t1.order_id,chr(13),''),chr(10),'') as order_id
,replace(replace(t1.is_theory_payment,chr(13),''),chr(10),'') as is_theory_payment
,replace(replace(t1.bj_market,chr(13),''),chr(10),'') as bj_market
,t1.bj_state as bj_state
,replace(replace(t1.ext_ord_id,chr(13),''),chr(10),'') as ext_ord_id
,replace(replace(t1.exe_market,chr(13),''),chr(10),'') as exe_market
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.account_time,chr(13),''),chr(10),'') as account_time
,replace(replace(t1.account_user,chr(13),''),chr(10),'') as account_user
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t1.update_user_id,chr(13),''),chr(10),'') as update_user_id
,replace(replace(t1.cal_date,chr(13),''),chr(10),'') as cal_date
,t1.ref_cash_inst_id as ref_cash_inst_id
,t1.ref_secu_inst_id as ref_secu_inst_id
,t1.inst_setgrp_id as inst_setgrp_id
,t1.state as state
,replace(replace(t1.operator_id,chr(13),''),chr(10),'') as operator_id
,replace(replace(t1.operator_name,chr(13),''),chr(10),'') as operator_name
,t1.print_times as print_times
,replace(replace(t1.due_order,chr(13),''),chr(10),'') as due_order
,t1.due_obj_key as due_obj_key
,t1.generate_type as generate_type
,t1.ref_inst_id as ref_inst_id
,replace(replace(t1.is_real_acctg,chr(13),''),chr(10),'') as is_real_acctg
,t1.real_account_inst_id as real_account_inst_id
,replace(replace(t1.is_unknown_price,chr(13),''),chr(10),'') as is_unknown_price
,t1.his_flag as his_flag
,replace(replace(t1.cash_acct_id,chr(13),''),chr(10),'') as cash_acct_id
,t1.his_inst_id as his_inst_id
,t1.his_ref_inst_id as his_ref_inst_id
,replace(replace(t1.is_operator_checked,chr(13),''),chr(10),'') as is_operator_checked
,replace(replace(t1.orddate,chr(13),''),chr(10),'') as orddate
,replace(replace(t1.condate,chr(13),''),chr(10),'') as condate
,replace(replace(t1.is_match,chr(13),''),chr(10),'') as is_match
,replace(replace(t1.settlemode,chr(13),''),chr(10),'') as settlemode
,replace(replace(t1.host_market,chr(13),''),chr(10),'') as host_market
,t1.spv_id as spv_id
,t1.process_type as process_type
,replace(replace(t1.clearing_date,chr(13),''),chr(10),'') as clearing_date
,replace(replace(t1.acctg_estd_completed,chr(13),''),chr(10),'') as acctg_estd_completed
,replace(replace(t1.acctg_real_completed,chr(13),''),chr(10),'') as acctg_real_completed
,replace(replace(t1.clearing_completed,chr(13),''),chr(10),'') as clearing_completed
,replace(replace(t1.is_period_inst,chr(13),''),chr(10),'') as is_period_inst
,replace(replace(t1.tsk_id,chr(13),''),chr(10),'') as tsk_id
,t1.approvestatus as approvestatus
,t1.bind_inst_id as bind_inst_id
,replace(replace(t1.trader,chr(13),''),chr(10),'') as trader
,t1.xcc_limit_type as xcc_limit_type
,replace(replace(t1.exh_extordid,chr(13),''),chr(10),'') as exh_extordid
,replace(replace(t1.create_user_id,chr(13),''),chr(10),'') as create_user_id

from ${iol_schema}.ibms_ttrd_set_instruction t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_set_instruction.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
