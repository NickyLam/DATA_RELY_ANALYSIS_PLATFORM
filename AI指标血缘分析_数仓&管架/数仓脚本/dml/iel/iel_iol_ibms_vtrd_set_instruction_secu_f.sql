: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_vtrd_set_instruction_secu_f
CreateDate: 20250408
FileName:   ${iel_data_path}/ibms_vtrd_set_instruction_secu.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,secu_inst_id
,secu_inst_grp_id
,inst_id
,replace(replace(t1.biz_type,chr(13),''),chr(10),'') as biz_type
,replace(replace(t1.direction,chr(13),''),chr(10),'') as direction
,replace(replace(t1.trade_grp_id,chr(13),''),chr(10),'') as trade_grp_id
,replace(replace(t1.secu_acct_id,chr(13),''),chr(10),'') as secu_acct_id
,replace(replace(t1.ext_secu_acct_id,chr(13),''),chr(10),'') as ext_secu_acct_id
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,real_fee
,estd_ai
,received_ai
,estd_cp
,real_ai
,real_cp
,due_ai
,due_cp
,prft_fee
,is_remain_due_ai
,is_remain_due_cp
,volume
,freeze_volume
,is_fixed
,replace(replace(t1.cal_date,chr(13),''),chr(10),'') as cal_date
,replace(replace(t1.set_date,chr(13),''),chr(10),'') as set_date
,replace(replace(t1.set_finish_date,chr(13),''),chr(10),'') as set_finish_date
,replace(replace(t1.i_name,chr(13),''),chr(10),'') as i_name
,replace(replace(t1.p_class,chr(13),''),chr(10),'') as p_class
,cost
,cost_ai_his_real
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
,amount
,replace(replace(t1.close_trade_id,chr(13),''),chr(10),'') as close_trade_id
,blc_state
,acctg_state
,estd_fee
,fee
,opr_state
,secu_inst_setgrp_id
,his_flag
,his_secu_inst_id
,replace(replace(t1.his_set_finish_date,chr(13),''),chr(10),'') as his_set_finish_date
,acctg_inst_id
,replace(replace(t1.cancel_flag,chr(13),''),chr(10),'') as cancel_flag
,volume_termcur
,amount_termcur
,estd_cp_termcur
,real_cp_termcur
,amrt_method
,real_margin
,replace(replace(t1.fpml,chr(13),''),chr(10),'') as fpml
,replace(replace(t1.is_impair,chr(13),''),chr(10),'') as is_impair
,replace(replace(t1.is_theory_acct,chr(13),''),chr(10),'') as is_theory_acct
,replace(replace(t1.is_theory_blc,chr(13),''),chr(10),'') as is_theory_blc
,cl_status
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

from ${iol_schema}.ibms_vtrd_set_instruction_secu t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_vtrd_set_instruction_secu.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
