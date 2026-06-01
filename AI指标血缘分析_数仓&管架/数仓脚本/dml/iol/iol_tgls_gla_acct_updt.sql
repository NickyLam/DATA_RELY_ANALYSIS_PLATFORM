/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tgls_gla_acct_updt
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
create table ${iol_schema}.tgls_gla_acct_updt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tgls_gla_acct_updt
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gla_acct_updt_op purge;
drop table ${iol_schema}.tgls_gla_acct_updt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tgls_gla_acct_updt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gla_acct_updt where 0=1;

create table ${iol_schema}.tgls_gla_acct_updt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tgls_gla_acct_updt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gla_acct_updt_cl(
            trandt -- 维护日期
            ,transq -- 维护流水
            ,acctno -- 维护主题
            ,updcol -- 维护字段
            ,oldval -- 维护前内容
            ,newval -- 维护后内容
            ,tranus -- 维护柜员
            ,tranbr -- 维护机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gla_acct_updt_op(
            trandt -- 维护日期
            ,transq -- 维护流水
            ,acctno -- 维护主题
            ,updcol -- 维护字段
            ,oldval -- 维护前内容
            ,newval -- 维护后内容
            ,tranus -- 维护柜员
            ,tranbr -- 维护机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trandt, o.trandt) as trandt -- 维护日期
    ,nvl(n.transq, o.transq) as transq -- 维护流水
    ,nvl(n.acctno, o.acctno) as acctno -- 维护主题
    ,nvl(n.updcol, o.updcol) as updcol -- 维护字段
    ,nvl(n.oldval, o.oldval) as oldval -- 维护前内容
    ,nvl(n.newval, o.newval) as newval -- 维护后内容
    ,nvl(n.tranus, o.tranus) as tranus -- 维护柜员
    ,nvl(n.tranbr, o.tranbr) as tranbr -- 维护机构编号
    ,case when
            n.trandt is null
            and n.transq is null
            and n.acctno is null
            and n.updcol is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trandt is null
            and n.transq is null
            and n.acctno is null
            and n.updcol is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trandt is null
            and n.transq is null
            and n.acctno is null
            and n.updcol is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.tgls_gla_acct_updt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tgls_gla_acct_updt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trandt = n.trandt
            and o.transq = n.transq
            and o.acctno = n.acctno
            and o.updcol = n.updcol
where (
        o.trandt is null
        and o.transq is null
        and o.acctno is null
        and o.updcol is null
    )
    or (
        n.trandt is null
        and n.transq is null
        and n.acctno is null
        and n.updcol is null
    )
    or (
        o.oldval <> n.oldval
        or o.newval <> n.newval
        or o.tranus <> n.tranus
        or o.tranbr <> n.tranbr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tgls_gla_acct_updt_cl(
            trandt -- 维护日期
            ,transq -- 维护流水
            ,acctno -- 维护主题
            ,updcol -- 维护字段
            ,oldval -- 维护前内容
            ,newval -- 维护后内容
            ,tranus -- 维护柜员
            ,tranbr -- 维护机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tgls_gla_acct_updt_op(
            trandt -- 维护日期
            ,transq -- 维护流水
            ,acctno -- 维护主题
            ,updcol -- 维护字段
            ,oldval -- 维护前内容
            ,newval -- 维护后内容
            ,tranus -- 维护柜员
            ,tranbr -- 维护机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trandt -- 维护日期
    ,o.transq -- 维护流水
    ,o.acctno -- 维护主题
    ,o.updcol -- 维护字段
    ,o.oldval -- 维护前内容
    ,o.newval -- 维护后内容
    ,o.tranus -- 维护柜员
    ,o.tranbr -- 维护机构编号
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
from ${iol_schema}.tgls_gla_acct_updt_bk o
    left join ${iol_schema}.tgls_gla_acct_updt_op n
        on
            o.trandt = n.trandt
            and o.transq = n.transq
            and o.acctno = n.acctno
            and o.updcol = n.updcol
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tgls_gla_acct_updt_cl d
        on
            o.trandt = d.trandt
            and o.transq = d.transq
            and o.acctno = d.acctno
            and o.updcol = d.updcol
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.tgls_gla_acct_updt;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tgls_gla_acct_updt') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tgls_gla_acct_updt drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tgls_gla_acct_updt add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tgls_gla_acct_updt exchange partition p_${batch_date} with table ${iol_schema}.tgls_gla_acct_updt_cl;
alter table ${iol_schema}.tgls_gla_acct_updt exchange partition p_20991231 with table ${iol_schema}.tgls_gla_acct_updt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tgls_gla_acct_updt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tgls_gla_acct_updt_op purge;
drop table ${iol_schema}.tgls_gla_acct_updt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tgls_gla_acct_updt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tgls_gla_acct_updt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
