: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_set_instruction_secu_i
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_set_instruction_secu.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,t1.secu_inst_id as secu_inst_id
,t1.secu_inst_grp_id as secu_inst_grp_id
,t1.inst_id as inst_id
,replace(replace(t1.biz_type,chr(13),''),chr(10),'') as biz_type
,replace(replace(t1.direction,chr(13),''),chr(10),'') as direction
,replace(replace(t1.trade_grp_id,chr(13),''),chr(10),'') as trade_grp_id
,replace(replace(t1.secu_acct_id,chr(13),''),chr(10),'') as secu_acct_id
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.real_fee as real_fee
,t1.estd_ai as estd_ai
,t1.received_ai as received_ai
,t1.estd_cp as estd_cp
,t1.real_ai as real_ai
,t1.real_cp as real_cp
,t1.due_ai as due_ai
,t1.due_cp as due_cp
,t1.prft_fee as prft_fee
,t1.is_remain_due_ai as is_remain_due_ai
,t1.is_remain_due_cp as is_remain_due_cp
,t1.volume as volume
,t1.freeze_volume as freeze_volume
,t1.is_fixed as is_fixed
,replace(replace(t1.cal_date,chr(13),''),chr(10),'') as cal_date
,replace(replace(t1.set_date,chr(13),''),chr(10),'') as set_date
,replace(replace(t1.set_finish_date,chr(13),''),chr(10),'') as set_finish_date
,replace(replace(t1.i_name,chr(13),''),chr(10),'') as i_name
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,t1.cost as cost
,t1.cost_ai_his_real as cost_ai_his_real
,replace(replace(t1.zzd_acct_code,chr(13),''),chr(10),'') as zzd_acct_code
,replace(replace(t1.party_zzd_acct_code,chr(13),''),chr(10),'') as party_zzd_acct_code
,replace(replace(t1.create_time,chr(13),''),chr(10),'') as create_time
,replace(replace(t1.update_time,chr(13),''),chr(10),'') as update_time
,replace(replace(t1.update_user,chr(13),''),chr(10),'') as update_user
,replace(replace(t1.confirm_time,chr(13),''),chr(10),'') as confirm_time
,replace(replace(t1.confirm_user,chr(13),''),chr(10),'') as confirm_user
,replace(replace(t1.account_time,chr(13),''),chr(10),'') as account_time
,replace(replace(t1.account_user,chr(13),''),chr(10),'') as account_user
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,t1.amount as amount
,replace(replace(t1.close_trade_id,chr(13),''),chr(10),'') as close_trade_id
,t1.blc_state as blc_state
,t1.acctg_state as acctg_state
,t1.estd_fee as estd_fee
,t1.fee as fee
,t1.opr_state as opr_state
,t1.secu_inst_setgrp_id as secu_inst_setgrp_id
,t1.his_flag as his_flag
,t1.his_secu_inst_id as his_secu_inst_id
,replace(replace(t1.his_set_finish_date,chr(13),''),chr(10),'') as his_set_finish_date
,t1.acctg_inst_id as acctg_inst_id
,replace(replace(t1.cancel_flag,chr(13),''),chr(10),'') as cancel_flag
,t1.volume_termcur as volume_termcur
,t1.amount_termcur as amount_termcur
,t1.estd_cp_termcur as estd_cp_termcur
,t1.real_cp_termcur as real_cp_termcur
,t1.amrt_method as amrt_method
,t1.real_margin as real_margin
,replace(replace(t1.fpml,chr(13),''),chr(10),'') as fpml
,replace(replace(t1.is_impair,chr(13),''),chr(10),'') as is_impair
,replace(replace(t1.is_theory_acct,chr(13),''),chr(10),'') as is_theory_acct
,replace(replace(t1.is_theory_blc,chr(13),''),chr(10),'') as is_theory_blc
,t1.cl_status as cl_status
,replace(replace(t1.party_pset,chr(13),''),chr(10),'') as party_pset
,replace(replace(t1.party_pset_country,chr(13),''),chr(10),'') as party_pset_country
,replace(replace(t1.party_agent_code_type,chr(13),''),chr(10),'') as party_agent_code_type
,replace(replace(t1.party_agent_code_dss,chr(13),''),chr(10),'') as party_agent_code_dss
,replace(replace(t1.party_agent_code,chr(13),''),chr(10),'') as party_agent_code
,replace(replace(t1.party_agent_account,chr(13),''),chr(10),'') as party_agent_account
,replace(replace(t1.party_code_type,chr(13),''),chr(10),'') as party_code_type
,replace(replace(t1.party_code_dss,chr(13),''),chr(10),'') as party_code_dss
,replace(replace(t1.party_code,chr(13),''),chr(10),'') as party_code
,replace(replace(t1.party_account,chr(13),''),chr(10),'') as party_account
,t1.si_id as si_id
,replace(replace(t1.cal_start_date,chr(13),''),chr(10),'') as cal_start_date
,t1.ord_limit_secu_inst_id as ord_limit_secu_inst_id
,t1.estd_volume as estd_volume
,t1.estd_amount as estd_amount
,t1.is_calc_tax_4_prft_trd as is_calc_tax_4_prft_trd
,t1.module_type as module_type
,replace(replace(t1.party_pset_name,chr(13),''),chr(10),'') as party_pset_name
,t1.volume_geninst as volume_geninst
,replace(replace(t1.custom_dim1,chr(13),''),chr(10),'') as custom_dim1
,t1.xcc_module_type as xcc_module_type
,replace(replace(t1.is_editable,chr(13),''),chr(10),'') as is_editable
,replace(replace(t1.memo_secu,chr(13),''),chr(10),'') as memo_secu
,replace(replace(t1.dtl_due_type,chr(13),''),chr(10),'') as dtl_due_type

from ${iol_schema}.ibms_ttrd_set_instruction_secu t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_set_instruction_secu.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
