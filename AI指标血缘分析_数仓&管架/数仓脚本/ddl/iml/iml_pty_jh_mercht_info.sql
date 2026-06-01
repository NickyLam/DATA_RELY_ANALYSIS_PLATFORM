/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_jh_mercht_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_jh_mercht_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_jh_mercht_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_jh_mercht_info(
    mercht_id varchar2(60) -- 商户编号
    ,lp_id varchar2(60) -- 法人编号
    ,agency_id varchar2(60) -- 代理商编号
    ,mercht_cn_name varchar2(375) -- 商户中文名称
    ,mercht_cn_abbr varchar2(150) -- 商户中文简称
    ,mercht_sign_dt date -- 商户签约日期
    ,mercht_revo_dt date -- 商户撤销日期
    ,cert_type_cd varchar2(60) -- 证件类型代码
    ,cert_no varchar2(60) -- 证件号码
    ,cert_invalid_dt date -- 证件失效日期
    ,mercht_tel_num varchar2(60) -- 商户电话号码
    ,elec_addr varchar2(750) -- 电子地址
    ,cotas_name varchar2(150) -- 联系人名称
    ,cotas_type_cd varchar2(30) -- 联系人类型代码
    ,cotas_cert_no varchar2(60) -- 联系人证件号码
    ,cotas_tel_num varchar2(60) -- 联系人电话号码
    ,cotas_addr varchar2(750) -- 联系人地址
    ,lp_name varchar2(150) -- 法人名称
    ,lp_cert_no varchar2(60) -- 法人证件号码
    ,lp_phone varchar2(90) -- 法人联系电话
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,cust_mgr_name varchar2(150) -- 客户经理姓名
    ,check_status_cd varchar2(30) -- 审核状态代码
    ,risk_lev_cd varchar2(30) -- 风险级别代码
    ,appl_dt date -- 申请日期
    ,start_use_dt date -- 启用日期
    ,org_id varchar2(60) -- 机构编号
    ,mercht_local_prov_cd varchar2(60) -- 商户所在省代码
    ,mercht_local_prov_name varchar2(150) -- 商户所在省名称
    ,mercht_local_city_cd varchar2(60) -- 商户所在市代码
    ,mercht_local_city_name varchar2(150) -- 商户所在市名称
    ,mercht_local_rg_cd varchar2(60) -- 商户所在区代码
    ,mercht_local_rg_name varchar2(150) -- 商户所在区名称
    ,flow_bank_apv_flow_num varchar2(60) -- 流程银行审批流水号
    ,flow_bank_apv_rest_cd varchar2(30) -- 流程银行审批结果代码
    ,h5_flow_flg varchar2(30) -- H5进件标志
    ,risk_mgmt_admit_status_cd varchar2(30) -- 风控准入状态代码
    ,risk_mgmt_froz_cd varchar2(100) -- 风控冻结代码
    ,risk_mgmt_descb varchar2(750) -- 风控描述
    ,ext_mercht_id varchar2(60) -- 外部商户编号
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
grant select on ${iml_schema}.pty_jh_mercht_info to ${icl_schema};
grant select on ${iml_schema}.pty_jh_mercht_info to ${idl_schema};
grant select on ${iml_schema}.pty_jh_mercht_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_jh_mercht_info is '聚合商户信息';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_id is '商户编号';
comment on column ${iml_schema}.pty_jh_mercht_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_jh_mercht_info.agency_id is '代理商编号';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_cn_name is '商户中文名称';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_cn_abbr is '商户中文简称';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_sign_dt is '商户签约日期';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_revo_dt is '商户撤销日期';
comment on column ${iml_schema}.pty_jh_mercht_info.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_jh_mercht_info.cert_no is '证件号码';
comment on column ${iml_schema}.pty_jh_mercht_info.cert_invalid_dt is '证件失效日期';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_tel_num is '商户电话号码';
comment on column ${iml_schema}.pty_jh_mercht_info.elec_addr is '电子地址';
comment on column ${iml_schema}.pty_jh_mercht_info.cotas_name is '联系人名称';
comment on column ${iml_schema}.pty_jh_mercht_info.cotas_type_cd is '联系人类型代码';
comment on column ${iml_schema}.pty_jh_mercht_info.cotas_cert_no is '联系人证件号码';
comment on column ${iml_schema}.pty_jh_mercht_info.cotas_tel_num is '联系人电话号码';
comment on column ${iml_schema}.pty_jh_mercht_info.cotas_addr is '联系人地址';
comment on column ${iml_schema}.pty_jh_mercht_info.lp_name is '法人名称';
comment on column ${iml_schema}.pty_jh_mercht_info.lp_cert_no is '法人证件号码';
comment on column ${iml_schema}.pty_jh_mercht_info.lp_phone is '法人联系电话';
comment on column ${iml_schema}.pty_jh_mercht_info.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.pty_jh_mercht_info.cust_mgr_name is '客户经理姓名';
comment on column ${iml_schema}.pty_jh_mercht_info.check_status_cd is '审核状态代码';
comment on column ${iml_schema}.pty_jh_mercht_info.risk_lev_cd is '风险级别代码';
comment on column ${iml_schema}.pty_jh_mercht_info.appl_dt is '申请日期';
comment on column ${iml_schema}.pty_jh_mercht_info.start_use_dt is '启用日期';
comment on column ${iml_schema}.pty_jh_mercht_info.org_id is '机构编号';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_local_prov_cd is '商户所在省代码';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_local_prov_name is '商户所在省名称';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_local_city_cd is '商户所在市代码';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_local_city_name is '商户所在市名称';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_local_rg_cd is '商户所在区代码';
comment on column ${iml_schema}.pty_jh_mercht_info.mercht_local_rg_name is '商户所在区名称';
comment on column ${iml_schema}.pty_jh_mercht_info.flow_bank_apv_flow_num is '流程银行审批流水号';
comment on column ${iml_schema}.pty_jh_mercht_info.flow_bank_apv_rest_cd is '流程银行审批结果代码';
comment on column ${iml_schema}.pty_jh_mercht_info.h5_flow_flg is 'H5进件标志';
comment on column ${iml_schema}.pty_jh_mercht_info.risk_mgmt_admit_status_cd is '风控准入状态代码';
comment on column ${iml_schema}.pty_jh_mercht_info.risk_mgmt_froz_cd is '风控冻结代码';
comment on column ${iml_schema}.pty_jh_mercht_info.risk_mgmt_descb is '风控描述';
comment on column ${iml_schema}.pty_jh_mercht_info.ext_mercht_id is '外部商户编号';
comment on column ${iml_schema}.pty_jh_mercht_info.start_dt is '开始时间';
comment on column ${iml_schema}.pty_jh_mercht_info.end_dt is '结束时间';
comment on column ${iml_schema}.pty_jh_mercht_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_jh_mercht_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_jh_mercht_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_jh_mercht_info.etl_timestamp is 'ETL处理时间戳';
