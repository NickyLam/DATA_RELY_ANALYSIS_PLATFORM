/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_p_onl_bank_serv_bus_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_p_onl_bank_serv_bus_flow
whenever sqlerror continue none;
drop table ${idl_schema}.aml_p_onl_bank_serv_bus_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_p_onl_bank_serv_bus_flow(
    etl_dt date -- 数据日期
    ,evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,flow_num varchar2(200) -- 流水号
    ,tran_dt date -- 交易日期
    ,tran_tm varchar2(60) -- 交易时间
    ,tran_code varchar2(250) -- 交易码
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,tran_return_code varchar2(250) -- 交易返回码
    ,fail_rs varchar2(2500) -- 失败原因
    ,tran_acct_num varchar2(200) -- 交易账号
    ,tran_amt number(30,2) -- 交易金额
    ,curr_cd varchar2(10) -- 币种代码
    ,whole_unify_cust_id varchar2(200) -- 全行统一客户编号
    ,tran_chn_cd varchar2(60) -- 交易渠道代码
    ,chn_send_flow_num varchar2(200) -- 渠道发送流水号
    ,sorc_sys_flow_num varchar2(100) -- 源系统流水号
    ,core_tran_flow_num varchar2(200) -- 核心交易流水号
    ,comm_fee number(30,2) -- 手续费
    ,visit_flow_num varchar2(200) -- 访问流水号
    ,core_tran_dt date -- 核心交易日期
    ,cust_ip_num varchar2(500) -- 客户IP号
    ,curr_server_host_name varchar2(500) -- 当前服务器主机名
    ,cust_termn_mac_addr varchar2(60) -- 客户终端MAC地址
    ,cust_termn_oper_sys_edit_num varchar2(60) -- 客户终端操作系统版本号
    ,cust_termn_brow varchar2(500) -- 客户终端浏览器
    ,cust_termn_equip_model varchar2(200) -- 客户终端设备型号
    ,cust_termn_equip_id varchar2(200) -- 客户终端设备编号
    ,logon_session_id varchar2(500) -- 登陆session编号
    ,rela_flow_num varchar2(200) -- 关联流水号
    ,tran_jnl_info varchar2(2500) -- 交易日志信息
    ,tran_type_code varchar2(250) -- 交易类型码
    ,cust_name varchar2(500) -- 客户名称
    ,save_cert_way_cd varchar2(10) -- 安全认证方式代码
    ,camp_job_no varchar2(60) -- 营销工号
    ,pbc_flow_num varchar2(200) -- 人行流水号
    ,user_seq_id varchar2(200) -- 用户顺序编号
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
grant select on ${idl_schema}.aml_p_onl_bank_serv_bus_flow to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_p_onl_bank_serv_bus_flow is '个人网银服务业务流水';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.evt_id is '事件编号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.lp_id is '法人编号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.flow_num is '流水号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.tran_dt is '交易日期';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.tran_tm is '交易时间';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.tran_code is '交易码';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.tran_status_cd is '交易状态代码';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.tran_return_code is '交易返回码';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.fail_rs is '失败原因';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.tran_acct_num is '交易账号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.tran_amt is '交易金额';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.whole_unify_cust_id is '全行统一客户编号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.tran_chn_cd is '交易渠道代码';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.chn_send_flow_num is '渠道发送流水号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.sorc_sys_flow_num is '源系统流水号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.comm_fee is '手续费';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.visit_flow_num is '访问流水号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.core_tran_dt is '核心交易日期';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.cust_ip_num is '客户IP号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.curr_server_host_name is '当前服务器主机名';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.cust_termn_mac_addr is '客户终端MAC地址';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.cust_termn_oper_sys_edit_num is '客户终端操作系统版本号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.cust_termn_brow is '客户终端浏览器';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.cust_termn_equip_model is '客户终端设备型号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.cust_termn_equip_id is '客户终端设备编号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.logon_session_id is '登陆session编号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.rela_flow_num is '关联流水号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.tran_jnl_info is '交易日志信息';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.tran_type_code is '交易类型码';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.cust_name is '客户名称';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.save_cert_way_cd is '安全认证方式代码';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.camp_job_no is '营销工号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.pbc_flow_num is '人行流水号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.user_seq_id is '用户顺序编号';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.job_cd is '任务代码';
comment on column ${idl_schema}.aml_p_onl_bank_serv_bus_flow.etl_timestamp is '数据处理时间';
