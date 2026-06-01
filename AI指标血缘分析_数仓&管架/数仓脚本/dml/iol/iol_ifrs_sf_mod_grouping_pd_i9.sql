/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifrs_sf_mod_grouping_pd_i9
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
create table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifrs_sf_mod_grouping_pd_i9
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_op purge;
drop table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 where 0=1;

create table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_cl(
            pd_internal_review -- 内评pd模型
            ,pd_internal_review_code -- 内评pd模型代码
            ,i9_mod_grouping -- i9模型分组
            ,status -- 0，启用 ，1，禁用 旧版
            ,pd_internal_review_id -- 唯一ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_op(
            pd_internal_review -- 内评pd模型
            ,pd_internal_review_code -- 内评pd模型代码
            ,i9_mod_grouping -- i9模型分组
            ,status -- 0，启用 ，1，禁用 旧版
            ,pd_internal_review_id -- 唯一ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pd_internal_review, o.pd_internal_review) as pd_internal_review -- 内评pd模型
    ,nvl(n.pd_internal_review_code, o.pd_internal_review_code) as pd_internal_review_code -- 内评pd模型代码
    ,nvl(n.i9_mod_grouping, o.i9_mod_grouping) as i9_mod_grouping -- i9模型分组
    ,nvl(n.status, o.status) as status -- 0，启用 ，1，禁用 旧版
    ,nvl(n.pd_internal_review_id, o.pd_internal_review_id) as pd_internal_review_id -- 唯一ID
    ,case when
            n.pd_internal_review_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pd_internal_review_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pd_internal_review_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifrs_sf_mod_grouping_pd_i9 where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pd_internal_review_id = n.pd_internal_review_id
where (
        o.pd_internal_review_id is null
    )
    or (
        n.pd_internal_review_id is null
    )
    or (
        o.pd_internal_review <> n.pd_internal_review
        or o.pd_internal_review_code <> n.pd_internal_review_code
        or o.i9_mod_grouping <> n.i9_mod_grouping
        or o.status <> n.status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_cl(
            pd_internal_review -- 内评pd模型
            ,pd_internal_review_code -- 内评pd模型代码
            ,i9_mod_grouping -- i9模型分组
            ,status -- 0，启用 ，1，禁用 旧版
            ,pd_internal_review_id -- 唯一ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_op(
            pd_internal_review -- 内评pd模型
            ,pd_internal_review_code -- 内评pd模型代码
            ,i9_mod_grouping -- i9模型分组
            ,status -- 0，启用 ，1，禁用 旧版
            ,pd_internal_review_id -- 唯一ID
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pd_internal_review -- 内评pd模型
    ,o.pd_internal_review_code -- 内评pd模型代码
    ,o.i9_mod_grouping -- i9模型分组
    ,o.status -- 0，启用 ，1，禁用 旧版
    ,o.pd_internal_review_id -- 唯一ID
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
from ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_bk o
    left join ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_op n
        on
            o.pd_internal_review_id = n.pd_internal_review_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_cl d
        on
            o.pd_internal_review_id = d.pd_internal_review_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ifrs_sf_mod_grouping_pd_i9') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 exchange partition p_${batch_date} with table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_cl;
alter table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 exchange partition p_20991231 with table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifrs_sf_mod_grouping_pd_i9 to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_op purge;
drop table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifrs_sf_mod_grouping_pd_i9_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifrs_sf_mod_grouping_pd_i9',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
