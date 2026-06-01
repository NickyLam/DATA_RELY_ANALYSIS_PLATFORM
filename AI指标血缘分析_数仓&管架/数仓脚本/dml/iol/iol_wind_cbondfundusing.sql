/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_cbondfundusing
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.wind_cbondfundusing_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_cbondfundusing
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_cbondfundusing_op purge;
drop table ${iol_schema}.wind_cbondfundusing_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_cbondfundusing_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_cbondfundusing where 0=1;

create table ${iol_schema}.wind_cbondfundusing_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_cbondfundusing where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_cbondfundusing_op(
        object_id -- 
        ,s_info_windcode -- 
        ,sec_id -- 
        ,start_dt_ora -- 
        ,end_dt_ora -- 
        ,cur_sign -- 
        ,funduse -- 
        ,opdate -- 
        ,opmode -- 
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 
    ,n.s_info_windcode -- 
    ,n.sec_id -- 
    ,n.start_dt_ora -- 
    ,n.end_dt_ora -- 
    ,n.cur_sign -- 
    ,n.funduse -- 
    ,n.opdate -- 
    ,n.opmode -- 
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_cbondfundusing_bk o
    right join (select * from ${itl_schema}.wind_cbondfundusing where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.object_id = n.object_id
where (
        o.object_id is null
    )
    or (
        o.s_info_windcode <> n.s_info_windcode
        or o.sec_id <> n.sec_id
        or o.start_dt_ora <> n.start_dt_ora
        or o.end_dt_ora <> n.end_dt_ora
        or o.cur_sign <> n.cur_sign
        or o.funduse <> n.funduse
        or o.opdate <> n.opdate
        or o.opmode <> n.opmode
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_cbondfundusing_cl(
            object_id -- 
        ,s_info_windcode -- 
        ,sec_id -- 
        ,start_dt_ora -- 
        ,end_dt_ora -- 
        ,cur_sign -- 
        ,funduse -- 
        ,opdate -- 
        ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_cbondfundusing_op(
            object_id -- 
        ,s_info_windcode -- 
        ,sec_id -- 
        ,start_dt_ora -- 
        ,end_dt_ora -- 
        ,cur_sign -- 
        ,funduse -- 
        ,opdate -- 
        ,opmode -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 
    ,o.s_info_windcode -- 
    ,o.sec_id -- 
    ,o.start_dt_ora -- 
    ,o.end_dt_ora -- 
    ,o.cur_sign -- 
    ,o.funduse -- 
    ,o.opdate -- 
    ,o.opmode -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_cbondfundusing_bk o
    left join ${iol_schema}.wind_cbondfundusing_op n
        on
            o.object_id = n.object_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_cbondfundusing;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('wind_cbondfundusing') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.wind_cbondfundusing drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.wind_cbondfundusing add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.wind_cbondfundusing exchange partition p_${batch_date} with table ${iol_schema}.wind_cbondfundusing_cl;
alter table ${iol_schema}.wind_cbondfundusing exchange partition p_20991231 with table ${iol_schema}.wind_cbondfundusing_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_cbondfundusing to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_cbondfundusing_op purge;
drop table ${iol_schema}.wind_cbondfundusing_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_cbondfundusing_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_cbondfundusing',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
