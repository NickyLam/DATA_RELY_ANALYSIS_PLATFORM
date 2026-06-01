/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_ponl_bk_authen_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_ponl_bk_authen_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_ponl_bk_authen_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_ponl_bk_authen_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,tran_tm varchar2(100) -- 交易时间
    ,tran_code varchar2(100) -- 交易码
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,return_code varchar2(100) -- 返回码
    ,fail_rs varchar2(2000) -- 失败原因
    ,acct_id varchar2(100) -- 账户编号
    ,tran_amt number(18,6) -- 交易金额
    ,curr_cd varchar2(30) -- 币种代码
    ,cust_id varchar2(100) -- 交易客户编号
    ,tran_chn_cd varchar2(30) -- 交易渠道代码
    ,chn_send_flow_num varchar2(100) -- 渠道发送流水号
    ,sorc_sys_flow_num varchar2(100) -- 源系统流水号
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号
    ,cust_ip varchar(250) -- 客户IP
    ,curr_server_host_name varchar2(100) -- 当前服务器主机名
    ,req_src_server_ip varchar2(100) -- 请求来源服务器IP
    ,cust_termn_mac_addr varchar2(100) -- 客户终端MAC地址
    ,cust_termn_oper_sys varchar2(100) -- 客户终端操作系统
    ,cust_termn_brow varchar2(100) -- 客户终端浏览器
    ,cust_termn_equip_model varchar2(100) -- 客户终端设备型号
    ,cust_termn_equip_id varchar2(100) -- 客户终端设备ID
    ,logon_session_id varchar2(250) -- 登陆sessionID
    ,rela_flow_num varchar2(100) -- 关联流水号
    ,tran_jnl_info varchar2(500) -- 交易日志信息
    ,tran_type_code varchar2(100) -- 交易类型码
    ,cust_name varchar2(250) -- 客户名称
    ,save_cert_way_cd varchar2(30) -- 安全认证方式代码
    ,func_menu_id varchar2(100) -- 功能菜单编号
    ,tran_order_no varchar2(60) -- 交易订单号
    ,chain_way_track_no varchar2(250) -- 链路跟踪号
    ,sys_flow_num varchar2(100) -- 系统流水号
    ,chn_id varchar2(30) -- 渠道编号
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
grant select on ${iml_schema}.evt_ponl_bk_authen_flow to ${icl_schema};
grant select on ${iml_schema}.evt_ponl_bk_authen_flow to ${idl_schema};
grant select on ${iml_schema}.evt_ponl_bk_authen_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_ponl_bk_authen_flow is '个人网银鉴权流水';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.flow_num is '流水号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.return_code is '返回码';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.fail_rs is '失败原因';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.cust_id is '交易客户编号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.tran_chn_cd is '交易渠道代码';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.chn_send_flow_num is '渠道发送流水号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.sorc_sys_flow_num is '源系统流水号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.cust_ip is '客户IP';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.curr_server_host_name is '当前服务器主机名';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.req_src_server_ip is '请求来源服务器IP';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.cust_termn_mac_addr is '客户终端MAC地址';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.cust_termn_oper_sys is '客户终端操作系统';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.cust_termn_brow is '客户终端浏览器';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.cust_termn_equip_model is '客户终端设备型号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.cust_termn_equip_id is '客户终端设备ID';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.logon_session_id is '登陆sessionID';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.tran_jnl_info is '交易日志信息';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.tran_type_code is '交易类型码';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.save_cert_way_cd is '安全认证方式代码';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.func_menu_id is '功能菜单编号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.tran_order_no is '交易订单号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.chain_way_track_no is '链路跟踪号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.sys_flow_num is '系统流水号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_ponl_bk_authen_flow.etl_timestamp is 'ETL处理时间戳';
