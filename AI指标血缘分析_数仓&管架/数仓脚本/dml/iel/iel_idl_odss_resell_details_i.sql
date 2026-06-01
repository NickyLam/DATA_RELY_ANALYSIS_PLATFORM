: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_resell_details_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_resell_details_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,sell_type
,contract_id
,draft_id
,sellbiz_type
,central_bankflg
,resell_gale_date
,resell_back_date
,resell_rate_days
,ban_endrsmt_mk
,intrst_rate
,sell_interest
,real_money
,sttlm_mk
,rpd_open_dt
,rpd_due_dt
,rpd_intrate
,face_amount
,btch_no
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
,same_city_flag
,imitate_sell_flag
,inner_flag
,account_flag
,endst_date
,calc_status
,sell_status
,sig_mk
,cm_status
,cm_err_procd
,swt_biz_id
,operator_id
,txn_date
,entity_regstat
,entity_reg_id
,value1
,misc
,last_upd_oper_id
,last_upd_time
,req_remark
,rcv_remark
,ecds_prc_msg
,rcv_prxy_sgntr
,apply_date
,account_date
,cancel_date
,cancel_opid
,actlog_id
,trf_ref
,trf_id
,postpone_days
,intr_offset
from ${idl_schema}.odss_resell_details
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_resell_details_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes