: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_idl_aml_evt_core_entry_flow_i
CreateDate: 20180529
FileName:   ${iel_data_path}/aml_evt_core_entry_flow.i.${batch_date}.dat
IF_mark:    i
Logs:
   zjj 2018-07-27 create template
' \
        query="select etl_dt
,evt_id
,tran_id
,tran_dt
,lp_id
,org_id
,entry_cancel_flg
,entry_flow_num
,hxp_tran_flg
,msg_send_status_cd
,err_cd
,err_rs
,bus_type_cd
,buy_dtl_id
,bill_id
,cont_id
,entry_way_cd
,final_modif_operr_id
,final_modif_tm
,bill_uniq_ind_no
,forgn_sys_bill_uniq_ind_no
,entry_step_seq_num
,sugst_pay_appl_flow_num from idl.aml_evt_core_entry_flow where etl_dt =to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/aml_evt_core_entry_flow.i.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes