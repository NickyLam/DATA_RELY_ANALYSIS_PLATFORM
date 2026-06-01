: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_vtrd_set_instruction_f
CreateDate: 20250408
FileName:   ${iel_data_path}/ibms_vtrd_set_instruction.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,inst_id
,replace(replace(t1.trade_id,chr(13),''),chr(10),'') as trade_id
,inst_type
,inst_grp_id
,replace(replace(t1.trd_type,chr(13),''),chr(10),'') as trd_type
,replace(replace(t1.set_type,chr(13),''),chr(10),'') as set_type
,replace(replace(t1.theory_set_date,chr(13),''),chr(10),'') as theory_set_date
,replace(replace(t1.real_set_date,chr(13),''),chr(10),'') as real_set_date
,replace(replace(t1.h_m_type,chr(13),''),chr(10),'') as h_m_type
,replace(replace(t1.h_a_type,chr(13),''),chr(10),'') as h_a_type
,replace(replace(t1.h_i_code,chr(13),''),chr(10),'') as h_i_code
,party_id
,replace(replace(t1.party_name,chr(13),''),chr(10),'') as party_name
,replace(replace(t1.order_id,chr(13),''),chr(10),'') as order_id
,replace(replace(t1.is_theory_payment,chr(13),''),chr(10),'') as is_theory_payment
,replace(replace(t1.bj_market,chr(13),''),chr(10),'') as bj_market
,bj_state
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
,ref_cash_inst_id
,ref_secu_inst_id
,inst_setgrp_id
,state
,replace(replace(t1.operator_id,chr(13),''),chr(10),'') as operator_id
,replace(replace(t1.operator_name,chr(13),''),chr(10),'') as operator_name
,print_times
,replace(replace(t1.due_order,chr(13),''),chr(10),'') as due_order
,due_obj_key
,generate_type
,ref_inst_id
,replace(replace(t1.is_real_acctg,chr(13),''),chr(10),'') as is_real_acctg

from ${iol_schema}.ibms_vtrd_set_instruction t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_vtrd_set_instruction.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
