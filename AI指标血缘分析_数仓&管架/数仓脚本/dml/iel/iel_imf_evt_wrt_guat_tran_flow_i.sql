: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_imf_evt_wrt_guat_tran_flow_i
CreateDate: 20240130
FileName:   ${iel_data_path}/evt_wrt_guat_tran_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.cash_tran_seq_num,chr(13),''),chr(10),'') as cash_tran_seq_num
,replace(replace(t1.cr_acct_id,chr(13),''),chr(10),'') as cr_acct_id
,replace(replace(t1.cr_cust_acct_num,chr(13),''),chr(10),'') as cr_cust_acct_num
,replace(replace(t1.cr_acct_curr,chr(13),''),chr(10),'') as cr_acct_curr
,replace(replace(t1.cr_acct_sub_acct_num,chr(13),''),chr(10),'') as cr_acct_sub_acct_num
,replace(replace(t1.cr_acct_prod_id,chr(13),''),chr(10),'') as cr_acct_prod_id
,replace(replace(t1.cr_bal_type_cd,chr(13),''),chr(10),'') as cr_bal_type_cd
,replace(replace(t1.cr_tran_seq_num,chr(13),''),chr(10),'') as cr_tran_seq_num
,replace(replace(t1.dr_acct_id,chr(13),''),chr(10),'') as dr_acct_id
,replace(replace(t1.dr_cust_acct_num,chr(13),''),chr(10),'') as dr_cust_acct_num
,replace(replace(t1.dr_acct_curr,chr(13),''),chr(10),'') as dr_acct_curr
,replace(replace(t1.dr_acct_sub_acct_num,chr(13),''),chr(10),'') as dr_acct_sub_acct_num
,replace(replace(t1.dr_acct_prod_id,chr(13),''),chr(10),'') as dr_acct_prod_id
,replace(replace(t1.dr_bal_type_cd,chr(13),''),chr(10),'') as dr_bal_type_cd
,replace(replace(t1.dr_tran_seq_num,chr(13),''),chr(10),'') as dr_tran_seq_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,tran_dt
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,revs_dt
,replace(replace(t1.revs_tran_cd,chr(13),''),chr(10),'') as revs_tran_cd
,replace(replace(t1.wrt_guat_tran_status_cd,chr(13),''),chr(10),'') as wrt_guat_tran_status_cd
,replace(replace(t1.bus_type_cd,chr(13),''),chr(10),'') as bus_type_cd
,replace(replace(t1.quot_type_cd,chr(13),''),chr(10),'') as quot_type_cd
,replace(replace(t1.exch_rat_type_cd,chr(13),''),chr(10),'') as exch_rat_type_cd
,buy_amt
,replace(replace(t1.buy_curr_cd,chr(13),''),chr(10),'') as buy_curr_cd
,buyer_exch_rat
,replace(replace(t1.sell_curr,chr(13),''),chr(10),'') as sell_curr
,sell_amt
,seller_exch_rat
,exec_exch_rat
,float_int_rat
,replace(replace(t1.base_quot_way_cd,chr(13),''),chr(10),'') as base_quot_way_cd
,replace(replace(t1.base_exch_rat_type_cd,chr(13),''),chr(10),'') as base_exch_rat_type_cd
,base_exch_rat
,base_equvl_amt
,cross_exch_rat
,offset_cross_exch_rat
,intnal_price
,change_equvl_amt
,change_amt
,change_base_int_rat
,replace(replace(t1.change_base_int_rat_type_cd,chr(13),''),chr(10),'') as change_base_int_rat_type_cd
,change_int_rat
,replace(replace(t1.change_base_quot_way_cd,chr(13),''),chr(10),'') as change_base_quot_way_cd
,replace(replace(t1.change_quot_way_cd,chr(13),''),chr(10),'') as change_quot_way_cd
,replace(replace(t1.change_int_rat_type_cd,chr(13),''),chr(10),'') as change_int_rat_type_cd
,replace(replace(t1.tran_ref_no,chr(13),''),chr(10),'') as tran_ref_no
,replace(replace(t1.follow_ref_no,chr(13),''),chr(10),'') as follow_ref_no
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.bank_tran_seq_num,chr(13),''),chr(10),'') as bank_tran_seq_num
,replace(replace(t1.tran_descb,chr(13),''),chr(10),'') as tran_descb
,replace(replace(t1.src_module_type_cd,chr(13),''),chr(10),'') as src_module_type_cd
,replace(replace(t1.tran_termn_id,chr(13),''),chr(10),'') as tran_termn_id
,check_dt
,entry_dt
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.check_auth_teller_id,chr(13),''),chr(10),'') as check_auth_teller_id
,replace(replace(t1.tran_auth_teller_id,chr(13),''),chr(10),'') as tran_auth_teller_id
,replace(replace(t1.revs_auth_teller_id,chr(13),''),chr(10),'') as revs_auth_teller_id
,replace(replace(t1.revs_teller_id,chr(13),''),chr(10),'') as revs_teller_id
,tran_tm
,replace(replace(t1.offset_status_cd,chr(13),''),chr(10),'') as offset_status_cd
,fcurr_hq_sys_in_suplm_amt
,replace(replace(t1.sys_in_offset_flow_num,chr(13),''),chr(10),'') as sys_in_offset_flow_num
,replace(replace(t1.tran_market_offset_flow_num,chr(13),''),chr(10),'') as tran_market_offset_flow_num
,buy_offset_exch_rat
,sell_offset_exch_rat
,replace(replace(t1.wg_bus_type_cd,chr(13),''),chr(10),'') as wg_bus_type_cd
,replace(replace(t1.overser_proof_flg,chr(13),''),chr(10),'') as overser_proof_flg
,replace(replace(t1.overser_proof_descb,chr(13),''),chr(10),'') as overser_proof_descb
,replace(replace(t1.overser_remark,chr(13),''),chr(10),'') as overser_remark

from ${iml_schema}.evt_wrt_guat_tran_flow t1
where etl_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_wrt_guat_tran_flow.i.${batch_date}.dat" \
        charset=utf8
        safe=yes
