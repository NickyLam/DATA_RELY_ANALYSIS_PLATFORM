/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orms_t21_disclosure_data
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
create table ${iol_schema}.orms_t21_disclosure_data_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orms_t21_disclosure_data
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orms_t21_disclosure_data_op purge;
drop table ${iol_schema}.orms_t21_disclosure_data_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orms_t21_disclosure_data_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orms_t21_disclosure_data where 0=1;

create table ${iol_schema}.orms_t21_disclosure_data_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orms_t21_disclosure_data where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orms_t21_disclosure_data_cl(
            id -- id，主键
            ,seq -- 披露报表类型序号
            ,type -- 纳入内部损失乘数计算的损失事件（中文）
            ,year -- 年度(只用于g4d2)
            ,datat1 -- 最近第一年数据(万元)
            ,datat2 -- 最近第二年数据(万元)
            ,datat3 -- 最近第三年数据(万元)
            ,datat4 -- 最近第四年数据(万元)
            ,datat5 -- 最近第五年数据(万元)
            ,datat6 -- 最近第六年数据(万元)
            ,datat7 -- 最近第七年数据(万元)
            ,datat8 -- 最近第八年数据(万元)
            ,datat9 -- 最近第九年数据(万元)
            ,datat10 -- 最近第十年数据(万元)
            ,average -- 平均值(万元)
            ,sumtotal -- 合计(万元)
            ,versions_id -- 披露报表版本id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orms_t21_disclosure_data_op(
            id -- id，主键
            ,seq -- 披露报表类型序号
            ,type -- 纳入内部损失乘数计算的损失事件（中文）
            ,year -- 年度(只用于g4d2)
            ,datat1 -- 最近第一年数据(万元)
            ,datat2 -- 最近第二年数据(万元)
            ,datat3 -- 最近第三年数据(万元)
            ,datat4 -- 最近第四年数据(万元)
            ,datat5 -- 最近第五年数据(万元)
            ,datat6 -- 最近第六年数据(万元)
            ,datat7 -- 最近第七年数据(万元)
            ,datat8 -- 最近第八年数据(万元)
            ,datat9 -- 最近第九年数据(万元)
            ,datat10 -- 最近第十年数据(万元)
            ,average -- 平均值(万元)
            ,sumtotal -- 合计(万元)
            ,versions_id -- 披露报表版本id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- id，主键
    ,nvl(n.seq, o.seq) as seq -- 披露报表类型序号
    ,nvl(n.type, o.type) as type -- 纳入内部损失乘数计算的损失事件（中文）
    ,nvl(n.year, o.year) as year -- 年度(只用于g4d2)
    ,nvl(n.datat1, o.datat1) as datat1 -- 最近第一年数据(万元)
    ,nvl(n.datat2, o.datat2) as datat2 -- 最近第二年数据(万元)
    ,nvl(n.datat3, o.datat3) as datat3 -- 最近第三年数据(万元)
    ,nvl(n.datat4, o.datat4) as datat4 -- 最近第四年数据(万元)
    ,nvl(n.datat5, o.datat5) as datat5 -- 最近第五年数据(万元)
    ,nvl(n.datat6, o.datat6) as datat6 -- 最近第六年数据(万元)
    ,nvl(n.datat7, o.datat7) as datat7 -- 最近第七年数据(万元)
    ,nvl(n.datat8, o.datat8) as datat8 -- 最近第八年数据(万元)
    ,nvl(n.datat9, o.datat9) as datat9 -- 最近第九年数据(万元)
    ,nvl(n.datat10, o.datat10) as datat10 -- 最近第十年数据(万元)
    ,nvl(n.average, o.average) as average -- 平均值(万元)
    ,nvl(n.sumtotal, o.sumtotal) as sumtotal -- 合计(万元)
    ,nvl(n.versions_id, o.versions_id) as versions_id -- 披露报表版本id
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
from (select * from ${iol_schema}.orms_t21_disclosure_data_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orms_t21_disclosure_data where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.seq <> n.seq
        or o.type <> n.type
        or o.year <> n.year
        or o.datat1 <> n.datat1
        or o.datat2 <> n.datat2
        or o.datat3 <> n.datat3
        or o.datat4 <> n.datat4
        or o.datat5 <> n.datat5
        or o.datat6 <> n.datat6
        or o.datat7 <> n.datat7
        or o.datat8 <> n.datat8
        or o.datat9 <> n.datat9
        or o.datat10 <> n.datat10
        or o.average <> n.average
        or o.sumtotal <> n.sumtotal
        or o.versions_id <> n.versions_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orms_t21_disclosure_data_cl(
            id -- id，主键
            ,seq -- 披露报表类型序号
            ,type -- 纳入内部损失乘数计算的损失事件（中文）
            ,year -- 年度(只用于g4d2)
            ,datat1 -- 最近第一年数据(万元)
            ,datat2 -- 最近第二年数据(万元)
            ,datat3 -- 最近第三年数据(万元)
            ,datat4 -- 最近第四年数据(万元)
            ,datat5 -- 最近第五年数据(万元)
            ,datat6 -- 最近第六年数据(万元)
            ,datat7 -- 最近第七年数据(万元)
            ,datat8 -- 最近第八年数据(万元)
            ,datat9 -- 最近第九年数据(万元)
            ,datat10 -- 最近第十年数据(万元)
            ,average -- 平均值(万元)
            ,sumtotal -- 合计(万元)
            ,versions_id -- 披露报表版本id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orms_t21_disclosure_data_op(
            id -- id，主键
            ,seq -- 披露报表类型序号
            ,type -- 纳入内部损失乘数计算的损失事件（中文）
            ,year -- 年度(只用于g4d2)
            ,datat1 -- 最近第一年数据(万元)
            ,datat2 -- 最近第二年数据(万元)
            ,datat3 -- 最近第三年数据(万元)
            ,datat4 -- 最近第四年数据(万元)
            ,datat5 -- 最近第五年数据(万元)
            ,datat6 -- 最近第六年数据(万元)
            ,datat7 -- 最近第七年数据(万元)
            ,datat8 -- 最近第八年数据(万元)
            ,datat9 -- 最近第九年数据(万元)
            ,datat10 -- 最近第十年数据(万元)
            ,average -- 平均值(万元)
            ,sumtotal -- 合计(万元)
            ,versions_id -- 披露报表版本id
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- id，主键
    ,o.seq -- 披露报表类型序号
    ,o.type -- 纳入内部损失乘数计算的损失事件（中文）
    ,o.year -- 年度(只用于g4d2)
    ,o.datat1 -- 最近第一年数据(万元)
    ,o.datat2 -- 最近第二年数据(万元)
    ,o.datat3 -- 最近第三年数据(万元)
    ,o.datat4 -- 最近第四年数据(万元)
    ,o.datat5 -- 最近第五年数据(万元)
    ,o.datat6 -- 最近第六年数据(万元)
    ,o.datat7 -- 最近第七年数据(万元)
    ,o.datat8 -- 最近第八年数据(万元)
    ,o.datat9 -- 最近第九年数据(万元)
    ,o.datat10 -- 最近第十年数据(万元)
    ,o.average -- 平均值(万元)
    ,o.sumtotal -- 合计(万元)
    ,o.versions_id -- 披露报表版本id
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
from ${iol_schema}.orms_t21_disclosure_data_bk o
    left join ${iol_schema}.orms_t21_disclosure_data_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orms_t21_disclosure_data_cl d
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
--truncate table ${iol_schema}.orms_t21_disclosure_data;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('orms_t21_disclosure_data') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.orms_t21_disclosure_data drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.orms_t21_disclosure_data add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.orms_t21_disclosure_data exchange partition p_${batch_date} with table ${iol_schema}.orms_t21_disclosure_data_cl;
alter table ${iol_schema}.orms_t21_disclosure_data exchange partition p_20991231 with table ${iol_schema}.orms_t21_disclosure_data_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orms_t21_disclosure_data to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orms_t21_disclosure_data_op purge;
drop table ${iol_schema}.orms_t21_disclosure_data_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orms_t21_disclosure_data_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orms_t21_disclosure_data',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
