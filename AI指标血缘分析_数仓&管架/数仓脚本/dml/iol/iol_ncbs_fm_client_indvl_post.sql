/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_client_indvl_post
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
create table ${iol_schema}.ncbs_fm_client_indvl_post_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_client_indvl_post
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_client_indvl_post_op purge;
drop table ${iol_schema}.ncbs_fm_client_indvl_post_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_client_indvl_post_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_client_indvl_post where 0=1;

create table ${iol_schema}.ncbs_fm_client_indvl_post_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_client_indvl_post where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_client_indvl_post_cl(
            company -- 法人
            ,field_value -- 取值范围
            ,meaning -- 说明
            ,ref_lang -- 参数语言
            ,tran_timestamp -- 交易时间戳
            ,narrative1 -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_client_indvl_post_op(
            company -- 法人
            ,field_value -- 取值范围
            ,meaning -- 说明
            ,ref_lang -- 参数语言
            ,tran_timestamp -- 交易时间戳
            ,narrative1 -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.company, o.company) as company -- 法人
    ,nvl(n.field_value, o.field_value) as field_value -- 取值范围
    ,nvl(n.meaning, o.meaning) as meaning -- 说明
    ,nvl(n.ref_lang, o.ref_lang) as ref_lang -- 参数语言
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.narrative1, o.narrative1) as narrative1 -- 备注
    ,case when
            n.field_value is null
            and n.ref_lang is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.field_value is null
            and n.ref_lang is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.field_value is null
            and n.ref_lang is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_client_indvl_post_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_client_indvl_post where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.field_value = n.field_value
            and o.ref_lang = n.ref_lang
where (
        o.field_value is null
        and o.ref_lang is null
    )
    or (
        n.field_value is null
        and n.ref_lang is null
    )
    or (
        o.company <> n.company
        or o.meaning <> n.meaning
        or o.tran_timestamp <> n.tran_timestamp
        or o.narrative1 <> n.narrative1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_client_indvl_post_cl(
            company -- 法人
            ,field_value -- 取值范围
            ,meaning -- 说明
            ,ref_lang -- 参数语言
            ,tran_timestamp -- 交易时间戳
            ,narrative1 -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_client_indvl_post_op(
            company -- 法人
            ,field_value -- 取值范围
            ,meaning -- 说明
            ,ref_lang -- 参数语言
            ,tran_timestamp -- 交易时间戳
            ,narrative1 -- 备注
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.company -- 法人
    ,o.field_value -- 取值范围
    ,o.meaning -- 说明
    ,o.ref_lang -- 参数语言
    ,o.tran_timestamp -- 交易时间戳
    ,o.narrative1 -- 备注
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
from ${iol_schema}.ncbs_fm_client_indvl_post_bk o
    left join ${iol_schema}.ncbs_fm_client_indvl_post_op n
        on
            o.field_value = n.field_value
            and o.ref_lang = n.ref_lang
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_client_indvl_post_cl d
        on
            o.field_value = d.field_value
            and o.ref_lang = d.ref_lang
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_client_indvl_post;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_client_indvl_post') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_client_indvl_post drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_client_indvl_post add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_client_indvl_post exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_client_indvl_post_cl;
alter table ${iol_schema}.ncbs_fm_client_indvl_post exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_client_indvl_post_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_client_indvl_post to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_client_indvl_post_op purge;
drop table ${iol_schema}.ncbs_fm_client_indvl_post_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_client_indvl_post_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_client_indvl_post',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
