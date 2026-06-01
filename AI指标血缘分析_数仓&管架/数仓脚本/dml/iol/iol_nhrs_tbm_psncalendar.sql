/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nhrs_tbm_psncalendar
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
create table ${iol_schema}.nhrs_tbm_psncalendar_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nhrs_tbm_psncalendar
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_tbm_psncalendar_op purge;
drop table ${iol_schema}.nhrs_tbm_psncalendar_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nhrs_tbm_psncalendar_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_tbm_psncalendar where 0=1;

create table ${iol_schema}.nhrs_tbm_psncalendar_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nhrs_tbm_psncalendar where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_tbm_psncalendar_cl(
            awaydatacostatus -- 出差数据是否汇总
            ,calendar -- 日历
            ,cancelflag -- 当日排班遇假日取消、保留的标志
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,datacreatestatus -- 考勤数据是否生成
            ,dataimportstatus -- 考勤机数据是否导入
            ,dr -- 备用DR
            ,gzsj -- 工作时长
            ,if_rest -- 是否休假
            ,isflexiblefinal -- 最终是否弹性
            ,isfromteam -- 是否来源于班组
            ,issolidifywhencalculation -- 是否生成考勤数据时固化
            ,iswtrecreate -- 工作时间段重新生成标志
            ,kqdatacostatus -- 考勤数据是否汇总
            ,leavedatacostatus -- 休假数据是否汇总
            ,modifiedtime -- 修改时间
            ,modifier -- 最后修改人
            ,original_shift_b4cut -- 假日切割前原班次
            ,original_shift_b4exg -- 假日对调前原班次
            ,overtimedatacostatus -- 加班数据是否汇总
            ,pk_group -- 集团主键
            ,pk_org -- 组织主键
            ,pk_psncalendar -- 人员工作日历主键
            ,pk_psndoc -- 人员基本信息
            ,pk_shift -- 班次主键
            ,ts -- 备用TS
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_tbm_psncalendar_op(
            awaydatacostatus -- 出差数据是否汇总
            ,calendar -- 日历
            ,cancelflag -- 当日排班遇假日取消、保留的标志
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,datacreatestatus -- 考勤数据是否生成
            ,dataimportstatus -- 考勤机数据是否导入
            ,dr -- 备用DR
            ,gzsj -- 工作时长
            ,if_rest -- 是否休假
            ,isflexiblefinal -- 最终是否弹性
            ,isfromteam -- 是否来源于班组
            ,issolidifywhencalculation -- 是否生成考勤数据时固化
            ,iswtrecreate -- 工作时间段重新生成标志
            ,kqdatacostatus -- 考勤数据是否汇总
            ,leavedatacostatus -- 休假数据是否汇总
            ,modifiedtime -- 修改时间
            ,modifier -- 最后修改人
            ,original_shift_b4cut -- 假日切割前原班次
            ,original_shift_b4exg -- 假日对调前原班次
            ,overtimedatacostatus -- 加班数据是否汇总
            ,pk_group -- 集团主键
            ,pk_org -- 组织主键
            ,pk_psncalendar -- 人员工作日历主键
            ,pk_psndoc -- 人员基本信息
            ,pk_shift -- 班次主键
            ,ts -- 备用TS
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.awaydatacostatus, o.awaydatacostatus) as awaydatacostatus -- 出差数据是否汇总
    ,nvl(n.calendar, o.calendar) as calendar -- 日历
    ,nvl(n.cancelflag, o.cancelflag) as cancelflag -- 当日排班遇假日取消、保留的标志
    ,nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.datacreatestatus, o.datacreatestatus) as datacreatestatus -- 考勤数据是否生成
    ,nvl(n.dataimportstatus, o.dataimportstatus) as dataimportstatus -- 考勤机数据是否导入
    ,nvl(n.dr, o.dr) as dr -- 备用DR
    ,nvl(n.gzsj, o.gzsj) as gzsj -- 工作时长
    ,nvl(n.if_rest, o.if_rest) as if_rest -- 是否休假
    ,nvl(n.isflexiblefinal, o.isflexiblefinal) as isflexiblefinal -- 最终是否弹性
    ,nvl(n.isfromteam, o.isfromteam) as isfromteam -- 是否来源于班组
    ,nvl(n.issolidifywhencalculation, o.issolidifywhencalculation) as issolidifywhencalculation -- 是否生成考勤数据时固化
    ,nvl(n.iswtrecreate, o.iswtrecreate) as iswtrecreate -- 工作时间段重新生成标志
    ,nvl(n.kqdatacostatus, o.kqdatacostatus) as kqdatacostatus -- 考勤数据是否汇总
    ,nvl(n.leavedatacostatus, o.leavedatacostatus) as leavedatacostatus -- 休假数据是否汇总
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 最后修改人
    ,nvl(n.original_shift_b4cut, o.original_shift_b4cut) as original_shift_b4cut -- 假日切割前原班次
    ,nvl(n.original_shift_b4exg, o.original_shift_b4exg) as original_shift_b4exg -- 假日对调前原班次
    ,nvl(n.overtimedatacostatus, o.overtimedatacostatus) as overtimedatacostatus -- 加班数据是否汇总
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 集团主键
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 组织主键
    ,nvl(n.pk_psncalendar, o.pk_psncalendar) as pk_psncalendar -- 人员工作日历主键
    ,nvl(n.pk_psndoc, o.pk_psndoc) as pk_psndoc -- 人员基本信息
    ,nvl(n.pk_shift, o.pk_shift) as pk_shift -- 班次主键
    ,nvl(n.ts, o.ts) as ts -- 备用TS
    ,case when
            n.pk_psncalendar is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_psncalendar is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_psncalendar is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nhrs_tbm_psncalendar_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nhrs_tbm_psncalendar where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_psncalendar = n.pk_psncalendar
