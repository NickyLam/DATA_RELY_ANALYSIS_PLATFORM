/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_amc_cdrl
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
create table ${iol_schema}.tgls_amc_cdrl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_amc_cdrl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_cdrl_op purge;
drop table ${iol_schema}.tgls_amc_cdrl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_cdrl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_cdrl where 0=1;

create table ${iol_schema}.tgls_amc_cdrl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_cdrl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_cdrl_cl(
            stacid -- 账套
            ,systid -- 系统来源
            ,mapptp -- 映射类型
            ,sourvl -- 源值
            ,sourna -- 源值描述
            ,mappvl -- 映射值
            ,mappna -- 映射值描述
            ,valide -- 启用标示,y-是n-否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_cdrl_op(
            stacid -- 账套
            ,systid -- 系统来源
            ,mapptp -- 映射类型
            ,sourvl -- 源值
            ,sourna -- 源值描述
            ,mappvl -- 映射值
            ,mappna -- 映射值描述
            ,valide -- 启用标示,y-是n-否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.systid, o.systid) as systid -- 系统来源
    ,nvl(n.mapptp, o.mapptp) as mapptp -- 映射类型
    ,nvl(n.sourvl, o.sourvl) as sourvl -- 源值
    ,nvl(n.sourna, o.sourna) as sourna -- 源值描述
    ,nvl(n.mappvl, o.mappvl) as mappvl -- 映射值
    ,nvl(n.mappna, o.mappna) as mappna -- 映射值描述
    ,nvl(n.valide, o.valide) as valide -- 启用标示,y-是n-否
    ,case when
            n.stacid is null
            and n.systid is null
            and n.sourvl is null
            and n.mappvl is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.systid is null
            and n.sourvl is null
            and n.mappvl is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.systid is null
            and n.sourvl is null
            and n.mappvl is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_amc_cdrl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_amc_cdrl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.systid = n.systid
            and o.sourvl = n.sourvl
            and o.mappvl = n.mappvl
where (
        o.stacid is null
        and o.systid is null
        and o.sourvl is null
        and o.mappvl is null
    )
    or (
        n.stacid is null
        and n.systid is null
        and n.sourvl is null
        and n.mappvl is null
    )
    or (
        o.mapptp <> n.mapptp
        or o.sourna <> n.sourna
        or o.mappna <> n.mappna
        or o.valide <> n.valide
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_cdrl_cl(
            stacid -- 账套
            ,systid -- 系统来源
            ,mapptp -- 映射类型
            ,sourvl -- 源值
            ,sourna -- 源值描述
            ,mappvl -- 映射值
            ,mappna -- 映射值描述
            ,valide -- 启用标示,y-是n-否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_cdrl_op(
            stacid -- 账套
            ,systid -- 系统来源
            ,mapptp -- 映射类型
            ,sourvl -- 源值
            ,sourna -- 源值描述
            ,mappvl -- 映射值
            ,mappna -- 映射值描述
            ,valide -- 启用标示,y-是n-否
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套
    ,o.systid -- 系统来源
    ,o.mapptp -- 映射类型
    ,o.sourvl -- 源值
    ,o.sourna -- 源值描述
    ,o.mappvl -- 映射值
    ,o.mappna -- 映射值描述
    ,o.valide -- 启用标示,y-是n-否
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
from ${iol_schema}.tgls_amc_cdrl_bk o
    left join ${iol_schema}.tgls_amc_cdrl_op n
        on
            o.stacid = n.stacid
            and o.systid = n.systid
            and o.sourvl = n.sourvl
            and o.mappvl = n.mappvl
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_amc_cdrl_cl d
        on
            o.stacid = d.stacid
            and o.systid = d.systid
            and o.sourvl = d.sourvl
            and o.mappvl = d.mappvl
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_amc_cdrl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_amc_cdrl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_amc_cdrl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_amc_cdrl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_amc_cdrl exchange partition p_${batch_date} with table ${iol_schema}.tgls_amc_cdrl_cl;
alter table ${iol_schema}.tgls_amc_cdrl exchange partition p_20991231 with table ${iol_schema}.tgls_amc_cdrl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_amc_cdrl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_cdrl_op purge;
drop table ${iol_schema}.tgls_amc_cdrl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_amc_cdrl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_amc_cdrl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
