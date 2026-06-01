: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_trust_tran_entr_h_i
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_trust_tran_entr_h.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.entr_flow_num,chr(13),''),chr(10),'') as entr_flow_num 
,replace(replace(t1.intior_flow_num,chr(13),''),chr(10),'') as intior_flow_num 
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id 
,t1.appl_dt as appl_dt 
,t1.appl_tm as appl_tm 
,t1.sys_dt as sys_dt 
,replace(replace(t1.seller_id,chr(13),''),chr(10),'') as seller_id 
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code 
,replace(replace(t1.ctrl_flg,chr(13),''),chr(10),'') as ctrl_flg 
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id 
,replace(replace(t1.tran_open_acct_org_id,chr(13),''),chr(10),'') as tran_open_acct_org_id 
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd 
,replace(replace(t1.finc_acct_id,chr(13),''),chr(10),'') as finc_acct_id 
,replace(replace(t1.finc_cust_id,chr(13),''),chr(10),'') as finc_cust_id 
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd 
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id 
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id 
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id 
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd 
,replace(replace(t1.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd 
,replace(replace(t1.tran_med_id,chr(13),''),chr(10),'') as tran_med_id 
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd 
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id 
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id 
,replace(replace(t1.finc_prod_id,chr(13),''),chr(10),'') as finc_prod_id 
,replace(replace(t1.prod_curr_cd,chr(13),''),chr(10),'') as prod_curr_cd 
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd 
,replace(replace(t1.charge_way_cd,chr(13),''),chr(10),'') as charge_way_cd 
,t1.rela_tran_dt as rela_tran_dt 
,replace(replace(t1.rela_tran_flow_num,chr(13),''),chr(10),'') as rela_tran_flow_num 
,t1.tran_amt as tran_amt 
,replace(replace(t1.cust_grouping_cd,chr(13),''),chr(10),'') as cust_grouping_cd 
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd 
,replace(replace(t1.init_tran_chn_cd,chr(13),''),chr(10),'') as init_tran_chn_cd 
,replace(replace(t1.init_tran_org_id,chr(13),''),chr(10),'') as init_tran_org_id 
,t1.tran_lot as tran_lot 
,replace(replace(t1.huge_redem_proc_cd,chr(13),''),chr(10),'') as huge_redem_proc_cd 
,replace(replace(t1.redem_mode_cd,chr(13),''),chr(10),'') as redem_mode_cd 
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd 
,replace(replace(t1.froz_rs_cd,chr(13),''),chr(10),'') as froz_rs_cd 
,replace(replace(t1.target_bank_acct_id,chr(13),''),chr(10),'') as target_bank_acct_id 
,replace(replace(t1.cust_risk_level_cd,chr(13),''),chr(10),'') as cust_risk_level_cd 
,replace(replace(t1.prod_risk_level_cd,chr(13),''),chr(10),'') as prod_risk_level_cd 
,t1.cfm_dt as cfm_dt 
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num 
,t1.cfm_lot as cfm_lot 
,replace(replace(t1.send_host_flow_num,chr(13),''),chr(10),'') as send_host_flow_num 
,t1.host_check_entry_dt as host_check_entry_dt 
,t1.init_tran_host_check_entry_dt as init_tran_host_check_entry_dt 
,replace(replace(t1.host_tran_code,chr(13),''),chr(10),'') as host_tran_code 
,t1.host_dt as host_dt 
,replace(replace(t1.host_flow_num,chr(13),''),chr(10),'') as host_flow_num 
,replace(replace(t1.supv_nomal_flg,chr(13),''),chr(10),'') as supv_nomal_flg 
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id 
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code 
,replace(replace(t1.return_info,chr(13),''),chr(10),'') as return_info 
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd 
,replace(replace(t1.accpt_way_cd,chr(13),''),chr(10),'') as accpt_way_cd 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.evt_trust_tran_entr_h t1 
where start_dt = to_date('${batch_date}','yyyymmdd');" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_trust_tran_entr_h.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes