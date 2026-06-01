/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_wld_syn_adj_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_wld_syn_adj_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_wld_syn_adj_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_wld_syn_adj_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_doc_name varchar2(750) -- 批量文件名称
    ,seq_num varchar2(60) -- 序号
    ,bus_flow_num varchar2(100) -- 业务流水号
    ,syn_id varchar2(100) -- 银团编号
    ,bank_id varchar2(100) -- 银行编号
    ,tran_type_cd varchar2(30) -- 交易类型代码
    ,logic_card_no varchar2(60) -- 逻辑卡号
    ,exc_resv_clear_amt number(30,2) -- 备付金清算金额
    ,cnc_entry_amt number(30,2) -- CNC记账金额
    ,should_adj_bal number(30,8) -- 应调整差额
    ,batch_dt date -- 批量日期
    ,excep_type_cd varchar2(60) -- 异常类型代码
    ,cust_name varchar2(750) -- 客户名称
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
grant select on ${iml_schema}.evt_wld_syn_adj_flow to ${icl_schema};
grant select on ${iml_schema}.evt_wld_syn_adj_flow to ${idl_schema};
grant select on ${iml_schema}.evt_wld_syn_adj_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_wld_syn_adj_flow is '微粒贷银团尾差调整流水';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.batch_doc_name is '批量文件名称';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.seq_num is '序号';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.bus_flow_num is '业务流水号';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.syn_id is '银团编号';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.bank_id is '银行编号';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.tran_type_cd is '交易类型代码';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.logic_card_no is '逻辑卡号';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.exc_resv_clear_amt is '备付金清算金额';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.cnc_entry_amt is 'CNC记账金额';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.should_adj_bal is '应调整差额';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.batch_dt is '批量日期';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.excep_type_cd is '异常类型代码';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.cust_name is '客户名称';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_wld_syn_adj_flow.etl_timestamp is 'ETL处理时间戳';
