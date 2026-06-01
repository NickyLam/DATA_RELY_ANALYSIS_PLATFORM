: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_finc_tran_entr_h_i_w
CreateDate: 20180529
FileName:   ${iel_data_path}/evt_finc_tran_entr_h_w.i.${batch_date}.dat
IF_mark:    i_w
Logs:
   zjj 2018-07-27 create template
' \
        query="select 
to_date('${batch_date}','yyyymmdd') as etl_dt 
,replace(replace(t.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t.entr_flow_num,chr(13),''),chr(10),'') as entr_flow_num
,replace(replace(t.intior_flow_num,chr(13),''),chr(10),'') as intior_flow_num
,replace(replace(t.cont_id,chr(13),''),chr(10),'') as cont_id
,t.tran_dt as tran_dt
,replace(replace(t.tran_tm,chr(13),''),chr(10),'') as tran_tm
,t.tran_sys_dt as tran_sys_dt
,replace(replace(t.seller_cd,chr(13),''),chr(10),'') as seller_cd
,replace(replace(t.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t.tran_acct_open_org_id,chr(13),''),chr(10),'') as tran_acct_open_org_id
,replace(replace(t.ta_cd,chr(13),''),chr(10),'') as ta_cd
,replace(replace(t.finc_acct_num,chr(13),''),chr(10),'') as finc_acct_num
,replace(replace(t.intnal_cust_id,chr(13),''),chr(10),'') as intnal_cust_id
,replace(replace(t.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t.bank_id,chr(13),''),chr(10),'') as bank_id
,replace(replace(t.party_id,chr(13),''),chr(10),'') as party_id
,replace(replace(t.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t.ec_idf_cd,chr(13),''),chr(10),'') as ec_idf_cd
,replace(replace(t.tran_med_type_cd,chr(13),''),chr(10),'') as tran_med_type_cd
,replace(replace(t.tran_med_id,chr(13),''),chr(10),'') as tran_med_id
,replace(replace(t.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t.prod_cate_cd,chr(13),''),chr(10),'') as prod_cate_cd
,replace(replace(t.prod_way_cd,chr(13),''),chr(10),'') as prod_way_cd
,t.rela_dt as rela_dt
,replace(replace(t.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,t.tran_amt as tran_amt
,replace(replace(t.cust_grouping_cd,chr(13),''),chr(10),'') as cust_grouping_cd
,replace(replace(t.acct_status_cd,chr(13),''),chr(10),'') as acct_status_cd
,replace(replace(t.init_flow_tran_chn,chr(13),''),chr(10),'') as init_flow_tran_chn
,replace(replace(t.init_flow_tran_org_id,chr(13),''),chr(10),'') as init_flow_tran_org_id
,t.tran_lot as tran_lot
,replace(replace(t.huge_redem_proc_flg,chr(13),''),chr(10),'') as huge_redem_proc_flg
,replace(replace(t.redem_mode_cd,chr(13),''),chr(10),'') as redem_mode_cd
,replace(replace(t.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t.froz_rs_cd,chr(13),''),chr(10),'') as froz_rs_cd
,replace(replace(t.target_bank_acct_id,chr(13),''),chr(10),'') as target_bank_acct_id
,replace(replace(t.cust_risk_level_cd,chr(13),''),chr(10),'') as cust_risk_level_cd
,replace(replace(t.prod_risk_level_cd,chr(13),''),chr(10),'') as prod_risk_level_cd
,replace(replace(t.send_host_flow_num,chr(13),''),chr(10),'') as send_host_flow_num
,t.host_check_entry_dt as host_check_entry_dt
,t.init_tran_host_entry_dt as init_tran_host_entry_dt
,replace(replace(t.host_tran_cd,chr(13),''),chr(10),'') as host_tran_cd
,t.host_dt as host_dt
,replace(replace(t.host_flow_id,chr(13),''),chr(10),'') as host_flow_id
,replace(replace(t.supv_nomal_flg,chr(13),''),chr(10),'') as supv_nomal_flg
,replace(replace(t.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t.err_descb,chr(13),''),chr(10),'') as err_descb
,replace(replace(t.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t.accpt_way_cd,chr(13),''),chr(10),'') as accpt_way_cd
,replace(replace(t.memo_descb,chr(13),''),chr(10),'') as memo_descb
,replace(replace(t.buy_acct_id,chr(13),''),chr(10),'') as buy_acct_id
,t.stdby_amt as stdby_amt
,replace(replace(t.remark_field_1,chr(13),''),chr(10),'') as remark_field_1
,t.start_dt as start_dt 
,t.end_dt as end_dt 
,replace(replace(t.id_mark,chr(13),''),chr(10),'') as id_mark 
from ${iml_schema}.evt_finc_tran_entr_h t
where (start_dt <= to_date('${batch_date}','yyyymmdd') and  start_dt >= to_date('${batch_date}','yyyymmdd') -6)  or (end_dt <= to_date('${batch_date}','yyyymmdd') and  end_dt >= to_date('${batch_date}','yyyymmdd') -6) ;" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_finc_tran_entr_h_w.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes