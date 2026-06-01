/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol bdms_tbl_task_his
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.bdms_tbl_task_his
whenever sqlerror continue none;
drop table ${iol_schema}.bdms_tbl_task_his purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_tbl_task_his(
    id varchar2(48) -- 主键ID
    ,task_id varchar2(48) -- 任务编号
    ,process_id varchar2(48) -- 流程实例编号
    ,node_id varchar2(48) -- 节点编号
    ,task_name varchar2(384) -- 任务名称
    ,task_flag number(22) -- 任务完成标志
    ,assign_id varchar2(48) -- 操作员编号
    ,task_description varchar2(384) -- 审批描述
    ,task_comment varchar2(384) -- 备注
    ,create_time varchar2(48) -- 创建时间
    ,taked_time varchar2(48) -- 领用时间
    ,deal_time varchar2(48) -- 处理时间
    ,name1 varchar2(384) -- 备用字段1
    ,name2 varchar2(384) -- 业务批次ID
    ,name3 varchar2(384) -- 备用字段3
    ,name4 varchar2(384) -- 业务汇总金额
    ,name5 varchar2(384) -- 业务机构编号
    ,name6 varchar2(384) -- 上级机构编号
    ,name7 varchar2(384) -- 备用字段7
    ,name8 varchar2(384) -- 备用字段8
    ,task_mark varchar2(48) -- 任务备注
    ,protocol_no varchar2(60) -- 业务协议编号
    ,contract_id varchar2(60) -- 业务批次ID
    ,node_name varchar2(384) -- 节点名称
    ,assign_name varchar2(384) -- 操作员名称
    ,parent_id varchar2(150) -- 父节点ID
    ,approve_flag varchar2(2) -- 审批意见: 1-同意 2-拒绝 3-退回
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
grant select on ${iol_schema}.bdms_tbl_task_his to ${iml_schema};
grant select on ${iol_schema}.bdms_tbl_task_his to ${icl_schema};
grant select on ${iol_schema}.bdms_tbl_task_his to ${idl_schema};
grant select on ${iol_schema}.bdms_tbl_task_his to ${iel_schema};

-- comment
comment on table ${iol_schema}.bdms_tbl_task_his is '审批历史表';
comment on column ${iol_schema}.bdms_tbl_task_his.id is '主键ID';
comment on column ${iol_schema}.bdms_tbl_task_his.task_id is '任务编号';
comment on column ${iol_schema}.bdms_tbl_task_his.process_id is '流程实例编号';
comment on column ${iol_schema}.bdms_tbl_task_his.node_id is '节点编号';
comment on column ${iol_schema}.bdms_tbl_task_his.task_name is '任务名称';
comment on column ${iol_schema}.bdms_tbl_task_his.task_flag is '任务完成标志';
comment on column ${iol_schema}.bdms_tbl_task_his.assign_id is '操作员编号';
comment on column ${iol_schema}.bdms_tbl_task_his.task_description is '审批描述';
comment on column ${iol_schema}.bdms_tbl_task_his.task_comment is '备注';
comment on column ${iol_schema}.bdms_tbl_task_his.create_time is '创建时间';
comment on column ${iol_schema}.bdms_tbl_task_his.taked_time is '领用时间';
comment on column ${iol_schema}.bdms_tbl_task_his.deal_time is '处理时间';
comment on column ${iol_schema}.bdms_tbl_task_his.name1 is '备用字段1';
comment on column ${iol_schema}.bdms_tbl_task_his.name2 is '业务批次ID';
comment on column ${iol_schema}.bdms_tbl_task_his.name3 is '备用字段3';
comment on column ${iol_schema}.bdms_tbl_task_his.name4 is '业务汇总金额';
comment on column ${iol_schema}.bdms_tbl_task_his.name5 is '业务机构编号';
comment on column ${iol_schema}.bdms_tbl_task_his.name6 is '上级机构编号';
comment on column ${iol_schema}.bdms_tbl_task_his.name7 is '备用字段7';
comment on column ${iol_schema}.bdms_tbl_task_his.name8 is '备用字段8';
comment on column ${iol_schema}.bdms_tbl_task_his.task_mark is '任务备注';
comment on column ${iol_schema}.bdms_tbl_task_his.protocol_no is '业务协议编号';
comment on column ${iol_schema}.bdms_tbl_task_his.contract_id is '业务批次ID';
comment on column ${iol_schema}.bdms_tbl_task_his.node_name is '节点名称';
comment on column ${iol_schema}.bdms_tbl_task_his.assign_name is '操作员名称';
comment on column ${iol_schema}.bdms_tbl_task_his.parent_id is '父节点ID';
comment on column ${iol_schema}.bdms_tbl_task_his.approve_flag is '审批意见: 1-同意 2-拒绝 3-退回';
comment on column ${iol_schema}.bdms_tbl_task_his.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.bdms_tbl_task_his.etl_timestamp is 'ETL处理时间戳';
