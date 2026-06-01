: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_bcdl_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_bcdl_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,t1.corp_work_dt as corp_work_dt
,replace(replace(t1.corp_flow_num,chr(13),''),chr(10),'') as corp_flow_num
,t1.corp_work_dt_batch as corp_work_dt_batch
,replace(replace(t1.corp_flow_num_batch,chr(13),''),chr(10),'') as corp_flow_num_batch
,t1.work_dt_batch as work_dt_batch
,replace(replace(t1.flow_num_batch,chr(13),''),chr(10),'') as flow_num_batch
,replace(replace(t1.tran_step_cd,chr(13),''),chr(10),'') as tran_step_cd
,t1.acct_dt as acct_dt
,replace(replace(t1.check_entry_status_cd,chr(13),''),chr(10),'') as check_entry_status_cd
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd
,t1.chn_dt as chn_dt
,replace(replace(t1.chn_flow_num,chr(13),''),chr(10),'') as chn_flow_num
,t1.core_tran_dt as core_tran_dt
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,replace(replace(t1.init_sys_idf_id,chr(13),''),chr(10),'') as init_sys_idf_id
,replace(replace(t1.org_id,chr(13),''),chr(10),'') as org_id
,replace(replace(t1.pay_acct,chr(13),''),chr(10),'') as pay_acct
,replace(replace(t1.pay_acct_num_name,chr(13),''),chr(10),'') as pay_acct_num_name
,replace(replace(t1.recver_type_cd,chr(13),''),chr(10),'') as recver_type_cd
,replace(replace(t1.recvbl_num,chr(13),''),chr(10),'') as recvbl_num
,replace(replace(t1.recvbl_num_acct_name,chr(13),''),chr(10),'') as recvbl_num_acct_name
,replace(replace(t1.recv_bank_no,chr(13),''),chr(10),'') as recv_bank_no
,replace(replace(t1.recv_bank_name,chr(13),''),chr(10),'') as recv_bank_name
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,t1.tran_amt as tran_amt
,t1.comm_fee as comm_fee
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.dtl_status_cd,chr(13),''),chr(10),'') as dtl_status_cd
,replace(replace(t1.resp_code,chr(13),''),chr(10),'') as resp_code
,replace(replace(t1.resp_info,chr(13),''),chr(10),'') as resp_info
,t1.sync_rest_dt as sync_rest_dt
,t1.sync_rest_cnt as sync_rest_cnt
,t1.sorc_sys_tran_timestamp as sorc_sys_tran_timestamp
from ${iml_schema}.evt_bcdl_tran_dtl t1
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt > to_date('${batch_date}','yyyymmdd')-15;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_bcdl_tran_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes