: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_onl_bank_tran_dtl_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_onl_bank_tran_dtl.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t.etl_dt as etl_dt
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t.whole_unify_cust_id,chr(13),''),chr(10),'') as whole_unify_cust_id
,t.tran_dt as tran_dt
,replace(replace(t.tran_tm,chr(13),''),chr(10),'') as tran_tm
,replace(replace(t.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t.tran_oper_type_cd,chr(13),''),chr(10),'') as tran_oper_type_cd
,replace(replace(t.tran_return_code,chr(13),''),chr(10),'') as tran_return_code
,replace(replace(t.fail_rs,chr(13),''),chr(10),'') as fail_rs
,t.tran_amt as tran_amt
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.comm_fee as comm_fee
,replace(replace(t.pay_acct_num,chr(13),''),chr(10),'') as pay_acct_num
,replace(replace(t.pay_acct_name,chr(13),''),chr(10),'') as pay_acct_name
,replace(replace(t.pay_acct_type_cd,chr(13),''),chr(10),'') as pay_acct_type_cd
,replace(replace(t.recvbl_num,chr(13),''),chr(10),'') as recvbl_num
,replace(replace(t.recvbl_num_name,chr(13),''),chr(10),'') as recvbl_num_name
,replace(replace(t.recvbl_acct_type_cd,chr(13),''),chr(10),'') as recvbl_acct_type_cd
,replace(replace(t.recver_bank_no,chr(13),''),chr(10),'') as recver_bank_no
,replace(replace(t.recver_bank_name,chr(13),''),chr(10),'') as recver_bank_name
,replace(replace(t.recver_prov_cd,chr(13),''),chr(10),'') as recver_prov_cd
,replace(replace(t.recver_prov_name,chr(13),''),chr(10),'') as recver_prov_name
,replace(replace(t.recver_city_cd,chr(13),''),chr(10),'') as recver_city_cd
,replace(replace(t.recver_city_name,chr(13),''),chr(10),'') as recver_city_name
,replace(replace(t.plan_fomult_tm,chr(13),''),chr(10),'') as plan_fomult_tm
,replace(replace(t.plan_type_cd,chr(13),''),chr(10),'') as plan_type_cd
,replace(replace(t.tran_freq_cd,chr(13),''),chr(10),'') as tran_freq_cd
,t.next_exec_dt as next_exec_dt
,replace(replace(t.precon_plan_status_cd,chr(13),''),chr(10),'') as precon_plan_status_cd
,t.tm_or_ff_begin_dt as tm_or_ff_begin_dt
,t.tm_or_ff_closing_dt as tm_or_ff_closing_dt
,replace(replace(t.lmt_attr_cd,chr(13),''),chr(10),'') as lmt_attr_cd
,replace(replace(t.save_cert_way_cd,chr(13),''),chr(10),'') as save_cert_way_cd
,replace(replace(t.usage_comnt,chr(13),''),chr(10),'') as usage_comnt
,replace(replace(t.onl_bank_tran_flow_num,chr(13),''),chr(10),'') as onl_bank_tran_flow_num
,replace(replace(t.recver_nickna,chr(13),''),chr(10),'') as recver_nickna
,replace(replace(t.atm_equip_id,chr(13),''),chr(10),'') as atm_equip_id
,replace(replace(t.st_msg_advise_mobile_no,chr(13),''),chr(10),'') as st_msg_advise_mobile_no
,replace(replace(t.brac_id,chr(13),''),chr(10),'') as brac_id
,replace(replace(t.brac_name,chr(13),''),chr(10),'') as brac_name
,replace(replace(t.dept_cd,chr(13),''),chr(10),'') as dept_cd
,replace(replace(t.tran_out_route_id,chr(13),''),chr(10),'') as tran_out_route_id
,replace(replace(t.remit_way_id,chr(13),''),chr(10),'') as remit_way_id
,replace(replace(t.remit_way_name,chr(13),''),chr(10),'') as remit_way_name
,replace(replace(t.next_day_tran_out_flg,chr(13),''),chr(10),'') as next_day_tran_out_flg
,replace(replace(t.tran_mobile_no,chr(13),''),chr(10),'') as tran_mobile_no
,replace(replace(t.crdt_card_repay_flg,chr(13),''),chr(10),'') as crdt_card_repay_flg
,replace(replace(t.user_seq_id,chr(13),''),chr(10),'') as user_seq_id
,replace(replace(t.remark,chr(13),''),chr(10),'') as remark
from iml.evt_onl_bank_tran_dtl t
where t.etl_dt >= to_date('20201201','yyyymmdd') and t.etl_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_onl_bank_tran_dtl.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes