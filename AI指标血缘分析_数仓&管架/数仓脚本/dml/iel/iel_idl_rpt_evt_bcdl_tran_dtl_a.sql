: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_rpt_evt_bcdl_tran_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/rpt_evt_bcdl_tran_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,lp_id
,cust_id
,corp_work_dt
,corp_flow_num
,corp_work_dt_batch
,corp_flow_num_batch
,work_dt_batch
,flow_num_batch
,tran_step_cd
,acct_dt
,check_entry_status_cd
,chn_cd
,chn_dt
,chn_flow_num
,core_tran_dt
,core_tran_flow_num
,init_sys_idf_id
,org_id
,pay_acct
,pay_acct_num_name
,recver_type_cd
,recvbl_num
,recvbl_num_acct_name
,recv_bank_no
,recv_bank_name
,curr_cd
,ec_idf_cd
,tran_amt
,comm_fee
,memo_cd
,postsc
,dtl_status_cd
,resp_code
,resp_info
,sync_rest_dt
,sync_rest_cnt
,sorc_sys_tran_timestamp from idl.rpt_evt_bcdl_tran_dtl where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/rpt_evt_bcdl_tran_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes