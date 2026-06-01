/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_dev_status_table
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.atms_dev_status_table_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.atms_dev_status_table
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_status_table_op purge;
drop table ${iol_schema}.atms_dev_status_table_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_status_table_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_status_table where 0=1;

create table ${iol_schema}.atms_dev_status_table_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_status_table where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_status_table_cl(
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
    else
        into ${iol_schema}.atms_dev_status_table_op(
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
    nvl(n.dev_no, o.dev_no) as dev_no -- 设备号
    ,nvl(n.dev_status, o.dev_status) as dev_status -- HEALTHY(正常) FATAL（故障）WARNING（警告）UNKNOWN（未知）
    ,nvl(n.dev_tx_status, o.dev_tx_status) as dev_tx_status -- HEALTHY（正常）PARTSERVICE（部分服务）NOSERVICE（停止服务）UNKNOWN（未知）
    ,nvl(n.dev_net_status, o.dev_net_status) as dev_net_status -- HEALTHY（正常）FATAL（故障，即离线）WARNING（警告）UNKNOW（未知）
    ,nvl(n.dev_run_status, o.dev_run_status) as dev_run_status -- HEALTHY(正常) CLOSE（关机）MAINTAIN（维护）NETFATAL（P通讯故障）PARTSERVICE（部分服务）NOSERVICE（停止服务）STOP（停用）UNKNOWN（未知）
    ,nvl(n.dev_cashbox_status, o.dev_cashbox_status) as dev_cashbox_status -- OK（充足）LOW（不足）EMPTY（缺炒）FULL（钞满）UNKNOWN（未知）
    ,nvl(n.dev_mod_status, o.dev_mod_status) as dev_mod_status -- HEALTHY(正常) FATAL（故障） WARNING（警告） UNKNOWN（未知）
    ,nvl(n.dev_potential_fault, o.dev_potential_fault) as dev_potential_fault -- 设备是否存在潜在故障（未使用）
    ,nvl(n.status_last_time, o.status_last_time) as status_last_time -- 上次更新时间（yyyymmddhhmmss）
    ,nvl(n.status_expire_time, o.status_expire_time) as status_expire_time -- 状态超时时间（yyyymmddhhmmss）
    ,nvl(n.tx_type, o.tx_type) as tx_type -- CWD-取款 DET-存款
    ,nvl(n.tx_time, o.tx_time) as tx_time -- 交易时间（yyyymmddhhmmss）
    ,nvl(n.atm_type, o.atm_type) as atm_type -- 1 --自动取款机(ATM) 2--自动存款机(CDM) 3--自动存取款机(CRS) 4--多媒体查询机(BSM)
    ,nvl(n.cash_unit_type, o.cash_unit_type) as cash_unit_type -- P--Physical,L--Logical
    ,nvl(n.status_info_type, o.status_info_type) as status_info_type -- 1--定时状态报文 2--强制发送状态报文
    ,nvl(n.combin_unit_type, o.combin_unit_type) as combin_unit_type -- 0--按默认方式合并 1--按PUPosName合并 2--按DevCdmCUID合并 3--按PUPosName和DevCdmCUID合并
    ,nvl(n.idc_device_status, o.idc_device_status) as idc_device_status -- HEALTHY FATAL WARNING NODEVICE UNKNOWN
    ,nvl(n.cim_device_status, o.cim_device_status) as cim_device_status -- CIM模块状态
    ,nvl(n.cdm_device_status, o.cdm_device_status) as cdm_device_status -- CMD模块状态
    ,nvl(n.dep_device_status, o.dep_device_status) as dep_device_status -- DEP模块状态
    ,nvl(n.ups_device_status, o.ups_device_status) as ups_device_status -- UPS模块状态
    ,nvl(n.spr_device_status, o.spr_device_status) as spr_device_status -- SPR模块状态
    ,nvl(n.rpr_device_status, o.rpr_device_status) as rpr_device_status -- RPR模块状态
    ,nvl(n.jpr_device_status, o.jpr_device_status) as jpr_device_status -- JPR模块状态
    ,nvl(n.chk_device_status, o.chk_device_status) as chk_device_status -- CHK模块状态
    ,nvl(n.ttu_device_status, o.ttu_device_status) as ttu_device_status -- TTU模块状态
    ,nvl(n.pbk_device_status, o.pbk_device_status) as pbk_device_status -- PBK模块状态
    ,nvl(n.pin_device_status, o.pin_device_status) as pin_device_status -- PIN模块状态
    ,nvl(n.siu_device_status, o.siu_device_status) as siu_device_status -- SIU模块状态
    ,nvl(n.cam_device_status, o.cam_device_status) as cam_device_status -- CAM模块状态
    ,nvl(n.idc_media_status, o.idc_media_status) as idc_media_status -- PRESENT NOTPRESENT INJAWS JAMMED
    ,nvl(n.idc_capture_bin_status, o.idc_capture_bin_status) as idc_capture_bin_status -- NOBIN BINOK BINHIGH BINFULL
    ,nvl(n.idc_capture_bin_count, o.idc_capture_bin_count) as idc_capture_bin_count -- 回收箱数量
    ,nvl(n.cim_accept_or_status, o.cim_accept_or_status) as cim_accept_or_status -- HEALTHY FATAL UNKNOWN
    ,nvl(n.cim_escrow_status, o.cim_escrow_status) as cim_escrow_status -- EMPTY NOEMPTY FULL NOESCROW UNKNOWN
    ,nvl(n.cim_cash_units, o.cim_cash_units) as cim_cash_units -- OK, Warning, Fatal, Unknown
    ,nvl(n.cim_shutter_status, o.cim_shutter_status) as cim_shutter_status -- Closed, Open, Jammed, Unknown, NotSupported
    ,nvl(n.cim_transport_status, o.cim_transport_status) as cim_transport_status -- OK, Inoperable, Unknown, NotSupported
    ,nvl(n.cim_inout_position, o.cim_inout_position) as cim_inout_position -- InLeft,InRight,InCenter,InTop,InBottom,InFront,InRear,OutLeft,OutRight, OutCenter, OutTop, OutBottom, OutFront, OutRear
    ,nvl(n.cim_input_output_status, o.cim_input_output_status) as cim_input_output_status -- EMPTY NOEMPTY UNKNOWN
    ,nvl(n.cim_pu_id, o.cim_pu_id) as cim_pu_id -- 物理单元标识（数组）
    ,nvl(n.cim_pu_count, o.cim_pu_count) as cim_pu_count -- 当前物理单元纸币数（数组）
    ,nvl(n.cim_pu_cash_in_count, o.cim_pu_cash_in_count) as cim_pu_cash_in_count -- 物理单元废钞数（数组）
    ,nvl(n.cim_pu_status, o.cim_pu_status) as cim_pu_status -- 逻辑单元状态
    ,nvl(n.cim_pupos_name, o.cim_pupos_name) as cim_pupos_name -- CIM物理钞箱物理位置名集合
    ,nvl(n.cim_cu_id, o.cim_cu_id) as cim_cu_id -- 逻辑单元标识（数组）
    ,nvl(n.cim_pcu_id, o.cim_pcu_id) as cim_pcu_id -- 物理单元与逻辑单元对应关系（数组）
    ,nvl(n.cim_cu_note_value, o.cim_cu_note_value) as cim_cu_note_value -- 逻辑单元纸币面值（数组）
    ,nvl(n.cim_cu_currency, o.cim_cu_currency) as cim_cu_currency -- 逻辑单元币种（数组）
    ,nvl(n.cim_cu_count, o.cim_cu_count) as cim_cu_count -- 当前逻辑单元纸币数（数组）
    ,nvl(n.cim_cu_cash_in_count, o.cim_cu_cash_in_count) as cim_cu_cash_in_count -- 逻辑单元废钞数（数组）
    ,nvl(n.cim_cu_type, o.cim_cu_type) as cim_cu_type -- 逻辑单元类型
    ,nvl(n.cim_cu_status, o.cim_cu_status) as cim_cu_status -- CIM逻辑单元状态
    ,nvl(n.cdm_shutter_status, o.cdm_shutter_status) as cdm_shutter_status -- Closed, Open, Jammed, Unknown, NotSupported
    ,nvl(n.cdm_dispenser_status, o.cdm_dispenser_status) as cdm_dispenser_status -- 退钞状态
    ,nvl(n.cdm_safe_door_status, o.cdm_safe_door_status) as cdm_safe_door_status -- OPEN FATAL CLOSED LOCKED NOTSUPPORTED
    ,nvl(n.cdm_stacker_status, o.cdm_stacker_status) as cdm_stacker_status -- CDM暂存器状态
    ,nvl(n.cdm_cash_units, o.cdm_cash_units) as cdm_cash_units -- OK, Warning, Fatal, Unknown
    ,nvl(n.cdm_transport_status, o.cdm_transport_status) as cdm_transport_status -- OK, Inoperable, Unknown, NotSupported
    ,nvl(n.cdm_out_position, o.cdm_out_position) as cdm_out_position -- Left,Right,Center,Top,Bottom,Front,Rear
    ,nvl(n.cdm_input_output_status, o.cdm_input_output_status) as cdm_input_output_status -- EMPTY NOTEMPTY UNKNOWN NOTSUPPORTED
    ,nvl(n.cdm_pu_status, o.cdm_pu_status) as cdm_pu_status -- 物理单元状态(数组)
    ,nvl(n.cdm_pu_id, o.cdm_pu_id) as cdm_pu_id -- CDM物理单元标识（数组）
    ,nvl(n.cdm_pu_initial_count, o.cdm_pu_initial_count) as cdm_pu_initial_count -- CDM当前物理单元纸币数（数组）
    ,nvl(n.cdm_pu_current_count, o.cdm_pu_current_count) as cdm_pu_current_count -- 当前物理单元初始币数
    ,nvl(n.cdm_pu_reject_count, o.cdm_pu_reject_count) as cdm_pu_reject_count -- CDM物理单元废钞数（数组）
    ,nvl(n.cdm_pupos_name, o.cdm_pupos_name) as cdm_pupos_name -- CDM物理钞箱物理位置名集合
    ,nvl(n.cdm_cu_id, o.cdm_cu_id) as cdm_cu_id -- CDM逻辑单元标识（数组）
    ,nvl(n.cdm_pcu_id, o.cdm_pcu_id) as cdm_pcu_id -- CDM物理单元与逻辑单元对应关系（数组）
    ,nvl(n.cdm_cu_note_value, o.cdm_cu_note_value) as cdm_cu_note_value -- CDM逻辑单元纸币面值（数组）
    ,nvl(n.cdm_cu_currency, o.cdm_cu_currency) as cdm_cu_currency -- CDM逻辑单元币种（数组）
    ,nvl(n.cdm_cu_current_count, o.cdm_cu_current_count) as cdm_cu_current_count -- CDM当前逻辑单元纸币数（数组）
    ,nvl(n.cdm_cu_initial_count, o.cdm_cu_initial_count) as cdm_cu_initial_count -- 当前逻辑单元初始币数
    ,nvl(n.cdm_cu_reject_count, o.cdm_cu_reject_count) as cdm_cu_reject_count -- CDM逻辑单元废钞数（数组）
    ,nvl(n.cdm_cu_type, o.cdm_cu_type) as cdm_cu_type -- CDM逻辑单元类型
    ,nvl(n.cdm_cu_status, o.cdm_cu_status) as cdm_cu_status -- CDM逻辑单元状态
    ,nvl(n.dep_deposit_status, o.dep_deposit_status) as dep_deposit_status -- OK NOTPRESENT DEPOSITJAMMED SHUTTERJAMMED
    ,nvl(n.dep_deposit_container_status, o.dep_deposit_container_status) as dep_deposit_container_status -- OK HIGH FULL NOTPRESENT
    ,nvl(n.dep_envelope_supply_status, o.dep_envelope_supply_status) as dep_envelope_supply_status -- OK LOW EMPTY
    ,nvl(n.dep_envelope_status, o.dep_envelope_status) as dep_envelope_status -- READY NOTREADY
    ,nvl(n.dep_printer_status, o.dep_printer_status) as dep_printer_status -- READY NOTREADY
    ,nvl(n.dep_printer_ink, o.dep_printer_ink) as dep_printer_ink -- OK LOW EMPTY
    ,nvl(n.dep_deposited_items, o.dep_deposited_items) as dep_deposited_items -- 已存信封数量
    ,nvl(n.dep_transport_status, o.dep_transport_status) as dep_transport_status -- 传送部件状态
    ,nvl(n.dep_shutter_status, o.dep_shutter_status) as dep_shutter_status -- 挡板状态
    ,nvl(n.ups_low, o.ups_low) as ups_low -- TRUE FALSE
    ,nvl(n.ups_engaged, o.ups_engaged) as ups_engaged -- TRUE FALSE
    ,nvl(n.ups_powering, o.ups_powering) as ups_powering -- TRUE FALSE
    ,nvl(n.ups_recovered, o.ups_recovered) as ups_recovered -- TRUE FALSE
    ,nvl(n.spr_media_status, o.spr_media_status) as spr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
    ,nvl(n.spr_paper_status, o.spr_paper_status) as spr_paper_status -- FULL LOW OUT UNKNOWN
    ,nvl(n.spr_retract_bin_status, o.spr_retract_bin_status) as spr_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
    ,nvl(n.spr_ink_status, o.spr_ink_status) as spr_ink_status -- 墨水状态
    ,nvl(n.spr_toner_status, o.spr_toner_status) as spr_toner_status -- 色带状态
    ,nvl(n.spr_stack_count, o.spr_stack_count) as spr_stack_count -- 暂存数量
    ,nvl(n.chk_media_status, o.chk_media_status) as chk_media_status -- NOPRESENT PRESENT INJAMS JAMMED
    ,nvl(n.chk_ink_status, o.chk_ink_status) as chk_ink_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
    ,nvl(n.rpr_media_status, o.rpr_media_status) as rpr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
    ,nvl(n.rpr_paper_status, o.rpr_paper_status) as rpr_paper_status -- FULL LOW OUT UNKNOWN
    ,nvl(n.rpr_retract_bin_status, o.rpr_retract_bin_status) as rpr_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
    ,nvl(n.rpr_ink_status, o.rpr_ink_status) as rpr_ink_status -- RPR墨水状态
    ,nvl(n.rpr_toner_status, o.rpr_toner_status) as rpr_toner_status -- RPR色带状态
    ,nvl(n.jpr_media_status, o.jpr_media_status) as jpr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
    ,nvl(n.jpr_paper_status, o.jpr_paper_status) as jpr_paper_status -- FULL LOW OUT UNKNOWN
    ,nvl(n.jpr_ink_status, o.jpr_ink_status) as jpr_ink_status -- JPR墨水状态
    ,nvl(n.jpr_toner_status, o.jpr_toner_status) as jpr_toner_status -- JPR色带状态
    ,nvl(n.pbk_media_status, o.pbk_media_status) as pbk_media_status -- NOPRESENT PRESENT INJAMS JAMMED
    ,nvl(n.pbk_ink_status, o.pbk_ink_status) as pbk_ink_status -- FULL LOW OUT UNKNOWN
    ,nvl(n.pbk_toner_status, o.pbk_toner_status) as pbk_toner_status -- FULL LOW OUT UNKNOWN
    ,nvl(n.pbk_retract_bin_status, o.pbk_retract_bin_status) as pbk_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
    ,nvl(n.pbk_retract_bin_count, o.pbk_retract_bin_count) as pbk_retract_bin_count -- PBK回收单元数量
    ,nvl(n.siu_operator_switch, o.siu_operator_switch) as siu_operator_switch -- NOSENSOR ERROR RUN MAINTENANCE SUPERVISOR
    ,nvl(n.siu_terminal_tamper, o.siu_terminal_tamper) as siu_terminal_tamper -- NOSENSOR ERROR ON OFF
    ,nvl(n.siu_alarm_tamper, o.siu_alarm_tamper) as siu_alarm_tamper -- NOSENSOR ERROR ON OFF
    ,nvl(n.siu_seismic, o.siu_seismic) as siu_seismic -- NOSENSOR ERROR ON OFF
    ,nvl(n.siu_proximity_detector, o.siu_proximity_detector) as siu_proximity_detector -- NOSENSOR ERROR ON OFF
    ,nvl(n.siu_heat, o.siu_heat) as siu_heat -- NOSENSOR ERROR ON OFF
    ,nvl(n.siu_ambient_light, o.siu_ambient_light) as siu_ambient_light -- NOSENSOR ERROR VERYLIGHT LIGHT MEDIUMLIGHT DARK VERYDARK
    ,nvl(n.siu_cabinet_state, o.siu_cabinet_state) as siu_cabinet_state -- 机箱状态
    ,nvl(n.siu_safe_state, o.siu_safe_state) as siu_safe_state -- SIU安全门状态
    ,nvl(n.siu_shield_state, o.siu_shield_state) as siu_shield_state -- SIU档板状态
    ,nvl(n.siu_bill_acceptor_light, o.siu_bill_acceptor_light) as siu_bill_acceptor_light -- HEALTHY FATAL NODEVICE
    ,nvl(n.siu_card_reader_light, o.siu_card_reader_light) as siu_card_reader_light -- HEALTHY FATAL NODEVICE
    ,nvl(n.siu_cheque_unit_light, o.siu_cheque_unit_light) as siu_cheque_unit_light -- HEALTHY FATAL NODEVICE
    ,nvl(n.siu_coin_dispenser_light, o.siu_coin_dispenser_light) as siu_coin_dispenser_light -- HEALTHY FATAL NODEVICE
    ,nvl(n.siu_note_dispenser_light, o.siu_note_dispenser_light) as siu_note_dispenser_light -- HEALTHY FATAL NODEVICE
    ,nvl(n.siu_envelope_depository_light, o.siu_envelope_depository_light) as siu_envelope_depository_light -- HEALTHY FATAL NODEVICE
    ,nvl(n.siu_passbook_printer_light, o.siu_passbook_printer_light) as siu_passbook_printer_light -- HEALTHY FATAL NODEVICE
    ,nvl(n.siu_pinpad_light, o.siu_pinpad_light) as siu_pinpad_light -- HEALTHY FATAL NODEVICE
    ,nvl(n.siu_receipt_printer_light, o.siu_receipt_printer_light) as siu_receipt_printer_light -- HEALTHY FATAL NODEVICE
    ,nvl(n.siu_envelope_dispenser_light, o.siu_envelope_dispenser_light) as siu_envelope_dispenser_light -- HEALTHY FATAL NODEVICE
    ,nvl(n.cam_camera_area, o.cam_camera_area) as cam_camera_area -- room,person,exit_slot
    ,nvl(n.cam_camera_area_status, o.cam_camera_area_status) as cam_camera_area_status -- HEALTHY FATAL NODEVICE
    ,nvl(n.cam_media_status, o.cam_media_status) as cam_media_status -- LOW HIGH FULL
    ,nvl(n.cam_picture_staken, o.cam_picture_staken) as cam_picture_staken -- 已获取图像
    ,nvl(n.dev_cash_status, o.dev_cash_status) as dev_cash_status -- 0：正常1：无法取款2：无法存款3：无法存取款
    ,nvl(n.action_type, o.action_type) as action_type -- 运行状态
    ,nvl(n.action_note, o.action_note) as action_note -- 运行子状态
    ,nvl(n.icc_device_status, o.icc_device_status) as icc_device_status -- ICC_DEVICE_STATUS
    ,nvl(n.icc_media_status, o.icc_media_status) as icc_media_status -- ICC_MEDIA_STATUS
    ,nvl(n.isc_device_status, o.isc_device_status) as isc_device_status -- ISC_DEVICE_STATUS
    ,nvl(n.isc_media_status, o.isc_media_status) as isc_media_status -- ISC_MEDIA_STATUS
    ,nvl(n.irc_device_status, o.irc_device_status) as irc_device_status -- IRC_DEVICE_STATUS
    ,nvl(n.irc_media_status, o.irc_media_status) as irc_media_status -- IRC_MEDIA_STATUS
    ,nvl(n.fpi_device_status, o.fpi_device_status) as fpi_device_status -- FPI_DEVICE_STATUS
    ,nvl(n.crd_device_status, o.crd_device_status) as crd_device_status -- CRD_DEVICE_STATUS
    ,nvl(n.ccd_device_status, o.ccd_device_status) as ccd_device_status -- CCD_DEVICE_STATUS
    ,nvl(n.dpr_device_status, o.dpr_device_status) as dpr_device_status -- 盖章模块状态
    ,nvl(n.bcr_device_status, o.bcr_device_status) as bcr_device_status -- 二维码扫描仪模块状态
    ,nvl(n.cam_status_area, o.cam_status_area) as cam_status_area -- 
    ,nvl(n.cam_status_media, o.cam_status_media) as cam_status_media -- 
    ,nvl(n.cam_status_state, o.cam_status_state) as cam_status_state -- 
    ,nvl(n.cam_status_pictures, o.cam_status_pictures) as cam_status_pictures -- 
    ,nvl(n.dev_crs_status, o.dev_crs_status) as dev_crs_status -- 0：正常1：无法取款2：无法存款3：无法存取款
    ,nvl(n.pjc_ret_code, o.pjc_ret_code) as pjc_ret_code -- PJC故障码
    ,nvl(n.pjc_cru_status, o.pjc_cru_status) as pjc_cru_status -- PJC模块主状态，Healthy-正常（进程存在），Fatal-失败
    ,nvl(n.pjc_ej_sendtime, o.pjc_ej_sendtime) as pjc_ej_sendtime -- PJC流水上传时间
    ,nvl(n.pjc_ej_date, o.pjc_ej_date) as pjc_ej_date -- PJC上传流水日期
    ,nvl(n.pjc_ej_nsend, o.pjc_ej_nsend) as pjc_ej_nsend -- 剩余未发送缓存流水情况，Without-未采集到流水，Ok-未发送流水数据为0，High-未发送流水数据未达到阀值，Full-未发送流水数据大于等于阀值
    ,nvl(n.cdm_cu_number, o.cdm_cu_number) as cdm_cu_number -- 取款箱逻辑钞箱索引号
    ,nvl(n.cim_cu_number, o.cim_cu_number) as cim_cu_number -- 存款箱逻辑钞箱索引号
    ,case when
            n.dev_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.dev_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.dev_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.atms_dev_status_table_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.atms_dev_status_table where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.dev_no = n.dev_no
where (
        o.dev_no is null
    )
    or (
        n.dev_no is null
    )
    or (
        o.dev_status <> n.dev_status
        or o.dev_tx_status <> n.dev_tx_status
        or o.dev_net_status <> n.dev_net_status
        or o.dev_run_status <> n.dev_run_status
        or o.dev_cashbox_status <> n.dev_cashbox_status
        or o.dev_mod_status <> n.dev_mod_status
        or o.dev_potential_fault <> n.dev_potential_fault
        or o.status_last_time <> n.status_last_time
        or o.status_expire_time <> n.status_expire_time
        or o.tx_type <> n.tx_type
        or o.tx_time <> n.tx_time
        or o.atm_type <> n.atm_type
        or o.cash_unit_type <> n.cash_unit_type
        or o.status_info_type <> n.status_info_type
        or o.combin_unit_type <> n.combin_unit_type
        or o.idc_device_status <> n.idc_device_status
        or o.cim_device_status <> n.cim_device_status
        or o.cdm_device_status <> n.cdm_device_status
        or o.dep_device_status <> n.dep_device_status
        or o.ups_device_status <> n.ups_device_status
        or o.spr_device_status <> n.spr_device_status
        or o.rpr_device_status <> n.rpr_device_status
        or o.jpr_device_status <> n.jpr_device_status
        or o.chk_device_status <> n.chk_device_status
        or o.ttu_device_status <> n.ttu_device_status
        or o.pbk_device_status <> n.pbk_device_status
        or o.pin_device_status <> n.pin_device_status
        or o.siu_device_status <> n.siu_device_status
        or o.cam_device_status <> n.cam_device_status
        or o.idc_media_status <> n.idc_media_status
        or o.idc_capture_bin_status <> n.idc_capture_bin_status
        or o.idc_capture_bin_count <> n.idc_capture_bin_count
        or o.cim_accept_or_status <> n.cim_accept_or_status
        or o.cim_escrow_status <> n.cim_escrow_status
        or o.cim_cash_units <> n.cim_cash_units
        or o.cim_shutter_status <> n.cim_shutter_status
        or o.cim_transport_status <> n.cim_transport_status
        or o.cim_inout_position <> n.cim_inout_position
        or o.cim_input_output_status <> n.cim_input_output_status
        or o.cim_pu_id <> n.cim_pu_id
        or o.cim_pu_count <> n.cim_pu_count
        or o.cim_pu_cash_in_count <> n.cim_pu_cash_in_count
        or o.cim_pu_status <> n.cim_pu_status
        or o.cim_pupos_name <> n.cim_pupos_name
        or o.cim_cu_id <> n.cim_cu_id
        or o.cim_pcu_id <> n.cim_pcu_id
        or o.cim_cu_note_value <> n.cim_cu_note_value
        or o.cim_cu_currency <> n.cim_cu_currency
        or o.cim_cu_count <> n.cim_cu_count
        or o.cim_cu_cash_in_count <> n.cim_cu_cash_in_count
        or o.cim_cu_type <> n.cim_cu_type
        or o.cim_cu_status <> n.cim_cu_status
        or o.cdm_shutter_status <> n.cdm_shutter_status
        or o.cdm_dispenser_status <> n.cdm_dispenser_status
        or o.cdm_safe_door_status <> n.cdm_safe_door_status
        or o.cdm_stacker_status <> n.cdm_stacker_status
        or o.cdm_cash_units <> n.cdm_cash_units
        or o.cdm_transport_status <> n.cdm_transport_status
        or o.cdm_out_position <> n.cdm_out_position
        or o.cdm_input_output_status <> n.cdm_input_output_status
        or o.cdm_pu_status <> n.cdm_pu_status
        or o.cdm_pu_id <> n.cdm_pu_id
        or o.cdm_pu_initial_count <> n.cdm_pu_initial_count
        or o.cdm_pu_current_count <> n.cdm_pu_current_count
        or o.cdm_pu_reject_count <> n.cdm_pu_reject_count
        or o.cdm_pupos_name <> n.cdm_pupos_name
        or o.cdm_cu_id <> n.cdm_cu_id
        or o.cdm_pcu_id <> n.cdm_pcu_id
        or o.cdm_cu_note_value <> n.cdm_cu_note_value
        or o.cdm_cu_currency <> n.cdm_cu_currency
        or o.cdm_cu_current_count <> n.cdm_cu_current_count
        or o.cdm_cu_initial_count <> n.cdm_cu_initial_count
        or o.cdm_cu_reject_count <> n.cdm_cu_reject_count
        or o.cdm_cu_type <> n.cdm_cu_type
        or o.cdm_cu_status <> n.cdm_cu_status
        or o.dep_deposit_status <> n.dep_deposit_status
        or o.dep_deposit_container_status <> n.dep_deposit_container_status
        or o.dep_envelope_supply_status <> n.dep_envelope_supply_status
        or o.dep_envelope_status <> n.dep_envelope_status
        or o.dep_printer_status <> n.dep_printer_status
        or o.dep_printer_ink <> n.dep_printer_ink
        or o.dep_deposited_items <> n.dep_deposited_items
        or o.dep_transport_status <> n.dep_transport_status
        or o.dep_shutter_status <> n.dep_shutter_status
        or o.ups_low <> n.ups_low
        or o.ups_engaged <> n.ups_engaged
        or o.ups_powering <> n.ups_powering
        or o.ups_recovered <> n.ups_recovered
        or o.spr_media_status <> n.spr_media_status
        or o.spr_paper_status <> n.spr_paper_status
        or o.spr_retract_bin_status <> n.spr_retract_bin_status
        or o.spr_ink_status <> n.spr_ink_status
        or o.spr_toner_status <> n.spr_toner_status
        or o.spr_stack_count <> n.spr_stack_count
        or o.chk_media_status <> n.chk_media_status
        or o.chk_ink_status <> n.chk_ink_status
        or o.rpr_media_status <> n.rpr_media_status
        or o.rpr_paper_status <> n.rpr_paper_status
        or o.rpr_retract_bin_status <> n.rpr_retract_bin_status
        or o.rpr_ink_status <> n.rpr_ink_status
        or o.rpr_toner_status <> n.rpr_toner_status
        or o.jpr_media_status <> n.jpr_media_status
        or o.jpr_paper_status <> n.jpr_paper_status
        or o.jpr_ink_status <> n.jpr_ink_status
        or o.jpr_toner_status <> n.jpr_toner_status
        or o.pbk_media_status <> n.pbk_media_status
        or o.pbk_ink_status <> n.pbk_ink_status
        or o.pbk_toner_status <> n.pbk_toner_status
        or o.pbk_retract_bin_status <> n.pbk_retract_bin_status
        or o.pbk_retract_bin_count <> n.pbk_retract_bin_count
        or o.siu_operator_switch <> n.siu_operator_switch
        or o.siu_terminal_tamper <> n.siu_terminal_tamper
        or o.siu_alarm_tamper <> n.siu_alarm_tamper
        or o.siu_seismic <> n.siu_seismic
        or o.siu_proximity_detector <> n.siu_proximity_detector
        or o.siu_heat <> n.siu_heat
        or o.siu_ambient_light <> n.siu_ambient_light
        or o.siu_cabinet_state <> n.siu_cabinet_state
        or o.siu_safe_state <> n.siu_safe_state
        or o.siu_shield_state <> n.siu_shield_state
        or o.siu_bill_acceptor_light <> n.siu_bill_acceptor_light
        or o.siu_card_reader_light <> n.siu_card_reader_light
        or o.siu_cheque_unit_light <> n.siu_cheque_unit_light
        or o.siu_coin_dispenser_light <> n.siu_coin_dispenser_light
        or o.siu_note_dispenser_light <> n.siu_note_dispenser_light
        or o.siu_envelope_depository_light <> n.siu_envelope_depository_light
        or o.siu_passbook_printer_light <> n.siu_passbook_printer_light
        or o.siu_pinpad_light <> n.siu_pinpad_light
        or o.siu_receipt_printer_light <> n.siu_receipt_printer_light
        or o.siu_envelope_dispenser_light <> n.siu_envelope_dispenser_light
        or o.cam_camera_area <> n.cam_camera_area
        or o.cam_camera_area_status <> n.cam_camera_area_status
        or o.cam_media_status <> n.cam_media_status
        or o.cam_picture_staken <> n.cam_picture_staken
        or o.dev_cash_status <> n.dev_cash_status
        or o.action_type <> n.action_type
        or o.action_note <> n.action_note
        or o.icc_device_status <> n.icc_device_status
        or o.icc_media_status <> n.icc_media_status
        or o.isc_device_status <> n.isc_device_status
        or o.isc_media_status <> n.isc_media_status
        or o.irc_device_status <> n.irc_device_status
        or o.irc_media_status <> n.irc_media_status
        or o.fpi_device_status <> n.fpi_device_status
        or o.crd_device_status <> n.crd_device_status
        or o.ccd_device_status <> n.ccd_device_status
        or o.dpr_device_status <> n.dpr_device_status
        or o.bcr_device_status <> n.bcr_device_status
        or o.cam_status_area <> n.cam_status_area
        or o.cam_status_media <> n.cam_status_media
        or o.cam_status_state <> n.cam_status_state
        or o.cam_status_pictures <> n.cam_status_pictures
        or o.dev_crs_status <> n.dev_crs_status
        or o.pjc_ret_code <> n.pjc_ret_code
        or o.pjc_cru_status <> n.pjc_cru_status
        or o.pjc_ej_sendtime <> n.pjc_ej_sendtime
        or o.pjc_ej_date <> n.pjc_ej_date
        or o.pjc_ej_nsend <> n.pjc_ej_nsend
        or o.cdm_cu_number <> n.cdm_cu_number
        or o.cim_cu_number <> n.cim_cu_number
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_status_table_cl(
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
    else
        into ${iol_schema}.atms_dev_status_table_op(
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
    o.dev_no -- 设备号
    ,o.dev_status -- HEALTHY(正常) FATAL（故障）WARNING（警告）UNKNOWN（未知）
    ,o.dev_tx_status -- HEALTHY（正常）PARTSERVICE（部分服务）NOSERVICE（停止服务）UNKNOWN（未知）
    ,o.dev_net_status -- HEALTHY（正常）FATAL（故障，即离线）WARNING（警告）UNKNOW（未知）
    ,o.dev_run_status -- HEALTHY(正常) CLOSE（关机）MAINTAIN（维护）NETFATAL（P通讯故障）PARTSERVICE（部分服务）NOSERVICE（停止服务）STOP（停用）UNKNOWN（未知）
    ,o.dev_cashbox_status -- OK（充足）LOW（不足）EMPTY（缺炒）FULL（钞满）UNKNOWN（未知）
    ,o.dev_mod_status -- HEALTHY(正常) FATAL（故障） WARNING（警告） UNKNOWN（未知）
    ,o.dev_potential_fault -- 设备是否存在潜在故障（未使用）
    ,o.status_last_time -- 上次更新时间（yyyymmddhhmmss）
    ,o.status_expire_time -- 状态超时时间（yyyymmddhhmmss）
    ,o.tx_type -- CWD-取款 DET-存款
    ,o.tx_time -- 交易时间（yyyymmddhhmmss）
    ,o.atm_type -- 1 --自动取款机(ATM) 2--自动存款机(CDM) 3--自动存取款机(CRS) 4--多媒体查询机(BSM)
    ,o.cash_unit_type -- P--Physical,L--Logical
    ,o.status_info_type -- 1--定时状态报文 2--强制发送状态报文
    ,o.combin_unit_type -- 0--按默认方式合并 1--按PUPosName合并 2--按DevCdmCUID合并 3--按PUPosName和DevCdmCUID合并
    ,o.idc_device_status -- HEALTHY FATAL WARNING NODEVICE UNKNOWN
    ,o.cim_device_status -- CIM模块状态
    ,o.cdm_device_status -- CMD模块状态
    ,o.dep_device_status -- DEP模块状态
    ,o.ups_device_status -- UPS模块状态
    ,o.spr_device_status -- SPR模块状态
    ,o.rpr_device_status -- RPR模块状态
    ,o.jpr_device_status -- JPR模块状态
    ,o.chk_device_status -- CHK模块状态
    ,o.ttu_device_status -- TTU模块状态
    ,o.pbk_device_status -- PBK模块状态
    ,o.pin_device_status -- PIN模块状态
    ,o.siu_device_status -- SIU模块状态
    ,o.cam_device_status -- CAM模块状态
    ,o.idc_media_status -- PRESENT NOTPRESENT INJAWS JAMMED
    ,o.idc_capture_bin_status -- NOBIN BINOK BINHIGH BINFULL
    ,o.idc_capture_bin_count -- 回收箱数量
    ,o.cim_accept_or_status -- HEALTHY FATAL UNKNOWN
    ,o.cim_escrow_status -- EMPTY NOEMPTY FULL NOESCROW UNKNOWN
    ,o.cim_cash_units -- OK, Warning, Fatal, Unknown
    ,o.cim_shutter_status -- Closed, Open, Jammed, Unknown, NotSupported
    ,o.cim_transport_status -- OK, Inoperable, Unknown, NotSupported
    ,o.cim_inout_position -- InLeft,InRight,InCenter,InTop,InBottom,InFront,InRear,OutLeft,OutRight, OutCenter, OutTop, OutBottom, OutFront, OutRear
    ,o.cim_input_output_status -- EMPTY NOEMPTY UNKNOWN
    ,o.cim_pu_id -- 物理单元标识（数组）
    ,o.cim_pu_count -- 当前物理单元纸币数（数组）
    ,o.cim_pu_cash_in_count -- 物理单元废钞数（数组）
    ,o.cim_pu_status -- 逻辑单元状态
    ,o.cim_pupos_name -- CIM物理钞箱物理位置名集合
    ,o.cim_cu_id -- 逻辑单元标识（数组）
    ,o.cim_pcu_id -- 物理单元与逻辑单元对应关系（数组）
    ,o.cim_cu_note_value -- 逻辑单元纸币面值（数组）
    ,o.cim_cu_currency -- 逻辑单元币种（数组）
    ,o.cim_cu_count -- 当前逻辑单元纸币数（数组）
    ,o.cim_cu_cash_in_count -- 逻辑单元废钞数（数组）
    ,o.cim_cu_type -- 逻辑单元类型
    ,o.cim_cu_status -- CIM逻辑单元状态
    ,o.cdm_shutter_status -- Closed, Open, Jammed, Unknown, NotSupported
    ,o.cdm_dispenser_status -- 退钞状态
    ,o.cdm_safe_door_status -- OPEN FATAL CLOSED LOCKED NOTSUPPORTED
    ,o.cdm_stacker_status -- CDM暂存器状态
    ,o.cdm_cash_units -- OK, Warning, Fatal, Unknown
    ,o.cdm_transport_status -- OK, Inoperable, Unknown, NotSupported
    ,o.cdm_out_position -- Left,Right,Center,Top,Bottom,Front,Rear
    ,o.cdm_input_output_status -- EMPTY NOTEMPTY UNKNOWN NOTSUPPORTED
    ,o.cdm_pu_status -- 物理单元状态(数组)
    ,o.cdm_pu_id -- CDM物理单元标识（数组）
    ,o.cdm_pu_initial_count -- CDM当前物理单元纸币数（数组）
    ,o.cdm_pu_current_count -- 当前物理单元初始币数
    ,o.cdm_pu_reject_count -- CDM物理单元废钞数（数组）
    ,o.cdm_pupos_name -- CDM物理钞箱物理位置名集合
    ,o.cdm_cu_id -- CDM逻辑单元标识（数组）
    ,o.cdm_pcu_id -- CDM物理单元与逻辑单元对应关系（数组）
    ,o.cdm_cu_note_value -- CDM逻辑单元纸币面值（数组）
    ,o.cdm_cu_currency -- CDM逻辑单元币种（数组）
    ,o.cdm_cu_current_count -- CDM当前逻辑单元纸币数（数组）
    ,o.cdm_cu_initial_count -- 当前逻辑单元初始币数
    ,o.cdm_cu_reject_count -- CDM逻辑单元废钞数（数组）
    ,o.cdm_cu_type -- CDM逻辑单元类型
    ,o.cdm_cu_status -- CDM逻辑单元状态
    ,o.dep_deposit_status -- OK NOTPRESENT DEPOSITJAMMED SHUTTERJAMMED
    ,o.dep_deposit_container_status -- OK HIGH FULL NOTPRESENT
    ,o.dep_envelope_supply_status -- OK LOW EMPTY
    ,o.dep_envelope_status -- READY NOTREADY
    ,o.dep_printer_status -- READY NOTREADY
    ,o.dep_printer_ink -- OK LOW EMPTY
    ,o.dep_deposited_items -- 已存信封数量
    ,o.dep_transport_status -- 传送部件状态
    ,o.dep_shutter_status -- 挡板状态
    ,o.ups_low -- TRUE FALSE
    ,o.ups_engaged -- TRUE FALSE
    ,o.ups_powering -- TRUE FALSE
    ,o.ups_recovered -- TRUE FALSE
    ,o.spr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
    ,o.spr_paper_status -- FULL LOW OUT UNKNOWN
    ,o.spr_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
    ,o.spr_ink_status -- 墨水状态
    ,o.spr_toner_status -- 色带状态
    ,o.spr_stack_count -- 暂存数量
    ,o.chk_media_status -- NOPRESENT PRESENT INJAMS JAMMED
    ,o.chk_ink_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
    ,o.rpr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
    ,o.rpr_paper_status -- FULL LOW OUT UNKNOWN
    ,o.rpr_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
    ,o.rpr_ink_status -- RPR墨水状态
    ,o.rpr_toner_status -- RPR色带状态
    ,o.jpr_media_status -- NOPRESENT PRESENT INJAMS JAMMED
    ,o.jpr_paper_status -- FULL LOW OUT UNKNOWN
    ,o.jpr_ink_status -- JPR墨水状态
    ,o.jpr_toner_status -- JPR色带状态
    ,o.pbk_media_status -- NOPRESENT PRESENT INJAMS JAMMED
    ,o.pbk_ink_status -- FULL LOW OUT UNKNOWN
    ,o.pbk_toner_status -- FULL LOW OUT UNKNOWN
    ,o.pbk_retract_bin_status -- NOBIN OK BINHIGH BINFULL BINUNKNOWN
    ,o.pbk_retract_bin_count -- PBK回收单元数量
    ,o.siu_operator_switch -- NOSENSOR ERROR RUN MAINTENANCE SUPERVISOR
    ,o.siu_terminal_tamper -- NOSENSOR ERROR ON OFF
    ,o.siu_alarm_tamper -- NOSENSOR ERROR ON OFF
    ,o.siu_seismic -- NOSENSOR ERROR ON OFF
    ,o.siu_proximity_detector -- NOSENSOR ERROR ON OFF
    ,o.siu_heat -- NOSENSOR ERROR ON OFF
    ,o.siu_ambient_light -- NOSENSOR ERROR VERYLIGHT LIGHT MEDIUMLIGHT DARK VERYDARK
    ,o.siu_cabinet_state -- 机箱状态
    ,o.siu_safe_state -- SIU安全门状态
    ,o.siu_shield_state -- SIU档板状态
    ,o.siu_bill_acceptor_light -- HEALTHY FATAL NODEVICE
    ,o.siu_card_reader_light -- HEALTHY FATAL NODEVICE
    ,o.siu_cheque_unit_light -- HEALTHY FATAL NODEVICE
    ,o.siu_coin_dispenser_light -- HEALTHY FATAL NODEVICE
    ,o.siu_note_dispenser_light -- HEALTHY FATAL NODEVICE
    ,o.siu_envelope_depository_light -- HEALTHY FATAL NODEVICE
    ,o.siu_passbook_printer_light -- HEALTHY FATAL NODEVICE
    ,o.siu_pinpad_light -- HEALTHY FATAL NODEVICE
    ,o.siu_receipt_printer_light -- HEALTHY FATAL NODEVICE
    ,o.siu_envelope_dispenser_light -- HEALTHY FATAL NODEVICE
    ,o.cam_camera_area -- room,person,exit_slot
    ,o.cam_camera_area_status -- HEALTHY FATAL NODEVICE
    ,o.cam_media_status -- LOW HIGH FULL
    ,o.cam_picture_staken -- 已获取图像
    ,o.dev_cash_status -- 0：正常1：无法取款2：无法存款3：无法存取款
    ,o.action_type -- 运行状态
    ,o.action_note -- 运行子状态
    ,o.icc_device_status -- ICC_DEVICE_STATUS
    ,o.icc_media_status -- ICC_MEDIA_STATUS
    ,o.isc_device_status -- ISC_DEVICE_STATUS
    ,o.isc_media_status -- ISC_MEDIA_STATUS
    ,o.irc_device_status -- IRC_DEVICE_STATUS
    ,o.irc_media_status -- IRC_MEDIA_STATUS
    ,o.fpi_device_status -- FPI_DEVICE_STATUS
    ,o.crd_device_status -- CRD_DEVICE_STATUS
    ,o.ccd_device_status -- CCD_DEVICE_STATUS
    ,o.dpr_device_status -- 盖章模块状态
    ,o.bcr_device_status -- 二维码扫描仪模块状态
    ,o.cam_status_area -- 
    ,o.cam_status_media -- 
    ,o.cam_status_state -- 
    ,o.cam_status_pictures -- 
    ,o.dev_crs_status -- 0：正常1：无法取款2：无法存款3：无法存取款
    ,o.pjc_ret_code -- PJC故障码
    ,o.pjc_cru_status -- PJC模块主状态，Healthy-正常（进程存在），Fatal-失败
    ,o.pjc_ej_sendtime -- PJC流水上传时间
    ,o.pjc_ej_date -- PJC上传流水日期
    ,o.pjc_ej_nsend -- 剩余未发送缓存流水情况，Without-未采集到流水，Ok-未发送流水数据为0，High-未发送流水数据未达到阀值，Full-未发送流水数据大于等于阀值
    ,o.cdm_cu_number -- 取款箱逻辑钞箱索引号
    ,o.cim_cu_number -- 存款箱逻辑钞箱索引号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.atms_dev_status_table_bk o
    left join ${iol_schema}.atms_dev_status_table_op n
        on
            o.dev_no = n.dev_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.atms_dev_status_table_cl d
        on
            o.dev_no = d.dev_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.atms_dev_status_table;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('atms_dev_status_table') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.atms_dev_status_table drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.atms_dev_status_table add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.atms_dev_status_table exchange partition p_${batch_date} with table ${iol_schema}.atms_dev_status_table_cl;
alter table ${iol_schema}.atms_dev_status_table exchange partition p_20991231 with table ${iol_schema}.atms_dev_status_table_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.atms_dev_status_table to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_status_table_op purge;
drop table ${iol_schema}.atms_dev_status_table_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.atms_dev_status_table_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'atms_dev_status_table',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
