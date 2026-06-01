/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_tps_sign_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_tps_sign_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_tps_sign_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tps_sign_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,broker_secu_cap_acct_id varchar2(100) -- 券商证券资金账户编号
    ,broker_cd varchar2(30) -- 券商代码
    ,broker_name varchar2(500) -- 券商名称
    ,tps_bank_cd varchar2(30) -- 第三方存管银行代码
    ,tps_sign_src_cd varchar2(30) -- 第三方存管签约来源代码
    ,sign_status_cd varchar2(30) -- 签约成功标志
    ,sign_dt date -- 签约日期
    ,sign_attach_info varchar2(500) -- 签约补充信息
    ,acct_id varchar2(100) -- 账户编号
    ,curr_cd varchar2(30) -- 币种代码
    ,cust_cert_type_cd varchar2(30) -- 客户证件类型代码
    ,cust_cert_no varchar2(60) -- 客户证件号码
    ,cust_id varchar2(100) -- 客户编号
    ,cust_name varchar2(500) -- 客户名称
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,open_acct_org_id varchar2(100) -- 开户机构编号
    ,operr_name varchar2(500) -- 经办人姓名
    ,operr_cert_type_cd varchar2(30) -- 经办人证件类型代码
    ,operr_cert_no varchar2(60) -- 经办人证件号码
    ,org_id varchar2(100) -- 机构编号
    ,org_name varchar2(500) -- 机构名称
    ,this_sign_flg varchar2(10) -- 签署标志
    ,this_sign_dt date -- 签署日期
    ,this_sign_flow_num varchar2(100) -- 签署流水号
    ,this_sign_agt_edit_num varchar2(500) -- 签署协议版本号
    ,this_sign_agt_src_cd varchar2(30) -- 签署协议来源代码
    ,this_sign_ip varchar2(500) -- 签署IP
    ,this_sign_mac_addr varchar2(1000) -- 签署MAC地址
    ,this_sign_equip_model varchar2(1000) -- 签署设备型号
    ,argue_way_cd varchar2(30) -- 争议解决方式代码
    ,etl_dt date -- ETL处理日期
    ,src_table_name varchar2(100) -- 源表名称
    ,job_cd varchar2(10) -- 任务编码
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list (job_cd)
subpartition by list (etl_dt)
(
   partition p_default values ('default')
   (
        subpartition p_default_19000101 values (to_date('19000101','yyyymmdd'))
   )
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iml_schema}.evt_tps_sign_flow to ${icl_schema};
grant select on ${iml_schema}.evt_tps_sign_flow to ${idl_schema};
grant select on ${iml_schema}.evt_tps_sign_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_tps_sign_flow is '第三方存管签约流水';
comment on column ${iml_schema}.evt_tps_sign_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_tps_sign_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_tps_sign_flow.broker_secu_cap_acct_id is '券商证券资金账户编号';
comment on column ${iml_schema}.evt_tps_sign_flow.broker_cd is '券商代码';
comment on column ${iml_schema}.evt_tps_sign_flow.broker_name is '券商名称';
comment on column ${iml_schema}.evt_tps_sign_flow.tps_bank_cd is '第三方存管银行代码';
comment on column ${iml_schema}.evt_tps_sign_flow.tps_sign_src_cd is '第三方存管签约来源代码';
comment on column ${iml_schema}.evt_tps_sign_flow.sign_status_cd is '签约成功标志';
comment on column ${iml_schema}.evt_tps_sign_flow.sign_dt is '签约日期';
comment on column ${iml_schema}.evt_tps_sign_flow.sign_attach_info is '签约补充信息';
comment on column ${iml_schema}.evt_tps_sign_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_tps_sign_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_tps_sign_flow.cust_cert_type_cd is '客户证件类型代码';
comment on column ${iml_schema}.evt_tps_sign_flow.cust_cert_no is '客户证件号码';
comment on column ${iml_schema}.evt_tps_sign_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_tps_sign_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_tps_sign_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_tps_sign_flow.cust_mgr_id is '客户经理编号';
comment on column ${iml_schema}.evt_tps_sign_flow.open_acct_org_id is '开户机构编号';
comment on column ${iml_schema}.evt_tps_sign_flow.operr_name is '经办人姓名';
comment on column ${iml_schema}.evt_tps_sign_flow.operr_cert_type_cd is '经办人证件类型代码';
comment on column ${iml_schema}.evt_tps_sign_flow.operr_cert_no is '经办人证件号码';
comment on column ${iml_schema}.evt_tps_sign_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_tps_sign_flow.org_name is '机构名称';
comment on column ${iml_schema}.evt_tps_sign_flow.this_sign_flg is '签署标志';
comment on column ${iml_schema}.evt_tps_sign_flow.this_sign_dt is '签署日期';
comment on column ${iml_schema}.evt_tps_sign_flow.this_sign_flow_num is '签署流水号';
comment on column ${iml_schema}.evt_tps_sign_flow.this_sign_agt_edit_num is '签署协议版本号';
comment on column ${iml_schema}.evt_tps_sign_flow.this_sign_agt_src_cd is '签署协议来源代码';
comment on column ${iml_schema}.evt_tps_sign_flow.this_sign_ip is '签署IP';
comment on column ${iml_schema}.evt_tps_sign_flow.this_sign_mac_addr is '签署MAC地址';
comment on column ${iml_schema}.evt_tps_sign_flow.this_sign_equip_model is '签署设备型号';
comment on column ${iml_schema}.evt_tps_sign_flow.argue_way_cd is '争议解决方式代码';
comment on column ${iml_schema}.evt_tps_sign_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_tps_sign_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_tps_sign_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_tps_sign_flow.etl_timestamp is 'ETL处理时间戳';
