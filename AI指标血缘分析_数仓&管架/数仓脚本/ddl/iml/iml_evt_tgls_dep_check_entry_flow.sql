/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_tgls_dep_check_entry_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_tgls_dep_check_entry_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_tgls_dep_check_entry_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_tgls_dep_check_entry_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(100) -- 法人编号
    ,batch_no varchar2(100) -- 批次号
    ,batch_no_dt date -- 批次号日期
    ,fin_dt date -- 财务日期
    ,sorc_sys_cd varchar2(30) -- 源系统代码
    ,fin_org_id varchar2(100) -- 财务机构编号
    ,amt_type_cd varchar2(30) -- 金额类型代码
    ,curr_cd varchar2(30) -- 币种代码
    ,sob_id varchar2(100) -- 账套编号
    ,acct_id varchar2(100) -- 账户编号
    ,sellbl_prod_id varchar2(100) -- 可售产品编号
    ,cap_char_cd varchar2(30) -- 资金性质代码
    ,bal number(30,2) -- 余额
    ,tran_dir_cd varchar2(30) -- 交易方向代码
    ,tran_amt number(30,2) -- 交易金额
    ,base_prod_id varchar2(100) -- 基础产品编号
    ,core_module varchar2(100) -- 核心模块
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
grant select on ${iml_schema}.evt_tgls_dep_check_entry_flow to ${icl_schema};
grant select on ${iml_schema}.evt_tgls_dep_check_entry_flow to ${idl_schema};
grant select on ${iml_schema}.evt_tgls_dep_check_entry_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_tgls_dep_check_entry_flow is '核算中台存款对账明细';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.batch_no is '批次号';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.batch_no_dt is '批次号日期';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.fin_dt is '财务日期';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.sorc_sys_cd is '源系统代码';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.fin_org_id is '财务机构编号';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.amt_type_cd is '金额类型代码';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.curr_cd is '币种代码';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.sob_id is '账套编号';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.acct_id is '账户编号';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.sellbl_prod_id is '可售产品编号';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.cap_char_cd is '资金性质代码';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.bal is '余额';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.tran_dir_cd is '交易方向代码';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.tran_amt is '交易金额';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.base_prod_id is '基础产品编号';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.core_module is '核心模块';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_tgls_dep_check_entry_flow.etl_timestamp is 'ETL处理时间戳';
