/*
Purpose:    近源模型层-状态表建表脚本，此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/init.py iol icms_flow_model
CreateDate: 20180515
FileType:   DDL
Logs:
    zjj 2018-05-15 新建表本
*/

prompt creating table ${iol_schema}.icms_flow_model
whenever sqlerror continue none;
drop table ${iol_schema}.icms_flow_model purge;

whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_flow_model(
    flowno varchar2(64) -- 流程编号
    ,phaseno varchar2(64) -- 阶段号
    ,version varchar2(36) -- 图形节点高度
    ,checklist varchar2(64) -- (NEW)阶段CHECKLIST
    ,height varchar2(36) -- 图形节点宽度
    ,continuecondition varchar2(400) -- 多批时流程继续的判断
    ,ycoordinate varchar2(36) -- 图形节点Y坐标
    ,attribute3 varchar2(1000) -- 属性3
    ,updatetime varchar2(64) -- 更新时间
    ,id varchar2(64) -- 图形节点编号
    ,corporgid varchar2(64) -- 法人机构编号
    ,attribute6 varchar2(1000) -- 属性6
    ,aapointcomp varchar2(1000) -- 授权点组件
    ,name varchar2(2000) -- 图形节点名称
    ,xcoordinate varchar2(36) -- 图形节点X坐标
    ,flowphasecontext varchar2(4000) -- 流程节点类型
    ,attribute4 varchar2(1000) -- 属性4
    ,attribute9 varchar2(1000) -- 属性9
    ,buttonset2 varchar2(2000) -- (NEW)STRIP按钮
    ,updateuser varchar2(64) -- 更新人
    ,swimlane varchar2(64) -- 版本
    ,attribute5 varchar2(1000) -- 属性5
    ,width varchar2(36) -- 泳道编号
    ,phaseattribute varchar2(160) -- 阶段属性
    ,attribute2 varchar2(1000) -- 属性2
    ,aapointcompurl varchar2(1000) -- 授权点组件url
    ,nodetype varchar2(64) -- 流程阶段上下文
    ,actionscript varchar2(4000) -- 动作生成脚本
    ,inputtime varchar2(64) -- 录入时间
    ,phasename varchar2(160) -- 阶段名称
    ,attribute8 varchar2(1000) -- 属性8
    ,standardtime2 number(22) -- (NEW)审批时间标准2(分钟)
    ,actiondescribe varchar2(4000) -- 动作描述
    ,attribute1 varchar2(1000) -- 属性1
    ,riskscanrule varchar2(64) -- (NEW)风险探测规则组
    ,phasedescribe varchar2(1000) -- 阶段描述
    ,choicedescribe varchar2(1000) -- 意见描述
    ,prescript varchar2(1000) -- 前沿执行脚本
    ,choicescript varchar2(1000) -- 意见生成脚本
    ,costlob varchar2(64) -- (NEW)审批成本归属
    ,aaenabled varchar2(2) -- 是否启用授权
    ,inputuser varchar2(64) -- 录入人
    ,type varchar2(64) -- 图形节点类型
    ,phasetype varchar2(64) -- 阶段类型
    ,initscript varchar2(4000) -- 初始执行脚本
    ,attribute7 varchar2(1000) -- 属性7
    ,standardtime1 number(22) -- (NEW)审批时间标准1(分钟)
    ,strips varchar2(2000) -- (NEW)阶段STRIP[逗号分隔]
    ,decisionscript varchar2(4000) -- (NEW)自动审批规则
    ,distributerule varchar2(64) -- 分发方式
    ,postscript varchar2(4000) -- 后续阶段脚本
    ,attribute10 varchar2(1000) -- 属性10
    ,aapointinitscript varchar2(4000) -- 授权点初始化脚本
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
grant select on ${iol_schema}.icms_flow_model to ${iml_schema};
grant select on ${iol_schema}.icms_flow_model to ${icl_schema};
grant select on ${iol_schema}.icms_flow_model to ${idl_schema};
grant select on ${iol_schema}.icms_flow_model to ${iel_schema};

-- comment
comment on table ${iol_schema}.icms_flow_model is '流程模型表流程模型';
comment on column ${iol_schema}.icms_flow_model.flowno is '流程编号';
comment on column ${iol_schema}.icms_flow_model.phaseno is '阶段号';
comment on column ${iol_schema}.icms_flow_model.version is '图形节点高度';
comment on column ${iol_schema}.icms_flow_model.checklist is '(NEW)阶段CHECKLIST';
comment on column ${iol_schema}.icms_flow_model.height is '图形节点宽度';
comment on column ${iol_schema}.icms_flow_model.continuecondition is '多批时流程继续的判断';
comment on column ${iol_schema}.icms_flow_model.ycoordinate is '图形节点Y坐标';
comment on column ${iol_schema}.icms_flow_model.attribute3 is '属性3';
comment on column ${iol_schema}.icms_flow_model.updatetime is '更新时间';
comment on column ${iol_schema}.icms_flow_model.id is '图形节点编号';
comment on column ${iol_schema}.icms_flow_model.corporgid is '法人机构编号';
comment on column ${iol_schema}.icms_flow_model.attribute6 is '属性6';
comment on column ${iol_schema}.icms_flow_model.aapointcomp is '授权点组件';
comment on column ${iol_schema}.icms_flow_model.name is '图形节点名称';
comment on column ${iol_schema}.icms_flow_model.xcoordinate is '图形节点X坐标';
comment on column ${iol_schema}.icms_flow_model.flowphasecontext is '流程节点类型';
comment on column ${iol_schema}.icms_flow_model.attribute4 is '属性4';
comment on column ${iol_schema}.icms_flow_model.attribute9 is '属性9';
comment on column ${iol_schema}.icms_flow_model.buttonset2 is '(NEW)STRIP按钮';
comment on column ${iol_schema}.icms_flow_model.updateuser is '更新人';
comment on column ${iol_schema}.icms_flow_model.swimlane is '版本';
comment on column ${iol_schema}.icms_flow_model.attribute5 is '属性5';
comment on column ${iol_schema}.icms_flow_model.width is '泳道编号';
comment on column ${iol_schema}.icms_flow_model.phaseattribute is '阶段属性';
comment on column ${iol_schema}.icms_flow_model.attribute2 is '属性2';
comment on column ${iol_schema}.icms_flow_model.aapointcompurl is '授权点组件url';
comment on column ${iol_schema}.icms_flow_model.nodetype is '流程阶段上下文';
comment on column ${iol_schema}.icms_flow_model.actionscript is '动作生成脚本';
comment on column ${iol_schema}.icms_flow_model.inputtime is '录入时间';
comment on column ${iol_schema}.icms_flow_model.phasename is '阶段名称';
comment on column ${iol_schema}.icms_flow_model.attribute8 is '属性8';
comment on column ${iol_schema}.icms_flow_model.standardtime2 is '(NEW)审批时间标准2(分钟)';
comment on column ${iol_schema}.icms_flow_model.actiondescribe is '动作描述';
comment on column ${iol_schema}.icms_flow_model.attribute1 is '属性1';
comment on column ${iol_schema}.icms_flow_model.riskscanrule is '(NEW)风险探测规则组';
comment on column ${iol_schema}.icms_flow_model.phasedescribe is '阶段描述';
comment on column ${iol_schema}.icms_flow_model.choicedescribe is '意见描述';
comment on column ${iol_schema}.icms_flow_model.prescript is '前沿执行脚本';
comment on column ${iol_schema}.icms_flow_model.choicescript is '意见生成脚本';
comment on column ${iol_schema}.icms_flow_model.costlob is '(NEW)审批成本归属';
comment on column ${iol_schema}.icms_flow_model.aaenabled is '是否启用授权';
comment on column ${iol_schema}.icms_flow_model.inputuser is '录入人';
comment on column ${iol_schema}.icms_flow_model.type is '图形节点类型';
comment on column ${iol_schema}.icms_flow_model.phasetype is '阶段类型';
comment on column ${iol_schema}.icms_flow_model.initscript is '初始执行脚本';
comment on column ${iol_schema}.icms_flow_model.attribute7 is '属性7';
comment on column ${iol_schema}.icms_flow_model.standardtime1 is '(NEW)审批时间标准1(分钟)';
comment on column ${iol_schema}.icms_flow_model.strips is '(NEW)阶段STRIP[逗号分隔]';
comment on column ${iol_schema}.icms_flow_model.decisionscript is '(NEW)自动审批规则';
comment on column ${iol_schema}.icms_flow_model.distributerule is '分发方式';
comment on column ${iol_schema}.icms_flow_model.postscript is '后续阶段脚本';
comment on column ${iol_schema}.icms_flow_model.attribute10 is '属性10';
comment on column ${iol_schema}.icms_flow_model.aapointinitscript is '授权点初始化脚本';
comment on column ${iol_schema}.icms_flow_model.start_dt is '开始时间';
comment on column ${iol_schema}.icms_flow_model.end_dt is '结束时间';
comment on column ${iol_schema}.icms_flow_model.id_mark is '增删标志';
comment on column ${iol_schema}.icms_flow_model.etl_timestamp is 'ETL处理时间戳';
