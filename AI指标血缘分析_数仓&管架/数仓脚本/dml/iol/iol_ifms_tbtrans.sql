/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbtrans
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
create table ${iol_schema}.ifms_tbtrans_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbtrans
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbtrans_op purge;
drop table ${iol_schema}.ifms_tbtrans_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbtrans_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbtrans where 0=1;

create table ${iol_schema}.ifms_tbtrans_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbtrans where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbtrans_cl(
            trans_code -- 
            ,trans_name -- 
            ,enable_flag -- 
            ,channels -- 
            ,host_online -- 
            ,trans_type -- 
            ,monitor_status -- 
            ,log_level -- 
            ,cancel_flag -- 
            ,erase_flag -- 
            ,mon_trans_type -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,prd_type -- 产品类型:[K_CPLX]0-基金 1-理财
            ,trans_types_flag -- 是否多交易类型:交易类型既是系统又分ta级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbtrans_op(
            trans_code -- 
            ,trans_name -- 
            ,enable_flag -- 
            ,channels -- 
            ,host_online -- 
            ,trans_type -- 
            ,monitor_status -- 
            ,log_level -- 
            ,cancel_flag -- 
            ,erase_flag -- 
            ,mon_trans_type -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,prd_type -- 产品类型:[K_CPLX]0-基金 1-理财
            ,trans_types_flag -- 是否多交易类型:交易类型既是系统又分ta级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trans_code, o.trans_code) as trans_code -- 
    ,nvl(n.trans_name, o.trans_name) as trans_name -- 
    ,nvl(n.enable_flag, o.enable_flag) as enable_flag -- 
    ,nvl(n.channels, o.channels) as channels -- 
    ,nvl(n.host_online, o.host_online) as host_online -- 
    ,nvl(n.trans_type, o.trans_type) as trans_type -- 
    ,nvl(n.monitor_status, o.monitor_status) as monitor_status -- 
    ,nvl(n.log_level, o.log_level) as log_level -- 
    ,nvl(n.cancel_flag, o.cancel_flag) as cancel_flag -- 
    ,nvl(n.erase_flag, o.erase_flag) as erase_flag -- 
    ,nvl(n.mon_trans_type, o.mon_trans_type) as mon_trans_type -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.prd_type, o.prd_type) as prd_type -- 产品类型:[K_CPLX]0-基金 1-理财
    ,nvl(n.trans_types_flag, o.trans_types_flag) as trans_types_flag -- 是否多交易类型:交易类型既是系统又分ta级
    ,case when
            n.trans_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trans_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trans_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbtrans_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbtrans where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trans_code = n.trans_code
where (
        o.trans_code is null
    )
    or (
        n.trans_code is null
    )
    or (
        o.trans_name <> n.trans_name
        or o.enable_flag <> n.enable_flag
        or o.channels <> n.channels
        or o.host_online <> n.host_online
        or o.trans_type <> n.trans_type
        or o.monitor_status <> n.monitor_status
        or o.log_level <> n.log_level
        or o.cancel_flag <> n.cancel_flag
        or o.erase_flag <> n.erase_flag
        or o.mon_trans_type <> n.mon_trans_type
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.prd_type <> n.prd_type
        or o.trans_types_flag <> n.trans_types_flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbtrans_cl(
            trans_code -- 
            ,trans_name -- 
            ,enable_flag -- 
            ,channels -- 
            ,host_online -- 
            ,trans_type -- 
            ,monitor_status -- 
            ,log_level -- 
            ,cancel_flag -- 
            ,erase_flag -- 
            ,mon_trans_type -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,prd_type -- 产品类型:[K_CPLX]0-基金 1-理财
            ,trans_types_flag -- 是否多交易类型:交易类型既是系统又分ta级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbtrans_op(
            trans_code -- 
            ,trans_name -- 
            ,enable_flag -- 
            ,channels -- 
            ,host_online -- 
            ,trans_type -- 
            ,monitor_status -- 
            ,log_level -- 
            ,cancel_flag -- 
            ,erase_flag -- 
            ,mon_trans_type -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,prd_type -- 产品类型:[K_CPLX]0-基金 1-理财
            ,trans_types_flag -- 是否多交易类型:交易类型既是系统又分ta级
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trans_code -- 
    ,o.trans_name -- 
    ,o.enable_flag -- 
    ,o.channels -- 
    ,o.host_online -- 
    ,o.trans_type -- 
    ,o.monitor_status -- 
    ,o.log_level -- 
    ,o.cancel_flag -- 
    ,o.erase_flag -- 
    ,o.mon_trans_type -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.prd_type -- 产品类型:[K_CPLX]0-基金 1-理财
    ,o.trans_types_flag -- 是否多交易类型:交易类型既是系统又分ta级
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
from ${iol_schema}.ifms_tbtrans_bk o
    left join ${iol_schema}.ifms_tbtrans_op n
        on
            o.trans_code = n.trans_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbtrans_cl d
        on
            o.trans_code = d.trans_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifms_tbtrans;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifms_tbtrans') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifms_tbtrans drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifms_tbtrans add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifms_tbtrans exchange partition p_${batch_date} with table ${iol_schema}.ifms_tbtrans_cl;
alter table ${iol_schema}.ifms_tbtrans exchange partition p_20991231 with table ${iol_schema}.ifms_tbtrans_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbtrans to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbtrans_op purge;
drop table ${iol_schema}.ifms_tbtrans_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbtrans_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbtrans',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
