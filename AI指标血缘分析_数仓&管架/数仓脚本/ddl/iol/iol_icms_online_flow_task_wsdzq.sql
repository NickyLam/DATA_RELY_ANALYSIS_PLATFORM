/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_online_flow_task_wsdzq
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_online_flow_task_wsdzq
whenever sqlerror continue none;
drop table ${iol_schema}.icms_online_flow_task_wsdzq purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_online_flow_task_wsdzq(
    serialno varchar2(64) -- 流程节点编号
    ,objectno varchar2(64) -- 流程对象编号
    ,uniqueid varchar2(64) -- 唯一标识
    ,stage varchar2(64) -- 产品阶段
    ,relativeserialno varchar2(64) -- 上一流水号字段
    ,flowno varchar2(64) -- 流程模型编号
    ,flowname varchar2(160) -- 流程模型名称
    ,phaseno varchar2(64) -- 当前阶段编号
    ,phasename varchar2(160) -- 当前阶段名称
    ,phasestatus varchar2(2) -- 当前阶段状态
    ,endtime date -- 结束时间
    ,applydate date -- 授信时间
    ,msg varchar2(1000) -- 报错详情
    ,productid varchar2(12) -- 产品编号
    ,otherparam varchar2(2000) -- 其他参数
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
grant select on ${iol_schema}.icms_online_flow_task_wsdzq to ${iml_schema};
grant select on ${iol_schema}.icms_online_flow_task_wsdzq to ${icl_schema};
grant select on ${iol_schema}.icms_online_flow_task_wsdzq to ${idl_schema};
grant select on ${iol_schema}.icms_online_flow_task_wsdzq to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_online_flow_task_wsdzq is '线上流程任务信息表';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.serialno is '流程节点编号';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.objectno is '流程对象编号';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.uniqueid is '唯一标识';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.stage is '产品阶段';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.relativeserialno is '上一流水号字段';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.flowno is '流程模型编号';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.flowname is '流程模型名称';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.phaseno is '当前阶段编号';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.phasename is '当前阶段名称';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.phasestatus is '当前阶段状态';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.endtime is '结束时间';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.applydate is '授信时间';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.msg is '报错详情';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.productid is '产品编号';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.otherparam is '其他参数';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.start_dt is '开始时间';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.end_dt is '结束时间';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.id_mark is '增删标志';
comment on column ${iol_schema}.icms_online_flow_task_wsdzq.etl_timestamp is 'ETL处理时间戳';
