/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol scps_workitem
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.scps_workitem
whenever sqlerror continue none;
drop table ${iol_schema}.scps_workitem purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_workitem(
    id number(19) -- 工作项id
    ,name varchar2(100) -- 工作项名称
    ,atiid number(19) -- 活动实例id
    ,priid number(19) -- 流程实例id
    ,priname varchar2(100) -- 流程实例名称
    ,executor varchar2(100) -- 执行人
    ,createtime date -- 创建时间
    ,checkouttime date -- 检出时间
    ,checkintime date -- 检入时间
    ,passedtime number(19) -- 耗时
    ,state number(2) -- 状态
    ,description varchar2(100) -- 工作项描述
    ,priority number(10,2) -- 优先级
    ,weightiness number(11) -- 权重
    ,groupid number(11) -- 分组id
    ,appid varchar2(30) -- 应用id
    ,input_time date -- 录入时间
    ,update_time date -- 最后一次修改时间
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
grant select on ${iol_schema}.scps_workitem to ${iml_schema};
grant select on ${iol_schema}.scps_workitem to ${icl_schema};
grant select on ${iol_schema}.scps_workitem to ${idl_schema};
grant select on ${iol_schema}.scps_workitem to ${iel_schema};

-- comment
comment on table ${iol_schema}.scps_workitem is '流程项表';
comment on column ${iol_schema}.scps_workitem.id is '工作项id';
comment on column ${iol_schema}.scps_workitem.name is '工作项名称';
comment on column ${iol_schema}.scps_workitem.atiid is '活动实例id';
comment on column ${iol_schema}.scps_workitem.priid is '流程实例id';
comment on column ${iol_schema}.scps_workitem.priname is '流程实例名称';
comment on column ${iol_schema}.scps_workitem.executor is '执行人';
comment on column ${iol_schema}.scps_workitem.createtime is '创建时间';
comment on column ${iol_schema}.scps_workitem.checkouttime is '检出时间';
comment on column ${iol_schema}.scps_workitem.checkintime is '检入时间';
comment on column ${iol_schema}.scps_workitem.passedtime is '耗时';
comment on column ${iol_schema}.scps_workitem.state is '状态';
comment on column ${iol_schema}.scps_workitem.description is '工作项描述';
comment on column ${iol_schema}.scps_workitem.priority is '优先级';
comment on column ${iol_schema}.scps_workitem.weightiness is '权重';
comment on column ${iol_schema}.scps_workitem.groupid is '分组id';
comment on column ${iol_schema}.scps_workitem.appid is '应用id';
comment on column ${iol_schema}.scps_workitem.input_time is '录入时间';
comment on column ${iol_schema}.scps_workitem.update_time is '最后一次修改时间';
comment on column ${iol_schema}.scps_workitem.start_dt is '开始时间';
comment on column ${iol_schema}.scps_workitem.end_dt is '结束时间';
comment on column ${iol_schema}.scps_workitem.id_mark is '增删标志';
comment on column ${iol_schema}.scps_workitem.etl_timestamp is 'ETL处理时间戳';
