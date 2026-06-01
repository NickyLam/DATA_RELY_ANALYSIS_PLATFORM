: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_icl_cmm_agent_consmt_tran_dtl_m_i
CreateDate: 20180529
FileName:   ${iel_data_path}/cmm_agent_consmt_tran_dtl_m.i.${batch_date}.dat
IF_mark:    m_i
Logs:
   zjj 2018-07-27 create template
' \
        query="select
etl_dt
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.ta_cd,chr(13),''),chr(10),'') as ta_cd
,t1.ta_cfm_dt as ta_cfm_dt
,replace(replace(t1.ta_cfm_flow_num,chr(13),''),chr(10),'') as ta_cfm_flow_num
,replace(replace(t1.rela_flow_num,chr(13),''),chr(10),'') as rela_flow_num
,replace(replace(t1.appl_form_id,chr(13),''),chr(10),'') as appl_form_id
,replace(replace(t1.init_appl_form_id,chr(13),''),chr(10),'') as init_appl_form_id
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.prod_acct_id,chr(13),''),chr(10),'') as prod_acct_id
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.bank_acct_id,chr(13),''),chr(10),'') as bank_acct_id
,replace(replace(t1.prod_id,chr(13),''),chr(10),'') as prod_id
,replace(replace(t1.std_prod_id,chr(13),''),chr(10),'') as std_prod_id
,replace(replace(t1.prod_name,chr(13),''),chr(10),'') as prod_name
,replace(replace(t1.cust_mgr_id,chr(13),''),chr(10),'') as cust_mgr_id
,replace(replace(t1.consmt_bus_type_cd,chr(13),''),chr(10),'') as consmt_bus_type_cd
,replace(replace(t1.sell_mode_cd,chr(13),''),chr(10),'') as sell_mode_cd
,replace(replace(t1.bus_cd,chr(13),''),chr(10),'') as bus_cd
,replace(replace(t1.cust_type_cd,chr(13),''),chr(10),'') as cust_type_cd
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.divd_way_cd,chr(13),''),chr(10),'') as divd_way_cd
,replace(replace(t1.huge_redem_proc_cd,chr(13),''),chr(10),'') as huge_redem_proc_cd
,replace(replace(t1.tran_chn_cd,chr(13),''),chr(10),'') as tran_chn_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,t1.appl_lot as appl_lot
,t1.appl_amt as appl_amt
,t1.cfm_lot as cfm_lot
,t1.cfm_amt as cfm_amt
,t1.tran_comm_fee as tran_comm_fee
,replace(replace(t1.tran_return_code,chr(13),''),chr(10),'') as tran_return_code
,replace(replace(t1.tran_return_info,chr(13),''),chr(10),'') as tran_return_info
,replace(replace(t1.tran_subrch_id,chr(13),''),chr(10),'') as tran_subrch_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,t1.tran_happ_dt as tran_happ_dt
,t1.tran_happ_tm as tran_happ_tm
,t1.prod_nv as prod_nv
,t1.tran_agent_fee as tran_agent_fee
,replace(replace(t1.tran_belong_org_id,chr(13),''),chr(10),'') as tran_belong_org_id
from ${icl_schema}.cmm_agent_consmt_tran_dtl t1
where to_char(trunc(ta_cfm_dt),'yyyymm') = to_char(to_date('${batch_date}','yyyymmdd'),'yyyymm')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/cmm_agent_consmt_tran_dtl_m.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes