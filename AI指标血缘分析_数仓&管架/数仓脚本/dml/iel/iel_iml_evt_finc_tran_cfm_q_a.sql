: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_finc_tran_cfm_q_a
CreateDate: 20240425
FileName:   ${iel_data_path}/evt_finc_tran_cfm_q.i.${batch_date}.dat
IF_mark:    q_i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
t1.cfm_dt as etl_dt
,t1.ta_cd as ta_cd
,t1.evt_id as evt_id
,t1.lp_id as lp_id
,t1.cfm_dt as cfm_dt
,t1.ta_cfm_flow_num as ta_cfm_flow_num
,t1.intior_cd as intior_cd
,t1.tran_dt as tran_dt
,t1.tran_tm as tran_tm
,t1.clear_day_term as clear_day_term
,t1.flow_num as flow_num
,t1.tran_cd as tran_cd
,t1.bus_cd as bus_cd
,t1.tran_org_id as tran_org_id
,t1.tran_open_acct_org_id as tran_open_acct_org_id
,t1.tran_chn_cd as tran_chn_cd
,t1.tran_teller_id as tran_teller_id
,t1.int_party_acct_id as int_party_acct_id
,t1.finc_acct_id as finc_acct_id
,t1.bank_cd as bank_cd
,t1.party_id as party_id
,t1.bank_acct_id as bank_acct_id
,t1.ta_tran_acct_id as ta_tran_acct_id
,t1.tran_med_type_cd as tran_med_type_cd
,t1.tran_med_id as tran_med_id
,t1.ec_flg as ec_flg
,t1.finc_prod_id as finc_prod_id
,t1.prod_nv as prod_nv
,t1.tran_price as tran_price
,t1.tran_amt as tran_amt
,t1.curr_cd as curr_cd
,t1.cfm_amt as cfm_amt
,t1.tran_lot as tran_lot
,t1.cfm_lot as cfm_lot
,t1.huge_redem_proc_flg as huge_redem_proc_flg
,t1.force_redem_rs_cd as force_redem_rs_cd
,t1.cotin_froz_amt as cotin_froz_amt
,t1.lot_accu_accum as lot_accu_accum
,t1.dtl_flg as dtl_flg
,t1.froz_rs_cd as froz_rs_cd
,t1.tran_dir_cd as tran_dir_cd
,t1.deflt_divd_way_cd as deflt_divd_way_cd
,t1.return_cd as return_cd
,replace(replace(t1.remark_info,chr(13),''),chr(10),'') as remark_info
,t1.tran_status_cd as tran_status_cd
,t1.cust_mgr_id as cust_mgr_id
,t1.rela_dt as rela_dt
,t1.rela_flow_num as rela_flow_num
,t1.cont_id as cont_id
,t1.host_dt as host_dt
,t1.host_flow_num as host_flow_num
,t1.tran_post_lot as tran_post_lot
,t1.rsrv_amt3 as rsrv_amt3
,replace(replace(t1.resv2,chr(13),''),chr(10),'') as resv2
,replace(replace(t1.resv_region3,chr(13),''),chr(10),'') as resv_region3
from ${iml_schema}.evt_finc_tran_cfm t1
where t1.cfm_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_tran_cfm_q.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes