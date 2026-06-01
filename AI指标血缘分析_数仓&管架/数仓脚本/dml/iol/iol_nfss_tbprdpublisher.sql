/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbprdpublisher
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
create table ${iol_schema}.nfss_tbprdpublisher_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbprdpublisher
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbprdpublisher_op purge;
drop table ${iol_schema}.nfss_tbprdpublisher_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbprdpublisher_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbprdpublisher where 0=1;

create table ${iol_schema}.nfss_tbprdpublisher_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbprdpublisher where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbprdpublisher_cl(
            publisher_type -- 发行人类型
            ,publisher_code -- 发行人代码
            ,publisher_name -- 发行人名称
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbprdpublisher_op(
            publisher_type -- 发行人类型
            ,publisher_code -- 发行人代码
            ,publisher_name -- 发行人名称
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.publisher_type, o.publisher_type) as publisher_type -- 发行人类型
    ,nvl(n.publisher_code, o.publisher_code) as publisher_code -- 发行人代码
    ,nvl(n.publisher_name, o.publisher_name) as publisher_name -- 发行人名称
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 备注1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 备注2
    ,case when
            n.publisher_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.publisher_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.publisher_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbprdpublisher_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbprdpublisher where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.publisher_code = n.publisher_code
where (
        o.publisher_code is null
    )
    or (
        n.publisher_code is null
    )
    or (
        o.publisher_type <> n.publisher_type
        or o.publisher_name <> n.publisher_name
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbprdpublisher_cl(
            publisher_type -- 发行人类型
            ,publisher_code -- 发行人代码
            ,publisher_name -- 发行人名称
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbprdpublisher_op(
            publisher_type -- 发行人类型
            ,publisher_code -- 发行人代码
            ,publisher_name -- 发行人名称
            ,reserve1 -- 备注1
            ,reserve2 -- 备注2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.publisher_type -- 发行人类型
    ,o.publisher_code -- 发行人代码
    ,o.publisher_name -- 发行人名称
    ,o.reserve1 -- 备注1
    ,o.reserve2 -- 备注2
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
from ${iol_schema}.nfss_tbprdpublisher_bk o
    left join ${iol_schema}.nfss_tbprdpublisher_op n
        on
            o.publisher_code = n.publisher_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbprdpublisher_cl d
        on
            o.publisher_code = d.publisher_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_tbprdpublisher;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_tbprdpublisher') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_tbprdpublisher drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_tbprdpublisher add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_tbprdpublisher exchange partition p_${batch_date} with table ${iol_schema}.nfss_tbprdpublisher_cl;
alter table ${iol_schema}.nfss_tbprdpublisher exchange partition p_20991231 with table ${iol_schema}.nfss_tbprdpublisher_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbprdpublisher to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbprdpublisher_op purge;
drop table ${iol_schema}.nfss_tbprdpublisher_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbprdpublisher_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbprdpublisher',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
