: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_pirs_f_evt_bms_accept_due_pay_i
CreateDate: 20180529
FileName:   ${iel_data_path}/pirs_f_evt_bms_accept_due_pay_${batch_date}_i.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select id
,branch_id
,draft_id
,isse_curcd
,isse_amt
,mesg_type
,apply_date
,ovrdue_rsn
,apply_curcd
,apply_amt
,sttlm_mk
,voc_cnt
,drft_hldr_role
,drft_hldr_cmonid
,drft_hldr_name
,drft_hldr_actno
,drft_hldr_ubank
,drft_hldr_agcy_ubank
,accept_date
,accept_curcd
,accept_amount
,return_customer_name
,customer_account
,receive_date
,reply_date
,operator_id
,repay_sig_mk
,dish_code
,dish_rsn
,appstatus
,acpay_status
,endst_date
,sig_mk
,cm_status
,cm_err_procd
,account_flag
,swt_biz_id
,entity_regstat
,entity_reg_id
,appno
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
,actlog_id
,trf_id
,trf_ref
,storage_flag
,storage_dtl_id from idl.pirs_f_evt_bms_accept_due_pay where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="|#|" record="0x0a"  \
        file="${iel_data_path}/pirs_f_evt_bms_accept_due_pay_${batch_date}_i.dat" \
        charset=zhs16gbk
        safe=yes