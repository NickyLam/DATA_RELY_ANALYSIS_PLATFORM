: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_irrs_f_evt_bms_buy_details_i
CreateDate: 20180529
FileName:   ${iel_data_path}/irrs_f_evt_bms_buy_details_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
id
,task_type
,buy_type
,buy_contract_id
,draft_id
,buybiz_type
,central_bankflg
,inner_flag
,same_city_flag
,virtual_flag
,previous_hand
,payment_date
,postpone_days
,payment_days
,ban_endrsmt_mk
,rpd_open_dt
,rpd_due_dt
,rpd_intrate
,intrst_rate
,payment_maturity
,sttlm_mk
,req_remark
,rcv_remark
,payment_by_buyer
,pay_amount
,risk_fees
,credit_line_id
,credit_line
,apply_date
,aoaccninf_actno
,aoaccninf_ubank
,dscnt_props_role
,dscnt_props_name
,dscnt_props_cmonid
,dscnt_props_actno
,dscnt_props_ubank
,dscnt_props_agcy_ubank
,dscnt_role
,dscnt_cmonid
,dscnt_name
,dscnt_actno
,dscnt_ubank
,contractno
,invc_nb
,btch_no
,credit_line_status
,accept_status
,check_status
,query_order
,query_content
,query_type
,check_result
,check_content
,query_check_id
,flaw_status
,disaffirm_status
,rcv_prxy_sgntr
,account_date
,account_flag
,actlog_id
,account
,endst_date
,cancel_date
,interest_status
,calc_status
,buy_status
,sig_mk
,cm_status
,cm_err_procd
,ecds_prc_msg
,trf_ref
,trf_id
,swt_biz_id
,entity_regstat
,entity_reg_id
,value1
,misc
,last_upd_oper_id
,last_upd_time
,intr_offset
,storage_flag
,storage_dtl_id
,run_code
from idl.irrs_f_evt_bms_buy_details
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/irrs_f_evt_bms_buy_details_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes