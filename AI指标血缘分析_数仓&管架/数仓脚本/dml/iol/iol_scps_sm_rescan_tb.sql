/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_scps_sm_rescan_tb
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
create table ${iol_schema}.scps_sm_rescan_tb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.scps_sm_rescan_tb
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_sm_rescan_tb_op purge;
drop table ${iol_schema}.scps_sm_rescan_tb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.scps_sm_rescan_tb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_sm_rescan_tb where 0=1;

create table ${iol_schema}.scps_sm_rescan_tb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.scps_sm_rescan_tb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_sm_rescan_tb_cl(
            task_id -- 任务号
            ,trade_code -- 交易码
            ,task_start_date -- 补件开始时间
            ,task_end_date -- 补件结束时间
            ,tackct_use_time -- 补件耗时
            ,tackct_status -- 补件状态
            ,iau_organ -- 发起补件柜员
            ,iau_teller_no -- 发起机构
            ,sub_teller_no -- 提交补件柜员
            ,sub_organ -- 提交机构
            ,tackct_type -- 补扫类型（1，事中 2，事后）
            ,tackct_count -- 补扫次数
            ,tackct_task_id -- 补扫任务号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_sm_rescan_tb_op(
            task_id -- 任务号
            ,trade_code -- 交易码
            ,task_start_date -- 补件开始时间
            ,task_end_date -- 补件结束时间
            ,tackct_use_time -- 补件耗时
            ,tackct_status -- 补件状态
            ,iau_organ -- 发起补件柜员
            ,iau_teller_no -- 发起机构
            ,sub_teller_no -- 提交补件柜员
            ,sub_organ -- 提交机构
            ,tackct_type -- 补扫类型（1，事中 2，事后）
            ,tackct_count -- 补扫次数
            ,tackct_task_id -- 补扫任务号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.task_id, o.task_id) as task_id -- 任务号
    ,nvl(n.trade_code, o.trade_code) as trade_code -- 交易码
    ,nvl(n.task_start_date, o.task_start_date) as task_start_date -- 补件开始时间
    ,nvl(n.task_end_date, o.task_end_date) as task_end_date -- 补件结束时间
    ,nvl(n.tackct_use_time, o.tackct_use_time) as tackct_use_time -- 补件耗时
    ,nvl(n.tackct_status, o.tackct_status) as tackct_status -- 补件状态
    ,nvl(n.iau_organ, o.iau_organ) as iau_organ -- 发起补件柜员
    ,nvl(n.iau_teller_no, o.iau_teller_no) as iau_teller_no -- 发起机构
    ,nvl(n.sub_teller_no, o.sub_teller_no) as sub_teller_no -- 提交补件柜员
    ,nvl(n.sub_organ, o.sub_organ) as sub_organ -- 提交机构
    ,nvl(n.tackct_type, o.tackct_type) as tackct_type -- 补扫类型（1，事中 2，事后）
    ,nvl(n.tackct_count, o.tackct_count) as tackct_count -- 补扫次数
    ,nvl(n.tackct_task_id, o.tackct_task_id) as tackct_task_id -- 补扫任务号
    ,case when
            n.task_id is null
            and n.task_start_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.task_id is null
            and n.task_start_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.task_id is null
            and n.task_start_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.scps_sm_rescan_tb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.scps_sm_rescan_tb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.task_id = n.task_id
            and o.task_start_date = n.task_start_date
where (
        o.task_id is null
        and o.task_start_date is null
    )
    or (
        n.task_id is null
        and n.task_start_date is null
    )
    or (
        o.trade_code <> n.trade_code
        or o.task_end_date <> n.task_end_date
        or o.tackct_use_time <> n.tackct_use_time
        or o.tackct_status <> n.tackct_status
        or o.iau_organ <> n.iau_organ
        or o.iau_teller_no <> n.iau_teller_no
        or o.sub_teller_no <> n.sub_teller_no
        or o.sub_organ <> n.sub_organ
        or o.tackct_type <> n.tackct_type
        or o.tackct_count <> n.tackct_count
        or o.tackct_task_id <> n.tackct_task_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.scps_sm_rescan_tb_cl(
            task_id -- 任务号
            ,trade_code -- 交易码
            ,task_start_date -- 补件开始时间
            ,task_end_date -- 补件结束时间
            ,tackct_use_time -- 补件耗时
            ,tackct_status -- 补件状态
            ,iau_organ -- 发起补件柜员
            ,iau_teller_no -- 发起机构
            ,sub_teller_no -- 提交补件柜员
            ,sub_organ -- 提交机构
            ,tackct_type -- 补扫类型（1，事中 2，事后）
            ,tackct_count -- 补扫次数
            ,tackct_task_id -- 补扫任务号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.scps_sm_rescan_tb_op(
            task_id -- 任务号
            ,trade_code -- 交易码
            ,task_start_date -- 补件开始时间
            ,task_end_date -- 补件结束时间
            ,tackct_use_time -- 补件耗时
            ,tackct_status -- 补件状态
            ,iau_organ -- 发起补件柜员
            ,iau_teller_no -- 发起机构
            ,sub_teller_no -- 提交补件柜员
            ,sub_organ -- 提交机构
            ,tackct_type -- 补扫类型（1，事中 2，事后）
            ,tackct_count -- 补扫次数
            ,tackct_task_id -- 补扫任务号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.task_id -- 任务号
    ,o.trade_code -- 交易码
    ,o.task_start_date -- 补件开始时间
    ,o.task_end_date -- 补件结束时间
    ,o.tackct_use_time -- 补件耗时
    ,o.tackct_status -- 补件状态
    ,o.iau_organ -- 发起补件柜员
    ,o.iau_teller_no -- 发起机构
    ,o.sub_teller_no -- 提交补件柜员
    ,o.sub_organ -- 提交机构
    ,o.tackct_type -- 补扫类型（1，事中 2，事后）
    ,o.tackct_count -- 补扫次数
    ,o.tackct_task_id -- 补扫任务号
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
from ${iol_schema}.scps_sm_rescan_tb_bk o
    left join ${iol_schema}.scps_sm_rescan_tb_op n
        on
            o.task_id = n.task_id
            and o.task_start_date = n.task_start_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.scps_sm_rescan_tb_cl d
        on
            o.task_id = d.task_id
            and o.task_start_date = d.task_start_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.scps_sm_rescan_tb;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('scps_sm_rescan_tb') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.scps_sm_rescan_tb drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.scps_sm_rescan_tb add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.scps_sm_rescan_tb exchange partition p_${batch_date} with table ${iol_schema}.scps_sm_rescan_tb_cl;
alter table ${iol_schema}.scps_sm_rescan_tb exchange partition p_20991231 with table ${iol_schema}.scps_sm_rescan_tb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.scps_sm_rescan_tb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.scps_sm_rescan_tb_op purge;
drop table ${iol_schema}.scps_sm_rescan_tb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.scps_sm_rescan_tb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'scps_sm_rescan_tb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
