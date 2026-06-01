: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_ibms_ttrd_otc_order_f
CreateDate: 20221013
FileName:   ${iel_data_path}/ibms_ttrd_otc_order.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.orddate,chr(13),''),chr(10),'') as orddate
,replace(replace(t1.ordtime,chr(13),''),chr(10),'') as ordtime
,t1.ordstatus as ordstatus
,t1.errcode as errcode
,replace(replace(t1.errinfo,chr(13),''),chr(10),'') as errinfo
,t1.total_amount as total_amount
,t1.used_amount as used_amount
,t1.remain_amount as remain_amount
,replace(replace(t1.pa_xml,chr(13),''),chr(10),'') as pa_xml
,replace(replace(t1.beg_date,chr(13),''),chr(10),'') as beg_date
,replace(replace(t1.end_date,chr(13),''),chr(10),'') as end_date
,replace(replace(t1.createdate,chr(13),''),chr(10),'') as createdate
,t1.effectdays as effectdays
,replace(replace(t1.agent_inst_id,chr(13),''),chr(10),'') as agent_inst_id
,t1.isinclimit as isinclimit
,replace(replace(t1.investtype,chr(13),''),chr(10),'') as investtype
,replace(replace(t1.ord_user_id,chr(13),''),chr(10),'') as ord_user_id
,replace(replace(t1.ord_user,chr(13),''),chr(10),'') as ord_user
,t1.muti_trade_ref as muti_trade_ref
,t1.cancel_amount as cancel_amount
,t1.order_type as order_type
,replace(replace(t1.ord_id,chr(13),''),chr(10),'') as ord_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.min_effect_time,chr(13),''),chr(10),'') as min_effect_time
,replace(replace(t1.max_effect_time,chr(13),''),chr(10),'') as max_effect_time
,replace(replace(t1.direction,chr(13),''),chr(10),'') as direction
,replace(replace(t1.i_code,chr(13),''),chr(10),'') as i_code
,replace(replace(t1.a_type,chr(13),''),chr(10),'') as a_type
,replace(replace(t1.m_type,chr(13),''),chr(10),'') as m_type
,t1.wmps_unit_id as wmps_unit_id
,replace(replace(t1.currency,chr(13),''),chr(10),'') as currency
,t1.limit_ytm as limit_ytm
,t1.limit_price as limit_price
,t1.min_term as min_term
,t1.max_term as max_term
,t1.last_modifier_id as last_modifier_id
,t1.last_modifier_time as last_modifier_time
,t1.spv_id as spv_id
,t1.f_trader_roleid as f_trader_roleid
,t1.disp_amount as disp_amount
,t1.undisp_amount as undisp_amount
,t1.abort_amount as abort_amount
,t1.accept_status as accept_status
,t1.abort_status as abort_status
,t1.exec_status as exec_status
,t1.exec_amount as exec_amount
,t1.unexec_amount as unexec_amount
,replace(replace(t1.asset_code,chr(13),''),chr(10),'') as asset_code
,replace(replace(t1.i_name,chr(13),''),chr(10),'') as i_name
,t1.bpm_status as bpm_status
,t1.bpm_type as bpm_type
,t1.cancel_ord_id as cancel_ord_id
,t1.sysordid as sysordid
,t1.remain_amount4confirm as remain_amount4confirm
,t1.out_state as out_state
,t1.task_ordinal as task_ordinal
,replace(replace(t1.cancelorback,chr(13),''),chr(10),'') as cancelorback
,t1.remain_amount4quote as remain_amount4quote
,replace(replace(t1.relation_ord_id,chr(13),''),chr(10),'') as relation_ord_id
,replace(replace(t1.cm_attr_master,chr(13),''),chr(10),'') as cm_attr_master
,replace(replace(t1.cm_attr_relation,chr(13),''),chr(10),'') as cm_attr_relation
,replace(replace(t1.is_for_cfets,chr(13),''),chr(10),'') as is_for_cfets
,replace(replace(t1.match_mode,chr(13),''),chr(10),'') as match_mode
,replace(replace(t1.xcc_submit_date,chr(13),''),chr(10),'') as xcc_submit_date
,replace(replace(t1.xcc_completed_date,chr(13),''),chr(10),'') as xcc_completed_date
,replace(replace(t1.xcc_withdraw_user,chr(13),''),chr(10),'') as xcc_withdraw_user

from ${iol_schema}.ibms_ttrd_otc_order t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/ibms_ttrd_otc_order.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
