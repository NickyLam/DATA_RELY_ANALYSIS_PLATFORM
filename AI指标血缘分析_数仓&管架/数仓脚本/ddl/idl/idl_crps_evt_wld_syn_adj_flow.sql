/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl crps_evt_wld_syn_adj_flow
CreateDate: 20230608
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.crps_evt_wld_syn_adj_flow purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.crps_evt_wld_syn_adj_flow(
etl_dt date --etl处理日期
,evt_id varchar2(250) --事件编号
,lp_id varchar2(100) --法人编号
,batch_doc_name varchar2(500) --批量文件名称
,seq_num varchar2(60) --序号
,bus_flow_num varchar2(100) --业务流水号
,syn_id varchar2(100) --银团编号
,bank_id varchar2(100) --银行编号
,tran_type_cd varchar2(30) --交易类型代码
,logic_card_no varchar2(60) --逻辑卡号
,exc_resv_clear_amt number(30,2) --备付金清算金额
,cnc_entry_amt number(30,2) --cnc记账金额
,should_adj_bal number(30,8) --应调整差额
,batch_dt date --批量日期
,excep_type_cd varchar2(60) --异常类型代码
,cust_name varchar2(500) --客户名称

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.crps_evt_wld_syn_adj_flow to ${iel_schema};

-- comment
comment on table ${idl_schema}.crps_evt_wld_syn_adj_flow is '微粒贷银团尾差调整流水';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.etl_dt is 'etl处理日期';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.evt_id is '事件编号';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.lp_id is '法人编号';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.batch_doc_name is '批量文件名称';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.seq_num is '序号';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.bus_flow_num is '业务流水号';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.syn_id is '银团编号';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.bank_id is '银行编号';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.tran_type_cd is '交易类型代码';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.logic_card_no is '逻辑卡号';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.exc_resv_clear_amt is '备付金清算金额';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.cnc_entry_amt is 'cnc记账金额';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.should_adj_bal is '应调整差额';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.batch_dt is '批量日期';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.excep_type_cd is '异常类型代码';
comment on column ${idl_schema}.crps_evt_wld_syn_adj_flow.cust_name is '客户名称';

