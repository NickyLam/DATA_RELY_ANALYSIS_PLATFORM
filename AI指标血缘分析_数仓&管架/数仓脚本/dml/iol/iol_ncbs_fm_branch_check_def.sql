/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_fm_branch_check_def
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
create table ${iol_schema}.ncbs_fm_branch_check_def_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_fm_branch_check_def
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_branch_check_def_op purge;
drop table ${iol_schema}.ncbs_fm_branch_check_def_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_fm_branch_check_def_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_branch_check_def where 0=1;

create table ${iol_schema}.ncbs_fm_branch_check_def_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_fm_branch_check_def where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_branch_check_def_cl(
            company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,branch_check_ref -- 机构检查定义类
            ,branch_check_desc -- 机构检查定义类描述
            ,branch_check_type -- 机构检查定义类检查类型
            ,branch_check_item_type -- 机构检查事项类型
            ,branch_check_item_status -- 机构检查事项状态
            ,branch_check_item_message -- 机构检查事项提示信息
            ,branch_check_item -- 机构检查事项
            ,branch_check_item_desc -- 机构检查事项描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_branch_check_def_op(
            company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,branch_check_ref -- 机构检查定义类
            ,branch_check_desc -- 机构检查定义类描述
            ,branch_check_type -- 机构检查定义类检查类型
            ,branch_check_item_type -- 机构检查事项类型
            ,branch_check_item_status -- 机构检查事项状态
            ,branch_check_item_message -- 机构检查事项提示信息
            ,branch_check_item -- 机构检查事项
            ,branch_check_item_desc -- 机构检查事项描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.company, o.company) as company -- 法人
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.branch_check_ref, o.branch_check_ref) as branch_check_ref -- 机构检查定义类
    ,nvl(n.branch_check_desc, o.branch_check_desc) as branch_check_desc -- 机构检查定义类描述
    ,nvl(n.branch_check_type, o.branch_check_type) as branch_check_type -- 机构检查定义类检查类型
    ,nvl(n.branch_check_item_type, o.branch_check_item_type) as branch_check_item_type -- 机构检查事项类型
    ,nvl(n.branch_check_item_status, o.branch_check_item_status) as branch_check_item_status -- 机构检查事项状态
    ,nvl(n.branch_check_item_message, o.branch_check_item_message) as branch_check_item_message -- 机构检查事项提示信息
    ,nvl(n.branch_check_item, o.branch_check_item) as branch_check_item -- 机构检查事项
    ,nvl(n.branch_check_item_desc, o.branch_check_item_desc) as branch_check_item_desc -- 机构检查事项描述
    ,case when
            n.branch_check_type is null
            and n.branch_check_item is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.branch_check_type is null
            and n.branch_check_item is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.branch_check_type is null
            and n.branch_check_item is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_fm_branch_check_def_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_fm_branch_check_def where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.branch_check_type = n.branch_check_type
            and o.branch_check_item = n.branch_check_item
where (
        o.branch_check_type is null
        and o.branch_check_item is null
    )
    or (
        n.branch_check_type is null
        and n.branch_check_item is null
    )
    or (
        o.company <> n.company
        or o.tran_timestamp <> n.tran_timestamp
        or o.branch_check_ref <> n.branch_check_ref
        or o.branch_check_desc <> n.branch_check_desc
        or o.branch_check_item_type <> n.branch_check_item_type
        or o.branch_check_item_status <> n.branch_check_item_status
        or o.branch_check_item_message <> n.branch_check_item_message
        or o.branch_check_item_desc <> n.branch_check_item_desc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_fm_branch_check_def_cl(
            company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,branch_check_ref -- 机构检查定义类
            ,branch_check_desc -- 机构检查定义类描述
            ,branch_check_type -- 机构检查定义类检查类型
            ,branch_check_item_type -- 机构检查事项类型
            ,branch_check_item_status -- 机构检查事项状态
            ,branch_check_item_message -- 机构检查事项提示信息
            ,branch_check_item -- 机构检查事项
            ,branch_check_item_desc -- 机构检查事项描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_fm_branch_check_def_op(
            company -- 法人
            ,tran_timestamp -- 交易时间戳
            ,branch_check_ref -- 机构检查定义类
            ,branch_check_desc -- 机构检查定义类描述
            ,branch_check_type -- 机构检查定义类检查类型
            ,branch_check_item_type -- 机构检查事项类型
            ,branch_check_item_status -- 机构检查事项状态
            ,branch_check_item_message -- 机构检查事项提示信息
            ,branch_check_item -- 机构检查事项
            ,branch_check_item_desc -- 机构检查事项描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.company -- 法人
    ,o.tran_timestamp -- 交易时间戳
    ,o.branch_check_ref -- 机构检查定义类
    ,o.branch_check_desc -- 机构检查定义类描述
    ,o.branch_check_type -- 机构检查定义类检查类型
    ,o.branch_check_item_type -- 机构检查事项类型
    ,o.branch_check_item_status -- 机构检查事项状态
    ,o.branch_check_item_message -- 机构检查事项提示信息
    ,o.branch_check_item -- 机构检查事项
    ,o.branch_check_item_desc -- 机构检查事项描述
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
from ${iol_schema}.ncbs_fm_branch_check_def_bk o
    left join ${iol_schema}.ncbs_fm_branch_check_def_op n
        on
            o.branch_check_type = n.branch_check_type
            and o.branch_check_item = n.branch_check_item
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_fm_branch_check_def_cl d
        on
            o.branch_check_type = d.branch_check_type
            and o.branch_check_item = d.branch_check_item
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_fm_branch_check_def;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_fm_branch_check_def') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_fm_branch_check_def drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_fm_branch_check_def add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_fm_branch_check_def exchange partition p_${batch_date} with table ${iol_schema}.ncbs_fm_branch_check_def_cl;
alter table ${iol_schema}.ncbs_fm_branch_check_def exchange partition p_20991231 with table ${iol_schema}.ncbs_fm_branch_check_def_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_fm_branch_check_def to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_fm_branch_check_def_op purge;
drop table ${iol_schema}.ncbs_fm_branch_check_def_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_fm_branch_check_def_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_fm_branch_check_def',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
