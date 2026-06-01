: '
Purpose:    unload config for sqluldr2
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iel_iol_atms_dev_status_table_f
CreateDate: 20230607
FileName:   ${iel_data_path}/atms_dev_status_table.f.${batch_date}.dat
IF_mark:    f
Logs:
' \
        query="select
to_date('${batch_date}','yyyymmdd') as etl_dt
,replace(replace(t1.dev_no,chr(13),''),chr(10),'') as dev_no
,replace(replace(t1.dev_status,chr(13),''),chr(10),'') as dev_status
,replace(replace(t1.dev_tx_status,chr(13),''),chr(10),'') as dev_tx_status
,replace(replace(t1.dev_net_status,chr(13),''),chr(10),'') as dev_net_status
,replace(replace(t1.dev_run_status,chr(13),''),chr(10),'') as dev_run_status
,replace(replace(t1.dev_cashbox_status,chr(13),''),chr(10),'') as dev_cashbox_status
,replace(replace(t1.dev_mod_status,chr(13),''),chr(10),'') as dev_mod_status
,replace(replace(t1.dev_potential_fault,chr(13),''),chr(10),'') as dev_potential_fault
,replace(replace(t1.status_last_time,chr(13),''),chr(10),'') as status_last_time
,replace(replace(t1.status_expire_time,chr(13),''),chr(10),'') as status_expire_time
,replace(replace(t1.tx_type,chr(13),''),chr(10),'') as tx_type
,replace(replace(t1.tx_time,chr(13),''),chr(10),'') as tx_time
,replace(replace(t1.atm_type,chr(13),''),chr(10),'') as atm_type
,replace(replace(t1.cash_unit_type,chr(13),''),chr(10),'') as cash_unit_type
,replace(replace(t1.status_info_type,chr(13),''),chr(10),'') as status_info_type
,replace(replace(t1.combin_unit_type,chr(13),''),chr(10),'') as combin_unit_type
,replace(replace(t1.idc_device_status,chr(13),''),chr(10),'') as idc_device_status
,replace(replace(t1.cim_device_status,chr(13),''),chr(10),'') as cim_device_status
,replace(replace(t1.cdm_device_status,chr(13),''),chr(10),'') as cdm_device_status
,replace(replace(t1.dep_device_status,chr(13),''),chr(10),'') as dep_device_status
,replace(replace(t1.ups_device_status,chr(13),''),chr(10),'') as ups_device_status
,replace(replace(t1.spr_device_status,chr(13),''),chr(10),'') as spr_device_status
,replace(replace(t1.rpr_device_status,chr(13),''),chr(10),'') as rpr_device_status
,replace(replace(t1.jpr_device_status,chr(13),''),chr(10),'') as jpr_device_status
,replace(replace(t1.chk_device_status,chr(13),''),chr(10),'') as chk_device_status
,replace(replace(t1.ttu_device_status,chr(13),''),chr(10),'') as ttu_device_status
,replace(replace(t1.pbk_device_status,chr(13),''),chr(10),'') as pbk_device_status
,replace(replace(t1.pin_device_status,chr(13),''),chr(10),'') as pin_device_status
,replace(replace(t1.siu_device_status,chr(13),''),chr(10),'') as siu_device_status
,replace(replace(t1.cam_device_status,chr(13),''),chr(10),'') as cam_device_status
,replace(replace(t1.idc_media_status,chr(13),''),chr(10),'') as idc_media_status
,replace(replace(t1.idc_capture_bin_status,chr(13),''),chr(10),'') as idc_capture_bin_status
,replace(replace(t1.idc_capture_bin_count,chr(13),''),chr(10),'') as idc_capture_bin_count
,replace(replace(t1.cim_accept_or_status,chr(13),''),chr(10),'') as cim_accept_or_status
,replace(replace(t1.cim_escrow_status,chr(13),''),chr(10),'') as cim_escrow_status
,replace(replace(t1.cim_cash_units,chr(13),''),chr(10),'') as cim_cash_units
,replace(replace(t1.cim_shutter_status,chr(13),''),chr(10),'') as cim_shutter_status
,replace(replace(t1.cim_transport_status,chr(13),''),chr(10),'') as cim_transport_status
,replace(replace(t1.cim_inout_position,chr(13),''),chr(10),'') as cim_inout_position
,replace(replace(t1.cim_input_output_status,chr(13),''),chr(10),'') as cim_input_output_status
,replace(replace(t1.cim_pu_id,chr(13),''),chr(10),'') as cim_pu_id
,replace(replace(t1.cim_pu_count,chr(13),''),chr(10),'') as cim_pu_count
,replace(replace(t1.cim_pu_cash_in_count,chr(13),''),chr(10),'') as cim_pu_cash_in_count
,replace(replace(t1.cim_pu_status,chr(13),''),chr(10),'') as cim_pu_status
,replace(replace(t1.cim_pupos_name,chr(13),''),chr(10),'') as cim_pupos_name
,replace(replace(t1.cim_cu_id,chr(13),''),chr(10),'') as cim_cu_id
,replace(replace(t1.cim_pcu_id,chr(13),''),chr(10),'') as cim_pcu_id
,replace(replace(t1.cim_cu_note_value,chr(13),''),chr(10),'') as cim_cu_note_value
,replace(replace(t1.cim_cu_currency,chr(13),''),chr(10),'') as cim_cu_currency
,replace(replace(t1.cim_cu_count,chr(13),''),chr(10),'') as cim_cu_count
,replace(replace(t1.cim_cu_cash_in_count,chr(13),''),chr(10),'') as cim_cu_cash_in_count
,replace(replace(t1.cim_cu_type,chr(13),''),chr(10),'') as cim_cu_type
,replace(replace(t1.cim_cu_status,chr(13),''),chr(10),'') as cim_cu_status
,replace(replace(t1.cdm_shutter_status,chr(13),''),chr(10),'') as cdm_shutter_status
,replace(replace(t1.cdm_dispenser_status,chr(13),''),chr(10),'') as cdm_dispenser_status
,replace(replace(t1.cdm_safe_door_status,chr(13),''),chr(10),'') as cdm_safe_door_status
,replace(replace(t1.cdm_stacker_status,chr(13),''),chr(10),'') as cdm_stacker_status
,replace(replace(t1.cdm_cash_units,chr(13),''),chr(10),'') as cdm_cash_units
,replace(replace(t1.cdm_transport_status,chr(13),''),chr(10),'') as cdm_transport_status
,replace(replace(t1.cdm_out_position,chr(13),''),chr(10),'') as cdm_out_position
,replace(replace(t1.cdm_input_output_status,chr(13),''),chr(10),'') as cdm_input_output_status
,replace(replace(t1.cdm_pu_status,chr(13),''),chr(10),'') as cdm_pu_status
,replace(replace(t1.cdm_pu_id,chr(13),''),chr(10),'') as cdm_pu_id
,replace(replace(t1.cdm_pu_initial_count,chr(13),''),chr(10),'') as cdm_pu_initial_count
,replace(replace(t1.cdm_pu_current_count,chr(13),''),chr(10),'') as cdm_pu_current_count
,replace(replace(t1.cdm_pu_reject_count,chr(13),''),chr(10),'') as cdm_pu_reject_count
,replace(replace(t1.cdm_pupos_name,chr(13),''),chr(10),'') as cdm_pupos_name
,replace(replace(t1.cdm_cu_id,chr(13),''),chr(10),'') as cdm_cu_id
,replace(replace(t1.cdm_pcu_id,chr(13),''),chr(10),'') as cdm_pcu_id
,replace(replace(t1.cdm_cu_note_value,chr(13),''),chr(10),'') as cdm_cu_note_value
,replace(replace(t1.cdm_cu_currency,chr(13),''),chr(10),'') as cdm_cu_currency
,replace(replace(t1.cdm_cu_current_count,chr(13),''),chr(10),'') as cdm_cu_current_count
,replace(replace(t1.cdm_cu_initial_count,chr(13),''),chr(10),'') as cdm_cu_initial_count
,replace(replace(t1.cdm_cu_reject_count,chr(13),''),chr(10),'') as cdm_cu_reject_count
,replace(replace(t1.cdm_cu_type,chr(13),''),chr(10),'') as cdm_cu_type
,replace(replace(t1.cdm_cu_status,chr(13),''),chr(10),'') as cdm_cu_status
,replace(replace(t1.dep_deposit_status,chr(13),''),chr(10),'') as dep_deposit_status
,replace(replace(t1.dep_deposit_container_status,chr(13),''),chr(10),'') as dep_deposit_container_status
,replace(replace(t1.dep_envelope_supply_status,chr(13),''),chr(10),'') as dep_envelope_supply_status
,replace(replace(t1.dep_envelope_status,chr(13),''),chr(10),'') as dep_envelope_status
,replace(replace(t1.dep_printer_status,chr(13),''),chr(10),'') as dep_printer_status
,replace(replace(t1.dep_printer_ink,chr(13),''),chr(10),'') as dep_printer_ink
,replace(replace(t1.dep_deposited_items,chr(13),''),chr(10),'') as dep_deposited_items
,replace(replace(t1.dep_transport_status,chr(13),''),chr(10),'') as dep_transport_status
,replace(replace(t1.dep_shutter_status,chr(13),''),chr(10),'') as dep_shutter_status

from ${iol_schema}.atms_dev_status_table t1
where start_dt <= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd')" \
        field="0x1b" record="0x0a"  \
        file="${iel_data_path}/atms_dev_status_table.f.${batch_date}.dat" \
        charset=zhs16gbk
        safe=yes
