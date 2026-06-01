/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_rb_card_no_secretary_restraints
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
create table ${iol_schema}.ncbs_rb_card_no_secretary_restraints_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_rb_card_no_secretary_restraints
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_card_no_secretary_restraints_op purge;
drop table ${iol_schema}.ncbs_rb_card_no_secretary_restraints_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_rb_card_no_secretary_restraints_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_card_no_secretary_restraints where 0=1;

create table ${iol_schema}.ncbs_rb_card_no_secretary_restraints_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_rb_card_no_secretary_restraints where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_card_no_secretary_restraints_cl(
            card_no -- 卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,limit_id -- 限额编号
            ,limit_num -- 累计笔数
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,day_limit_avail -- 当日可用限额
            ,single_limit -- 账户单笔交易限额
            ,total_day_amt -- 单日累计小额免密限额
            ,no_password_status -- 免密状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_card_no_secretary_restraints_op(
            card_no -- 卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,limit_id -- 限额编号
            ,limit_num -- 累计笔数
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,day_limit_avail -- 当日可用限额
            ,single_limit -- 账户单笔交易限额
            ,total_day_amt -- 单日累计小额免密限额
            ,no_password_status -- 免密状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.card_no, o.card_no) as card_no -- 卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.internal_key, o.internal_key) as internal_key -- 账户内部键值
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.limit_id, o.limit_id) as limit_id -- 限额编号
    ,nvl(n.limit_num, o.limit_num) as limit_num -- 累计笔数
    ,nvl(n.last_change_date, o.last_change_date) as last_change_date -- 最后修改日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,nvl(n.day_limit_avail, o.day_limit_avail) as day_limit_avail -- 当日可用限额
    ,nvl(n.single_limit, o.single_limit) as single_limit -- 账户单笔交易限额
    ,nvl(n.total_day_amt, o.total_day_amt) as total_day_amt -- 单日累计小额免密限额
    ,nvl(n.no_password_status, o.no_password_status) as no_password_status -- 免密状态
    ,case when
            n.internal_key is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internal_key is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internal_key is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_rb_card_no_secretary_restraints_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_rb_card_no_secretary_restraints where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internal_key = n.internal_key
where (
        o.internal_key is null
    )
    or (
        n.internal_key is null
    )
    or (
        o.card_no <> n.card_no
        or o.client_no <> n.client_no
        or o.company <> n.company
        or o.limit_id <> n.limit_id
        or o.limit_num <> n.limit_num
        or o.last_change_date <> n.last_change_date
        or o.tran_timestamp <> n.tran_timestamp
        or o.day_limit_avail <> n.day_limit_avail
        or o.single_limit <> n.single_limit
        or o.total_day_amt <> n.total_day_amt
        or o.no_password_status <> n.no_password_status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_rb_card_no_secretary_restraints_cl(
            card_no -- 卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,limit_id -- 限额编号
            ,limit_num -- 累计笔数
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,day_limit_avail -- 当日可用限额
            ,single_limit -- 账户单笔交易限额
            ,total_day_amt -- 单日累计小额免密限额
            ,no_password_status -- 免密状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_rb_card_no_secretary_restraints_op(
            card_no -- 卡号
            ,client_no -- 客户编号
            ,internal_key -- 账户内部键值
            ,company -- 法人
            ,limit_id -- 限额编号
            ,limit_num -- 累计笔数
            ,last_change_date -- 最后修改日期
            ,tran_timestamp -- 交易时间戳
            ,day_limit_avail -- 当日可用限额
            ,single_limit -- 账户单笔交易限额
            ,total_day_amt -- 单日累计小额免密限额
            ,no_password_status -- 免密状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.card_no -- 卡号
    ,o.client_no -- 客户编号
    ,o.internal_key -- 账户内部键值
    ,o.company -- 法人
    ,o.limit_id -- 限额编号
    ,o.limit_num -- 累计笔数
    ,o.last_change_date -- 最后修改日期
    ,o.tran_timestamp -- 交易时间戳
    ,o.day_limit_avail -- 当日可用限额
    ,o.single_limit -- 账户单笔交易限额
    ,o.total_day_amt -- 单日累计小额免密限额
    ,o.no_password_status -- 免密状态
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
from ${iol_schema}.ncbs_rb_card_no_secretary_restraints_bk o
    left join ${iol_schema}.ncbs_rb_card_no_secretary_restraints_op n
        on
            o.internal_key = n.internal_key
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_rb_card_no_secretary_restraints_cl d
        on
            o.internal_key = d.internal_key
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_rb_card_no_secretary_restraints;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_rb_card_no_secretary_restraints') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_rb_card_no_secretary_restraints drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_rb_card_no_secretary_restraints add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_rb_card_no_secretary_restraints exchange partition p_${batch_date} with table ${iol_schema}.ncbs_rb_card_no_secretary_restraints_cl;
alter table ${iol_schema}.ncbs_rb_card_no_secretary_restraints exchange partition p_20991231 with table ${iol_schema}.ncbs_rb_card_no_secretary_restraints_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_rb_card_no_secretary_restraints to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_rb_card_no_secretary_restraints_op purge;
drop table ${iol_schema}.ncbs_rb_card_no_secretary_restraints_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_rb_card_no_secretary_restraints_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_rb_card_no_secretary_restraints',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
