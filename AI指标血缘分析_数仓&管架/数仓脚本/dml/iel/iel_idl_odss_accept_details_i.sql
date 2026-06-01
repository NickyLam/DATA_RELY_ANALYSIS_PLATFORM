: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_accept_details_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_accept_details_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,contract_id
,seq_no
,draft_id
,task_type
,credit_fee
,charge
,expenses
,ucondl_consgntmrk
,contractno
,invc_nb
,btch_nb
,payment_ubank_id
,credit_line_id
,credit_line
,credit_line_status
,accept_status
,endst_date
,account_flag
,print_status
,print_date
,sig_mk
,cm_status
,cm_err_procd
,swt_biz_id
,entity_regstat
,entity_reg_id
,misc
,last_upd_oper_id
,last_upd_time
,req_remark
,rcv_remark
,ecds_prc_msg
,rcv_prxy_sgntr
,account_date
,cancel_date
,actlog_id
,cdt_ratgs
,cdt_ratg_agcy
,cdt_ratg_due_dt
,accptnc_agrmtnb
,run_code
,accp_detail_remark
from ${idl_schema}.odss_accept_details
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_accept_details_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes