/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl base_d_equip_status_monit_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.base_d_equip_status_monit_info
whenever sqlerror continue none;
drop table ${idl_schema}.base_d_equip_status_monit_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_equip_status_monit_info(
    equip_brand varchar2(20) -- 设备品牌
    ,equip_type varchar2(20) -- 设备类型
    ,equip_model varchar2(20) -- 设备型号
    ,equip_id varchar2(20) -- 设备编号
    ,move_status varchar2(20) -- 运行状态
    ,module_status varchar2(20) -- 模块状态
    ,dev_status varchar2(20) -- 钱箱状态
    ,web_status varchar2(20) -- 网络状态
    ,capture_bin_count number(16,2) -- 吞卡数量
    ,equip_belong_org_code varchar2(20) -- 设备所属机构编码
    ,inst_addr varchar2(2000) -- 装机地址
    ,mang_way varchar2(10) -- 经营方式
    ,in_bank_out_bank_flg varchar2(10) -- 在行离行标志
    ,dev_addr varchar2(20) -- ip地址
    ,self_equip_type varchar2(10) -- 自助设备类型
    ,self_equip_type_name varchar2(20) -- 自助设备类型名称
    ,equip_mger_member varchar2(200) -- 设备管理人员
    ,equip_oper_status varchar2(20) -- 设备运营状态
    ,last_update_tm varchar2(30) -- 上次更新时间
    ,equip_status varchar2(20) -- 设备状态
    ,denom number(16,2) -- 分母
    ,matn_stop_duran number(16,2) -- 维护停机时长
    ,fault_stop_duran number(16,2) -- 故障停机时长
    ,offline_stop_duran number(16,2) -- 离线停机时长
    ,fault_tot_cnt number(16,2) -- 故障总次数
    ,fault_tot_tm number(16,2) -- 故障总时间
    ,qz_duran number(16,2) -- 缺纸时长
    ,qz_cnt number(16,2) -- 缺纸次数
    ,qc_duran number(16,2) -- 缺钞时长
    ,qc_cnt number(16,2) -- 缺钞次数
    ,cm_duran number(16,2) -- 钞满时长
    ,cm_cnt number(16,2) -- 钞满次数
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.base_d_equip_status_monit_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.base_d_equip_status_monit_info is '设备状态监控信息日报表';
comment on column ${idl_schema}.base_d_equip_status_monit_info.equip_brand is '设备品牌';
comment on column ${idl_schema}.base_d_equip_status_monit_info.equip_type is '设备类型';
comment on column ${idl_schema}.base_d_equip_status_monit_info.equip_model is '设备型号';
comment on column ${idl_schema}.base_d_equip_status_monit_info.equip_id is '设备编号';
comment on column ${idl_schema}.base_d_equip_status_monit_info.move_status is '运行状态';
comment on column ${idl_schema}.base_d_equip_status_monit_info.module_status is '模块状态';
comment on column ${idl_schema}.base_d_equip_status_monit_info.dev_status is '钱箱状态';
comment on column ${idl_schema}.base_d_equip_status_monit_info.web_status is '网络状态';
comment on column ${idl_schema}.base_d_equip_status_monit_info.capture_bin_count is '吞卡数量';
comment on column ${idl_schema}.base_d_equip_status_monit_info.equip_belong_org_code is '设备所属机构编码';
comment on column ${idl_schema}.base_d_equip_status_monit_info.inst_addr is '装机地址';
comment on column ${idl_schema}.base_d_equip_status_monit_info.mang_way is '经营方式';
comment on column ${idl_schema}.base_d_equip_status_monit_info.in_bank_out_bank_flg is '在行离行标志';
comment on column ${idl_schema}.base_d_equip_status_monit_info.dev_addr is 'ip地址';
comment on column ${idl_schema}.base_d_equip_status_monit_info.self_equip_type is '自助设备类型';
comment on column ${idl_schema}.base_d_equip_status_monit_info.self_equip_type_name is '自助设备类型名称';
comment on column ${idl_schema}.base_d_equip_status_monit_info.equip_mger_member is '设备管理人员';
comment on column ${idl_schema}.base_d_equip_status_monit_info.equip_oper_status is '设备运营状态';
comment on column ${idl_schema}.base_d_equip_status_monit_info.last_update_tm is '上次更新时间';
comment on column ${idl_schema}.base_d_equip_status_monit_info.equip_status is '设备状态';
comment on column ${idl_schema}.base_d_equip_status_monit_info.denom is '分母';
comment on column ${idl_schema}.base_d_equip_status_monit_info.matn_stop_duran is '维护停机时长';
comment on column ${idl_schema}.base_d_equip_status_monit_info.fault_stop_duran is '故障停机时长';
comment on column ${idl_schema}.base_d_equip_status_monit_info.offline_stop_duran is '离线停机时长';
comment on column ${idl_schema}.base_d_equip_status_monit_info.fault_tot_cnt is '故障总次数';
comment on column ${idl_schema}.base_d_equip_status_monit_info.fault_tot_tm is '故障总时间';
comment on column ${idl_schema}.base_d_equip_status_monit_info.qz_duran is '缺纸时长';
comment on column ${idl_schema}.base_d_equip_status_monit_info.qz_cnt is '缺纸次数';
comment on column ${idl_schema}.base_d_equip_status_monit_info.qc_duran is '缺钞时长';
comment on column ${idl_schema}.base_d_equip_status_monit_info.qc_cnt is '缺钞次数';
comment on column ${idl_schema}.base_d_equip_status_monit_info.cm_duran is '钞满时长';
comment on column ${idl_schema}.base_d_equip_status_monit_info.cm_cnt is '钞满次数';
comment on column ${idl_schema}.base_d_equip_status_monit_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.base_d_equip_status_monit_info.etl_timestamp is 'ETL处理时间戳';