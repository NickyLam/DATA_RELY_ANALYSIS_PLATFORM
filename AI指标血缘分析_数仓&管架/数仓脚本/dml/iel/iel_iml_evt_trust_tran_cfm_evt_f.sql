: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_trust_tran_cfm_evt_f
CreateDate: 20241023
FileName:   ${iel_data_path}/evt_trust_tran_cfm_evt.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,cfm_dt
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,replace(replace(t1.init_cfm_flow_num,chr(13),''),chr(10),'') as init_cfm_flow_num
,replace(replace(t1.intior_type_cd,chr(13),''),chr(10),'') as intior_type_cd
,tran_dt
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,clear_dt
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.termn_id,chr(13),''),chr(10),'') as termn_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t1.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
,replace(replace(t1.tran_med_id,chr(13),''),chr(10),'') as tran_med_id
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
,prod_nv
,tran_price
,tran_amt
,replace(replace(t1.stl_curr_cd,chr(13),''),chr(10),'') as stl_curr_cd
,cfm_amt
,tran_lot
,cfm_lot
,replace(replace(t1.need_huge_redem_proc_flg,chr(13),''),chr(10),'') as need_huge_redem_proc_flg
,replace(replace(t1.force_redem_rs,chr(13),''),chr(10),'') as force_redem_rs
,comm_discnt
,tot_cost
,comm_fee
,stamp_tax
,int_tax
,tran_fee
,agent_fee
,back_end_charge
,other_fee_1
,other_fee_2
,cfm_prft
,mgmt_fee
,cotin_froz_amt
,replace(replace(t1.dtl_flg,chr(13),''),chr(10),'') as dtl_flg
,replace(replace(t1.end_type_cd,chr(13),''),chr(10),'') as end_type_cd
,replace(replace(t1.froz_rs_cd,chr(13),''),chr(10),'') as froz_rs_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,int_amt
,int_turn_lot
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t1.memo_comnt,chr(13),''),chr(10),'') as memo_comnt
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.err_info,chr(13),''),chr(10),'') as err_info
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,rela_dt
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,bank_comm_fee
,replace(replace(t1.intior_flow_num,chr(13),''),chr(10),'') as intior_flow_num
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,replace(replace(t1.host_tran_cd,chr(13),''),chr(10),'') as host_tran_cd
,host_dt
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,tran_post_lot

from ${iml_schema}.evt_trust_tran_cfm_evt t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_trust_tran_cfm_evt.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
