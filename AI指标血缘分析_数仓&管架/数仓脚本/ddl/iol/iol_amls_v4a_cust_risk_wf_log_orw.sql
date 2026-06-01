/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_v4a_cust_risk_wf_log_orw
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_v4a_cust_risk_wf_log_orw
whenever sqlerror continue none;
drop table ${iol_schema}.amls_v4a_cust_risk_wf_log_orw purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_v4a_cust_risk_wf_log_orw(
    opr_dt date -- 操作时间
    ,opr_tm varchar2(24) -- 操作时间
    ,organkey varchar2(18) -- 归属机构
    ,opr_user varchar2(48) -- 经办柜员
    ,realname varchar2(384) -- 经办柜员名称
    ,curr_node_id varchar2(30) -- 操作类型
    ,node_name varchar2(195) -- 操作类型描述
    ,wf_seq varchar2(96) -- 唯一标识
    ,sys_id varchar2(5) -- 系统标识
    ,eft_flag varchar2(3) -- 金融交易类型
    ,serv_flag varchar2(3) -- 业务交易类型
    ,acct_flag varchar2(3) -- 账户交易类型
    ,ca_flag varchar2(3) -- 现金交易类型
    ,bd_flag varchar2(3) -- 存取款交易类型
    ,etl_dt date -- ETL处理日期
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 64k next 64k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.amls_v4a_cust_risk_wf_log_orw to ${iml_schema};
grant select on ${iol_schema}.amls_v4a_cust_risk_wf_log_orw to ${icl_schema};
grant select on ${iol_schema}.amls_v4a_cust_risk_wf_log_orw to ${idl_schema};
grant select on ${iol_schema}.amls_v4a_cust_risk_wf_log_orw to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_v4a_cust_risk_wf_log_orw is '反洗钱客户风险评级系统-业务量统计';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.opr_dt is '操作时间';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.opr_tm is '操作时间';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.organkey is '归属机构';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.opr_user is '经办柜员';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.realname is '经办柜员名称';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.curr_node_id is '操作类型';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.node_name is '操作类型描述';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.wf_seq is '唯一标识';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.sys_id is '系统标识';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.eft_flag is '金融交易类型';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.serv_flag is '业务交易类型';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.acct_flag is '账户交易类型';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.ca_flag is '现金交易类型';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.bd_flag is '存取款交易类型';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_v4a_cust_risk_wf_log_orw.etl_timestamp is 'ETL处理时间戳';
