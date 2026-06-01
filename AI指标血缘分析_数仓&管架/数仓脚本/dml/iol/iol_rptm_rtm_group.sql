/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_group
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
create table ${iol_schema}.rptm_rtm_group_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rptm_rtm_group
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_group_op purge;
drop table ${iol_schema}.rptm_rtm_group_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_group_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_group where 0=1;

create table ${iol_schema}.rptm_rtm_group_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_group where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_group_cl(
            id -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,group_id -- 
            ,group_name -- 
            ,etl_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_group_op(
            id -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,group_id -- 
            ,group_name -- 
            ,etl_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.rp_name, o.rp_name) as rp_name -- 
    ,nvl(n.ybj_rp_card_type, o.ybj_rp_card_type) as ybj_rp_card_type -- 
    ,nvl(n.rp_card_no, o.rp_card_no) as rp_card_no -- 
    ,nvl(n.group_id, o.group_id) as group_id -- 
    ,nvl(n.group_name, o.group_name) as group_name -- 
    ,nvl(n.etl_dt, o.etl_dt) as etl_dt -- 
    ,case when

        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when

        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when

        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rptm_rtm_group_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rptm_rtm_group where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on

where (

    )
    or (

    )
    or (
        o.id <> n.id
        or o.rp_name <> n.rp_name
        or o.ybj_rp_card_type <> n.ybj_rp_card_type
        or o.rp_card_no <> n.rp_card_no
        or o.group_id <> n.group_id
        or o.group_name <> n.group_name
        or o.etl_dt <> n.etl_dt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_group_cl(
            id -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,group_id -- 
            ,group_name -- 
            ,etl_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_group_op(
            id -- 
            ,rp_name -- 
            ,ybj_rp_card_type -- 
            ,rp_card_no -- 
            ,group_id -- 
            ,group_name -- 
            ,etl_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.rp_name -- 
    ,o.ybj_rp_card_type -- 
    ,o.rp_card_no -- 
    ,o.group_id -- 
    ,o.group_name -- 
    ,o.etl_dt -- 
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
from ${iol_schema}.rptm_rtm_group_bk o
    left join ${iol_schema}.rptm_rtm_group_op n
        on

            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rptm_rtm_group_cl d
        on

where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rptm_rtm_group;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rptm_rtm_group') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rptm_rtm_group drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rptm_rtm_group add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rptm_rtm_group exchange partition p_${batch_date} with table ${iol_schema}.rptm_rtm_group_cl;
alter table ${iol_schema}.rptm_rtm_group exchange partition p_20991231 with table ${iol_schema}.rptm_rtm_group_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rptm_rtm_group to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_group_op purge;
drop table ${iol_schema}.rptm_rtm_group_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rptm_rtm_group_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rptm_rtm_group',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
