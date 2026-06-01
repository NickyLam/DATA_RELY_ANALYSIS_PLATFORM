/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml chn_termn_equip_basic_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.chn_termn_equip_basic_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.chn_termn_equip_basic_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_termn_equip_basic_info_h(
    equip_id varchar2(60) -- 设备编号
    ,lp_id varchar2(60) -- 法人编号
    ,chn_id varchar2(60) -- 直联终端编号
    ,term_id varchar2(100) -- 终端编号
    ,termn_id varchar2(90) -- 设备IP
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,in_bank_flg varchar2(10) -- 在行标志
    ,equip_type_cd varchar2(10) -- 设备类型代码
    ,equip_type_name varchar2(150) -- 设备类型名称
    ,equip_model varchar2(60) -- 设备型号
    ,equip_status_cd varchar2(10) -- 设备状态代码
    ,equip_matnce_id varchar2(60) -- 设备维护商编号
    ,equip_install_dt date -- 设备安装日期
    ,cash_flg varchar2(10) -- 现金标志
    ,install_way_cd varchar2(10) -- 安装方式代码
    ,dist_cd varchar2(20) -- 行政区划代码
    ,equip_ser_num varchar2(100) -- 设备序列号
    ,equip_addr varchar2(750) -- 设备地址
    ,termn_status_cd varchar2(30) -- 终端状态代码
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (end_dt)
(
   partition p_default values ('default')
   (
         subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
         ,subpartition p_default_20991231 values (to_date('20991231','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.chn_termn_equip_basic_info_h to ${icl_schema};
grant select on ${iml_schema}.chn_termn_equip_basic_info_h to ${idl_schema};
grant select on ${iml_schema}.chn_termn_equip_basic_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.chn_termn_equip_basic_info_h is '设备基本信息历史';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.equip_id is '设备编号';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.chn_id is '直联终端编号';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.term_id is '终端编号';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.termn_id is '设备IP';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.in_bank_flg is '在行标志';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.equip_type_cd is '设备类型代码';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.equip_type_name is '设备类型名称';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.equip_model is '设备型号';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.equip_status_cd is '设备状态代码';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.equip_matnce_id is '设备维护商编号';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.equip_install_dt is '设备安装日期';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.cash_flg is '现金标志';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.install_way_cd is '安装方式代码';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.dist_cd is '行政区划代码';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.equip_ser_num is '设备序列号';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.equip_addr is '设备地址';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.termn_status_cd is '终端状态代码';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.chn_termn_equip_basic_info_h.etl_timestamp is 'ETL处理时间戳';
