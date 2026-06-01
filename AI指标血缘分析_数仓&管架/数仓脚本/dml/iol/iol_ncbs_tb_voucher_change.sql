/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_tb_voucher_change
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
create table ${iol_schema}.ncbs_tb_voucher_change_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_tb_voucher_change
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_voucher_change_op purge;
drop table ${iol_schema}.ncbs_tb_voucher_change_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_tb_voucher_change_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_voucher_change where 0=1;

create table ${iol_schema}.ncbs_tb_voucher_change_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_tb_voucher_change where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_voucher_change_cl(
            company -- 法人
            ,new_status -- 新凭证状态
            ,old_status -- 凭证原状态
            ,post_flag -- 是否生成分录
            ,status_desc -- 描述信息
            ,update_after -- 凭证出售后登记簿更新标志
            ,update_before -- 凭证出售前登记簿更新标志
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_voucher_change_op(
            company -- 法人
            ,new_status -- 新凭证状态
            ,old_status -- 凭证原状态
            ,post_flag -- 是否生成分录
            ,status_desc -- 描述信息
            ,update_after -- 凭证出售后登记簿更新标志
            ,update_before -- 凭证出售前登记簿更新标志
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.company, o.company) as company -- 法人
    ,nvl(n.new_status, o.new_status) as new_status -- 新凭证状态
    ,nvl(n.old_status, o.old_status) as old_status -- 凭证原状态
    ,nvl(n.post_flag, o.post_flag) as post_flag -- 是否生成分录
    ,nvl(n.status_desc, o.status_desc) as status_desc -- 描述信息
    ,nvl(n.update_after, o.update_after) as update_after -- 凭证出售后登记簿更新标志
    ,nvl(n.update_before, o.update_before) as update_before -- 凭证出售前登记簿更新标志
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.new_status is null
            and n.old_status is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.new_status is null
            and n.old_status is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.new_status is null
            and n.old_status is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_tb_voucher_change_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_tb_voucher_change where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.new_status = n.new_status
            and o.old_status = n.old_status
where (
        o.new_status is null
        and o.old_status is null
    )
    or (
        n.new_status is null
        and n.old_status is null
    )
    or (
        o.company <> n.company
        or o.post_flag <> n.post_flag
        or o.status_desc <> n.status_desc
        or o.update_after <> n.update_after
        or o.update_before <> n.update_before
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_tb_voucher_change_cl(
            company -- 法人
            ,new_status -- 新凭证状态
            ,old_status -- 凭证原状态
            ,post_flag -- 是否生成分录
            ,status_desc -- 描述信息
            ,update_after -- 凭证出售后登记簿更新标志
            ,update_before -- 凭证出售前登记簿更新标志
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_tb_voucher_change_op(
            company -- 法人
            ,new_status -- 新凭证状态
            ,old_status -- 凭证原状态
            ,post_flag -- 是否生成分录
            ,status_desc -- 描述信息
            ,update_after -- 凭证出售后登记簿更新标志
            ,update_before -- 凭证出售前登记簿更新标志
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.company -- 法人
    ,o.new_status -- 新凭证状态
    ,o.old_status -- 凭证原状态
    ,o.post_flag -- 是否生成分录
    ,o.status_desc -- 描述信息
    ,o.update_after -- 凭证出售后登记簿更新标志
    ,o.update_before -- 凭证出售前登记簿更新标志
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
from ${iol_schema}.ncbs_tb_voucher_change_bk o
    left join ${iol_schema}.ncbs_tb_voucher_change_op n
        on
            o.new_status = n.new_status
            and o.old_status = n.old_status
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_tb_voucher_change_cl d
        on
            o.new_status = d.new_status
            and o.old_status = d.old_status
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_tb_voucher_change;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_tb_voucher_change') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_tb_voucher_change drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_tb_voucher_change add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_tb_voucher_change exchange partition p_${batch_date} with table ${iol_schema}.ncbs_tb_voucher_change_cl;
alter table ${iol_schema}.ncbs_tb_voucher_change exchange partition p_20991231 with table ${iol_schema}.ncbs_tb_voucher_change_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_tb_voucher_change to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_tb_voucher_change_op purge;
drop table ${iol_schema}.ncbs_tb_voucher_change_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_tb_voucher_change_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_tb_voucher_change',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
