/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rptm_rtm_rp_detail
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
create table ${iol_schema}.rptm_rtm_rp_detail_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rptm_rtm_rp_detail
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_rp_detail_op purge;
drop table ${iol_schema}.rptm_rtm_rp_detail_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rptm_rtm_rp_detail_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_detail where 0=1;

create table ${iol_schema}.rptm_rtm_rp_detail_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rptm_rtm_rp_detail where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_rp_detail_cl(
            bus_id -- 
            ,ybj_rp_type -- 
            ,rp_name -- 
            ,ybj_card_type -- 
            ,card_no -- 
            ,rea_no -- 
            ,inst_org -- 
            ,economic_nature -- 
            ,registered -- 
            ,effect_state -- 
            ,active_time -- 
            ,invalid_time -- 
            ,etl_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_rp_detail_op(
            bus_id -- 
            ,ybj_rp_type -- 
            ,rp_name -- 
            ,ybj_card_type -- 
            ,card_no -- 
            ,rea_no -- 
            ,inst_org -- 
            ,economic_nature -- 
            ,registered -- 
            ,effect_state -- 
            ,active_time -- 
            ,invalid_time -- 
            ,etl_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bus_id, o.bus_id) as bus_id -- 
    ,nvl(n.ybj_rp_type, o.ybj_rp_type) as ybj_rp_type -- 
    ,nvl(n.rp_name, o.rp_name) as rp_name -- 
    ,nvl(n.ybj_card_type, o.ybj_card_type) as ybj_card_type -- 
    ,nvl(n.card_no, o.card_no) as card_no -- 
    ,nvl(n.rea_no, o.rea_no) as rea_no -- 
    ,nvl(n.inst_org, o.inst_org) as inst_org -- 
    ,nvl(n.economic_nature, o.economic_nature) as economic_nature -- 
    ,nvl(n.registered, o.registered) as registered -- 
    ,nvl(n.effect_state, o.effect_state) as effect_state -- 
    ,nvl(n.active_time, o.active_time) as active_time -- 
    ,nvl(n.invalid_time, o.invalid_time) as invalid_time -- 
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
from (select * from ${iol_schema}.rptm_rtm_rp_detail_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rptm_rtm_rp_detail where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on

where (

    )
    or (

    )
    or (
        o.bus_id <> n.bus_id
        or o.ybj_rp_type <> n.ybj_rp_type
        or o.rp_name <> n.rp_name
        or o.ybj_card_type <> n.ybj_card_type
        or o.card_no <> n.card_no
        or o.rea_no <> n.rea_no
        or o.inst_org <> n.inst_org
        or o.economic_nature <> n.economic_nature
        or o.registered <> n.registered
        or o.effect_state <> n.effect_state
        or o.active_time <> n.active_time
        or o.invalid_time <> n.invalid_time
        or o.etl_dt <> n.etl_dt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rptm_rtm_rp_detail_cl(
            bus_id -- 
            ,ybj_rp_type -- 
            ,rp_name -- 
            ,ybj_card_type -- 
            ,card_no -- 
            ,rea_no -- 
            ,inst_org -- 
            ,economic_nature -- 
            ,registered -- 
            ,effect_state -- 
            ,active_time -- 
            ,invalid_time -- 
            ,etl_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rptm_rtm_rp_detail_op(
            bus_id -- 
            ,ybj_rp_type -- 
            ,rp_name -- 
            ,ybj_card_type -- 
            ,card_no -- 
            ,rea_no -- 
            ,inst_org -- 
            ,economic_nature -- 
            ,registered -- 
            ,effect_state -- 
            ,active_time -- 
            ,invalid_time -- 
            ,etl_dt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bus_id -- 
    ,o.ybj_rp_type -- 
    ,o.rp_name -- 
    ,o.ybj_card_type -- 
    ,o.card_no -- 
    ,o.rea_no -- 
    ,o.inst_org -- 
    ,o.economic_nature -- 
    ,o.registered -- 
    ,o.effect_state -- 
    ,o.active_time -- 
    ,o.invalid_time -- 
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
from ${iol_schema}.rptm_rtm_rp_detail_bk o
    left join ${iol_schema}.rptm_rtm_rp_detail_op n
        on

            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rptm_rtm_rp_detail_cl d
        on

where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.rptm_rtm_rp_detail;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('rptm_rtm_rp_detail') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.rptm_rtm_rp_detail drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.rptm_rtm_rp_detail add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.rptm_rtm_rp_detail exchange partition p_${batch_date} with table ${iol_schema}.rptm_rtm_rp_detail_cl;
alter table ${iol_schema}.rptm_rtm_rp_detail exchange partition p_20991231 with table ${iol_schema}.rptm_rtm_rp_detail_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rptm_rtm_rp_detail to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rptm_rtm_rp_detail_op purge;
drop table ${iol_schema}.rptm_rtm_rp_detail_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rptm_rtm_rp_detail_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rptm_rtm_rp_detail',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
