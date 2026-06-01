: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_otc_order_f_w
CreateDate: 20180529
FileName:   ${iel_data_path}/ibms_ttrd_otc_order_w.f.${batch_date}.dat
IF_mark:    f_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
replace(replace(orddate,chr(10),''),chr(13),'') as orddate
,replace(replace(ordtime,chr(10),''),chr(13),'') as ordtime
,replace(replace(ordstatus,chr(10),''),chr(13),'') as ordstatus
,replace(replace(errcode,chr(10),''),chr(13),'') as errcode
,replace(replace(errinfo,chr(10),''),chr(13),'') as errinfo
,replace(replace(total_amount,chr(10),''),chr(13),'') as total_amount
,replace(replace(used_amount,chr(10),''),chr(13),'') as used_amount
,replace(replace(remain_amount,chr(10),''),chr(13),'') as remain_amount
,replace(replace(pa_xml,chr(10),''),chr(13),'') as pa_xml
,replace(replace(beg_date,chr(10),''),chr(13),'') as beg_date
,replace(replace(end_date,chr(10),''),chr(13),'') as end_date
,replace(replace(createdate,chr(10),''),chr(13),'') as createdate
,replace(replace(effectdays,chr(10),''),chr(13),'') as effectdays
,replace(replace(agent_inst_id,chr(10),''),chr(13),'') as agent_inst_id
,replace(replace(isinclimit,chr(10),''),chr(13),'') as isinclimit
,replace(replace(investtype,chr(10),''),chr(13),'') as investtype
,replace(replace(ord_user_id,chr(10),''),chr(13),'') as ord_user_id
,replace(replace(ord_user,chr(10),''),chr(13),'') as ord_user
,replace(replace(muti_trade_ref,chr(10),''),chr(13),'') as muti_trade_ref
,replace(replace(cancel_amount,chr(10),''),chr(13),'') as cancel_amount
,replace(replace(order_type,chr(10),''),chr(13),'') as order_type
,replace(replace(ord_id,chr(10),''),chr(13),'') as ord_id
,replace(replace(remark,chr(10),''),chr(13),'') as remark
,replace(replace(min_effect_time,chr(10),''),chr(13),'') as min_effect_time
,replace(replace(max_effect_time,chr(10),''),chr(13),'') as max_effect_time
,replace(replace(direction,chr(10),''),chr(13),'') as direction
,replace(replace(i_code,chr(10),''),chr(13),'') as i_code
,replace(replace(a_type,chr(10),''),chr(13),'') as a_type
,replace(replace(m_type,chr(10),''),chr(13),'') as m_type
,replace(replace(wmps_unit_id,chr(10),''),chr(13),'') as wmps_unit_id
,replace(replace(currency,chr(10),''),chr(13),'') as currency
,replace(replace(limit_ytm,chr(10),''),chr(13),'') as limit_ytm
,replace(replace(limit_price,chr(10),''),chr(13),'') as limit_price
,replace(replace(min_term,chr(10),''),chr(13),'') as min_term
,replace(replace(max_term,chr(10),''),chr(13),'') as max_term
,replace(replace(last_modifier_id,chr(10),''),chr(13),'') as last_modifier_id
,replace(replace(last_modifier_time,chr(10),''),chr(13),'') as last_modifier_time
,replace(replace(spv_id,chr(10),''),chr(13),'') as spv_id
,replace(replace(f_trader_roleid,chr(10),''),chr(13),'') as f_trader_roleid
,replace(replace(disp_amount,chr(10),''),chr(13),'') as disp_amount
,replace(replace(undisp_amount,chr(10),''),chr(13),'') as undisp_amount
,replace(replace(abort_amount,chr(10),''),chr(13),'') as abort_amount
,replace(replace(accept_status,chr(10),''),chr(13),'') as accept_status
,replace(replace(abort_status,chr(10),''),chr(13),'') as abort_status
,replace(replace(exec_status,chr(10),''),chr(13),'') as exec_status
,replace(replace(exec_amount,chr(10),''),chr(13),'') as exec_amount
,replace(replace(unexec_amount,chr(10),''),chr(13),'') as unexec_amount
,replace(replace(asset_code,chr(10),''),chr(13),'') as asset_code
,replace(replace(i_name,chr(10),''),chr(13),'') as i_name
,replace(replace(bpm_status,chr(10),''),chr(13),'') as bpm_status
,replace(replace(bpm_type,chr(10),''),chr(13),'') as bpm_type
,replace(replace(cancel_ord_id,chr(10),''),chr(13),'') as cancel_ord_id
,replace(replace(sysordid,chr(10),''),chr(13),'') as sysordid
,replace(replace(remain_amount4confirm,chr(10),''),chr(13),'') as remain_amount4confirm
,replace(replace(out_state,chr(10),''),chr(13),'') as out_state
,replace(replace(task_ordinal,chr(10),''),chr(13),'') as task_ordinal
,replace(replace(cancelorback,chr(10),''),chr(13),'') as cancelorback
,replace(replace(remain_amount4quote,chr(10),''),chr(13),'') as remain_amount4quote
,replace(replace(relation_ord_id,chr(10),''),chr(13),'') as relation_ord_id
,replace(replace(cm_attr_master,chr(10),''),chr(13),'') as cm_attr_master
,replace(replace(cm_attr_relation,chr(10),''),chr(13),'') as cm_attr_relation
,replace(replace(is_for_cfets,chr(10),''),chr(13),'') as is_for_cfets
,replace(replace(match_mode,chr(10),''),chr(13),'') as match_mode
,replace(replace(xcc_submit_date,chr(10),''),chr(13),'') as xcc_submit_date
,replace(replace(xcc_completed_date,chr(10),''),chr(13),'') as xcc_completed_date
,replace(replace(xcc_withdraw_user,chr(10),''),chr(13),'') as xcc_withdraw_user
,start_dt
,end_dt
,id_mark
,etl_timestamp
from iol.ibms_ttrd_otc_order
where start_dt between to_date('${batch_date}', 'yyyymmdd') - 6 and to_date('${batch_date}', 'yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_otc_order_w.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes