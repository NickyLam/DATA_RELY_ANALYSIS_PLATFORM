: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_corp_rgst_bill_ccution_evt_f
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_corp_rgst_bill_ccution_evt.f.${batch_date}.dat
IF_mark:    f
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.rgst_id,chr(13),''),chr(10),'') as rgst_id 
,replace(replace(t1.bill_id,chr(13),''),chr(10),'') as bill_id 
,replace(replace(t1.recv_id,chr(13),''),chr(10),'') as recv_id 
,replace(replace(t1.bill_med_cd,chr(13),''),chr(10),'') as bill_med_cd 
,replace(replace(t1.bill_type_cd,chr(13),''),chr(10),'') as bill_type_cd 
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd 
,replace(replace(t1.bus_attr_cd,chr(13),''),chr(10),'') as bus_attr_cd 
,replace(replace(t1.bus_dir_cd,chr(13),''),chr(10),'') as bus_dir_cd 
,replace(replace(t1.bill_src_cd,chr(13),''),chr(10),'') as bill_src_cd 
,replace(replace(t1.bill_num,chr(13),''),chr(10),'') as bill_num 
,replace(replace(t1.bill_sub_intrv_id,chr(13),''),chr(10),'') as bill_sub_intrv_id 
,t1.bill_amt as bill_amt 
,t1.tran_dt as tran_dt 
,replace(replace(t1.reqer_type_cd,chr(13),''),chr(10),'') as reqer_type_cd 
,replace(replace(t1.reqer_name,chr(13),''),chr(10),'') as reqer_name 
,replace(replace(t1.reqer_soci_crdt_cd,chr(13),''),chr(10),'') as reqer_soci_crdt_cd 
,replace(replace(t1.reqer_acct_type_cd,chr(13),''),chr(10),'') as reqer_acct_type_cd 
,replace(replace(t1.reqer_acct_id,chr(13),''),chr(10),'') as reqer_acct_id 
,replace(replace(t1.reqer_acct_name,chr(13),''),chr(10),'') as reqer_acct_name 
,replace(replace(t1.reqer_open_bank_no,chr(13),''),chr(10),'') as reqer_open_bank_no 
,replace(replace(t1.reqer_mem_cd,chr(13),''),chr(10),'') as reqer_mem_cd 
,replace(replace(t1.reqer_org_cd,chr(13),''),chr(10),'') as reqer_org_cd 
,replace(replace(t1.recver_type_cd,chr(13),''),chr(10),'') as recver_type_cd 
,replace(replace(t1.recver_name,chr(13),''),chr(10),'') as recver_name 
,replace(replace(t1.recver_soci_crdt_cd,chr(13),''),chr(10),'') as recver_soci_crdt_cd 
,replace(replace(t1.recver_acct_type_cd,chr(13),''),chr(10),'') as recver_acct_type_cd 
,replace(replace(t1.recver_acct_id,chr(13),''),chr(10),'') as recver_acct_id 
,replace(replace(t1.recver_acct_name,chr(13),''),chr(10),'') as recver_acct_name 
,replace(replace(t1.recver_open_bank_no,chr(13),''),chr(10),'') as recver_open_bank_no 
,replace(replace(t1.recver_mem_cd,chr(13),''),chr(10),'') as recver_mem_cd 
,replace(replace(t1.recver_org_cd,chr(13),''),chr(10),'') as recver_org_cd 
,t1.discnt_int_rat as discnt_int_rat 
,t1.discnt_actl_amt as discnt_actl_amt 
,replace(replace(t1.not_ngbl_cd,chr(13),''),chr(10),'') as not_ngbl_cd 
,replace(replace(t1.onl_clear_flg,chr(13),''),chr(10),'') as onl_clear_flg 
,replace(replace(t1.enter_id,chr(13),''),chr(10),'') as enter_id 
,replace(replace(t1.enter_acct_bank_no,chr(13),''),chr(10),'') as enter_acct_bank_no 
,replace(replace(t1.reply_idf_cd,chr(13),''),chr(10),'') as reply_idf_cd 
,t1.recv_dt as recv_dt 
,replace(replace(t1.refuse_pay_cd,chr(13),''),chr(10),'') as refuse_pay_cd 
,replace(replace(t1.refuse_pay_remark_info,chr(13),''),chr(10),'') as refuse_pay_remark_info 
,replace(replace(t1.recs_type_cd,chr(13),''),chr(10),'') as recs_type_cd 
,t1.actl_int as actl_int 
,t1.int_accr_exp_dt as int_accr_exp_dt 
,replace(replace(t1.int_payer_name,chr(13),''),chr(10),'') as int_payer_name 
,replace(replace(t1.int_payer_acct_id,chr(13),''),chr(10),'') as int_payer_acct_id 
,replace(replace(t1.int_payer_open_bank_name,chr(13),''),chr(10),'') as int_payer_open_bank_name 
,t1.comm_fee as comm_fee 
,t1.todos as todos 
,t1.pay_int_ratio as pay_int_ratio 
,t1.buyer_pay_int_int as buyer_pay_int_int 
,t1.tot_int as tot_int 
,replace(replace(t1.stop_pay_type_cd,chr(13),''),chr(10),'') as stop_pay_type_cd 
,replace(replace(t1.stop_pay_rs_descb,chr(13),''),chr(10),'') as stop_pay_rs_descb 
,replace(replace(t1.remit_stop_pay_type_cd,chr(13),''),chr(10),'') as remit_stop_pay_type_cd 
,replace(replace(t1.remit_stop_pay_rs_descb,chr(13),''),chr(10),'') as remit_stop_pay_rs_descb 
,t1.surp_tenor as surp_tenor 
,t1.stl_amt as stl_amt 
,replace(replace(t1.stl_rest_cd,chr(13),''),chr(10),'') as stl_rest_cd 
,t1.stl_dt as stl_dt 
,replace(replace(t1.payoff_type_cd,chr(13),''),chr(10),'') as payoff_type_cd 
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
,replace(replace(t1.src_table_name,chr(13),''),chr(10),'') as src_table_name 
from ${iml_schema}.evt_corp_rgst_bill_ccution_evt t1  
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_corp_rgst_bill_ccution_evt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes