/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_amc_scel_attr
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
create table ${iol_schema}.tgls_amc_scel_attr_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_amc_scel_attr
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_scel_attr_op purge;
drop table ${iol_schema}.tgls_amc_scel_attr_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_amc_scel_attr_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_scel_attr where 0=1;

create table ${iol_schema}.tgls_amc_scel_attr_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_amc_scel_attr where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_scel_attr_cl(
            stacid -- 账套
            ,elemcd -- 要素编号
            ,elemna -- 要素名称
            ,busitp -- 业务类型
            ,busina -- 业务名称
            ,tablcl -- 参考列名称
            ,paracd -- 代码值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_scel_attr_op(
            stacid -- 账套
            ,elemcd -- 要素编号
            ,elemna -- 要素名称
            ,busitp -- 业务类型
            ,busina -- 业务名称
            ,tablcl -- 参考列名称
            ,paracd -- 代码值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stacid, o.stacid) as stacid -- 账套
    ,nvl(n.elemcd, o.elemcd) as elemcd -- 要素编号
    ,nvl(n.elemna, o.elemna) as elemna -- 要素名称
    ,nvl(n.busitp, o.busitp) as busitp -- 业务类型
    ,nvl(n.busina, o.busina) as busina -- 业务名称
    ,nvl(n.tablcl, o.tablcl) as tablcl -- 参考列名称
    ,nvl(n.paracd, o.paracd) as paracd -- 代码值
    ,case when
            n.stacid is null
            and n.elemcd is null
            and n.busitp is null
            and n.tablcl is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stacid is null
            and n.elemcd is null
            and n.busitp is null
            and n.tablcl is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stacid is null
            and n.elemcd is null
            and n.busitp is null
            and n.tablcl is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_amc_scel_attr_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_amc_scel_attr where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stacid = n.stacid
            and o.elemcd = n.elemcd
            and o.busitp = n.busitp
            and o.tablcl = n.tablcl
where (
        o.stacid is null
        and o.elemcd is null
        and o.busitp is null
        and o.tablcl is null
    )
    or (
        n.stacid is null
        and n.elemcd is null
        and n.busitp is null
        and n.tablcl is null
    )
    or (
        o.elemna <> n.elemna
        or o.busina <> n.busina
        or o.paracd <> n.paracd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_amc_scel_attr_cl(
            stacid -- 账套
            ,elemcd -- 要素编号
            ,elemna -- 要素名称
            ,busitp -- 业务类型
            ,busina -- 业务名称
            ,tablcl -- 参考列名称
            ,paracd -- 代码值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_amc_scel_attr_op(
            stacid -- 账套
            ,elemcd -- 要素编号
            ,elemna -- 要素名称
            ,busitp -- 业务类型
            ,busina -- 业务名称
            ,tablcl -- 参考列名称
            ,paracd -- 代码值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stacid -- 账套
    ,o.elemcd -- 要素编号
    ,o.elemna -- 要素名称
    ,o.busitp -- 业务类型
    ,o.busina -- 业务名称
    ,o.tablcl -- 参考列名称
    ,o.paracd -- 代码值
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
from ${iol_schema}.tgls_amc_scel_attr_bk o
    left join ${iol_schema}.tgls_amc_scel_attr_op n
        on
            o.stacid = n.stacid
            and o.elemcd = n.elemcd
            and o.busitp = n.busitp
            and o.tablcl = n.tablcl
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_amc_scel_attr_cl d
        on
            o.stacid = d.stacid
            and o.elemcd = d.elemcd
            and o.busitp = d.busitp
            and o.tablcl = d.tablcl
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_amc_scel_attr;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_amc_scel_attr') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_amc_scel_attr drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_amc_scel_attr add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_amc_scel_attr exchange partition p_${batch_date} with table ${iol_schema}.tgls_amc_scel_attr_cl;
alter table ${iol_schema}.tgls_amc_scel_attr exchange partition p_20991231 with table ${iol_schema}.tgls_amc_scel_attr_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_amc_scel_attr to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_amc_scel_attr_op purge;
drop table ${iol_schema}.tgls_amc_scel_attr_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_amc_scel_attr_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_amc_scel_attr',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
