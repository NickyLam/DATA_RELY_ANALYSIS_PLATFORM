/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_instrument_calculate_rate
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
create table ${iol_schema}.ibms_ttrd_instrument_calculate_rate_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_instrument_calculate_rate
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_instrument_calculate_rate_op purge;
drop table ${iol_schema}.ibms_ttrd_instrument_calculate_rate_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_instrument_calculate_rate_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_instrument_calculate_rate where 0=1;

create table ${iol_schema}.ibms_ttrd_instrument_calculate_rate_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_instrument_calculate_rate where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_instrument_calculate_rate_cl(
            id -- 主键
            ,i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,beg_date -- 生效日期
            ,nominal_rate -- 名义利率
            ,added_rate -- 增值税率
            ,slotting_addrate -- 通道附加税率
            ,slotting_rate -- 通道费率
            ,slotting_daycounter -- 通道费计息基准
            ,trustee_rate -- 托管费率
            ,trustee_daycounter -- 托管费计息基准
            ,other_rate -- 其他费率
            ,other_daycounter -- 其他费用计息基准
            ,nominal_daycounter -- 名义利率计息基准
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_instrument_calculate_rate_op(
            id -- 主键
            ,i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,beg_date -- 生效日期
            ,nominal_rate -- 名义利率
            ,added_rate -- 增值税率
            ,slotting_addrate -- 通道附加税率
            ,slotting_rate -- 通道费率
            ,slotting_daycounter -- 通道费计息基准
            ,trustee_rate -- 托管费率
            ,trustee_daycounter -- 托管费计息基准
            ,other_rate -- 其他费率
            ,other_daycounter -- 其他费用计息基准
            ,nominal_daycounter -- 名义利率计息基准
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.i_code, o.i_code) as i_code -- 
    ,nvl(n.a_type, o.a_type) as a_type -- 
    ,nvl(n.m_type, o.m_type) as m_type -- 
    ,nvl(n.beg_date, o.beg_date) as beg_date -- 生效日期
    ,nvl(n.nominal_rate, o.nominal_rate) as nominal_rate -- 名义利率
    ,nvl(n.added_rate, o.added_rate) as added_rate -- 增值税率
    ,nvl(n.slotting_addrate, o.slotting_addrate) as slotting_addrate -- 通道附加税率
    ,nvl(n.slotting_rate, o.slotting_rate) as slotting_rate -- 通道费率
    ,nvl(n.slotting_daycounter, o.slotting_daycounter) as slotting_daycounter -- 通道费计息基准
    ,nvl(n.trustee_rate, o.trustee_rate) as trustee_rate -- 托管费率
    ,nvl(n.trustee_daycounter, o.trustee_daycounter) as trustee_daycounter -- 托管费计息基准
    ,nvl(n.other_rate, o.other_rate) as other_rate -- 其他费率
    ,nvl(n.other_daycounter, o.other_daycounter) as other_daycounter -- 其他费用计息基准
    ,nvl(n.nominal_daycounter, o.nominal_daycounter) as nominal_daycounter -- 名义利率计息基准
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
from (select * from ${iol_schema}.ibms_ttrd_instrument_calculate_rate_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_instrument_calculate_rate where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.beg_date <> n.beg_date
        or o.nominal_rate <> n.nominal_rate
        or o.added_rate <> n.added_rate
        or o.slotting_addrate <> n.slotting_addrate
        or o.slotting_rate <> n.slotting_rate
        or o.slotting_daycounter <> n.slotting_daycounter
        or o.trustee_rate <> n.trustee_rate
        or o.trustee_daycounter <> n.trustee_daycounter
        or o.other_rate <> n.other_rate
        or o.other_daycounter <> n.other_daycounter
        or o.nominal_daycounter <> n.nominal_daycounter
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_instrument_calculate_rate_cl(
            id -- 主键
            ,i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,beg_date -- 生效日期
            ,nominal_rate -- 名义利率
            ,added_rate -- 增值税率
            ,slotting_addrate -- 通道附加税率
            ,slotting_rate -- 通道费率
            ,slotting_daycounter -- 通道费计息基准
            ,trustee_rate -- 托管费率
            ,trustee_daycounter -- 托管费计息基准
            ,other_rate -- 其他费率
            ,other_daycounter -- 其他费用计息基准
            ,nominal_daycounter -- 名义利率计息基准
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_instrument_calculate_rate_op(
            id -- 主键
            ,i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,beg_date -- 生效日期
            ,nominal_rate -- 名义利率
            ,added_rate -- 增值税率
            ,slotting_addrate -- 通道附加税率
            ,slotting_rate -- 通道费率
            ,slotting_daycounter -- 通道费计息基准
            ,trustee_rate -- 托管费率
            ,trustee_daycounter -- 托管费计息基准
            ,other_rate -- 其他费率
            ,other_daycounter -- 其他费用计息基准
            ,nominal_daycounter -- 名义利率计息基准
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.i_code -- 
    ,o.a_type -- 
    ,o.m_type -- 
    ,o.beg_date -- 生效日期
    ,o.nominal_rate -- 名义利率
    ,o.added_rate -- 增值税率
    ,o.slotting_addrate -- 通道附加税率
    ,o.slotting_rate -- 通道费率
    ,o.slotting_daycounter -- 通道费计息基准
    ,o.trustee_rate -- 托管费率
    ,o.trustee_daycounter -- 托管费计息基准
    ,o.other_rate -- 其他费率
    ,o.other_daycounter -- 其他费用计息基准
    ,o.nominal_daycounter -- 名义利率计息基准
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
from ${iol_schema}.ibms_ttrd_instrument_calculate_rate_bk o
    left join ${iol_schema}.ibms_ttrd_instrument_calculate_rate_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_instrument_calculate_rate_cl d
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
--truncate table ${iol_schema}.ibms_ttrd_instrument_calculate_rate;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ibms_ttrd_instrument_calculate_rate') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ibms_ttrd_instrument_calculate_rate drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ibms_ttrd_instrument_calculate_rate add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ibms_ttrd_instrument_calculate_rate exchange partition p_${batch_date} with table ${iol_schema}.ibms_ttrd_instrument_calculate_rate_cl;
alter table ${iol_schema}.ibms_ttrd_instrument_calculate_rate exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_instrument_calculate_rate_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_instrument_calculate_rate to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_instrument_calculate_rate_op purge;
drop table ${iol_schema}.ibms_ttrd_instrument_calculate_rate_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_instrument_calculate_rate_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_instrument_calculate_rate',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
