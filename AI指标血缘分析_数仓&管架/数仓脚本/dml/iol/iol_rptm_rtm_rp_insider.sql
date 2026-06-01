/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_rp_insider
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
create table ${iol_schema}.rptm_rtm_rp_insider_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rptm_rtm_rp_insider
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_rp_insider_op purge;
drop table ${iol_schema}.rptm_rtm_rp_insider_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_insider_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_insider where 0=1;

create table ${iol_schema}.rptm_rtm_rp_insider_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_insider where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_rp_insider_cl(
            id -- 
            ,bus_id -- 
            ,insider_name -- 
            ,card_type -- 
            ,card_no -- 
            ,duty -- 
            ,data_state -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,wf_state -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_rp_insider_op(
            id -- 
            ,bus_id -- 
            ,insider_name -- 
            ,card_type -- 
            ,card_no -- 
            ,duty -- 
            ,data_state -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,wf_state -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.bus_id, o.bus_id) as bus_id -- 
    ,nvl(n.insider_name, o.insider_name) as insider_name -- 
    ,nvl(n.card_type, o.card_type) as card_type -- 
    ,nvl(n.card_no, o.card_no) as card_no -- 
    ,nvl(n.duty, o.duty) as duty -- 
    ,nvl(n.data_state, o.data_state) as data_state -- 
    ,nvl(n.create_user, o.create_user) as create_user -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.create_org, o.create_org) as create_org -- 
    ,nvl(n.update_user, o.update_user) as update_user -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.update_org, o.update_org) as update_org -- 
    ,nvl(n.wf_state, o.wf_state) as wf_state -- 
    ,nvl(n.process_instance_id, o.process_instance_id) as process_instance_id -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
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
from (select * from ${iol_schema}.rptm_rtm_rp_insider_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rptm_rtm_rp_insider where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on

where (

    )
    or (

    )
    or (
        o.id <> n.id
        or o.bus_id <> n.bus_id
        or o.insider_name <> n.insider_name
        or o.card_type <> n.card_type
        or o.card_no <> n.card_no
        or o.duty <> n.duty
        or o.data_state <> n.data_state
        or o.create_user <> n.create_user
        or o.create_time <> n.create_time
        or o.create_org <> n.create_org
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.update_org <> n.update_org
        or o.wf_state <> n.wf_state
        or o.process_instance_id <> n.process_instance_id
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
        into ${iol_schema}.rptm_rtm_rp_insider_cl(
            id -- 
            ,bus_id -- 
            ,insider_name -- 
            ,card_type -- 
            ,card_no -- 
            ,duty -- 
            ,data_state -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,wf_state -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_rp_insider_op(
            id -- 
            ,bus_id -- 
            ,insider_name -- 
            ,card_type -- 
            ,card_no -- 
            ,duty -- 
            ,data_state -- 
            ,create_user -- 
            ,create_time -- 
            ,create_org -- 
            ,update_user -- 
            ,update_time -- 
            ,update_org -- 
            ,wf_state -- 
            ,process_instance_id -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.bus_id -- 
    ,o.insider_name -- 
    ,o.card_type -- 
    ,o.card_no -- 
    ,o.duty -- 
    ,o.data_state -- 
    ,o.create_user -- 
    ,o.create_time -- 
    ,o.create_org -- 
    ,o.update_user -- 
    ,o.update_time -- 
    ,o.update_org -- 
    ,o.wf_state -- 
    ,o.process_instance_id -- 
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
from ${iol_schema}.rptm_rtm_rp_insider_bk o
    left join ${iol_schema}.rptm_rtm_rp_insider_op n
        on

            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rptm_rtm_rp_insider_cl d
        on

where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rptm_rtm_rp_insider;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rptm_rtm_rp_insider') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rptm_rtm_rp_insider drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rptm_rtm_rp_insider add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rptm_rtm_rp_insider exchange partition p_${batch_date} with table ${iol_schema}.rptm_rtm_rp_insider_cl;
alter table ${iol_schema}.rptm_rtm_rp_insider exchange partition p_20991231 with table ${iol_schema}.rptm_rtm_rp_insider_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rptm_rtm_rp_insider to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_rp_insider_op purge;
drop table ${iol_schema}.rptm_rtm_rp_insider_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rptm_rtm_rp_insider_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rptm_rtm_rp_insider',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
