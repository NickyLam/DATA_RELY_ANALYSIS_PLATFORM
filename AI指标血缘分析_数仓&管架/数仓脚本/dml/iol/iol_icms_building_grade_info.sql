/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_building_grade_info
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
create table ${iol_schema}.icms_building_grade_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_building_grade_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_building_grade_info_op purge;
drop table ${iol_schema}.icms_building_grade_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_building_grade_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_building_grade_info where 0=1;

create table ${iol_schema}.icms_building_grade_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_building_grade_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_building_grade_info_cl(
            serialno -- 流水号
            ,bldgencd -- 楼盘编码
            ,rowcount -- 条数
            ,message -- 说明
            ,data -- 数据域
            ,remark -- 备注
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,regioncd -- 行政区划代码
            ,prptycomplloc -- 物业完整地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_building_grade_info_op(
            serialno -- 流水号
            ,bldgencd -- 楼盘编码
            ,rowcount -- 条数
            ,message -- 说明
            ,data -- 数据域
            ,remark -- 备注
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,regioncd -- 行政区划代码
            ,prptycomplloc -- 物业完整地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.bldgencd, o.bldgencd) as bldgencd -- 楼盘编码
    ,nvl(n.rowcount, o.rowcount) as rowcount -- 条数
    ,nvl(n.message, o.message) as message -- 说明
    ,nvl(n.data, o.data) as data -- 数据域
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.attribute1, o.attribute1) as attribute1 -- 属性1
    ,nvl(n.attribute2, o.attribute2) as attribute2 -- 属性2
    ,nvl(n.attribute3, o.attribute3) as attribute3 -- 属性3
    ,nvl(n.regioncd, o.regioncd) as regioncd -- 行政区划代码
    ,nvl(n.prptycomplloc, o.prptycomplloc) as prptycomplloc -- 物业完整地址
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
from (select * from ${iol_schema}.icms_building_grade_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_building_grade_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.bldgencd <> n.bldgencd
        or o.rowcount <> n.rowcount
        or o.message <> n.message
        or o.data <> n.data
        or o.remark <> n.remark
        or o.attribute1 <> n.attribute1
        or o.attribute2 <> n.attribute2
        or o.attribute3 <> n.attribute3
        or o.regioncd <> n.regioncd
        or o.prptycomplloc <> n.prptycomplloc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_building_grade_info_cl(
            serialno -- 流水号
            ,bldgencd -- 楼盘编码
            ,rowcount -- 条数
            ,message -- 说明
            ,data -- 数据域
            ,remark -- 备注
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,regioncd -- 行政区划代码
            ,prptycomplloc -- 物业完整地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_building_grade_info_op(
            serialno -- 流水号
            ,bldgencd -- 楼盘编码
            ,rowcount -- 条数
            ,message -- 说明
            ,data -- 数据域
            ,remark -- 备注
            ,attribute1 -- 属性1
            ,attribute2 -- 属性2
            ,attribute3 -- 属性3
            ,regioncd -- 行政区划代码
            ,prptycomplloc -- 物业完整地址
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.bldgencd -- 楼盘编码
    ,o.rowcount -- 条数
    ,o.message -- 说明
    ,o.data -- 数据域
    ,o.remark -- 备注
    ,o.attribute1 -- 属性1
    ,o.attribute2 -- 属性2
    ,o.attribute3 -- 属性3
    ,o.regioncd -- 行政区划代码
    ,o.prptycomplloc -- 物业完整地址
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
from ${iol_schema}.icms_building_grade_info_bk o
    left join ${iol_schema}.icms_building_grade_info_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_building_grade_info_cl d
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
--truncate table ${iol_schema}.icms_building_grade_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_building_grade_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_building_grade_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_building_grade_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_building_grade_info exchange partition p_${batch_date} with table ${iol_schema}.icms_building_grade_info_cl;
alter table ${iol_schema}.icms_building_grade_info exchange partition p_20991231 with table ${iol_schema}.icms_building_grade_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_building_grade_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_building_grade_info_op purge;
drop table ${iol_schema}.icms_building_grade_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_building_grade_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_building_grade_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
