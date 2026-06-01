/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_evt_core_basic_tran_addit
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_evt_core_basic_tran_addit
whenever sqlerror continue none;
drop table ${idl_schema}.aml_evt_core_basic_tran_addit purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_evt_core_basic_tran_addit(
    etl_dt date -- 数据日期   
    ,evt_id varchar2(60) -- 事件编号   
    ,lp_id varchar2(60) -- 法人编号   
    ,tran_flow_num varchar2(60) -- 交易流水号   
    ,tran_dt date -- 交易日期   
    ,agent_name varchar2(100) -- 代理人名称   
    ,agent_cert_type_cd varchar2(10) -- 代理人证件类型代码   
    ,agent_cert_no varchar2(60) -- 代理人证件号码   
    ,agent_nation_cd varchar2(10) -- 代理人国籍代码   
    ,agent_gender_cd varchar2(10) -- 代理人性别代码   
    ,agent_cert_exp_dt date -- 代理人证件到期日   
    ,agent_phone varchar2(60) -- 代理人联系电话   
    ,agent_licen_issue_autho_site varchar2(100) -- 代理人发证机关所在地   
    ,agent_type_cd varchar2(10) -- 代理类型代码   
    ,agent_rs varchar2(250) -- 代理原因   
    ,operr_cert_type_cd varchar2(10) -- 经办人证件类型代码   
    ,operr_cert_no varchar2(60) -- 经办人证件号码   
    ,operr_name varchar2(100) -- 经办人名称   
    ,memo varchar2(250) -- 摘要   
    ,comnt_remark_postsc varchar2(100) -- 说明备注附言   
    ,ext_field_1 varchar2(100) -- 扩展字段1   
    ,ext_field_2 varchar2(20) -- 扩展字段2   
    ,ext_field_3 varchar2(20) -- 扩展字段3   
    ,ext_field_4 varchar2(20) -- 扩展字段4   
    ,ext_field_5 varchar2(20) -- 扩展字段5   
    ,ext_field_6 varchar2(20) -- 扩展字段6   
    ,ext_field_7 varchar2(20) -- 扩展字段7   
    ,ext_field_8 varchar2(20) -- 扩展字段8   
    ,job_cd varchar2(10) -- 任务代码   
    ,etl_timestamp timestamp -- 数据处理时间   
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.aml_evt_core_basic_tran_addit to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_evt_core_basic_tran_addit is '核心基本交易附加表';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.evt_id is '事件编号';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.lp_id is '法人编号';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.tran_flow_num is '交易流水号';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.tran_dt is '交易日期';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.agent_name is '代理人名称';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.agent_cert_type_cd is '代理人证件类型代码';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.agent_cert_no is '代理人证件号码';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.agent_nation_cd is '代理人国籍代码';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.agent_gender_cd is '代理人性别代码';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.agent_cert_exp_dt is '代理人证件到期日';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.agent_phone is '代理人联系电话';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.agent_licen_issue_autho_site is '代理人发证机关所在地';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.agent_type_cd is '代理类型代码';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.agent_rs is '代理原因';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.operr_cert_type_cd is '经办人证件类型代码';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.operr_cert_no is '经办人证件号码';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.operr_name is '经办人名称';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.memo is '摘要';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.comnt_remark_postsc is '说明备注附言';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.ext_field_1 is '扩展字段1';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.ext_field_2 is '扩展字段2';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.ext_field_3 is '扩展字段3';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.ext_field_4 is '扩展字段4';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.ext_field_5 is '扩展字段5';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.ext_field_6 is '扩展字段6';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.ext_field_7 is '扩展字段7';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.ext_field_8 is '扩展字段8';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.job_cd is '任务代码';
comment on column ${idl_schema}.aml_evt_core_basic_tran_addit.etl_timestamp is '数据处理时间';