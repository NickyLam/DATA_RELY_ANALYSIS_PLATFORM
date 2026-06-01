/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_unionpay_comm_fee_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_unionpay_comm_fee_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_unionpay_comm_fee_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_unionpay_comm_fee_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,org_id varchar2(100) -- 机构编号
    ,unionpay_tran_type_cd varchar2(30) -- 银联交易类型代码
    ,trader_type_cd varchar2(30) -- 交易方类型代码
    ,tran_dt date -- 交易日期
    ,int_paybl_amt number(30,2) -- 应付金额
    ,recvbl_amt number(30,2) -- 应收金额
    ,front_dt date -- 前置日期
    ,front_flow_num varchar2(100) -- 前置流水号
    ,core_tran_flow_num varchar2(100) -- 核心交易流水号
    ,core_tran_dt date -- 核心交易日期
    ,unionpay_front_tran_status_cd varchar2(30) -- 银联前置交易状态代码
    ,err_cd varchar2(90) -- 错误码
    ,err_info_desc varchar2(750) -- 错误信息描述
    ,paybl_exch_fee number(30,2) -- 应付交换费
    ,recvbl_exch_fee number(30,2) -- 应收交换费
    ,tran_clear_fee number(30,2) -- 转接清算费
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
grant select on ${iml_schema}.evt_unionpay_comm_fee_flow to ${icl_schema};
grant select on ${iml_schema}.evt_unionpay_comm_fee_flow to ${idl_schema};
grant select on ${iml_schema}.evt_unionpay_comm_fee_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_unionpay_comm_fee_flow is '银联手续费流水';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.org_id is '机构编号';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.unionpay_tran_type_cd is '银联交易类型代码';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.trader_type_cd is '交易方类型代码';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.tran_dt is '交易日期';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.int_paybl_amt is '应付金额';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.recvbl_amt is '应收金额';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.front_dt is '前置日期';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.front_flow_num is '前置流水号';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.core_tran_flow_num is '核心交易流水号';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.core_tran_dt is '核心交易日期';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.unionpay_front_tran_status_cd is '银联前置交易状态代码';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.err_cd is '错误码';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.err_info_desc is '错误信息描述';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.paybl_exch_fee is '应付交换费';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.recvbl_exch_fee is '应收交换费';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.tran_clear_fee is '转接清算费';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_unionpay_comm_fee_flow.etl_timestamp is 'ETL处理时间戳';
