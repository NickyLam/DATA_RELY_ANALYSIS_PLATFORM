/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_noas_oa_stock_finance
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
create table ${iol_schema}.noas_oa_stock_finance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.noas_oa_stock_finance
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_stock_finance_op purge;
drop table ${iol_schema}.noas_oa_stock_finance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.noas_oa_stock_finance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_stock_finance where 0=1;

create table ${iol_schema}.noas_oa_stock_finance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.noas_oa_stock_finance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_stock_finance_cl(
            stock_finance_id -- 
            ,stock_info_id -- 
            ,a_particular_year -- 
            ,total_assets -- 
            ,gross_liability -- 
            ,net_asset -- 
            ,retained_profits -- 
            ,ratio_of_liabilities -- 
            ,balance_investment -- 
            ,balance_net_asset_ratio -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_stock_finance_op(
            stock_finance_id -- 
            ,stock_info_id -- 
            ,a_particular_year -- 
            ,total_assets -- 
            ,gross_liability -- 
            ,net_asset -- 
            ,retained_profits -- 
            ,ratio_of_liabilities -- 
            ,balance_investment -- 
            ,balance_net_asset_ratio -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.stock_finance_id, o.stock_finance_id) as stock_finance_id -- 
    ,nvl(n.stock_info_id, o.stock_info_id) as stock_info_id -- 
    ,nvl(n.a_particular_year, o.a_particular_year) as a_particular_year -- 
    ,nvl(n.total_assets, o.total_assets) as total_assets -- 
    ,nvl(n.gross_liability, o.gross_liability) as gross_liability -- 
    ,nvl(n.net_asset, o.net_asset) as net_asset -- 
    ,nvl(n.retained_profits, o.retained_profits) as retained_profits -- 
    ,nvl(n.ratio_of_liabilities, o.ratio_of_liabilities) as ratio_of_liabilities -- 
    ,nvl(n.balance_investment, o.balance_investment) as balance_investment -- 
    ,nvl(n.balance_net_asset_ratio, o.balance_net_asset_ratio) as balance_net_asset_ratio -- 
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 
    ,case when
            n.stock_finance_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.stock_finance_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.stock_finance_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.noas_oa_stock_finance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.noas_oa_stock_finance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.stock_finance_id = n.stock_finance_id
where (
        o.stock_finance_id is null
    )
    or (
        n.stock_finance_id is null
    )
    or (
        o.stock_info_id <> n.stock_info_id
        or o.a_particular_year <> n.a_particular_year
        or o.total_assets <> n.total_assets
        or o.gross_liability <> n.gross_liability
        or o.net_asset <> n.net_asset
        or o.retained_profits <> n.retained_profits
        or o.ratio_of_liabilities <> n.ratio_of_liabilities
        or o.balance_investment <> n.balance_investment
        or o.balance_net_asset_ratio <> n.balance_net_asset_ratio
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.noas_oa_stock_finance_cl(
            stock_finance_id -- 
            ,stock_info_id -- 
            ,a_particular_year -- 
            ,total_assets -- 
            ,gross_liability -- 
            ,net_asset -- 
            ,retained_profits -- 
            ,ratio_of_liabilities -- 
            ,balance_investment -- 
            ,balance_net_asset_ratio -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.noas_oa_stock_finance_op(
            stock_finance_id -- 
            ,stock_info_id -- 
            ,a_particular_year -- 
            ,total_assets -- 
            ,gross_liability -- 
            ,net_asset -- 
            ,retained_profits -- 
            ,ratio_of_liabilities -- 
            ,balance_investment -- 
            ,balance_net_asset_ratio -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.stock_finance_id -- 
    ,o.stock_info_id -- 
    ,o.a_particular_year -- 
    ,o.total_assets -- 
    ,o.gross_liability -- 
    ,o.net_asset -- 
    ,o.retained_profits -- 
    ,o.ratio_of_liabilities -- 
    ,o.balance_investment -- 
    ,o.balance_net_asset_ratio -- 
    ,o.last_updated_stamp -- 
    ,o.last_updated_tx_stamp -- 
    ,o.created_stamp -- 
    ,o.created_tx_stamp -- 
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
from ${iol_schema}.noas_oa_stock_finance_bk o
    left join ${iol_schema}.noas_oa_stock_finance_op n
        on
            o.stock_finance_id = n.stock_finance_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.noas_oa_stock_finance_cl d
        on
            o.stock_finance_id = d.stock_finance_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.noas_oa_stock_finance;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('noas_oa_stock_finance') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.noas_oa_stock_finance drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.noas_oa_stock_finance add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.noas_oa_stock_finance exchange partition p_${batch_date} with table ${iol_schema}.noas_oa_stock_finance_cl;
alter table ${iol_schema}.noas_oa_stock_finance exchange partition p_20991231 with table ${iol_schema}.noas_oa_stock_finance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.noas_oa_stock_finance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.noas_oa_stock_finance_op purge;
drop table ${iol_schema}.noas_oa_stock_finance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.noas_oa_stock_finance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'noas_oa_stock_finance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
