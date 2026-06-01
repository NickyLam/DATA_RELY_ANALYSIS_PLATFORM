: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_evt_onl_bank_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_evt_onl_bank_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select evt_id
,lp_id
,tran_flow_num
,whole_unify_cust_id
,tran_tm
,tran_code
,tran_oper_type_cd
,tran_return_code
,fail_rs
,tran_amt
,curr_cd
,comm_fee
,pay_acct_num
,pay_acct_name
,pay_acct_type_cd
,recvbl_num
,recvbl_num_name
,recvbl_acct_type_cd
,recver_bank_no
,recver_bank_name
,recver_prov_cd
,recver_prov_name
,recver_city_cd
,recver_city_name
,plan_fomult_tm
,plan_type_cd
,tran_freq_cd
,next_exec_dt
,precon_plan_status_cd
,tm_or_ff_begin_dt
,tm_or_ff_closing_dt
,lmt_attr_cd
,save_cert_way_cd
,usage_comnt
,onl_bank_tran_flow_num
,recver_nickna
,atm_equip_id
,st_msg_advise_mobile_no
,brac_id
,brac_name
,dept_cd
,tran_out_route_id
,remit_way_id
,remit_way_name
,next_day_tran_out_flg
,tran_mobile_no
,crdt_card_repay_flg
,user_seq_id
,remark
,etl_dt
,job_cd from idl.rpt_evt_onl_bank_tran_dtl where etl_dt =to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_evt_onl_bank_tran_dtl.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes