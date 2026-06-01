/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol atms_dev_status_table
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.atms_dev_status_table
whenever sqlerror continue none;
drop table ${iol_schema}.atms_dev_status_table purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_status_table(
    dev_no varchar2(20) -- 设备号
    ,dev_status varchar2(20) -- healthy(正常) fatal（故障）warning（警告）unknown（未知）
    ,dev_tx_status varchar2(20) -- healthy（正常）partservice（部分服务）noservice（停止服务）unknown（未知）
    ,dev_net_status varchar2(20) -- healthy（正常）fatal（故障，即离线）warning（警告）unknow（未知）
    ,dev_run_status varchar2(20) -- healthy(正常) close（关机）maintain（维护）netfatal（p通讯故障）partservice（部分服务）noservice（停止服务）stop（停用）unknown（未知）
    ,dev_cashbox_status varchar2(20) -- ok（充足）low（不足）empty（缺炒）full（钞满）unknown（未知）
    ,dev_mod_status varchar2(20) -- healthy(正常) fatal（故障） warning（警告） unknown（未知）
    ,dev_potential_fault varchar2(20) -- 设备是否存在潜在故障（未使用）
    ,status_last_time varchar2(14) -- 上次更新时间（yyyymmddhhmmss）
    ,status_expire_time varchar2(14) -- 状态超时时间（yyyymmddhhmmss）
    ,tx_type varchar2(15) -- cwd-取款 det-存款
    ,tx_time varchar2(14) -- 交易时间（yyyymmddhhmmss）
    ,atm_type varchar2(1) -- 1 --自动取款机(atm) 2--自动存款机(cdm) 3--自动存取款机(crs) 4--多媒体查询机(bsm)
    ,cash_unit_type varchar2(1) -- p--physical,l--logical
    ,status_info_type varchar2(1) -- 1--定时状态报文 2--强制发送状态报文
    ,combin_unit_type varchar2(1) -- 0--按默认方式合并 1--按puposname合并 2--按devcdmcuid合并 3--按puposname和devcdmcuid合并
    ,idc_device_status varchar2(15) -- healthy fatal warning nodevice unknown
    ,cim_device_status varchar2(15) -- cim模块状态
    ,cdm_device_status varchar2(15) -- cmd模块状态
    ,dep_device_status varchar2(15) -- dep模块状态
    ,ups_device_status varchar2(15) -- ups模块状态
    ,spr_device_status varchar2(15) -- spr模块状态
    ,rpr_device_status varchar2(15) -- rpr模块状态
    ,jpr_device_status varchar2(15) -- jpr模块状态
    ,chk_device_status varchar2(15) -- chk模块状态
    ,ttu_device_status varchar2(15) -- ttu模块状态
    ,pbk_device_status varchar2(15) -- pbk模块状态
    ,pin_device_status varchar2(15) -- pin模块状态
    ,siu_device_status varchar2(15) -- siu模块状态
    ,cam_device_status varchar2(15) -- cam模块状态
    ,idc_media_status varchar2(20) -- present notpresent injaws jammed
    ,idc_capture_bin_status varchar2(20) -- nobin binok binhigh binfull
    ,idc_capture_bin_count varchar2(10) -- 回收箱数量
    ,cim_accept_or_status varchar2(20) -- healthy fatal unknown
    ,cim_escrow_status varchar2(20) -- empty noempty full noescrow unknown
    ,cim_cash_units varchar2(20) -- ok, warning, fatal, unknown
    ,cim_shutter_status varchar2(40) -- closed, open, jammed, unknown, notsupported
    ,cim_transport_status varchar2(40) -- ok, inoperable, unknown, notsupported
    ,cim_inout_position varchar2(40) -- inleft,inright,incenter,intop,inbottom,infront,inrear,outleft,outright, outcenter, outtop, outbottom, outfront, outrear
    ,cim_input_output_status varchar2(100) -- empty noempty unknown
    ,cim_pu_id varchar2(100) -- 物理单元标识（数组）
    ,cim_pu_count varchar2(100) -- 当前物理单元纸币数（数组）
    ,cim_pu_cash_in_count varchar2(100) -- 物理单元废钞数（数组）
    ,cim_pu_status varchar2(100) -- 逻辑单元状态
    ,cim_pupos_name varchar2(200) -- cim物理钞箱物理位置名集合
    ,cim_cu_id varchar2(100) -- 逻辑单元标识（数组）
    ,cim_pcu_id varchar2(100) -- 物理单元与逻辑单元对应关系（数组）
    ,cim_cu_note_value varchar2(100) -- 逻辑单元纸币面值（数组）
    ,cim_cu_currency varchar2(100) -- 逻辑单元币种（数组）
    ,cim_cu_count varchar2(100) -- 当前逻辑单元纸币数（数组）
    ,cim_cu_cash_in_count varchar2(100) -- 逻辑单元废钞数（数组）
    ,cim_cu_type varchar2(500) -- 逻辑单元类型
    ,cim_cu_status varchar2(100) -- cim逻辑单元状态
    ,cdm_shutter_status varchar2(20) -- closed, open, jammed, unknown, notsupported
    ,cdm_dispenser_status varchar2(20) -- 退钞状态
    ,cdm_safe_door_status varchar2(20) -- open fatal closed locked notsupported
    ,cdm_stacker_status varchar2(20) -- cdm暂存器状态
    ,cdm_cash_units varchar2(20) -- ok, warning, fatal, unknown
    ,cdm_transport_status varchar2(40) -- ok, inoperable, unknown, notsupported
    ,cdm_out_position varchar2(40) -- left,right,center,top,bottom,front,rear
    ,cdm_input_output_status varchar2(20) -- empty notempty unknown notsupported
    ,cdm_pu_status varchar2(100) -- 物理单元状态(数组)
    ,cdm_pu_id varchar2(100) -- cdm物理单元标识（数组）
    ,cdm_pu_initial_count varchar2(100) -- cdm当前物理单元纸币数（数组）
    ,cdm_pu_current_count varchar2(100) -- 当前物理单元初始币数
    ,cdm_pu_reject_count varchar2(100) -- cdm物理单元废钞数（数组）
    ,cdm_pupos_name varchar2(200) -- cdm物理钞箱物理位置名集合
    ,cdm_cu_id varchar2(100) -- cdm逻辑单元标识（数组）
    ,cdm_pcu_id varchar2(100) -- cdm物理单元与逻辑单元对应关系（数组）
    ,cdm_cu_note_value varchar2(100) -- cdm逻辑单元纸币面值（数组）
    ,cdm_cu_currency varchar2(100) -- cdm逻辑单元币种（数组）
    ,cdm_cu_current_count varchar2(100) -- cdm当前逻辑单元纸币数（数组）
    ,cdm_cu_initial_count varchar2(100) -- 当前逻辑单元初始币数
    ,cdm_cu_reject_count varchar2(100) -- cdm逻辑单元废钞数（数组）
    ,cdm_cu_type varchar2(500) -- cdm逻辑单元类型
    ,cdm_cu_status varchar2(100) -- cdm逻辑单元状态
    ,dep_deposit_status varchar2(20) -- ok notpresent depositjammed shutterjammed
    ,dep_deposit_container_status varchar2(20) -- ok high full notpresent
    ,dep_envelope_supply_status varchar2(20) -- ok low empty
    ,dep_envelope_status varchar2(20) -- ready notready
    ,dep_printer_status varchar2(20) -- ready notready
    ,dep_printer_ink varchar2(20) -- ok low empty
    ,dep_deposited_items varchar2(10) -- 已存信封数量
    ,dep_transport_status varchar2(20) -- 传送部件状态
    ,dep_shutter_status varchar2(20) -- 挡板状态
    ,ups_low varchar2(20) -- true false
    ,ups_engaged varchar2(20) -- true false
    ,ups_powering varchar2(20) -- true false
    ,ups_recovered varchar2(20) -- true false
    ,spr_media_status varchar2(20) -- nopresent present injams jammed
    ,spr_paper_status varchar2(20) -- full low out unknown
    ,spr_retract_bin_status varchar2(20) -- nobin ok binhigh binfull binunknown
    ,spr_ink_status varchar2(20) -- 墨水状态
    ,spr_toner_status varchar2(20) -- 色带状态
    ,spr_stack_count varchar2(10) -- 暂存数量
    ,chk_media_status varchar2(20) -- nopresent present injams jammed
    ,chk_ink_status varchar2(20) -- nobin ok binhigh binfull binunknown
    ,rpr_media_status varchar2(20) -- nopresent present injams jammed
    ,rpr_paper_status varchar2(20) -- full low out unknown
    ,rpr_retract_bin_status varchar2(20) -- nobin ok binhigh binfull binunknown
    ,rpr_ink_status varchar2(20) -- rpr墨水状态
    ,rpr_toner_status varchar2(20) -- rpr色带状态
    ,jpr_media_status varchar2(20) -- nopresent present injams jammed
    ,jpr_paper_status varchar2(20) -- full low out unknown
    ,jpr_ink_status varchar2(20) -- jpr墨水状态
    ,jpr_toner_status varchar2(20) -- jpr色带状态
    ,pbk_media_status varchar2(20) -- nopresent present injams jammed
    ,pbk_ink_status varchar2(20) -- full low out unknown
    ,pbk_toner_status varchar2(20) -- full low out unknown
    ,pbk_retract_bin_status varchar2(20) -- nobin ok binhigh binfull binunknown
    ,pbk_retract_bin_count varchar2(10) -- pbk回收单元数量
    ,siu_operator_switch varchar2(20) -- nosensor error run maintenance supervisor
    ,siu_terminal_tamper varchar2(20) -- nosensor error on off
    ,siu_alarm_tamper varchar2(20) -- nosensor error on off
    ,siu_seismic varchar2(20) -- nosensor error on off
    ,siu_proximity_detector varchar2(20) -- nosensor error on off
    ,siu_heat varchar2(20) -- nosensor error on off
    ,siu_ambient_light varchar2(20) -- nosensor error verylight light mediumlight dark verydark
    ,siu_cabinet_state varchar2(20) -- 机箱状态
    ,siu_safe_state varchar2(20) -- siu安全门状态
    ,siu_shield_state varchar2(20) -- siu档板状态
    ,siu_bill_acceptor_light varchar2(20) -- healthy fatal nodevice
    ,siu_card_reader_light varchar2(20) -- healthy fatal nodevice
    ,siu_cheque_unit_light varchar2(20) -- healthy fatal nodevice
    ,siu_coin_dispenser_light varchar2(20) -- healthy fatal nodevice
    ,siu_note_dispenser_light varchar2(20) -- healthy fatal nodevice
    ,siu_envelope_depository_light varchar2(20) -- healthy fatal nodevice
    ,siu_passbook_printer_light varchar2(20) -- healthy fatal nodevice
    ,siu_pinpad_light varchar2(20) -- healthy fatal nodevice
    ,siu_receipt_printer_light varchar2(20) -- healthy fatal nodevice
    ,siu_envelope_dispenser_light varchar2(20) -- healthy fatal nodevice
    ,cam_camera_area varchar2(40) -- room,person,exit_slot
    ,cam_camera_area_status varchar2(40) -- healthy fatal nodevice
    ,cam_media_status varchar2(40) -- low high full
    ,cam_picture_staken varchar2(10) -- 已获取图像
    ,dev_cash_status varchar2(1) -- 0：正常1：无法取款2：无法存款3：无法存取款
    ,action_type varchar2(2) -- 运行状态
    ,action_note varchar2(2) -- 运行子状态
    ,icc_device_status varchar2(15) -- icc_device_status
    ,icc_media_status varchar2(20) -- icc_media_status
    ,isc_device_status varchar2(15) -- isc_device_status
    ,isc_media_status varchar2(20) -- isc_media_status
    ,irc_device_status varchar2(15) -- irc_device_status
    ,irc_media_status varchar2(20) -- irc_media_status
    ,fpi_device_status varchar2(15) -- fpi_device_status
    ,crd_device_status varchar2(15) -- crd_device_status
    ,ccd_device_status varchar2(15) -- ccd_device_status
    ,dpr_device_status varchar2(15) -- 盖章模块状态
    ,bcr_device_status varchar2(15) -- 二维码扫描仪模块状态
    ,cam_status_area varchar2(100) -- 
    ,cam_status_media varchar2(100) -- 
    ,cam_status_state varchar2(100) -- 
    ,cam_status_pictures varchar2(100) -- 
    ,dev_crs_status varchar2(1) -- 0：正常1：无法取款2：无法存款3：无法存取款
    ,pjc_ret_code varchar2(20) -- pjc故障码
    ,pjc_cru_status varchar2(20) -- pjc模块主状态，healthy-正常（进程存在），fatal-失败
    ,pjc_ej_sendtime varchar2(20) -- pjc流水上传时间
    ,pjc_ej_date varchar2(20) -- pjc上传流水日期
    ,pjc_ej_nsend varchar2(20) -- 剩余未发送缓存流水情况，without-未采集到流水，ok-未发送流水数据为0，high-未发送流水数据未达到阀值，full-未发送流水数据大于等于阀值
    ,cdm_cu_number varchar2(100) -- 取款箱逻辑钞箱索引号
    ,cim_cu_number varchar2(100) -- 存款箱逻辑钞箱索引号
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.atms_dev_status_table to ${iml_schema};
grant select on ${iol_schema}.atms_dev_status_table to ${icl_schema};
grant select on ${iol_schema}.atms_dev_status_table to ${idl_schema};
grant select on ${iol_schema}.atms_dev_status_table to ${iel_schema};

-- comment
comment on table ${iol_schema}.atms_dev_status_table is '设备模块状态表';
comment on column ${iol_schema}.atms_dev_status_table.dev_no is '设备号';
comment on column ${iol_schema}.atms_dev_status_table.dev_status is 'healthy(正常) fatal（故障）warning（警告）unknown（未知）';
comment on column ${iol_schema}.atms_dev_status_table.dev_tx_status is 'healthy（正常）partservice（部分服务）noservice（停止服务）unknown（未知）';
comment on column ${iol_schema}.atms_dev_status_table.dev_net_status is 'healthy（正常）fatal（故障，即离线）warning（警告）unknow（未知）';
comment on column ${iol_schema}.atms_dev_status_table.dev_run_status is 'healthy(正常) close（关机）maintain（维护）netfatal（p通讯故障）partservice（部分服务）noservice（停止服务）stop（停用）unknown（未知）';
comment on column ${iol_schema}.atms_dev_status_table.dev_cashbox_status is 'ok（充足）low（不足）empty（缺炒）full（钞满）unknown（未知）';
comment on column ${iol_schema}.atms_dev_status_table.dev_mod_status is 'healthy(正常) fatal（故障） warning（警告） unknown（未知）';
comment on column ${iol_schema}.atms_dev_status_table.dev_potential_fault is '设备是否存在潜在故障（未使用）';
comment on column ${iol_schema}.atms_dev_status_table.status_last_time is '上次更新时间（yyyymmddhhmmss）';
comment on column ${iol_schema}.atms_dev_status_table.status_expire_time is '状态超时时间（yyyymmddhhmmss）';
comment on column ${iol_schema}.atms_dev_status_table.tx_type is 'cwd-取款 det-存款';
comment on column ${iol_schema}.atms_dev_status_table.tx_time is '交易时间（yyyymmddhhmmss）';
comment on column ${iol_schema}.atms_dev_status_table.atm_type is '1 --自动取款机(atm) 2--自动存款机(cdm) 3--自动存取款机(crs) 4--多媒体查询机(bsm)';
comment on column ${iol_schema}.atms_dev_status_table.cash_unit_type is 'p--physical,l--logical';
comment on column ${iol_schema}.atms_dev_status_table.status_info_type is '1--定时状态报文 2--强制发送状态报文';
comment on column ${iol_schema}.atms_dev_status_table.combin_unit_type is '0--按默认方式合并 1--按puposname合并 2--按devcdmcuid合并 3--按puposname和devcdmcuid合并';
comment on column ${iol_schema}.atms_dev_status_table.idc_device_status is 'healthy fatal warning nodevice unknown';
comment on column ${iol_schema}.atms_dev_status_table.cim_device_status is 'cim模块状态';
comment on column ${iol_schema}.atms_dev_status_table.cdm_device_status is 'cmd模块状态';
comment on column ${iol_schema}.atms_dev_status_table.dep_device_status is 'dep模块状态';
comment on column ${iol_schema}.atms_dev_status_table.ups_device_status is 'ups模块状态';
comment on column ${iol_schema}.atms_dev_status_table.spr_device_status is 'spr模块状态';
comment on column ${iol_schema}.atms_dev_status_table.rpr_device_status is 'rpr模块状态';
comment on column ${iol_schema}.atms_dev_status_table.jpr_device_status is 'jpr模块状态';
comment on column ${iol_schema}.atms_dev_status_table.chk_device_status is 'chk模块状态';
comment on column ${iol_schema}.atms_dev_status_table.ttu_device_status is 'ttu模块状态';
comment on column ${iol_schema}.atms_dev_status_table.pbk_device_status is 'pbk模块状态';
comment on column ${iol_schema}.atms_dev_status_table.pin_device_status is 'pin模块状态';
comment on column ${iol_schema}.atms_dev_status_table.siu_device_status is 'siu模块状态';
comment on column ${iol_schema}.atms_dev_status_table.cam_device_status is 'cam模块状态';
comment on column ${iol_schema}.atms_dev_status_table.idc_media_status is 'present notpresent injaws jammed';
comment on column ${iol_schema}.atms_dev_status_table.idc_capture_bin_status is 'nobin binok binhigh binfull';
comment on column ${iol_schema}.atms_dev_status_table.idc_capture_bin_count is '回收箱数量';
comment on column ${iol_schema}.atms_dev_status_table.cim_accept_or_status is 'healthy fatal unknown';
comment on column ${iol_schema}.atms_dev_status_table.cim_escrow_status is 'empty noempty full noescrow unknown';
comment on column ${iol_schema}.atms_dev_status_table.cim_cash_units is 'ok, warning, fatal, unknown';
comment on column ${iol_schema}.atms_dev_status_table.cim_shutter_status is 'closed, open, jammed, unknown, notsupported';
comment on column ${iol_schema}.atms_dev_status_table.cim_transport_status is 'ok, inoperable, unknown, notsupported';
comment on column ${iol_schema}.atms_dev_status_table.cim_inout_position is 'inleft,inright,incenter,intop,inbottom,infront,inrear,outleft,outright, outcenter, outtop, outbottom, outfront, outrear';
comment on column ${iol_schema}.atms_dev_status_table.cim_input_output_status is 'empty noempty unknown';
comment on column ${iol_schema}.atms_dev_status_table.cim_pu_id is '物理单元标识（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cim_pu_count is '当前物理单元纸币数（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cim_pu_cash_in_count is '物理单元废钞数（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cim_pu_status is '逻辑单元状态';
comment on column ${iol_schema}.atms_dev_status_table.cim_pupos_name is 'cim物理钞箱物理位置名集合';
comment on column ${iol_schema}.atms_dev_status_table.cim_cu_id is '逻辑单元标识（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cim_pcu_id is '物理单元与逻辑单元对应关系（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cim_cu_note_value is '逻辑单元纸币面值（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cim_cu_currency is '逻辑单元币种（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cim_cu_count is '当前逻辑单元纸币数（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cim_cu_cash_in_count is '逻辑单元废钞数（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cim_cu_type is '逻辑单元类型';
comment on column ${iol_schema}.atms_dev_status_table.cim_cu_status is 'cim逻辑单元状态';
comment on column ${iol_schema}.atms_dev_status_table.cdm_shutter_status is 'closed, open, jammed, unknown, notsupported';
comment on column ${iol_schema}.atms_dev_status_table.cdm_dispenser_status is '退钞状态';
comment on column ${iol_schema}.atms_dev_status_table.cdm_safe_door_status is 'open fatal closed locked notsupported';
comment on column ${iol_schema}.atms_dev_status_table.cdm_stacker_status is 'cdm暂存器状态';
comment on column ${iol_schema}.atms_dev_status_table.cdm_cash_units is 'ok, warning, fatal, unknown';
comment on column ${iol_schema}.atms_dev_status_table.cdm_transport_status is 'ok, inoperable, unknown, notsupported';
comment on column ${iol_schema}.atms_dev_status_table.cdm_out_position is 'left,right,center,top,bottom,front,rear';
comment on column ${iol_schema}.atms_dev_status_table.cdm_input_output_status is 'empty notempty unknown notsupported';
comment on column ${iol_schema}.atms_dev_status_table.cdm_pu_status is '物理单元状态(数组)';
comment on column ${iol_schema}.atms_dev_status_table.cdm_pu_id is 'cdm物理单元标识（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cdm_pu_initial_count is 'cdm当前物理单元纸币数（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cdm_pu_current_count is '当前物理单元初始币数';
comment on column ${iol_schema}.atms_dev_status_table.cdm_pu_reject_count is 'cdm物理单元废钞数（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cdm_pupos_name is 'cdm物理钞箱物理位置名集合';
comment on column ${iol_schema}.atms_dev_status_table.cdm_cu_id is 'cdm逻辑单元标识（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cdm_pcu_id is 'cdm物理单元与逻辑单元对应关系（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cdm_cu_note_value is 'cdm逻辑单元纸币面值（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cdm_cu_currency is 'cdm逻辑单元币种（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cdm_cu_current_count is 'cdm当前逻辑单元纸币数（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cdm_cu_initial_count is '当前逻辑单元初始币数';
comment on column ${iol_schema}.atms_dev_status_table.cdm_cu_reject_count is 'cdm逻辑单元废钞数（数组）';
comment on column ${iol_schema}.atms_dev_status_table.cdm_cu_type is 'cdm逻辑单元类型';
comment on column ${iol_schema}.atms_dev_status_table.cdm_cu_status is 'cdm逻辑单元状态';
comment on column ${iol_schema}.atms_dev_status_table.dep_deposit_status is 'ok notpresent depositjammed shutterjammed';
comment on column ${iol_schema}.atms_dev_status_table.dep_deposit_container_status is 'ok high full notpresent';
comment on column ${iol_schema}.atms_dev_status_table.dep_envelope_supply_status is 'ok low empty';
comment on column ${iol_schema}.atms_dev_status_table.dep_envelope_status is 'ready notready';
comment on column ${iol_schema}.atms_dev_status_table.dep_printer_status is 'ready notready';
comment on column ${iol_schema}.atms_dev_status_table.dep_printer_ink is 'ok low empty';
comment on column ${iol_schema}.atms_dev_status_table.dep_deposited_items is '已存信封数量';
comment on column ${iol_schema}.atms_dev_status_table.dep_transport_status is '传送部件状态';
comment on column ${iol_schema}.atms_dev_status_table.dep_shutter_status is '挡板状态';
comment on column ${iol_schema}.atms_dev_status_table.ups_low is 'true false';
comment on column ${iol_schema}.atms_dev_status_table.ups_engaged is 'true false';
comment on column ${iol_schema}.atms_dev_status_table.ups_powering is 'true false';
comment on column ${iol_schema}.atms_dev_status_table.ups_recovered is 'true false';
comment on column ${iol_schema}.atms_dev_status_table.spr_media_status is 'nopresent present injams jammed';
comment on column ${iol_schema}.atms_dev_status_table.spr_paper_status is 'full low out unknown';
comment on column ${iol_schema}.atms_dev_status_table.spr_retract_bin_status is 'nobin ok binhigh binfull binunknown';
comment on column ${iol_schema}.atms_dev_status_table.spr_ink_status is '墨水状态';
comment on column ${iol_schema}.atms_dev_status_table.spr_toner_status is '色带状态';
comment on column ${iol_schema}.atms_dev_status_table.spr_stack_count is '暂存数量';
comment on column ${iol_schema}.atms_dev_status_table.chk_media_status is 'nopresent present injams jammed';
comment on column ${iol_schema}.atms_dev_status_table.chk_ink_status is 'nobin ok binhigh binfull binunknown';
comment on column ${iol_schema}.atms_dev_status_table.rpr_media_status is 'nopresent present injams jammed';
comment on column ${iol_schema}.atms_dev_status_table.rpr_paper_status is 'full low out unknown';
comment on column ${iol_schema}.atms_dev_status_table.rpr_retract_bin_status is 'nobin ok binhigh binfull binunknown';
comment on column ${iol_schema}.atms_dev_status_table.rpr_ink_status is 'rpr墨水状态';
comment on column ${iol_schema}.atms_dev_status_table.rpr_toner_status is 'rpr色带状态';
comment on column ${iol_schema}.atms_dev_status_table.jpr_media_status is 'nopresent present injams jammed';
comment on column ${iol_schema}.atms_dev_status_table.jpr_paper_status is 'full low out unknown';
comment on column ${iol_schema}.atms_dev_status_table.jpr_ink_status is 'jpr墨水状态';
comment on column ${iol_schema}.atms_dev_status_table.jpr_toner_status is 'jpr色带状态';
comment on column ${iol_schema}.atms_dev_status_table.pbk_media_status is 'nopresent present injams jammed';
comment on column ${iol_schema}.atms_dev_status_table.pbk_ink_status is 'full low out unknown';
comment on column ${iol_schema}.atms_dev_status_table.pbk_toner_status is 'full low out unknown';
comment on column ${iol_schema}.atms_dev_status_table.pbk_retract_bin_status is 'nobin ok binhigh binfull binunknown';
comment on column ${iol_schema}.atms_dev_status_table.pbk_retract_bin_count is 'pbk回收单元数量';
comment on column ${iol_schema}.atms_dev_status_table.siu_operator_switch is 'nosensor error run maintenance supervisor';
comment on column ${iol_schema}.atms_dev_status_table.siu_terminal_tamper is 'nosensor error on off';
comment on column ${iol_schema}.atms_dev_status_table.siu_alarm_tamper is 'nosensor error on off';
comment on column ${iol_schema}.atms_dev_status_table.siu_seismic is 'nosensor error on off';
comment on column ${iol_schema}.atms_dev_status_table.siu_proximity_detector is 'nosensor error on off';
comment on column ${iol_schema}.atms_dev_status_table.siu_heat is 'nosensor error on off';
comment on column ${iol_schema}.atms_dev_status_table.siu_ambient_light is 'nosensor error verylight light mediumlight dark verydark';
comment on column ${iol_schema}.atms_dev_status_table.siu_cabinet_state is '机箱状态';
comment on column ${iol_schema}.atms_dev_status_table.siu_safe_state is 'siu安全门状态';
comment on column ${iol_schema}.atms_dev_status_table.siu_shield_state is 'siu档板状态';
comment on column ${iol_schema}.atms_dev_status_table.siu_bill_acceptor_light is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.siu_card_reader_light is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.siu_cheque_unit_light is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.siu_coin_dispenser_light is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.siu_note_dispenser_light is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.siu_envelope_depository_light is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.siu_passbook_printer_light is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.siu_pinpad_light is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.siu_receipt_printer_light is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.siu_envelope_dispenser_light is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.cam_camera_area is 'room,person,exit_slot';
comment on column ${iol_schema}.atms_dev_status_table.cam_camera_area_status is 'healthy fatal nodevice';
comment on column ${iol_schema}.atms_dev_status_table.cam_media_status is 'low high full';
comment on column ${iol_schema}.atms_dev_status_table.cam_picture_staken is '已获取图像';
comment on column ${iol_schema}.atms_dev_status_table.dev_cash_status is '0：正常1：无法取款2：无法存款3：无法存取款';
comment on column ${iol_schema}.atms_dev_status_table.action_type is '运行状态';
comment on column ${iol_schema}.atms_dev_status_table.action_note is '运行子状态';
comment on column ${iol_schema}.atms_dev_status_table.icc_device_status is 'icc_device_status';
comment on column ${iol_schema}.atms_dev_status_table.icc_media_status is 'icc_media_status';
comment on column ${iol_schema}.atms_dev_status_table.isc_device_status is 'isc_device_status';
comment on column ${iol_schema}.atms_dev_status_table.isc_media_status is 'isc_media_status';
comment on column ${iol_schema}.atms_dev_status_table.irc_device_status is 'irc_device_status';
comment on column ${iol_schema}.atms_dev_status_table.irc_media_status is 'irc_media_status';
comment on column ${iol_schema}.atms_dev_status_table.fpi_device_status is 'fpi_device_status';
comment on column ${iol_schema}.atms_dev_status_table.crd_device_status is 'crd_device_status';
comment on column ${iol_schema}.atms_dev_status_table.ccd_device_status is 'ccd_device_status';
comment on column ${iol_schema}.atms_dev_status_table.dpr_device_status is '盖章模块状态';
comment on column ${iol_schema}.atms_dev_status_table.bcr_device_status is '二维码扫描仪模块状态';
comment on column ${iol_schema}.atms_dev_status_table.cam_status_area is '';
comment on column ${iol_schema}.atms_dev_status_table.cam_status_media is '';
comment on column ${iol_schema}.atms_dev_status_table.cam_status_state is '';
comment on column ${iol_schema}.atms_dev_status_table.cam_status_pictures is '';
comment on column ${iol_schema}.atms_dev_status_table.dev_crs_status is '0：正常1：无法取款2：无法存款3：无法存取款';
comment on column ${iol_schema}.atms_dev_status_table.pjc_ret_code is 'pjc故障码';
comment on column ${iol_schema}.atms_dev_status_table.pjc_cru_status is 'pjc模块主状态，healthy-正常（进程存在），fatal-失败';
comment on column ${iol_schema}.atms_dev_status_table.pjc_ej_sendtime is 'pjc流水上传时间';
comment on column ${iol_schema}.atms_dev_status_table.pjc_ej_date is 'pjc上传流水日期';
comment on column ${iol_schema}.atms_dev_status_table.pjc_ej_nsend is '剩余未发送缓存流水情况，without-未采集到流水，ok-未发送流水数据为0，high-未发送流水数据未达到阀值，full-未发送流水数据大于等于阀值';
comment on column ${iol_schema}.atms_dev_status_table.cdm_cu_number is '取款箱逻辑钞箱索引号';
comment on column ${iol_schema}.atms_dev_status_table.cim_cu_number is '存款箱逻辑钞箱索引号';
comment on column ${iol_schema}.atms_dev_status_table.start_dt is '开始时间';
comment on column ${iol_schema}.atms_dev_status_table.end_dt is '结束时间';
comment on column ${iol_schema}.atms_dev_status_table.id_mark is '增删标志';
comment on column ${iol_schema}.atms_dev_status_table.etl_timestamp is 'ETL处理时间戳';
