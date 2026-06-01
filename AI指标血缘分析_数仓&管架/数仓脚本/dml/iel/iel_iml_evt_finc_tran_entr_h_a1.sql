: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_finc_tran_entr_h_a1
CreateDate: 20240425
FileName:   ${iel_data_path}/evt_finc_tran_entr_h.a.${batch_date}.dat
IF_mark:    a
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
t1.start_dt as etl_dt 
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id 
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id 
,replace(replace(t1.entr_flow_num,chr(13),''),chr(10),'') as entr_flow_num 
,replace(replace(t1.intior_flow_num,chr(13),''),chr(10),'') as intior_flow_num 
,replace(replace(t1.cont_id,chr(13),''),chr(10),'') as cont_id 
,t1.tran_dt as tran_dt 
,replace(replace(t1.tran_tm,chr(13),''),chr(10),'') as tran_tm 
,t1.tran_sys_dt as tran_sys_dt 
,replace(replace(t1.seller_cd,chr(13),''),chr(10),'') as seller_cd 
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd 
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id 
,replace(replace(t1.tran_acct_open_org_id,chr(13),''),chr(10),'') as tran_acct_open_org_id 
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd 
,replace(replace(t1.finc_acct_num,chr(13),''),chr(10),'') as finc_acct_num 
,replace(replace(t1.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id 
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd 
,replace(replace(t1.bank_id,chr(13),''),chr(10),'') as bank_id 
,replace(replace(t1.party_id,chr(13),''),chr(10),'') as party_id 
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id 
,replace(replace(t1.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd 
,replace(replace(t1.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd 
,replace(replace(t1.tran_med_id,chr(13),''),chr(10),'') as tran_med_id 
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd 
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id 
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id 
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id 
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd 
,replace(replace(t1.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd 
,replace(replace(t1.prod_way_cd,chr(13),''),chr(10),'') as prod_way_cd 
,t1.rela_dt as rela_dt 
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num 
,t1.tran_amt as tran_amt 
,replace(replace(t1.cust_grouping_cd,chr(13),''),chr(10),'') as cust_grouping_cd 
,replace(replace(t1.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd 
,replace(replace(t1.init_flow_tran_chn,chr(13),''),chr(10),'') as init_flow_tran_chn 
,replace(replace(t1.init_flow_tran_org_id,chr(13),''),chr(10),'') as init_flow_tran_org_id 
,t1.tran_lot as tran_lot 
,replace(replace(t1.huge_redem_proc_flg,chr(13),''),chr(10),'') as huge_redem_proc_flg 
,replace(replace(t1.redem_mode_cd,chr(13),''),chr(10),'') as redem_mode_cd 
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd 
,replace(replace(t1.froz_rs_cd,chr(13),''),chr(10),'') as froz_rs_cd 
,replace(replace(t1.target_bank_acct_id,chr(13),''),chr(10),'') as target_bank_acct_id 
,replace(replace(t1.cust_risk_level_cd,chr(13),''),chr(10),'') as cust_risk_level_cd 
,replace(replace(t1.prod_risk_level_cd,chr(13),''),chr(10),'') as prod_risk_level_cd 
,replace(replace(t1.send_host_flow_num,chr(13),''),chr(10),'') as send_host_flow_num 
,t1.host_check_entry_dt as host_check_entry_dt 
,t1.init_tran_host_entry_dt as init_tran_host_entry_dt 
,replace(replace(t1.host_tran_cd,chr(13),''),chr(10),'') as host_tran_cd 
,t1.host_dt as host_dt 
,replace(replace(t1.host_flow_id,chr(13),''),chr(10),'') as host_flow_id 
,replace(replace(t1.supv_nomal_flg,chr(13),''),chr(10),'') as supv_nomal_flg 
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id 
,replace(replace(t1.err_descb,chr(13),''),chr(10),'') as err_descb 
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd 
,replace(replace(t1.accpt_way_cd,chr(13),''),chr(10),'') as accpt_way_cd 
,replace(replace(t1.memo_descb,chr(13),''),chr(10),'') as memo_descb 
,replace(replace(t1.buy_acct_id,chr(13),''),chr(10),'') as buy_acct_id 
,t1.stdby_amt as stdby_amt 
,t1.start_dt as start_dt 
,t1.end_dt as end_dt 
,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
,replace(replace(t1.remark_field_1,chr(13),''),chr(10),'') as remark_field_1 
,replace(replace(t1.remark_field_2,chr(13),''),chr(10),'') as remark_field_2 
from ${iml_schema}.evt_finc_tran_entr_h t1 
where 1=1 " \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_tran_entr_h.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes