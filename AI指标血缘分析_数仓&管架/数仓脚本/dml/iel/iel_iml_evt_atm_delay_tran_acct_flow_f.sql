: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iml_evt_atm_delay_tran_acct_flow_f
CreateDate: 20251110
FileName:   ${iel_data_path}/evt_atm_delay_tran_acct_flow.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.evt_id,chr(13),''),chr(10),'') as evt_id
,replace(replace(t1.lp_id,chr(13),''),chr(10),'') as lp_id
,replace(replace(t1.main_acct_id,chr(13),''),chr(10),'') as main_acct_id
,replace(replace(t1.sys_follow_id,chr(13),''),chr(10),'') as sys_follow_id
,replace(replace(t1.rsrv_mobile_no,chr(13),''),chr(10),'') as rsrv_mobile_no
,replace(replace(t1.curr_cd,chr(13),''),chr(10),'') as curr_cd
,replace(replace(t1.unionpay_curr_cd,chr(13),''),chr(10),'') as unionpay_curr_cd
,replace(replace(t1.tran_flow_num,chr(13),''),chr(10),'') as tran_flow_num
,midgrod_tran_dt
,tran_dt
,replace(replace(t1.tran_cd,chr(13),''),chr(10),'') as tran_cd
,replace(replace(t1.tran_type_cd,chr(13),''),chr(10),'') as tran_type_cd
,replace(replace(t1.tran_status_cd,chr(13),''),chr(10),'') as tran_status_cd
,tran_amt
,replace(replace(t1.tran_teller_id,chr(13),''),chr(10),'') as tran_teller_id
,replace(replace(t1.tran_org_id,chr(13),''),chr(10),'') as tran_org_id
,replace(replace(t1.ova_flow_num,chr(13),''),chr(10),'') as ova_flow_num
,replace(replace(t1.bus_flow_num,chr(13),''),chr(10),'') as bus_flow_num
,ghb_dtran_acct_fail_ag_cnt
,replace(replace(t1.delay_tran_acct_rest_cd,chr(13),''),chr(10),'') as delay_tran_acct_rest_cd
,replace(replace(t1.fee_type_cd,chr(13),''),chr(10),'') as fee_type_cd
,comm_fee
,clear_amt
,replace(replace(t1.tran_out_acct_id,chr(13),''),chr(10),'') as tran_out_acct_id
,replace(replace(t1.tran_out_acct_name,chr(13),''),chr(10),'') as tran_out_acct_name
,replace(replace(t1.tran_in_acct_id,chr(13),''),chr(10),'') as tran_in_acct_id
,replace(replace(t1.tran_in_acct_name,chr(13),''),chr(10),'') as tran_in_acct_name
,replace(replace(t1.open_acct_org_id,chr(13),''),chr(10),'') as open_acct_org_id
,replace(replace(t1.proc_org_id,chr(13),''),chr(10),'') as proc_org_id
,replace(replace(t1.send_org_id,chr(13),''),chr(10),'') as send_org_id
,replace(replace(t1.core_froz_flow_num,chr(13),''),chr(10),'') as core_froz_flow_num
,core_froz_dt
,replace(replace(t1.core_deduct_flow_num,chr(13),''),chr(10),'') as core_deduct_flow_num
,core_deduct_dt
,replace(replace(t1.core_memo_code,chr(13),''),chr(10),'') as core_memo_code
,replace(replace(t1.core_intfc_code,chr(13),''),chr(10),'') as core_intfc_code
,replace(replace(t1.aldy_adj_entry_flg,chr(13),''),chr(10),'') as aldy_adj_entry_flg
,replace(replace(t1.err_cd,chr(13),''),chr(10),'') as err_cd
,replace(replace(t1.err_info,chr(13),''),chr(10),'') as err_info
,replace(replace(t1.sorc_sys_cd,chr(13),''),chr(10),'') as sorc_sys_cd
,replace(replace(t1.pass_id,chr(13),''),chr(10),'') as pass_id
,replace(replace(t1.mercht_type_cd,chr(13),''),chr(10),'') as mercht_type_cd
,replace(replace(t1.proc_mercht_id,chr(13),''),chr(10),'') as proc_mercht_id
,replace(replace(t1.proc_mercht_name,chr(13),''),chr(10),'') as proc_mercht_name
,replace(replace(t1.init_sys_follow_id,chr(13),''),chr(10),'') as init_sys_follow_id
,replace(replace(t1.init_ova_flow_num,chr(13),''),chr(10),'') as init_ova_flow_num
,replace(replace(t1.init_bus_flow_num,chr(13),''),chr(10),'') as init_bus_flow_num
,replace(replace(t1.init_tran_tm,chr(13),''),chr(10),'') as init_tran_tm
,replace(replace(t1.init_tran_flow_num,chr(13),''),chr(10),'') as init_tran_flow_num
,replace(replace(t1.init_proc_org_id,chr(13),''),chr(10),'') as init_proc_org_id
,replace(replace(t1.init_send_org_id,chr(13),''),chr(10),'') as init_send_org_id
,replace(replace(t1.remark,chr(13),''),chr(10),'') as remark
,replace(replace(t1.equip_id,chr(13),''),chr(10),'') as equip_id

from ${iml_schema}.evt_atm_delay_tran_acct_flow t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/evt_atm_delay_tran_acct_flow.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
