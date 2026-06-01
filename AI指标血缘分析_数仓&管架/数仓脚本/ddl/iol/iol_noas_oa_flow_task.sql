/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol noas_oa_flow_task
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.noas_oa_flow_task
whenever sqlerror continue none;
drop table ${iol_schema}.noas_oa_flow_task purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_flow_task(
    oa_flow_task_id varchar2(180) -- 
    ,task_name varchar2(4000) -- 
    ,flow_type_id varchar2(60) -- 
    ,assignee varchar2(60) -- 
    ,assignee_organ_code varchar2(60) -- 
    ,assign_date timestamp -- 
    ,completed_date timestamp -- 
    ,drafted_party_id varchar2(60) -- 
    ,drafted_party_organ_code varchar2(60) -- 
    ,drafted_date timestamp -- 
    ,urgency varchar2(60) -- 
    ,task_status varchar2(60) -- 
    ,task_url varchar2(765) -- 
    ,process_instance_id varchar2(180) -- 
    ,batch_no varchar2(765) -- 
    ,act_ru_task_id varchar2(180) -- 
    ,oa_node_id varchar2(60) -- 
    ,parent_flow_task_id varchar2(180) -- 
    ,parent_task_party_id varchar2(60) -- 
    ,is_wait varchar2(60) -- 
    ,notes varchar2(765) -- 
    ,last_updated_stamp timestamp -- 
    ,last_updated_tx_stamp timestamp -- 
    ,created_stamp timestamp -- 
    ,created_tx_stamp timestamp -- 
    ,current_state varchar2(765) -- 
    ,assignee_role_id varchar2(60) -- 
    ,drafted_party_organ_code_dummy varchar2(765) -- 
    ,assignee_dummy varchar2(60) -- 
    ,drafted_party_id_dummy varchar2(60) -- 
    ,assignee_organ_code_dummy varchar2(765) -- 
    ,complete_channel varchar2(30) -- 
    ,data_year varchar2(30) -- 
    ,authorizer varchar2(60) -- 
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
grant select on ${iol_schema}.noas_oa_flow_task to ${iml_schema};
grant select on ${iol_schema}.noas_oa_flow_task to ${icl_schema};
grant select on ${iol_schema}.noas_oa_flow_task to ${idl_schema};
grant select on ${iol_schema}.noas_oa_flow_task to ${iel_schema};

-- comment
comment on table ${iol_schema}.noas_oa_flow_task is '';
comment on column ${iol_schema}.noas_oa_flow_task.oa_flow_task_id is '';
comment on column ${iol_schema}.noas_oa_flow_task.task_name is '';
comment on column ${iol_schema}.noas_oa_flow_task.flow_type_id is '';
comment on column ${iol_schema}.noas_oa_flow_task.assignee is '';
comment on column ${iol_schema}.noas_oa_flow_task.assignee_organ_code is '';
comment on column ${iol_schema}.noas_oa_flow_task.assign_date is '';
comment on column ${iol_schema}.noas_oa_flow_task.completed_date is '';
comment on column ${iol_schema}.noas_oa_flow_task.drafted_party_id is '';
comment on column ${iol_schema}.noas_oa_flow_task.drafted_party_organ_code is '';
comment on column ${iol_schema}.noas_oa_flow_task.drafted_date is '';
comment on column ${iol_schema}.noas_oa_flow_task.urgency is '';
comment on column ${iol_schema}.noas_oa_flow_task.task_status is '';
comment on column ${iol_schema}.noas_oa_flow_task.task_url is '';
comment on column ${iol_schema}.noas_oa_flow_task.process_instance_id is '';
comment on column ${iol_schema}.noas_oa_flow_task.batch_no is '';
comment on column ${iol_schema}.noas_oa_flow_task.act_ru_task_id is '';
comment on column ${iol_schema}.noas_oa_flow_task.oa_node_id is '';
comment on column ${iol_schema}.noas_oa_flow_task.parent_flow_task_id is '';
comment on column ${iol_schema}.noas_oa_flow_task.parent_task_party_id is '';
comment on column ${iol_schema}.noas_oa_flow_task.is_wait is '';
comment on column ${iol_schema}.noas_oa_flow_task.notes is '';
comment on column ${iol_schema}.noas_oa_flow_task.last_updated_stamp is '';
comment on column ${iol_schema}.noas_oa_flow_task.last_updated_tx_stamp is '';
comment on column ${iol_schema}.noas_oa_flow_task.created_stamp is '';
comment on column ${iol_schema}.noas_oa_flow_task.created_tx_stamp is '';
comment on column ${iol_schema}.noas_oa_flow_task.current_state is '';
comment on column ${iol_schema}.noas_oa_flow_task.assignee_role_id is '';
comment on column ${iol_schema}.noas_oa_flow_task.drafted_party_organ_code_dummy is '';
comment on column ${iol_schema}.noas_oa_flow_task.assignee_dummy is '';
comment on column ${iol_schema}.noas_oa_flow_task.drafted_party_id_dummy is '';
comment on column ${iol_schema}.noas_oa_flow_task.assignee_organ_code_dummy is '';
comment on column ${iol_schema}.noas_oa_flow_task.complete_channel is '';
comment on column ${iol_schema}.noas_oa_flow_task.data_year is '';
comment on column ${iol_schema}.noas_oa_flow_task.authorizer is '';
comment on column ${iol_schema}.noas_oa_flow_task.start_dt is '开始时间';
comment on column ${iol_schema}.noas_oa_flow_task.end_dt is '结束时间';
comment on column ${iol_schema}.noas_oa_flow_task.id_mark is '增删标志';
comment on column ${iol_schema}.noas_oa_flow_task.etl_timestamp is 'ETL处理时间戳';
