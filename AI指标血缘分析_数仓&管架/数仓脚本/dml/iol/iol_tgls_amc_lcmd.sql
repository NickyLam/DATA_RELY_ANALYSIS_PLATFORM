/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_amc_lcmd
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
create table ${iol_schema}.tgls_amc_lcmd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_amc_lcmd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_lcmd_op purge;
drop table ${iol_schema}.tgls_amc_lcmd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_lcmd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_lcmd where 0=1;

create table ${iol_schema}.tgls_amc_lcmd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_lcmd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_lcmd_cl(
            stacid -- 账套标记
            ,prcscd -- 交易场景代码
            ,busitp -- 业务类型
            ,eventp -- 交易事件类型
            ,amtftg -- 是否计量触发(0-否，1-是)
            ,tfcond -- 触发条件
            ,fisttg -- 是否首次交易(0-否，1-是)
            ,vlidtg -- 是否启用(0-否，1-是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_lcmd_op(
            stacid -- 账套标记
            ,prcscd -- 交易场景代码
            ,busitp -- 业务类型
            ,eventp -- 交易事件类型
            ,amtftg -- 是否计量触发(0-否，1-是)
            ,tfcond -- 触发条件
            ,fisttg -- 是否首次交易(0-否，1-是)
            ,vlidtg -- 是否启用(0-否，1-是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套标记
    ,nvl(n.prcscd, o.prcscd) as prcscd -- 交易场景代码
    ,nvl(n.busitp, o.busitp) as busitp -- 业务类型
    ,nvl(n.eventp, o.eventp) as eventp -- 交易事件类型
    ,nvl(n.amtftg, o.amtftg) as amtftg -- 是否计量触发(0-否，1-是)
    ,nvl(n.tfcond, o.tfcond) as tfcond -- 触发条件
    ,nvl(n.fisttg, o.fisttg) as fisttg -- 是否首次交易(0-否，1-是)
    ,nvl(n.vlidtg, o.vlidtg) as vlidtg -- 是否启用(0-否，1-是)
    ,case when
            n.stacid is null
            and n.prcscd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.prcscd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.prcscd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_amc_lcmd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_amc_lcmd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.prcscd = n.prcscd
where (
        o.stacid is null
        and o.prcscd is null
    )
    or (
        n.stacid is null
        and n.prcscd is null
    )
    or (
        o.busitp <> n.busitp
        or o.eventp <> n.eventp
        or o.amtftg <> n.amtftg
        or o.tfcond <> n.tfcond
        or o.fisttg <> n.fisttg
        or o.vlidtg <> n.vlidtg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_lcmd_cl(
            stacid -- 账套标记
            ,prcscd -- 交易场景代码
            ,busitp -- 业务类型
            ,eventp -- 交易事件类型
            ,amtftg -- 是否计量触发(0-否，1-是)
            ,tfcond -- 触发条件
            ,fisttg -- 是否首次交易(0-否，1-是)
            ,vlidtg -- 是否启用(0-否，1-是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_lcmd_op(
            stacid -- 账套标记
            ,prcscd -- 交易场景代码
            ,busitp -- 业务类型
            ,eventp -- 交易事件类型
            ,amtftg -- 是否计量触发(0-否，1-是)
            ,tfcond -- 触发条件
            ,fisttg -- 是否首次交易(0-否，1-是)
            ,vlidtg -- 是否启用(0-否，1-是)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套标记
    ,o.prcscd -- 交易场景代码
    ,o.busitp -- 业务类型
    ,o.eventp -- 交易事件类型
    ,o.amtftg -- 是否计量触发(0-否，1-是)
    ,o.tfcond -- 触发条件
    ,o.fisttg -- 是否首次交易(0-否，1-是)
    ,o.vlidtg -- 是否启用(0-否，1-是)
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
from ${iol_schema}.tgls_amc_lcmd_bk o
    left join ${iol_schema}.tgls_amc_lcmd_op n
        on
            o.stacid = n.stacid
            and o.prcscd = n.prcscd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_amc_lcmd_cl d
        on
            o.stacid = d.stacid
            and o.prcscd = d.prcscd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_amc_lcmd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_amc_lcmd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_amc_lcmd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_amc_lcmd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_amc_lcmd exchange partition p_${batch_date} with table ${iol_schema}.tgls_amc_lcmd_cl;
alter table ${iol_schema}.tgls_amc_lcmd exchange partition p_20991231 with table ${iol_schema}.tgls_amc_lcmd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_amc_lcmd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_lcmd_op purge;
drop table ${iol_schema}.tgls_amc_lcmd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_amc_lcmd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_amc_lcmd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
