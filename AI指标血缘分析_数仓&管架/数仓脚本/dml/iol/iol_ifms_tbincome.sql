/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tbincome
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
create table ${iol_schema}.ifms_tbincome_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tbincome;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbincome_op purge;
drop table ${iol_schema}.ifms_tbincome_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tbincome_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbincome where 0=1;

create table ${iol_schema}.ifms_tbincome_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tbincome where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbincome_cl(
            cfm_date -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,seller_code -- 
            ,income -- 
            ,frozen_income -- 
            ,income_new -- 
            ,real_vol -- 
            ,frozen_vol -- 
            ,return_fee -- 
            ,return_fee_new -- 
            ,amt1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbincome_op(
            cfm_date -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,seller_code -- 
            ,income -- 
            ,frozen_income -- 
            ,income_new -- 
            ,real_vol -- 
            ,frozen_vol -- 
            ,return_fee -- 
            ,return_fee_new -- 
            ,amt1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cfm_date, o.cfm_date) as cfm_date -- 
    ,nvl(n.asset_acc, o.asset_acc) as asset_acc -- 
    ,nvl(n.ta_client, o.ta_client) as ta_client -- 
    ,nvl(n.prd_code, o.prd_code) as prd_code -- 
    ,nvl(n.share_class, o.share_class) as share_class -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.income, o.income) as income -- 
    ,nvl(n.frozen_income, o.frozen_income) as frozen_income -- 
    ,nvl(n.income_new, o.income_new) as income_new -- 
    ,nvl(n.real_vol, o.real_vol) as real_vol -- 
    ,nvl(n.frozen_vol, o.frozen_vol) as frozen_vol -- 
    ,nvl(n.return_fee, o.return_fee) as return_fee -- 
    ,nvl(n.return_fee_new, o.return_fee_new) as return_fee_new -- 
    ,nvl(n.amt1, o.amt1) as amt1 -- 
    ,case when
            n.cfm_date is null
            and n.asset_acc is null
            and n.ta_client is null
            and n.prd_code is null
            and n.share_class is null
            and n.seller_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cfm_date is null
            and n.asset_acc is null
            and n.ta_client is null
            and n.prd_code is null
            and n.share_class is null
            and n.seller_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cfm_date is null
            and n.asset_acc is null
            and n.ta_client is null
            and n.prd_code is null
            and n.share_class is null
            and n.seller_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tbincome_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tbincome where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cfm_date = n.cfm_date
            and o.asset_acc = n.asset_acc
            and o.ta_client = n.ta_client
            and o.prd_code = n.prd_code
            and o.share_class = n.share_class
            and o.seller_code = n.seller_code
where (
        o.cfm_date is null
        and o.asset_acc is null
        and o.ta_client is null
        and o.prd_code is null
        and o.share_class is null
        and o.seller_code is null
    )
    or (
        n.cfm_date is null
        and n.asset_acc is null
        and n.ta_client is null
        and n.prd_code is null
        and n.share_class is null
        and n.seller_code is null
    )
    or (
        o.income <> n.income
        or o.frozen_income <> n.frozen_income
        or o.income_new <> n.income_new
        or o.real_vol <> n.real_vol
        or o.frozen_vol <> n.frozen_vol
        or o.return_fee <> n.return_fee
        or o.return_fee_new <> n.return_fee_new
        or o.amt1 <> n.amt1
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tbincome_cl(
            cfm_date -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,seller_code -- 
            ,income -- 
            ,frozen_income -- 
            ,income_new -- 
            ,real_vol -- 
            ,frozen_vol -- 
            ,return_fee -- 
            ,return_fee_new -- 
            ,amt1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tbincome_op(
            cfm_date -- 
            ,asset_acc -- 
            ,ta_client -- 
            ,prd_code -- 
            ,share_class -- 
            ,seller_code -- 
            ,income -- 
            ,frozen_income -- 
            ,income_new -- 
            ,real_vol -- 
            ,frozen_vol -- 
            ,return_fee -- 
            ,return_fee_new -- 
            ,amt1 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cfm_date -- 
    ,o.asset_acc -- 
    ,o.ta_client -- 
    ,o.prd_code -- 
    ,o.share_class -- 
    ,o.seller_code -- 
    ,o.income -- 
    ,o.frozen_income -- 
    ,o.income_new -- 
    ,o.real_vol -- 
    ,o.frozen_vol -- 
    ,o.return_fee -- 
    ,o.return_fee_new -- 
    ,o.amt1 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tbincome_bk o
    left join ${iol_schema}.ifms_tbincome_op n
        on
            o.cfm_date = n.cfm_date
            and o.asset_acc = n.asset_acc
            and o.ta_client = n.ta_client
            and o.prd_code = n.prd_code
            and o.share_class = n.share_class
            and o.seller_code = n.seller_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tbincome_cl d
        on
            o.cfm_date = d.cfm_date
            and o.asset_acc = d.asset_acc
            and o.ta_client = d.ta_client
            and o.prd_code = d.prd_code
            and o.share_class = d.share_class
            and o.seller_code = d.seller_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tbincome;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tbincome exchange partition p_19000101 with table ${iol_schema}.ifms_tbincome_cl;
alter table ${iol_schema}.ifms_tbincome exchange partition p_20991231 with table ${iol_schema}.ifms_tbincome_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tbincome to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tbincome_op purge;
drop table ${iol_schema}.ifms_tbincome_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tbincome_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tbincome',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
