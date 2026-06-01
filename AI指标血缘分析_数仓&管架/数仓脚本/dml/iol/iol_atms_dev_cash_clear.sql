/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_atms_dev_cash_clear
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
create table ${iol_schema}.atms_dev_cash_clear_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.atms_dev_cash_clear
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_cash_clear_op purge;
drop table ${iol_schema}.atms_dev_cash_clear_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.atms_dev_cash_clear_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_cash_clear where 0=1;

create table ${iol_schema}.atms_dev_cash_clear_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.atms_dev_cash_clear where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_cash_clear_cl(
            dev_no -- 设备号
            ,addcash_id -- 加钞标识（当前日期+编号，编号为两位，从00~99）
            ,addcash_datetime -- 加钞日期
            ,addcash_amount -- 加钞金额
            ,addcash_type -- 加钞面值集合 如50,100多种面值以逗号分割
            ,addcash_count -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
            ,clear_datetime -- 清机时间
            ,addcash_left -- 主机尾箱余额
            ,addcash_lastamount -- 钞箱剩余金额（不包括回收箱）
            ,addcash_retractcount -- 回收箱张数
            ,deposit_count -- 存款总笔数
            ,deposit_amount -- 存款总金额
            ,withdraw_count -- 取款总笔数
            ,withdraw_amount -- 取款总金额
            ,clear_id -- 
            ,cashutil_amount -- 
            ,cashby_handcount -- 
            ,add_id -- 
            ,add_cash_method -- 加钞方式（0-本地加钞，1-联动加钞）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_dev_cash_clear_op(
            dev_no -- 设备号
            ,addcash_id -- 加钞标识（当前日期+编号，编号为两位，从00~99）
            ,addcash_datetime -- 加钞日期
            ,addcash_amount -- 加钞金额
            ,addcash_type -- 加钞面值集合 如50,100多种面值以逗号分割
            ,addcash_count -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
            ,clear_datetime -- 清机时间
            ,addcash_left -- 主机尾箱余额
            ,addcash_lastamount -- 钞箱剩余金额（不包括回收箱）
            ,addcash_retractcount -- 回收箱张数
            ,deposit_count -- 存款总笔数
            ,deposit_amount -- 存款总金额
            ,withdraw_count -- 取款总笔数
            ,withdraw_amount -- 取款总金额
            ,clear_id -- 
            ,cashutil_amount -- 
            ,cashby_handcount -- 
            ,add_id -- 
            ,add_cash_method -- 加钞方式（0-本地加钞，1-联动加钞）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.dev_no, o.dev_no) as dev_no -- 设备号
    ,nvl(n.addcash_id, o.addcash_id) as addcash_id -- 加钞标识（当前日期+编号，编号为两位，从00~99）
    ,nvl(n.addcash_datetime, o.addcash_datetime) as addcash_datetime -- 加钞日期
    ,nvl(n.addcash_amount, o.addcash_amount) as addcash_amount -- 加钞金额
    ,nvl(n.addcash_type, o.addcash_type) as addcash_type -- 加钞面值集合 如50,100多种面值以逗号分割
    ,nvl(n.addcash_count, o.addcash_count) as addcash_count -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
    ,nvl(n.clear_datetime, o.clear_datetime) as clear_datetime -- 清机时间
    ,nvl(n.addcash_left, o.addcash_left) as addcash_left -- 主机尾箱余额
    ,nvl(n.addcash_lastamount, o.addcash_lastamount) as addcash_lastamount -- 钞箱剩余金额（不包括回收箱）
    ,nvl(n.addcash_retractcount, o.addcash_retractcount) as addcash_retractcount -- 回收箱张数
    ,nvl(n.deposit_count, o.deposit_count) as deposit_count -- 存款总笔数
    ,nvl(n.deposit_amount, o.deposit_amount) as deposit_amount -- 存款总金额
    ,nvl(n.withdraw_count, o.withdraw_count) as withdraw_count -- 取款总笔数
    ,nvl(n.withdraw_amount, o.withdraw_amount) as withdraw_amount -- 取款总金额
    ,nvl(n.clear_id, o.clear_id) as clear_id -- 
    ,nvl(n.cashutil_amount, o.cashutil_amount) as cashutil_amount -- 
    ,nvl(n.cashby_handcount, o.cashby_handcount) as cashby_handcount -- 
    ,nvl(n.add_id, o.add_id) as add_id -- 
    ,nvl(n.add_cash_method, o.add_cash_method) as add_cash_method -- 加钞方式（0-本地加钞，1-联动加钞）
    ,case when
            n.dev_no is null
            and n.addcash_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.dev_no is null
            and n.addcash_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.dev_no is null
            and n.addcash_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.atms_dev_cash_clear_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.atms_dev_cash_clear where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.dev_no = n.dev_no
            and o.addcash_id = n.addcash_id
where (
        o.dev_no is null
        and o.addcash_id is null
    )
    or (
        n.dev_no is null
        and n.addcash_id is null
    )
    or (
        o.addcash_datetime <> n.addcash_datetime
        or o.addcash_amount <> n.addcash_amount
        or o.addcash_type <> n.addcash_type
        or o.addcash_count <> n.addcash_count
        or o.clear_datetime <> n.clear_datetime
        or o.addcash_left <> n.addcash_left
        or o.addcash_lastamount <> n.addcash_lastamount
        or o.addcash_retractcount <> n.addcash_retractcount
        or o.deposit_count <> n.deposit_count
        or o.deposit_amount <> n.deposit_amount
        or o.withdraw_count <> n.withdraw_count
        or o.withdraw_amount <> n.withdraw_amount
        or o.clear_id <> n.clear_id
        or o.cashutil_amount <> n.cashutil_amount
        or o.cashby_handcount <> n.cashby_handcount
        or o.add_id <> n.add_id
        or o.add_cash_method <> n.add_cash_method
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.atms_dev_cash_clear_cl(
            dev_no -- 设备号
            ,addcash_id -- 加钞标识（当前日期+编号，编号为两位，从00~99）
            ,addcash_datetime -- 加钞日期
            ,addcash_amount -- 加钞金额
            ,addcash_type -- 加钞面值集合 如50,100多种面值以逗号分割
            ,addcash_count -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
            ,clear_datetime -- 清机时间
            ,addcash_left -- 主机尾箱余额
            ,addcash_lastamount -- 钞箱剩余金额（不包括回收箱）
            ,addcash_retractcount -- 回收箱张数
            ,deposit_count -- 存款总笔数
            ,deposit_amount -- 存款总金额
            ,withdraw_count -- 取款总笔数
            ,withdraw_amount -- 取款总金额
            ,clear_id -- 
            ,cashutil_amount -- 
            ,cashby_handcount -- 
            ,add_id -- 
            ,add_cash_method -- 加钞方式（0-本地加钞，1-联动加钞）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.atms_dev_cash_clear_op(
            dev_no -- 设备号
            ,addcash_id -- 加钞标识（当前日期+编号，编号为两位，从00~99）
            ,addcash_datetime -- 加钞日期
            ,addcash_amount -- 加钞金额
            ,addcash_type -- 加钞面值集合 如50,100多种面值以逗号分割
            ,addcash_count -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
            ,clear_datetime -- 清机时间
            ,addcash_left -- 主机尾箱余额
            ,addcash_lastamount -- 钞箱剩余金额（不包括回收箱）
            ,addcash_retractcount -- 回收箱张数
            ,deposit_count -- 存款总笔数
            ,deposit_amount -- 存款总金额
            ,withdraw_count -- 取款总笔数
            ,withdraw_amount -- 取款总金额
            ,clear_id -- 
            ,cashutil_amount -- 
            ,cashby_handcount -- 
            ,add_id -- 
            ,add_cash_method -- 加钞方式（0-本地加钞，1-联动加钞）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.dev_no -- 设备号
    ,o.addcash_id -- 加钞标识（当前日期+编号，编号为两位，从00~99）
    ,o.addcash_datetime -- 加钞日期
    ,o.addcash_amount -- 加钞金额
    ,o.addcash_type -- 加钞面值集合 如50,100多种面值以逗号分割
    ,o.addcash_count -- 加钞张数 如 1000,2000 多种面值与AddCashType的面值对应，同样以逗号分割
    ,o.clear_datetime -- 清机时间
    ,o.addcash_left -- 主机尾箱余额
    ,o.addcash_lastamount -- 钞箱剩余金额（不包括回收箱）
    ,o.addcash_retractcount -- 回收箱张数
    ,o.deposit_count -- 存款总笔数
    ,o.deposit_amount -- 存款总金额
    ,o.withdraw_count -- 取款总笔数
    ,o.withdraw_amount -- 取款总金额
    ,o.clear_id -- 
    ,o.cashutil_amount -- 
    ,o.cashby_handcount -- 
    ,o.add_id -- 
    ,o.add_cash_method -- 加钞方式（0-本地加钞，1-联动加钞）
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
from ${iol_schema}.atms_dev_cash_clear_bk o
    left join ${iol_schema}.atms_dev_cash_clear_op n
        on
            o.dev_no = n.dev_no
            and o.addcash_id = n.addcash_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.atms_dev_cash_clear_cl d
        on
            o.dev_no = d.dev_no
            and o.addcash_id = d.addcash_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.atms_dev_cash_clear;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('atms_dev_cash_clear') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.atms_dev_cash_clear drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.atms_dev_cash_clear add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.atms_dev_cash_clear exchange partition p_${batch_date} with table ${iol_schema}.atms_dev_cash_clear_cl;
alter table ${iol_schema}.atms_dev_cash_clear exchange partition p_20991231 with table ${iol_schema}.atms_dev_cash_clear_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.atms_dev_cash_clear to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.atms_dev_cash_clear_op purge;
drop table ${iol_schema}.atms_dev_cash_clear_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.atms_dev_cash_clear_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'atms_dev_cash_clear',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
