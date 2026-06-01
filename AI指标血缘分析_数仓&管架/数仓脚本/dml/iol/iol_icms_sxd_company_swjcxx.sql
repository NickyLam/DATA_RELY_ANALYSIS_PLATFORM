/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_sxd_company_swjcxx
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
create table ${iol_schema}.icms_sxd_company_swjcxx_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_sxd_company_swjcxx
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_swjcxx_op purge;
drop table ${iol_schema}.icms_sxd_company_swjcxx_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_sxd_company_swjcxx_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_swjcxx where 0=1;

create table ${iol_schema}.icms_sxd_company_swjcxx_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_sxd_company_swjcxx where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_swjcxx_cl(
            id -- 主键
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,serno -- 业务流水号
            ,aydjrq -- 案源登记日期
            ,ajbh -- 稽查案件编号
            ,rwxdrq -- 稽查任务下达日期
            ,aymc -- 案源名称
            ,ajzt -- 案件状态
            ,aydjbm -- 案源登记部门名称
            ,nrzy -- 内容摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_swjcxx_op(
            id -- 主键
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,serno -- 业务流水号
            ,aydjrq -- 案源登记日期
            ,ajbh -- 稽查案件编号
            ,rwxdrq -- 稽查任务下达日期
            ,aymc -- 案源名称
            ,ajzt -- 案件状态
            ,aydjbm -- 案源登记部门名称
            ,nrzy -- 内容摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.serno, o.serno) as serno -- 业务流水号
    ,nvl(n.aydjrq, o.aydjrq) as aydjrq -- 案源登记日期
    ,nvl(n.ajbh, o.ajbh) as ajbh -- 稽查案件编号
    ,nvl(n.rwxdrq, o.rwxdrq) as rwxdrq -- 稽查任务下达日期
    ,nvl(n.aymc, o.aymc) as aymc -- 案源名称
    ,nvl(n.ajzt, o.ajzt) as ajzt -- 案件状态
    ,nvl(n.aydjbm, o.aydjbm) as aydjbm -- 案源登记部门名称
    ,nvl(n.nrzy, o.nrzy) as nrzy -- 内容摘要
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_sxd_company_swjcxx_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_sxd_company_swjcxx where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.migtflag <> n.migtflag
        or o.serno <> n.serno
        or o.aydjrq <> n.aydjrq
        or o.ajbh <> n.ajbh
        or o.rwxdrq <> n.rwxdrq
        or o.aymc <> n.aymc
        or o.ajzt <> n.ajzt
        or o.aydjbm <> n.aydjbm
        or o.nrzy <> n.nrzy
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_sxd_company_swjcxx_cl(
            id -- 主键
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,serno -- 业务流水号
            ,aydjrq -- 案源登记日期
            ,ajbh -- 稽查案件编号
            ,rwxdrq -- 稽查任务下达日期
            ,aymc -- 案源名称
            ,ajzt -- 案件状态
            ,aydjbm -- 案源登记部门名称
            ,nrzy -- 内容摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_sxd_company_swjcxx_op(
            id -- 主键
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,serno -- 业务流水号
            ,aydjrq -- 案源登记日期
            ,ajbh -- 稽查案件编号
            ,rwxdrq -- 稽查任务下达日期
            ,aymc -- 案源名称
            ,ajzt -- 案件状态
            ,aydjbm -- 案源登记部门名称
            ,nrzy -- 内容摘要
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.serno -- 业务流水号
    ,o.aydjrq -- 案源登记日期
    ,o.ajbh -- 稽查案件编号
    ,o.rwxdrq -- 稽查任务下达日期
    ,o.aymc -- 案源名称
    ,o.ajzt -- 案件状态
    ,o.aydjbm -- 案源登记部门名称
    ,o.nrzy -- 内容摘要
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
from ${iol_schema}.icms_sxd_company_swjcxx_bk o
    left join ${iol_schema}.icms_sxd_company_swjcxx_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_sxd_company_swjcxx_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_sxd_company_swjcxx;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_sxd_company_swjcxx') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_sxd_company_swjcxx drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_sxd_company_swjcxx add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_sxd_company_swjcxx exchange partition p_${batch_date} with table ${iol_schema}.icms_sxd_company_swjcxx_cl;
alter table ${iol_schema}.icms_sxd_company_swjcxx exchange partition p_20991231 with table ${iol_schema}.icms_sxd_company_swjcxx_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_sxd_company_swjcxx to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_sxd_company_swjcxx_op purge;
drop table ${iol_schema}.icms_sxd_company_swjcxx_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_sxd_company_swjcxx_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_sxd_company_swjcxx',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
