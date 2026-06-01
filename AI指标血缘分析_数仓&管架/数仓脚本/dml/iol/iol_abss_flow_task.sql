/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_abss_flow_task
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
create table ${iol_schema}.abss_flow_task_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.abss_flow_task
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_flow_task_op purge;
drop table ${iol_schema}.abss_flow_task_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.abss_flow_task_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_flow_task where 0=1;

create table ${iol_schema}.abss_flow_task_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.abss_flow_task where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_flow_task_cl(
            serialno -- 流水号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,relativeserialno -- 上一流水号
            ,flowno -- 流程编号
            ,flowname -- 流程名称
            ,phaseno -- 阶段编号
            ,phasename -- 阶段名称
            ,phasetype -- 阶段类型
            ,applytype -- 申请类型
            ,userid -- 承办人编号
            ,username -- 承办人姓名
            ,orgid -- 承办机构编号
            ,orgname -- 承办机构名称
            ,begintime -- 开始执行时间
            ,endtime -- 完成执行时间
            ,phasechoice -- 阶段意见
            ,phaseaction -- 阶段动作
            ,phaseopinion -- 意见详情
            ,phaseopinion1 -- 意见详情1
            ,phaseopinion2 -- 意见详情2
            ,phaseopinion3 -- 意见详情3
            ,phaseopinion4 -- 意见详情4
            ,checklistresult -- 检查清单结果
            ,autodecision -- 自动审批判断结果
            ,riskscanresult -- 风险探测结果
            ,standardtime1 -- 标准审批用时
            ,standardtime2 -- 最长审批用时
            ,costlob -- 审批成本归属
            ,clientx -- 图元X坐标
            ,clienty -- 图元Y坐标
            ,width -- 图元宽度
            ,heigth -- 图元高度
            ,groupinfo -- 分组信息
            ,processinstno -- 流程实例
            ,processtaskno -- 任务编号
            ,relativeobjectno -- 关联对象编号
            ,flowstate -- 工作流状态
            ,forkstate -- 
            ,version -- 系统未使用
            ,baseflowno -- 基础流程编号
            ,taskstate -- 任务状态
            ,forkno -- 
            ,allforkno -- 
            ,parentflowno -- 父流程编号
            ,assignedtaskno -- 
            ,relanoticeno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_flow_task_op(
            serialno -- 流水号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,relativeserialno -- 上一流水号
            ,flowno -- 流程编号
            ,flowname -- 流程名称
            ,phaseno -- 阶段编号
            ,phasename -- 阶段名称
            ,phasetype -- 阶段类型
            ,applytype -- 申请类型
            ,userid -- 承办人编号
            ,username -- 承办人姓名
            ,orgid -- 承办机构编号
            ,orgname -- 承办机构名称
            ,begintime -- 开始执行时间
            ,endtime -- 完成执行时间
            ,phasechoice -- 阶段意见
            ,phaseaction -- 阶段动作
            ,phaseopinion -- 意见详情
            ,phaseopinion1 -- 意见详情1
            ,phaseopinion2 -- 意见详情2
            ,phaseopinion3 -- 意见详情3
            ,phaseopinion4 -- 意见详情4
            ,checklistresult -- 检查清单结果
            ,autodecision -- 自动审批判断结果
            ,riskscanresult -- 风险探测结果
            ,standardtime1 -- 标准审批用时
            ,standardtime2 -- 最长审批用时
            ,costlob -- 审批成本归属
            ,clientx -- 图元X坐标
            ,clienty -- 图元Y坐标
            ,width -- 图元宽度
            ,heigth -- 图元高度
            ,groupinfo -- 分组信息
            ,processinstno -- 流程实例
            ,processtaskno -- 任务编号
            ,relativeobjectno -- 关联对象编号
            ,flowstate -- 工作流状态
            ,forkstate -- 
            ,version -- 系统未使用
            ,baseflowno -- 基础流程编号
            ,taskstate -- 任务状态
            ,forkno -- 
            ,allforkno -- 
            ,parentflowno -- 父流程编号
            ,assignedtaskno -- 
            ,relanoticeno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.objectno, o.objectno) as objectno -- 对象编号
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 对象类型
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 上一流水号
    ,nvl(n.flowno, o.flowno) as flowno -- 流程编号
    ,nvl(n.flowname, o.flowname) as flowname -- 流程名称
    ,nvl(n.phaseno, o.phaseno) as phaseno -- 阶段编号
    ,nvl(n.phasename, o.phasename) as phasename -- 阶段名称
    ,nvl(n.phasetype, o.phasetype) as phasetype -- 阶段类型
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型
    ,nvl(n.userid, o.userid) as userid -- 承办人编号
    ,nvl(n.username, o.username) as username -- 承办人姓名
    ,nvl(n.orgid, o.orgid) as orgid -- 承办机构编号
    ,nvl(n.orgname, o.orgname) as orgname -- 承办机构名称
    ,nvl(n.begintime, o.begintime) as begintime -- 开始执行时间
    ,nvl(n.endtime, o.endtime) as endtime -- 完成执行时间
    ,nvl(n.phasechoice, o.phasechoice) as phasechoice -- 阶段意见
    ,nvl(n.phaseaction, o.phaseaction) as phaseaction -- 阶段动作
    ,nvl(n.phaseopinion, o.phaseopinion) as phaseopinion -- 意见详情
    ,nvl(n.phaseopinion1, o.phaseopinion1) as phaseopinion1 -- 意见详情1
    ,nvl(n.phaseopinion2, o.phaseopinion2) as phaseopinion2 -- 意见详情2
    ,nvl(n.phaseopinion3, o.phaseopinion3) as phaseopinion3 -- 意见详情3
    ,nvl(n.phaseopinion4, o.phaseopinion4) as phaseopinion4 -- 意见详情4
    ,nvl(n.checklistresult, o.checklistresult) as checklistresult -- 检查清单结果
    ,nvl(n.autodecision, o.autodecision) as autodecision -- 自动审批判断结果
    ,nvl(n.riskscanresult, o.riskscanresult) as riskscanresult -- 风险探测结果
    ,nvl(n.standardtime1, o.standardtime1) as standardtime1 -- 标准审批用时
    ,nvl(n.standardtime2, o.standardtime2) as standardtime2 -- 最长审批用时
    ,nvl(n.costlob, o.costlob) as costlob -- 审批成本归属
    ,nvl(n.clientx, o.clientx) as clientx -- 图元X坐标
    ,nvl(n.clienty, o.clienty) as clienty -- 图元Y坐标
    ,nvl(n.width, o.width) as width -- 图元宽度
    ,nvl(n.heigth, o.heigth) as heigth -- 图元高度
    ,nvl(n.groupinfo, o.groupinfo) as groupinfo -- 分组信息
    ,nvl(n.processinstno, o.processinstno) as processinstno -- 流程实例
    ,nvl(n.processtaskno, o.processtaskno) as processtaskno -- 任务编号
    ,nvl(n.relativeobjectno, o.relativeobjectno) as relativeobjectno -- 关联对象编号
    ,nvl(n.flowstate, o.flowstate) as flowstate -- 工作流状态
    ,nvl(n.forkstate, o.forkstate) as forkstate -- 
    ,nvl(n.version, o.version) as version -- 系统未使用
    ,nvl(n.baseflowno, o.baseflowno) as baseflowno -- 基础流程编号
    ,nvl(n.taskstate, o.taskstate) as taskstate -- 任务状态
    ,nvl(n.forkno, o.forkno) as forkno -- 
    ,nvl(n.allforkno, o.allforkno) as allforkno -- 
    ,nvl(n.parentflowno, o.parentflowno) as parentflowno -- 父流程编号
    ,nvl(n.assignedtaskno, o.assignedtaskno) as assignedtaskno -- 
    ,nvl(n.relanoticeno, o.relanoticeno) as relanoticeno -- 
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.abss_flow_task_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.abss_flow_task where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.objectno <> n.objectno
        or o.objecttype <> n.objecttype
        or o.relativeserialno <> n.relativeserialno
        or o.flowno <> n.flowno
        or o.flowname <> n.flowname
        or o.phaseno <> n.phaseno
        or o.phasename <> n.phasename
        or o.phasetype <> n.phasetype
        or o.applytype <> n.applytype
        or o.userid <> n.userid
        or o.username <> n.username
        or o.orgid <> n.orgid
        or o.orgname <> n.orgname
        or o.begintime <> n.begintime
        or o.endtime <> n.endtime
        or o.phasechoice <> n.phasechoice
        or o.phaseaction <> n.phaseaction
        or o.phaseopinion <> n.phaseopinion
        or o.phaseopinion1 <> n.phaseopinion1
        or o.phaseopinion2 <> n.phaseopinion2
        or o.phaseopinion3 <> n.phaseopinion3
        or o.phaseopinion4 <> n.phaseopinion4
        or o.checklistresult <> n.checklistresult
        or o.autodecision <> n.autodecision
        or o.riskscanresult <> n.riskscanresult
        or o.standardtime1 <> n.standardtime1
        or o.standardtime2 <> n.standardtime2
        or o.costlob <> n.costlob
        or o.clientx <> n.clientx
        or o.clienty <> n.clienty
        or o.width <> n.width
        or o.heigth <> n.heigth
        or o.groupinfo <> n.groupinfo
        or o.processinstno <> n.processinstno
        or o.processtaskno <> n.processtaskno
        or o.relativeobjectno <> n.relativeobjectno
        or o.flowstate <> n.flowstate
        or o.forkstate <> n.forkstate
        or o.version <> n.version
        or o.baseflowno <> n.baseflowno
        or o.taskstate <> n.taskstate
        or o.forkno <> n.forkno
        or o.allforkno <> n.allforkno
        or o.parentflowno <> n.parentflowno
        or o.assignedtaskno <> n.assignedtaskno
        or o.relanoticeno <> n.relanoticeno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.abss_flow_task_cl(
            serialno -- 流水号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,relativeserialno -- 上一流水号
            ,flowno -- 流程编号
            ,flowname -- 流程名称
            ,phaseno -- 阶段编号
            ,phasename -- 阶段名称
            ,phasetype -- 阶段类型
            ,applytype -- 申请类型
            ,userid -- 承办人编号
            ,username -- 承办人姓名
            ,orgid -- 承办机构编号
            ,orgname -- 承办机构名称
            ,begintime -- 开始执行时间
            ,endtime -- 完成执行时间
            ,phasechoice -- 阶段意见
            ,phaseaction -- 阶段动作
            ,phaseopinion -- 意见详情
            ,phaseopinion1 -- 意见详情1
            ,phaseopinion2 -- 意见详情2
            ,phaseopinion3 -- 意见详情3
            ,phaseopinion4 -- 意见详情4
            ,checklistresult -- 检查清单结果
            ,autodecision -- 自动审批判断结果
            ,riskscanresult -- 风险探测结果
            ,standardtime1 -- 标准审批用时
            ,standardtime2 -- 最长审批用时
            ,costlob -- 审批成本归属
            ,clientx -- 图元X坐标
            ,clienty -- 图元Y坐标
            ,width -- 图元宽度
            ,heigth -- 图元高度
            ,groupinfo -- 分组信息
            ,processinstno -- 流程实例
            ,processtaskno -- 任务编号
            ,relativeobjectno -- 关联对象编号
            ,flowstate -- 工作流状态
            ,forkstate -- 
            ,version -- 系统未使用
            ,baseflowno -- 基础流程编号
            ,taskstate -- 任务状态
            ,forkno -- 
            ,allforkno -- 
            ,parentflowno -- 父流程编号
            ,assignedtaskno -- 
            ,relanoticeno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.abss_flow_task_op(
            serialno -- 流水号
            ,objectno -- 对象编号
            ,objecttype -- 对象类型
            ,relativeserialno -- 上一流水号
            ,flowno -- 流程编号
            ,flowname -- 流程名称
            ,phaseno -- 阶段编号
            ,phasename -- 阶段名称
            ,phasetype -- 阶段类型
            ,applytype -- 申请类型
            ,userid -- 承办人编号
            ,username -- 承办人姓名
            ,orgid -- 承办机构编号
            ,orgname -- 承办机构名称
            ,begintime -- 开始执行时间
            ,endtime -- 完成执行时间
            ,phasechoice -- 阶段意见
            ,phaseaction -- 阶段动作
            ,phaseopinion -- 意见详情
            ,phaseopinion1 -- 意见详情1
            ,phaseopinion2 -- 意见详情2
            ,phaseopinion3 -- 意见详情3
            ,phaseopinion4 -- 意见详情4
            ,checklistresult -- 检查清单结果
            ,autodecision -- 自动审批判断结果
            ,riskscanresult -- 风险探测结果
            ,standardtime1 -- 标准审批用时
            ,standardtime2 -- 最长审批用时
            ,costlob -- 审批成本归属
            ,clientx -- 图元X坐标
            ,clienty -- 图元Y坐标
            ,width -- 图元宽度
            ,heigth -- 图元高度
            ,groupinfo -- 分组信息
            ,processinstno -- 流程实例
            ,processtaskno -- 任务编号
            ,relativeobjectno -- 关联对象编号
            ,flowstate -- 工作流状态
            ,forkstate -- 
            ,version -- 系统未使用
            ,baseflowno -- 基础流程编号
            ,taskstate -- 任务状态
            ,forkno -- 
            ,allforkno -- 
            ,parentflowno -- 父流程编号
            ,assignedtaskno -- 
            ,relanoticeno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.objectno -- 对象编号
    ,o.objecttype -- 对象类型
    ,o.relativeserialno -- 上一流水号
    ,o.flowno -- 流程编号
    ,o.flowname -- 流程名称
    ,o.phaseno -- 阶段编号
    ,o.phasename -- 阶段名称
    ,o.phasetype -- 阶段类型
    ,o.applytype -- 申请类型
    ,o.userid -- 承办人编号
    ,o.username -- 承办人姓名
    ,o.orgid -- 承办机构编号
    ,o.orgname -- 承办机构名称
    ,o.begintime -- 开始执行时间
    ,o.endtime -- 完成执行时间
    ,o.phasechoice -- 阶段意见
    ,o.phaseaction -- 阶段动作
    ,o.phaseopinion -- 意见详情
    ,o.phaseopinion1 -- 意见详情1
    ,o.phaseopinion2 -- 意见详情2
    ,o.phaseopinion3 -- 意见详情3
    ,o.phaseopinion4 -- 意见详情4
    ,o.checklistresult -- 检查清单结果
    ,o.autodecision -- 自动审批判断结果
    ,o.riskscanresult -- 风险探测结果
    ,o.standardtime1 -- 标准审批用时
    ,o.standardtime2 -- 最长审批用时
    ,o.costlob -- 审批成本归属
    ,o.clientx -- 图元X坐标
    ,o.clienty -- 图元Y坐标
    ,o.width -- 图元宽度
    ,o.heigth -- 图元高度
    ,o.groupinfo -- 分组信息
    ,o.processinstno -- 流程实例
    ,o.processtaskno -- 任务编号
    ,o.relativeobjectno -- 关联对象编号
    ,o.flowstate -- 工作流状态
    ,o.forkstate -- 
    ,o.version -- 系统未使用
    ,o.baseflowno -- 基础流程编号
    ,o.taskstate -- 任务状态
    ,o.forkno -- 
    ,o.allforkno -- 
    ,o.parentflowno -- 父流程编号
    ,o.assignedtaskno -- 
    ,o.relanoticeno -- 
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
from ${iol_schema}.abss_flow_task_bk o
    left join ${iol_schema}.abss_flow_task_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.abss_flow_task_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.abss_flow_task;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('abss_flow_task') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.abss_flow_task drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.abss_flow_task add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.abss_flow_task exchange partition p_${batch_date} with table ${iol_schema}.abss_flow_task_cl;
alter table ${iol_schema}.abss_flow_task exchange partition p_20991231 with table ${iol_schema}.abss_flow_task_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.abss_flow_task to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.abss_flow_task_op purge;
drop table ${iol_schema}.abss_flow_task_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.abss_flow_task_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'abss_flow_task',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
