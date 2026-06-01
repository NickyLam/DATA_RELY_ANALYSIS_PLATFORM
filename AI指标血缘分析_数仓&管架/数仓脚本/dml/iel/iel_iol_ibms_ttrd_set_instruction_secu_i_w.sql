: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_set_instruction_secu_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_set_instruction_secu_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(secu_inst_id,chr(10),''),chr(13),'') as secu_inst_id
,replace(replace(secu_inst_grp_id,chr(10),''),chr(13),'') as secu_inst_grp_id
,replace(replace(inst_id,chr(10),''),chr(13),'') as inst_id
,replace(replace(biz_type,chr(10),''),chr(13),'') as biz_type
,replace(replace(direction,chr(10),''),chr(13),'') as direction
,replace(replace(trade_grp_id,chr(10),''),chr(13),'') as trade_grp_id
,replace(replace(secu_acct_id,chr(10),''),chr(13),'') as secu_acct_id
,replace(replace(ext_secu_acct_id,chr(10),''),chr(13),'') as ext_secu_acct_id
,replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(real_fee,chr(10),''),chr(13),'') as real_fee
,replace(replace(estd_ai,chr(10),''),chr(13),'') as estd_ai
,replace(replace(received_ai,chr(10),''),chr(13),'') as received_ai
,replace(replace(estd_cp,chr(10),''),chr(13),'') as estd_cp
,replace(replace(real_ai,chr(10),''),chr(13),'') as real_ai
,replace(replace(real_cp,chr(10),''),chr(13),'') as real_cp
,replace(replace(due_ai,chr(10),''),chr(13),'') as due_ai
,replace(replace(due_cp,chr(10),''),chr(13),'') as due_cp
,replace(replace(prft_fee,chr(10),''),chr(13),'') as prft_fee
,replace(replace(is_remain_due_ai,chr(10),''),chr(13),'') as is_remain_due_ai
,replace(replace(is_remain_due_cp,chr(10),''),chr(13),'') as is_remain_due_cp
,replace(replace(volume,chr(10),''),chr(13),'') as volume
,replace(replace(freeze_volume,chr(10),''),chr(13),'') as freeze_volume
,replace(replace(is_fixed,chr(10),''),chr(13),'') as is_fixed
,replace(replace(cal_date,chr(10),''),chr(13),'') as cal_date
,replace(replace(set_date,chr(10),''),chr(13),'') as set_date
,replace(replace(set_finish_date,chr(10),''),chr(13),'') as set_finish_date
,replace(replace(i_name,chr(10),''),chr(13),'') as i_name
,replace(replace(p_class,chr(10),''),chr(13),'') as p_class
,replace(replace(cost,chr(10),''),chr(13),'') as cost
,replace(replace(cost_ai_his_real,chr(10),''),chr(13),'') as cost_ai_his_real
,replace(replace(zzd_acct_code,chr(10),''),chr(13),'') as zzd_acct_code
,replace(replace(party_zzd_acct_code,chr(10),''),chr(13),'') as party_zzd_acct_code
,replace(replace(create_time,chr(10),''),chr(13),'') as create_time
,replace(replace(update_time,chr(10),''),chr(13),'') as update_time
,replace(replace(update_user,chr(10),''),chr(13),'') as update_user
,replace(replace(confirm_time,chr(10),''),chr(13),'') as confirm_time
,replace(replace(confirm_user,chr(10),''),chr(13),'') as confirm_user
,replace(replace(account_time,chr(10),''),chr(13),'') as account_time
,replace(replace(account_user,chr(10),''),chr(13),'') as account_user
,replace(replace(memo,chr(10),''),chr(13),'') as memo
,replace(replace(amount,chr(10),''),chr(13),'') as amount
,replace(replace(close_trade_id,chr(10),''),chr(13),'') as close_trade_id
,replace(replace(blc_state,chr(10),''),chr(13),'') as blc_state
,replace(replace(acctg_state,chr(10),''),chr(13),'') as acctg_state
,replace(replace(estd_fee,chr(10),''),chr(13),'') as estd_fee
,replace(replace(fee,chr(10),''),chr(13),'') as fee
,replace(replace(opr_state,chr(10),''),chr(13),'') as opr_state
,replace(replace(secu_inst_setgrp_id,chr(10),''),chr(13),'') as secu_inst_setgrp_id
,replace(replace(his_flag,chr(10),''),chr(13),'') as his_flag
,replace(replace(his_secu_inst_id,chr(10),''),chr(13),'') as his_secu_inst_id
,replace(replace(his_set_finish_date,chr(10),''),chr(13),'') as his_set_finish_date
,replace(replace(acctg_inst_id,chr(10),''),chr(13),'') as acctg_inst_id
,replace(replace(cancel_flag,chr(10),''),chr(13),'') as cancel_flag
,replace(replace(volume_termcur,chr(10),''),chr(13),'') as volume_termcur
,replace(replace(amount_termcur,chr(10),''),chr(13),'') as amount_termcur
,replace(replace(estd_cp_termcur,chr(10),''),chr(13),'') as estd_cp_termcur
,replace(replace(real_cp_termcur,chr(10),''),chr(13),'') as real_cp_termcur
,replace(replace(amrt_method,chr(10),''),chr(13),'') as amrt_method
,replace(replace(real_margin,chr(10),''),chr(13),'') as real_margin
,replace(replace(fpml,chr(10),''),chr(13),'') as fpml
,replace(replace(is_impair,chr(10),''),chr(13),'') as is_impair
,replace(replace(is_theory_acct,chr(10),''),chr(13),'') as is_theory_acct
,replace(replace(is_theory_blc,chr(10),''),chr(13),'') as is_theory_blc
,replace(replace(cl_status,chr(10),''),chr(13),'') as cl_status
,replace(replace(party_pset,chr(10),''),chr(13),'') as party_pset
,replace(replace(party_pset_country,chr(10),''),chr(13),'') as party_pset_country
,replace(replace(party_agent_code_type,chr(10),''),chr(13),'') as party_agent_code_type
,replace(replace(party_agent_code_dss,chr(10),''),chr(13),'') as party_agent_code_dss
,replace(replace(party_agent_code,chr(10),''),chr(13),'') as party_agent_code
,replace(replace(party_agent_account,chr(10),''),chr(13),'') as party_agent_account
,replace(replace(party_code_type,chr(10),''),chr(13),'') as party_code_type
,replace(replace(party_code_dss,chr(10),''),chr(13),'') as party_code_dss
,replace(replace(party_code,chr(10),''),chr(13),'') as party_code
,replace(replace(party_account,chr(10),''),chr(13),'') as party_account
,replace(replace(si_id,chr(10),''),chr(13),'') as si_id
,replace(replace(cal_start_date,chr(10),''),chr(13),'') as cal_start_date
,replace(replace(ord_limit_secu_inst_id,chr(10),''),chr(13),'') as ord_limit_secu_inst_id
,replace(replace(estd_volume,chr(10),''),chr(13),'') as estd_volume
,replace(replace(estd_amount,chr(10),''),chr(13),'') as estd_amount
,replace(replace(is_calc_tax_4_prft_trd,chr(10),''),chr(13),'') as is_calc_tax_4_prft_trd
,replace(replace(module_type,chr(10),''),chr(13),'') as module_type
,replace(replace(party_pset_name,chr(10),''),chr(13),'') as party_pset_name
,replace(replace(volume_geninst,chr(10),''),chr(13),'') as volume_geninst
,replace(replace(custom_dim1,chr(10),''),chr(13),'') as custom_dim1
,replace(replace(xcc_module_type,chr(10),''),chr(13),'') as xcc_module_type
,replace(replace(is_editable,chr(10),''),chr(13),'') as is_editable
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_set_instruction_secu
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_set_instruction_secu_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes