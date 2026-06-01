/*
Purpose:    整合模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iml evt_seal_acct_mgmt_jnl_flow
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow
whenever sqlerror continue none;
drop table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow purge;

whenever sqlerror exit sql.sqlcode;
create table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow(
    evt_id varchar2(250) -- 事件编号
    ,lp_id varchar2(60) -- 法人编号
    ,flow_num varchar2(100) -- 流水号
    ,oper_type_cd varchar2(30) -- 操作类型代码
    ,oper_teller_id varchar2(100) -- 操作柜员编号
    ,oper_dt date -- 操作日期
    ,oper_tm timestamp -- 操作时间
    ,brac_id varchar2(100) -- 网点编号
    ,remark varchar2(4000) -- 备注
    ,opered_acct_id varchar2(100) -- 被操作账户编号
    ,opered_acct_name varchar2(1500) -- 被操作账户名称
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
grant select on ${iml_schema}.evt_seal_acct_mgmt_jnl_flow to ${icl_schema};
grant select on ${iml_schema}.evt_seal_acct_mgmt_jnl_flow to ${idl_schema};
grant select on ${iml_schema}.evt_seal_acct_mgmt_jnl_flow to ${iel_schema};

-- comment
comment on table ${iml_schema}.evt_seal_acct_mgmt_jnl_flow is '验印账户管理日志流水';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.evt_id is '事件编号';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.lp_id is '法人编号';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.flow_num is '流水号';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.oper_type_cd is '操作类型代码';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.oper_teller_id is '操作柜员编号';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.oper_dt is '操作日期';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.oper_tm is '操作时间';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.brac_id is '网点编号';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.remark is '备注';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.opered_acct_id is '被操作账户编号';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.opered_acct_name is '被操作账户名称';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.etl_dt is 'ETL处理日期';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.src_table_name is '源表名称';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.job_cd is '任务编码';
comment on column ${iml_schema}.evt_seal_acct_mgmt_jnl_flow.etl_timestamp is 'ETL处理时间戳';
