: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_set_instruction_his_i
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_set_instruction_his.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select to_date('${batch_date}','yyyymmdd') as etl_dt
,t.inst_id as inst_id
,replace(replace(t.trade_id,chr(13),''),chr(10),'') as trade_id
,t.inst_type as inst_type
,t.inst_grp_id as inst_grp_id
,replace(replace(t.trd_type,chr(13),''),chr(10),'') as trd_type
,replace(replace(t.set_type,chr(13),''),chr(10),'') as set_type
,replace(replace(t.theory_set_date,chr(13),''),chr(10),'') as theory_set_date
,replace(replace(t.real_set_date,chr(13),''),chr(10),'') as real_set_date
,replace(replace(t.h_m_type,chr(13),''),chr(10),'') as h_m_type
,replace(replace(t.h_a_type,chr(13),''),chr(10),'') as h_a_type
,replace(replace(t.h_i_code,chr(13),''),chr(10),'') as h_i_code
,t.party_id as party_id
,replace(replace(t.party_name,chr(13),''),chr(10),'') as party_name
,replace(replace(t.order_id,chr(13),''),chr(10),'') as order_id
,replace(replace(t.is_theory_payment,chr(13),''),chr(10),'') as is_theory_payment
,replace(replace(t.bj_market,chr(13),''),chr(10),'') as bj_market
,t.bj_state as bj_state
,replace(replace(t.ext_ord_id,chr(13),''),chr(10),'') as ext_ord_id
,replace(replace(t.exe_market,chr(13),''),chr(10),'') as exe_market
,replace(replace(t.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t.account_time,chr(13),''),chr(10),'') as account_time
,replace(replace(t.account_user,chr(13),''),chr(10),'') as account_user
,replace(replace(t.memo,chr(13),''),chr(10),'') as memo
,replace(replace(t.update_user_id,chr(13),''),chr(10),'') as update_user_id
,replace(replace(t.cal_date,chr(13),''),chr(10),'') as cal_date
,t.ref_cash_inst_id as ref_cash_inst_id
,t.ref_secu_inst_id as ref_secu_inst_id
,t.inst_setgrp_id as inst_setgrp_id
,t.state as state
,replace(replace(t.operator_id,chr(13),''),chr(10),'') as operator_id
,replace(replace(t.operator_name,chr(13),''),chr(10),'') as operator_name
,t.print_times as print_times
,replace(replace(t.due_order,chr(13),''),chr(10),'') as due_order
,t.due_obj_key as due_obj_key
,t.generate_type as generate_type
,t.ref_inst_id as ref_inst_id
,replace(replace(t.is_real_acctg,chr(13),''),chr(10),'') as is_real_acctg
,t.real_account_inst_id as real_account_inst_id
,replace(replace(t.is_unknown_price,chr(13),''),chr(10),'') as is_unknown_price
,t.his_flag as his_flag
,replace(replace(t.cash_acct_id,chr(13),''),chr(10),'') as cash_acct_id
,t.his_inst_id as his_inst_id
,t.his_ref_inst_id as his_ref_inst_id
,replace(replace(t.is_operator_checked,chr(13),''),chr(10),'') as is_operator_checked
,replace(replace(t.orddate,chr(13),''),chr(10),'') as orddate
,replace(replace(t.condate,chr(13),''),chr(10),'') as condate
,replace(replace(t.is_match,chr(13),''),chr(10),'') as is_match
,replace(replace(t.settlemode,chr(13),''),chr(10),'') as settlemode
,replace(replace(t.host_market,chr(13),''),chr(10),'') as host_market
,t.spv_id as spv_id
,t.process_type as process_type
,replace(replace(t.clearing_date,chr(13),''),chr(10),'') as clearing_date
,replace(replace(t.acctg_estd_completed,chr(13),''),chr(10),'') as acctg_estd_completed
,replace(replace(t.acctg_real_completed,chr(13),''),chr(10),'') as acctg_real_completed
,replace(replace(t.clearing_completed,chr(13),''),chr(10),'') as clearing_completed
,replace(replace(t.is_period_inst,chr(13),''),chr(10),'') as is_period_inst
,replace(replace(t.tsk_id,chr(13),''),chr(10),'') as tsk_id
,t.approvestatus as approvestatus
,t.bind_inst_id as bind_inst_id
,replace(replace(t.trader,chr(13),''),chr(10),'') as trader
,t.xcc_limit_type as xcc_limit_type
,replace(replace(t.exh_extordid,chr(13),''),chr(10),'') as exh_extordid
,replace(replace(t.create_user_id,chr(13),''),chr(10),'') as create_user_id
from ${iol_schema}.IBMS_TTRD_SET_INSTRUCTION_HIS t 
where replace(REAL_SET_DATE,'-','')='${batch_date}';" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_set_instruction_his.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes