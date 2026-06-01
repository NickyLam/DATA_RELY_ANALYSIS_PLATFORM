/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd idl_atms_dev_status_table
CreateDate: 20180515
FileType:   DML
Logs:
    zjj 2018-05-15 新建表本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 4;
alter session force parallel dml parallel 4;
-- alter session force parallel ddl parallel 4;


-- 2.1 drop timeout partition and add partition
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none;
alter table ${idl_schema}.atms_dev_status_table drop partition p_${last_date};
alter table ${idl_schema}.atms_dev_status_table drop partition p_${batch_date};

-- 2.2 add today partition
whenever sqlerror exit sql.sqlcode;
alter table ${idl_schema}.atms_dev_status_table add  partition p_${batch_date} values (to_date('${batch_date}','yyyymmdd'));

-- 2.3 insert data target table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${idl_schema}.atms_dev_status_table (
    dev_no
    ,dev_status
    ,dev_tx_status
    ,dev_net_status
    ,dev_run_status
    ,dev_cashbox_status
    ,dev_mod_status
    ,dev_potential_fault
    ,status_last_time
    ,status_expire_time
    ,tx_type
    ,tx_time
    ,atm_type
    ,cash_unit_type
    ,status_info_type
    ,combin_unit_type
    ,idc_device_status
    ,cim_device_status
    ,cdm_device_status
    ,dep_device_status
    ,ups_device_status
    ,spr_device_status
    ,rpr_device_status
    ,jpr_device_status
    ,chk_device_status
    ,ttu_device_status
    ,pbk_device_status
    ,pin_device_status
    ,siu_device_status
    ,cam_device_status
    ,idc_media_status
    ,idc_capture_bin_status
    ,idc_capture_bin_count
    ,cim_accept_or_status
    ,cim_escrow_status
    ,cim_cash_units
    ,cim_shutter_status
    ,cim_transport_status
    ,cim_inout_position
    ,cim_input_output_status
    ,cim_pu_id
    ,cim_pu_count
    ,cim_pu_cash_in_count
    ,cim_pu_status
    ,cim_pupos_name
    ,cim_cu_id
    ,cim_pcu_id
    ,cim_cu_note_value
    ,cim_cu_currency
    ,cim_cu_count
    ,cim_cu_cash_in_count
    ,cim_cu_type
    ,cim_cu_status
    ,cdm_shutter_status
    ,cdm_dispenser_status
    ,cdm_safe_door_status
    ,cdm_stacker_status
    ,cdm_cash_units
    ,cdm_transport_status
    ,cdm_out_position
    ,cdm_input_output_status
    ,cdm_pu_status
    ,cdm_pu_id
    ,cdm_pu_initial_count
    ,cdm_pu_current_count
    ,cdm_pu_reject_count
    ,cdm_pupos_name
    ,cdm_cu_id
    ,cdm_pcu_id
    ,cdm_cu_note_value
    ,cdm_cu_currency
    ,cdm_cu_current_count
    ,cdm_cu_initial_count
    ,cdm_cu_reject_count
    ,cdm_cu_type
    ,cdm_cu_status
    ,dep_deposit_status
    ,dep_deposit_container_status
    ,dep_envelope_supply_status
    ,dep_envelope_status
    ,dep_printer_status
    ,dep_printer_ink
    ,dep_deposited_items
    ,dep_transport_status
    ,dep_shutter_status
    ,ups_low
    ,ups_engaged
    ,ups_powering
    ,ups_recovered
    ,spr_media_status
    ,spr_paper_status
    ,spr_retract_bin_status
    ,spr_ink_status
    ,spr_toner_status
    ,spr_stack_count
    ,chk_media_status
    ,chk_ink_status
    ,rpr_media_status
    ,rpr_paper_status
    ,rpr_retract_bin_status
    ,rpr_ink_status
    ,rpr_toner_status
    ,jpr_media_status
    ,jpr_paper_status
    ,jpr_ink_status
    ,jpr_toner_status
    ,pbk_media_status
    ,pbk_ink_status
    ,pbk_toner_status
    ,pbk_retract_bin_status
    ,pbk_retract_bin_count
    ,siu_operator_switch
    ,siu_terminal_tamper
    ,siu_alarm_tamper
    ,siu_seismic
    ,siu_proximity_detector
    ,siu_heat
    ,siu_ambient_light
    ,siu_cabinet_state
    ,siu_safe_state
    ,siu_shield_state
    ,siu_bill_acceptor_light
    ,siu_card_reader_light
    ,siu_cheque_unit_light
    ,siu_coin_dispenser_light
    ,siu_note_dispenser_light
    ,siu_envelope_depository_light
    ,siu_passbook_printer_light
    ,siu_pinpad_light
    ,siu_receipt_printer_light
    ,siu_envelope_dispenser_light
    ,cam_camera_area
    ,cam_camera_area_status
    ,cam_media_status
    ,cam_picture_staken
    ,dev_cash_status
    ,action_type
    ,action_note
    ,icc_device_status
    ,icc_media_status
    ,isc_device_status
    ,isc_media_status
    ,irc_device_status
    ,irc_media_status
    ,fpi_device_status
    ,crd_device_status
    ,ccd_device_status
    ,dpr_device_status
    ,bcr_device_status
    ,cam_status_area
    ,cam_status_media
    ,cam_status_state
    ,cam_status_pictures
    ,start_dt
    ,end_dt
    ,id_mark
    ,etl_dt
    ,etl_timestamp
)
select 
    replace(replace(t1.dev_no,chr(13),''),chr(10),'') as dev_no 
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
    ,replace(replace(t1.ups_low,chr(13),''),chr(10),'') as ups_low 
    ,replace(replace(t1.ups_engaged,chr(13),''),chr(10),'') as ups_engaged 
    ,replace(replace(t1.ups_powering,chr(13),''),chr(10),'') as ups_powering 
    ,replace(replace(t1.ups_recovered,chr(13),''),chr(10),'') as ups_recovered 
    ,replace(replace(t1.spr_media_status,chr(13),''),chr(10),'') as spr_media_status 
    ,replace(replace(t1.spr_paper_status,chr(13),''),chr(10),'') as spr_paper_status 
    ,replace(replace(t1.spr_retract_bin_status,chr(13),''),chr(10),'') as spr_retract_bin_status 
    ,replace(replace(t1.spr_ink_status,chr(13),''),chr(10),'') as spr_ink_status 
    ,replace(replace(t1.spr_toner_status,chr(13),''),chr(10),'') as spr_toner_status 
    ,replace(replace(t1.spr_stack_count,chr(13),''),chr(10),'') as spr_stack_count 
    ,replace(replace(t1.chk_media_status,chr(13),''),chr(10),'') as chk_media_status 
    ,replace(replace(t1.chk_ink_status,chr(13),''),chr(10),'') as chk_ink_status 
    ,replace(replace(t1.rpr_media_status,chr(13),''),chr(10),'') as rpr_media_status 
    ,replace(replace(t1.rpr_paper_status,chr(13),''),chr(10),'') as rpr_paper_status 
    ,replace(replace(t1.rpr_retract_bin_status,chr(13),''),chr(10),'') as rpr_retract_bin_status 
    ,replace(replace(t1.rpr_ink_status,chr(13),''),chr(10),'') as rpr_ink_status 
    ,replace(replace(t1.rpr_toner_status,chr(13),''),chr(10),'') as rpr_toner_status 
    ,replace(replace(t1.jpr_media_status,chr(13),''),chr(10),'') as jpr_media_status 
    ,replace(replace(t1.jpr_paper_status,chr(13),''),chr(10),'') as jpr_paper_status 
    ,replace(replace(t1.jpr_ink_status,chr(13),''),chr(10),'') as jpr_ink_status 
    ,replace(replace(t1.jpr_toner_status,chr(13),''),chr(10),'') as jpr_toner_status 
    ,replace(replace(t1.pbk_media_status,chr(13),''),chr(10),'') as pbk_media_status 
    ,replace(replace(t1.pbk_ink_status,chr(13),''),chr(10),'') as pbk_ink_status 
    ,replace(replace(t1.pbk_toner_status,chr(13),''),chr(10),'') as pbk_toner_status 
    ,replace(replace(t1.pbk_retract_bin_status,chr(13),''),chr(10),'') as pbk_retract_bin_status 
    ,replace(replace(t1.pbk_retract_bin_count,chr(13),''),chr(10),'') as pbk_retract_bin_count 
    ,replace(replace(t1.siu_operator_switch,chr(13),''),chr(10),'') as siu_operator_switch 
    ,replace(replace(t1.siu_terminal_tamper,chr(13),''),chr(10),'') as siu_terminal_tamper 
    ,replace(replace(t1.siu_alarm_tamper,chr(13),''),chr(10),'') as siu_alarm_tamper 
    ,replace(replace(t1.siu_seismic,chr(13),''),chr(10),'') as siu_seismic 
    ,replace(replace(t1.siu_proximity_detector,chr(13),''),chr(10),'') as siu_proximity_detector 
    ,replace(replace(t1.siu_heat,chr(13),''),chr(10),'') as siu_heat 
    ,replace(replace(t1.siu_ambient_light,chr(13),''),chr(10),'') as siu_ambient_light 
    ,replace(replace(t1.siu_cabinet_state,chr(13),''),chr(10),'') as siu_cabinet_state 
    ,replace(replace(t1.siu_safe_state,chr(13),''),chr(10),'') as siu_safe_state 
    ,replace(replace(t1.siu_shield_state,chr(13),''),chr(10),'') as siu_shield_state 
    ,replace(replace(t1.siu_bill_acceptor_light,chr(13),''),chr(10),'') as siu_bill_acceptor_light 
    ,replace(replace(t1.siu_card_reader_light,chr(13),''),chr(10),'') as siu_card_reader_light 
    ,replace(replace(t1.siu_cheque_unit_light,chr(13),''),chr(10),'') as siu_cheque_unit_light 
    ,replace(replace(t1.siu_coin_dispenser_light,chr(13),''),chr(10),'') as siu_coin_dispenser_light 
    ,replace(replace(t1.siu_note_dispenser_light,chr(13),''),chr(10),'') as siu_note_dispenser_light 
    ,replace(replace(t1.siu_envelope_depository_light,chr(13),''),chr(10),'') as siu_envelope_depository_light 
    ,replace(replace(t1.siu_passbook_printer_light,chr(13),''),chr(10),'') as siu_passbook_printer_light 
    ,replace(replace(t1.siu_pinpad_light,chr(13),''),chr(10),'') as siu_pinpad_light 
    ,replace(replace(t1.siu_receipt_printer_light,chr(13),''),chr(10),'') as siu_receipt_printer_light 
    ,replace(replace(t1.siu_envelope_dispenser_light,chr(13),''),chr(10),'') as siu_envelope_dispenser_light 
    ,replace(replace(t1.cam_camera_area,chr(13),''),chr(10),'') as cam_camera_area 
    ,replace(replace(t1.cam_camera_area_status,chr(13),''),chr(10),'') as cam_camera_area_status 
    ,replace(replace(t1.cam_media_status,chr(13),''),chr(10),'') as cam_media_status 
    ,replace(replace(t1.cam_picture_staken,chr(13),''),chr(10),'') as cam_picture_staken 
    ,replace(replace(t1.dev_cash_status,chr(13),''),chr(10),'') as dev_cash_status 
    ,replace(replace(t1.action_type,chr(13),''),chr(10),'') as action_type 
    ,replace(replace(t1.action_note,chr(13),''),chr(10),'') as action_note 
    ,replace(replace(t1.icc_device_status,chr(13),''),chr(10),'') as icc_device_status 
    ,replace(replace(t1.icc_media_status,chr(13),''),chr(10),'') as icc_media_status 
    ,replace(replace(t1.isc_device_status,chr(13),''),chr(10),'') as isc_device_status 
    ,replace(replace(t1.isc_media_status,chr(13),''),chr(10),'') as isc_media_status 
    ,replace(replace(t1.irc_device_status,chr(13),''),chr(10),'') as irc_device_status 
    ,replace(replace(t1.irc_media_status,chr(13),''),chr(10),'') as irc_media_status 
    ,replace(replace(t1.fpi_device_status,chr(13),''),chr(10),'') as fpi_device_status 
    ,replace(replace(t1.crd_device_status,chr(13),''),chr(10),'') as crd_device_status 
    ,replace(replace(t1.ccd_device_status,chr(13),''),chr(10),'') as ccd_device_status 
    ,replace(replace(t1.dpr_device_status,chr(13),''),chr(10),'') as dpr_device_status 
    ,replace(replace(t1.bcr_device_status,chr(13),''),chr(10),'') as bcr_device_status 
    ,replace(replace(t1.cam_status_area,chr(13),''),chr(10),'') as cam_status_area 
    ,replace(replace(t1.cam_status_media,chr(13),''),chr(10),'') as cam_status_media 
    ,replace(replace(t1.cam_status_state,chr(13),''),chr(10),'') as cam_status_state 
    ,replace(replace(t1.cam_status_pictures,chr(13),''),chr(10),'') as cam_status_pictures 
    ,t1.start_dt as start_dt 
    ,t1.end_dt as end_dt 
    ,replace(replace(t1.id_mark,chr(13),''),chr(10),'') as id_mark 
    ,to_date('${batch_date}','yyyymmdd') as etl_dt 
    ,t1.etl_timestamp as etl_timestamp 
 from ${iol_schema}.atms_dev_status_table t1
where t1.start_dt<= to_date('${batch_date}','yyyymmdd') and end_dt > to_date('${batch_date}','yyyymmdd');
commit;


-- 4 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${idl_schema}',tabname => 'atms_dev_status_table',partname => 'p_${batch_date}', granularity => 'PARTITION', degree => 8, cascade => true);