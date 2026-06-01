/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol eifs_t01_corp_group_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.eifs_t01_corp_group_info
whenever sqlerror continue none;
drop table ${iol_schema}.eifs_t01_corp_group_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t01_corp_group_info(
    group_id varchar2(45) -- 群体id
    ,group_num varchar2(45) -- 集团编号
    ,group_name varchar2(300) -- 集团名称
    ,group_short_name varchar2(150) -- 集团简称
    ,group_en_name varchar2(150) -- 集团英文名称
    ,phys_addr_cty_zone_cd varchar2(30) -- 国家和地区
    ,group_work_addr_dist_cd varchar2(30) -- 集团办公地行政区划
    ,group_dom_work_addr varchar2(600) -- 集团国内办公地址
    ,trade_group_ind varchar2(2) -- 同业集团标志
    ,group_mem_cnt number(22,0) -- 集团成员数
    ,group_risk_warn_info_cd varchar2(5) -- 集团风险预警信号
    ,group_status varchar2(15) -- 集团状态
    ,tax_pay_ctzn_idnt varchar2(11) -- 税收居民身份
    ,prnt_cust_no varchar2(24) -- 母公司客户号
    ,tax_org_type varchar2(5) -- 税收机构类别
    ,cust_mgr_name varchar2(300) -- 客户经理姓名
    ,cust_mgr_num varchar2(12) -- 客户经理编号
    ,create_te varchar2(12) -- 创建柜员
    ,create_org varchar2(15) -- 创建机构号
    ,init_system_id varchar2(15) -- 创建渠道
    ,init_created_ts timestamp -- 源系统创建时间
    ,created_ts timestamp -- 进入ecif的时间
    ,updated_ts timestamp -- 在ecif中失效的时间
    ,last_updated_te varchar2(45) -- 最新更新柜员
    ,last_updated_org varchar2(30) -- 最新更新机构号
    ,last_system_id varchar2(15) -- 最新更新渠道
    ,last_updated_ts timestamp -- 最新更新时间
    ,grp_typ varchar2(3) -- 
    ,wthr_ghb_assoc_txn varchar2(2) -- 
    ,fst_busi varchar2(11) -- 
    ,pri_major_main_biz_bus_pct varchar2(90) -- 
    ,scd_busi varchar2(11) -- 
    ,scd_major_main_biz_bus_pct varchar2(90) -- 
    ,third_busi varchar2(11) -- 
    ,third_major_main_biz_bus_pct varchar2(90) -- 
    ,actl_ctrl_cnt varchar2(90) -- 
    ,main_cntri_cnt varchar2(90) -- 
    ,upd_offic_loc_date timestamp -- 
    ,src_sys_num varchar2(45) -- 来源系统编号
    ,last_updated_src_sys_num varchar2(45) -- 最新更新源系统编号
    ,actl_ctrl_cert_num varchar2(90) -- 实际控制人证件代码
    ,actl_ctrl_iden_typ varchar2(6) -- 实际控制人证件类型
    ,actl_ctrl_name varchar2(300) -- 实际控制人名称
    ,actl_ctrl_nation_cd varchar2(30) -- 实际控制人国别
    ,base_group_cust_no varchar2(30) -- 总分行认定集团客户
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
grant select on ${iol_schema}.eifs_t01_corp_group_info to ${iml_schema};
grant select on ${iol_schema}.eifs_t01_corp_group_info to ${icl_schema};
grant select on ${iol_schema}.eifs_t01_corp_group_info to ${idl_schema};
grant select on ${iol_schema}.eifs_t01_corp_group_info to ${iel_schema};

-- comment
comment on table ${iol_schema}.eifs_t01_corp_group_info is '集团客户基本信息';
comment on column ${iol_schema}.eifs_t01_corp_group_info.group_id is '群体id';
comment on column ${iol_schema}.eifs_t01_corp_group_info.group_num is '集团编号';
comment on column ${iol_schema}.eifs_t01_corp_group_info.group_name is '集团名称';
comment on column ${iol_schema}.eifs_t01_corp_group_info.group_short_name is '集团简称';
comment on column ${iol_schema}.eifs_t01_corp_group_info.group_en_name is '集团英文名称';
comment on column ${iol_schema}.eifs_t01_corp_group_info.phys_addr_cty_zone_cd is '国家和地区';
comment on column ${iol_schema}.eifs_t01_corp_group_info.group_work_addr_dist_cd is '集团办公地行政区划';
comment on column ${iol_schema}.eifs_t01_corp_group_info.group_dom_work_addr is '集团国内办公地址';
comment on column ${iol_schema}.eifs_t01_corp_group_info.trade_group_ind is '同业集团标志';
comment on column ${iol_schema}.eifs_t01_corp_group_info.group_mem_cnt is '集团成员数';
comment on column ${iol_schema}.eifs_t01_corp_group_info.group_risk_warn_info_cd is '集团风险预警信号';
comment on column ${iol_schema}.eifs_t01_corp_group_info.group_status is '集团状态';
comment on column ${iol_schema}.eifs_t01_corp_group_info.tax_pay_ctzn_idnt is '税收居民身份';
comment on column ${iol_schema}.eifs_t01_corp_group_info.prnt_cust_no is '母公司客户号';
comment on column ${iol_schema}.eifs_t01_corp_group_info.tax_org_type is '税收机构类别';
comment on column ${iol_schema}.eifs_t01_corp_group_info.cust_mgr_name is '客户经理姓名';
comment on column ${iol_schema}.eifs_t01_corp_group_info.cust_mgr_num is '客户经理编号';
comment on column ${iol_schema}.eifs_t01_corp_group_info.create_te is '创建柜员';
comment on column ${iol_schema}.eifs_t01_corp_group_info.create_org is '创建机构号';
comment on column ${iol_schema}.eifs_t01_corp_group_info.init_system_id is '创建渠道';
comment on column ${iol_schema}.eifs_t01_corp_group_info.init_created_ts is '源系统创建时间';
comment on column ${iol_schema}.eifs_t01_corp_group_info.created_ts is '进入ecif的时间';
comment on column ${iol_schema}.eifs_t01_corp_group_info.updated_ts is '在ecif中失效的时间';
comment on column ${iol_schema}.eifs_t01_corp_group_info.last_updated_te is '最新更新柜员';
comment on column ${iol_schema}.eifs_t01_corp_group_info.last_updated_org is '最新更新机构号';
comment on column ${iol_schema}.eifs_t01_corp_group_info.last_system_id is '最新更新渠道';
comment on column ${iol_schema}.eifs_t01_corp_group_info.last_updated_ts is '最新更新时间';
comment on column ${iol_schema}.eifs_t01_corp_group_info.grp_typ is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.wthr_ghb_assoc_txn is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.fst_busi is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.pri_major_main_biz_bus_pct is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.scd_busi is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.scd_major_main_biz_bus_pct is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.third_busi is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.third_major_main_biz_bus_pct is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.actl_ctrl_cnt is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.main_cntri_cnt is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.upd_offic_loc_date is '';
comment on column ${iol_schema}.eifs_t01_corp_group_info.src_sys_num is '来源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_group_info.last_updated_src_sys_num is '最新更新源系统编号';
comment on column ${iol_schema}.eifs_t01_corp_group_info.actl_ctrl_cert_num is '实际控制人证件代码';
comment on column ${iol_schema}.eifs_t01_corp_group_info.actl_ctrl_iden_typ is '实际控制人证件类型';
comment on column ${iol_schema}.eifs_t01_corp_group_info.actl_ctrl_name is '实际控制人名称';
comment on column ${iol_schema}.eifs_t01_corp_group_info.actl_ctrl_nation_cd is '实际控制人国别';
comment on column ${iol_schema}.eifs_t01_corp_group_info.base_group_cust_no is '总分行认定集团客户';
comment on column ${iol_schema}.eifs_t01_corp_group_info.start_dt is '开始时间';
comment on column ${iol_schema}.eifs_t01_corp_group_info.end_dt is '结束时间';
comment on column ${iol_schema}.eifs_t01_corp_group_info.id_mark is '增删标志';
comment on column ${iol_schema}.eifs_t01_corp_group_info.etl_timestamp is 'ETL处理时间戳';
