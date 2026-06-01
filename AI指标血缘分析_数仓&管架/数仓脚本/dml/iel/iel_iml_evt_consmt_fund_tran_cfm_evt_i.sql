: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_consmt_fund_tran_cfm_evt_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_consmt_fund_tran_cfm_evt.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
     to_date('${batch_date}','yyyymmdd') as etl_dt
    ,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
    ,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
    ,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
    ,t.cfm_dt as cfm_dt
    ,replace(replace(t.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
    ,replace(replace(t.init_cfm_flow_num,chr(13),''),chr(10),'') as init_cfm_flow_num
    ,replace(replace(t.intior_cd,chr(13),''),chr(10),'') as intior_cd
    ,t.appl_dt as appl_dt
    ,t.appl_tm as appl_tm
    ,t.clear_dt as clear_dt
    ,replace(replace(t.appl_flow_num,chr(13),''),chr(10),'') as appl_flow_num
    ,replace(replace(t.tran_code,chr(13),''),chr(10),'') as tran_code
    ,replace(replace(t.bus_cd,chr(13),''),chr(10),'') as bus_cd
    ,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
    ,replace(replace(t.tran_belong_org_id,chr(13),''),chr(10),'') as tran_belong_org_id
    ,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
    ,replace(replace(t.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id
    ,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
    ,replace(replace(t.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
    ,replace(replace(t.cust_id,chr(13),''),chr(10),'') as cust_id
    ,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
    ,replace(replace(t.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
    ,replace(replace(t.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
    ,replace(replace(t.tran_med_id,chr(13),''),chr(10),'') as tran_med_id
    ,replace(replace(t.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
    ,replace(replace(t.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
    ,replace(replace(t.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd
    ,t.prod_nv as prod_nv
    ,t.tran_price as tran_price
    ,t.tran_amt as tran_amt
    ,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
    ,t.cfm_amt as cfm_amt
    ,t.tran_lot as tran_lot
    ,t.cfm_lot as cfm_lot
    ,replace(replace(t.huge_redem_proc_cd,chr(13),''),chr(10),'') as huge_redem_proc_cd
    ,replace(replace(t.force_redem_rs_cd,chr(13),''),chr(10),'') as force_redem_rs_cd
    ,t.cotin_froz_amt as cotin_froz_amt
    ,t.lot_accu_accum as lot_accu_accum
    ,replace(replace(t.dtl_flg,chr(13),''),chr(10),'') as dtl_flg
    ,replace(replace(t.froz_rs_cd,chr(13),''),chr(10),'') as froz_rs_cd
    ,replace(replace(t.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
    ,replace(replace(t.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
    ,replace(replace(t.return_code,chr(13),''),chr(10),'') as return_code
    ,replace(replace(t.return_info,chr(13),''),chr(10),'') as return_info
    ,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
    ,t.rela_dt as rela_dt
    ,replace(replace(t.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
    ,replace(replace(t.intior_flow_num,chr(13),''),chr(10),'') as intior_flow_num
    ,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
    ,t.host_dt as host_dt
    ,replace(replace(t.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
    ,t.tran_post_lot as tran_post_lot
    ,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
    ,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
    ,t.comm_fee as comm_fee
    ,t.agent_fee as agent_fee
    ,t.bank_comm_fee as bank_comm_fee
    ,replace(replace(t.target_prod_id,chr(13),''),chr(10),'') as target_prod_id
    ,t.target_prod_nv as target_prod_nv
    ,t.target_prod_price as target_prod_price
    ,t.target_prod_cfm_lot as target_prod_cfm_lot
from iml.evt_consmt_fund_tran_cfm_evt t
where t.cfm_dt = to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_consmt_fund_tran_cfm_evt.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes