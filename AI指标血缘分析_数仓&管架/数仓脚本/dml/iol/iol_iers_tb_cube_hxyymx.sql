/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_tb_cube_hxyymx
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
create table ${iol_schema}.iers_tb_cube_hxyymx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_tb_cube_hxyymx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_tb_cube_hxyymx_op purge;
drop table ${iol_schema}.iers_tb_cube_hxyymx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_tb_cube_hxyymx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_tb_cube_hxyymx where 0=1;

create table ${iol_schema}.iers_tb_cube_hxyymx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.iers_tb_cube_hxyymx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_tb_cube_hxyymx_cl(
            pk_obj -- 发布对象PK
            ,uniqkey -- 单元格标识
            ,pk_mvtype -- 多视图类型主键
            ,code_mvtype -- 多视图类型
            ,pk_version -- 预算版本
            ,code_version -- 预算版本编码
            ,pk_curr -- 货币主键
            ,code_curr -- 货币编码
            ,pk_entity -- 实体主键
            ,code_entity -- 实体编码
            ,pk_measure -- 测量主键
            ,code_measure -- 测量编码
            ,pk_year -- 会计年度主键
            ,code_year -- 会计年
            ,pk_quarter -- 季度主键
            ,code_quarter -- 季度编码
            ,pk_month -- 会计月份主键
            ,code_month -- 会计月份
            ,value -- 值
            ,txtvalue -- 发送值
            ,status2 -- 状态2
            ,status3 -- 状态3
            ,ts -- 时间戳
            ,dr -- 删除标志
            ,pk_dept -- 部门
            ,code_dept -- 部门编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_tb_cube_hxyymx_op(
            pk_obj -- 发布对象PK
            ,uniqkey -- 单元格标识
            ,pk_mvtype -- 多视图类型主键
            ,code_mvtype -- 多视图类型
            ,pk_version -- 预算版本
            ,code_version -- 预算版本编码
            ,pk_curr -- 货币主键
            ,code_curr -- 货币编码
            ,pk_entity -- 实体主键
            ,code_entity -- 实体编码
            ,pk_measure -- 测量主键
            ,code_measure -- 测量编码
            ,pk_year -- 会计年度主键
            ,code_year -- 会计年
            ,pk_quarter -- 季度主键
            ,code_quarter -- 季度编码
            ,pk_month -- 会计月份主键
            ,code_month -- 会计月份
            ,value -- 值
            ,txtvalue -- 发送值
            ,status2 -- 状态2
            ,status3 -- 状态3
            ,ts -- 时间戳
            ,dr -- 删除标志
            ,pk_dept -- 部门
            ,code_dept -- 部门编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_obj, o.pk_obj) as pk_obj -- 发布对象PK
    ,nvl(n.uniqkey, o.uniqkey) as uniqkey -- 单元格标识
    ,nvl(n.pk_mvtype, o.pk_mvtype) as pk_mvtype -- 多视图类型主键
    ,nvl(n.code_mvtype, o.code_mvtype) as code_mvtype -- 多视图类型
    ,nvl(n.pk_version, o.pk_version) as pk_version -- 预算版本
    ,nvl(n.code_version, o.code_version) as code_version -- 预算版本编码
    ,nvl(n.pk_curr, o.pk_curr) as pk_curr -- 货币主键
    ,nvl(n.code_curr, o.code_curr) as code_curr -- 货币编码
    ,nvl(n.pk_entity, o.pk_entity) as pk_entity -- 实体主键
    ,nvl(n.code_entity, o.code_entity) as code_entity -- 实体编码
    ,nvl(n.pk_measure, o.pk_measure) as pk_measure -- 测量主键
    ,nvl(n.code_measure, o.code_measure) as code_measure -- 测量编码
    ,nvl(n.pk_year, o.pk_year) as pk_year -- 会计年度主键
    ,nvl(n.code_year, o.code_year) as code_year -- 会计年
    ,nvl(n.pk_quarter, o.pk_quarter) as pk_quarter -- 季度主键
    ,nvl(n.code_quarter, o.code_quarter) as code_quarter -- 季度编码
    ,nvl(n.pk_month, o.pk_month) as pk_month -- 会计月份主键
    ,nvl(n.code_month, o.code_month) as code_month -- 会计月份
    ,nvl(n.value, o.value) as value -- 值
    ,nvl(n.txtvalue, o.txtvalue) as txtvalue -- 发送值
    ,nvl(n.status2, o.status2) as status2 -- 状态2
    ,nvl(n.status3, o.status3) as status3 -- 状态3
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.pk_dept, o.pk_dept) as pk_dept -- 部门
    ,nvl(n.code_dept, o.code_dept) as code_dept -- 部门编码
    ,case when
            n.pk_obj is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_obj is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_obj is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_tb_cube_hxyymx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_tb_cube_hxyymx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_obj = n.pk_obj
