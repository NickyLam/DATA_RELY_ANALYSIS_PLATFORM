/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fdps_fdp_account
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
create table ${iol_schema}.fdps_fdp_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fdps_fdp_account;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fdps_fdp_account_op purge;
drop table ${iol_schema}.fdps_fdp_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fdps_fdp_account_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fdps_fdp_account where 0=1;

create table ${iol_schema}.fdps_fdp_account_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fdps_fdp_account where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fdps_fdp_account_cl(
            fdp_account_id -- 主账号标识
            ,account_no -- 主账号
            ,actual_balance -- 实际余额
            ,available_balance -- 可用余额
            ,fee_balance -- 手续费子账户余额
            ,interest_balance -- 利息子账户
            ,allow_balance -- 余额子账户
            ,offset_balance -- 轧差子账户
            ,settle_balance -- 中间结算子账户（不纳入主账户总额）
            ,cash_balance -- 返现专户子账户
            ,yes_actual_balance -- 上日实际余额
            ,yes_available_balance -- 上日可用余额
            ,yes_fee_balance -- 上日手续费子账户余额
            ,yes_interest_balance -- 上日利息子账户
            ,yes_allow_balance -- 上日余额子账户
            ,yes_offset_balance -- 上日轧差子账户
            ,yes_settle_balance -- 上日中间结算子账户（不纳入主账户总额）
            ,yes_cash_balance -- 上日返现专户子账户
            ,account_status -- 账户状态
            ,remark -- 备注
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事物时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事物时间
            ,guarant_balance -- 担保子账户
            ,yes_guarant_balance -- 上日担保子账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fdps_fdp_account_op(
            fdp_account_id -- 主账号标识
            ,account_no -- 主账号
            ,actual_balance -- 实际余额
            ,available_balance -- 可用余额
            ,fee_balance -- 手续费子账户余额
            ,interest_balance -- 利息子账户
            ,allow_balance -- 余额子账户
            ,offset_balance -- 轧差子账户
            ,settle_balance -- 中间结算子账户（不纳入主账户总额）
            ,cash_balance -- 返现专户子账户
            ,yes_actual_balance -- 上日实际余额
            ,yes_available_balance -- 上日可用余额
            ,yes_fee_balance -- 上日手续费子账户余额
            ,yes_interest_balance -- 上日利息子账户
            ,yes_allow_balance -- 上日余额子账户
            ,yes_offset_balance -- 上日轧差子账户
            ,yes_settle_balance -- 上日中间结算子账户（不纳入主账户总额）
            ,yes_cash_balance -- 上日返现专户子账户
            ,account_status -- 账户状态
            ,remark -- 备注
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事物时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事物时间
            ,guarant_balance -- 担保子账户
            ,yes_guarant_balance -- 上日担保子账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fdp_account_id, o.fdp_account_id) as fdp_account_id -- 主账号标识
    ,nvl(n.account_no, o.account_no) as account_no -- 主账号
    ,nvl(n.actual_balance, o.actual_balance) as actual_balance -- 实际余额
    ,nvl(n.available_balance, o.available_balance) as available_balance -- 可用余额
    ,nvl(n.fee_balance, o.fee_balance) as fee_balance -- 手续费子账户余额
    ,nvl(n.interest_balance, o.interest_balance) as interest_balance -- 利息子账户
    ,nvl(n.allow_balance, o.allow_balance) as allow_balance -- 余额子账户
    ,nvl(n.offset_balance, o.offset_balance) as offset_balance -- 轧差子账户
    ,nvl(n.settle_balance, o.settle_balance) as settle_balance -- 中间结算子账户（不纳入主账户总额）
    ,nvl(n.cash_balance, o.cash_balance) as cash_balance -- 返现专户子账户
    ,nvl(n.yes_actual_balance, o.yes_actual_balance) as yes_actual_balance -- 上日实际余额
    ,nvl(n.yes_available_balance, o.yes_available_balance) as yes_available_balance -- 上日可用余额
    ,nvl(n.yes_fee_balance, o.yes_fee_balance) as yes_fee_balance -- 上日手续费子账户余额
    ,nvl(n.yes_interest_balance, o.yes_interest_balance) as yes_interest_balance -- 上日利息子账户
    ,nvl(n.yes_allow_balance, o.yes_allow_balance) as yes_allow_balance -- 上日余额子账户
    ,nvl(n.yes_offset_balance, o.yes_offset_balance) as yes_offset_balance -- 上日轧差子账户
    ,nvl(n.yes_settle_balance, o.yes_settle_balance) as yes_settle_balance -- 上日中间结算子账户（不纳入主账户总额）
    ,nvl(n.yes_cash_balance, o.yes_cash_balance) as yes_cash_balance -- 上日返现专户子账户
    ,nvl(n.account_status, o.account_status) as account_status -- 账户状态
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 最后更新时间
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 最后更新事物时间
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 创建时间
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 创建事物时间
    ,nvl(n.guarant_balance, o.guarant_balance) as guarant_balance -- 担保子账户
    ,nvl(n.yes_guarant_balance, o.yes_guarant_balance) as yes_guarant_balance -- 上日担保子账户
    ,case when
            n.fdp_account_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fdp_account_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fdp_account_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fdps_fdp_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fdps_fdp_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fdp_account_id = n.fdp_account_id
where (
        o.fdp_account_id is null
    )
    or (
        n.fdp_account_id is null
    )
    or (
        o.account_no <> n.account_no
        or o.actual_balance <> n.actual_balance
        or o.available_balance <> n.available_balance
        or o.fee_balance <> n.fee_balance
        or o.interest_balance <> n.interest_balance
        or o.allow_balance <> n.allow_balance
        or o.offset_balance <> n.offset_balance
        or o.settle_balance <> n.settle_balance
        or o.cash_balance <> n.cash_balance
        or o.yes_actual_balance <> n.yes_actual_balance
        or o.yes_available_balance <> n.yes_available_balance
        or o.yes_fee_balance <> n.yes_fee_balance
        or o.yes_interest_balance <> n.yes_interest_balance
        or o.yes_allow_balance <> n.yes_allow_balance
        or o.yes_offset_balance <> n.yes_offset_balance
        or o.yes_settle_balance <> n.yes_settle_balance
        or o.yes_cash_balance <> n.yes_cash_balance
        or o.account_status <> n.account_status
        or o.remark <> n.remark
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.guarant_balance <> n.guarant_balance
        or o.yes_guarant_balance <> n.yes_guarant_balance
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fdps_fdp_account_cl(
            fdp_account_id -- 主账号标识
            ,account_no -- 主账号
            ,actual_balance -- 实际余额
            ,available_balance -- 可用余额
            ,fee_balance -- 手续费子账户余额
            ,interest_balance -- 利息子账户
            ,allow_balance -- 余额子账户
            ,offset_balance -- 轧差子账户
            ,settle_balance -- 中间结算子账户（不纳入主账户总额）
            ,cash_balance -- 返现专户子账户
            ,yes_actual_balance -- 上日实际余额
            ,yes_available_balance -- 上日可用余额
            ,yes_fee_balance -- 上日手续费子账户余额
            ,yes_interest_balance -- 上日利息子账户
            ,yes_allow_balance -- 上日余额子账户
            ,yes_offset_balance -- 上日轧差子账户
            ,yes_settle_balance -- 上日中间结算子账户（不纳入主账户总额）
            ,yes_cash_balance -- 上日返现专户子账户
            ,account_status -- 账户状态
            ,remark -- 备注
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事物时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事物时间
            ,guarant_balance -- 担保子账户
            ,yes_guarant_balance -- 上日担保子账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fdps_fdp_account_op(
            fdp_account_id -- 主账号标识
            ,account_no -- 主账号
            ,actual_balance -- 实际余额
            ,available_balance -- 可用余额
            ,fee_balance -- 手续费子账户余额
            ,interest_balance -- 利息子账户
            ,allow_balance -- 余额子账户
            ,offset_balance -- 轧差子账户
            ,settle_balance -- 中间结算子账户（不纳入主账户总额）
            ,cash_balance -- 返现专户子账户
            ,yes_actual_balance -- 上日实际余额
            ,yes_available_balance -- 上日可用余额
            ,yes_fee_balance -- 上日手续费子账户余额
            ,yes_interest_balance -- 上日利息子账户
            ,yes_allow_balance -- 上日余额子账户
            ,yes_offset_balance -- 上日轧差子账户
            ,yes_settle_balance -- 上日中间结算子账户（不纳入主账户总额）
            ,yes_cash_balance -- 上日返现专户子账户
            ,account_status -- 账户状态
            ,remark -- 备注
            ,last_updated_stamp -- 最后更新时间
            ,last_updated_tx_stamp -- 最后更新事物时间
            ,created_stamp -- 创建时间
            ,created_tx_stamp -- 创建事物时间
            ,guarant_balance -- 担保子账户
            ,yes_guarant_balance -- 上日担保子账户
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fdp_account_id -- 主账号标识
    ,o.account_no -- 主账号
    ,o.actual_balance -- 实际余额
    ,o.available_balance -- 可用余额
    ,o.fee_balance -- 手续费子账户余额
    ,o.interest_balance -- 利息子账户
    ,o.allow_balance -- 余额子账户
    ,o.offset_balance -- 轧差子账户
    ,o.settle_balance -- 中间结算子账户（不纳入主账户总额）
    ,o.cash_balance -- 返现专户子账户
    ,o.yes_actual_balance -- 上日实际余额
    ,o.yes_available_balance -- 上日可用余额
    ,o.yes_fee_balance -- 上日手续费子账户余额
    ,o.yes_interest_balance -- 上日利息子账户
    ,o.yes_allow_balance -- 上日余额子账户
    ,o.yes_offset_balance -- 上日轧差子账户
    ,o.yes_settle_balance -- 上日中间结算子账户（不纳入主账户总额）
    ,o.yes_cash_balance -- 上日返现专户子账户
    ,o.account_status -- 账户状态
    ,o.remark -- 备注
    ,o.last_updated_stamp -- 最后更新时间
    ,o.last_updated_tx_stamp -- 最后更新事物时间
    ,o.created_stamp -- 创建时间
    ,o.created_tx_stamp -- 创建事物时间
    ,o.guarant_balance -- 担保子账户
    ,o.yes_guarant_balance -- 上日担保子账户
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fdps_fdp_account_bk o
    left join ${iol_schema}.fdps_fdp_account_op n
        on
            o.fdp_account_id = n.fdp_account_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fdps_fdp_account_cl d
        on
            o.fdp_account_id = d.fdp_account_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fdps_fdp_account;

-- 4.2 exchange partition
alter table ${iol_schema}.fdps_fdp_account exchange partition p_19000101 with table ${iol_schema}.fdps_fdp_account_cl;
alter table ${iol_schema}.fdps_fdp_account exchange partition p_20991231 with table ${iol_schema}.fdps_fdp_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fdps_fdp_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fdps_fdp_account_op purge;
drop table ${iol_schema}.fdps_fdp_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fdps_fdp_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fdps_fdp_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
