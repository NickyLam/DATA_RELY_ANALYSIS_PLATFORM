/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_bail_account
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
create table ${iol_schema}.bdps_bail_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_bail_account;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_bail_account_op purge;
drop table ${iol_schema}.bdps_bail_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_bail_account_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_bail_account where 0=1;

create table ${iol_schema}.bdps_bail_account_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_bail_account where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_bail_account_cl(
            id -- 
            ,bail_account -- 
            ,cust_id -- 
            ,bail_sub_no -- 
            ,bail_amount -- 
            ,manager_id -- 
            ,depart_id -- 
            ,brch_id -- 
            ,cust_account_start_dt -- 
            ,cust_account_mature_dt -- 
            ,cust_account_rate -- 
            ,deposit_type -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,valid_flag -- 
            ,lock_flag -- 
            ,lock_type -- 
            ,lock_id -- 
            ,if_default -- 
            ,avaibl -- 
            ,pool_type -- 1-额度池；2-资产池
            ,bank_no -- 开户行号
            ,bank_name -- 开户行名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_bail_account_op(
            id -- 
            ,bail_account -- 
            ,cust_id -- 
            ,bail_sub_no -- 
            ,bail_amount -- 
            ,manager_id -- 
            ,depart_id -- 
            ,brch_id -- 
            ,cust_account_start_dt -- 
            ,cust_account_mature_dt -- 
            ,cust_account_rate -- 
            ,deposit_type -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,valid_flag -- 
            ,lock_flag -- 
            ,lock_type -- 
            ,lock_id -- 
            ,if_default -- 
            ,avaibl -- 
            ,pool_type -- 1-额度池；2-资产池
            ,bank_no -- 开户行号
            ,bank_name -- 开户行名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.bail_account, o.bail_account) as bail_account -- 
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 
    ,nvl(n.bail_sub_no, o.bail_sub_no) as bail_sub_no -- 
    ,nvl(n.bail_amount, o.bail_amount) as bail_amount -- 
    ,nvl(n.manager_id, o.manager_id) as manager_id -- 
    ,nvl(n.depart_id, o.depart_id) as depart_id -- 
    ,nvl(n.brch_id, o.brch_id) as brch_id -- 
    ,nvl(n.cust_account_start_dt, o.cust_account_start_dt) as cust_account_start_dt -- 
    ,nvl(n.cust_account_mature_dt, o.cust_account_mature_dt) as cust_account_mature_dt -- 
    ,nvl(n.cust_account_rate, o.cust_account_rate) as cust_account_rate -- 
    ,nvl(n.deposit_type, o.deposit_type) as deposit_type -- 
    ,nvl(n.last_upd_oper_id, o.last_upd_oper_id) as last_upd_oper_id -- 
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 
    ,nvl(n.valid_flag, o.valid_flag) as valid_flag -- 
    ,nvl(n.lock_flag, o.lock_flag) as lock_flag -- 
    ,nvl(n.lock_type, o.lock_type) as lock_type -- 
    ,nvl(n.lock_id, o.lock_id) as lock_id -- 
    ,nvl(n.if_default, o.if_default) as if_default -- 
    ,nvl(n.avaibl, o.avaibl) as avaibl -- 
    ,nvl(n.pool_type, o.pool_type) as pool_type -- 1-额度池；2-资产池
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 开户行号
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 开户行名称
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
from (select * from ${iol_schema}.bdps_bail_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_bail_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.bail_account <> n.bail_account
        or o.cust_id <> n.cust_id
        or o.bail_sub_no <> n.bail_sub_no
        or o.bail_amount <> n.bail_amount
        or o.manager_id <> n.manager_id
        or o.depart_id <> n.depart_id
        or o.brch_id <> n.brch_id
        or o.cust_account_start_dt <> n.cust_account_start_dt
        or o.cust_account_mature_dt <> n.cust_account_mature_dt
        or o.cust_account_rate <> n.cust_account_rate
        or o.deposit_type <> n.deposit_type
        or o.last_upd_oper_id <> n.last_upd_oper_id
        or o.last_upd_time <> n.last_upd_time
        or o.valid_flag <> n.valid_flag
        or o.lock_flag <> n.lock_flag
        or o.lock_type <> n.lock_type
        or o.lock_id <> n.lock_id
        or o.if_default <> n.if_default
        or o.avaibl <> n.avaibl
        or o.pool_type <> n.pool_type
        or o.bank_no <> n.bank_no
        or o.bank_name <> n.bank_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_bail_account_cl(
            id -- 
            ,bail_account -- 
            ,cust_id -- 
            ,bail_sub_no -- 
            ,bail_amount -- 
            ,manager_id -- 
            ,depart_id -- 
            ,brch_id -- 
            ,cust_account_start_dt -- 
            ,cust_account_mature_dt -- 
            ,cust_account_rate -- 
            ,deposit_type -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,valid_flag -- 
            ,lock_flag -- 
            ,lock_type -- 
            ,lock_id -- 
            ,if_default -- 
            ,avaibl -- 
            ,pool_type -- 1-额度池；2-资产池
            ,bank_no -- 开户行号
            ,bank_name -- 开户行名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_bail_account_op(
            id -- 
            ,bail_account -- 
            ,cust_id -- 
            ,bail_sub_no -- 
            ,bail_amount -- 
            ,manager_id -- 
            ,depart_id -- 
            ,brch_id -- 
            ,cust_account_start_dt -- 
            ,cust_account_mature_dt -- 
            ,cust_account_rate -- 
            ,deposit_type -- 
            ,last_upd_oper_id -- 
            ,last_upd_time -- 
            ,valid_flag -- 
            ,lock_flag -- 
            ,lock_type -- 
            ,lock_id -- 
            ,if_default -- 
            ,avaibl -- 
            ,pool_type -- 1-额度池；2-资产池
            ,bank_no -- 开户行号
            ,bank_name -- 开户行名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.bail_account -- 
    ,o.cust_id -- 
    ,o.bail_sub_no -- 
    ,o.bail_amount -- 
    ,o.manager_id -- 
    ,o.depart_id -- 
    ,o.brch_id -- 
    ,o.cust_account_start_dt -- 
    ,o.cust_account_mature_dt -- 
    ,o.cust_account_rate -- 
    ,o.deposit_type -- 
    ,o.last_upd_oper_id -- 
    ,o.last_upd_time -- 
    ,o.valid_flag -- 
    ,o.lock_flag -- 
    ,o.lock_type -- 
    ,o.lock_id -- 
    ,o.if_default -- 
    ,o.avaibl -- 
    ,o.pool_type -- 1-额度池；2-资产池
    ,o.bank_no -- 开户行号
    ,o.bank_name -- 开户行名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_bail_account_bk o
    left join ${iol_schema}.bdps_bail_account_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_bail_account_cl d
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
-- truncate table ${iol_schema}.bdps_bail_account;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_bail_account exchange partition p_19000101 with table ${iol_schema}.bdps_bail_account_cl;
alter table ${iol_schema}.bdps_bail_account exchange partition p_20991231 with table ${iol_schema}.bdps_bail_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_bail_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_bail_account_op purge;
drop table ${iol_schema}.bdps_bail_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_bail_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_bail_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
