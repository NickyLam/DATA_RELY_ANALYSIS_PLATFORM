/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol abss_flow_task
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.abss_flow_task
whenever sqlerror continue none;
drop table ${iol_schema}.abss_flow_task purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_flow_task(
    serialno varchar2(48) -- 流水号
    ,objectno varchar2(48) -- 对象编号
    ,objecttype varchar2(60) -- 对象类型
    ,relativeserialno varchar2(48) -- 上一流水号
    ,flowno varchar2(48) -- 流程编号
    ,flowname varchar2(120) -- 流程名称
    ,phaseno varchar2(48) -- 阶段编号
    ,phasename varchar2(120) -- 阶段名称
    ,phasetype varchar2(27) -- 阶段类型
    ,applytype varchar2(60) -- 申请类型
    ,userid varchar2(48) -- 承办人编号
    ,username varchar2(120) -- 承办人姓名
    ,orgid varchar2(48) -- 承办机构编号
    ,orgname varchar2(120) -- 承办机构名称
    ,begintime varchar2(30) -- 开始执行时间
    ,endtime varchar2(30) -- 完成执行时间
    ,phasechoice varchar2(120) -- 阶段意见
    ,phaseaction varchar2(750) -- 阶段动作
    ,phaseopinion varchar2(4000) -- 意见详情
    ,phaseopinion1 varchar2(375) -- 意见详情1
    ,phaseopinion2 varchar2(375) -- 意见详情2
    ,phaseopinion3 varchar2(375) -- 意见详情3
    ,phaseopinion4 varchar2(375) -- 意见详情4
    ,checklistresult varchar2(120) -- 检查清单结果
    ,autodecision varchar2(120) -- 自动审批判断结果
    ,riskscanresult varchar2(120) -- 风险探测结果
    ,standardtime1 varchar2(48) -- 标准审批用时
    ,standardtime2 varchar2(48) -- 最长审批用时
    ,costlob varchar2(48) -- 审批成本归属
    ,clientx number -- 图元X坐标
    ,clienty number -- 图元Y坐标
    ,width number -- 图元宽度
    ,heigth number -- 图元高度
    ,groupinfo varchar2(1500) -- 分组信息
    ,processinstno varchar2(48) -- 流程实例
    ,processtaskno varchar2(48) -- 任务编号
    ,relativeobjectno varchar2(48) -- 关联对象编号
    ,flowstate varchar2(120) -- 工作流状态
    ,forkstate varchar2(9) -- 
    ,version varchar2(15) -- 系统未使用
    ,baseflowno varchar2(48) -- 基础流程编号
    ,taskstate varchar2(9) -- 任务状态
    ,forkno varchar2(30) -- 
    ,allforkno varchar2(120) -- 
    ,parentflowno varchar2(96) -- 父流程编号
    ,assignedtaskno varchar2(480) -- 
    ,relanoticeno varchar2(60) -- 
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
grant select on ${iol_schema}.abss_flow_task to ${iml_schema};
grant select on ${iol_schema}.abss_flow_task to ${icl_schema};
grant select on ${iol_schema}.abss_flow_task to ${idl_schema};
grant select on ${iol_schema}.abss_flow_task to ${iel_schema};

-- comment
comment on table ${iol_schema}.abss_flow_task is '流程阶段数据';
comment on column ${iol_schema}.abss_flow_task.serialno is '流水号';
comment on column ${iol_schema}.abss_flow_task.objectno is '对象编号';
comment on column ${iol_schema}.abss_flow_task.objecttype is '对象类型';
comment on column ${iol_schema}.abss_flow_task.relativeserialno is '上一流水号';
comment on column ${iol_schema}.abss_flow_task.flowno is '流程编号';
comment on column ${iol_schema}.abss_flow_task.flowname is '流程名称';
comment on column ${iol_schema}.abss_flow_task.phaseno is '阶段编号';
comment on column ${iol_schema}.abss_flow_task.phasename is '阶段名称';
comment on column ${iol_schema}.abss_flow_task.phasetype is '阶段类型';
comment on column ${iol_schema}.abss_flow_task.applytype is '申请类型';
comment on column ${iol_schema}.abss_flow_task.userid is '承办人编号';
comment on column ${iol_schema}.abss_flow_task.username is '承办人姓名';
comment on column ${iol_schema}.abss_flow_task.orgid is '承办机构编号';
comment on column ${iol_schema}.abss_flow_task.orgname is '承办机构名称';
comment on column ${iol_schema}.abss_flow_task.begintime is '开始执行时间';
comment on column ${iol_schema}.abss_flow_task.endtime is '完成执行时间';
comment on column ${iol_schema}.abss_flow_task.phasechoice is '阶段意见';
comment on column ${iol_schema}.abss_flow_task.phaseaction is '阶段动作';
comment on column ${iol_schema}.abss_flow_task.phaseopinion is '意见详情';
comment on column ${iol_schema}.abss_flow_task.phaseopinion1 is '意见详情1';
comment on column ${iol_schema}.abss_flow_task.phaseopinion2 is '意见详情2';
comment on column ${iol_schema}.abss_flow_task.phaseopinion3 is '意见详情3';
comment on column ${iol_schema}.abss_flow_task.phaseopinion4 is '意见详情4';
comment on column ${iol_schema}.abss_flow_task.checklistresult is '检查清单结果';
comment on column ${iol_schema}.abss_flow_task.autodecision is '自动审批判断结果';
comment on column ${iol_schema}.abss_flow_task.riskscanresult is '风险探测结果';
comment on column ${iol_schema}.abss_flow_task.standardtime1 is '标准审批用时';
comment on column ${iol_schema}.abss_flow_task.standardtime2 is '最长审批用时';
comment on column ${iol_schema}.abss_flow_task.costlob is '审批成本归属';
comment on column ${iol_schema}.abss_flow_task.clientx is '图元X坐标';
comment on column ${iol_schema}.abss_flow_task.clienty is '图元Y坐标';
comment on column ${iol_schema}.abss_flow_task.width is '图元宽度';
comment on column ${iol_schema}.abss_flow_task.heigth is '图元高度';
comment on column ${iol_schema}.abss_flow_task.groupinfo is '分组信息';
comment on column ${iol_schema}.abss_flow_task.processinstno is '流程实例';
comment on column ${iol_schema}.abss_flow_task.processtaskno is '任务编号';
comment on column ${iol_schema}.abss_flow_task.relativeobjectno is '关联对象编号';
comment on column ${iol_schema}.abss_flow_task.flowstate is '工作流状态';
comment on column ${iol_schema}.abss_flow_task.forkstate is '';
comment on column ${iol_schema}.abss_flow_task.version is '系统未使用';
comment on column ${iol_schema}.abss_flow_task.baseflowno is '基础流程编号';
comment on column ${iol_schema}.abss_flow_task.taskstate is '任务状态';
comment on column ${iol_schema}.abss_flow_task.forkno is '';
comment on column ${iol_schema}.abss_flow_task.allforkno is '';
comment on column ${iol_schema}.abss_flow_task.parentflowno is '父流程编号';
comment on column ${iol_schema}.abss_flow_task.assignedtaskno is '';
comment on column ${iol_schema}.abss_flow_task.relanoticeno is '';
comment on column ${iol_schema}.abss_flow_task.start_dt is '开始时间';
comment on column ${iol_schema}.abss_flow_task.end_dt is '结束时间';
comment on column ${iol_schema}.abss_flow_task.id_mark is '增删标志';
comment on column ${iol_schema}.abss_flow_task.etl_timestamp is 'ETL处理时间戳';
