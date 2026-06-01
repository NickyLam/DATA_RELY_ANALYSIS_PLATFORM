/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_loc_holiday
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
create table ${iol_schema}.ncbs_fm_loc_holiday_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_loc_holiday
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_loc_holiday_op purge;
drop table ${iol_schema}.ncbs_fm_loc_holiday_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_loc_holiday_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_loc_holiday where 0=1;

create table ${iol_schema}.ncbs_fm_loc_holiday_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_loc_holiday where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_loc_holiday_cl(
            country -- 国家
            ,apply_ind -- 适用范围
            ,company -- 法人
            ,holiday_desc -- 假日描述
            ,holiday_type -- 假日类型
            ,state -- 行政区划(省、州)
            ,working_holiday -- 工作日/假日
            ,holiday_date -- 假日日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_loc_holiday_op(
            country -- 国家
            ,apply_ind -- 适用范围
            ,company -- 法人
            ,holiday_desc -- 假日描述
            ,holiday_type -- 假日类型
            ,state -- 行政区划(省、州)
            ,working_holiday -- 工作日/假日
            ,holiday_date -- 假日日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.country, o.country) as country -- 国家
    ,nvl(n.apply_ind, o.apply_ind) as apply_ind -- 适用范围
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.holiday_desc, o.holiday_desc) as holiday_desc -- 假日描述
    ,nvl(n.holiday_type, o.holiday_type) as holiday_type -- 假日类型
    ,nvl(n.state, o.state) as state -- 行政区划(省、州)
    ,nvl(n.working_holiday, o.working_holiday) as working_holiday -- 工作日/假日
    ,nvl(n.holiday_date, o.holiday_date) as holiday_date -- 假日日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.country is null
            and n.state is null
            and n.holiday_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.country is null
            and n.state is null
            and n.holiday_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.country is null
            and n.state is null
            and n.holiday_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_loc_holiday_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_loc_holiday where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.country = n.country
            and o.state = n.state
            and o.holiday_date = n.holiday_date
where (
        o.country is null
        and o.state is null
        and o.holiday_date is null
    )
    or (
        n.country is null
        and n.state is null
        and n.holiday_date is null
    )
    or (
        o.apply_ind <> n.apply_ind
        or o.company <> n.company
        or o.holiday_desc <> n.holiday_desc
        or o.holiday_type <> n.holiday_type
        or o.working_holiday <> n.working_holiday
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_loc_holiday_cl(
            country -- 国家
            ,apply_ind -- 适用范围
            ,company -- 法人
            ,holiday_desc -- 假日描述
            ,holiday_type -- 假日类型
            ,state -- 行政区划(省、州)
            ,working_holiday -- 工作日/假日
            ,holiday_date -- 假日日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_loc_holiday_op(
            country -- 国家
            ,apply_ind -- 适用范围
            ,company -- 法人
            ,holiday_desc -- 假日描述
            ,holiday_type -- 假日类型
            ,state -- 行政区划(省、州)
            ,working_holiday -- 工作日/假日
            ,holiday_date -- 假日日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.country -- 国家
    ,o.apply_ind -- 适用范围
    ,o.company -- 法人
    ,o.holiday_desc -- 假日描述
    ,o.holiday_type -- 假日类型
    ,o.state -- 行政区划(省、州)
    ,o.working_holiday -- 工作日/假日
    ,o.holiday_date -- 假日日期
    ,o.tran_timestamp -- 交易时间戳
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
from ${iol_schema}.ncbs_fm_loc_holiday_bk o
    left join ${iol_schema}.ncbs_fm_loc_holiday_op n
        on
            o.country = n.country
            and o.state = n.state
            and o.holiday_date = n.holiday_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_loc_holiday_cl d
        on
            o.country = d.country
            and o.state = d.state
            and o.holiday_date = d.holiday_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_loc_holiday;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_loc_holiday') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_loc_holiday drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_loc_holiday add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_loc_holiday exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_loc_holiday_cl;
alter table ${iol_schema}.ncbs_fm_loc_holiday exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_loc_holiday_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_loc_holiday to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_loc_holiday_op purge;
drop table ${iol_schema}.ncbs_fm_loc_holiday_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_loc_holiday_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_loc_holiday',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
