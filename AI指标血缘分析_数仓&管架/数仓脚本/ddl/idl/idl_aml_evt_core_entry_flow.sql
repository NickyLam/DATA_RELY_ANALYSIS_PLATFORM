/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl aml_evt_core_entry_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${idl_schema}.aml_evt_core_entry_flow
whenever sqlerror continue none;
drop table ${idl_schema}.aml_evt_core_entry_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${idl_schema}.aml_evt_core_entry_flow(
    etl_dt date -- 数据日期
    ,evt_id varchar2(60) -- 事件编号
    ,tran_id varchar2(60) -- 交易编号
    ,tran_dt date -- 交易日期
    ,lp_id varchar2(60) -- 法人编号
    ,org_id varchar2(60) -- 机构编号
    ,entry_cancel_flg varchar2(10) -- 记账取消标志
    ,entry_flow_num varchar2(60) -- 记账流水号
    ,hxp_tran_flg varchar2(10) -- 补记交易标志
    ,msg_send_status_cd varchar2(10) -- 报文发送状态代码
    ,err_cd varchar2(10) -- 错误代码
    ,err_rs varchar2(100) -- 错误原因
    ,bus_type_cd varchar2(10) -- 业务类型代码
    ,buy_dtl_id varchar2(60) -- 买入明细编号
    ,bill_id varchar2(60) -- 票据编号
    ,cont_id varchar2(60) -- 合同编号
    ,entry_way_cd varchar2(10) -- 记账方式代码
    ,final_modif_operr_id varchar2(60) -- 最后修改操作员编号
    ,final_modif_tm timestamp -- 最后修改时间
    ,bill_uniq_ind_no varchar2(60) -- 票据唯一标识号
    ,forgn_sys_bill_uniq_ind_no varchar2(60) -- 对外系统票据唯一标识号
    ,entry_step_seq_num varchar2(10) -- 记账步骤序号
    ,sugst_pay_appl_flow_num varchar2(60) -- 提示付款申请流水号
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
grant select on ${idl_schema}.aml_evt_core_entry_flow to ${iel_schema};

-- comment
comment on table ${idl_schema}.aml_evt_core_entry_flow is '核心记账流水事件';
comment on column ${idl_schema}.aml_evt_core_entry_flow.etl_dt is '数据日期';
comment on column ${idl_schema}.aml_evt_core_entry_flow.evt_id is '事件编号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.tran_id is '交易编号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.tran_dt is '交易日期';
comment on column ${idl_schema}.aml_evt_core_entry_flow.lp_id is '法人编号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.org_id is '机构编号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.entry_cancel_flg is '记账取消标志';
comment on column ${idl_schema}.aml_evt_core_entry_flow.entry_flow_num is '记账流水号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.hxp_tran_flg is '补记交易标志';
comment on column ${idl_schema}.aml_evt_core_entry_flow.msg_send_status_cd is '报文发送状态代码';
comment on column ${idl_schema}.aml_evt_core_entry_flow.err_cd is '错误代码';
comment on column ${idl_schema}.aml_evt_core_entry_flow.err_rs is '错误原因';
comment on column ${idl_schema}.aml_evt_core_entry_flow.bus_type_cd is '业务类型代码';
comment on column ${idl_schema}.aml_evt_core_entry_flow.buy_dtl_id is '买入明细编号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.bill_id is '票据编号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.cont_id is '合同编号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.entry_way_cd is '记账方式代码';
comment on column ${idl_schema}.aml_evt_core_entry_flow.final_modif_operr_id is '最后修改操作员编号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.final_modif_tm is '最后修改时间';
comment on column ${idl_schema}.aml_evt_core_entry_flow.bill_uniq_ind_no is '票据唯一标识号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.forgn_sys_bill_uniq_ind_no is '对外系统票据唯一标识号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.entry_step_seq_num is '记账步骤序号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.sugst_pay_appl_flow_num is '提示付款申请流水号';
comment on column ${idl_schema}.aml_evt_core_entry_flow.job_cd is '任务代码';
comment on column ${idl_schema}.aml_evt_core_entry_flow.etl_timestamp is '数据处理时间';
