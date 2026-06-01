/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_tbclientseller
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
create table ${iol_schema}.nfss_tbclientseller_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_tbclientseller;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbclientseller_op purge;
drop table ${iol_schema}.nfss_tbclientseller_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_tbclientseller_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbclientseller where 0=1;

create table ${iol_schema}.nfss_tbclientseller_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_tbclientseller where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbclientseller_cl(
            in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,seller_code -- 
            ,open_date -- 
            ,close_date -- 
            ,ta_client -- 
            ,status -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbclientseller_op(
            in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,seller_code -- 
            ,open_date -- 
            ,close_date -- 
            ,ta_client -- 
            ,status -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.bank_no, o.bank_no) as bank_no -- 
    ,nvl(n.client_no, o.client_no) as client_no -- 
    ,nvl(n.seller_code, o.seller_code) as seller_code -- 
    ,nvl(n.open_date, o.open_date) as open_date -- 
    ,nvl(n.close_date, o.close_date) as close_date -- 
    ,nvl(n.ta_client, o.ta_client) as ta_client -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,case when
            n.bank_no is null
            and n.client_no is null
            and n.seller_code is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bank_no is null
            and n.client_no is null
            and n.seller_code is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bank_no is null
            and n.client_no is null
            and n.seller_code is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_tbclientseller_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_tbclientseller where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bank_no = n.bank_no
            and o.client_no = n.client_no
            and o.seller_code = n.seller_code
where (
        o.bank_no is null
        and o.client_no is null
        and o.seller_code is null
    )
    or (
        n.bank_no is null
        and n.client_no is null
        and n.seller_code is null
    )
    or (
        o.in_client_no <> n.in_client_no
        or o.open_date <> n.open_date
        or o.close_date <> n.close_date
        or o.ta_client <> n.ta_client
        or o.status <> n.status
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_tbclientseller_cl(
            in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,seller_code -- 
            ,open_date -- 
            ,close_date -- 
            ,ta_client -- 
            ,status -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_tbclientseller_op(
            in_client_no -- 
            ,bank_no -- 
            ,client_no -- 
            ,seller_code -- 
            ,open_date -- 
            ,close_date -- 
            ,ta_client -- 
            ,status -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 
    ,o.bank_no -- 
    ,o.client_no -- 
    ,o.seller_code -- 
    ,o.open_date -- 
    ,o.close_date -- 
    ,o.ta_client -- 
    ,o.status -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_tbclientseller_bk o
    left join ${iol_schema}.nfss_tbclientseller_op n
        on
            o.bank_no = n.bank_no
            and o.client_no = n.client_no
            and o.seller_code = n.seller_code
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_tbclientseller_cl d
        on
            o.bank_no = d.bank_no
            and o.client_no = d.client_no
            and o.seller_code = d.seller_code
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.nfss_tbclientseller;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_tbclientseller exchange partition p_19000101 with table ${iol_schema}.nfss_tbclientseller_cl;
alter table ${iol_schema}.nfss_tbclientseller exchange partition p_20991231 with table ${iol_schema}.nfss_tbclientseller_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_tbclientseller to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_tbclientseller_op purge;
drop table ${iol_schema}.nfss_tbclientseller_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_tbclientseller_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_tbclientseller',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
