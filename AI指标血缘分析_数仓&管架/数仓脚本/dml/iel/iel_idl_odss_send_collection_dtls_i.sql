: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_odss_send_collection_dtls_i
CreateDate: 20180529
FileName:   ${iel_data_path}/odss_send_collection_dtls_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
id
,batch_id
,branch_id
,send_date
,draft_id
,isse_curcd
,isse_amt
,drft_hldr_cmonid
,apply_amt
,mesg_type
,sttlm_mk
,drft_hldr_role
,apply_date
,ovrdue_rsn
,apply_curcd
,drft_hldr_name
,drft_hldr_actno
,drft_hldr_ubank
,drft_hldr_agcy_ubank
,prompt_status
,endst_date
,receive_date
,sig_mk
,dish_code
,dish_rsn
,cm_status
,cm_err_procd
,account_flag
,swt_biz_id
,entity_regstat
,entity_reg_id
,misc
,last_upd_oper_id
,last_upd_time
,req_remark
,rcv_remark
,ecds_prc_msg
,req_prxy_prop_stn
,rcv_prxy_sgntr
,account_date
,cancel_date
,cancel_opid
,actlog_id
,trf_ref
,trf_id
,src_type
,core_account
,due_flag
,payment_amout
,discount_amount
from ${idl_schema}.odss_send_collection_dtls
where etl_dt=to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/odss_send_collection_dtls_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes