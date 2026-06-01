/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_meeting_fillinvote
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
create table ${iol_schema}.icms_meeting_fillinvote_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_meeting_fillinvote
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_meeting_fillinvote_op purge;
drop table ${iol_schema}.icms_meeting_fillinvote_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_meeting_fillinvote_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_meeting_fillinvote where 0=1;

create table ${iol_schema}.icms_meeting_fillinvote_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_meeting_fillinvote where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_meeting_fillinvote_cl(
            serialno -- 表决流水号
            ,meetingserialno -- 关联会议流水号
            ,meetinginveno -- 关联上会业务流水号
            ,customerid -- 客户编号
            ,isthreecategories -- 是否属于三类项目
            ,cuslevel -- 客户评级
            ,classifylevel -- 债项评级
            ,evaluatefl -- 风险定价分类
            ,opintion -- 审议意见
            ,allopinion -- 整体意见
            ,allsyopinion1 -- 整体审议意见
            ,saveflage -- 完整性标识
            ,confirmopiniontype -- 确认意见类型（1-同意，0-否决）
            ,confirmopinion1 -- 确认意见
            ,secretaryuserid -- 贷审会秘书用户编号
            ,leaderuserid -- 分行分管风险行领导用户编号
            ,confirmopiniondate -- 汇总日期
            ,allsyopinion -- 整体审议意见
            ,confirmopinion -- 确认意见
            ,vetoopinion -- 一票否决签署意见
            ,vetoopiniontype -- 一票否决签署意见类型
            ,presidentuserid -- 分行行长用户编号
            ,submitdate -- 提交日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_meeting_fillinvote_op(
            serialno -- 表决流水号
            ,meetingserialno -- 关联会议流水号
            ,meetinginveno -- 关联上会业务流水号
            ,customerid -- 客户编号
            ,isthreecategories -- 是否属于三类项目
            ,cuslevel -- 客户评级
            ,classifylevel -- 债项评级
            ,evaluatefl -- 风险定价分类
            ,opintion -- 审议意见
            ,allopinion -- 整体意见
            ,allsyopinion1 -- 整体审议意见
            ,saveflage -- 完整性标识
            ,confirmopiniontype -- 确认意见类型（1-同意，0-否决）
            ,confirmopinion1 -- 确认意见
            ,secretaryuserid -- 贷审会秘书用户编号
            ,leaderuserid -- 分行分管风险行领导用户编号
            ,confirmopiniondate -- 汇总日期
            ,allsyopinion -- 整体审议意见
            ,confirmopinion -- 确认意见
            ,vetoopinion -- 一票否决签署意见
            ,vetoopiniontype -- 一票否决签署意见类型
            ,presidentuserid -- 分行行长用户编号
            ,submitdate -- 提交日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 表决流水号
    ,nvl(n.meetingserialno, o.meetingserialno) as meetingserialno -- 关联会议流水号
    ,nvl(n.meetinginveno, o.meetinginveno) as meetinginveno -- 关联上会业务流水号
    ,nvl(n.customerid, o.customerid) as customerid -- 客户编号
    ,nvl(n.isthreecategories, o.isthreecategories) as isthreecategories -- 是否属于三类项目
    ,nvl(n.cuslevel, o.cuslevel) as cuslevel -- 客户评级
    ,nvl(n.classifylevel, o.classifylevel) as classifylevel -- 债项评级
    ,nvl(n.evaluatefl, o.evaluatefl) as evaluatefl -- 风险定价分类
    ,nvl(n.opintion, o.opintion) as opintion -- 审议意见
    ,nvl(n.allopinion, o.allopinion) as allopinion -- 整体意见
    ,nvl(n.allsyopinion1, o.allsyopinion1) as allsyopinion1 -- 整体审议意见
    ,nvl(n.saveflage, o.saveflage) as saveflage -- 完整性标识
    ,nvl(n.confirmopiniontype, o.confirmopiniontype) as confirmopiniontype -- 确认意见类型（1-同意，0-否决）
    ,nvl(n.confirmopinion1, o.confirmopinion1) as confirmopinion1 -- 确认意见
    ,nvl(n.secretaryuserid, o.secretaryuserid) as secretaryuserid -- 贷审会秘书用户编号
    ,nvl(n.leaderuserid, o.leaderuserid) as leaderuserid -- 分行分管风险行领导用户编号
    ,nvl(n.confirmopiniondate, o.confirmopiniondate) as confirmopiniondate -- 汇总日期
    ,nvl(n.allsyopinion, o.allsyopinion) as allsyopinion -- 整体审议意见
    ,nvl(n.confirmopinion, o.confirmopinion) as confirmopinion -- 确认意见
    ,nvl(n.vetoopinion, o.vetoopinion) as vetoopinion -- 一票否决签署意见
    ,nvl(n.vetoopiniontype, o.vetoopiniontype) as vetoopiniontype -- 一票否决签署意见类型
    ,nvl(n.presidentuserid, o.presidentuserid) as presidentuserid -- 分行行长用户编号
    ,nvl(n.submitdate, o.submitdate) as submitdate -- 提交日期
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
from (select * from ${iol_schema}.icms_meeting_fillinvote_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_meeting_fillinvote where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.meetingserialno <> n.meetingserialno
        or o.meetinginveno <> n.meetinginveno
        or o.customerid <> n.customerid
        or o.isthreecategories <> n.isthreecategories
        or o.cuslevel <> n.cuslevel
        or o.classifylevel <> n.classifylevel
        or o.evaluatefl <> n.evaluatefl
        or o.opintion <> n.opintion
        or o.allopinion <> n.allopinion
        or o.allsyopinion1 <> n.allsyopinion1
        or o.saveflage <> n.saveflage
        or o.confirmopiniontype <> n.confirmopiniontype
        or o.confirmopinion1 <> n.confirmopinion1
        or o.secretaryuserid <> n.secretaryuserid
        or o.leaderuserid <> n.leaderuserid
        or o.confirmopiniondate <> n.confirmopiniondate
        or o.allsyopinion <> n.allsyopinion
        or o.confirmopinion <> n.confirmopinion
        or o.vetoopinion <> n.vetoopinion
        or o.vetoopiniontype <> n.vetoopiniontype
        or o.presidentuserid <> n.presidentuserid
        or o.submitdate <> n.submitdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_meeting_fillinvote_cl(
            serialno -- 表决流水号
            ,meetingserialno -- 关联会议流水号
            ,meetinginveno -- 关联上会业务流水号
            ,customerid -- 客户编号
            ,isthreecategories -- 是否属于三类项目
            ,cuslevel -- 客户评级
            ,classifylevel -- 债项评级
            ,evaluatefl -- 风险定价分类
            ,opintion -- 审议意见
            ,allopinion -- 整体意见
            ,allsyopinion1 -- 整体审议意见
            ,saveflage -- 完整性标识
            ,confirmopiniontype -- 确认意见类型（1-同意，0-否决）
            ,confirmopinion1 -- 确认意见
            ,secretaryuserid -- 贷审会秘书用户编号
            ,leaderuserid -- 分行分管风险行领导用户编号
            ,confirmopiniondate -- 汇总日期
            ,allsyopinion -- 整体审议意见
            ,confirmopinion -- 确认意见
            ,vetoopinion -- 一票否决签署意见
            ,vetoopiniontype -- 一票否决签署意见类型
            ,presidentuserid -- 分行行长用户编号
            ,submitdate -- 提交日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_meeting_fillinvote_op(
            serialno -- 表决流水号
            ,meetingserialno -- 关联会议流水号
            ,meetinginveno -- 关联上会业务流水号
            ,customerid -- 客户编号
            ,isthreecategories -- 是否属于三类项目
            ,cuslevel -- 客户评级
            ,classifylevel -- 债项评级
            ,evaluatefl -- 风险定价分类
            ,opintion -- 审议意见
            ,allopinion -- 整体意见
            ,allsyopinion1 -- 整体审议意见
            ,saveflage -- 完整性标识
            ,confirmopiniontype -- 确认意见类型（1-同意，0-否决）
            ,confirmopinion1 -- 确认意见
            ,secretaryuserid -- 贷审会秘书用户编号
            ,leaderuserid -- 分行分管风险行领导用户编号
            ,confirmopiniondate -- 汇总日期
            ,allsyopinion -- 整体审议意见
            ,confirmopinion -- 确认意见
            ,vetoopinion -- 一票否决签署意见
            ,vetoopiniontype -- 一票否决签署意见类型
            ,presidentuserid -- 分行行长用户编号
            ,submitdate -- 提交日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 表决流水号
    ,o.meetingserialno -- 关联会议流水号
    ,o.meetinginveno -- 关联上会业务流水号
    ,o.customerid -- 客户编号
    ,o.isthreecategories -- 是否属于三类项目
    ,o.cuslevel -- 客户评级
    ,o.classifylevel -- 债项评级
    ,o.evaluatefl -- 风险定价分类
    ,o.opintion -- 审议意见
    ,o.allopinion -- 整体意见
    ,o.allsyopinion1 -- 整体审议意见
    ,o.saveflage -- 完整性标识
    ,o.confirmopiniontype -- 确认意见类型（1-同意，0-否决）
    ,o.confirmopinion1 -- 确认意见
    ,o.secretaryuserid -- 贷审会秘书用户编号
    ,o.leaderuserid -- 分行分管风险行领导用户编号
    ,o.confirmopiniondate -- 汇总日期
    ,o.allsyopinion -- 整体审议意见
    ,o.confirmopinion -- 确认意见
    ,o.vetoopinion -- 一票否决签署意见
    ,o.vetoopiniontype -- 一票否决签署意见类型
    ,o.presidentuserid -- 分行行长用户编号
    ,o.submitdate -- 提交日期
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
from ${iol_schema}.icms_meeting_fillinvote_bk o
    left join ${iol_schema}.icms_meeting_fillinvote_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_meeting_fillinvote_cl d
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
--truncate table ${iol_schema}.icms_meeting_fillinvote;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_meeting_fillinvote') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_meeting_fillinvote drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_meeting_fillinvote add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_meeting_fillinvote exchange partition p_${batch_date} with table ${iol_schema}.icms_meeting_fillinvote_cl;
alter table ${iol_schema}.icms_meeting_fillinvote exchange partition p_20991231 with table ${iol_schema}.icms_meeting_fillinvote_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_meeting_fillinvote to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_meeting_fillinvote_op purge;
drop table ${iol_schema}.icms_meeting_fillinvote_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_meeting_fillinvote_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_meeting_fillinvote',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
