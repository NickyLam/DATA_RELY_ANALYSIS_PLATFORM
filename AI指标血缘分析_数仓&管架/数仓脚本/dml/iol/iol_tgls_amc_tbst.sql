/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_amc_tbst
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
create table ${iol_schema}.tgls_amc_tbst_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_amc_tbst
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_tbst_op purge;
drop table ${iol_schema}.tgls_amc_tbst_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_tbst_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_tbst where 0=1;

create table ${iol_schema}.tgls_amc_tbst_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_tbst where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_tbst_cl(
            stacid -- 账套
            ,tablcd -- 表代码
            ,tablna -- 表名称
            ,busitp -- 业务类型
            ,tabltp -- 表类型
            ,status -- 是否启用
            ,usedtp -- 使用状态
            ,desctx -- 说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_tbst_op(
            stacid -- 账套
            ,tablcd -- 表代码
            ,tablna -- 表名称
            ,busitp -- 业务类型
            ,tabltp -- 表类型
            ,status -- 是否启用
            ,usedtp -- 使用状态
            ,desctx -- 说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.tablcd, o.tablcd) as tablcd -- 表代码
    ,nvl(n.tablna, o.tablna) as tablna -- 表名称
    ,nvl(n.busitp, o.busitp) as busitp -- 业务类型
    ,nvl(n.tabltp, o.tabltp) as tabltp -- 表类型
    ,nvl(n.status, o.status) as status -- 是否启用
    ,nvl(n.usedtp, o.usedtp) as usedtp -- 使用状态
    ,nvl(n.desctx, o.desctx) as desctx -- 说明
    ,case when
            n.stacid is null
            and n.tablcd is null
            and n.busitp is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.tablcd is null
            and n.busitp is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.tablcd is null
            and n.busitp is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_amc_tbst_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_amc_tbst where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.tablcd = n.tablcd
            and o.busitp = n.busitp
where (
        o.stacid is null
        and o.tablcd is null
        and o.busitp is null
    )
    or (
        n.stacid is null
        and n.tablcd is null
        and n.busitp is null
    )
    or (
        o.tablna <> n.tablna
        or o.tabltp <> n.tabltp
        or o.status <> n.status
        or o.usedtp <> n.usedtp
        or o.desctx <> n.desctx
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_tbst_cl(
            stacid -- 账套
            ,tablcd -- 表代码
            ,tablna -- 表名称
            ,busitp -- 业务类型
            ,tabltp -- 表类型
            ,status -- 是否启用
            ,usedtp -- 使用状态
            ,desctx -- 说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_tbst_op(
            stacid -- 账套
            ,tablcd -- 表代码
            ,tablna -- 表名称
            ,busitp -- 业务类型
            ,tabltp -- 表类型
            ,status -- 是否启用
            ,usedtp -- 使用状态
            ,desctx -- 说明
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套
    ,o.tablcd -- 表代码
    ,o.tablna -- 表名称
    ,o.busitp -- 业务类型
    ,o.tabltp -- 表类型
    ,o.status -- 是否启用
    ,o.usedtp -- 使用状态
    ,o.desctx -- 说明
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
from ${iol_schema}.tgls_amc_tbst_bk o
    left join ${iol_schema}.tgls_amc_tbst_op n
        on
            o.stacid = n.stacid
            and o.tablcd = n.tablcd
            and o.busitp = n.busitp
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_amc_tbst_cl d
        on
            o.stacid = d.stacid
            and o.tablcd = d.tablcd
            and o.busitp = d.busitp
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_amc_tbst;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_amc_tbst') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_amc_tbst drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_amc_tbst add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_amc_tbst exchange partition p_${batch_date} with table ${iol_schema}.tgls_amc_tbst_cl;
alter table ${iol_schema}.tgls_amc_tbst exchange partition p_20991231 with table ${iol_schema}.tgls_amc_tbst_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_amc_tbst to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_tbst_op purge;
drop table ${iol_schema}.tgls_amc_tbst_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_amc_tbst_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_amc_tbst',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
