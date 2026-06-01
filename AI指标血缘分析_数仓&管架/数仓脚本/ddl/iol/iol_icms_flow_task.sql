/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_flow_task
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_flow_task
whenever sqlerror continue none;
drop table ${iol_schema}.icms_flow_task purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_flow_task(
    serialno varchar2(128) -- 流程节点编号
    ,endtime date -- 结束时间
    ,riskscanresult varchar2(800) -- 风险探测结果
    ,standardtime1 number(22) -- 标准审批用时
    ,flowstate varchar2(800) -- 流程状态
    ,phasetype varchar2(128) -- 当前阶段类型
    ,phaseopinion1 varchar2(2000) -- 节点意见1
    ,standardtime2 number(22) -- 最长审批用时
    ,phasename varchar2(320) -- 当前阶段名称
    ,applytype varchar2(128) -- 申请类型
    ,relativeobjectno varchar2(128) -- 流程对象流水号
    ,migtflag varchar2(160) -- 迁移标志：crsrcrilcupl
    ,flowname varchar2(320) -- 流程模型名称
    ,orgname varchar2(320) -- 机构名称
    ,relanoticeno varchar2(128) -- 关联意见号
    ,relativeserialno varchar2(128) -- 上一流水号字段
    ,flowno varchar2(128) -- 流程模型编号
    ,forkstate varchar2(72) -- 分支状态
    ,forkno varchar2(128) -- 并行分支编号
    ,phaseopinion4 varchar2(2000) -- 意见详情4
    ,version varchar2(72) -- 版本
    ,clienty number(22) -- 图元Y坐标
    ,width number(22) -- 图元宽度
    ,baseflowno varchar2(128) -- 流程号
    ,phaseopinion varchar2(4000) -- 意见详情
    ,objectno varchar2(128) -- 流程对象编号
    ,phaseno varchar2(128) -- 当前阶段编号
    ,userid varchar2(128) -- 用户编号
    ,processtaskno varchar2(128) -- 流程任务编号
    ,begintime date -- 开始日期
    ,costlob varchar2(128) -- 审批成本归属
    ,allforkno varchar2(800) -- 所有的并行分支编号
    ,groupinfo varchar2(4000) -- 集团信息
    ,objecttype varchar2(128) -- 流程对象任务类型
    ,username varchar2(320) -- 用户名称
    ,orgid varchar2(128) -- 登记机构
    ,owner varchar2(128) -- 所属人
    ,processinstno varchar2(128) -- 流程实例编号
    ,phaseaction varchar2(4000) -- 节点操作
    ,phaseopinion2 varchar2(2000) -- 意见详情2
    ,checklistresult varchar2(800) -- 检查清单结果
    ,autodecision varchar2(800) -- 自动审批判断结果
    ,assignedtaskno varchar2(128) -- 指定任务编号
    ,taskstate varchar2(72) -- 任务状态
    ,parentflowno varchar2(128) -- 父流程号
    ,phasechoice varchar2(2000) -- 阶段意见
    ,phaseopinion3 varchar2(2000) -- 意见详情3
    ,clientx number(22) -- 图元X坐标
    ,heigth number(22) -- 图元高度
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
grant select on ${iol_schema}.icms_flow_task to ${iml_schema};
grant select on ${iol_schema}.icms_flow_task to ${icl_schema};
grant select on ${iol_schema}.icms_flow_task to ${idl_schema};
grant select on ${iol_schema}.icms_flow_task to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_flow_task is '流程任务';
comment on column ${iol_schema}.icms_flow_task.serialno is '流程节点编号';
comment on column ${iol_schema}.icms_flow_task.endtime is '结束时间';
comment on column ${iol_schema}.icms_flow_task.riskscanresult is '风险探测结果';
comment on column ${iol_schema}.icms_flow_task.standardtime1 is '标准审批用时';
comment on column ${iol_schema}.icms_flow_task.flowstate is '流程状态';
comment on column ${iol_schema}.icms_flow_task.phasetype is '当前阶段类型';
comment on column ${iol_schema}.icms_flow_task.phaseopinion1 is '节点意见1';
comment on column ${iol_schema}.icms_flow_task.standardtime2 is '最长审批用时';
comment on column ${iol_schema}.icms_flow_task.phasename is '当前阶段名称';
comment on column ${iol_schema}.icms_flow_task.applytype is '申请类型';
comment on column ${iol_schema}.icms_flow_task.relativeobjectno is '流程对象流水号';
comment on column ${iol_schema}.icms_flow_task.migtflag is '迁移标志：crsrcrilcupl';
comment on column ${iol_schema}.icms_flow_task.flowname is '流程模型名称';
comment on column ${iol_schema}.icms_flow_task.orgname is '机构名称';
comment on column ${iol_schema}.icms_flow_task.relanoticeno is '关联意见号';
comment on column ${iol_schema}.icms_flow_task.relativeserialno is '上一流水号字段';
comment on column ${iol_schema}.icms_flow_task.flowno is '流程模型编号';
comment on column ${iol_schema}.icms_flow_task.forkstate is '分支状态';
comment on column ${iol_schema}.icms_flow_task.forkno is '并行分支编号';
comment on column ${iol_schema}.icms_flow_task.phaseopinion4 is '意见详情4';
comment on column ${iol_schema}.icms_flow_task.version is '版本';
comment on column ${iol_schema}.icms_flow_task.clienty is '图元Y坐标';
comment on column ${iol_schema}.icms_flow_task.width is '图元宽度';
comment on column ${iol_schema}.icms_flow_task.baseflowno is '流程号';
comment on column ${iol_schema}.icms_flow_task.phaseopinion is '意见详情';
comment on column ${iol_schema}.icms_flow_task.objectno is '流程对象编号';
comment on column ${iol_schema}.icms_flow_task.phaseno is '当前阶段编号';
comment on column ${iol_schema}.icms_flow_task.userid is '用户编号';
comment on column ${iol_schema}.icms_flow_task.processtaskno is '流程任务编号';
comment on column ${iol_schema}.icms_flow_task.begintime is '开始日期';
comment on column ${iol_schema}.icms_flow_task.costlob is '审批成本归属';
comment on column ${iol_schema}.icms_flow_task.allforkno is '所有的并行分支编号';
comment on column ${iol_schema}.icms_flow_task.groupinfo is '集团信息';
comment on column ${iol_schema}.icms_flow_task.objecttype is '流程对象任务类型';
comment on column ${iol_schema}.icms_flow_task.username is '用户名称';
comment on column ${iol_schema}.icms_flow_task.orgid is '登记机构';
comment on column ${iol_schema}.icms_flow_task.owner is '所属人';
comment on column ${iol_schema}.icms_flow_task.processinstno is '流程实例编号';
comment on column ${iol_schema}.icms_flow_task.phaseaction is '节点操作';
comment on column ${iol_schema}.icms_flow_task.phaseopinion2 is '意见详情2';
comment on column ${iol_schema}.icms_flow_task.checklistresult is '检查清单结果';
comment on column ${iol_schema}.icms_flow_task.autodecision is '自动审批判断结果';
comment on column ${iol_schema}.icms_flow_task.assignedtaskno is '指定任务编号';
comment on column ${iol_schema}.icms_flow_task.taskstate is '任务状态';
comment on column ${iol_schema}.icms_flow_task.parentflowno is '父流程号';
comment on column ${iol_schema}.icms_flow_task.phasechoice is '阶段意见';
comment on column ${iol_schema}.icms_flow_task.phaseopinion3 is '意见详情3';
comment on column ${iol_schema}.icms_flow_task.clientx is '图元X坐标';
comment on column ${iol_schema}.icms_flow_task.heigth is '图元高度';
comment on column ${iol_schema}.icms_flow_task.start_dt is '开始时间';
comment on column ${iol_schema}.icms_flow_task.end_dt is '结束时间';
comment on column ${iol_schema}.icms_flow_task.id_mark is '增删标志';
comment on column ${iol_schema}.icms_flow_task.etl_timestamp is 'ETL处理时间戳';
