/*
Purpose:    近源模型层-流水表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol itsm_act_hi_procinst
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.itsm_act_hi_procinst
whenever sqlerror continue none;
drop table ${iol_schema}.itsm_act_hi_procinst purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.itsm_act_hi_procinst(
    id_ varchar2(96) -- 序号
    ,rev_ number(22) -- 类型
    ,proc_inst_id_ varchar2(96) -- 任务句柄
    ,business_key_ varchar2(383) -- 工单ID
    ,proc_def_id_ varchar2(96) -- 模型编号
    ,start_time_ date -- 流程创建时间
    ,end_time_ date -- 流程结束时间
    ,duration_ number(22) -- 
    ,start_user_id_ varchar2(383) -- 创建流程用户
    ,start_act_id_ varchar2(383) -- 开始标志
    ,end_act_id_ varchar2(383) -- 结束标志
    ,super_process_instance_id_ varchar2(96) -- 
    ,delete_reason_ varchar2(4000) -- 删除原因
    ,tenant_id_ varchar2(383) -- 
    ,name_ varchar2(383) -- 
    ,callback_id_ varchar2(383) -- 
    ,callback_type_ varchar2(383) -- 
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
grant select on ${iol_schema}.itsm_act_hi_procinst to ${iml_schema};
grant select on ${iol_schema}.itsm_act_hi_procinst to ${icl_schema};
grant select on ${iol_schema}.itsm_act_hi_procinst to ${idl_schema};
grant select on ${iol_schema}.itsm_act_hi_procinst to ${iel_schema};

-- comment
comment on table ${iol_schema}.itsm_act_hi_procinst is '流程引擎注册表';
comment on column ${iol_schema}.itsm_act_hi_procinst.id_ is '序号';
comment on column ${iol_schema}.itsm_act_hi_procinst.rev_ is '类型';
comment on column ${iol_schema}.itsm_act_hi_procinst.proc_inst_id_ is '任务句柄';
comment on column ${iol_schema}.itsm_act_hi_procinst.business_key_ is '工单ID';
comment on column ${iol_schema}.itsm_act_hi_procinst.proc_def_id_ is '模型编号';
comment on column ${iol_schema}.itsm_act_hi_procinst.start_time_ is '流程创建时间';
comment on column ${iol_schema}.itsm_act_hi_procinst.end_time_ is '流程结束时间';
comment on column ${iol_schema}.itsm_act_hi_procinst.duration_ is '';
comment on column ${iol_schema}.itsm_act_hi_procinst.start_user_id_ is '创建流程用户';
comment on column ${iol_schema}.itsm_act_hi_procinst.start_act_id_ is '开始标志';
comment on column ${iol_schema}.itsm_act_hi_procinst.end_act_id_ is '结束标志';
comment on column ${iol_schema}.itsm_act_hi_procinst.super_process_instance_id_ is '';
comment on column ${iol_schema}.itsm_act_hi_procinst.delete_reason_ is '删除原因';
comment on column ${iol_schema}.itsm_act_hi_procinst.tenant_id_ is '';
comment on column ${iol_schema}.itsm_act_hi_procinst.name_ is '';
comment on column ${iol_schema}.itsm_act_hi_procinst.callback_id_ is '';
comment on column ${iol_schema}.itsm_act_hi_procinst.callback_type_ is '';
comment on column ${iol_schema}.itsm_act_hi_procinst.etl_dt is 'ETL处理日期';
comment on column ${iol_schema}.itsm_act_hi_procinst.etl_timestamp is 'ETL处理时间戳';
