/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_evt_bank_pc_edit_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_evt_bank_pc_edit_tran_flow
whenever sqlerror continue none;
drop table ${idl_schema}.aml_evt_bank_pc_edit_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_evt_bank_pc_edit_tran_flow(
    etl_dt date -- 数据日期
    ,evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,flow_num varchar2(60) -- 流水号
    ,tran_tm timestamp -- 交易时间
    ,tran_dt date -- 交易日期
    ,tran_code varchar2(100) -- 交易码
    ,tran_order varchar2(100) -- 交易命令
    ,unify_cust_id varchar2(60) -- 统一客户编号
    ,user_seq_num varchar2(60) -- 用户顺序号
    ,tran_chn_cd varchar2(20) -- 交易渠道代码
    ,cust_name varchar2(500) -- 客户姓名
    ,menu_id varchar2(100) -- 菜单ID
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,tran_return_code varchar2(500) -- 交易返回编码
    ,fail_rs_descb varchar2(2000) -- 失败原因描述
    ,tran_acct_num varchar2(60) -- 交易账号
    ,tran_amt number(30,2) -- 交易金额
    ,curr_cd varchar2(10) -- 币种代码
    ,chn_send_flow_id varchar2(1000) -- 渠道发送流水编号
    ,sorc_sys_flow_id varchar2(60) -- 源系统流水编号
    ,core_tran_flow_id varchar2(60) -- 核心交易流水编号
    ,comm_fee number(30,2) -- 手续费
    ,parent_flow_id varchar2(60) -- 父流水编号
    ,src_flow_seq_id varchar2(60) -- 来源流水顺序编号
    ,auth_refuse_rs varchar2(250) -- 授权拒绝原因
    ,visit_flow_id varchar2(60) -- 访问流水编号
    ,core_tran_dt date -- 核心交易日期
    ,callout_tran_code varchar2(100) -- 被调方交易码
    ,cust_ip varchar2(500) -- 客户IP
    ,curr_server_host_name varchar2(100) -- 当前服务器主机名称
    ,req_src_server_ip varchar2(60) -- 请求来源服务器IP
    ,cust_termn_mac_addr varchar2(30) -- 客户终端MAC地址
    ,cust_termn_oper_sys varchar2(30) -- 客户终端操作系统
    ,cust_termn_brow varchar2(60) -- 客户终端浏览器
    ,cust_termn_equip_model varchar2(30) -- 客户终端设备型号
    ,cust_termn_equip_id varchar2(60) -- 客户终端设备ID
    ,session_id varchar2(250) -- SESSION_ID
    ,rela_flow_id varchar2(60) -- 关联流水编号
    ,save_cert_way_cd varchar2(10) -- 安全认证方式代码
    ,auth_status_cd varchar2(10) -- 授权状态代码
    ,bank_agent_flg varchar2(10) -- 银行代办标志
    ,auth_role_seq_num varchar2(10) -- 授权角色序号
    ,submit_core_dt date -- 提交核心日期
    ,submit_core_tm timestamp -- 提交核心时间
    ,tran_tot_qtty number(10) -- 交易总数量
    ,remark varchar2(1000) -- 备注
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
grant select on ${idl_schema}.aml_evt_bank_pc_edit_tran_flow to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_evt_bank_pc_edit_tran_flow is '银行PC版交易流水';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.evt_id is '事件编号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.lp_id is '法人编号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.flow_num is '流水号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.tran_tm is '交易时间';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.tran_dt is '交易日期';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.tran_code is '交易码';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.tran_order is '交易命令';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.unify_cust_id is '统一客户编号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.user_seq_num is '用户顺序号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.tran_chn_cd is '交易渠道代码';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.cust_name is '客户姓名';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.menu_id is '菜单ID';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.tran_return_code is '交易返回编码';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.fail_rs_descb is '失败原因描述';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.tran_acct_num is '交易账号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.tran_amt is '交易金额';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.curr_cd is '币种代码';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.chn_send_flow_id is '渠道发送流水编号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.sorc_sys_flow_id is '源系统流水编号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.core_tran_flow_id is '核心交易流水编号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.comm_fee is '手续费';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.parent_flow_id is '父流水编号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.src_flow_seq_id is '来源流水顺序编号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.auth_refuse_rs is '授权拒绝原因';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.visit_flow_id is '访问流水编号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.core_tran_dt is '核心交易日期';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.callout_tran_code is '被调方交易码';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.cust_ip is '客户IP';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.curr_server_host_name is '当前服务器主机名称';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.req_src_server_ip is '请求来源服务器IP';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.cust_termn_mac_addr is '客户终端MAC地址';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.cust_termn_oper_sys is '客户终端操作系统';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.cust_termn_brow is '客户终端浏览器';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.cust_termn_equip_model is '客户终端设备型号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.cust_termn_equip_id is '客户终端设备ID';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.session_id is 'SESSION_ID';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.rela_flow_id is '关联流水编号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.save_cert_way_cd is '安全认证方式代码';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.auth_status_cd is '授权状态代码';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.bank_agent_flg is '银行代办标志';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.auth_role_seq_num is '授权角色序号';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.submit_core_dt is '提交核心日期';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.submit_core_tm is '提交核心时间';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.tran_tot_qtty is '交易总数量';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.remark is '备注';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.job_cd is '任务代码';
comment on column ${idl_schema}.aml_evt_bank_pc_edit_tran_flow.etl_timestamp is '数据处理时间';