where (
        o.pk_obj is null
    )
    or (
        n.pk_obj is null
    )
    or (
        o.uniqkey <> n.uniqkey
        or o.pk_mvtype <> n.pk_mvtype
        or o.code_mvtype <> n.code_mvtype
        or o.pk_version <> n.pk_version
        or o.code_version <> n.code_version
        or o.pk_curr <> n.pk_curr
        or o.code_curr <> n.code_curr
        or o.pk_entity <> n.pk_entity
        or o.code_entity <> n.code_entity
        or o.pk_measure <> n.pk_measure
        or o.code_measure <> n.code_measure
        or o.pk_year <> n.pk_year
        or o.code_year <> n.code_year
        or o.pk_quarter <> n.pk_quarter
        or o.code_quarter <> n.code_quarter
        or o.pk_month <> n.pk_month
        or o.code_month <> n.code_month
        or o.value <> n.value
        or o.txtvalue <> n.txtvalue
        or o.status2 <> n.status2
        or o.status3 <> n.status3
        or o.ts <> n.ts
        or o.dr <> n.dr
        or o.pk_dept <> n.pk_dept
        or o.code_dept <> n.code_dept
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_tb_cube_hxyymx_cl(
            pk_obj -- 发布对象PK
            ,uniqkey -- 单元格标识
            ,pk_mvtype -- 多视图类型主键
            ,code_mvtype -- 多视图类型
            ,pk_version -- 预算版本
            ,code_version -- 预算版本编码
            ,pk_curr -- 货币主键
            ,code_curr -- 货币编码
            ,pk_entity -- 实体主键
            ,code_entity -- 实体编码
            ,pk_measure -- 测量主键
            ,code_measure -- 测量编码
            ,pk_year -- 会计年度主键
            ,code_year -- 会计年
            ,pk_quarter -- 季度主键
            ,code_quarter -- 季度编码
            ,pk_month -- 会计月份主键
            ,code_month -- 会计月份
            ,value -- 值
            ,txtvalue -- 发送值
            ,status2 -- 状态2
            ,status3 -- 状态3
            ,ts -- 时间戳
            ,dr -- 删除标志
            ,pk_dept -- 部门
            ,code_dept -- 部门编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_tb_cube_hxyymx_op(
            pk_obj -- 发布对象PK
            ,uniqkey -- 单元格标识
            ,pk_mvtype -- 多视图类型主键
            ,code_mvtype -- 多视图类型
            ,pk_version -- 预算版本
            ,code_version -- 预算版本编码
            ,pk_curr -- 货币主键
            ,code_curr -- 货币编码
            ,pk_entity -- 实体主键
            ,code_entity -- 实体编码
            ,pk_measure -- 测量主键
            ,code_measure -- 测量编码
            ,pk_year -- 会计年度主键
            ,code_year -- 会计年
            ,pk_quarter -- 季度主键
            ,code_quarter -- 季度编码
            ,pk_month -- 会计月份主键
            ,code_month -- 会计月份
            ,value -- 值
            ,txtvalue -- 发送值
            ,status2 -- 状态2
            ,status3 -- 状态3
            ,ts -- 时间戳
            ,dr -- 删除标志
            ,pk_dept -- 部门
            ,code_dept -- 部门编码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_obj -- 发布对象PK
    ,o.uniqkey -- 单元格标识
    ,o.pk_mvtype -- 多视图类型主键
    ,o.code_mvtype -- 多视图类型
    ,o.pk_version -- 预算版本
    ,o.code_version -- 预算版本编码
    ,o.pk_curr -- 货币主键
    ,o.code_curr -- 货币编码
    ,o.pk_entity -- 实体主键
    ,o.code_entity -- 实体编码
    ,o.pk_measure -- 测量主键
    ,o.code_measure -- 测量编码
    ,o.pk_year -- 会计年度主键
    ,o.code_year -- 会计年
    ,o.pk_quarter -- 季度主键
    ,o.code_quarter -- 季度编码
    ,o.pk_month -- 会计月份主键
    ,o.code_month -- 会计月份
    ,o.value -- 值
    ,o.txtvalue -- 发送值
    ,o.status2 -- 状态2
    ,o.status3 -- 状态3
    ,o.ts -- 时间戳
    ,o.dr -- 删除标志
    ,o.pk_dept -- 部门
    ,o.code_dept -- 部门编码
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
from ${iol_schema}.iers_tb_cube_hxyymx_bk o
    left join ${iol_schema}.iers_tb_cube_hxyymx_op n
        on
            o.pk_obj = n.pk_obj
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_tb_cube_hxyymx_cl d
        on
            o.pk_obj = d.pk_obj
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_tb_cube_hxyymx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_tb_cube_hxyymx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_tb_cube_hxyymx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_tb_cube_hxyymx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_tb_cube_hxyymx exchange partition p_${batch_date} with table ${iol_schema}.iers_tb_cube_hxyymx_cl;
alter table ${iol_schema}.iers_tb_cube_hxyymx exchange partition p_20991231 with table ${iol_schema}.iers_tb_cube_hxyymx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_tb_cube_hxyymx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_tb_cube_hxyymx_op purge;
drop table ${iol_schema}.iers_tb_cube_hxyymx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_tb_cube_hxyymx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_tb_cube_hxyymx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
