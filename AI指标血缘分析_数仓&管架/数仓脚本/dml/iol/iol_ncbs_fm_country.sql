/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_country
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
create table ${iol_schema}.ncbs_fm_country_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_country
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_country_op purge;
drop table ${iol_schema}.ncbs_fm_country_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_country_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_country where 0=1;

create table ${iol_schema}.ncbs_fm_country_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_country where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_country_cl(
            ccy -- 币种
            ,country -- 国家
            ,company -- 法人
            ,country_desc -- 国家名称
            ,country_tel -- 国家电话区号
            ,iso_code -- iso编码
            ,ncct_flag -- 非合作国家
            ,psc_flag -- 政治敏感国家
            ,region -- 地区（洲代码）
            ,safe_code -- safe编码
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_country_op(
            ccy -- 币种
            ,country -- 国家
            ,company -- 法人
            ,country_desc -- 国家名称
            ,country_tel -- 国家电话区号
            ,iso_code -- iso编码
            ,ncct_flag -- 非合作国家
            ,psc_flag -- 政治敏感国家
            ,region -- 地区（洲代码）
            ,safe_code -- safe编码
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.country, o.country) as country -- 国家
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.country_desc, o.country_desc) as country_desc -- 国家名称
    ,nvl(n.country_tel, o.country_tel) as country_tel -- 国家电话区号
    ,nvl(n.iso_code, o.iso_code) as iso_code -- iso编码
    ,nvl(n.ncct_flag, o.ncct_flag) as ncct_flag -- 非合作国家
    ,nvl(n.psc_flag, o.psc_flag) as psc_flag -- 政治敏感国家
    ,nvl(n.region, o.region) as region -- 地区（洲代码）
    ,nvl(n.safe_code, o.safe_code) as safe_code -- safe编码
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.country is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.country is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.country is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_country_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_country where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.country = n.country
where (
        o.country is null
    )
    or (
        n.country is null
    )
    or (
        o.ccy <> n.ccy
        or o.company <> n.company
        or o.country_desc <> n.country_desc
        or o.country_tel <> n.country_tel
        or o.iso_code <> n.iso_code
        or o.ncct_flag <> n.ncct_flag
        or o.psc_flag <> n.psc_flag
        or o.region <> n.region
        or o.safe_code <> n.safe_code
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_country_cl(
            ccy -- 币种
            ,country -- 国家
            ,company -- 法人
            ,country_desc -- 国家名称
            ,country_tel -- 国家电话区号
            ,iso_code -- iso编码
            ,ncct_flag -- 非合作国家
            ,psc_flag -- 政治敏感国家
            ,region -- 地区（洲代码）
            ,safe_code -- safe编码
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_country_op(
            ccy -- 币种
            ,country -- 国家
            ,company -- 法人
            ,country_desc -- 国家名称
            ,country_tel -- 国家电话区号
            ,iso_code -- iso编码
            ,ncct_flag -- 非合作国家
            ,psc_flag -- 政治敏感国家
            ,region -- 地区（洲代码）
            ,safe_code -- safe编码
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.country -- 国家
    ,o.company -- 法人
    ,o.country_desc -- 国家名称
    ,o.country_tel -- 国家电话区号
    ,o.iso_code -- iso编码
    ,o.ncct_flag -- 非合作国家
    ,o.psc_flag -- 政治敏感国家
    ,o.region -- 地区（洲代码）
    ,o.safe_code -- safe编码
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
from ${iol_schema}.ncbs_fm_country_bk o
    left join ${iol_schema}.ncbs_fm_country_op n
        on
            o.country = n.country
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_country_cl d
        on
            o.country = d.country
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_country;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_country') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_country drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_country add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_country exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_country_cl;
alter table ${iol_schema}.ncbs_fm_country exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_country_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_country to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_country_op purge;
drop table ${iol_schema}.ncbs_fm_country_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_country_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_country',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
