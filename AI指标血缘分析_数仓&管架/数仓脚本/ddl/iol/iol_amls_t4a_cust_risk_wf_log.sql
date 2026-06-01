/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol amls_t4a_cust_risk_wf_log
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.amls_t4a_cust_risk_wf_log
whenever sqlerror continue none;
drop table ${iol_schema}.amls_t4a_cust_risk_wf_log purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amls_t4a_cust_risk_wf_log(
    rslt_id varchar2(72) -- 评级结果id
    ,stat_dt date -- 评级日期
    ,wf_seq varchar2(72) -- 流程序号
    ,cust_id varchar2(48) -- 客户号
    ,curr_lvl varchar2(24) -- 调整前风险等级
    ,curr_node_id varchar2(30) -- 当前节点
    ,curr_sts varchar2(2) -- 当前状态
    ,curr_post_id varchar2(15) -- 当前岗位
    ,curr_org_id varchar2(30) -- 当前岗位所处机构
    ,flow_id varchar2(15) -- 流程id
    ,next_lvl varchar2(24) -- 调整后风险等级
    ,next_node_id varchar2(30) -- 下一节点
    ,next_sts varchar2(2) -- 下一状态
    ,next_post_id varchar2(15) -- 下一个岗位
    ,next_org_id varchar2(30) -- 下一岗位所处机构
    ,opr_tm varchar2(29) -- 操作时间
    ,opr_user varchar2(48) -- 当前操作人
    ,advice varchar2(3900) -- 意见
    ,opr_id varchar2(30) -- 
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
grant select on ${iol_schema}.amls_t4a_cust_risk_wf_log to ${iml_schema};
grant select on ${iol_schema}.amls_t4a_cust_risk_wf_log to ${icl_schema};
grant select on ${iol_schema}.amls_t4a_cust_risk_wf_log to ${idl_schema};
grant select on ${iol_schema}.amls_t4a_cust_risk_wf_log to ${iel_schema};

-- comment
comment on table ${iol_schema}.amls_t4a_cust_risk_wf_log is '反洗钱';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.rslt_id is '评级结果id';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.stat_dt is '评级日期';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.wf_seq is '流程序号';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.cust_id is '客户号';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.curr_lvl is '调整前风险等级';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.curr_node_id is '当前节点';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.curr_sts is '当前状态';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.curr_post_id is '当前岗位';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.curr_org_id is '当前岗位所处机构';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.flow_id is '流程id';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.next_lvl is '调整后风险等级';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.next_node_id is '下一节点';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.next_sts is '下一状态';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.next_post_id is '下一个岗位';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.next_org_id is '下一岗位所处机构';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.opr_tm is '操作时间';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.opr_user is '当前操作人';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.advice is '意见';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.opr_id is '';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.amls_t4a_cust_risk_wf_log.etl_timestamp is 'ETL处理时间戳';
