/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_intellge_brac_comm_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_intellge_brac_comm_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_intellge_brac_comm_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_intellge_brac_comm_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,plat_flow_num varchar2(100) -- 平台流水号
    ,plat_tran_dt date -- 平台交易日期
    ,ova_flow_num varchar2(100) -- 全局流水号
    ,sorc_sys_id varchar2(100) -- 源系统编号
    ,chn_id varchar2(100) -- 渠道编号
    ,chn_dt date -- 渠道日期
    ,chn_flow_num varchar2(100) -- 渠道流水号
    ,back_end_serv_sys_id varchar2(100) -- 后台服务系统编号
    ,back_end_serv_sys_intfc_id varchar2(250) -- 后台服务系统接口编号
    ,back_end_serv_sys_intfc_name varchar2(1000) -- 后台服务系统接口名称
    ,back_end_resp_dt date -- 后台响应日期
    ,back_end_flow_num varchar2(100) -- 后台流水号
    ,back_end_proc_status_cd varchar2(30) -- 后台处理状态代码
    ,back_end_process_cd varchar2(60) -- 后台处理码
    ,back_end_return_info_desc varchar2(1000) -- 后台返回信息描述
    ,req_tm timestamp -- 请求时间
    ,resp_tm timestamp -- 响应时间
    ,menu_id varchar2(100) -- 菜单编号
    ,main_comm_flg varchar2(10) -- 主通讯标志
    ,cust_type_cd varchar2(30) -- 客户类型代码
    ,menu_name varchar2(250) -- 菜单名称
    ,cust_id varchar2(100) -- 客户编号
    ,core_bus_type_cd varchar2(30) -- 核心业务类型代码
    ,acct_id varchar2(100) -- 账户编号
    ,acct_num_name varchar2(1000) -- 账号名称
    ,tran_amt number(30,2) -- 交易金额
    ,cntpty_acct_id varchar2(100) -- 交易对手账户编号
    ,cntpty_acct_name varchar2(500) -- 交易对手账户名称
    ,node_id varchar2(100) -- 节点编号
    ,node_name varchar2(500) -- 节点名称
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
grant select on ${iml_schema}.evt_intellge_brac_comm_flow to ${icl_schema};
grant select on ${iml_schema}.evt_intellge_brac_comm_flow to ${idl_schema};
grant select on ${iml_schema}.evt_intellge_brac_comm_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_intellge_brac_comm_flow is '智能网点通讯流水';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.plat_flow_num is '平台流水号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.plat_tran_dt is '平台交易日期';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.ova_flow_num is '全局流水号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.sorc_sys_id is '源系统编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.chn_id is '渠道编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.chn_dt is '渠道日期';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.chn_flow_num is '渠道流水号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.back_end_serv_sys_id is '后台服务系统编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.back_end_serv_sys_intfc_id is '后台服务系统接口编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.back_end_serv_sys_intfc_name is '后台服务系统接口名称';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.back_end_resp_dt is '后台响应日期';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.back_end_flow_num is '后台流水号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.back_end_proc_status_cd is '后台处理状态代码';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.back_end_process_cd is '后台处理码';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.back_end_return_info_desc is '后台返回信息描述';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.req_tm is '请求时间';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.resp_tm is '响应时间';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.menu_id is '菜单编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.main_comm_flg is '主通讯标志';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.cust_type_cd is '客户类型代码';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.menu_name is '菜单名称';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.cust_id is '客户编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.core_bus_type_cd is '核心业务类型代码';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.acct_num_name is '账号名称';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.cntpty_acct_id is '交易对手账户编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.cntpty_acct_name is '交易对手账户名称';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.node_id is '节点编号';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.node_name is '节点名称';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_intellge_brac_comm_flow.etl_timestamp is 'ETL处理时间戳';
