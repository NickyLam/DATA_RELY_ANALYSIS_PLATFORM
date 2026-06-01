: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_agt_bid_margin_enter_acct_info_h_f
CreateDate: 20230927
FileName:   ${iel_data_path}/agt_bid_margin_enter_acct_info_h.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.agt_id,chr(13),''),chr(10),'') as agt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.midgrod_tran_flow_num,chr(13),''),chr(10),'') as midgrod_tran_flow_num
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,midgrod_dt
,replace(replace(t1.chn_sys_cd,chr(13),''),chr(10),'') as chn_sys_cd
,chn_tran_dt
,replace(replace(t1.chn_tran_flow_num,chr(13),''),chr(10),'') as chn_tran_flow_num
,replace(replace(t1.chn_org_id,chr(13),''),chr(10),'') as chn_org_id
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.debit_crdt_flg,chr(13),''),chr(10),'') as debit_crdt_flg
,replace(replace(t1.oper_type_cd,chr(13),''),chr(10),'') as oper_type_cd
,avl_tm
,avl_amt
,replace(replace(t1.advise_status_cd,chr(13),''),chr(10),'') as advise_status_cd
,replace(replace(t1.fin_status_cd,chr(13),''),chr(10),'') as fin_status_cd
,replace(replace(t1.aldy_check_entry_flg,chr(13),''),chr(10),'') as aldy_check_entry_flg
,replace(replace(t1.refund_flg,chr(13),''),chr(10),'') as refund_flg
,replace(replace(t1.pay_acct_id,chr(13),''),chr(10),'') as pay_acct_id
,replace(replace(t1.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name
,replace(replace(t1.payer_open_bank_num,chr(13),''),chr(10),'') as payer_open_bank_num
,replace(replace(t1.payer_open_bank_name,chr(13),''),chr(10),'') as payer_open_bank_name
,replace(replace(t1.recvbl_acct_id,chr(13),''),chr(10),'') as recvbl_acct_id
,replace(replace(t1.recvbl_acct_name,chr(13),''),chr(10),'') as recvbl_acct_name
,replace(replace(t1.stl_acct_id,chr(13),''),chr(10),'') as stl_acct_id
,replace(replace(t1.stl_acct_name,chr(13),''),chr(10),'') as stl_acct_name
,stl_acct_bal
,replace(replace(t1.margin_acct_status_cd,chr(13),''),chr(10),'') as margin_acct_status_cd
,core_entry_tran_dt
,replace(replace(t1.core_entry_host_flow_num,chr(13),''),chr(10),'') as core_entry_host_flow_num
,replace(replace(t1.core_entry_tran_flow_num,chr(13),''),chr(10),'') as core_entry_tran_flow_num
,replace(replace(t1.core_entry_status,chr(13),''),chr(10),'') as core_entry_status
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd
,replace(replace(t1.f_r_acct_up_host_return_code,chr(13),''),chr(10),'') as f_r_acct_up_host_return_code
,replace(replace(t1.f_r_acct_host_return_info,chr(13),''),chr(10),'') as f_r_acct_host_return_info
,f_r_acct_host_dt
,replace(replace(t1.f_r_acct_host_flow,chr(13),''),chr(10),'') as f_r_acct_host_flow
,replace(replace(t1.open_acct_status_cd,chr(13),''),chr(10),'') as open_acct_status_cd
,open_acct_dt
,replace(replace(t1.open_acct_host_flow_num,chr(13),''),chr(10),'') as open_acct_host_flow_num
,open_acct_host_dt
,replace(replace(t1.open_acct_uphost_flow,chr(13),''),chr(10),'') as open_acct_uphost_flow
,replace(replace(t1.open_acct_host_return_code,chr(13),''),chr(10),'') as open_acct_host_return_code
,replace(replace(t1.open_acct_host_return_info,chr(13),''),chr(10),'') as open_acct_host_return_info
,replace(replace(t1.open_bank_name,chr(13),''),chr(10),'') as open_bank_name
,trdpty_tran_dt
,replace(replace(t1.trdpty_flow_num,chr(13),''),chr(10),'') as trdpty_flow_num
,replace(replace(t1.rest_cd,chr(13),''),chr(10),'') as rest_cd
,replace(replace(t1.rest_descb,chr(13),''),chr(10),'') as rest_descb
,replace(replace(t1.fail_rs_descb,chr(13),''),chr(10),'') as fail_rs_descb
,replace(replace(t1.postsc,chr(13),''),chr(10),'') as postsc
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.tran_vouch_type_cd,chr(13),''),chr(10),'') as tran_vouch_type_cd
,replace(replace(t1.tran_vouch_no,chr(13),''),chr(10),'') as tran_vouch_no
,tran_vouch_sell_dt
,replace(replace(t1.aldy_spdst_flg_cd,chr(13),''),chr(10),'') as aldy_spdst_flg_cd
,replace(replace(t1.spdst_uniq_idf,chr(13),''),chr(10),'') as spdst_uniq_idf
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,advise_send_cnt
,replace(replace(t1.proj_name,chr(13),''),chr(10),'') as proj_name
,replace(replace(t1.oper_name,chr(13),''),chr(10),'') as oper_name
,replace(replace(t1.memo_descb,chr(13),''),chr(10),'') as memo_descb

from ${iml_schema}.agt_bid_margin_enter_acct_info_h t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/agt_bid_margin_enter_acct_info_h.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
