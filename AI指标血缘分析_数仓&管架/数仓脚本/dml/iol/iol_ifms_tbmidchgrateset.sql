/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbmidchgrateset
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
create table ${iol_schema}.ifms_tbmidchgrateset_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbmidchgrateset
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbmidchgrateset_op purge;
drop table ${iol_schema}.ifms_tbmidchgrateset_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbmidchgrateset_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbmidchgrateset where 0=1;

create table ${iol_schema}.ifms_tbmidchgrateset_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbmidchgrateset where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbmidchgrateset_cl(
            prd_code -- 
            ,sale_rate -- 
            ,price_diff_rate -- 
            ,rate_effective_date -- 
            ,trans_date -- 
            ,trans_time -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbmidchgrateset_op(
            prd_code -- 
            ,sale_rate -- 
            ,price_diff_rate -- 
            ,rate_effective_date -- 
            ,trans_date -- 
            ,trans_time -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.sale_rate, o.sale_rate) as sale_rate -- 
    ,nvl(n.price_diff_rate, o.price_diff_rate) as price_diff_rate -- 
    ,nvl(n.rate_effective_date, o.rate_effective_date) as rate_effective_date -- 
    ,nvl(n.trans_date, o.trans_date) as trans_date -- 
    ,nvl(n.trans_time, o.trans_time) as trans_time -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,case when
            n.prd_code is null
            and n.rate_effective_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.prd_code is null
            and n.rate_effective_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.prd_code is null
            and n.rate_effective_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbmidchgrateset_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbmidchgrateset where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.prd_code = n.prd_code
            and o.rate_effective_date = n.rate_effective_date
where (
        o.prd_code is null
        and o.rate_effective_date is null
    )
    or (
        n.prd_code is null
        and n.rate_effective_date is null
    )
    or (
        o.sale_rate <> n.sale_rate
        or o.price_diff_rate <> n.price_diff_rate
        or o.trans_date <> n.trans_date
        or o.trans_time <> n.trans_time
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbmidchgrateset_cl(
            prd_code -- 
            ,sale_rate -- 
            ,price_diff_rate -- 
            ,rate_effective_date -- 
            ,trans_date -- 
            ,trans_time -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbmidchgrateset_op(
            prd_code -- 
            ,sale_rate -- 
            ,price_diff_rate -- 
            ,rate_effective_date -- 
            ,trans_date -- 
            ,trans_time -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.prd_code -- 
    ,o.sale_rate -- 
    ,o.price_diff_rate -- 
    ,o.rate_effective_date -- 
    ,o.trans_date -- 
    ,o.trans_time -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
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
from ${iol_schema}.ifms_tbmidchgrateset_bk o
    left join ${iol_schema}.ifms_tbmidchgrateset_op n
        on
            o.prd_code = n.prd_code
            and o.rate_effective_date = n.rate_effective_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbmidchgrateset_cl d
        on
            o.prd_code = d.prd_code
            and o.rate_effective_date = d.rate_effective_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifms_tbmidchgrateset;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifms_tbmidchgrateset') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifms_tbmidchgrateset drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifms_tbmidchgrateset add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifms_tbmidchgrateset exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbmidchgrateset_cl;
alter table ${iol_schema}.ifms_tbmidchgrateset exchange partition p_20991231 with table ${iol_schema}.ifms_tbmidchgrateset_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbmidchgrateset to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbmidchgrateset_op purge;
drop table ${iol_schema}.ifms_tbmidchgrateset_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbmidchgrateset_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbmidchgrateset',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
