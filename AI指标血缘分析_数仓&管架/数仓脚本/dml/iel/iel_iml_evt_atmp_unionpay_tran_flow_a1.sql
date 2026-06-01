: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_atmp_unionpay_tran_flow_a1
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_atmp_unionpay_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.send_org_id,chr(13),''),chr(10),'') as send_org_id 
,replace(replace(t1.sys_follow_id,chr(13),''),chr(10),'') as sys_follow_id 
,t1.tran_tm as tran_tm 
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd 
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd 
,replace(replace(t1.proc_org_id,chr(13),''),chr(10),'') as proc_org_id 
,t1.tran_dt as tran_dt 
,replace(replace(t1.teller_id,chr(13),''),chr(10),'') as teller_id 
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id 
,replace(replace(t1.chn_cd,chr(13),''),chr(10),'') as chn_cd 
,replace(replace(t1.msg_type_cd,chr(13),''),chr(10),'') as msg_type_cd 
,replace(replace(t1.main_acct_id,chr(13),''),chr(10),'') as main_acct_id 
,replace(replace(t1.proc_cd,chr(13),''),chr(10),'') as proc_cd 
,replace(replace(t1.intnal_proc_cd,chr(13),''),chr(10),'') as intnal_proc_cd 
,t1.tran_amt as tran_amt 
,t1.onl_acct_bal as onl_acct_bal 
,t1.acct_td_aval_bal as acct_td_aval_bal 
,t1.atm_draw_td_aval_bal as atm_draw_td_aval_bal 
,replace(replace(t1.tran_fee,chr(13),''),chr(10),'') as tran_fee 
,replace(replace(t1.proc_org_site_tm,chr(13),''),chr(10),'') as proc_org_site_tm 
,replace(replace(t1.proc_org_site_dt,chr(13),''),chr(10),'') as proc_org_site_dt 
,replace(replace(t1.clear_dt,chr(13),''),chr(10),'') as clear_dt 
,replace(replace(t1.mercht_type_cd,chr(13),''),chr(10),'') as mercht_type_cd 
,replace(replace(t1.tran_serv_input_way_cd,chr(13),''),chr(10),'') as tran_serv_input_way_cd 
,replace(replace(t1.tran_serv_cond_cd,chr(13),''),chr(10),'') as tran_serv_cond_cd 
,replace(replace(t1.retriv_ref_id,chr(13),''),chr(10),'') as retriv_ref_id 
,replace(replace(t1.apprv_tran_auth_id,chr(13),''),chr(10),'') as apprv_tran_auth_id 
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code 
,replace(replace(t1.proc_termn_id,chr(13),''),chr(10),'') as proc_termn_id 
,replace(replace(t1.proc_mercht_id,chr(13),''),chr(10),'') as proc_mercht_id 
,replace(replace(t1.proc_mercht_name,chr(13),''),chr(10),'') as proc_mercht_name 
,replace(replace(t1.addit_resp_descb,chr(13),''),chr(10),'') as addit_resp_descb 
,replace(replace(t1.addit_priv,chr(13),''),chr(10),'') as addit_priv 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.resv_region,chr(13),''),chr(10),'') as resv_region 
,replace(replace(t1.recv_org_id,chr(13),''),chr(10),'') as recv_org_id 
,replace(replace(t1.cups_resv_num,chr(13),''),chr(10),'') as cups_resv_num 
,replace(replace(t1.init_proc_org_id,chr(13),''),chr(10),'') as init_proc_org_id 
,replace(replace(t1.init_send_org_id,chr(13),''),chr(10),'') as init_send_org_id 
,replace(replace(t1.init_sys_follow_id,chr(13),''),chr(10),'') as init_sys_follow_id 
,t1.init_tran_tm as init_tran_tm 
,replace(replace(t1.unionpay_exch_rat,chr(13),''),chr(10),'') as unionpay_exch_rat 
,replace(replace(t1.expns_acct_id,chr(13),''),chr(10),'') as expns_acct_id 
,replace(replace(t1.depot_acct_id,chr(13),''),chr(10),'') as depot_acct_id 
,replace(replace(t1.atmc_tran_flow_num,chr(13),''),chr(10),'') as atmc_tran_flow_num 
,' ' as msg_head_info 
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd 
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd 
,replace(replace(t1.err_info,chr(13),''),chr(10),'') as err_info 
,replace(replace(t1.termn_type_cd,chr(13),''),chr(10),'') as termn_type_cd 
,replace(replace(t1.init_way_cd,chr(13),''),chr(10),'') as init_way_cd 
,replace(replace(t1.mercht_cty_rg_cd,chr(13),''),chr(10),'') as mercht_cty_rg_cd 
,t1.deduct_amt as deduct_amt 
,t1.deduct_exch_rat as deduct_exch_rat 
,t1.clear_amt as clear_amt 
,replace(replace(t1.send_org_actl_id,chr(13),''),chr(10),'') as send_org_actl_id 
,replace(replace(t1.cross_bor_flg,chr(13),''),chr(10),'') as cross_bor_flg 
,replace(replace(t1.card_ser_num,chr(13),''),chr(10),'') as card_ser_num 
,replace(replace(t1.access_ic_data_region,chr(13),''),chr(10),'') as access_ic_data_region 
,replace(replace(t1.send_ic_data_region,chr(13),''),chr(10),'') as send_ic_data_region 
,replace(replace(t1.intnal_tran_cd,chr(13),''),chr(10),'') as intnal_tran_cd 
,t1.fcurr_tran_amt as fcurr_tran_amt 
,replace(replace(t1.bank_acct_type_cd,chr(13),''),chr(10),'') as bank_acct_type_cd 
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id 
,t1.comm_fee as comm_fee 
,replace(replace(t1.card_type_cd,chr(13),''),chr(10),'') as card_type_cd 
,replace(replace(t1.card_tran_type_cd,chr(13),''),chr(10),'') as card_tran_type_cd 
,replace(replace(t1.qr_code_pay_scene_cd,chr(13),''),chr(10),'') as qr_code_pay_scene_cd 
,replace(replace(t1.cross_bank_flg,chr(13),''),chr(10),'') as cross_bank_flg 
,replace(replace(t1.degr_flg,chr(13),''),chr(10),'') as degr_flg 
,replace(replace(t1.beps_unpasew_flg,chr(13),''),chr(10),'') as beps_unpasew_flg 
,replace(replace(t1.subclass_return_code,chr(13),''),chr(10),'') as subclass_return_code 
,replace(replace(t1.memo_cd,chr(13),''),chr(10),'') as memo_cd 
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num 
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num 
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num 
,replace(replace(t1.upp_enter_status_cd,chr(13),''),chr(10),'') as upp_enter_status_cd 
,replace(replace(t1.entry_flow_num,chr(13),''),chr(10),'') as entry_flow_num 
,t1.entry_dt as entry_dt 
,replace(replace(t1.delay_deduct_tran_flow_num,chr(13),''),chr(10),'') as delay_deduct_tran_flow_num 
,t1.delay_deduct_tran_dt as delay_deduct_tran_dt 
,replace(replace(t1.unionpay_delay_tran_return_cd,chr(13),''),chr(10),'') as unionpay_delay_tran_return_cd 
,replace(replace(t1.delay_tran_return_cd,chr(13),''),chr(10),'') as delay_tran_return_cd 
,replace(replace(t1.termn_equip_id,chr(13),''),chr(10),'') as termn_equip_id 
,replace(replace(t1.termn_ip_addr,chr(13),''),chr(10),'') as termn_ip_addr 
,replace(replace(t1.termn_sim_num,chr(13),''),chr(10),'') as termn_sim_num 
,replace(replace(t1.termn_gps_position,chr(13),''),chr(10),'') as termn_gps_position 
,replace(replace(t1.rsrv_mobile_no,chr(13),''),chr(10),'') as rsrv_mobile_no 
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id 
,replace(replace(t1.cust_name,chr(13),''),chr(10),'') as cust_name 
,t1.midgrod_tran_dt as midgrod_tran_dt 
,t1.acct_dt as acct_dt 
,replace(replace(t1.init_tran_cd,chr(13),''),chr(10),'') as init_tran_cd 
from ${iml_schema}.evt_atmp_unionpay_tran_flow t1 
where etl_dt <= to_date('${batch_date}','yyyymmdd') " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_atmp_unionpay_tran_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes