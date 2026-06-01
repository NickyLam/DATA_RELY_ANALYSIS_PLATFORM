/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ncbs_cd_card_lock_tbl
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
create table ${iol_schema}.ncbs_cd_card_lock_tbl_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ncbs_cd_card_lock_tbl
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cd_card_lock_tbl_op purge;
drop table ${iol_schema}.ncbs_cd_card_lock_tbl_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ncbs_cd_card_lock_tbl_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cd_card_lock_tbl where 0=1;

create table ${iol_schema}.ncbs_cd_card_lock_tbl_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ncbs_cd_card_lock_tbl where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cd_card_lock_tbl_cl(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,common_province1 -- 常用省份1
            ,common_province2 -- 常用省份2
            ,common_province3 -- 常用省份3
            ,common_province4 -- 常用省份4
            ,common_province5 -- 常用省份5
            ,company -- 法人
            ,lock_flag -- 锁标志
            ,lock_type -- 锁类型
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cd_card_lock_tbl_op(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,common_province1 -- 常用省份1
            ,common_province2 -- 常用省份2
            ,common_province3 -- 常用省份3
            ,common_province4 -- 常用省份4
            ,common_province5 -- 常用省份5
            ,company -- 法人
            ,lock_flag -- 锁标志
            ,lock_type -- 锁类型
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.base_acct_no, o.base_acct_no) as base_acct_no -- 交易账号/卡号
    ,nvl(n.client_no, o.client_no) as client_no -- 客户编号
    ,nvl(n.common_province1, o.common_province1) as common_province1 -- 常用省份1
    ,nvl(n.common_province2, o.common_province2) as common_province2 -- 常用省份2
    ,nvl(n.common_province3, o.common_province3) as common_province3 -- 常用省份3
    ,nvl(n.common_province4, o.common_province4) as common_province4 -- 常用省份4
    ,nvl(n.common_province5, o.common_province5) as common_province5 -- 常用省份5
    ,nvl(n.company, o.company) as company -- 法人
    ,nvl(n.lock_flag, o.lock_flag) as lock_flag -- 锁标志
    ,nvl(n.lock_type, o.lock_type) as lock_type -- 锁类型
    ,nvl(n.end_date, o.end_date) as end_date -- 结束日期
    ,nvl(n.start_date, o.start_date) as start_date -- 开始日期
    ,nvl(n.tran_timestamp, o.tran_timestamp) as tran_timestamp -- 交易时间戳
    ,case when
            n.base_acct_no is null
            and n.lock_flag is null
            and n.lock_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.base_acct_no is null
            and n.lock_flag is null
            and n.lock_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.base_acct_no is null
            and n.lock_flag is null
            and n.lock_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ncbs_cd_card_lock_tbl_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ncbs_cd_card_lock_tbl where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.base_acct_no = n.base_acct_no
            and o.lock_flag = n.lock_flag
            and o.lock_type = n.lock_type
where (
        o.base_acct_no is null
        and o.lock_flag is null
        and o.lock_type is null
    )
    or (
        n.base_acct_no is null
        and n.lock_flag is null
        and n.lock_type is null
    )
    or (
        o.client_no <> n.client_no
        or o.common_province1 <> n.common_province1
        or o.common_province2 <> n.common_province2
        or o.common_province3 <> n.common_province3
        or o.common_province4 <> n.common_province4
        or o.common_province5 <> n.common_province5
        or o.company <> n.company
        or o.end_date <> n.end_date
        or o.start_date <> n.start_date
        or o.tran_timestamp <> n.tran_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ncbs_cd_card_lock_tbl_cl(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,common_province1 -- 常用省份1
            ,common_province2 -- 常用省份2
            ,common_province3 -- 常用省份3
            ,common_province4 -- 常用省份4
            ,common_province5 -- 常用省份5
            ,company -- 法人
            ,lock_flag -- 锁标志
            ,lock_type -- 锁类型
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ncbs_cd_card_lock_tbl_op(
            base_acct_no -- 交易账号/卡号
            ,client_no -- 客户编号
            ,common_province1 -- 常用省份1
            ,common_province2 -- 常用省份2
            ,common_province3 -- 常用省份3
            ,common_province4 -- 常用省份4
            ,common_province5 -- 常用省份5
            ,company -- 法人
            ,lock_flag -- 锁标志
            ,lock_type -- 锁类型
            ,end_date -- 结束日期
            ,start_date -- 开始日期
            ,tran_timestamp -- 交易时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.base_acct_no -- 交易账号/卡号
    ,o.client_no -- 客户编号
    ,o.common_province1 -- 常用省份1
    ,o.common_province2 -- 常用省份2
    ,o.common_province3 -- 常用省份3
    ,o.common_province4 -- 常用省份4
    ,o.common_province5 -- 常用省份5
    ,o.company -- 法人
    ,o.lock_flag -- 锁标志
    ,o.lock_type -- 锁类型
    ,o.end_date -- 结束日期
    ,o.start_date -- 开始日期
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
from ${iol_schema}.ncbs_cd_card_lock_tbl_bk o
    left join ${iol_schema}.ncbs_cd_card_lock_tbl_op n
        on
            o.base_acct_no = n.base_acct_no
            and o.lock_flag = n.lock_flag
            and o.lock_type = n.lock_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ncbs_cd_card_lock_tbl_cl d
        on
            o.base_acct_no = d.base_acct_no
            and o.lock_flag = d.lock_flag
            and o.lock_type = d.lock_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ncbs_cd_card_lock_tbl;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ncbs_cd_card_lock_tbl') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ncbs_cd_card_lock_tbl drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ncbs_cd_card_lock_tbl add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ncbs_cd_card_lock_tbl exchange partition p_${batch_date} with table ${iol_schema}.ncbs_cd_card_lock_tbl_cl;
alter table ${iol_schema}.ncbs_cd_card_lock_tbl exchange partition p_20991231 with table ${iol_schema}.ncbs_cd_card_lock_tbl_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ncbs_cd_card_lock_tbl to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ncbs_cd_card_lock_tbl_op purge;
drop table ${iol_schema}.ncbs_cd_card_lock_tbl_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ncbs_cd_card_lock_tbl_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ncbs_cd_card_lock_tbl',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
