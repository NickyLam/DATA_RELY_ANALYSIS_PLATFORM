: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_hdws_ibms_ttrd_set_instruction_his_i
CreateDate: 20180529
FileName:   ${iel_data_path}/hdws_ibms_ttrd_set_instruction_his.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select t1.inst_id
,t1.trade_id
,t1.inst_type
,t1.inst_grp_id
,t1.trd_type
,t1.set_type
,t1.theory_set_date
,t1.real_set_date
,t1.h_m_type
,t1.h_a_type
,t1.h_i_code
,t1.party_id
,t1.party_name
,t1.order_id
,t1.is_theory_payment
,t1.bj_market
,t1.bj_state
,t1.ext_ord_id
,t1.exe_market
,t1.create_time
,t1.update_time
,t1.update_user
,t1.account_time
,t1.account_user
,t1.memo
,t1.update_user_id
,t1.cal_date
,t1.ref_cash_inst_id
,t1.ref_secu_inst_id
,t1.inst_setgrp_id
,t1.state
,t1.operator_id
,t1.operator_name
,t1.print_times
,t1.due_order
,t1.due_obj_key
,t1.generate_type
,t1.ref_inst_id
,t1.is_real_acctg
,t1.real_account_inst_id
,t1.is_unknown_price
,t1.his_flag
,t1.cash_acct_id
,t1.his_inst_id
,t1.his_ref_inst_id
,t1.is_operator_checked
,t1.orddate
,t1.condate
,t1.is_match
,t1.settlemode
,t1.host_market
,t1.spv_id
,t1.clearing_date
,t1.acctg_estd_completed
,t1.acctg_real_completed
,t1.clearing_completed
,t1.is_period_inst
,t1.tsk_id
,t1.approvestatus
,t1.bind_inst_id
,t1.trader
,t1.q_accname
,t1.q_secu_acct_id
,t1.q_party_zzd_acct_code
,t1.q_p_type
,t1.q_p_class
,t1.q_currency
,t1.q_i_name
,t1.q_i_id
,t1.q_settle_amount
,t1.q_two_effective_contract
,t1.trade_orddate
,t1.trade_ids
,t1.order_ids
,t1.trade_ref_type
,t1.q_description
,t1.process_type
,t1.is_refreshable
,t1.xcc_limit_type
,t1.exh_extordid
,t1.create_user_id
from ${idl_schema}.hdws_ibms_ttrd_set_instruction_his t1 
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/hdws_ibms_ttrd_set_instruction_his.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes