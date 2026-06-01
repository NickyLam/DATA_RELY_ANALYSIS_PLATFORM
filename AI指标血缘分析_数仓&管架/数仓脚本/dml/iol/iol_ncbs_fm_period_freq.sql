/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_period_freq
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
create table ${iol_schema}.ncbs_fm_period_freq_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_period_freq
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_period_freq_op purge;
drop table ${iol_schema}.ncbs_fm_period_freq_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_period_freq_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_period_freq where 0=1;

create table ${iol_schema}.ncbs_fm_period_freq_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_period_freq where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_period_freq_cl(
            period_freq -- 频率id
            ,add_no -- 每期数量
            ,company -- 法人
            ,first_last -- 期初/期末
            ,force_work_day -- 节假日是否顺延
            ,half_month -- 半月标识
            ,period_freq_desc -- 周期频率描述
            ,tran_timestamp -- 交易时间戳
            ,client_spread -- 客户浮动
            ,day_mth -- 每期单位
            ,day_num -- 每期天数
            ,prior_days -- 期限单位值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_period_freq_op(
            period_freq -- 频率id
            ,add_no -- 每期数量
            ,company -- 法人
            ,first_last -- 期初/期末
            ,force_work_day -- 节假日是否顺延
            ,half_month -- 半月标识
            ,period_freq_desc -- 周期频率描述
            ,tran_timestamp -- 交易时间戳
            ,client_spread -- 客户浮动
            ,day_mth -- 每期单位
            ,day_num -- 每期天数
            ,prior_days -- 期限单位值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.period_freq, o.period_freq) as period_freq -- 频率id
    ,nvl(n.add_no, o.add_no) as add_no -- 每期数量
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.first_last, o.first_last) as first_last -- 期初/期末
    ,nvl(n.force_work_day, o.force_work_day) as force_work_day -- 节假日是否顺延
    ,nvl(n.half_month, o.half_month) as half_month -- 半月标识
    ,nvl(n.period_freq_desc, o.period_freq_desc) as period_freq_desc -- 周期频率描述
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.client_spread, o.client_spread) as client_spread -- 客户浮动
    ,nvl(n.day_mth, o.day_mth) as day_mth -- 每期单位
    ,nvl(n.day_num, o.day_num) as day_num -- 每期天数
    ,nvl(n.prior_days, o.prior_days) as prior_days -- 期限单位值
    ,case when
            n.period_freq is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.period_freq is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.period_freq is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_period_freq_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_period_freq where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.period_freq = n.period_freq
where (
        o.period_freq is null
    )
    or (
        n.period_freq is null
    )
    or (
        o.add_no <> n.add_no
        or o.company <> n.company
        or o.first_last <> n.first_last
        or o.force_work_day <> n.force_work_day
        or o.half_month <> n.half_month
        or o.period_freq_desc <> n.period_freq_desc
        or o.tran_timestamp <> n.tran_timestamp
        or o.client_spread <> n.client_spread
        or o.day_mth <> n.day_mth
        or o.day_num <> n.day_num
        or o.prior_days <> n.prior_days
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_period_freq_cl(
            period_freq -- 频率id
            ,add_no -- 每期数量
            ,company -- 法人
            ,first_last -- 期初/期末
            ,force_work_day -- 节假日是否顺延
            ,half_month -- 半月标识
            ,period_freq_desc -- 周期频率描述
            ,tran_timestamp -- 交易时间戳
            ,client_spread -- 客户浮动
            ,day_mth -- 每期单位
            ,day_num -- 每期天数
            ,prior_days -- 期限单位值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_period_freq_op(
            period_freq -- 频率id
            ,add_no -- 每期数量
            ,company -- 法人
            ,first_last -- 期初/期末
            ,force_work_day -- 节假日是否顺延
            ,half_month -- 半月标识
            ,period_freq_desc -- 周期频率描述
            ,tran_timestamp -- 交易时间戳
            ,client_spread -- 客户浮动
            ,day_mth -- 每期单位
            ,day_num -- 每期天数
            ,prior_days -- 期限单位值
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.period_freq -- 频率id
    ,o.add_no -- 每期数量
    ,o.company -- 法人
    ,o.first_last -- 期初/期末
    ,o.force_work_day -- 节假日是否顺延
    ,o.half_month -- 半月标识
    ,o.period_freq_desc -- 周期频率描述
    ,o.tran_timestamp -- 交易时间戳
    ,o.client_spread -- 客户浮动
    ,o.day_mth -- 每期单位
    ,o.day_num -- 每期天数
    ,o.prior_days -- 期限单位值
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
from ${iol_schema}.ncbs_fm_period_freq_bk o
    left join ${iol_schema}.ncbs_fm_period_freq_op n
        on
            o.period_freq = n.period_freq
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_period_freq_cl d
        on
            o.period_freq = d.period_freq
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_period_freq;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_period_freq') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_period_freq drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_period_freq add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_period_freq exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_period_freq_cl;
alter table ${iol_schema}.ncbs_fm_period_freq exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_period_freq_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_period_freq to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_period_freq_op purge;
drop table ${iol_schema}.ncbs_fm_period_freq_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_period_freq_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_period_freq',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
