/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_fake_coin_def
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
create table ${iol_schema}.ncbs_fm_fake_coin_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_fake_coin_def
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_fake_coin_def_op purge;
drop table ${iol_schema}.ncbs_fm_fake_coin_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_fake_coin_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_fake_coin_def where 0=1;

create table ${iol_schema}.ncbs_fm_fake_coin_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_fake_coin_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_fake_coin_def_cl(
            ccy -- 币种
            ,bond_name -- 券别名称
            ,bond_number -- 套数
            ,bond_type_id -- 国债券别代码
            ,bond_version_num -- 版别
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,bond_notes -- 面额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_fake_coin_def_op(
            ccy -- 币种
            ,bond_name -- 券别名称
            ,bond_number -- 套数
            ,bond_type_id -- 国债券别代码
            ,bond_version_num -- 版别
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,bond_notes -- 面额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.bond_name, o.bond_name) as bond_name -- 券别名称
    ,nvl(n.bond_number, o.bond_number) as bond_number -- 套数
    ,nvl(n.bond_type_id, o.bond_type_id) as bond_type_id -- 国债券别代码
    ,nvl(n.bond_version_num, o.bond_version_num) as bond_version_num -- 版别
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.bond_notes, o.bond_notes) as bond_notes -- 面额
    ,case when
            n.ccy is null
            and n.bond_number is null
            and n.bond_type_id is null
            and n.bond_version_num is null
            and n.bond_notes is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ccy is null
            and n.bond_number is null
            and n.bond_type_id is null
            and n.bond_version_num is null
            and n.bond_notes is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ccy is null
            and n.bond_number is null
            and n.bond_type_id is null
            and n.bond_version_num is null
            and n.bond_notes is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_fake_coin_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_fake_coin_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ccy = n.ccy
            and o.bond_number = n.bond_number
            and o.bond_type_id = n.bond_type_id
            and o.bond_version_num = n.bond_version_num
            and o.bond_notes = n.bond_notes
where (
        o.ccy is null
        and o.bond_number is null
        and o.bond_type_id is null
        and o.bond_version_num is null
        and o.bond_notes is null
    )
    or (
        n.ccy is null
        and n.bond_number is null
        and n.bond_type_id is null
        and n.bond_version_num is null
        and n.bond_notes is null
    )
    or (
        o.bond_name <> n.bond_name
        or o.company <> n.company
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_fake_coin_def_cl(
            ccy -- 币种
            ,bond_name -- 券别名称
            ,bond_number -- 套数
            ,bond_type_id -- 国债券别代码
            ,bond_version_num -- 版别
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,bond_notes -- 面额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_fake_coin_def_op(
            ccy -- 币种
            ,bond_name -- 券别名称
            ,bond_number -- 套数
            ,bond_type_id -- 国债券别代码
            ,bond_version_num -- 版别
            ,company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,bond_notes -- 面额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ccy -- 币种
    ,o.bond_name -- 券别名称
    ,o.bond_number -- 套数
    ,o.bond_type_id -- 国债券别代码
    ,o.bond_version_num -- 版别
    ,o.company -- 法人
    ,o.tran_timestamp -- 交易时间戳
    ,o.bond_notes -- 面额
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
from ${iol_schema}.ncbs_fm_fake_coin_def_bk o
    left join ${iol_schema}.ncbs_fm_fake_coin_def_op n
        on
            o.ccy = n.ccy
            and o.bond_number = n.bond_number
            and o.bond_type_id = n.bond_type_id
            and o.bond_version_num = n.bond_version_num
            and o.bond_notes = n.bond_notes
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_fake_coin_def_cl d
        on
            o.ccy = d.ccy
            and o.bond_number = d.bond_number
            and o.bond_type_id = d.bond_type_id
            and o.bond_version_num = d.bond_version_num
            and o.bond_notes = d.bond_notes
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_fake_coin_def;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_fake_coin_def') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_fake_coin_def drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_fake_coin_def add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_fake_coin_def exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_fake_coin_def_cl;
alter table ${iol_schema}.ncbs_fm_fake_coin_def exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_fake_coin_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_fake_coin_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_fake_coin_def_op purge;
drop table ${iol_schema}.ncbs_fm_fake_coin_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_fake_coin_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_fake_coin_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
