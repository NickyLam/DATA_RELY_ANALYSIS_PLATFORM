/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_dev_status_table
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 3;
alter session force parallel dml parallel 3;

declare
  v_var    number(3)  :=0;
  v_sql    varchar2(1000);
  
begin
  for tb in (SELECT TO_CHAR(END_DT, 'yyyymmdd') as end_dt
               FROM (SELECT END_DT,
                            ROW_NUMBER() OVER(PARTITION BY END_DT ORDER BY END_DT) RN
                       FROM atms_dev_status_table_bak${batch_date})
              WHERE RN = 1
 ) loop

  select count(partition_name) into v_var 
    from user_tab_partitions 
   where substr(partition_name,3) = tb.end_dt 
     and table_name = upper('atms_dev_status_table');
  
  if v_var <> 0 then 
    execute immediate 'alter table atms_dev_status_table drop partition p_' || tb.end_dt;
  end if;
  
    v_sql :='alter table atms_dev_status_table add partition p_' || tb.end_dt || ' values(to_date(' || tb.end_dt || ',''yyyymmdd''))';
    
    execute immediate v_sql;

  
   -- 回插所有数据    
   
insert /*+ append */ into ${iol_schema}.atms_dev_status_table(
            dev_no -- 设备号
            ,dev_status -- HEALTHY(正常) FATAL（故障）WARNING（警告）UNKNOWN（未知）
            ,dev_tx_status -- HEALTHY（正常）PARTSERVICE（部分服务）NOSERVICE（停止服务）UNKNOWN（未知）
            ,dev_net_status -- HEALTHY（正常）FATAL（故障，即离线）WARNING（警告）UNKNOW（未知）
            ,dev_run_status -- HEALTHY(正常) CLOSE（关机）MAINTAIN（维护）NETFATAL（P通讯故障）PARTSERVICE（部分服务）NOSERVICE（停止服务）STOP（停用）UNKNOWN（未知）
            ,dev_cashbox_status -- OK（充足）LOW（不足）EMPTY（缺炒）FULL（钞满）UNKNOWN（未知）
            ,dev_mod_status -- HEALTHY(正常) FATAL（故障） WARNING（警告） UNKNOWN（未知）
            ,dev_potential_fault -- 设备是否存在潜在故障（未使用）
            ,status_last_time -- 上次更新时间（yyyymmddhhmmss）
            ,status_expire_time -- 状态超时时间（yyyymmddhhmmss）
            ,tx_type -- CWD-取款 DET-存款
            ,tx_time -- 交易时间（yyyymmddhhmmss）
            ,atm_type -- 1 --自动取款机(ATM) 2--自动存款机(CDM) 3--自动存取款机(CRS) 4--多媒体查询机(BSM)
            ,cash_unit_type -- P--Physical,L--Logical
            ,status_info_type -- 1--定时状态报文 2--强制发送状态报文
            ,combin_unit_type -- 0--按默认方式合并 1--按PUPosName合并 2--按DevCdmCUID合并 3--按PUPosName和DevCdmCUID合并
            ,idc_device_status -- HEALTHY FATAL WARNING NODEVICE UNKNOWN
            ,cim_device_status -- CIM模块状态
            ,cdm_device_status -- CMD模块状态
            ,dep_device_status -- DEP模块状态
            ,ups_device_status -- UPS模块状态
            ,spr_device_status -- SPR模块状态
            ,rpr_device_status -- RPR模块状态
            ,jpr_device_status -- JPR模块状态
            ,chk_device_status -- CHK模块状态
            ,ttu_device_status -- TTU模块状态
            ,pbk_device_status -- PBK模块状态
            ,pin_device_status -- PIN模块状态
            ,siu_device_status -- SIU模块状态
            ,cam_device_status -- CAM模块状态
            ,idc_media_status -- PRESENT NOTPRESENT INJAWS JAMMED
            ,idc_capture_bin_status -- NOBIN BINOK BINHIGH BINFULL
            ,idc_capture_bin_count -- 回收箱数量
            ,cim_accept_or_status -- HEALTHY FATAL UNKNOWN
            ,cim_escrow_status -- EMPTY NOEMPTY FULL NOESCROW UNKNOWN
            ,cim_cash_units -- OK, Warning, Fatal, Unknown
            ,cim_shutter_status -- Closed, Open, Jammed, Unknown, NotSupported
            ,cim_transport_status -- OK, Inoperable, Unknown, NotSupported
            ,cim_inout_position -- InLeft,InRight,InCenter,InTop,InBottom,InFront,InRear,OutLeft,OutRight, OutCenter, OutTop, OutBottom, OutFront, OutRear
            ,cim_input_output_status -- EMPTY NOEMPTY UNKNOWN
            ,cim_pu_id -- 物理单元标识（数组）
            ,cim_pu_count -- 当前物理单元纸币数（数组）
            ,cim_pu_cash_in_count -- 物理单元废钞数（数组）
            ,cim_pu_status -- 逻辑单元状态
            ,cim_pupos_name -- CIM物理钞箱物理位置名集合
            ,cim_cu_id -- 逻辑单元标识（数组）
            ,cim_pcu_id -- 物理单元与逻辑单元对应关系（数组）
            ,cim_cu_note_value -- 逻辑单元纸币面值（数组）
            ,cim_cu_currency -- 逻辑单元币种（数组）
            ,cim_cu_count -- 当前逻辑单元纸币数（数组）
            ,cim_cu_cash_in_count -- 逻辑单元废钞数（数组）
            ,cim_cu_type -- 逻辑单元类型
            ,cim_cu_status -- CIM逻辑单元状态
            ,cdm_shutter_status -- Closed, Open, Jammed, Unknown, NotSupported
            ,cdm_dispenser_status -- 退钞状态
            ,cdm_safe_door_status -- OPEN FATAL CLOSED LOCKED NOTSUPPORTED
            ,cdm_stacker_status -- CDM暂存器状态
            ,cdm_cash_units -- OK, Warning, Fatal, Unknown
            ,cdm_transport_status -- OK, Inoperable, Unknown, NotSupported
            ,cdm_out_position -- Left,Right,Center,Top,Bottom,Front,Rear
            ,cdm_input_output_status -- EMPTY NOTEMPTY UNKNOWN NOTSUPPORTED
            ,cdm_pu_status -- 物理单元状态(数组)
            ,cdm_pu_id -- CDM物理单元标识（数组）
            ,cdm_pu_initial_count -- CDM当前物理单元纸币数（数组）
            ,cdm_pu_current_count -- 当前物理单元初始币数
            ,cdm_pu_reject_count -- CDM物理单元废钞数（数组）
            ,cdm_pupos_name -- CDM物理钞箱物理位置名集合
            ,cdm_cu_id -- CDM逻辑单元标识（数组）
            ,cdm_pcu_id -- CDM物理单元与逻辑单元对应关系（数组）
            ,cdm_cu_note_value -- CDM逻辑单元纸币面值（数组）
            ,cdm_cu_currency -- CDM逻辑单元币种（数组）
            ,cdm_cu_current_count -- CDM当前逻辑单元纸币数（数组）
            ,cdm_cu_initial_count -- 当前逻辑单元初始币数
            ,cdm_cu_reject_count -- CDM逻辑单元废钞数（数组）
            ,cdm_cu_type -- CDM逻辑单元类型
            ,cdm_cu_status -- CDM逻辑单元状态
            ,dep_deposit_status -- OK NOTPRESENT DEPOSITJAMMED SHUTTERJAMMED
            ,dep_deposit_container_status -- OK HIGH FULL NOTPRESENT
            ,dep_envelope_supply_status -- OK LOW EMPTY
            ,dep_envelope_status -- READY NOTREADY
            ,dep_printer_status -- READY NOTREADY
            ,dep_printer_ink -- OK LOW EMPTY
            ,dep_deposited_items -- 已存信封数量
            ,dep_transport_status -- 传送部件状态
            ,dep_shutter_status -- 挡板状态
            ,ups_low -- TRUE FALSE
            ,ups_engaged -- TRUE FALSE
            ,ups_powering -- TRUE FALSE
            ,ups_recovered -- TRUE FALSE
            ,spr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
            ,spr_paper_status -- FULL LOW OUT UNKNOWN
            ,spr_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
            ,spr_ink_status -- 墨水状态
            ,spr_toner_status -- 色带状态
            ,spr_stack_count -- 暂存数量
            ,chk_media_status -- NOPRESENT PRESENT INJAMS JAMMED
            ,chk_ink_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
            ,rpr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
            ,rpr_paper_status -- FULL LOW OUT UNKNOWN
            ,rpr_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
            ,rpr_ink_status -- RPR墨水状态
            ,rpr_toner_status -- RPR色带状态
            ,jpr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
            ,jpr_paper_status -- FULL LOW OUT UNKNOWN
            ,jpr_ink_status -- JPR墨水状态
            ,jpr_toner_status -- JPR色带状态
            ,pbk_media_status -- NOPRESENT PRESENT INJAMS JAMMED
            ,pbk_ink_status -- FULL LOW OUT UNKNOWN
            ,pbk_toner_status -- FULL LOW OUT UNKNOWN
            ,pbk_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
            ,pbk_retract_bin_count -- PBK回收单元数量
            ,siu_operator_switch -- NOSENSOR ERROR RUN MAINTENANCE SUPERVISOR
            ,siu_terminal_tamper -- NOSENSOR ERROR ON OFF
            ,siu_alarm_tamper -- NOSENSOR ERROR ON OFF
            ,siu_seismic -- NOSENSOR ERROR ON OFF
            ,siu_proximity_detector -- NOSENSOR ERROR ON OFF
            ,siu_heat -- NOSENSOR ERROR ON OFF
            ,siu_ambient_light -- NOSENSOR ERROR VERYLIGHT LIGHT MEDIUMLIGHT DARK VERYDARK
            ,siu_cabinet_state -- 机箱状态
            ,siu_safe_state -- SIU安全门状态
            ,siu_shield_state -- SIU档板状态
            ,siu_bill_acceptor_light -- HEALTHY FATAL NODEVICE
            ,siu_card_reader_light -- HEALTHY FATAL NODEVICE
            ,siu_cheque_unit_light -- HEALTHY FATAL NODEVICE
            ,siu_coin_dispenser_light -- HEALTHY FATAL NODEVICE
            ,siu_note_dispenser_light -- HEALTHY FATAL NODEVICE
            ,siu_envelope_depository_light -- HEALTHY FATAL NODEVICE
            ,siu_passbook_printer_light -- HEALTHY FATAL NODEVICE
            ,siu_pinpad_light -- HEALTHY FATAL NODEVICE
            ,siu_receipt_printer_light -- HEALTHY FATAL NODEVICE
            ,siu_envelope_dispenser_light -- HEALTHY FATAL NODEVICE
            ,cam_camera_area -- room,person,exit_slot
            ,cam_camera_area_status -- HEALTHY FATAL NODEVICE
            ,cam_media_status -- LOW HIGH FULL
            ,cam_picture_staken -- 已获取图像
            ,dev_cash_status -- 0：正常1：无法取款2：无法存款3：无法存取款
            ,action_type -- 运行状态
            ,action_note -- 运行子状态
            ,icc_device_status -- ICC_DEVICE_STATUS
            ,icc_media_status -- ICC_MEDIA_STATUS
            ,isc_device_status -- ISC_DEVICE_STATUS
            ,isc_media_status -- ISC_MEDIA_STATUS
            ,irc_device_status -- IRC_DEVICE_STATUS
            ,irc_media_status -- IRC_MEDIA_STATUS
            ,fpi_device_status -- FPI_DEVICE_STATUS
            ,crd_device_status -- CRD_DEVICE_STATUS
            ,ccd_device_status -- CCD_DEVICE_STATUS
            ,dpr_device_status -- 盖章模块状态
            ,bcr_device_status -- 二维码扫描仪模块状态
            ,cam_status_area -- 
            ,cam_status_media -- 
            ,cam_status_state -- 
            ,cam_status_pictures -- 
            ,dev_crs_status -- 0：正常1：无法取款2：无法存款3：无法存取款
            ,pjc_ret_code -- PJC故障码
            ,pjc_cru_status -- PJC模块主状态，Healthy-正常（进程存在），Fatal-失败
            ,pjc_ej_sendtime -- PJC流水上传时间
            ,pjc_ej_date -- PJC上传流水日期
            ,pjc_ej_nsend -- 剩余未发送缓存流水情况，Without-未采集到流水，Ok-未发送流水数据为0，High-未发送流水数据未达到阀值，Full-未发送流水数据大于等于阀值
            ,cdm_cu_number -- 取款箱逻辑钞箱索引号
            ,cim_cu_number -- 存款箱逻辑钞箱索引号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
            dev_no -- 设备号
            ,dev_status -- HEALTHY(正常) FATAL（故障）WARNING（警告）UNKNOWN（未知）
            ,dev_tx_status -- HEALTHY（正常）PARTSERVICE（部分服务）NOSERVICE（停止服务）UNKNOWN（未知）
            ,dev_net_status -- HEALTHY（正常）FATAL（故障，即离线）WARNING（警告）UNKNOW（未知）
            ,dev_run_status -- HEALTHY(正常) CLOSE（关机）MAINTAIN（维护）NETFATAL（P通讯故障）PARTSERVICE（部分服务）NOSERVICE（停止服务）STOP（停用）UNKNOWN（未知）
            ,dev_cashbox_status -- OK（充足）LOW（不足）EMPTY（缺炒）FULL（钞满）UNKNOWN（未知）
            ,dev_mod_status -- HEALTHY(正常) FATAL（故障） WARNING（警告） UNKNOWN（未知）
            ,dev_potential_fault -- 设备是否存在潜在故障（未使用）
            ,status_last_time -- 上次更新时间（yyyymmddhhmmss）
            ,status_expire_time -- 状态超时时间（yyyymmddhhmmss）
            ,tx_type -- CWD-取款 DET-存款
            ,tx_time -- 交易时间（yyyymmddhhmmss）
            ,atm_type -- 1 --自动取款机(ATM) 2--自动存款机(CDM) 3--自动存取款机(CRS) 4--多媒体查询机(BSM)
            ,cash_unit_type -- P--Physical,L--Logical
            ,status_info_type -- 1--定时状态报文 2--强制发送状态报文
            ,combin_unit_type -- 0--按默认方式合并 1--按PUPosName合并 2--按DevCdmCUID合并 3--按PUPosName和DevCdmCUID合并
            ,idc_device_status -- HEALTHY FATAL WARNING NODEVICE UNKNOWN
            ,cim_device_status -- CIM模块状态
            ,cdm_device_status -- CMD模块状态
            ,dep_device_status -- DEP模块状态
            ,ups_device_status -- UPS模块状态
            ,spr_device_status -- SPR模块状态
            ,rpr_device_status -- RPR模块状态
            ,jpr_device_status -- JPR模块状态
            ,chk_device_status -- CHK模块状态
            ,ttu_device_status -- TTU模块状态
            ,pbk_device_status -- PBK模块状态
            ,pin_device_status -- PIN模块状态
            ,siu_device_status -- SIU模块状态
            ,cam_device_status -- CAM模块状态
            ,idc_media_status -- PRESENT NOTPRESENT INJAWS JAMMED
            ,idc_capture_bin_status -- NOBIN BINOK BINHIGH BINFULL
            ,idc_capture_bin_count -- 回收箱数量
            ,cim_accept_or_status -- HEALTHY FATAL UNKNOWN
            ,cim_escrow_status -- EMPTY NOEMPTY FULL NOESCROW UNKNOWN
            ,cim_cash_units -- OK, Warning, Fatal, Unknown
            ,cim_shutter_status -- Closed, Open, Jammed, Unknown, NotSupported
            ,cim_transport_status -- OK, Inoperable, Unknown, NotSupported
            ,cim_inout_position -- InLeft,InRight,InCenter,InTop,InBottom,InFront,InRear,OutLeft,OutRight, OutCenter, OutTop, OutBottom, OutFront, OutRear
            ,cim_input_output_status -- EMPTY NOEMPTY UNKNOWN
            ,cim_pu_id -- 物理单元标识（数组）
            ,cim_pu_count -- 当前物理单元纸币数（数组）
            ,cim_pu_cash_in_count -- 物理单元废钞数（数组）
            ,cim_pu_status -- 逻辑单元状态
            ,cim_pupos_name -- CIM物理钞箱物理位置名集合
            ,cim_cu_id -- 逻辑单元标识（数组）
            ,cim_pcu_id -- 物理单元与逻辑单元对应关系（数组）
            ,cim_cu_note_value -- 逻辑单元纸币面值（数组）
            ,cim_cu_currency -- 逻辑单元币种（数组）
            ,cim_cu_count -- 当前逻辑单元纸币数（数组）
            ,cim_cu_cash_in_count -- 逻辑单元废钞数（数组）
            ,cim_cu_type -- 逻辑单元类型
            ,cim_cu_status -- CIM逻辑单元状态
            ,cdm_shutter_status -- Closed, Open, Jammed, Unknown, NotSupported
            ,cdm_dispenser_status -- 退钞状态
            ,cdm_safe_door_status -- OPEN FATAL CLOSED LOCKED NOTSUPPORTED
            ,cdm_stacker_status -- CDM暂存器状态
            ,cdm_cash_units -- OK, Warning, Fatal, Unknown
            ,cdm_transport_status -- OK, Inoperable, Unknown, NotSupported
            ,cdm_out_position -- Left,Right,Center,Top,Bottom,Front,Rear
            ,cdm_input_output_status -- EMPTY NOTEMPTY UNKNOWN NOTSUPPORTED
            ,cdm_pu_status -- 物理单元状态(数组)
            ,cdm_pu_id -- CDM物理单元标识（数组）
            ,cdm_pu_initial_count -- CDM当前物理单元纸币数（数组）
            ,cdm_pu_current_count -- 当前物理单元初始币数
            ,cdm_pu_reject_count -- CDM物理单元废钞数（数组）
            ,cdm_pupos_name -- CDM物理钞箱物理位置名集合
            ,cdm_cu_id -- CDM逻辑单元标识（数组）
            ,cdm_pcu_id -- CDM物理单元与逻辑单元对应关系（数组）
            ,cdm_cu_note_value -- CDM逻辑单元纸币面值（数组）
            ,cdm_cu_currency -- CDM逻辑单元币种（数组）
            ,cdm_cu_current_count -- CDM当前逻辑单元纸币数（数组）
            ,cdm_cu_initial_count -- 当前逻辑单元初始币数
            ,cdm_cu_reject_count -- CDM逻辑单元废钞数（数组）
            ,cdm_cu_type -- CDM逻辑单元类型
            ,cdm_cu_status -- CDM逻辑单元状态
            ,dep_deposit_status -- OK NOTPRESENT DEPOSITJAMMED SHUTTERJAMMED
            ,dep_deposit_container_status -- OK HIGH FULL NOTPRESENT
            ,dep_envelope_supply_status -- OK LOW EMPTY
            ,dep_envelope_status -- READY NOTREADY
            ,dep_printer_status -- READY NOTREADY
            ,dep_printer_ink -- OK LOW EMPTY
            ,dep_deposited_items -- 已存信封数量
            ,dep_transport_status -- 传送部件状态
            ,dep_shutter_status -- 挡板状态
            ,ups_low -- TRUE FALSE
            ,ups_engaged -- TRUE FALSE
            ,ups_powering -- TRUE FALSE
            ,ups_recovered -- TRUE FALSE
            ,spr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
            ,spr_paper_status -- FULL LOW OUT UNKNOWN
            ,spr_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
            ,spr_ink_status -- 墨水状态
            ,spr_toner_status -- 色带状态
            ,spr_stack_count -- 暂存数量
            ,chk_media_status -- NOPRESENT PRESENT INJAMS JAMMED
            ,chk_ink_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
            ,rpr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
            ,rpr_paper_status -- FULL LOW OUT UNKNOWN
            ,rpr_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
            ,rpr_ink_status -- RPR墨水状态
            ,rpr_toner_status -- RPR色带状态
            ,jpr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
            ,jpr_paper_status -- FULL LOW OUT UNKNOWN
            ,jpr_ink_status -- JPR墨水状态
            ,jpr_toner_status -- JPR色带状态
            ,pbk_media_status -- NOPRESENT PRESENT INJAMS JAMMED
            ,pbk_ink_status -- FULL LOW OUT UNKNOWN
            ,pbk_toner_status -- FULL LOW OUT UNKNOWN
            ,pbk_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
            ,pbk_retract_bin_count -- PBK回收单元数量
            ,siu_operator_switch -- NOSENSOR ERROR RUN MAINTENANCE SUPERVISOR
            ,siu_terminal_tamper -- NOSENSOR ERROR ON OFF
            ,siu_alarm_tamper -- NOSENSOR ERROR ON OFF
            ,siu_seismic -- NOSENSOR ERROR ON OFF
            ,siu_proximity_detector -- NOSENSOR ERROR ON OFF
            ,siu_heat -- NOSENSOR ERROR ON OFF
            ,siu_ambient_light -- NOSENSOR ERROR VERYLIGHT LIGHT MEDIUMLIGHT DARK VERYDARK
            ,siu_cabinet_state -- 机箱状态
            ,siu_safe_state -- SIU安全门状态
            ,siu_shield_state -- SIU档板状态
            ,siu_bill_acceptor_light -- HEALTHY FATAL NODEVICE
            ,siu_card_reader_light -- HEALTHY FATAL NODEVICE
            ,siu_cheque_unit_light -- HEALTHY FATAL NODEVICE
            ,siu_coin_dispenser_light -- HEALTHY FATAL NODEVICE
            ,siu_note_dispenser_light -- HEALTHY FATAL NODEVICE
            ,siu_envelope_depository_light -- HEALTHY FATAL NODEVICE
            ,siu_passbook_printer_light -- HEALTHY FATAL NODEVICE
            ,siu_pinpad_light -- HEALTHY FATAL NODEVICE
            ,siu_receipt_printer_light -- HEALTHY FATAL NODEVICE
            ,siu_envelope_dispenser_light -- HEALTHY FATAL NODEVICE
            ,cam_camera_area -- room,person,exit_slot
            ,cam_camera_area_status -- HEALTHY FATAL NODEVICE
            ,cam_media_status -- LOW HIGH FULL
            ,cam_picture_staken -- 已获取图像
            ,dev_cash_status -- 0：正常1：无法取款2：无法存款3：无法存取款
            ,action_type -- 运行状态
            ,action_note -- 运行子状态
            ,icc_device_status -- ICC_DEVICE_STATUS
            ,icc_media_status -- ICC_MEDIA_STATUS
            ,isc_device_status -- ISC_DEVICE_STATUS
            ,isc_media_status -- ISC_MEDIA_STATUS
            ,irc_device_status -- IRC_DEVICE_STATUS
            ,irc_media_status -- IRC_MEDIA_STATUS
            ,fpi_device_status -- FPI_DEVICE_STATUS
            ,crd_device_status -- CRD_DEVICE_STATUS
            ,ccd_device_status -- CCD_DEVICE_STATUS
            ,dpr_device_status -- 盖章模块状态
            ,bcr_device_status -- 二维码扫描仪模块状态
            ,cam_status_area -- 
            ,cam_status_media -- 
            ,cam_status_state -- 
            ,cam_status_pictures -- 
            ,' ' as dev_crs_status -- 0：正常1：无法取款2：无法存款3：无法存取款
            ,' ' as pjc_ret_code -- PJC故障码
            ,' ' as pjc_cru_status -- PJC模块主状态，Healthy-正常（进程存在），Fatal-失败
            ,' ' as pjc_ej_sendtime -- PJC流水上传时间
            ,' ' as pjc_ej_date -- PJC上传流水日期
            ,' ' as pjc_ej_nsend -- 剩余未发送缓存流水情况，Without-未采集到流水，Ok-未发送流水数据为0，High-未发送流水数据未达到阀值，Full-未发送流水数据大于等于阀值
            ,' ' as cdm_cu_number -- 取款箱逻辑钞箱索引号
            ,' ' as cim_cu_number -- 存款箱逻辑钞箱索引号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
from ${iol_schema}.atms_dev_status_table_bak${batch_date}
where end_dt = to_date(tb.end_dt,'yyyymmdd');
commit;

end loop;
end;
/
