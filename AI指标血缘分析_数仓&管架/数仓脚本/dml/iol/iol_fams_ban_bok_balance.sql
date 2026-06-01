/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_ban_bok_balance
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
create table ${iol_schema}.fams_ban_bok_balance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_ban_bok_balance;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_bok_balance_op purge;
drop table ${iol_schema}.fams_ban_bok_balance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_ban_bok_balance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_bok_balance where 0=1;

create table ${iol_schema}.fams_ban_bok_balance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_ban_bok_balance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_bok_balance_cl(
            bookset_id -- 账套代码
            ,balance_date -- 余额日期
            ,subject_no -- 科目号
            ,bal_flag -- 借贷方向
            ,amt -- 科目余额
            ,damt -- 借方金额
            ,camt -- 贷方金额
            ,ccy -- 币种
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_bok_balance_op(
            bookset_id -- 账套代码
            ,balance_date -- 余额日期
            ,subject_no -- 科目号
            ,bal_flag -- 借贷方向
            ,amt -- 科目余额
            ,damt -- 借方金额
            ,camt -- 贷方金额
            ,ccy -- 币种
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bookset_id, o.bookset_id) as bookset_id -- 账套代码
    ,nvl(n.balance_date, o.balance_date) as balance_date -- 余额日期
    ,nvl(n.subject_no, o.subject_no) as subject_no -- 科目号
    ,nvl(n.bal_flag, o.bal_flag) as bal_flag -- 借贷方向
    ,nvl(n.amt, o.amt) as amt -- 科目余额
    ,nvl(n.damt, o.damt) as damt -- 借方金额
    ,nvl(n.camt, o.camt) as camt -- 贷方金额
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.bookset_id is null
            and n.balance_date is null
            and n.subject_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bookset_id is null
            and n.balance_date is null
            and n.subject_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bookset_id is null
            and n.balance_date is null
            and n.subject_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_ban_bok_balance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_ban_bok_balance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bookset_id = n.bookset_id
            and o.balance_date = n.balance_date
            and o.subject_no = n.subject_no
where (
        o.bookset_id is null
        and o.balance_date is null
        and o.subject_no is null
    )
    or (
        n.bookset_id is null
        and n.balance_date is null
        and n.subject_no is null
    )
    or (
        o.bal_flag <> n.bal_flag
        or o.amt <> n.amt
        or o.damt <> n.damt
        or o.camt <> n.camt
        or o.ccy <> n.ccy
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_ban_bok_balance_cl(
            bookset_id -- 账套代码
            ,balance_date -- 余额日期
            ,subject_no -- 科目号
            ,bal_flag -- 借贷方向
            ,amt -- 科目余额
            ,damt -- 借方金额
            ,camt -- 贷方金额
            ,ccy -- 币种
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_ban_bok_balance_op(
            bookset_id -- 账套代码
            ,balance_date -- 余额日期
            ,subject_no -- 科目号
            ,bal_flag -- 借贷方向
            ,amt -- 科目余额
            ,damt -- 借方金额
            ,camt -- 贷方金额
            ,ccy -- 币种
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bookset_id -- 账套代码
    ,o.balance_date -- 余额日期
    ,o.subject_no -- 科目号
    ,o.bal_flag -- 借贷方向
    ,o.amt -- 科目余额
    ,o.damt -- 借方金额
    ,o.camt -- 贷方金额
    ,o.ccy -- 币种
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_ban_bok_balance_bk o
    left join ${iol_schema}.fams_ban_bok_balance_op n
        on
            o.bookset_id = n.bookset_id
            and o.balance_date = n.balance_date
            and o.subject_no = n.subject_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_ban_bok_balance_cl d
        on
            o.bookset_id = d.bookset_id
            and o.balance_date = d.balance_date
            and o.subject_no = d.subject_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_ban_bok_balance;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_ban_bok_balance exchange partition p_19000101 with table ${iol_schema}.fams_ban_bok_balance_cl;
alter table ${iol_schema}.fams_ban_bok_balance exchange partition p_20991231 with table ${iol_schema}.fams_ban_bok_balance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_ban_bok_balance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_ban_bok_balance_op purge;
drop table ${iol_schema}.fams_ban_bok_balance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_ban_bok_balance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_ban_bok_balance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
