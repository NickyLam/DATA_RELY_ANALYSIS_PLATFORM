/*
Purpose:    技术缓冲层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py msl msl_edw_cmm_self_equip_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${msl_schema}.msl_edw_cmm_self_equip_info
whenever sqlerror continue none;
drop table ${msl_schema}.msl_edw_cmm_self_equip_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${msl_schema}.msl_edw_cmm_self_equip_info(
    etl_dt date
    ,lp_id varchar2(60)
    ,equip_id varchar2(60)
    ,equip_ip_addr_id varchar2(60)
    ,belong_org_id varchar2(60)
    ,in_bank_flg varchar2(10)
    ,self_equip_model varchar2(60)
    ,self_equip_type_cd varchar2(10)
    ,equip_type_name varchar2(100)
    ,equip_type_name_cn_descb varchar2(100)
    ,equip_status_cd varchar2(10)
    ,equip_matnce_id varchar2(60)
    ,equip_install_dt date
    ,cash_flg varchar2(10)
    ,install_way_cd varchar2(10)
    ,dist_cd varchar2(20)
    ,chn_id varchar2(60)
    ,equip_install_addr varchar2(500)
    ,equip_kind_name varchar2(60)
)
storage (initial 1024k next 1024k)
compress nologging
;

-- grant
grant select on ${msl_schema}.msl_edw_cmm_self_equip_info to ${itl_schema};

-- comment
comment on table ${msl_schema}.msl_edw_cmm_self_equip_info is '自助设备信息';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.etl_dt is 'ETL处理日期';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.lp_id is '法人编号';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.equip_id is '设备编号';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.equip_ip_addr_id is '设备IP地址编号';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.belong_org_id is '所属机构编号';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.in_bank_flg is '在行标志';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.self_equip_model is '自助设备型号';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.self_equip_type_cd is '自助设备类型代码';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.equip_type_name is '设备类型名称';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.equip_type_name_cn_descb is '设备类型名称中文描述';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.equip_status_cd is '设备状态代码';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.equip_matnce_id is '设备维护商编号';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.equip_install_dt is '设备安装日期';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.cash_flg is '现金标志';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.install_way_cd is '安装方式代码';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.dist_cd is '行政区划代码';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.chn_id is '渠道编号';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.equip_install_addr is '设备安装地址';
comment on column ${msl_schema}.msl_edw_cmm_self_equip_info.equip_kind_name is '设备种类名称';
