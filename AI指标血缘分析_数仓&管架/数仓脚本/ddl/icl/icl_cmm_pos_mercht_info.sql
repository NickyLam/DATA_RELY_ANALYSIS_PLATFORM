/*
Purpose:    共性加工层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py icl cmm_pos_mercht_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${icl_schema}.cmm_pos_mercht_info
whenever sqlerror continue none;
drop table ${icl_schema}.cmm_pos_mercht_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${icl_schema}.cmm_pos_mercht_info(
    etl_dt date -- 数据日期
    ,lp_id varchar2(60) -- 法人编号
    ,mercht_order_id varchar2(60) -- 商户序列编号
    ,mercht_id varchar2(60) -- 商户编号
    ,agency_id varchar2(60) -- 代理商编号
    ,mercht_name varchar2(500) -- 商户名称
	,mercht_cust_id varchar2(60) -- 商户客户号
    ,mercht_fname varchar2(150) -- 商户全称
    ,work_addr varchar2(750) -- 办公地址
    ,open_acct_bank_name varchar2(150) -- 开户银行名称
    ,open_acct_bank_id varchar2(60) -- 开户银行编号
    ,acct_id varchar2(60) -- 账户编号
    ,acct_name varchar2(150) -- 账户名称
    ,acct_type_cd varchar2(60) -- 账户类型代码
    ,cotas_type_cd varchar2(60) -- 联系人类型代码
    ,cotas_name varchar2(150) -- 联系人名称
    ,cont_num varchar2(60) -- 联系号码
    ,cotas_e_mail varchar2(90) -- 联系人电子邮箱
    ,fax_num varchar2(60) -- 传真号码
    ,mercht_belong_rg_cd varchar2(60) -- 商户地区代码
    ,mercht_mcc_code varchar2(60) -- 商户类别码
    ,mercht_mcc_descb varchar2(500) -- 商户类别码名称
    ,oper_co_corp_name varchar2(150) -- 经办合作单位名称
    ,agency_abbr varchar2(100) -- 代理商简称
    ,agency_belong_brch_id varchar2(100) -- 代理商所属分行编号
    ,agency_bus_lics_id varchar2(60) -- 代理商营业执照编号
    ,agency_cotas_name varchar2(100) -- 代理商联系人名称
    ,agency_cotas_addr varchar2(100) -- 代理商联系人地址
    ,agency_enter_acct_chn_cd varchar2(30) -- 代理商入账渠道代码
    ,agency_status_cd varchar2(30) -- 代理商状态代码
    ,recv_bill_bank_id varchar2(60) -- 收单银行编号
    ,mercht_status_cd varchar2(30) -- 商户状态代码
    ,dic_conc_co_status_cd varchar2(30) -- 商户激活状态
    ,belong_org_id varchar2(60) -- 所属机构编号
    ,cust_mgr_id varchar2(100) -- 客户经理编号
    ,cust_mgr_name varchar2(150) -- 客户经理名称
    ,flow_bank_apv_flow_id varchar2(60) -- 流程银行审批流水编号
    ,flow_bank_apv_rest_cd varchar2(30) -- 流程银行审批结果代码
    ,h5_flow_flg varchar2(30) -- H5进件标志
    ,dic_conc_mercht_flg varchar2(10) -- 直连商户标志
    ,jh_mercht_flg varchar2(10) -- 聚合商户标志
    ,mercht_start_use_dt date -- 商户启用日期
    ,mercht_sign_dt date -- 商户签约日期
    ,mercht_revo_dt date -- 商户撤销日期
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
grant select on ${icl_schema}.cmm_pos_mercht_info to ${idl_schema};
grant select on ${icl_schema}.cmm_pos_mercht_info to ${iel_schema};
grant select on ${icl_schema}.cmm_pos_mercht_info to ${dqc_schema};
-- comment
comment on table ${icl_schema}.cmm_pos_mercht_info is 'POS商户信息';
comment on column ${icl_schema}.cmm_pos_mercht_info.etl_dt is '数据日期';
comment on column ${icl_schema}.cmm_pos_mercht_info.lp_id is '法人编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_order_id is '商户序列编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_id is '商户编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_cust_id is '商户客户号';
comment on column ${icl_schema}.cmm_pos_mercht_info.agency_id is '代理商编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_name is '商户名称';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_fname is '商户全称';
comment on column ${icl_schema}.cmm_pos_mercht_info.work_addr is '办公地址';
comment on column ${icl_schema}.cmm_pos_mercht_info.open_acct_bank_name is '开户银行名称';
comment on column ${icl_schema}.cmm_pos_mercht_info.open_acct_bank_id is '开户银行编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.acct_id is '账户编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.acct_name is '账户名称';
comment on column ${icl_schema}.cmm_pos_mercht_info.acct_type_cd is '账户类型代码';
comment on column ${icl_schema}.cmm_pos_mercht_info.cotas_type_cd is '联系人类型代码';
comment on column ${icl_schema}.cmm_pos_mercht_info.cotas_name is '联系人名称';
comment on column ${icl_schema}.cmm_pos_mercht_info.cont_num is '联系号码';
comment on column ${icl_schema}.cmm_pos_mercht_info.cotas_e_mail is '联系人电子邮箱';
comment on column ${icl_schema}.cmm_pos_mercht_info.fax_num is '传真号码';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_belong_rg_cd is '商户地区代码';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_mcc_code is '商户类别码';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_mcc_descb is '商户类别码名称';
comment on column ${icl_schema}.cmm_pos_mercht_info.oper_co_corp_name is '经办合作单位名称';
comment on column ${icl_schema}.cmm_pos_mercht_info.agency_abbr is '代理商简称';
comment on column ${icl_schema}.cmm_pos_mercht_info.agency_belong_brch_id is '代理商所属分行编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.agency_bus_lics_id is '代理商营业执照编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.agency_cotas_name is '代理商联系人名称';
comment on column ${icl_schema}.cmm_pos_mercht_info.agency_cotas_addr is '代理商联系人地址';
comment on column ${icl_schema}.cmm_pos_mercht_info.agency_enter_acct_chn_cd is '代理商入账渠道代码';
comment on column ${icl_schema}.cmm_pos_mercht_info.agency_status_cd is '代理商状态代码';
comment on column ${icl_schema}.cmm_pos_mercht_info.recv_bill_bank_id is '收单银行编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_status_cd is '商户状态代码';
comment on column ${icl_schema}.cmm_pos_mercht_info.dic_conc_co_status_cd is '商户激活状态';
comment on column ${icl_schema}.cmm_pos_mercht_info.belong_org_id is '所属机构编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.cust_mgr_id is '客户经理编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.cust_mgr_name is '客户经理名称';
comment on column ${icl_schema}.cmm_pos_mercht_info.flow_bank_apv_flow_id is '流程银行审批流水编号';
comment on column ${icl_schema}.cmm_pos_mercht_info.flow_bank_apv_rest_cd is '流程银行审批结果代码';
comment on column ${icl_schema}.cmm_pos_mercht_info.h5_flow_flg is 'H5进件标志';
comment on column ${icl_schema}.cmm_pos_mercht_info.dic_conc_mercht_flg is '直连商户标志';
comment on column ${icl_schema}.cmm_pos_mercht_info.jh_mercht_flg is '聚合商户标志';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_start_use_dt is '商户启用日期';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_sign_dt is '商户签约日期';
comment on column ${icl_schema}.cmm_pos_mercht_info.mercht_revo_dt is '商户撤销日期';
comment on column ${icl_schema}.cmm_pos_mercht_info.job_cd is '任务代码';
comment on column ${icl_schema}.cmm_pos_mercht_info.etl_timestamp is '数据处理时间';
--comment on column ${icl_schema}.cmm_pos_mercht_info.etl_dt is 'ETL处理日期';
--comment on column ${icl_schema}.cmm_pos_mercht_info.etl_timestamp is 'ETL处理时间戳';
