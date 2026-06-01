: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_scss_unp_atm_tran_flow_a
CreateDate: 20240330
FileName:   ${iel_data_path}/evt_scss_unp_atm_tran_flow.a.${batch_date}.dat
IF_mark:    a
Logs:
' \
        query="select
etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,sys_dt
,replace(replace(t1.sys_flow_num,chr(13),''),chr(10),'') as sys_flow_num
,replace(replace(t1.req_flow_num,chr(13),''),chr(10),'') as req_flow_num
,replace(replace(t1.aldy_revo_flg,chr(13),''),chr(10),'') as aldy_revo_flg
,replace(replace(t1.revo_flow_num,chr(13),''),chr(10),'') as revo_flow_num
,replace(replace(t1.revo_front_flow_num,chr(13),''),chr(10),'') as revo_front_flow_num
,replace(replace(t1.chn_id,chr(13),''),chr(10),'') as chn_id
,replace(replace(t1.src_chn_id,chr(13),''),chr(10),'') as src_chn_id
,chn_dt
,replace(replace(t1.check_entry_code,chr(13),''),chr(10),'') as check_entry_code
,replace(replace(t1.mercht_type_cd,chr(13),''),chr(10),'') as mercht_type_cd
,replace(replace(t1.mercht_id,chr(13),''),chr(10),'') as mercht_id
,replace(replace(t1.mercht_name,chr(13),''),chr(10),'') as mercht_name
,replace(replace(t1.unionpay_org_id,chr(13),''),chr(10),'') as unionpay_org_id
,replace(replace(t1.unionpay_rg_code,chr(13),''),chr(10),'') as unionpay_rg_code
,replace(replace(t1.agent_org_id,chr(13),''),chr(10),'') as agent_org_id
,replace(replace(t1.tran_code,chr(13),''),chr(10),'') as tran_code
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,replace(replace(t1.return_code,chr(13),''),chr(10),'') as return_code
,replace(replace(t1.return_descb,chr(13),''),chr(10),'') as return_descb
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,tran_amt
,replace(replace(t1.init_intfc_code,chr(13),''),chr(10),'') as init_intfc_code
,replace(replace(t1.tran_sub_module_code,chr(13),''),chr(10),'') as tran_sub_module_code
,replace(replace(t1.tran_acct_id,chr(13),''),chr(10),'') as tran_acct_id
,replace(replace(t1.tran_acct_name,chr(13),''),chr(10),'') as tran_acct_name
,replace(replace(t1.tran_acct_type_cd,chr(13),''),chr(10),'') as tran_acct_type_cd
,replace(replace(t1.card_iss_org_id,chr(13),''),chr(10),'') as card_iss_org_id
,replace(replace(t1.card_level_cd,chr(13),''),chr(10),'') as card_level_cd
,replace(replace(t1.stl_card_flg,chr(13),''),chr(10),'') as stl_card_flg
,replace(replace(t1.corp_stl_card_lp_name,chr(13),''),chr(10),'') as corp_stl_card_lp_name
,replace(replace(t1.cert_type_cd,chr(13),''),chr(10),'') as cert_type_cd
,replace(replace(t1.cert_no,chr(13),''),chr(10),'') as cert_no
,replace(replace(t1.mobile_no,chr(13),''),chr(10),'') as mobile_no
,replace(replace(t1.tran_out_acct_id,chr(13),''),chr(10),'') as tran_out_acct_id
,replace(replace(t1.tran_out_acct_name,chr(13),''),chr(10),'') as tran_out_acct_name
,replace(replace(t1.tran_out_acct_org_id,chr(13),''),chr(10),'') as tran_out_acct_org_id
,replace(replace(t1.tran_in_acct_id,chr(13),''),chr(10),'') as tran_in_acct_id
,replace(replace(t1.tran_in_acct_name,chr(13),''),chr(10),'') as tran_in_acct_name
,replace(replace(t1.tran_in_acct_org_id,chr(13),''),chr(10),'') as tran_in_acct_org_id
,replace(replace(t1.dr_acct_id1,chr(13),''),chr(10),'') as dr_acct_id1
,replace(replace(t1.dr_acct_name1,chr(13),''),chr(10),'') as dr_acct_name1
,replace(replace(t1.cr_acct_id1,chr(13),''),chr(10),'') as cr_acct_id1
,replace(replace(t1.cr_acct_name1,chr(13),''),chr(10),'') as cr_acct_name1
,tran_amt1
,replace(replace(t1.dr_acct_id2,chr(13),''),chr(10),'') as dr_acct_id2
,replace(replace(t1.dr_acct_name2,chr(13),''),chr(10),'') as dr_acct_name2
,replace(replace(t1.cr_acct_id2,chr(13),''),chr(10),'') as cr_acct_id2
,replace(replace(t1.cr_acct_name2,chr(13),''),chr(10),'') as cr_acct_name2
,tran_amt2
,replace(replace(t1.dr_acct_id3,chr(13),''),chr(10),'') as dr_acct_id3
,replace(replace(t1.dr_acct_name3,chr(13),''),chr(10),'') as dr_acct_name3
,replace(replace(t1.cr_acct_id3,chr(13),''),chr(10),'') as cr_acct_id3
,replace(replace(t1.cr_acct_name3,chr(13),''),chr(10),'') as cr_acct_name3
,tran_amt3
,replace(replace(t1.dr_acct_id4,chr(13),''),chr(10),'') as dr_acct_id4
,replace(replace(t1.dr_acct_name4,chr(13),''),chr(10),'') as dr_acct_name4
,replace(replace(t1.cr_acct_id4,chr(13),''),chr(10),'') as cr_acct_id4
,replace(replace(t1.cr_acct_name4,chr(13),''),chr(10),'') as cr_acct_name4
,tran_amt4
,replace(replace(t1.comm_fee_dr_acct_id,chr(13),''),chr(10),'') as comm_fee_dr_acct_id
,replace(replace(t1.comm_fee_dr_acct_name,chr(13),''),chr(10),'') as comm_fee_dr_acct_name
,replace(replace(t1.comm_fee_cr_acct_id,chr(13),''),chr(10),'') as comm_fee_cr_acct_id
,replace(replace(t1.comm_fee_cr_acct_name,chr(13),''),chr(10),'') as comm_fee_cr_acct_name
,comm_fee_amt
,replace(replace(t1.remark1,chr(13),''),chr(10),'') as remark1
,actl_bal
,acct_bal
,replace(replace(t1.remark2,chr(13),''),chr(10),'') as remark2
,replace(replace(t1.serv_src_init_sys_id,chr(13),''),chr(10),'') as serv_src_init_sys_id
,replace(replace(t1.serv_target_sys_id,chr(13),''),chr(10),'') as serv_target_sys_id
,replace(replace(t1.serv_msg_id,chr(13),''),chr(10),'') as serv_msg_id
,replace(replace(t1.serv_caller_sys_id,chr(13),''),chr(10),'') as serv_caller_sys_id
,replace(replace(t1.serv_ova_flow_num,chr(13),''),chr(10),'') as serv_ova_flow_num
,replace(replace(t1.serv_caller_tran_flow_num,chr(13),''),chr(10),'') as serv_caller_tran_flow_num
,serv_caller_tran_dt
,replace(replace(t1.serv_name,chr(13),''),chr(10),'') as serv_name
,replace(replace(t1.serv_tran_code,chr(13),''),chr(10),'') as serv_tran_code
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.core_flow_num,chr(13),''),chr(10),'') as core_flow_num
,core_dt
,replace(replace(t1.core_return_code,chr(13),''),chr(10),'') as core_return_code
,replace(replace(t1.core_return_info,chr(13),''),chr(10),'') as core_return_info
,froz_dt
,replace(replace(t1.froz_flow,chr(13),''),chr(10),'') as froz_flow
,replace(replace(t1.init_serv_caller_tran_flow_num,chr(13),''),chr(10),'') as init_serv_caller_tran_flow_num
,init_serv_caller_tran_dt
,replace(replace(t1.init_upp_tran_flow_num,chr(13),''),chr(10),'') as init_upp_tran_flow_num
,init_upp_tran_dt
,init_froz_dt
,replace(replace(t1.init_froz_flow_num,chr(13),''),chr(10),'') as init_froz_flow_num
,replace(replace(t1.cust_id,chr(13),''),chr(10),'') as cust_id
,replace(replace(t1.cust_belong_org_id,chr(13),''),chr(10),'') as cust_belong_org_id
,replace(replace(t1.auth_flow_num,chr(13),''),chr(10),'') as auth_flow_num
,replace(replace(t1.auth_teller_id,chr(13),''),chr(10),'') as auth_teller_id
,replace(replace(t1.check_teller_id,chr(13),''),chr(10),'') as check_teller_id
,replace(replace(t1.tran_serv_process_cd,chr(13),''),chr(10),'') as tran_serv_process_cd
,acctnt_dt
,insto_dt
,final_update_dt
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark

from ${iml_schema}.evt_scss_unp_atm_tran_flow t1
where etl_dt <= to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_scss_unp_atm_tran_flow.a.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
