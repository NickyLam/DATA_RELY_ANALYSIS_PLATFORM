/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_os_priv_serv_bus_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_os_priv_serv_bus_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_os_priv_serv_bus_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_os_priv_serv_bus_flow(
    evt_id varchar2(60) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,flow_num varchar2(60) -- 流水号
    ,tran_dt date -- 交易日期
    ,tran_tm varchar2(20) -- 交易时间
    ,tran_code varchar2(100) -- 交易码
    ,tran_status_cd varchar2(10) -- 交易状态代码
    ,tran_return_code varchar2(100) -- 交易返回码
    ,fail_rs varchar2(2000) -- 失败原因
    ,tran_acct_num varchar2(60) -- 交易账号
    ,tran_amt number(30,2) -- 交易金额
    ,curr_cd varchar2(10) -- 币种代码
    ,whole_unify_cust_id varchar2(60) -- 全行统一客户编号
    ,user_seq_id varchar2(60) -- 用户顺序编号
    ,tran_chn_cd varchar2(60) -- 渠道系统代码
    ,chn_send_flow_num varchar2(64) -- 渠道发送流水号
    ,sorc_sys_flow_num varchar2(60) -- 源系统流水号
    ,core_tran_flow_num varchar2(60) -- 核心交易流水号
    ,comm_fee number(30,2) -- 手续费
    ,visit_flow_num varchar2(60) -- 访问流水号
    ,core_tran_dt date -- 核心交易日期
    ,cust_ip_num varchar2(250) -- 客户IP号
    ,curr_server_host_name varchar2(60) -- 当前服务器主机名
    ,cust_termn_mac_addr varchar2(60) -- 客户终端MAC地址
    ,cust_termn_oper_sys_edit_num varchar2(60) -- 客户终端操作系统版本号
    ,cust_termn_brow varchar2(60) -- 客户终端浏览器
    ,cust_termn_equip_model varchar2(60) -- 客户终端设备型号
    ,cust_termn_equip_id varchar2(100) -- 客户终端设备编号
    ,logon_session_id varchar2(200) -- 登陆session编号
    ,rela_flow_num varchar2(60) -- 关联流水号
    ,tran_jnl_info varchar2(2000) -- 交易日志信息
    ,tran_type_code varchar2(100) -- 交易类型码
    ,cust_name varchar2(200) -- 客户名称
    ,save_cert_way_cd varchar2(10) -- 安全认证方式代码
    ,camp_job_no varchar2(60) -- 营销工号
    ,pbc_flow_num varchar2(60) -- 人行流水号
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
grant select on ${iml_schema}.evt_os_priv_serv_bus_flow to ${icl_schema};
grant select on ${iml_schema}.evt_os_priv_serv_bus_flow to ${idl_schema};
grant select on ${iml_schema}.evt_os_priv_serv_bus_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_os_priv_serv_bus_flow is '外服对私服务业务流水';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.flow_num is '流水号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.tran_tm is '交易时间';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.tran_code is '交易码';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.tran_return_code is '交易返回码';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.fail_rs is '失败原因';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.tran_acct_num is '交易账号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.whole_unify_cust_id is '全行统一客户编号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.user_seq_id is '用户顺序编号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.tran_chn_cd is '渠道系统代码';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.chn_send_flow_num is '渠道发送流水号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.sorc_sys_flow_num is '源系统流水号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.comm_fee is '手续费';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.visit_flow_num is '访问流水号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.cust_ip_num is '客户IP号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.curr_server_host_name is '当前服务器主机名';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.cust_termn_mac_addr is '客户终端MAC地址';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.cust_termn_oper_sys_edit_num is '客户终端操作系统版本号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.cust_termn_brow is '客户终端浏览器';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.cust_termn_equip_model is '客户终端设备型号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.cust_termn_equip_id is '客户终端设备编号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.logon_session_id is '登陆session编号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.rela_flow_num is '关联流水号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.tran_jnl_info is '交易日志信息';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.tran_type_code is '交易类型码';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.save_cert_way_cd is '安全认证方式代码';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.camp_job_no is '营销工号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.pbc_flow_num is '人行流水号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_os_priv_serv_bus_flow.etl_timestamp is 'ETL处理时间戳';
