/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl atms_dev_status_table
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.atms_dev_status_table
whenever sqlerror continue none;
drop table ${idl_schema}.atms_dev_status_table purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.atms_dev_status_table(
    dev_no varchar2(20) -- 
    ,dev_status varchar2(20) -- 
    ,dev_tx_status varchar2(20) -- 
    ,dev_net_status varchar2(20) -- 
    ,dev_run_status varchar2(20) -- 
    ,dev_cashbox_status varchar2(20) -- 
    ,dev_mod_status varchar2(20) -- 
    ,dev_potential_fault varchar2(20) -- 
    ,status_last_time varchar2(14) -- 
    ,status_expire_time varchar2(14) -- 
    ,tx_type varchar2(15) -- 
    ,tx_time varchar2(14) -- 
    ,atm_type varchar2(1) -- 
    ,cash_unit_type varchar2(1) -- 
    ,status_info_type varchar2(1) -- 
    ,combin_unit_type varchar2(1) -- 
    ,idc_device_status varchar2(15) -- 
    ,cim_device_status varchar2(15) -- 
    ,cdm_device_status varchar2(15) -- 
    ,dep_device_status varchar2(15) -- 
    ,ups_device_status varchar2(15) -- 
    ,spr_device_status varchar2(15) -- 
    ,rpr_device_status varchar2(15) -- 
    ,jpr_device_status varchar2(15) -- 
    ,chk_device_status varchar2(15) -- 
    ,ttu_device_status varchar2(15) -- 
    ,pbk_device_status varchar2(15) -- 
    ,pin_device_status varchar2(15) -- 
    ,siu_device_status varchar2(15) -- 
    ,cam_device_status varchar2(15) -- 
    ,idc_media_status varchar2(20) -- 
    ,idc_capture_bin_status varchar2(20) -- 
    ,idc_capture_bin_count varchar2(10) -- 
    ,cim_accept_or_status varchar2(20) -- 
    ,cim_escrow_status varchar2(20) -- 
    ,cim_cash_units varchar2(20) -- 
    ,cim_shutter_status varchar2(40) -- 
    ,cim_transport_status varchar2(40) -- 
    ,cim_inout_position varchar2(40) -- 
    ,cim_input_output_status varchar2(100) -- 
    ,cim_pu_id varchar2(100) -- 
    ,cim_pu_count varchar2(100) -- 
    ,cim_pu_cash_in_count varchar2(100) -- 
    ,cim_pu_status varchar2(100) -- 
    ,cim_pupos_name varchar2(200) -- 
    ,cim_cu_id varchar2(100) -- 
    ,cim_pcu_id varchar2(100) -- 
    ,cim_cu_note_value varchar2(100) -- 
    ,cim_cu_currency varchar2(100) -- 
    ,cim_cu_count varchar2(100) -- 
    ,cim_cu_cash_in_count varchar2(100) -- 
    ,cim_cu_type varchar2(100) -- 
    ,cim_cu_status varchar2(100) -- 
    ,cdm_shutter_status varchar2(20) -- 
    ,cdm_dispenser_status varchar2(20) -- 
    ,cdm_safe_door_status varchar2(20) -- 
    ,cdm_stacker_status varchar2(20) -- 
    ,cdm_cash_units varchar2(20) -- 
    ,cdm_transport_status varchar2(40) -- 
    ,cdm_out_position varchar2(40) -- 
    ,cdm_input_output_status varchar2(20) -- 
    ,cdm_pu_status varchar2(100) -- 
    ,cdm_pu_id varchar2(100) -- 
    ,cdm_pu_initial_count varchar2(100) -- 
    ,cdm_pu_current_count varchar2(100) -- 
    ,cdm_pu_reject_count varchar2(100) -- 
    ,cdm_pupos_name varchar2(200) -- 
    ,cdm_cu_id varchar2(100) -- 
    ,cdm_pcu_id varchar2(100) -- 
    ,cdm_cu_note_value varchar2(100) -- 
    ,cdm_cu_currency varchar2(100) -- 
    ,cdm_cu_current_count varchar2(100) -- 
    ,cdm_cu_initial_count varchar2(100) -- 
    ,cdm_cu_reject_count varchar2(100) -- 
    ,cdm_cu_type varchar2(100) -- 
    ,cdm_cu_status varchar2(100) -- 
    ,dep_deposit_status varchar2(20) -- 
    ,dep_deposit_container_status varchar2(20) -- 
    ,dep_envelope_supply_status varchar2(20) -- 
    ,dep_envelope_status varchar2(20) -- 
    ,dep_printer_status varchar2(20) -- 
    ,dep_printer_ink varchar2(20) -- 
    ,dep_deposited_items varchar2(10) -- 
    ,dep_transport_status varchar2(20) -- 
    ,dep_shutter_status varchar2(20) -- 
    ,ups_low varchar2(20) -- 
    ,ups_engaged varchar2(20) -- 
    ,ups_powering varchar2(20) -- 
    ,ups_recovered varchar2(20) -- 
    ,spr_media_status varchar2(20) -- 
    ,spr_paper_status varchar2(20) -- 
    ,spr_retract_bin_status varchar2(20) -- 
    ,spr_ink_status varchar2(20) -- 
    ,spr_toner_status varchar2(20) -- 
    ,spr_stack_count varchar2(10) -- 
    ,chk_media_status varchar2(20) -- 
    ,chk_ink_status varchar2(20) -- 
    ,rpr_media_status varchar2(20) -- 
    ,rpr_paper_status varchar2(20) -- 
    ,rpr_retract_bin_status varchar2(20) -- 
    ,rpr_ink_status varchar2(20) -- 
    ,rpr_toner_status varchar2(20) -- 
    ,jpr_media_status varchar2(20) -- 
    ,jpr_paper_status varchar2(20) -- 
    ,jpr_ink_status varchar2(20) -- 
    ,jpr_toner_status varchar2(20) -- 
    ,pbk_media_status varchar2(20) -- 
    ,pbk_ink_status varchar2(20) -- 
    ,pbk_toner_status varchar2(20) -- 
    ,pbk_retract_bin_status varchar2(20) -- 
    ,pbk_retract_bin_count varchar2(10) -- 
    ,siu_operator_switch varchar2(20) -- 
    ,siu_terminal_tamper varchar2(20) -- 
    ,siu_alarm_tamper varchar2(20) -- 
    ,siu_seismic varchar2(20) -- 
    ,siu_proximity_detector varchar2(20) -- 
    ,siu_heat varchar2(20) -- 
    ,siu_ambient_light varchar2(20) -- 
    ,siu_cabinet_state varchar2(20) -- 
    ,siu_safe_state varchar2(20) -- 
    ,siu_shield_state varchar2(20) -- 
    ,siu_bill_acceptor_light varchar2(20) -- 
    ,siu_card_reader_light varchar2(20) -- 
    ,siu_cheque_unit_light varchar2(20) -- 
    ,siu_coin_dispenser_light varchar2(20) -- 
    ,siu_note_dispenser_light varchar2(20) -- 
    ,siu_envelope_depository_light varchar2(20) -- 
    ,siu_passbook_printer_light varchar2(20) -- 
    ,siu_pinpad_light varchar2(20) -- 
    ,siu_receipt_printer_light varchar2(20) -- 
    ,siu_envelope_dispenser_light varchar2(20) -- 
    ,cam_camera_area varchar2(40) -- 
    ,cam_camera_area_status varchar2(40) -- 
    ,cam_media_status varchar2(40) -- 
    ,cam_picture_staken varchar2(10) -- 
    ,dev_cash_status varchar2(1) -- 
    ,action_type varchar2(2) -- 
    ,action_note varchar2(2) -- 
    ,icc_device_status varchar2(15) -- 
    ,icc_media_status varchar2(20) -- 
    ,isc_device_status varchar2(15) -- 
    ,isc_media_status varchar2(20) -- 
    ,irc_device_status varchar2(15) -- 
    ,irc_media_status varchar2(20) -- 
    ,fpi_device_status varchar2(15) -- 
    ,crd_device_status varchar2(15) -- 
    ,ccd_device_status varchar2(15) -- 
    ,dpr_device_status varchar2(15) -- 
    ,bcr_device_status varchar2(15) -- 
    ,cam_status_area varchar2(100) -- 
    ,cam_status_media varchar2(100) -- 
    ,cam_status_state varchar2(100) -- 
    ,cam_status_pictures varchar2(100) -- 
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on idl.atms_dev_status_table to iel;


-- comment
comment on table ${idl_schema}.atms_dev_status_table is '设备模块状态表';
comment on column ${idl_schema}.atms_dev_status_table.dev_no is '';
comment on column ${idl_schema}.atms_dev_status_table.dev_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dev_tx_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dev_net_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dev_run_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dev_cashbox_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dev_mod_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dev_potential_fault is '';
comment on column ${idl_schema}.atms_dev_status_table.status_last_time is '';
comment on column ${idl_schema}.atms_dev_status_table.status_expire_time is '';
comment on column ${idl_schema}.atms_dev_status_table.tx_type is '';
comment on column ${idl_schema}.atms_dev_status_table.tx_time is '';
comment on column ${idl_schema}.atms_dev_status_table.atm_type is '';
comment on column ${idl_schema}.atms_dev_status_table.cash_unit_type is '';
comment on column ${idl_schema}.atms_dev_status_table.status_info_type is '';
comment on column ${idl_schema}.atms_dev_status_table.combin_unit_type is '';
comment on column ${idl_schema}.atms_dev_status_table.idc_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dep_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.ups_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.spr_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.rpr_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.jpr_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.chk_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.ttu_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.pbk_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.pin_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cam_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.idc_media_status is '';
comment on column ${idl_schema}.atms_dev_status_table.idc_capture_bin_status is '';
comment on column ${idl_schema}.atms_dev_status_table.idc_capture_bin_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_accept_or_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_escrow_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_cash_units is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_shutter_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_transport_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_inout_position is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_input_output_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_pu_id is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_pu_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_pu_cash_in_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_pu_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_pupos_name is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_cu_id is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_pcu_id is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_cu_note_value is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_cu_currency is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_cu_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_cu_cash_in_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_cu_type is '';
comment on column ${idl_schema}.atms_dev_status_table.cim_cu_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_shutter_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_dispenser_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_safe_door_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_stacker_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_cash_units is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_transport_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_out_position is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_input_output_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_pu_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_pu_id is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_pu_initial_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_pu_current_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_pu_reject_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_pupos_name is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_cu_id is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_pcu_id is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_cu_note_value is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_cu_currency is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_cu_current_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_cu_initial_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_cu_reject_count is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_cu_type is '';
comment on column ${idl_schema}.atms_dev_status_table.cdm_cu_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dep_deposit_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dep_deposit_container_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dep_envelope_supply_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dep_envelope_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dep_printer_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dep_printer_ink is '';
comment on column ${idl_schema}.atms_dev_status_table.dep_deposited_items is '';
comment on column ${idl_schema}.atms_dev_status_table.dep_transport_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dep_shutter_status is '';
comment on column ${idl_schema}.atms_dev_status_table.ups_low is '';
comment on column ${idl_schema}.atms_dev_status_table.ups_engaged is '';
comment on column ${idl_schema}.atms_dev_status_table.ups_powering is '';
comment on column ${idl_schema}.atms_dev_status_table.ups_recovered is '';
comment on column ${idl_schema}.atms_dev_status_table.spr_media_status is '';
comment on column ${idl_schema}.atms_dev_status_table.spr_paper_status is '';
comment on column ${idl_schema}.atms_dev_status_table.spr_retract_bin_status is '';
comment on column ${idl_schema}.atms_dev_status_table.spr_ink_status is '';
comment on column ${idl_schema}.atms_dev_status_table.spr_toner_status is '';
comment on column ${idl_schema}.atms_dev_status_table.spr_stack_count is '';
comment on column ${idl_schema}.atms_dev_status_table.chk_media_status is '';
comment on column ${idl_schema}.atms_dev_status_table.chk_ink_status is '';
comment on column ${idl_schema}.atms_dev_status_table.rpr_media_status is '';
comment on column ${idl_schema}.atms_dev_status_table.rpr_paper_status is '';
comment on column ${idl_schema}.atms_dev_status_table.rpr_retract_bin_status is '';
comment on column ${idl_schema}.atms_dev_status_table.rpr_ink_status is '';
comment on column ${idl_schema}.atms_dev_status_table.rpr_toner_status is '';
comment on column ${idl_schema}.atms_dev_status_table.jpr_media_status is '';
comment on column ${idl_schema}.atms_dev_status_table.jpr_paper_status is '';
comment on column ${idl_schema}.atms_dev_status_table.jpr_ink_status is '';
comment on column ${idl_schema}.atms_dev_status_table.jpr_toner_status is '';
comment on column ${idl_schema}.atms_dev_status_table.pbk_media_status is '';
comment on column ${idl_schema}.atms_dev_status_table.pbk_ink_status is '';
comment on column ${idl_schema}.atms_dev_status_table.pbk_toner_status is '';
comment on column ${idl_schema}.atms_dev_status_table.pbk_retract_bin_status is '';
comment on column ${idl_schema}.atms_dev_status_table.pbk_retract_bin_count is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_operator_switch is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_terminal_tamper is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_alarm_tamper is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_seismic is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_proximity_detector is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_heat is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_ambient_light is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_cabinet_state is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_safe_state is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_shield_state is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_bill_acceptor_light is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_card_reader_light is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_cheque_unit_light is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_coin_dispenser_light is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_note_dispenser_light is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_envelope_depository_light is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_passbook_printer_light is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_pinpad_light is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_receipt_printer_light is '';
comment on column ${idl_schema}.atms_dev_status_table.siu_envelope_dispenser_light is '';
comment on column ${idl_schema}.atms_dev_status_table.cam_camera_area is '';
comment on column ${idl_schema}.atms_dev_status_table.cam_camera_area_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cam_media_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cam_picture_staken is '';
comment on column ${idl_schema}.atms_dev_status_table.dev_cash_status is '';
comment on column ${idl_schema}.atms_dev_status_table.action_type is '';
comment on column ${idl_schema}.atms_dev_status_table.action_note is '';
comment on column ${idl_schema}.atms_dev_status_table.icc_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.icc_media_status is '';
comment on column ${idl_schema}.atms_dev_status_table.isc_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.isc_media_status is '';
comment on column ${idl_schema}.atms_dev_status_table.irc_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.irc_media_status is '';
comment on column ${idl_schema}.atms_dev_status_table.fpi_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.crd_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.ccd_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.dpr_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.bcr_device_status is '';
comment on column ${idl_schema}.atms_dev_status_table.cam_status_area is '';
comment on column ${idl_schema}.atms_dev_status_table.cam_status_media is '';
comment on column ${idl_schema}.atms_dev_status_table.cam_status_state is '';
comment on column ${idl_schema}.atms_dev_status_table.cam_status_pictures is '';
comment on column ${idl_schema}.atms_dev_status_table.start_dt is '开始时间';
comment on column ${idl_schema}.atms_dev_status_table.end_dt is '结束时间';
comment on column ${idl_schema}.atms_dev_status_table.id_mark is '增删标志';
comment on column ${idl_schema}.atms_dev_status_table.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.atms_dev_status_table.etl_timestamp is 'ETL处理时间戳';
