/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py itl itl_edw_cmm_self_equip_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${itl_schema}.itl_edw_cmm_self_equip_info
whenever sqlerror continue none;
drop table ${itl_schema}.itl_edw_cmm_self_equip_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${itl_schema}.itl_edw_cmm_self_equip_info(
    lp_id varchar2(60) -- 法人编号
    ,equip_id varchar2(60) -- 设备编号
    ,equip_ip_addr_id varchar2(60) -- 设备IP地址编号
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,in_bank_flg varchar2(10) -- 在行标志
    ,self_equip_model varchar2(60) -- 自助设备型号
    ,self_equip_type_cd varchar2(10) -- 自助设备类型代码
    ,equip_type_name varchar2(100) -- 设备类型名称
    ,equip_type_name_cn_descb varchar2(100) -- 设备类型名称中文描述
    ,equip_status_cd varchar2(10) -- 设备状态代码
    ,equip_matnce_id varchar2(60) -- 设备维护商编号
    ,equip_install_dt date -- 设备安装日期
    ,cash_flg varchar2(10) -- 现金标志
    ,install_way_cd varchar2(10) -- 安装方式代码
    ,dist_cd varchar2(20) -- 行政区划代码
    ,chn_id varchar2(60) -- 渠道编号
    ,equip_install_addr varchar2(500) -- 设备安装地址
    ,equip_kind_name varchar2(60) -- 设备种类名称
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
grant select on ${itl_schema}.itl_edw_cmm_self_equip_info to ${iol_schema};

-- comment
comment on table ${itl_schema}.itl_edw_cmm_self_equip_info is '自助设备信息';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.lp_id is '法人编号';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.equip_id is '设备编号';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.equip_ip_addr_id is '设备IP地址编号';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.belong_org_id is '所属机构编号';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.in_bank_flg is '在行标志';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.self_equip_model is '自助设备型号';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.self_equip_type_cd is '自助设备类型代码';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.equip_type_name is '设备类型名称';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.equip_type_name_cn_descb is '设备类型名称中文描述';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.equip_status_cd is '设备状态代码';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.equip_matnce_id is '设备维护商编号';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.equip_install_dt is '设备安装日期';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.cash_flg is '现金标志';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.install_way_cd is '安装方式代码';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.dist_cd is '行政区划代码';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.chn_id is '渠道编号';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.equip_install_addr is '设备安装地址';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.equip_kind_name is '设备种类名称';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.etl_dt is 'ETL处理日期';
comment on column ${itl_schema}.itl_edw_cmm_self_equip_info.etl_timestamp is 'ETL处理时间戳';
