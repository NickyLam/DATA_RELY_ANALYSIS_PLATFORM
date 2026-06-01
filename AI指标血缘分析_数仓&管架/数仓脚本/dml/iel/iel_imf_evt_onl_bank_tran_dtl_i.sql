: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_onl_bank_tran_dtl_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_onl_bank_tran_dtl.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.whole_unify_cust_id,chr(13),''),chr(10),'') as whole_unify_cust_id
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_oper_type_cd,chr(13),''),chr(10),'') as tran_oper_type_cd
,replace(replace(t1.tran_return_code,chr(13),''),chr(10),'') as tran_return_code
,replace(replace(t1.fail_rs,chr(13),''),chr(10),'') as fail_rs
,t1.tran_amt as tran_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.comm_fee as comm_fee
,replace(replace(t1.pay_acct_num,chr(13),''),chr(10),'') as pay_acct_num
,replace(replace(t1.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name
,replace(replace(t1.pay_acct_type_cd,chr(13),''),chr(10),'') as pay_acct_type_cd
,replace(replace(t1.recvbl_num,chr(13),''),chr(10),'') as recvbl_num
,replace(replace(t1.recvbl_num_name,chr(13),''),chr(10),'') as recvbl_num_name
,replace(replace(t1.recvbl_acct_type_cd,chr(13),''),chr(10),'') as recvbl_acct_type_cd
,replace(replace(t1.recver_bank_no,chr(13),''),chr(10),'') as recver_bank_no
,replace(replace(t1.recver_bank_name,chr(13),''),chr(10),'') as recver_bank_name
,replace(replace(t1.recver_prov_cd,chr(13),''),chr(10),'') as recver_prov_cd
,replace(replace(t1.recver_prov_name,chr(13),''),chr(10),'') as recver_prov_name
,replace(replace(t1.recver_city_cd,chr(13),''),chr(10),'') as recver_city_cd
,replace(replace(t1.recver_city_name,chr(13),''),chr(10),'') as recver_city_name
,replace(replace(t1.plan_fomult_tm,chr(13),''),chr(10),'') as plan_fomult_tm
,replace(replace(t1.plan_type_cd,chr(13),''),chr(10),'') as plan_type_cd
,replace(replace(t1.tran_freq_cd,chr(13),''),chr(10),'') as tran_freq_cd
,t1.next_exec_dt as next_exec_dt
,replace(replace(t1.precon_plan_status_cd,chr(13),''),chr(10),'') as precon_plan_status_cd
,t1.tm_or_ff_begin_dt as tm_or_ff_begin_dt
,t1.tm_or_ff_closing_dt as tm_or_ff_closing_dt
,replace(replace(t1.lmt_attr_cd,chr(13),''),chr(10),'') as lmt_attr_cd
,replace(replace(t1.save_cert_way_cd,chr(13),''),chr(10),'') as save_cert_way_cd
,replace(replace(t1.usage_comnt,chr(13),''),chr(10),'') as usage_comnt
,replace(replace(t1.onl_bank_tran_flow_num,chr(13),''),chr(10),'') as onl_bank_tran_flow_num
,replace(replace(t1.recver_nickna,chr(13),''),chr(10),'') as recver_nickna
,replace(replace(t1.atm_equip_id,chr(13),''),chr(10),'') as atm_equip_id
,replace(replace(t1.st_msg_advise_mobile_no,chr(13),''),chr(10),'') as st_msg_advise_mobile_no
,replace(replace(t1.brac_id,chr(13),''),chr(10),'') as brac_id
,replace(replace(t1.brac_name,chr(13),''),chr(10),'') as brac_name
,replace(replace(t1.dept_cd,chr(13),''),chr(10),'') as dept_cd
,replace(replace(t1.tran_out_route_id,chr(13),''),chr(10),'') as tran_out_route_id
,replace(replace(t1.remit_way_id,chr(13),''),chr(10),'') as remit_way_id
,replace(replace(t1.remit_way_name,chr(13),''),chr(10),'') as remit_way_name
,replace(replace(t1.next_day_tran_out_flg,chr(13),''),chr(10),'') as next_day_tran_out_flg
,replace(replace(t1.tran_mobile_no,chr(13),''),chr(10),'') as tran_mobile_no
,replace(replace(t1.crdt_card_repay_flg,chr(13),''),chr(10),'') as crdt_card_repay_flg
,replace(replace(t1.user_seq_id,chr(13),''),chr(10),'') as user_seq_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.tran_order_no,chr(13),''),chr(10),'') as tran_order_no
,replace(replace(t1.chain_way_track_no,chr(13),''),chr(10),'') as chain_way_track_no
from ${iml_schema}.evt_onl_bank_tran_dtl t1
where etl_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_onl_bank_tran_dtl.i.${batch_date}.dat" \
        charset=utf8
        safe=yes