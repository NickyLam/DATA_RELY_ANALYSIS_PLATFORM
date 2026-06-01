/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml chn_equip_info_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.chn_equip_info_h
whenever sqlerror continue none;
drop table ${iml_schema}.chn_equip_info_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.chn_equip_info_h(
    equip_id varchar2(100) -- 设备编号
    ,lp_id varchar2(100) -- 法人编号
    ,equip_model varchar2(100) -- 设备型号
    ,equip_type_cd varchar2(100) -- 设备类型代码
    ,equip_status_cd varchar2(30) -- 设备状态代码
    ,equip_use_status_cd varchar2(30) -- 设备使用状态代码
    ,in_bank_flg varchar2(10) -- 在行标志
    ,install_way_cd varchar2(30) -- 安装方式代码
    ,inst_phone varchar2(60) -- 安装联系电话
    ,equip_manuf_name varchar2(500) -- 设备厂商名称
    ,equip_addr varchar2(500) -- 设备地址
    ,equip_ip varchar2(100) -- 设备IP
    ,matn_start_dt date -- 维保开始日期
    ,matn_end_dt date -- 维保结束日期
    ,equip_buy_dt date -- 设备购买日期
    ,equip_start_use_dt date -- 设备启用日期
    ,equip_stop_dt date -- 设备停止日期
    ,self_h_bank_flg varchar2(10) -- 自助银行标志
    ,comm_status_flg varchar2(30) -- 通讯状态正常标志
    ,move_status_cd varchar2(30) -- 运行状态代码
    ,clean_corp_id varchar2(100) -- 清机公司编号
    ,clean_corp_name varchar2(500) -- 清机公司名称
    ,atm_clean_appl_bind_teller_id varchar2(100) -- ATM清机申请绑定柜员编号
    ,outsourc_mgmt_flg varchar2(10) -- 外包管理标志
    ,midgrod_inst_code varchar2(500) -- 中台装机码
    ,midgrod_sync_flg varchar2(10) -- 中台同步标志
    ,vtual_teller_id varchar2(100) -- 虚拟柜员编号
    ,belong_org_id varchar2(100) -- 所属机构编号
    ,fir_create_dt date -- 首次创建日期
    ,fir_create_teller_id varchar2(100) -- 首次创建柜员编号
    ,fir_creator_belong_org_id varchar2(100) -- 首次创建人所属机构编号
    ,matn_ps_belong_org_cd varchar2(30) -- 维护人所属机构代码
    ,final_modif_dt date -- 最后修改日期
    ,final_modif_teller_id varchar2(100) -- 最后修改柜员编号
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
grant select on ${iml_schema}.chn_equip_info_h to ${icl_schema};
grant select on ${iml_schema}.chn_equip_info_h to ${idl_schema};
grant select on ${iml_schema}.chn_equip_info_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.chn_equip_info_h is '设备信息历史';
comment on column ${iml_schema}.chn_equip_info_h.equip_id is '设备编号';
comment on column ${iml_schema}.chn_equip_info_h.lp_id is '法人编号';
comment on column ${iml_schema}.chn_equip_info_h.equip_model is '设备型号';
comment on column ${iml_schema}.chn_equip_info_h.equip_type_cd is '设备类型代码';
comment on column ${iml_schema}.chn_equip_info_h.equip_status_cd is '设备状态代码';
comment on column ${iml_schema}.chn_equip_info_h.equip_use_status_cd is '设备使用状态代码';
comment on column ${iml_schema}.chn_equip_info_h.in_bank_flg is '在行标志';
comment on column ${iml_schema}.chn_equip_info_h.install_way_cd is '安装方式代码';
comment on column ${iml_schema}.chn_equip_info_h.inst_phone is '安装联系电话';
comment on column ${iml_schema}.chn_equip_info_h.equip_manuf_name is '设备厂商名称';
comment on column ${iml_schema}.chn_equip_info_h.equip_addr is '设备地址';
comment on column ${iml_schema}.chn_equip_info_h.equip_ip is '设备IP';
comment on column ${iml_schema}.chn_equip_info_h.matn_start_dt is '维保开始日期';
comment on column ${iml_schema}.chn_equip_info_h.matn_end_dt is '维保结束日期';
comment on column ${iml_schema}.chn_equip_info_h.equip_buy_dt is '设备购买日期';
comment on column ${iml_schema}.chn_equip_info_h.equip_start_use_dt is '设备启用日期';
comment on column ${iml_schema}.chn_equip_info_h.equip_stop_dt is '设备停止日期';
comment on column ${iml_schema}.chn_equip_info_h.self_h_bank_flg is '自助银行标志';
comment on column ${iml_schema}.chn_equip_info_h.comm_status_flg is '通讯状态正常标志';
comment on column ${iml_schema}.chn_equip_info_h.move_status_cd is '运行状态代码';
comment on column ${iml_schema}.chn_equip_info_h.clean_corp_id is '清机公司编号';
comment on column ${iml_schema}.chn_equip_info_h.clean_corp_name is '清机公司名称';
comment on column ${iml_schema}.chn_equip_info_h.atm_clean_appl_bind_teller_id is 'ATM清机申请绑定柜员编号';
comment on column ${iml_schema}.chn_equip_info_h.outsourc_mgmt_flg is '外包管理标志';
comment on column ${iml_schema}.chn_equip_info_h.midgrod_inst_code is '中台装机码';
comment on column ${iml_schema}.chn_equip_info_h.midgrod_sync_flg is '中台同步标志';
comment on column ${iml_schema}.chn_equip_info_h.vtual_teller_id is '虚拟柜员编号';
comment on column ${iml_schema}.chn_equip_info_h.belong_org_id is '所属机构编号';
comment on column ${iml_schema}.chn_equip_info_h.fir_create_dt is '首次创建日期';
comment on column ${iml_schema}.chn_equip_info_h.fir_create_teller_id is '首次创建柜员编号';
comment on column ${iml_schema}.chn_equip_info_h.fir_creator_belong_org_id is '首次创建人所属机构编号';
comment on column ${iml_schema}.chn_equip_info_h.matn_ps_belong_org_cd is '维护人所属机构代码';
comment on column ${iml_schema}.chn_equip_info_h.final_modif_dt is '最后修改日期';
comment on column ${iml_schema}.chn_equip_info_h.final_modif_teller_id is '最后修改柜员编号';
comment on column ${iml_schema}.chn_equip_info_h.start_dt is '开始时间';
comment on column ${iml_schema}.chn_equip_info_h.end_dt is '结束时间';
comment on column ${iml_schema}.chn_equip_info_h.id_mark is '增删标志';
comment on column ${iml_schema}.chn_equip_info_h.src_table_name is '源表名称';
comment on column ${iml_schema}.chn_equip_info_h.job_cd is '任务编码';
comment on column ${iml_schema}.chn_equip_info_h.etl_timestamp is 'ETL处理时间戳';
