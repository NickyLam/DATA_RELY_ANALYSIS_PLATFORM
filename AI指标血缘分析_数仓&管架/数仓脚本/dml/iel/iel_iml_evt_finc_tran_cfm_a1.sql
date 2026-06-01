: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_finc_tran_cfm_a1
CreateDate: 20240425
FileName:   ${iel_data_path}/evt_finc_tran_cfm.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.cfm_dt as etl_dt
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,t1.cfm_dt as cfm_dt
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,replace(replace(t1.intior_cd,chr(13),''),chr(10),'') as intior_cd
,t1.tran_dt as tran_dt
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm
,t1.clear_day_term as clear_day_term
,replace(replace(t1.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_open_acct_org_id,chr(13),''),chr(10),'') as tran_open_acct_org_id
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.int_party_acct_id,chr(13),''),chr(10),'') as int_party_acct_id
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t1.bank_cd,chr(13),''),chr(10),'') as bank_cd
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t1.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
,replace(replace(t1.tran_med_id,chr(13),''),chr(10),'') as tran_med_id
,replace(replace(t1.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,t1.prod_nv as prod_nv
,t1.tran_price as tran_price
,t1.tran_amt as tran_amt
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t1.cfm_amt as cfm_amt
,t1.tran_lot as tran_lot
,t1.cfm_lot as cfm_lot
,replace(replace(t1.huge_redem_proc_flg,chr(13),''),chr(10),'') as huge_redem_proc_flg
,replace(replace(t1.force_redem_rs_cd,chr(13),''),chr(10),'') as force_redem_rs_cd
,t1.cotin_froz_amt as cotin_froz_amt
,t1.lot_accu_accum as lot_accu_accum
,replace(replace(t1.dtl_flg,chr(13),''),chr(10),'') as dtl_flg
,replace(replace(t1.froz_rs_cd,chr(13),''),chr(10),'') as froz_rs_cd
,replace(replace(t1.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t1.deflt_divd_way_cd,chr(13),''),chr(10),'') as deflt_divd_way_cd
,replace(replace(t1.return_cd,chr(13),''),chr(10),'') as return_cd
,replace(replace(t1.remark_info,chr(13),''),chr(10),'') as remark_info
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,t1.rela_dt as rela_dt
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id
,t1.host_dt as host_dt
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,t1.tran_post_lot as tran_post_lot
,t1.rsrv_amt3 as rsrv_amt3
,replace(replace(t1.resv2,chr(13),''),chr(10),'') as resv2
,replace(replace(t1.resv_region3,chr(13),''),chr(10),'') as resv_region3
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.target_bank_acct_id,chr(13),''),chr(10),'') as target_bank_acct_id
,t1.tot_cost as tot_cost
,replace(replace(t1.init_cfm_flow_num,chr(13),''),chr(10),'') as init_cfm_flow_num
from ${iml_schema}.evt_finc_tran_cfm t1
where t1.cfm_dt <= to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_tran_cfm.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes