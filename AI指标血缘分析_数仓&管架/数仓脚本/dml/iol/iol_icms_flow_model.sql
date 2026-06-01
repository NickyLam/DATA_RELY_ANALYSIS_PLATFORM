/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_flow_model
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
create table ${iol_schema}.icms_flow_model_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_flow_model
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_flow_model_op purge;
drop table ${iol_schema}.icms_flow_model_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_flow_model_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_flow_model where 0=1;

create table ${iol_schema}.icms_flow_model_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_flow_model where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_flow_model_cl(
            flowno -- 流程编号
            ,phaseno -- 阶段号
            ,version -- 图形节点高度
            ,checklist -- (NEW)阶段CHECKLIST
            ,height -- 图形节点宽度
            ,continuecondition -- 多批时流程继续的判断
            ,ycoordinate -- 图形节点Y坐标
            ,attribute3 -- 属性3
            ,updatetime -- 更新时间
            ,id -- 图形节点编号
            ,corporgid -- 法人机构编号
            ,attribute6 -- 属性6
            ,aapointcomp -- 授权点组件
            ,name -- 图形节点名称
            ,xcoordinate -- 图形节点X坐标
            ,flowphasecontext -- 流程节点类型
            ,attribute4 -- 属性4
            ,attribute9 -- 属性9
            ,buttonset2 -- (NEW)STRIP按钮
            ,updateuser -- 更新人
            ,swimlane -- 版本
            ,attribute5 -- 属性5
            ,width -- 泳道编号
            ,phaseattribute -- 阶段属性
            ,attribute2 -- 属性2
            ,aapointcompurl -- 授权点组件url
            ,nodetype -- 流程阶段上下文
            ,actionscript -- 动作生成脚本
            ,inputtime -- 录入时间
            ,phasename -- 阶段名称
            ,attribute8 -- 属性8
            ,standardtime2 -- (NEW)审批时间标准2(分钟)
            ,actiondescribe -- 动作描述
            ,attribute1 -- 属性1
            ,riskscanrule -- (NEW)风险探测规则组
            ,phasedescribe -- 阶段描述
            ,choicedescribe -- 意见描述
            ,prescript -- 前沿执行脚本
            ,choicescript -- 意见生成脚本
            ,costlob -- (NEW)审批成本归属
            ,aaenabled -- 是否启用授权
            ,inputuser -- 录入人
            ,type -- 图形节点类型
            ,phasetype -- 阶段类型
            ,initscript -- 初始执行脚本
            ,attribute7 -- 属性7
            ,standardtime1 -- (NEW)审批时间标准1(分钟)
            ,strips -- (NEW)阶段STRIP[逗号分隔]
            ,decisionscript -- (NEW)自动审批规则
            ,distributerule -- 分发方式
            ,postscript -- 后续阶段脚本
            ,attribute10 -- 属性10
            ,aapointinitscript -- 授权点初始化脚本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_flow_model_op(
            flowno -- 流程编号
            ,phaseno -- 阶段号
            ,version -- 图形节点高度
            ,checklist -- (NEW)阶段CHECKLIST
            ,height -- 图形节点宽度
            ,continuecondition -- 多批时流程继续的判断
            ,ycoordinate -- 图形节点Y坐标
            ,attribute3 -- 属性3
            ,updatetime -- 更新时间
            ,id -- 图形节点编号
            ,corporgid -- 法人机构编号
            ,attribute6 -- 属性6
            ,aapointcomp -- 授权点组件
            ,name -- 图形节点名称
            ,xcoordinate -- 图形节点X坐标
            ,flowphasecontext -- 流程节点类型
            ,attribute4 -- 属性4
            ,attribute9 -- 属性9
            ,buttonset2 -- (NEW)STRIP按钮
            ,updateuser -- 更新人
            ,swimlane -- 版本
            ,attribute5 -- 属性5
            ,width -- 泳道编号
            ,phaseattribute -- 阶段属性
            ,attribute2 -- 属性2
            ,aapointcompurl -- 授权点组件url
            ,nodetype -- 流程阶段上下文
            ,actionscript -- 动作生成脚本
            ,inputtime -- 录入时间
            ,phasename -- 阶段名称
            ,attribute8 -- 属性8
            ,standardtime2 -- (NEW)审批时间标准2(分钟)
            ,actiondescribe -- 动作描述
            ,attribute1 -- 属性1
            ,riskscanrule -- (NEW)风险探测规则组
            ,phasedescribe -- 阶段描述
            ,choicedescribe -- 意见描述
            ,prescript -- 前沿执行脚本
            ,choicescript -- 意见生成脚本
            ,costlob -- (NEW)审批成本归属
            ,aaenabled -- 是否启用授权
            ,inputuser -- 录入人
            ,type -- 图形节点类型
            ,phasetype -- 阶段类型
            ,initscript -- 初始执行脚本
            ,attribute7 -- 属性7
            ,standardtime1 -- (NEW)审批时间标准1(分钟)
            ,strips -- (NEW)阶段STRIP[逗号分隔]
            ,decisionscript -- (NEW)自动审批规则
            ,distributerule -- 分发方式
            ,postscript -- 后续阶段脚本
            ,attribute10 -- 属性10
            ,aapointinitscript -- 授权点初始化脚本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.flowno, o.flowno) as flowno -- 流程编号
    ,nvl(n.phaseno, o.phaseno) as phaseno -- 阶段号
    ,nvl(n.version, o.version) as version -- 图形节点高度
    ,nvl(n.checklist, o.checklist) as checklist -- (NEW)阶段CHECKLIST
    ,nvl(n.height, o.height) as height -- 图形节点宽度
    ,nvl(n.continuecondition, o.continuecondition) as continuecondition -- 多批时流程继续的判断
    ,nvl(n.ycoordinate, o.ycoordinate) as ycoordinate -- 图形节点Y坐标
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 属性3
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,nvl(n.id, o.id) as id -- 图形节点编号
    ,nvl(n.corporgid, o.corporgid) as corporgid -- 法人机构编号
    ,nvl(n.attribute6, o.attribute6) as attribute6 -- 属性6
    ,nvl(n.aapointcomp, o.aapointcomp) as aapointcomp -- 授权点组件
    ,nvl(n.name, o.name) as name -- 图形节点名称
    ,nvl(n.xcoordinate, o.xcoordinate) as xcoordinate -- 图形节点X坐标
    ,nvl(n.flowphasecontext, o.flowphasecontext) as flowphasecontext -- 流程节点类型
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 属性4
    ,nvl(n.attribute9, o.attribute9) as attribute9 -- 属性9
    ,nvl(n.buttonset2, o.buttonset2) as buttonset2 -- (NEW)STRIP按钮
    ,nvl(n.updateuser, o.updateuser) as updateuser -- 更新人
    ,nvl(n.swimlane, o.swimlane) as swimlane -- 版本
    ,nvl(n.attribute5, o.attribute5) as attribute5 -- 属性5
    ,nvl(n.width, o.width) as width -- 泳道编号
    ,nvl(n.phaseattribute, o.phaseattribute) as phaseattribute -- 阶段属性
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 属性2
    ,nvl(n.aapointcompurl, o.aapointcompurl) as aapointcompurl -- 授权点组件url
    ,nvl(n.nodetype, o.nodetype) as nodetype -- 流程阶段上下文
    ,nvl(n.actionscript, o.actionscript) as actionscript -- 动作生成脚本
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 录入时间
    ,nvl(n.phasename, o.phasename) as phasename -- 阶段名称
    ,nvl(n.attribute8, o.attribute8) as attribute8 -- 属性8
    ,nvl(n.standardtime2, o.standardtime2) as standardtime2 -- (NEW)审批时间标准2(分钟)
    ,nvl(n.actiondescribe, o.actiondescribe) as actiondescribe -- 动作描述
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 属性1
    ,nvl(n.riskscanrule, o.riskscanrule) as riskscanrule -- (NEW)风险探测规则组
    ,nvl(n.phasedescribe, o.phasedescribe) as phasedescribe -- 阶段描述
    ,nvl(n.choicedescribe, o.choicedescribe) as choicedescribe -- 意见描述
    ,nvl(n.prescript, o.prescript) as prescript -- 前沿执行脚本
    ,nvl(n.choicescript, o.choicescript) as choicescript -- 意见生成脚本
    ,nvl(n.costlob, o.costlob) as costlob -- (NEW)审批成本归属
    ,nvl(n.aaenabled, o.aaenabled) as aaenabled -- 是否启用授权
    ,nvl(n.inputuser, o.inputuser) as inputuser -- 录入人
    ,nvl(n.type, o.type) as type -- 图形节点类型
    ,nvl(n.phasetype, o.phasetype) as phasetype -- 阶段类型
    ,nvl(n.initscript, o.initscript) as initscript -- 初始执行脚本
    ,nvl(n.attribute7, o.attribute7) as attribute7 -- 属性7
    ,nvl(n.standardtime1, o.standardtime1) as standardtime1 -- (NEW)审批时间标准1(分钟)
    ,nvl(n.strips, o.strips) as strips -- (NEW)阶段STRIP[逗号分隔]
    ,nvl(n.decisionscript, o.decisionscript) as decisionscript -- (NEW)自动审批规则
    ,nvl(n.distributerule, o.distributerule) as distributerule -- 分发方式
    ,nvl(n.postscript, o.postscript) as postscript -- 后续阶段脚本
    ,nvl(n.attribute10, o.attribute10) as attribute10 -- 属性10
    ,nvl(n.aapointinitscript, o.aapointinitscript) as aapointinitscript -- 授权点初始化脚本
    ,case when
            n.flowno is null
            and n.phaseno is null
            and n.version is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.flowno is null
            and n.phaseno is null
            and n.version is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.flowno is null
            and n.phaseno is null
            and n.version is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_flow_model_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_flow_model where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.flowno = n.flowno
            and o.phaseno = n.phaseno
            and o.version = n.version
where (
        o.flowno is null
        and o.phaseno is null
        and o.version is null
    )
    or (
        n.flowno is null
        and n.phaseno is null
        and n.version is null
    )
    or (
        o.checklist <> n.checklist
        or o.height <> n.height
        or o.continuecondition <> n.continuecondition
        or o.ycoordinate <> n.ycoordinate
        or o.attribute3 <> n.attribute3
        or o.updatetime <> n.updatetime
        or o.id <> n.id
        or o.corporgid <> n.corporgid
        or o.attribute6 <> n.attribute6
        or o.aapointcomp <> n.aapointcomp
        or o.name <> n.name
        or o.xcoordinate <> n.xcoordinate
        or o.flowphasecontext <> n.flowphasecontext
        or o.attribute4 <> n.attribute4
        or o.attribute9 <> n.attribute9
        or o.buttonset2 <> n.buttonset2
        or o.updateuser <> n.updateuser
        or o.swimlane <> n.swimlane
        or o.attribute5 <> n.attribute5
        or o.width <> n.width
        or o.phaseattribute <> n.phaseattribute
        or o.attribute2 <> n.attribute2
        or o.aapointcompurl <> n.aapointcompurl
        or o.nodetype <> n.nodetype
        or o.actionscript <> n.actionscript
        or o.inputtime <> n.inputtime
        or o.phasename <> n.phasename
        or o.attribute8 <> n.attribute8
        or o.standardtime2 <> n.standardtime2
        or o.actiondescribe <> n.actiondescribe
        or o.attribute1 <> n.attribute1
        or o.riskscanrule <> n.riskscanrule
        or o.phasedescribe <> n.phasedescribe
        or o.choicedescribe <> n.choicedescribe
        or o.prescript <> n.prescript
        or o.choicescript <> n.choicescript
        or o.costlob <> n.costlob
        or o.aaenabled <> n.aaenabled
        or o.inputuser <> n.inputuser
        or o.type <> n.type
        or o.phasetype <> n.phasetype
        or o.initscript <> n.initscript
        or o.attribute7 <> n.attribute7
        or o.standardtime1 <> n.standardtime1
        or o.strips <> n.strips
        or o.decisionscript <> n.decisionscript
        or o.distributerule <> n.distributerule
        or o.postscript <> n.postscript
        or o.attribute10 <> n.attribute10
        or o.aapointinitscript <> n.aapointinitscript
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_flow_model_cl(
            flowno -- 流程编号
            ,phaseno -- 阶段号
            ,version -- 图形节点高度
            ,checklist -- (NEW)阶段CHECKLIST
            ,height -- 图形节点宽度
            ,continuecondition -- 多批时流程继续的判断
            ,ycoordinate -- 图形节点Y坐标
            ,attribute3 -- 属性3
            ,updatetime -- 更新时间
            ,id -- 图形节点编号
            ,corporgid -- 法人机构编号
            ,attribute6 -- 属性6
            ,aapointcomp -- 授权点组件
            ,name -- 图形节点名称
            ,xcoordinate -- 图形节点X坐标
            ,flowphasecontext -- 流程节点类型
            ,attribute4 -- 属性4
            ,attribute9 -- 属性9
            ,buttonset2 -- (NEW)STRIP按钮
            ,updateuser -- 更新人
            ,swimlane -- 版本
            ,attribute5 -- 属性5
            ,width -- 泳道编号
            ,phaseattribute -- 阶段属性
            ,attribute2 -- 属性2
            ,aapointcompurl -- 授权点组件url
            ,nodetype -- 流程阶段上下文
            ,actionscript -- 动作生成脚本
            ,inputtime -- 录入时间
            ,phasename -- 阶段名称
            ,attribute8 -- 属性8
            ,standardtime2 -- (NEW)审批时间标准2(分钟)
            ,actiondescribe -- 动作描述
            ,attribute1 -- 属性1
            ,riskscanrule -- (NEW)风险探测规则组
            ,phasedescribe -- 阶段描述
            ,choicedescribe -- 意见描述
            ,prescript -- 前沿执行脚本
            ,choicescript -- 意见生成脚本
            ,costlob -- (NEW)审批成本归属
            ,aaenabled -- 是否启用授权
            ,inputuser -- 录入人
            ,type -- 图形节点类型
            ,phasetype -- 阶段类型
            ,initscript -- 初始执行脚本
            ,attribute7 -- 属性7
            ,standardtime1 -- (NEW)审批时间标准1(分钟)
            ,strips -- (NEW)阶段STRIP[逗号分隔]
            ,decisionscript -- (NEW)自动审批规则
            ,distributerule -- 分发方式
            ,postscript -- 后续阶段脚本
            ,attribute10 -- 属性10
            ,aapointinitscript -- 授权点初始化脚本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_flow_model_op(
            flowno -- 流程编号
            ,phaseno -- 阶段号
            ,version -- 图形节点高度
            ,checklist -- (NEW)阶段CHECKLIST
            ,height -- 图形节点宽度
            ,continuecondition -- 多批时流程继续的判断
            ,ycoordinate -- 图形节点Y坐标
            ,attribute3 -- 属性3
            ,updatetime -- 更新时间
            ,id -- 图形节点编号
            ,corporgid -- 法人机构编号
            ,attribute6 -- 属性6
            ,aapointcomp -- 授权点组件
            ,name -- 图形节点名称
            ,xcoordinate -- 图形节点X坐标
            ,flowphasecontext -- 流程节点类型
            ,attribute4 -- 属性4
            ,attribute9 -- 属性9
            ,buttonset2 -- (NEW)STRIP按钮
            ,updateuser -- 更新人
            ,swimlane -- 版本
            ,attribute5 -- 属性5
            ,width -- 泳道编号
            ,phaseattribute -- 阶段属性
            ,attribute2 -- 属性2
            ,aapointcompurl -- 授权点组件url
            ,nodetype -- 流程阶段上下文
            ,actionscript -- 动作生成脚本
            ,inputtime -- 录入时间
            ,phasename -- 阶段名称
            ,attribute8 -- 属性8
            ,standardtime2 -- (NEW)审批时间标准2(分钟)
            ,actiondescribe -- 动作描述
            ,attribute1 -- 属性1
            ,riskscanrule -- (NEW)风险探测规则组
            ,phasedescribe -- 阶段描述
            ,choicedescribe -- 意见描述
            ,prescript -- 前沿执行脚本
            ,choicescript -- 意见生成脚本
            ,costlob -- (NEW)审批成本归属
            ,aaenabled -- 是否启用授权
            ,inputuser -- 录入人
            ,type -- 图形节点类型
            ,phasetype -- 阶段类型
            ,initscript -- 初始执行脚本
            ,attribute7 -- 属性7
            ,standardtime1 -- (NEW)审批时间标准1(分钟)
            ,strips -- (NEW)阶段STRIP[逗号分隔]
            ,decisionscript -- (NEW)自动审批规则
            ,distributerule -- 分发方式
            ,postscript -- 后续阶段脚本
            ,attribute10 -- 属性10
            ,aapointinitscript -- 授权点初始化脚本
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.flowno -- 流程编号
    ,o.phaseno -- 阶段号
    ,o.version -- 图形节点高度
    ,o.checklist -- (NEW)阶段CHECKLIST
    ,o.height -- 图形节点宽度
    ,o.continuecondition -- 多批时流程继续的判断
    ,o.ycoordinate -- 图形节点Y坐标
    ,o.attribute3 -- 属性3
    ,o.updatetime -- 更新时间
    ,o.id -- 图形节点编号
    ,o.corporgid -- 法人机构编号
    ,o.attribute6 -- 属性6
    ,o.aapointcomp -- 授权点组件
    ,o.name -- 图形节点名称
    ,o.xcoordinate -- 图形节点X坐标
    ,o.flowphasecontext -- 流程节点类型
    ,o.attribute4 -- 属性4
    ,o.attribute9 -- 属性9
    ,o.buttonset2 -- (NEW)STRIP按钮
    ,o.updateuser -- 更新人
    ,o.swimlane -- 版本
    ,o.attribute5 -- 属性5
    ,o.width -- 泳道编号
    ,o.phaseattribute -- 阶段属性
    ,o.attribute2 -- 属性2
    ,o.aapointcompurl -- 授权点组件url
    ,o.nodetype -- 流程阶段上下文
    ,o.actionscript -- 动作生成脚本
    ,o.inputtime -- 录入时间
    ,o.phasename -- 阶段名称
    ,o.attribute8 -- 属性8
    ,o.standardtime2 -- (NEW)审批时间标准2(分钟)
    ,o.actiondescribe -- 动作描述
    ,o.attribute1 -- 属性1
    ,o.riskscanrule -- (NEW)风险探测规则组
    ,o.phasedescribe -- 阶段描述
    ,o.choicedescribe -- 意见描述
    ,o.prescript -- 前沿执行脚本
    ,o.choicescript -- 意见生成脚本
    ,o.costlob -- (NEW)审批成本归属
    ,o.aaenabled -- 是否启用授权
    ,o.inputuser -- 录入人
    ,o.type -- 图形节点类型
    ,o.phasetype -- 阶段类型
    ,o.initscript -- 初始执行脚本
    ,o.attribute7 -- 属性7
    ,o.standardtime1 -- (NEW)审批时间标准1(分钟)
    ,o.strips -- (NEW)阶段STRIP[逗号分隔]
    ,o.decisionscript -- (NEW)自动审批规则
    ,o.distributerule -- 分发方式
    ,o.postscript -- 后续阶段脚本
    ,o.attribute10 -- 属性10
    ,o.aapointinitscript -- 授权点初始化脚本
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null
          then 'I'
          when o.end_dt >= to_date('${batch_date}','yyyymmdd')
          then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志 
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.icms_flow_model_bk o
    left join ${iol_schema}.icms_flow_model_op n
        on
            o.flowno = n.flowno
            and o.phaseno = n.phaseno
            and o.version = n.version
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_flow_model_cl d
        on
            o.flowno = d.flowno
            and o.phaseno = d.phaseno
            and o.version = d.version
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_flow_model;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_flow_model') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_flow_model drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_flow_model add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_flow_model exchange partition p_${batch_date} with table ${iol_schema}.icms_flow_model_cl;
alter table ${iol_schema}.icms_flow_model exchange partition p_20991231 with table ${iol_schema}.icms_flow_model_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_flow_model to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_flow_model_op purge;
drop table ${iol_schema}.icms_flow_model_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_flow_model_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_flow_model',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
