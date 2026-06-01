/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_epc_payfan_indent_tran_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_epc_payfan_indent_tran_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_epc_payfan_indent_tran_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_epc_payfan_indent_tran_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,ser_num varchar2(250) -- 序列号
    ,order_no varchar2(250) -- 订单号
    ,indent_amt number(30,2) -- 订单金额
    ,tran_status_cd varchar2(30) -- 交易状态代码
    ,tran_dt date -- 交易日期
    ,sign_ser_num varchar2(250) -- 签约序列号
    ,pay_acct_id varchar2(250) -- 付款账户编号
    ,pay_acct_name varchar2(500) -- 付款账户名称
    ,pay_acct_type_cd varchar2(30) -- 付款账户类型代码
    ,pay_acct_core_type_cd varchar2(30) -- 付款账户核心类型代码
    ,recvbl_acct_id varchar2(250) -- 收款账户编号
    ,recvbl_acct_name varchar2(500) -- 收款账户名称
    ,recvbl_acct_type_cd varchar2(30) -- 收款账户类型代码
    ,recvbl_acct_core_type_cd varchar2(30) -- 收款账户核心类型代码
    ,ppp_tran_flow_num varchar2(250) -- PPP交易流水号
    ,ppp_init_tran_dt date -- PPP原交易日期
    ,ppp_return_info varchar2(1000) -- ppp返回信息
    ,postsc varchar2(1000) -- 附言
    ,valid_flg varchar2(10) -- 有效标志
    ,init_create_dt date -- 最初创建日期
    ,create_teller_id varchar2(100) -- 创建柜员编号
    ,create_teller_name varchar2(500) -- 创建柜员名称
    ,latest_update_dt date -- 最新更新日期
    ,update_teller_id varchar2(100) -- 更新柜员编号
    ,update_teller_name varchar2(500) -- 更新柜员名称
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
grant select on ${iml_schema}.evt_epc_payfan_indent_tran_flow to ${icl_schema};
grant select on ${iml_schema}.evt_epc_payfan_indent_tran_flow to ${idl_schema};
grant select on ${iml_schema}.evt_epc_payfan_indent_tran_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_epc_payfan_indent_tran_flow is '网联代付订单交易流水';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.ser_num is '序列号';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.order_no is '订单号';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.indent_amt is '订单金额';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.tran_status_cd is '交易状态代码';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.sign_ser_num is '签约序列号';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.pay_acct_id is '付款账户编号';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.pay_acct_name is '付款账户名称';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.pay_acct_type_cd is '付款账户类型代码';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.pay_acct_core_type_cd is '付款账户核心类型代码';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.recvbl_acct_id is '收款账户编号';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.recvbl_acct_name is '收款账户名称';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.recvbl_acct_type_cd is '收款账户类型代码';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.recvbl_acct_core_type_cd is '收款账户核心类型代码';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.ppp_tran_flow_num is 'PPP交易流水号';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.ppp_init_tran_dt is 'PPP原交易日期';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.ppp_return_info is 'ppp返回信息';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.postsc is '附言';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.valid_flg is '有效标志';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.init_create_dt is '最初创建日期';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.create_teller_id is '创建柜员编号';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.create_teller_name is '创建柜员名称';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.latest_update_dt is '最新更新日期';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.update_teller_id is '更新柜员编号';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.update_teller_name is '更新柜员名称';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_epc_payfan_indent_tran_flow.etl_timestamp is 'ETL处理时间戳';
