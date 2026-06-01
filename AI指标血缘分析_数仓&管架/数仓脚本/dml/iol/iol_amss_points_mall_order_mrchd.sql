/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amss_points_mall_order_mrchd
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
create table ${iol_schema}.amss_points_mall_order_mrchd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amss_points_mall_order_mrchd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_points_mall_order_mrchd_op purge;
drop table ${iol_schema}.amss_points_mall_order_mrchd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amss_points_mall_order_mrchd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_points_mall_order_mrchd where 0=1;

create table ${iol_schema}.amss_points_mall_order_mrchd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amss_points_mall_order_mrchd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_points_mall_order_mrchd_cl(
            id -- 
            ,serial_num -- 
            ,provt_name -- 
            ,mrchd_encd -- 
            ,mrchd_name -- 
            ,mrchd_qtty -- 
            ,mrchd_desc -- 
            ,form_mechd_fee -- 
            ,physics_flag -- 
            ,create_time -- 
            ,update_time -- 
            ,create_emp -- 
            ,update_emp -- 
            ,cnsm_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_points_mall_order_mrchd_op(
            id -- 
            ,serial_num -- 
            ,provt_name -- 
            ,mrchd_encd -- 
            ,mrchd_name -- 
            ,mrchd_qtty -- 
            ,mrchd_desc -- 
            ,form_mechd_fee -- 
            ,physics_flag -- 
            ,create_time -- 
            ,update_time -- 
            ,create_emp -- 
            ,update_emp -- 
            ,cnsm_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.serial_num, o.serial_num) as serial_num -- 
    ,nvl(n.provt_name, o.provt_name) as provt_name -- 
    ,nvl(n.mrchd_encd, o.mrchd_encd) as mrchd_encd -- 
    ,nvl(n.mrchd_name, o.mrchd_name) as mrchd_name -- 
    ,nvl(n.mrchd_qtty, o.mrchd_qtty) as mrchd_qtty -- 
    ,nvl(n.mrchd_desc, o.mrchd_desc) as mrchd_desc -- 
    ,nvl(n.form_mechd_fee, o.form_mechd_fee) as form_mechd_fee -- 
    ,nvl(n.physics_flag, o.physics_flag) as physics_flag -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 
    ,nvl(n.cnsm_type, o.cnsm_type) as cnsm_type -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amss_points_mall_order_mrchd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amss_points_mall_order_mrchd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.serial_num <> n.serial_num
        or o.provt_name <> n.provt_name
        or o.mrchd_encd <> n.mrchd_encd
        or o.mrchd_name <> n.mrchd_name
        or o.mrchd_qtty <> n.mrchd_qtty
        or o.mrchd_desc <> n.mrchd_desc
        or o.form_mechd_fee <> n.form_mechd_fee
        or o.physics_flag <> n.physics_flag
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.create_emp <> n.create_emp
        or o.update_emp <> n.update_emp
        or o.cnsm_type <> n.cnsm_type
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amss_points_mall_order_mrchd_cl(
            id -- 
            ,serial_num -- 
            ,provt_name -- 
            ,mrchd_encd -- 
            ,mrchd_name -- 
            ,mrchd_qtty -- 
            ,mrchd_desc -- 
            ,form_mechd_fee -- 
            ,physics_flag -- 
            ,create_time -- 
            ,update_time -- 
            ,create_emp -- 
            ,update_emp -- 
            ,cnsm_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amss_points_mall_order_mrchd_op(
            id -- 
            ,serial_num -- 
            ,provt_name -- 
            ,mrchd_encd -- 
            ,mrchd_name -- 
            ,mrchd_qtty -- 
            ,mrchd_desc -- 
            ,form_mechd_fee -- 
            ,physics_flag -- 
            ,create_time -- 
            ,update_time -- 
            ,create_emp -- 
            ,update_emp -- 
            ,cnsm_type -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.serial_num -- 
    ,o.provt_name -- 
    ,o.mrchd_encd -- 
    ,o.mrchd_name -- 
    ,o.mrchd_qtty -- 
    ,o.mrchd_desc -- 
    ,o.form_mechd_fee -- 
    ,o.physics_flag -- 
    ,o.create_time -- 
    ,o.update_time -- 
    ,o.create_emp -- 
    ,o.update_emp -- 
    ,o.cnsm_type -- 
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
from ${iol_schema}.amss_points_mall_order_mrchd_bk o
    left join ${iol_schema}.amss_points_mall_order_mrchd_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amss_points_mall_order_mrchd_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amss_points_mall_order_mrchd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amss_points_mall_order_mrchd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amss_points_mall_order_mrchd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amss_points_mall_order_mrchd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amss_points_mall_order_mrchd exchange partition p_${batch_date} with table ${iol_schema}.amss_points_mall_order_mrchd_cl;
alter table ${iol_schema}.amss_points_mall_order_mrchd exchange partition p_20991231 with table ${iol_schema}.amss_points_mall_order_mrchd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amss_points_mall_order_mrchd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amss_points_mall_order_mrchd_op purge;
drop table ${iol_schema}.amss_points_mall_order_mrchd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amss_points_mall_order_mrchd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amss_points_mall_order_mrchd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
