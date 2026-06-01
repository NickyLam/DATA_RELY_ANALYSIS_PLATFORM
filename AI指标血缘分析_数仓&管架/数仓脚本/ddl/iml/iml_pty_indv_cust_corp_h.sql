/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_indv_cust_corp_h
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_indv_cust_corp_h
whenever sqlerror continue none;
drop table ${iml_schema}.pty_indv_cust_corp_h purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_indv_cust_corp_h(
    cust_id varchar2(100) -- 客户编号
    ,lp_id varchar2(100) -- 法人编号
    ,cust_name varchar2(1000) -- 客户名称
    ,cert_type_cd varchar2(10) -- 证件类型代码
    ,cert_no varchar2(100) -- 证件号码
    ,cust_corp_rela_cd varchar2(30) -- 借款人与企业关系代码
    ,corp_cust_id varchar2(100) -- 企业客户编号
    ,corp_name varchar2(375) -- 企业名称
    ,corp_cert_type_cd varchar2(30) -- 企业证件类型代码
    ,corp_cert_no varchar2(60) -- 企业证件号码
    ,corp_cert_exp_dt date -- 企业证件到期日期
    ,corp_mang_addr varchar2(1000) -- 企业经营地址
    ,corp_found_dt date -- 企业成立日期
    ,corp_size_cd varchar2(30) -- 企业规模代码
    ,legal_rep_name varchar2(500) -- 法定代表人
    ,emply_number number(10) -- 职工人数
    ,bus_anl_inco number(30,8) -- 营业年收入
    ,tot_asset number(30,8) -- 总资产
    ,bl_induty_type_cd varchar2(30) -- 所属行业类型代码
    ,bl_induty_name varchar2(1000) -- 所属行业名称
    ,create_teller_id varchar2(100) -- 创建柜员编号
    ,create_org_id varchar2(100) -- 创建机构编号
    ,init_create_dt date -- 最初创建日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_org_id varchar2(100) -- 更新机构编号
    ,update_chn_id varchar2(30) -- 更新渠道编号
    ,update_sys_name varchar2(500) -- 更新系统名称
    ,latest_update_dt date -- 最新更新日期
    ,sorc_sys_name varchar2(100) -- 源系统名称
    ,sorc_sys_chn_id varchar2(30) -- 源系统渠道编号
    ,sorc_sys_create_dt date -- 源系统创建日期
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
grant select on ${iml_schema}.pty_indv_cust_corp_h to ${icl_schema};
grant select on ${iml_schema}.pty_indv_cust_corp_h to ${idl_schema};
grant select on ${iml_schema}.pty_indv_cust_corp_h to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_indv_cust_corp_h is '个人客户经营实体历史';
comment on column ${iml_schema}.pty_indv_cust_corp_h.cust_id is '客户编号';
comment on column ${iml_schema}.pty_indv_cust_corp_h.lp_id is '法人编号';
comment on column ${iml_schema}.pty_indv_cust_corp_h.cust_name is '客户名称';
comment on column ${iml_schema}.pty_indv_cust_corp_h.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_indv_cust_corp_h.cert_no is '证件号码';
comment on column ${iml_schema}.pty_indv_cust_corp_h.cust_corp_rela_cd is '借款人与企业关系代码';
comment on column ${iml_schema}.pty_indv_cust_corp_h.corp_cust_id is '企业客户编号';
comment on column ${iml_schema}.pty_indv_cust_corp_h.corp_name is '企业名称';
comment on column ${iml_schema}.pty_indv_cust_corp_h.corp_cert_type_cd is '企业证件类型代码';
comment on column ${iml_schema}.pty_indv_cust_corp_h.corp_cert_no is '企业证件号码';
comment on column ${iml_schema}.pty_indv_cust_corp_h.corp_cert_exp_dt is '企业证件到期日期';
comment on column ${iml_schema}.pty_indv_cust_corp_h.corp_mang_addr is '企业经营地址';
comment on column ${iml_schema}.pty_indv_cust_corp_h.corp_found_dt is '企业成立日期';
comment on column ${iml_schema}.pty_indv_cust_corp_h.corp_size_cd is '企业规模代码';
comment on column ${iml_schema}.pty_indv_cust_corp_h.legal_rep_name is '法定代表人';
comment on column ${iml_schema}.pty_indv_cust_corp_h.emply_number is '职工人数';
comment on column ${iml_schema}.pty_indv_cust_corp_h.bus_anl_inco is '营业年收入';
comment on column ${iml_schema}.pty_indv_cust_corp_h.tot_asset is '总资产';
comment on column ${iml_schema}.pty_indv_cust_corp_h.bl_induty_type_cd is '所属行业类型代码';
comment on column ${iml_schema}.pty_indv_cust_corp_h.bl_induty_name is '所属行业名称';
comment on column ${iml_schema}.pty_indv_cust_corp_h.create_teller_id is '创建柜员编号';
comment on column ${iml_schema}.pty_indv_cust_corp_h.create_org_id is '创建机构编号';
comment on column ${iml_schema}.pty_indv_cust_corp_h.init_create_dt is '最初创建日期';
comment on column ${iml_schema}.pty_indv_cust_corp_h.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.pty_indv_cust_corp_h.update_org_id is '更新机构编号';
comment on column ${iml_schema}.pty_indv_cust_corp_h.update_chn_id is '更新渠道编号';
comment on column ${iml_schema}.pty_indv_cust_corp_h.update_sys_name is '更新系统名称';
comment on column ${iml_schema}.pty_indv_cust_corp_h.latest_update_dt is '最新更新日期';
comment on column ${iml_schema}.pty_indv_cust_corp_h.sorc_sys_name is '源系统名称';
comment on column ${iml_schema}.pty_indv_cust_corp_h.sorc_sys_chn_id is '源系统渠道编号';
comment on column ${iml_schema}.pty_indv_cust_corp_h.sorc_sys_create_dt is '源系统创建日期';
comment on column ${iml_schema}.pty_indv_cust_corp_h.start_dt is '开始时间';
comment on column ${iml_schema}.pty_indv_cust_corp_h.end_dt is '结束时间';
comment on column ${iml_schema}.pty_indv_cust_corp_h.id_mark is '增删标志';
comment on column ${iml_schema}.pty_indv_cust_corp_h.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_indv_cust_corp_h.job_cd is '任务编码';
comment on column ${iml_schema}.pty_indv_cust_corp_h.etl_timestamp is 'ETL处理时间戳';
