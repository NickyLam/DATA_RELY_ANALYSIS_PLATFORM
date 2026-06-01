/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_form_suggestion
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_form_suggestion
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_form_suggestion purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_form_suggestion(
    suggestion_id varchar2(30) -- 审批意见标识
    ,party_id varchar2(30) -- 人员ID
    ,node_id varchar2(30) -- 节点ID
    ,organ_code varchar2(30) -- 机构
    ,process_ins_id varchar2(90) -- 流程实体ID
    ,suggestion_time timestamp -- 审批时间
    ,last_updated_stamp timestamp -- 最后更新时间
    ,last_updated_tx_stamp timestamp -- 最后更新事务时间
    ,created_stamp timestamp -- 创建时间
    ,created_tx_stamp timestamp -- 创建事务时间
    ,party_id_dummy varchar2(30) -- 人员-迁移用
    ,organ_code_dummy varchar2(383) -- 机构-迁移用
    ,assignee_role_id varchar2(30) -- 处理人角色
    ,suggestion varchar2(4000) -- 审批意见
    ,act_ru_task_id varchar2(90) -- 任务ID
    ,start_dt date -- 开始时间
    ,end_dt date -- 结束时间
    ,id_mark varchar2(10) -- 增删标志
    ,etl_timestamp timestamp -- ETL处理时间戳
)
partition by list(end_dt)(
     partition p_19000101 values (to_date('19000101','yyyymmdd')),
     partition p_20991231 values (to_date('20991231','yyyymmdd'))
)
storage (initial 1024k next 1024k)
compress ${option_switch} for query high
nologging
;

-- grant
grant select on ${iol_schema}.noas_oa_form_suggestion to ${iml_schema};
grant select on ${iol_schema}.noas_oa_form_suggestion to ${icl_schema};
grant select on ${iol_schema}.noas_oa_form_suggestion to ${idl_schema};
grant select on ${iol_schema}.noas_oa_form_suggestion to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_form_suggestion is '表单意见表';
comment on column ${iol_schema}.noas_oa_form_suggestion.suggestion_id is '审批意见标识';
comment on column ${iol_schema}.noas_oa_form_suggestion.party_id is '人员ID';
comment on column ${iol_schema}.noas_oa_form_suggestion.node_id is '节点ID';
comment on column ${iol_schema}.noas_oa_form_suggestion.organ_code is '机构';
comment on column ${iol_schema}.noas_oa_form_suggestion.process_ins_id is '流程实体ID';
comment on column ${iol_schema}.noas_oa_form_suggestion.suggestion_time is '审批时间';
comment on column ${iol_schema}.noas_oa_form_suggestion.last_updated_stamp is '最后更新时间';
comment on column ${iol_schema}.noas_oa_form_suggestion.last_updated_tx_stamp is '最后更新事务时间';
comment on column ${iol_schema}.noas_oa_form_suggestion.created_stamp is '创建时间';
comment on column ${iol_schema}.noas_oa_form_suggestion.created_tx_stamp is '创建事务时间';
comment on column ${iol_schema}.noas_oa_form_suggestion.party_id_dummy is '人员-迁移用';
comment on column ${iol_schema}.noas_oa_form_suggestion.organ_code_dummy is '机构-迁移用';
comment on column ${iol_schema}.noas_oa_form_suggestion.assignee_role_id is '处理人角色';
comment on column ${iol_schema}.noas_oa_form_suggestion.suggestion is '审批意见';
comment on column ${iol_schema}.noas_oa_form_suggestion.act_ru_task_id is '任务ID';
comment on column ${iol_schema}.noas_oa_form_suggestion.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_form_suggestion.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_form_suggestion.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_form_suggestion.etl_timestamp is 'ETL处理时间戳';
