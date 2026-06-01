: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_finc_tran_cfm_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_finc_tran_cfm_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,t.cfm_dt as cfm_dt
,replace(replace(t.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,replace(replace(t.intior_cd,chr(13),''),chr(10),'') as intior_cd
,t.tran_dt as tran_dt
,replace(replace(t.tran_tm,chr(13),''),chr(10),'') as tran_tm
,t.clear_day_term as clear_day_term
,replace(replace(t.flow_num,chr(13),''),chr(10),'') as flow_num
,replace(replace(t.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.tran_open_acct_org_id,chr(13),''),chr(10),'') as tran_open_acct_org_id
,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t.int_party_acct_id,chr(13),''),chr(10),'') as int_party_acct_id
,replace(replace(t.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id
,replace(replace(t.bank_cd,chr(13),''),chr(10),'') as bank_cd
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t.ta_tran_acct_id,chr(13),''),chr(10),'') as ta_tran_acct_id
,replace(replace(t.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
,replace(replace(t.tran_med_id,chr(13),''),chr(10),'') as tran_med_id
,replace(replace(t.ec_flg,chr(13),''),chr(10),'') as ec_flg
,replace(replace(t.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id
,t.prod_nv as prod_nv
,t.tran_price as tran_price
,t.tran_amt as tran_amt
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,t.cfm_amt as cfm_amt
,t.tran_lot as tran_lot
,t.cfm_lot as cfm_lot
,replace(replace(t.huge_redem_proc_flg,chr(13),''),chr(10),'') as huge_redem_proc_flg
,replace(replace(t.force_redem_rs_cd,chr(13),''),chr(10),'') as force_redem_rs_cd
,t.cotin_froz_amt as cotin_froz_amt
,t.lot_accu_accum as lot_accu_accum
,replace(replace(t.dtl_flg,chr(13),''),chr(10),'') as dtl_flg
,replace(replace(t.froz_rs_cd,chr(13),''),chr(10),'') as froz_rs_cd
,replace(replace(t.tran_dir_cd,chr(13),''),chr(10),'') as tran_dir_cd
,replace(replace(t.deflt_divd_way_cd,chr(13),''),chr(10),'') as deflt_divd_way_cd
,replace(replace(t.return_cd,chr(13),''),chr(10),'') as return_cd
,replace(replace(t.remark_info,chr(13),''),chr(10),'') as remark_info
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,t.rela_dt as rela_dt
,replace(replace(t.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,t.host_dt as host_dt
,replace(replace(t.host_flow_num,chr(13),''),chr(10),'') as host_flow_num
,t.tran_post_lot as tran_post_lot
,t.rsrv_amt3 as rsrv_amt3
,replace(replace(t.resv2,chr(13),''),chr(10),'') as resv2
,replace(replace(t.resv_region3,chr(13),''),chr(10),'') as resv_region3
from ${iml_schema}.evt_finc_tran_cfm t
where etl_dt <= to_date('${batch_date}','yyyymmdd') and etl_dt >= to_date('${batch_date}','yyyymmdd') -6 ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_tran_cfm_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes