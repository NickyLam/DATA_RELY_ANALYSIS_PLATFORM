/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_flow_object
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
create table ${iol_schema}.icms_flow_object_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_flow_object
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_flow_object_op purge;
drop table ${iol_schema}.icms_flow_object_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_flow_object_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_flow_object where 0=1;

create table ${iol_schema}.icms_flow_object_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_flow_object where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_flow_object_cl(
            objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,userid -- 登记人编号
            ,relativetaskno -- 关联流程对象流水号
            ,flowname -- 流程模型名称
            ,orgname -- 评估单位
            ,processinstno -- 流程实例编号
            ,phasename -- 当前阶段名称
            ,objattribute2 -- 流程属性2
            ,applyno -- 申请编号
            ,baseflowno -- 流程号
            ,flowno -- 流程模型编号
            ,objattribute5 -- 流程属性5
            ,archivetime -- 归档时刻
            ,objattribute4 -- 流程属性4
            ,username -- 登记人名称
            ,orgid -- 登记机构号
            ,objattribute1 -- 流程属性1
            ,objattribute3 -- 流程属性3
            ,flowstate -- 流程状态
            ,processtaskno -- 流程任务编号
            ,serialno -- 流程对象流水号
            ,phaseno -- 当前阶段编号
            ,objdescribe -- 流程描述
            ,applytype -- 申请类型
            ,tasktype -- 任务类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,phasetype -- 当前阶段类型
            ,archive -- 归档标识
            ,version -- 版本
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_flow_object_op(
            objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,userid -- 登记人编号
            ,relativetaskno -- 关联流程对象流水号
            ,flowname -- 流程模型名称
            ,orgname -- 评估单位
            ,processinstno -- 流程实例编号
            ,phasename -- 当前阶段名称
            ,objattribute2 -- 流程属性2
            ,applyno -- 申请编号
            ,baseflowno -- 流程号
            ,flowno -- 流程模型编号
            ,objattribute5 -- 流程属性5
            ,archivetime -- 归档时刻
            ,objattribute4 -- 流程属性4
            ,username -- 登记人名称
            ,orgid -- 登记机构号
            ,objattribute1 -- 流程属性1
            ,objattribute3 -- 流程属性3
            ,flowstate -- 流程状态
            ,processtaskno -- 流程任务编号
            ,serialno -- 流程对象流水号
            ,phaseno -- 当前阶段编号
            ,objdescribe -- 流程描述
            ,applytype -- 申请类型
            ,tasktype -- 任务类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,phasetype -- 当前阶段类型
            ,archive -- 归档标识
            ,version -- 版本
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.objecttype, o.objecttype) as objecttype -- 流程对象任务类型
    ,nvl(n.objectno, o.objectno) as objectno -- 流程对象编号
    ,nvl(n.userid, o.userid) as userid -- 登记人编号
    ,nvl(n.relativetaskno, o.relativetaskno) as relativetaskno -- 关联流程对象流水号
    ,nvl(n.flowname, o.flowname) as flowname -- 流程模型名称
    ,nvl(n.orgname, o.orgname) as orgname -- 评估单位
    ,nvl(n.processinstno, o.processinstno) as processinstno -- 流程实例编号
    ,nvl(n.phasename, o.phasename) as phasename -- 当前阶段名称
    ,nvl(n.objattribute2, o.objattribute2) as objattribute2 -- 流程属性2
    ,nvl(n.applyno, o.applyno) as applyno -- 申请编号
    ,nvl(n.baseflowno, o.baseflowno) as baseflowno -- 流程号
    ,nvl(n.flowno, o.flowno) as flowno -- 流程模型编号
    ,nvl(n.objattribute5, o.objattribute5) as objattribute5 -- 流程属性5
    ,nvl(n.archivetime, o.archivetime) as archivetime -- 归档时刻
    ,nvl(n.objattribute4, o.objattribute4) as objattribute4 -- 流程属性4
    ,nvl(n.username, o.username) as username -- 登记人名称
    ,nvl(n.orgid, o.orgid) as orgid -- 登记机构号
    ,nvl(n.objattribute1, o.objattribute1) as objattribute1 -- 流程属性1
    ,nvl(n.objattribute3, o.objattribute3) as objattribute3 -- 流程属性3
    ,nvl(n.flowstate, o.flowstate) as flowstate -- 流程状态
    ,nvl(n.processtaskno, o.processtaskno) as processtaskno -- 流程任务编号
    ,nvl(n.serialno, o.serialno) as serialno -- 流程对象流水号
    ,nvl(n.phaseno, o.phaseno) as phaseno -- 当前阶段编号
    ,nvl(n.objdescribe, o.objdescribe) as objdescribe -- 流程描述
    ,nvl(n.applytype, o.applytype) as applytype -- 申请类型
    ,nvl(n.tasktype, o.tasktype) as tasktype -- 任务类型
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.phasetype, o.phasetype) as phasetype -- 当前阶段类型
    ,nvl(n.archive, o.archive) as archive -- 归档标识
    ,nvl(n.version, o.version) as version -- 版本
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,case when
            n.objecttype is null
            and n.objectno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.objecttype is null
            and n.objectno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.objecttype is null
            and n.objectno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_flow_object_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_flow_object where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.objecttype = n.objecttype
            and o.objectno = n.objectno
where (
        o.objecttype is null
        and o.objectno is null
    )
    or (
        n.objecttype is null
        and n.objectno is null
    )
    or (
        o.userid <> n.userid
        or o.relativetaskno <> n.relativetaskno
        or o.flowname <> n.flowname
        or o.orgname <> n.orgname
        or o.processinstno <> n.processinstno
        or o.phasename <> n.phasename
        or o.objattribute2 <> n.objattribute2
        or o.applyno <> n.applyno
        or o.baseflowno <> n.baseflowno
        or o.flowno <> n.flowno
        or o.objattribute5 <> n.objattribute5
        or o.archivetime <> n.archivetime
        or o.objattribute4 <> n.objattribute4
        or o.username <> n.username
        or o.orgid <> n.orgid
        or o.objattribute1 <> n.objattribute1
        or o.objattribute3 <> n.objattribute3
        or o.flowstate <> n.flowstate
        or o.processtaskno <> n.processtaskno
        or o.serialno <> n.serialno
        or o.phaseno <> n.phaseno
        or o.objdescribe <> n.objdescribe
        or o.applytype <> n.applytype
        or o.tasktype <> n.tasktype
        or o.migtflag <> n.migtflag
        or o.phasetype <> n.phasetype
        or o.archive <> n.archive
        or o.version <> n.version
        or o.inputdate <> n.inputdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_flow_object_cl(
            objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,userid -- 登记人编号
            ,relativetaskno -- 关联流程对象流水号
            ,flowname -- 流程模型名称
            ,orgname -- 评估单位
            ,processinstno -- 流程实例编号
            ,phasename -- 当前阶段名称
            ,objattribute2 -- 流程属性2
            ,applyno -- 申请编号
            ,baseflowno -- 流程号
            ,flowno -- 流程模型编号
            ,objattribute5 -- 流程属性5
            ,archivetime -- 归档时刻
            ,objattribute4 -- 流程属性4
            ,username -- 登记人名称
            ,orgid -- 登记机构号
            ,objattribute1 -- 流程属性1
            ,objattribute3 -- 流程属性3
            ,flowstate -- 流程状态
            ,processtaskno -- 流程任务编号
            ,serialno -- 流程对象流水号
            ,phaseno -- 当前阶段编号
            ,objdescribe -- 流程描述
            ,applytype -- 申请类型
            ,tasktype -- 任务类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,phasetype -- 当前阶段类型
            ,archive -- 归档标识
            ,version -- 版本
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_flow_object_op(
            objecttype -- 流程对象任务类型
            ,objectno -- 流程对象编号
            ,userid -- 登记人编号
            ,relativetaskno -- 关联流程对象流水号
            ,flowname -- 流程模型名称
            ,orgname -- 评估单位
            ,processinstno -- 流程实例编号
            ,phasename -- 当前阶段名称
            ,objattribute2 -- 流程属性2
            ,applyno -- 申请编号
            ,baseflowno -- 流程号
            ,flowno -- 流程模型编号
            ,objattribute5 -- 流程属性5
            ,archivetime -- 归档时刻
            ,objattribute4 -- 流程属性4
            ,username -- 登记人名称
            ,orgid -- 登记机构号
            ,objattribute1 -- 流程属性1
            ,objattribute3 -- 流程属性3
            ,flowstate -- 流程状态
            ,processtaskno -- 流程任务编号
            ,serialno -- 流程对象流水号
            ,phaseno -- 当前阶段编号
            ,objdescribe -- 流程描述
            ,applytype -- 申请类型
            ,tasktype -- 任务类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,phasetype -- 当前阶段类型
            ,archive -- 归档标识
            ,version -- 版本
            ,inputdate -- 登记日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.objecttype -- 流程对象任务类型
    ,o.objectno -- 流程对象编号
    ,o.userid -- 登记人编号
    ,o.relativetaskno -- 关联流程对象流水号
    ,o.flowname -- 流程模型名称
    ,o.orgname -- 评估单位
    ,o.processinstno -- 流程实例编号
    ,o.phasename -- 当前阶段名称
    ,o.objattribute2 -- 流程属性2
    ,o.applyno -- 申请编号
    ,o.baseflowno -- 流程号
    ,o.flowno -- 流程模型编号
    ,o.objattribute5 -- 流程属性5
    ,o.archivetime -- 归档时刻
    ,o.objattribute4 -- 流程属性4
    ,o.username -- 登记人名称
    ,o.orgid -- 登记机构号
    ,o.objattribute1 -- 流程属性1
    ,o.objattribute3 -- 流程属性3
    ,o.flowstate -- 流程状态
    ,o.processtaskno -- 流程任务编号
    ,o.serialno -- 流程对象流水号
    ,o.phaseno -- 当前阶段编号
    ,o.objdescribe -- 流程描述
    ,o.applytype -- 申请类型
    ,o.tasktype -- 任务类型
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.phasetype -- 当前阶段类型
    ,o.archive -- 归档标识
    ,o.version -- 版本
    ,o.inputdate -- 登记日期
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
from ${iol_schema}.icms_flow_object_bk o
    left join ${iol_schema}.icms_flow_object_op n
        on
            o.objecttype = n.objecttype
            and o.objectno = n.objectno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_flow_object_cl d
        on
            o.objecttype = d.objecttype
            and o.objectno = d.objectno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_flow_object;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_flow_object') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_flow_object drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_flow_object add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_flow_object exchange partition p_${batch_date} with table ${iol_schema}.icms_flow_object_cl;
alter table ${iol_schema}.icms_flow_object exchange partition p_20991231 with table ${iol_schema}.icms_flow_object_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_flow_object to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_flow_object_op purge;
drop table ${iol_schema}.icms_flow_object_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_flow_object_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_flow_object',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