where (
        o.pk_psncalendar is null
    )
    or (
        n.pk_psncalendar is null
    )
    or (
        o.awaydatacostatus <> n.awaydatacostatus
        or o.calendar <> n.calendar
        or o.cancelflag <> n.cancelflag
        or o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.datacreatestatus <> n.datacreatestatus
        or o.dataimportstatus <> n.dataimportstatus
        or o.dr <> n.dr
        or o.gzsj <> n.gzsj
        or o.if_rest <> n.if_rest
        or o.isflexiblefinal <> n.isflexiblefinal
        or o.isfromteam <> n.isfromteam
        or o.issolidifywhencalculation <> n.issolidifywhencalculation
        or o.iswtrecreate <> n.iswtrecreate
        or o.kqdatacostatus <> n.kqdatacostatus
        or o.leavedatacostatus <> n.leavedatacostatus
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.original_shift_b4cut <> n.original_shift_b4cut
        or o.original_shift_b4exg <> n.original_shift_b4exg
        or o.overtimedatacostatus <> n.overtimedatacostatus
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_psndoc <> n.pk_psndoc
        or o.pk_shift <> n.pk_shift
        or o.ts <> n.ts
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nhrs_tbm_psncalendar_cl(
            awaydatacostatus -- 出差数据是否汇总
            ,calendar -- 日历
            ,cancelflag -- 当日排班遇假日取消、保留的标志
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,datacreatestatus -- 考勤数据是否生成
            ,dataimportstatus -- 考勤机数据是否导入
            ,dr -- 备用DR
            ,gzsj -- 工作时长
            ,if_rest -- 是否休假
            ,isflexiblefinal -- 最终是否弹性
            ,isfromteam -- 是否来源于班组
            ,issolidifywhencalculation -- 是否生成考勤数据时固化
            ,iswtrecreate -- 工作时间段重新生成标志
            ,kqdatacostatus -- 考勤数据是否汇总
            ,leavedatacostatus -- 休假数据是否汇总
            ,modifiedtime -- 修改时间
            ,modifier -- 最后修改人
            ,original_shift_b4cut -- 假日切割前原班次
            ,original_shift_b4exg -- 假日对调前原班次
            ,overtimedatacostatus -- 加班数据是否汇总
            ,pk_group -- 集团主键
            ,pk_org -- 组织主键
            ,pk_psncalendar -- 人员工作日历主键
            ,pk_psndoc -- 人员基本信息
            ,pk_shift -- 班次主键
            ,ts -- 备用TS
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nhrs_tbm_psncalendar_op(
            awaydatacostatus -- 出差数据是否汇总
            ,calendar -- 日历
            ,cancelflag -- 当日排班遇假日取消、保留的标志
            ,creationtime -- 创建时间
            ,creator -- 创建人
            ,datacreatestatus -- 考勤数据是否生成
            ,dataimportstatus -- 考勤机数据是否导入
            ,dr -- 备用DR
            ,gzsj -- 工作时长
            ,if_rest -- 是否休假
            ,isflexiblefinal -- 最终是否弹性
            ,isfromteam -- 是否来源于班组
            ,issolidifywhencalculation -- 是否生成考勤数据时固化
            ,iswtrecreate -- 工作时间段重新生成标志
            ,kqdatacostatus -- 考勤数据是否汇总
            ,leavedatacostatus -- 休假数据是否汇总
            ,modifiedtime -- 修改时间
            ,modifier -- 最后修改人
            ,original_shift_b4cut -- 假日切割前原班次
            ,original_shift_b4exg -- 假日对调前原班次
            ,overtimedatacostatus -- 加班数据是否汇总
            ,pk_group -- 集团主键
            ,pk_org -- 组织主键
            ,pk_psncalendar -- 人员工作日历主键
            ,pk_psndoc -- 人员基本信息
            ,pk_shift -- 班次主键
            ,ts -- 备用TS
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.awaydatacostatus -- 出差数据是否汇总
    ,o.calendar -- 日历
    ,o.cancelflag -- 当日排班遇假日取消、保留的标志
    ,o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.datacreatestatus -- 考勤数据是否生成
    ,o.dataimportstatus -- 考勤机数据是否导入
    ,o.dr -- 备用DR
    ,o.gzsj -- 工作时长
    ,o.if_rest -- 是否休假
    ,o.isflexiblefinal -- 最终是否弹性
    ,o.isfromteam -- 是否来源于班组
    ,o.issolidifywhencalculation -- 是否生成考勤数据时固化
    ,o.iswtrecreate -- 工作时间段重新生成标志
    ,o.kqdatacostatus -- 考勤数据是否汇总
    ,o.leavedatacostatus -- 休假数据是否汇总
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 最后修改人
    ,o.original_shift_b4cut -- 假日切割前原班次
    ,o.original_shift_b4exg -- 假日对调前原班次
    ,o.overtimedatacostatus -- 加班数据是否汇总
    ,o.pk_group -- 集团主键
    ,o.pk_org -- 组织主键
    ,o.pk_psncalendar -- 人员工作日历主键
    ,o.pk_psndoc -- 人员基本信息
    ,o.pk_shift -- 班次主键
    ,o.ts -- 备用TS
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
from ${iol_schema}.nhrs_tbm_psncalendar_bk o
    left join ${iol_schema}.nhrs_tbm_psncalendar_op n
        on
            o.pk_psncalendar = n.pk_psncalendar
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nhrs_tbm_psncalendar_cl d
        on
            o.pk_psncalendar = d.pk_psncalendar
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nhrs_tbm_psncalendar;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nhrs_tbm_psncalendar') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nhrs_tbm_psncalendar drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nhrs_tbm_psncalendar add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nhrs_tbm_psncalendar exchange partition p_${batch_date} with table ${iol_schema}.nhrs_tbm_psncalendar_cl;
alter table ${iol_schema}.nhrs_tbm_psncalendar exchange partition p_20991231 with table ${iol_schema}.nhrs_tbm_psncalendar_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nhrs_tbm_psncalendar to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nhrs_tbm_psncalendar_op purge;
drop table ${iol_schema}.nhrs_tbm_psncalendar_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nhrs_tbm_psncalendar_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nhrs_tbm_psncalendar',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
