/*
Purpose:    整合模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml pty_salary_plat_payoff_corp_info
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.pty_salary_plat_payoff_corp_info
whenever sqlerror continue none;
drop table ${iml_schema}.pty_salary_plat_payoff_corp_info purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.pty_salary_plat_payoff_corp_info(
    party_id varchar2(250) -- 当事人编号
    ,lp_id varchar2(100) -- 法人编号
    ,corp_id varchar2(250) -- 企业编号
    ,corp_name varchar2(1000) -- 企业名称
    ,corp_abbr varchar2(1000) -- 企业简称
    ,corp_size_cd varchar2(30) -- 企业规模代码
    ,indus_type_cd varchar2(30) -- 行业类型代码
    ,cert_type_cd varchar2(30) -- 证件类型代码
    ,cert_no varchar2(250) -- 证件号码
    ,local_prov varchar2(500) -- 所在省
    ,local_city varchar2(500) -- 所在市
    ,local_rg varchar2(500) -- 所在区
    ,dtl_addr varchar2(2000) -- 详细地址
    ,imp_cust_flg varchar2(10) -- 重点客户标志
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,bank_org_id varchar2(250) -- 银行机构编号
    ,bank_mgmt_id varchar2(250) -- 银行管理员工编号
    ,bank_cust_mgr_id varchar2(250) -- 银行客户经理编号
    ,corp_hibchy varchar2(100) -- 企业层级
    ,super_corp_id varchar2(250) -- 上级企业编号
    ,lp_name varchar2(250) -- 法人名称
    ,lp_cert_type_cd varchar2(30) -- 法人证件类型代码
    ,lp_cert_no varchar2(250) -- 法人证件号码
    ,chc_cert_type_cd varchar2(30) -- 认证类型代码
    ,cert_submit_dt date -- 认证提交日期
    ,start_use_flg varchar2(10) -- 启用标志
    ,cert_submit_emply_id varchar2(250) -- 认证提交员工编号
    ,fir_cert_sucs_dt date -- 首次认证成功日期
    ,corp_cert_status_cd varchar2(30) -- 企业认证状态代码
    ,cert_fail_rs varchar2(2000) -- 认证失败原因
    ,corp_dsmis_status_cd varchar2(30) -- 企业解散状态代码
    ,corp_dsmis_flow_num varchar2(250) -- 企业解散流水号
    ,allow_emply_srch_reach_corp_flg varchar2(10) -- 允许员工搜索到企业标志
    ,allow_other_corp_rela_flg varchar2(10) -- 允许其他企业关联标志
    ,batch_no varchar2(250) -- 批次号
    ,batch_create_dt date -- 批次创建日期
    ,batch_update_dt date -- 批次更新日期
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
grant select on ${iml_schema}.pty_salary_plat_payoff_corp_info to ${icl_schema};
grant select on ${iml_schema}.pty_salary_plat_payoff_corp_info to ${idl_schema};
grant select on ${iml_schema}.pty_salary_plat_payoff_corp_info to ${iel_schema};

-- comment
comment on table ${iml_schema}.pty_salary_plat_payoff_corp_info is '薪酬平台代发企业信息';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.party_id is '当事人编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.lp_id is '法人编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.corp_id is '企业编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.corp_name is '企业名称';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.corp_abbr is '企业简称';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.corp_size_cd is '企业规模代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.indus_type_cd is '行业类型代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.cert_type_cd is '证件类型代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.cert_no is '证件号码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.local_prov is '所在省';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.local_city is '所在市';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.local_rg is '所在区';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.dtl_addr is '详细地址';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.imp_cust_flg is '重点客户标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.bank_org_id is '银行机构编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.bank_mgmt_id is '银行管理员工编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.bank_cust_mgr_id is '银行客户经理编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.corp_hibchy is '企业层级';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.super_corp_id is '上级企业编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.lp_name is '法人名称';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.lp_cert_type_cd is '法人证件类型代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.lp_cert_no is '法人证件号码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.chc_cert_type_cd is '认证类型代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.cert_submit_dt is '认证提交日期';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.start_use_flg is '启用标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.cert_submit_emply_id is '认证提交员工编号';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.fir_cert_sucs_dt is '首次认证成功日期';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.corp_cert_status_cd is '企业认证状态代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.cert_fail_rs is '认证失败原因';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.corp_dsmis_status_cd is '企业解散状态代码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.corp_dsmis_flow_num is '企业解散流水号';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.allow_emply_srch_reach_corp_flg is '允许员工搜索到企业标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.allow_other_corp_rela_flg is '允许其他企业关联标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.batch_no is '批次号';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.batch_create_dt is '批次创建日期';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.batch_update_dt is '批次更新日期';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.start_dt is '开始时间';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.end_dt is '结束时间';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.id_mark is '增删标志';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.src_table_name is '源表名称';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.job_cd is '任务编码';
comment on column ${iml_schema}.pty_salary_plat_payoff_corp_info.etl_timestamp is 'ETL处理时间戳';
