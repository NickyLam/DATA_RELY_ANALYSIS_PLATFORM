/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_flow_task
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
create table ${iol_schema}.icms_flow_task_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_flow_task
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_flow_task_op purge;
drop table ${iol_schema}.icms_flow_task_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_flow_task_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_flow_task where 0=1;

create table ${iol_schema}.icms_flow_task_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_flow_task where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_flow_task_cl(
            serialno -- 流程节点编号
            ,endtime -- 结束时间
            ,riskscanresult -- 风险探测结果
            ,standardtime1 -- 标准审批用时
            ,flowstate -- 流程状态
            ,phasetype -- 当前阶段类型
            ,phaseopinion1 -- 节点意见1
            ,standardtime2 -- 最长审批用时
            ,phasename -- 当前阶段名称
            ,applytype -- 申请类型
            ,relativeobjectno -- 流程对象流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,flowname -- 流程模型名称
            ,orgname -- 机构名称
            ,relanoticeno -- 关联意见号
            ,relativeserialno -- 上一流水号字段
            ,flowno -- 流程模型编号
            ,forkstate -- 分支状态
            ,forkno -- 并行分支编号
            ,phaseopinion4 -- 意见详情4
            ,version -- 版本
            ,clienty -- 图元Y坐标
            ,width -- 图元宽度
            ,baseflowno -- 流程号
            ,phaseopinion -- 意见详情
            ,objectno -- 流程对象编号
            ,phaseno -- 当前阶段编号
            ,userid -- 用户编号
            ,processtaskno -- 流程任务编号
            ,begintime -- 开始日期
            ,costlob -- 审批成本归属
            ,allforkno -- 所有的并行分支编号
            ,groupinfo -- 集团信息
            ,objecttype -- 流程对象任务类型
            ,username -- 用户名称
            ,orgid -- 登记机构
            ,owner -- 所属人
            ,processinstno -- 流程实例编号
            ,phaseaction -- 节点操作
            ,phaseopinion2 -- 意见详情2
            ,checklistresult -- 检查清单结果
            ,autodecision -- 自动审批判断结果
            ,assignedtaskno -- 指定任务编号
            ,taskstate -- 任务状态
            ,parentflowno -- 父流程号
            ,phasechoice -- 阶段意见
            ,phaseopinion3 -- 意见详情3
            ,clientx -- 图元X坐标
            ,heigth -- 图元高度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_flow_task_op(
            serialno -- 流程节点编号
            ,endtime -- 结束时间
            ,riskscanresult -- 风险探测结果
            ,standardtime1 -- 标准审批用时
            ,flowstate -- 流程状态
            ,phasetype -- 当前阶段类型
            ,phaseopinion1 -- 节点意见1
            ,standardtime2 -- 最长审批用时
            ,phasename -- 当前阶段名称
            ,applytype -- 申请类型
            ,relativeobjectno -- 流程对象流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,flowname -- 流程模型名称
            ,orgname -- 机构名称
            ,relanoticeno -- 关联意见号
            ,relativeserialno -- 上一流水号字段
            ,flowno -- 流程模型编号
            ,forkstate -- 分支状态
            ,forkno -- 并行分支编号
            ,phaseopinion4 -- 意见详情4
            ,version -- 版本
            ,clienty -- 图元Y坐标
            ,width -- 图元宽度
            ,baseflowno -- 流程号
            ,phaseopinion -- 意见详情
            ,objectno -- 流程对象编号
            ,phaseno -- 当前阶段编号
            ,userid -- 用户编号
            ,processtaskno -- 流程任务编号
            ,begintime -- 开始日期
            ,costlob -- 审批成本归属
            ,allforkno -- 所有的并行分支编号
            ,groupinfo -- 集团信息
            ,objecttype -- 流程对象任务类型
            ,username -- 用户名称
            ,orgid -- 登记机构
            ,owner -- 所属人
            ,processinstno -- 流程实例编号
            ,phaseaction -- 节点操作
            ,phaseopinion2 -- 意见详情2
            ,checklistresult -- 检查清单结果
            ,autodecision -- 自动审批判断结果
            ,assignedtaskno -- 指定任务编号
            ,taskstate -- 任务状态
            ,parentflowno -- 父流程号
            ,phasechoice -- 阶段意见
            ,phaseopinion3 -- 意见详情3
            ,clientx -- 图元X坐标
            ,heigth -- 图元高度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流程节点编号
    ,nvl(n.endtime, o.endtime) as endtime -- 结束时间
    ,nvl(n.riskscanresult, o.riskscanresult) as riskscanresult -- 风险探测结果
    ,nvl(n.standardtime1, o.standardtime1) as standardtime1 -- 标准审批用时
    ,nvl(n.flowstate, o.flowstate) as flowstate -- 流程状态
    ,nvl(n.phasetype, o.phasetype) as phasetype -- 当前阶段类型
    ,nvl(n.phaseopinion1, o.phaseopinion1) as phaseopinion1 -- 节点意见1
    ,nvl(n.standardtime2, o.standardtime2) as standardtime2 -- 最长审批用时
    ,nvl(n.phasename, o.phasename) as phasename -- 当前阶段名称
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型
    ,nvl(n.relativeobjectno, o.relativeobjectno) as relativeobjectno -- 流程对象流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.flowname, o.flowname) as flowname -- 流程模型名称
    ,nvl(n.orgname, o.orgname) as orgname -- 机构名称
    ,nvl(n.relanoticeno, o.relanoticeno) as relanoticeno -- 关联意见号
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 上一流水号字段
    ,nvl(n.flowno, o.flowno) as flowno -- 流程模型编号
    ,nvl(n.forkstate, o.forkstate) as forkstate -- 分支状态
    ,nvl(n.forkno, o.forkno) as forkno -- 并行分支编号
    ,nvl(n.phaseopinion4, o.phaseopinion4) as phaseopinion4 -- 意见详情4
    ,nvl(n.version, o.version) as version -- 版本
    ,nvl(n.clienty, o.clienty) as clienty -- 图元Y坐标
    ,nvl(n.width, o.width) as width -- 图元宽度
    ,nvl(n.baseflowno, o.baseflowno) as baseflowno -- 流程号
    ,nvl(n.phaseopinion, o.phaseopinion) as phaseopinion -- 意见详情
    ,nvl(n.objectno, o.objectno) as objectno -- 流程对象编号
    ,nvl(n.phaseno, o.phaseno) as phaseno -- 当前阶段编号
    ,nvl(n.userid, o.userid) as userid -- 用户编号
    ,nvl(n.processtaskno, o.processtaskno) as processtaskno -- 流程任务编号
    ,nvl(n.begintime, o.begintime) as begintime -- 开始日期
    ,nvl(n.costlob, o.costlob) as costlob -- 审批成本归属
    ,nvl(n.allforkno, o.allforkno) as allforkno -- 所有的并行分支编号
    ,nvl(n.groupinfo, o.groupinfo) as groupinfo -- 集团信息
    ,nvl(n.objecttype, o.objecttype) as objecttype -- 流程对象任务类型
    ,nvl(n.username, o.username) as username -- 用户名称
    ,nvl(n.orgid, o.orgid) as orgid -- 登记机构
    ,nvl(n.owner, o.owner) as owner -- 所属人
    ,nvl(n.processinstno, o.processinstno) as processinstno -- 流程实例编号
    ,nvl(n.phaseaction, o.phaseaction) as phaseaction -- 节点操作
    ,nvl(n.phaseopinion2, o.phaseopinion2) as phaseopinion2 -- 意见详情2
    ,nvl(n.checklistresult, o.checklistresult) as checklistresult -- 检查清单结果
    ,nvl(n.autodecision, o.autodecision) as autodecision -- 自动审批判断结果
    ,nvl(n.assignedtaskno, o.assignedtaskno) as assignedtaskno -- 指定任务编号
    ,nvl(n.taskstate, o.taskstate) as taskstate -- 任务状态
    ,nvl(n.parentflowno, o.parentflowno) as parentflowno -- 父流程号
    ,nvl(n.phasechoice, o.phasechoice) as phasechoice -- 阶段意见
    ,nvl(n.phaseopinion3, o.phaseopinion3) as phaseopinion3 -- 意见详情3
    ,nvl(n.clientx, o.clientx) as clientx -- 图元X坐标
    ,nvl(n.heigth, o.heigth) as heigth -- 图元高度
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
from (select * from ${iol_schema}.icms_flow_task_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_flow_task where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.endtime <> n.endtime
        or o.riskscanresult <> n.riskscanresult
        or o.standardtime1 <> n.standardtime1
        or o.flowstate <> n.flowstate
        or o.phasetype <> n.phasetype
        or o.phaseopinion1 <> n.phaseopinion1
        or o.standardtime2 <> n.standardtime2
        or o.phasename <> n.phasename
        or o.applytype <> n.applytype
        or o.relativeobjectno <> n.relativeobjectno
        or o.migtflag <> n.migtflag
        or o.flowname <> n.flowname
        or o.orgname <> n.orgname
        or o.relanoticeno <> n.relanoticeno
        or o.relativeserialno <> n.relativeserialno
        or o.flowno <> n.flowno
        or o.forkstate <> n.forkstate
        or o.forkno <> n.forkno
        or o.phaseopinion4 <> n.phaseopinion4
        or o.version <> n.version
        or o.clienty <> n.clienty
        or o.width <> n.width
        or o.baseflowno <> n.baseflowno
        or o.phaseopinion <> n.phaseopinion
        or o.objectno <> n.objectno
        or o.phaseno <> n.phaseno
        or o.userid <> n.userid
        or o.processtaskno <> n.processtaskno
        or o.begintime <> n.begintime
        or o.costlob <> n.costlob
        or o.allforkno <> n.allforkno
        or o.groupinfo <> n.groupinfo
        or o.objecttype <> n.objecttype
        or o.username <> n.username
        or o.orgid <> n.orgid
        or o.owner <> n.owner
        or o.processinstno <> n.processinstno
        or o.phaseaction <> n.phaseaction
        or o.phaseopinion2 <> n.phaseopinion2
        or o.checklistresult <> n.checklistresult
        or o.autodecision <> n.autodecision
        or o.assignedtaskno <> n.assignedtaskno
        or o.taskstate <> n.taskstate
        or o.parentflowno <> n.parentflowno
        or o.phasechoice <> n.phasechoice
        or o.phaseopinion3 <> n.phaseopinion3
        or o.clientx <> n.clientx
        or o.heigth <> n.heigth
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_flow_task_cl(
            serialno -- 流程节点编号
            ,endtime -- 结束时间
            ,riskscanresult -- 风险探测结果
            ,standardtime1 -- 标准审批用时
            ,flowstate -- 流程状态
            ,phasetype -- 当前阶段类型
            ,phaseopinion1 -- 节点意见1
            ,standardtime2 -- 最长审批用时
            ,phasename -- 当前阶段名称
            ,applytype -- 申请类型
            ,relativeobjectno -- 流程对象流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,flowname -- 流程模型名称
            ,orgname -- 机构名称
            ,relanoticeno -- 关联意见号
            ,relativeserialno -- 上一流水号字段
            ,flowno -- 流程模型编号
            ,forkstate -- 分支状态
            ,forkno -- 并行分支编号
            ,phaseopinion4 -- 意见详情4
            ,version -- 版本
            ,clienty -- 图元Y坐标
            ,width -- 图元宽度
            ,baseflowno -- 流程号
            ,phaseopinion -- 意见详情
            ,objectno -- 流程对象编号
            ,phaseno -- 当前阶段编号
            ,userid -- 用户编号
            ,processtaskno -- 流程任务编号
            ,begintime -- 开始日期
            ,costlob -- 审批成本归属
            ,allforkno -- 所有的并行分支编号
            ,groupinfo -- 集团信息
            ,objecttype -- 流程对象任务类型
            ,username -- 用户名称
            ,orgid -- 登记机构
            ,owner -- 所属人
            ,processinstno -- 流程实例编号
            ,phaseaction -- 节点操作
            ,phaseopinion2 -- 意见详情2
            ,checklistresult -- 检查清单结果
            ,autodecision -- 自动审批判断结果
            ,assignedtaskno -- 指定任务编号
            ,taskstate -- 任务状态
            ,parentflowno -- 父流程号
            ,phasechoice -- 阶段意见
            ,phaseopinion3 -- 意见详情3
            ,clientx -- 图元X坐标
            ,heigth -- 图元高度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_flow_task_op(
            serialno -- 流程节点编号
            ,endtime -- 结束时间
            ,riskscanresult -- 风险探测结果
            ,standardtime1 -- 标准审批用时
            ,flowstate -- 流程状态
            ,phasetype -- 当前阶段类型
            ,phaseopinion1 -- 节点意见1
            ,standardtime2 -- 最长审批用时
            ,phasename -- 当前阶段名称
            ,applytype -- 申请类型
            ,relativeobjectno -- 流程对象流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,flowname -- 流程模型名称
            ,orgname -- 机构名称
            ,relanoticeno -- 关联意见号
            ,relativeserialno -- 上一流水号字段
            ,flowno -- 流程模型编号
            ,forkstate -- 分支状态
            ,forkno -- 并行分支编号
            ,phaseopinion4 -- 意见详情4
            ,version -- 版本
            ,clienty -- 图元Y坐标
            ,width -- 图元宽度
            ,baseflowno -- 流程号
            ,phaseopinion -- 意见详情
            ,objectno -- 流程对象编号
            ,phaseno -- 当前阶段编号
            ,userid -- 用户编号
            ,processtaskno -- 流程任务编号
            ,begintime -- 开始日期
            ,costlob -- 审批成本归属
            ,allforkno -- 所有的并行分支编号
            ,groupinfo -- 集团信息
            ,objecttype -- 流程对象任务类型
            ,username -- 用户名称
            ,orgid -- 登记机构
            ,owner -- 所属人
            ,processinstno -- 流程实例编号
            ,phaseaction -- 节点操作
            ,phaseopinion2 -- 意见详情2
            ,checklistresult -- 检查清单结果
            ,autodecision -- 自动审批判断结果
            ,assignedtaskno -- 指定任务编号
            ,taskstate -- 任务状态
            ,parentflowno -- 父流程号
            ,phasechoice -- 阶段意见
            ,phaseopinion3 -- 意见详情3
            ,clientx -- 图元X坐标
            ,heigth -- 图元高度
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流程节点编号
    ,o.endtime -- 结束时间
    ,o.riskscanresult -- 风险探测结果
    ,o.standardtime1 -- 标准审批用时
    ,o.flowstate -- 流程状态
    ,o.phasetype -- 当前阶段类型
    ,o.phaseopinion1 -- 节点意见1
    ,o.standardtime2 -- 最长审批用时
    ,o.phasename -- 当前阶段名称
    ,o.applytype -- 申请类型
    ,o.relativeobjectno -- 流程对象流水号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.flowname -- 流程模型名称
    ,o.orgname -- 机构名称
    ,o.relanoticeno -- 关联意见号
    ,o.relativeserialno -- 上一流水号字段
    ,o.flowno -- 流程模型编号
    ,o.forkstate -- 分支状态
    ,o.forkno -- 并行分支编号
    ,o.phaseopinion4 -- 意见详情4
    ,o.version -- 版本
    ,o.clienty -- 图元Y坐标
    ,o.width -- 图元宽度
    ,o.baseflowno -- 流程号
    ,o.phaseopinion -- 意见详情
    ,o.objectno -- 流程对象编号
    ,o.phaseno -- 当前阶段编号
    ,o.userid -- 用户编号
    ,o.processtaskno -- 流程任务编号
    ,o.begintime -- 开始日期
    ,o.costlob -- 审批成本归属
    ,o.allforkno -- 所有的并行分支编号
    ,o.groupinfo -- 集团信息
    ,o.objecttype -- 流程对象任务类型
    ,o.username -- 用户名称
    ,o.orgid -- 登记机构
    ,o.owner -- 所属人
    ,o.processinstno -- 流程实例编号
    ,o.phaseaction -- 节点操作
    ,o.phaseopinion2 -- 意见详情2
    ,o.checklistresult -- 检查清单结果
    ,o.autodecision -- 自动审批判断结果
    ,o.assignedtaskno -- 指定任务编号
    ,o.taskstate -- 任务状态
    ,o.parentflowno -- 父流程号
    ,o.phasechoice -- 阶段意见
    ,o.phaseopinion3 -- 意见详情3
    ,o.clientx -- 图元X坐标
    ,o.heigth -- 图元高度
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
from ${iol_schema}.icms_flow_task_bk o
    left join ${iol_schema}.icms_flow_task_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_flow_task_cl d
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
--truncate table ${iol_schema}.icms_flow_task;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_flow_task') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_flow_task drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_flow_task add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_flow_task exchange partition p_${batch_date} with table ${iol_schema}.icms_flow_task_cl;
alter table ${iol_schema}.icms_flow_task exchange partition p_20991231 with table ${iol_schema}.icms_flow_task_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_flow_task to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_flow_task_op purge;
drop table ${iol_schema}.icms_flow_task_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_flow_task_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_flow_task',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
