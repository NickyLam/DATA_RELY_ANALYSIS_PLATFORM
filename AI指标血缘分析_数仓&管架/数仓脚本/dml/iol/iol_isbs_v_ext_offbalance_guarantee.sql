/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_v_ext_offbalance_guarantee
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
create table ${iol_schema}.isbs_v_ext_offbalance_guarantee_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_v_ext_offbalance_guarantee;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_v_ext_offbalance_guarantee_op purge;
drop table ${iol_schema}.isbs_v_ext_offbalance_guarantee_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_v_ext_offbalance_guarantee_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_v_ext_offbalance_guarantee where 0=1;

create table ${iol_schema}.isbs_v_ext_offbalance_guarantee_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_v_ext_offbalance_guarantee where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_v_ext_offbalance_guarantee_cl(
            as_of_date -- 
            ,finish_type -- 
            ,gl_account_id -- 
            ,data_source -- 
            ,cif_key -- 
            ,iso_currency_cd -- 
            ,org_book_bal_latest -- 
            ,flag -- 
            ,cur_book_bal -- 
            ,org_book_bal -- 
            ,maturity_date -- 
            ,account_open_date -- 
            ,org_unit_id -- 
            ,account_number -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_v_ext_offbalance_guarantee_op(
            as_of_date -- 
            ,finish_type -- 
            ,gl_account_id -- 
            ,data_source -- 
            ,cif_key -- 
            ,iso_currency_cd -- 
            ,org_book_bal_latest -- 
            ,flag -- 
            ,cur_book_bal -- 
            ,org_book_bal -- 
            ,maturity_date -- 
            ,account_open_date -- 
            ,org_unit_id -- 
            ,account_number -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.as_of_date, o.as_of_date) as as_of_date -- 
    ,nvl(n.finish_type, o.finish_type) as finish_type -- 
    ,nvl(n.gl_account_id, o.gl_account_id) as gl_account_id -- 
    ,nvl(n.data_source, o.data_source) as data_source -- 
    ,nvl(n.cif_key, o.cif_key) as cif_key -- 
    ,nvl(n.iso_currency_cd, o.iso_currency_cd) as iso_currency_cd -- 
    ,nvl(n.org_book_bal_latest, o.org_book_bal_latest) as org_book_bal_latest -- 
    ,nvl(n.flag, o.flag) as flag -- 
    ,nvl(n.cur_book_bal, o.cur_book_bal) as cur_book_bal -- 
    ,nvl(n.org_book_bal, o.org_book_bal) as org_book_bal -- 
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 
    ,nvl(n.account_open_date, o.account_open_date) as account_open_date -- 
    ,nvl(n.org_unit_id, o.org_unit_id) as org_unit_id -- 
    ,nvl(n.account_number, o.account_number) as account_number -- 
    ,case when
            n.account_number is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.account_number is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.account_number is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_v_ext_offbalance_guarantee_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_v_ext_offbalance_guarantee where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.account_number = n.account_number
where (
        o.account_number is null
    )
    or (
        n.account_number is null
    )
    or (
        o.as_of_date <> n.as_of_date
        or o.finish_type <> n.finish_type
        or o.gl_account_id <> n.gl_account_id
        or o.data_source <> n.data_source
        or o.cif_key <> n.cif_key
        or o.iso_currency_cd <> n.iso_currency_cd
        or o.org_book_bal_latest <> n.org_book_bal_latest
        or o.flag <> n.flag
        or o.cur_book_bal <> n.cur_book_bal
        or o.org_book_bal <> n.org_book_bal
        or o.maturity_date <> n.maturity_date
        or o.account_open_date <> n.account_open_date
        or o.org_unit_id <> n.org_unit_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_v_ext_offbalance_guarantee_cl(
            as_of_date -- 
            ,finish_type -- 
            ,gl_account_id -- 
            ,data_source -- 
            ,cif_key -- 
            ,iso_currency_cd -- 
            ,org_book_bal_latest -- 
            ,flag -- 
            ,cur_book_bal -- 
            ,org_book_bal -- 
            ,maturity_date -- 
            ,account_open_date -- 
            ,org_unit_id -- 
            ,account_number -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_v_ext_offbalance_guarantee_op(
            as_of_date -- 
            ,finish_type -- 
            ,gl_account_id -- 
            ,data_source -- 
            ,cif_key -- 
            ,iso_currency_cd -- 
            ,org_book_bal_latest -- 
            ,flag -- 
            ,cur_book_bal -- 
            ,org_book_bal -- 
            ,maturity_date -- 
            ,account_open_date -- 
            ,org_unit_id -- 
            ,account_number -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.as_of_date -- 
    ,o.finish_type -- 
    ,o.gl_account_id -- 
    ,o.data_source -- 
    ,o.cif_key -- 
    ,o.iso_currency_cd -- 
    ,o.org_book_bal_latest -- 
    ,o.flag -- 
    ,o.cur_book_bal -- 
    ,o.org_book_bal -- 
    ,o.maturity_date -- 
    ,o.account_open_date -- 
    ,o.org_unit_id -- 
    ,o.account_number -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_v_ext_offbalance_guarantee_bk o
    left join ${iol_schema}.isbs_v_ext_offbalance_guarantee_op n
        on
            o.account_number = n.account_number
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_v_ext_offbalance_guarantee_cl d
        on
            o.account_number = d.account_number
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_v_ext_offbalance_guarantee;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_v_ext_offbalance_guarantee exchange partition p_19000101 with table ${iol_schema}.isbs_v_ext_offbalance_guarantee_cl;
alter table ${iol_schema}.isbs_v_ext_offbalance_guarantee exchange partition p_20991231 with table ${iol_schema}.isbs_v_ext_offbalance_guarantee_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_v_ext_offbalance_guarantee to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_v_ext_offbalance_guarantee_op purge;
drop table ${iol_schema}.isbs_v_ext_offbalance_guarantee_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_v_ext_offbalance_guarantee_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_v_ext_offbalance_guarantee',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
