/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_clr_transfer_history
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
create table ${iol_schema}.icms_clr_transfer_history_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_clr_transfer_history
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_transfer_history_op purge;
drop table ${iol_schema}.icms_clr_transfer_history_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_clr_transfer_history_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_transfer_history where 0=1;

create table ${iol_schema}.icms_clr_transfer_history_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_clr_transfer_history where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_transfer_history_cl(
            serialno -- 记录流水号
            ,clrid -- 押品编号
            ,clrname -- 押品名称
            ,clrtypeid -- 押品资产类型编号
            ,oldmanageid -- 原管户人用户编号
            ,oldmanageorg -- 原管户人所属机构编号
            ,newmanageid -- 新管户人用户编号
            ,newmanageorg -- 新管户人所属机构编号
            ,operateuserid -- 操作人用户编号
            ,operateorgid -- 操作人所属机构编号
            ,operatetime -- 操作时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_transfer_history_op(
            serialno -- 记录流水号
            ,clrid -- 押品编号
            ,clrname -- 押品名称
            ,clrtypeid -- 押品资产类型编号
            ,oldmanageid -- 原管户人用户编号
            ,oldmanageorg -- 原管户人所属机构编号
            ,newmanageid -- 新管户人用户编号
            ,newmanageorg -- 新管户人所属机构编号
            ,operateuserid -- 操作人用户编号
            ,operateorgid -- 操作人所属机构编号
            ,operatetime -- 操作时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 记录流水号
    ,nvl(n.clrid, o.clrid) as clrid -- 押品编号
    ,nvl(n.clrname, o.clrname) as clrname -- 押品名称
    ,nvl(n.clrtypeid, o.clrtypeid) as clrtypeid -- 押品资产类型编号
    ,nvl(n.oldmanageid, o.oldmanageid) as oldmanageid -- 原管户人用户编号
    ,nvl(n.oldmanageorg, o.oldmanageorg) as oldmanageorg -- 原管户人所属机构编号
    ,nvl(n.newmanageid, o.newmanageid) as newmanageid -- 新管户人用户编号
    ,nvl(n.newmanageorg, o.newmanageorg) as newmanageorg -- 新管户人所属机构编号
    ,nvl(n.operateuserid, o.operateuserid) as operateuserid -- 操作人用户编号
    ,nvl(n.operateorgid, o.operateorgid) as operateorgid -- 操作人所属机构编号
    ,nvl(n.operatetime, o.operatetime) as operatetime -- 操作时间
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
from (select * from ${iol_schema}.icms_clr_transfer_history_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_clr_transfer_history where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.clrid <> n.clrid
        or o.clrname <> n.clrname
        or o.clrtypeid <> n.clrtypeid
        or o.oldmanageid <> n.oldmanageid
        or o.oldmanageorg <> n.oldmanageorg
        or o.newmanageid <> n.newmanageid
        or o.newmanageorg <> n.newmanageorg
        or o.operateuserid <> n.operateuserid
        or o.operateorgid <> n.operateorgid
        or o.operatetime <> n.operatetime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_clr_transfer_history_cl(
            serialno -- 记录流水号
            ,clrid -- 押品编号
            ,clrname -- 押品名称
            ,clrtypeid -- 押品资产类型编号
            ,oldmanageid -- 原管户人用户编号
            ,oldmanageorg -- 原管户人所属机构编号
            ,newmanageid -- 新管户人用户编号
            ,newmanageorg -- 新管户人所属机构编号
            ,operateuserid -- 操作人用户编号
            ,operateorgid -- 操作人所属机构编号
            ,operatetime -- 操作时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_clr_transfer_history_op(
            serialno -- 记录流水号
            ,clrid -- 押品编号
            ,clrname -- 押品名称
            ,clrtypeid -- 押品资产类型编号
            ,oldmanageid -- 原管户人用户编号
            ,oldmanageorg -- 原管户人所属机构编号
            ,newmanageid -- 新管户人用户编号
            ,newmanageorg -- 新管户人所属机构编号
            ,operateuserid -- 操作人用户编号
            ,operateorgid -- 操作人所属机构编号
            ,operatetime -- 操作时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 记录流水号
    ,o.clrid -- 押品编号
    ,o.clrname -- 押品名称
    ,o.clrtypeid -- 押品资产类型编号
    ,o.oldmanageid -- 原管户人用户编号
    ,o.oldmanageorg -- 原管户人所属机构编号
    ,o.newmanageid -- 新管户人用户编号
    ,o.newmanageorg -- 新管户人所属机构编号
    ,o.operateuserid -- 操作人用户编号
    ,o.operateorgid -- 操作人所属机构编号
    ,o.operatetime -- 操作时间
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
from ${iol_schema}.icms_clr_transfer_history_bk o
    left join ${iol_schema}.icms_clr_transfer_history_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_clr_transfer_history_cl d
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
--truncate table ${iol_schema}.icms_clr_transfer_history;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_clr_transfer_history') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_clr_transfer_history drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_clr_transfer_history add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_clr_transfer_history exchange partition p_${batch_date} with table ${iol_schema}.icms_clr_transfer_history_cl;
alter table ${iol_schema}.icms_clr_transfer_history exchange partition p_20991231 with table ${iol_schema}.icms_clr_transfer_history_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_clr_transfer_history to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_clr_transfer_history_op purge;
drop table ${iol_schema}.icms_clr_transfer_history_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_clr_transfer_history_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_clr_transfer_history',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
