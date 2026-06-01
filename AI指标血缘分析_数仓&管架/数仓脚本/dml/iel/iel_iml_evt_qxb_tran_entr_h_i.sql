: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_qxb_tran_entr_h_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_qxb_tran_entr_h.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ibank_no,chr(13),''),chr(10),'') as ibank_no
,replace(replace(t1.appl_form_id,chr(13),''),chr(10),'') as appl_form_id
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.sell_mode_cd,chr(13),''),chr(10),'') as sell_mode_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.fund_acct_id,chr(13),''),chr(10),'') as fund_acct_id
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t1.acct_id,chr(13),''),chr(10),'') as acct_id
,replace(replace(t1.bank_card_num,chr(13),''),chr(10),'') as bank_card_num
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.appl_lot as appl_lot
,t1.appl_amt as appl_amt
,t1.tran_cfm_lot as tran_cfm_lot
,t1.tran_cfm_amt as tran_cfm_amt
,t1.tran_cfm_dt as tran_cfm_dt
,replace(replace(t1.init_appl_form_id,chr(13),''),chr(10),'') as init_appl_form_id
,t1.init_appl_lot as init_appl_lot
,replace(replace(t1.fund_consmt_agt_id,chr(13),''),chr(10),'') as fund_consmt_agt_id
,replace(replace(t1.huge_redem_proc_cd,chr(13),''),chr(10),'') as huge_redem_proc_cd
,t1.comm_fee as comm_fee
,replace(replace(t1.cntpty_fund_acct_id,chr(13),''),chr(10),'') as cntpty_fund_acct_id
,replace(replace(t1.cntpty_seller_cd,chr(13),''),chr(10),'') as cntpty_seller_cd
,replace(replace(t1.cntpty_tran_acct_id,chr(13),''),chr(10),'') as cntpty_tran_acct_id
,replace(replace(t1.cntpty_charge_way_cd,chr(13),''),chr(10),'') as cntpty_charge_way_cd
,replace(replace(t1.finc_cust_mgr_id,chr(13),''),chr(10),'') as finc_cust_mgr_id
,replace(replace(t1.operr_name,chr(13),''),chr(10),'') as operr_name
,replace(replace(t1.last_appl_status_cd,chr(13),''),chr(10),'') as last_appl_status_cd
,replace(replace(t1.appl_status_cd,chr(13),''),chr(10),'') as appl_status_cd
,replace(replace(t1.risk_level_match_flg,chr(13),''),chr(10),'') as risk_level_match_flg
,replace(replace(t1.order_way_cd,chr(13),''),chr(10),'') as order_way_cd
,replace(replace(t1.accpt_way_cd,chr(13),''),chr(10),'') as accpt_way_cd
,replace(replace(t1.oper_teller_id,chr(13),''),chr(10),'') as oper_teller_id
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info
,replace(replace(t1.tran_brch_id,chr(13),''),chr(10),'') as tran_brch_id
,replace(replace(t1.tran_brac_id,chr(13),''),chr(10),'') as tran_brac_id
,t1.tran_dt as tran_dt
,t1.tran_tm as tran_tm
,t1.add_dt as add_dt
,t1.add_tm as add_tm
,t1.start_dt as start_dt
,t1.end_dt as end_dt
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark
from iml.evt_qxb_tran_entr_h t1
where t1.start_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_qxb_tran_entr_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes