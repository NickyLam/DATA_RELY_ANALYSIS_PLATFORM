/*
Purpose:    应用集市层-建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py idl pcls_wf_flow_node_exec_log
CreateDate: 20250516
FileType:   DDL
Logs:
*/

whenever sqlerror continue none;
drop table ${idl_schema}.pcls_wf_flow_node_exec_log purge;
whenever sqlerror exit sql.sqlcode;

create table ${idl_schema}.pcls_wf_flow_node_exec_log(
etl_dt date --数据日期
,id number(22) --主键
,log_no varchar2(4000) --执行记录编码
,flow_no varchar2(4000) --工作流流程号
,node_no varchar2(4000) --节点编码
,biz_no varchar2(4000) --主申请编号
,sub_biz_no varchar2(4000) --子申请编号
,org_no varchar2(4000) --所属机构编号
,sub_org_no varchar2(4000) --子机构编码
,channel_no varchar2(4000) --所属渠道
,product_code varchar2(4000) --所属产品
,biz_type varchar2(4000) --流程类型appl/draw/cas/xx待定
,sub_biz_type varchar2(4000) --子流程类型
,instance_no varchar2(4000) --工作流实例编号
,exec_status varchar2(4000) --waitting：等待执行，running：执行中,finish:执行结束,fail:失败,hang_up：挂起,block：异常挂起
,exec_fail_num number(22) --异常次数
,params varchar2(4000) --上下文变量
,date_begin date --开始时间
,date_end date --结束时间
,date_created timestamp(6) --创建时间
,created_by varchar2(4000) --创建人
,date_updated timestamp(6) --修改时间
,updated_by varchar2(4000) --修改人

)
partition by list(etl_dt)(
    partition p_19000101 values (to_date('19000101','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${idl_schema}.pcls_wf_flow_node_exec_log to ${iel_schema};

-- comment
comment on table ${idl_schema}.pcls_wf_flow_node_exec_log is '工作流执行节点表';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.etl_dt is '数据日期';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.id is '主键';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.log_no is '执行记录编码';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.flow_no is '工作流流程号';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.node_no is '节点编码';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.biz_no is '主申请编号';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.sub_biz_no is '子申请编号';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.org_no is '所属机构编号';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.sub_org_no is '子机构编码';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.channel_no is '所属渠道';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.product_code is '所属产品';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.biz_type is '流程类型appl/draw/cas/xx待定';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.sub_biz_type is '子流程类型';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.instance_no is '工作流实例编号';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.exec_status is 'waitting：等待执行，running：执行中,finish:执行结束,fail:失败,hang_up：挂起,block：异常挂起';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.exec_fail_num is '异常次数';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.params is '上下文变量';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.date_begin is '开始时间';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.date_end is '结束时间';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.date_created is '创建时间';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.created_by is '创建人';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.date_updated is '修改时间';
comment on column ${idl_schema}.pcls_wf_flow_node_exec_log.updated_by is '修改人';

