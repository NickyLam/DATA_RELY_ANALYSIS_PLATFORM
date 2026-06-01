/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_tm_cust_limit_o
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
create table ${iol_schema}.icms_tm_cust_limit_o_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_tm_cust_limit_o
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_tm_cust_limit_o_op purge;
drop table ${iol_schema}.icms_tm_cust_limit_o_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_tm_cust_limit_o_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_tm_cust_limit_o where 0=1;

create table ${iol_schema}.icms_tm_cust_limit_o_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_tm_cust_limit_o where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_tm_cust_limit_o_cl(
            org -- 机构号
            ,custlimitid -- 客户额度id
            ,limitcategory -- 额度种类
            ,limittype -- 额度类型
            ,creditlimit -- 信用额度
            ,jpaversion -- 乐观锁版本号
            ,lastmodifieddatetime -- 修改时间
            ,createddatetime -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_tm_cust_limit_o_op(
            org -- 机构号
            ,custlimitid -- 客户额度id
            ,limitcategory -- 额度种类
            ,limittype -- 额度类型
            ,creditlimit -- 信用额度
            ,jpaversion -- 乐观锁版本号
            ,lastmodifieddatetime -- 修改时间
            ,createddatetime -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.org, o.org) as org -- 机构号
    ,nvl(n.custlimitid, o.custlimitid) as custlimitid -- 客户额度id
    ,nvl(n.limitcategory, o.limitcategory) as limitcategory -- 额度种类
    ,nvl(n.limittype, o.limittype) as limittype -- 额度类型
    ,nvl(n.creditlimit, o.creditlimit) as creditlimit -- 信用额度
    ,nvl(n.jpaversion, o.jpaversion) as jpaversion -- 乐观锁版本号
    ,nvl(n.lastmodifieddatetime, o.lastmodifieddatetime) as lastmodifieddatetime -- 修改时间
    ,nvl(n.createddatetime, o.createddatetime) as createddatetime -- 创建时间
    ,case when
            n.custlimitid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.custlimitid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.custlimitid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_tm_cust_limit_o_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_tm_cust_limit_o where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.custlimitid = n.custlimitid
where (
        o.custlimitid is null
    )
    or (
        n.custlimitid is null
    )
    or (
        o.org <> n.org
        or o.limitcategory <> n.limitcategory
        or o.limittype <> n.limittype
        or o.creditlimit <> n.creditlimit
        or o.jpaversion <> n.jpaversion
        or o.lastmodifieddatetime <> n.lastmodifieddatetime
        or o.createddatetime <> n.createddatetime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_tm_cust_limit_o_cl(
            org -- 机构号
            ,custlimitid -- 客户额度id
            ,limitcategory -- 额度种类
            ,limittype -- 额度类型
            ,creditlimit -- 信用额度
            ,jpaversion -- 乐观锁版本号
            ,lastmodifieddatetime -- 修改时间
            ,createddatetime -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_tm_cust_limit_o_op(
            org -- 机构号
            ,custlimitid -- 客户额度id
            ,limitcategory -- 额度种类
            ,limittype -- 额度类型
            ,creditlimit -- 信用额度
            ,jpaversion -- 乐观锁版本号
            ,lastmodifieddatetime -- 修改时间
            ,createddatetime -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org -- 机构号
    ,o.custlimitid -- 客户额度id
    ,o.limitcategory -- 额度种类
    ,o.limittype -- 额度类型
    ,o.creditlimit -- 信用额度
    ,o.jpaversion -- 乐观锁版本号
    ,o.lastmodifieddatetime -- 修改时间
    ,o.createddatetime -- 创建时间
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
from ${iol_schema}.icms_tm_cust_limit_o_bk o
    left join ${iol_schema}.icms_tm_cust_limit_o_op n
        on
            o.custlimitid = n.custlimitid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_tm_cust_limit_o_cl d
        on
            o.custlimitid = d.custlimitid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_tm_cust_limit_o;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_tm_cust_limit_o') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_tm_cust_limit_o drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_tm_cust_limit_o add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_tm_cust_limit_o exchange partition p_${batch_date} with table ${iol_schema}.icms_tm_cust_limit_o_cl;
alter table ${iol_schema}.icms_tm_cust_limit_o exchange partition p_20991231 with table ${iol_schema}.icms_tm_cust_limit_o_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_tm_cust_limit_o to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_tm_cust_limit_o_op purge;
drop table ${iol_schema}.icms_tm_cust_limit_o_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_tm_cust_limit_o_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_tm_cust_limit_o',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
