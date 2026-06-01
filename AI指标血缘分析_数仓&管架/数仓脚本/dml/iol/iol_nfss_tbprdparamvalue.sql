/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbprdparamvalue
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
create table ${iol_schema}.nfss_tbprdparamvalue_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbprdparamvalue
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbprdparamvalue_op purge;
drop table ${iol_schema}.nfss_tbprdparamvalue_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbprdparamvalue_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbprdparamvalue where 0=1;

create table ${iol_schema}.nfss_tbprdparamvalue_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbprdparamvalue where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbprdparamvalue_cl(
            table_name -- 
            ,prd_code -- 
            ,field_code -- 
            ,field_value -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbprdparamvalue_op(
            table_name -- 
            ,prd_code -- 
            ,field_code -- 
            ,field_value -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.table_name, o.table_name) as table_name -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.field_code, o.field_code) as field_code -- 
    ,nvl(n.field_value, o.field_value) as field_value -- 
    ,case when
            n.table_name is null
            and n.prd_code is null
            and n.field_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.table_name is null
            and n.prd_code is null
            and n.field_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.table_name is null
            and n.prd_code is null
            and n.field_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbprdparamvalue_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbprdparamvalue where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.table_name = n.table_name
            and o.prd_code = n.prd_code
            and o.field_code = n.field_code
where (
        o.table_name is null
        and o.prd_code is null
        and o.field_code is null
    )
    or (
        n.table_name is null
        and n.prd_code is null
        and n.field_code is null
    )
    or (
        o.field_value <> n.field_value
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbprdparamvalue_cl(
            table_name -- 
            ,prd_code -- 
            ,field_code -- 
            ,field_value -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbprdparamvalue_op(
            table_name -- 
            ,prd_code -- 
            ,field_code -- 
            ,field_value -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.table_name -- 
    ,o.prd_code -- 
    ,o.field_code -- 
    ,o.field_value -- 
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
from ${iol_schema}.nfss_tbprdparamvalue_bk o
    left join ${iol_schema}.nfss_tbprdparamvalue_op n
        on
            o.table_name = n.table_name
            and o.prd_code = n.prd_code
            and o.field_code = n.field_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbprdparamvalue_cl d
        on
            o.table_name = d.table_name
            and o.prd_code = d.prd_code
            and o.field_code = d.field_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_tbprdparamvalue;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_tbprdparamvalue') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_tbprdparamvalue drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_tbprdparamvalue add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_tbprdparamvalue exchange partition p_${batch_date} with table ${iol_schema}.nfss_tbprdparamvalue_cl;
alter table ${iol_schema}.nfss_tbprdparamvalue exchange partition p_20991231 with table ${iol_schema}.nfss_tbprdparamvalue_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbprdparamvalue to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbprdparamvalue_op purge;
drop table ${iol_schema}.nfss_tbprdparamvalue_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbprdparamvalue_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbprdparamvalue',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
