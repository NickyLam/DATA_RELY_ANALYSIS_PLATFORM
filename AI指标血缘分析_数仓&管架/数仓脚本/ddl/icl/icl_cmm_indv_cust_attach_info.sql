/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_indv_cust_attach_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_indv_cust_attach_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_indv_cust_attach_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_indv_cust_attach_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,cust_id varchar2(60) -- 客户编号
    ,cust_type_cd varchar2(20) -- 客户类型代码
    ,cust_name varchar2(250) -- 客户名称
	,move_num varchar2(100) -- 电话号码
	,work_tel_num varchar2(100) --单位电话号码
    ,family_farm_flg varchar2(10) -- 家庭农场标志
    ,mls_acct_flg varchar2(10) -- 低保户标志
    ,disb_ps_flg varchar2(10) -- 残疾人标志
	,ex_servsm_flg varchar2(10) -- 退役军人标志
    ,no_buslics_prc_flg varchar2(10) -- 无营业执照负责人标志
    ,sm_bus_owner_cert_type varchar2(100) -- 小微企业主证件类型
    ,sm_bus_owner_cert_no varchar2(100) -- 小微企业主证件号码
    ,indv_bus_cert_type varchar2(100) -- 个体工商户证件类型
    ,indv_bus_cert_no varchar2(100) -- 个体工商户证件号码
    ,inco_curr varchar2(30) -- 收入币种
    ,crdt_cust_flg_cd varchar2(10) -- 信贷客户标识代码
    ,crdt_cust_type_cd varchar2(30) -- 信贷客户类型代码
    ,cross_bor_cust_flg varchar2(10) -- 跨境电商客户标志
    ,mang_enty_bl_induty_type_cd varchar2(30) -- 经营实体所属行业类型代码
    ,latest_update_teller_id varchar2(60) -- 最新更新柜员编号
    ,latest_update_org_id varchar2(60) -- 最新更新机构编号
    ,latest_update_chn_cd varchar2(30) -- 最新更新渠道代码
    ,latest_update_tm timestamp(6) -- 最新更新时间
    ,job_cd varchar2(10) -- 任务代码
    ,etl_timestamp timestamp -- 数据处理时间
 --   ,etl_dt date -- ETL处理日期
   -- ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${icl_schema}.cmm_indv_cust_attach_info to ${idl_schema};
grant select on ${icl_schema}.cmm_indv_cust_attach_info to ${iel_schema};
grant select on ${icl_schema}.cmm_indv_cust_attach_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_indv_cust_attach_info is '个人客户补充信息';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.cust_id is '客户编号';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.cust_type_cd is '客户类型代码';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.cust_name is '客户名称';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.move_num is '电话号码';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.work_tel_num is '单位电话号码';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.family_farm_flg is '家庭农场标志';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.mls_acct_flg is '低保户标志';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.disb_ps_flg is '残疾人标志';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.ex_servsm_flg is '退役军人标志';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.no_buslics_prc_flg is '无营业执照负责人标志';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.sm_bus_owner_cert_type is '小微企业主证件类型';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.sm_bus_owner_cert_no is '小微企业主证件号码';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.indv_bus_cert_type is '个体工商户证件类型';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.indv_bus_cert_no is '个体工商户证件号码';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.inco_curr is '收入币种';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.crdt_cust_flg_cd is '信贷客户标识代码';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.crdt_cust_type_cd is '信贷客户类型代码';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.cross_bor_cust_flg is '跨境电商客户标志';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.mang_enty_bl_induty_type_cd is '经营实体所属行业类型代码';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.latest_update_teller_id is '最新更新柜员编号';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.latest_update_org_id is '最新更新机构编号';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.latest_update_chn_cd is '最新更新渠道代码';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.latest_update_tm is '最新更新时间';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_indv_cust_attach_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_indv_cust_attach_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_indv_cust_attach_info.etl_timestamp is 'ETL处理时间戳';
