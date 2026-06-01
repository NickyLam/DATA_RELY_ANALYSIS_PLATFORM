: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_qxb_tran_cfm_h_a
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_qxb_tran_cfm_h.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ibank_no,chr(13),''),chr(10),'') as ibank_no
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t1.sell_mode_cd,chr(13),''),chr(10),'') as sell_mode_cd
,t1.cfm_dt as cfm_dt
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,replace(replace(t1.appl_form_id,chr(13),''),chr(10),'') as appl_form_id
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.fund_acct_id,chr(13),''),chr(10),'') as fund_acct_id
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.appl_lot as appl_lot
,t1.appl_amt as appl_amt
,t1.tran_cfm_lot as tran_cfm_lot
,t1.tran_cfm_amt as tran_cfm_amt
,replace(replace(t1.init_appl_form_id,chr(13),''),chr(10),'') as init_appl_form_id
,replace(replace(t1.bank_card_num,chr(13),''),chr(10),'') as bank_card_num
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t1.huge_redem_proc_cd,chr(13),''),chr(10),'') as huge_redem_proc_cd
,replace(replace(t1.froz_rs_cd,chr(13),''),chr(10),'') as froz_rs_cd
,t1.froz_closing_dt as froz_closing_dt
,replace(replace(t1.ta_init_flg,chr(13),''),chr(10),'') as ta_init_flg
,t1.comm_fee as comm_fee
,t1.comm_fee_rat as comm_fee_rat
,t1.comm_discnt_rat as comm_discnt_rat
,t1.agent_fee as agent_fee
,t1.post_recv_comm_fee as post_recv_comm_fee
,t1.interest as interest
,t1.int_tax as int_tax
,replace(replace(t1.bus_prdure_end_flg,chr(13),''),chr(10),'') as bus_prdure_end_flg
,replace(replace(t1.accpt_way_cd,chr(13),''),chr(10),'') as accpt_way_cd
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.tran_happ_subrch_id,chr(13),''),chr(10),'') as tran_happ_subrch_id
,replace(replace(t1.tran_happ_brac_id,chr(13),''),chr(10),'') as tran_happ_brac_id
,t1.tran_happ_dt as tran_happ_dt
,t1.tran_happ_tm as tran_happ_tm
,t1.add_dt as add_dt
,t1.add_tm as add_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.evt_qxb_tran_cfm_h t1
where t1.start_dt <= to_date('${batch_date}','yyyymmdd')  and t1.end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_qxb_tran_cfm_h.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes