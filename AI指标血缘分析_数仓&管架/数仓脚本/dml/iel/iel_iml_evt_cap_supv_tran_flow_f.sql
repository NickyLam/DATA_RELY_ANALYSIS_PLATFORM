: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_cap_supv_tran_flow_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_cap_supv_tran_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,t1.tran_tm as tran_tm
,replace(replace(t1.coprator_id,chr(13),''),chr(10),'') as coprator_id
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t1.intnal_cust_name,chr(13),''),chr(10),'') as intnal_cust_name
,replace(replace(t1.vtual_acct_id,chr(13),''),chr(10),'') as vtual_acct_id
,replace(replace(t1.vtual_acct_type_cd,chr(13),''),chr(10),'') as vtual_acct_type_cd
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.trdpty_flow_num,chr(13),''),chr(10),'') as trdpty_flow_num
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num
,replace(replace(t1.payer_intnal_cust_id,chr(13),''),chr(10),'') as payer_intnal_cust_id
,replace(replace(t1.payer_vtual_acct_id,chr(13),''),chr(10),'') as payer_vtual_acct_id
,replace(replace(t1.payer_bank_acct_name,chr(13),''),chr(10),'') as payer_bank_acct_name
,replace(replace(t1.payer_bank_acct_id,chr(13),''),chr(10),'') as payer_bank_acct_id
,replace(replace(t1.payer_open_bank_name,chr(13),''),chr(10),'') as payer_open_bank_name
,replace(replace(t1.payer_open_bank_id,chr(13),''),chr(10),'') as payer_open_bank_id
,replace(replace(t1.payer_open_ghb_flg,chr(13),''),chr(10),'') as payer_open_ghb_flg
,replace(replace(t1.recver_intnal_cust_id,chr(13),''),chr(10),'') as recver_intnal_cust_id
,replace(replace(t1.recver_vtual_acct_id,chr(13),''),chr(10),'') as recver_vtual_acct_id
,t1.guar_amt as guar_amt
,t1.guar_surp_amt as guar_surp_amt
,t1.avl_amt as avl_amt
,replace(replace(t1.recver_bank_acct_name,chr(13),''),chr(10),'') as recver_bank_acct_name
,replace(replace(t1.recver_bank_acct_id,chr(13),''),chr(10),'') as recver_bank_acct_id
,replace(replace(t1.recver_open_bank_name,chr(13),''),chr(10),'') as recver_open_bank_name
,replace(replace(t1.recver_open_bank_id,chr(13),''),chr(10),'') as recver_open_bank_id
,replace(replace(t1.mode_pay,chr(13),''),chr(10),'') as mode_pay
,replace(replace(t1.refund_idf_cd,chr(13),''),chr(10),'') as refund_idf_cd
,replace(replace(t1.refund_src_flow_num,chr(13),''),chr(10),'') as refund_src_flow_num
,replace(replace(t1.refund_src_sub_flow_num,chr(13),''),chr(10),'') as refund_src_sub_flow_num
,t1.comm_fee as comm_fee
,t1.pay_amt as pay_amt
,t1.actl_bal as actl_bal
,t1.aval_bal as aval_bal
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t1.check_code,chr(13),''),chr(10),'') as check_code
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,t1.clear_dt as clear_dt
,replace(replace(t1.core_tran_flow_num,chr(13),''),chr(10),'') as core_tran_flow_num
,t1.core_tran_dt as core_tran_dt
,t1.recge_rest_advise_cnt as recge_rest_advise_cnt
,replace(replace(t1.recge_rest_advise_status_cd,chr(13),''),chr(10),'') as recge_rest_advise_status_cd
,t1.recge_rest_advise_tm as recge_rest_advise_tm
,replace(replace(t1.bank_batch_id,chr(13),''),chr(10),'') as bank_batch_id
,replace(replace(t1.trdpty_batch_id,chr(13),''),chr(10),'') as trdpty_batch_id
,replace(replace(t1.memo,chr(13),''),chr(10),'') as memo
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from ${iml_schema}.evt_cap_supv_tran_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_cap_supv_tran_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes