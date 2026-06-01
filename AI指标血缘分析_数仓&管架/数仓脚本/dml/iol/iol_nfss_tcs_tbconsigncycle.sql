/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tcs_tbconsigncycle
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
create table ${iol_schema}.nfss_tcs_tbconsigncycle_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tcs_tbconsigncycle;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tcs_tbconsigncycle_op purge;
drop table ${iol_schema}.nfss_tcs_tbconsigncycle_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tcs_tbconsigncycle_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tcs_tbconsigncycle where 0=1;

create table ${iol_schema}.nfss_tcs_tbconsigncycle_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tcs_tbconsigncycle where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tcs_tbconsigncycle_cl(
            ta_code -- ta代码
            ,prd_code -- 产品代码
            ,allow_type -- 允许类型
            ,cycle_type -- 周期类型
            ,start_date -- 起始日期
            ,end_date -- 截止日期
            ,serial_no -- 方案编号
            ,int1 -- 备用整数1
            ,int2 -- 备用整数2
            ,int3 -- 备用整数2
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tcs_tbconsigncycle_op(
            ta_code -- ta代码
            ,prd_code -- 产品代码
            ,allow_type -- 允许类型
            ,cycle_type -- 周期类型
            ,start_date -- 起始日期
            ,end_date -- 截止日期
            ,serial_no -- 方案编号
            ,int1 -- 备用整数1
            ,int2 -- 备用整数2
            ,int3 -- 备用整数2
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ta_code, o.ta_code) as ta_code -- ta代码
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 产品代码
    ,nvl(n.allow_type, o.allow_type) as allow_type -- 允许类型
    ,nvl(n.cycle_type, o.cycle_type) as cycle_type -- 周期类型
    ,nvl(n.start_date, o.start_date) as start_date -- 起始日期
    ,nvl(n.end_date, o.end_date) as end_date -- 截止日期
    ,nvl(n.serial_no, o.serial_no) as serial_no -- 方案编号
    ,nvl(n.int1, o.int1) as int1 -- 备用整数1
    ,nvl(n.int2, o.int2) as int2 -- 备用整数2
    ,nvl(n.int3, o.int3) as int3 -- 备用整数2
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 保留字段1
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 保留字段2
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 保留字段3
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.allow_type is null
            and n.cycle_type is null
            and n.start_date is null
            and n.end_date is null
            and n.serial_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.allow_type is null
            and n.cycle_type is null
            and n.start_date is null
            and n.end_date is null
            and n.serial_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ta_code is null
            and n.prd_code is null
            and n.allow_type is null
            and n.cycle_type is null
            and n.start_date is null
            and n.end_date is null
            and n.serial_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tcs_tbconsigncycle_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tcs_tbconsigncycle where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.allow_type = n.allow_type
            and o.cycle_type = n.cycle_type
            and o.start_date = n.start_date
            and o.end_date = n.end_date
            and o.serial_no = n.serial_no
where (
        o.ta_code is null
        and o.prd_code is null
        and o.allow_type is null
        and o.cycle_type is null
        and o.start_date is null
        and o.end_date is null
        and o.serial_no is null
    )
    or (
        n.ta_code is null
        and n.prd_code is null
        and n.allow_type is null
        and n.cycle_type is null
        and n.start_date is null
        and n.end_date is null
        and n.serial_no is null
    )
    or (
        o.int1 <> n.int1
        or o.int2 <> n.int2
        or o.int3 <> n.int3
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
        into ${iol_schema}.nfss_tcs_tbconsigncycle_cl(
            ta_code -- ta代码
            ,prd_code -- 产品代码
            ,allow_type -- 允许类型
            ,cycle_type -- 周期类型
            ,start_date -- 起始日期
            ,end_date -- 截止日期
            ,serial_no -- 方案编号
            ,int1 -- 备用整数1
            ,int2 -- 备用整数2
            ,int3 -- 备用整数2
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tcs_tbconsigncycle_op(
            ta_code -- ta代码
            ,prd_code -- 产品代码
            ,allow_type -- 允许类型
            ,cycle_type -- 周期类型
            ,start_date -- 起始日期
            ,end_date -- 截止日期
            ,serial_no -- 方案编号
            ,int1 -- 备用整数1
            ,int2 -- 备用整数2
            ,int3 -- 备用整数2
            ,reserve1 -- 保留字段1
            ,reserve2 -- 保留字段2
            ,reserve3 -- 保留字段3
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ta_code -- ta代码
    ,o.prd_code -- 产品代码
    ,o.allow_type -- 允许类型
    ,o.cycle_type -- 周期类型
    ,o.start_date -- 起始日期
    ,o.end_date -- 截止日期
    ,o.serial_no -- 方案编号
    ,o.int1 -- 备用整数1
    ,o.int2 -- 备用整数2
    ,o.int3 -- 备用整数2
    ,o.reserve1 -- 保留字段1
    ,o.reserve2 -- 保留字段2
    ,o.reserve3 -- 保留字段3
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tcs_tbconsigncycle_bk o
    left join ${iol_schema}.nfss_tcs_tbconsigncycle_op n
        on
            o.ta_code = n.ta_code
            and o.prd_code = n.prd_code
            and o.allow_type = n.allow_type
            and o.cycle_type = n.cycle_type
            and o.start_date = n.start_date
            and o.end_date = n.end_date
            and o.serial_no = n.serial_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tcs_tbconsigncycle_cl d
        on
            o.ta_code = d.ta_code
            and o.prd_code = d.prd_code
            and o.allow_type = d.allow_type
            and o.cycle_type = d.cycle_type
            and o.start_date = d.start_date
            and o.end_date = d.end_date
            and o.serial_no = d.serial_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tcs_tbconsigncycle;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tcs_tbconsigncycle exchange partition p_19000101 with table ${iol_schema}.nfss_tcs_tbconsigncycle_cl;
alter table ${iol_schema}.nfss_tcs_tbconsigncycle exchange partition p_20991231 with table ${iol_schema}.nfss_tcs_tbconsigncycle_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tcs_tbconsigncycle to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tcs_tbconsigncycle_op purge;
drop table ${iol_schema}.nfss_tcs_tbconsigncycle_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tcs_tbconsigncycle_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tcs_tbconsigncycle',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
