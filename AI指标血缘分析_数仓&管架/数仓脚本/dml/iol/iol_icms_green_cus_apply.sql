/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_green_cus_apply
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
create table ${iol_schema}.icms_green_cus_apply_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_green_cus_apply
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_green_cus_apply_op purge;
drop table ${iol_schema}.icms_green_cus_apply_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_green_cus_apply_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_green_cus_apply where 0=1;

create table ${iol_schema}.icms_green_cus_apply_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_green_cus_apply where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_green_cus_apply_cl(
            serialno -- 申请流流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,attribute3 -- 预留字段3
            ,isfreshcust -- 是否绿色信贷
            ,inputuserid -- 用户编号
            ,attribute2 -- 预留字段2
            ,attribute4 -- 预留字段4
            ,attribute1 -- 预留字段1
            ,applystatus -- 申请状态
            ,customerid -- 客户号
            ,greencategory -- 绿色信贷类别
            ,inputtime -- 录入时间
            ,inputorgid -- 机构编号
            ,isgreenbonds -- 是否绿色债劵项目
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_green_cus_apply_op(
            serialno -- 申请流流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,attribute3 -- 预留字段3
            ,isfreshcust -- 是否绿色信贷
            ,inputuserid -- 用户编号
            ,attribute2 -- 预留字段2
            ,attribute4 -- 预留字段4
            ,attribute1 -- 预留字段1
            ,applystatus -- 申请状态
            ,customerid -- 客户号
            ,greencategory -- 绿色信贷类别
            ,inputtime -- 录入时间
            ,inputorgid -- 机构编号
            ,isgreenbonds -- 是否绿色债劵项目
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 申请流流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 预留字段3
    ,nvl(n.isfreshcust, o.isfreshcust) as isfreshcust -- 是否绿色信贷
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 用户编号
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 预留字段2
    ,nvl(n.attribute4, o.attribute4) as attribute4 -- 预留字段4
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 预留字段1
    ,nvl(n.applystatus, o.applystatus) as applystatus -- 申请状态
    ,nvl(n.customerid, o.customerid) as customerid -- 客户号
    ,nvl(n.greencategory, o.greencategory) as greencategory -- 绿色信贷类别
    ,nvl(n.inputtime, o.inputtime) as inputtime -- 录入时间
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 机构编号
    ,nvl(n.isgreenbonds, o.isgreenbonds) as isgreenbonds -- 是否绿色债劵项目
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
from (select * from ${iol_schema}.icms_green_cus_apply_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_green_cus_apply where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.migtflag <> n.migtflag
        or o.attribute3 <> n.attribute3
        or o.isfreshcust <> n.isfreshcust
        or o.inputuserid <> n.inputuserid
        or o.attribute2 <> n.attribute2
        or o.attribute4 <> n.attribute4
        or o.attribute1 <> n.attribute1
        or o.applystatus <> n.applystatus
        or o.customerid <> n.customerid
        or o.greencategory <> n.greencategory
        or o.inputtime <> n.inputtime
        or o.inputorgid <> n.inputorgid
        or o.isgreenbonds <> n.isgreenbonds
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_green_cus_apply_cl(
            serialno -- 申请流流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,attribute3 -- 预留字段3
            ,isfreshcust -- 是否绿色信贷
            ,inputuserid -- 用户编号
            ,attribute2 -- 预留字段2
            ,attribute4 -- 预留字段4
            ,attribute1 -- 预留字段1
            ,applystatus -- 申请状态
            ,customerid -- 客户号
            ,greencategory -- 绿色信贷类别
            ,inputtime -- 录入时间
            ,inputorgid -- 机构编号
            ,isgreenbonds -- 是否绿色债劵项目
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_green_cus_apply_op(
            serialno -- 申请流流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,attribute3 -- 预留字段3
            ,isfreshcust -- 是否绿色信贷
            ,inputuserid -- 用户编号
            ,attribute2 -- 预留字段2
            ,attribute4 -- 预留字段4
            ,attribute1 -- 预留字段1
            ,applystatus -- 申请状态
            ,customerid -- 客户号
            ,greencategory -- 绿色信贷类别
            ,inputtime -- 录入时间
            ,inputorgid -- 机构编号
            ,isgreenbonds -- 是否绿色债劵项目
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 申请流流水号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.attribute3 -- 预留字段3
    ,o.isfreshcust -- 是否绿色信贷
    ,o.inputuserid -- 用户编号
    ,o.attribute2 -- 预留字段2
    ,o.attribute4 -- 预留字段4
    ,o.attribute1 -- 预留字段1
    ,o.applystatus -- 申请状态
    ,o.customerid -- 客户号
    ,o.greencategory -- 绿色信贷类别
    ,o.inputtime -- 录入时间
    ,o.inputorgid -- 机构编号
    ,o.isgreenbonds -- 是否绿色债劵项目
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
from ${iol_schema}.icms_green_cus_apply_bk o
    left join ${iol_schema}.icms_green_cus_apply_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_green_cus_apply_cl d
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
--truncate table ${iol_schema}.icms_green_cus_apply;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_green_cus_apply') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_green_cus_apply drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_green_cus_apply add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_green_cus_apply exchange partition p_${batch_date} with table ${iol_schema}.icms_green_cus_apply_cl;
alter table ${iol_schema}.icms_green_cus_apply exchange partition p_20991231 with table ${iol_schema}.icms_green_cus_apply_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_green_cus_apply to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_green_cus_apply_op purge;
drop table ${iol_schema}.icms_green_cus_apply_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_green_cus_apply_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_green_cus_apply',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
