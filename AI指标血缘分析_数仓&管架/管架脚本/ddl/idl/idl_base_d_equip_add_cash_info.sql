/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl base_d_equip_add_cash_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.base_d_equip_add_cash_info
whenever sqlerror continue none;
drop table ${idl_schema}.base_d_equip_add_cash_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.base_d_equip_add_cash_info(
    add_cash_ind_no varchar2(20) -- 加钞标识号
    ,add_cash_dt varchar2(20) -- 加钞日期
    ,equip_belong_org_code varchar2(20) -- 设备所属机构编码
    ,equip_id varchar2(20) -- 设备编号
    ,inst_addr varchar2(2000) -- 装机地址
    ,self_equip_type varchar2(20) -- 自助设备类型
    ,self_equip_type_name varchar2(20) -- 自助设备类型名称
    ,equip_mger_member varchar2(200) -- 设备管理人员
    ,in_bank_out_bank_idf varchar2(10) -- 在行离行标识
    ,equip_oper_status varchar2(20) -- 设备运营状态
    ,equip_status varchar2(20) -- 设备状态
    ,cash_start_tm date -- 清机开始时间
    ,cash_end_tm date -- 清机结束时间
    ,cash_duran number(16,2) -- 清机时长
    ,bf_minor_add_cash_amt number(38,8) -- 前次加钞金额
    ,draw_amt number(38,8) -- 取款金额
    ,dep_amt number(38,8) -- 存款金额
    ,surp_amt number(38,8) -- 剩余金额
    ,callbk_cnt number(16,2) -- 回收张数
    ,ths_tm_add_cash_tot number(38,8) -- 本次加钞总额
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
grant select on ${idl_schema}.base_d_equip_add_cash_info to ${iel_schema};

-- comment
comment on table ${idl_schema}.base_d_equip_add_cash_info is '设备清机加钞信息表';
comment on column ${idl_schema}.base_d_equip_add_cash_info.add_cash_ind_no is '加钞标识号';
comment on column ${idl_schema}.base_d_equip_add_cash_info.add_cash_dt is '加钞日期';
comment on column ${idl_schema}.base_d_equip_add_cash_info.equip_belong_org_code is '设备所属机构编码';
comment on column ${idl_schema}.base_d_equip_add_cash_info.equip_id is '设备编号';
comment on column ${idl_schema}.base_d_equip_add_cash_info.inst_addr is '装机地址';
comment on column ${idl_schema}.base_d_equip_add_cash_info.self_equip_type is '自助设备类型';
comment on column ${idl_schema}.base_d_equip_add_cash_info.self_equip_type_name is '自助设备类型名称';
comment on column ${idl_schema}.base_d_equip_add_cash_info.equip_mger_member is '设备管理人员';
comment on column ${idl_schema}.base_d_equip_add_cash_info.in_bank_out_bank_idf is '在行离行标识';
comment on column ${idl_schema}.base_d_equip_add_cash_info.equip_oper_status is '设备运营状态';
comment on column ${idl_schema}.base_d_equip_add_cash_info.equip_status is '设备状态';
comment on column ${idl_schema}.base_d_equip_add_cash_info.cash_start_tm is '清机开始时间';
comment on column ${idl_schema}.base_d_equip_add_cash_info.cash_end_tm is '清机结束时间';
comment on column ${idl_schema}.base_d_equip_add_cash_info.cash_duran is '清机时长';
comment on column ${idl_schema}.base_d_equip_add_cash_info.bf_minor_add_cash_amt is '前次加钞金额';
comment on column ${idl_schema}.base_d_equip_add_cash_info.draw_amt is '取款金额';
comment on column ${idl_schema}.base_d_equip_add_cash_info.dep_amt is '存款金额';
comment on column ${idl_schema}.base_d_equip_add_cash_info.surp_amt is '剩余金额';
comment on column ${idl_schema}.base_d_equip_add_cash_info.callbk_cnt is '回收张数';
comment on column ${idl_schema}.base_d_equip_add_cash_info.ths_tm_add_cash_tot is '本次加钞总额';
comment on column ${idl_schema}.base_d_equip_add_cash_info.etl_dt is 'ETL处理日期';
comment on column ${idl_schema}.base_d_equip_add_cash_info.etl_timestamp is 'ETL处理时间戳';