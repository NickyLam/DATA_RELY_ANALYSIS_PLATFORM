/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_rpss_relatedparty
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
create table ${iol_schema}.rpss_relatedparty_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.rpss_relatedparty;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rpss_relatedparty_op purge;
drop table ${iol_schema}.rpss_relatedparty_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.rpss_relatedparty_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rpss_relatedparty where 0=1;

create table ${iol_schema}.rpss_relatedparty_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.rpss_relatedparty where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rpss_relatedparty_cl(
            related_id -- 
            ,ywlx -- 
            ,status_id -- 
            ,registrant -- 
            ,registration_org -- 
            ,registration_date -- 
            ,last_modified_date -- 
            ,last_modified_by_user_login -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,approval_date -- 
            ,approval_person -- 
            ,reject_reason -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rpss_relatedparty_op(
            related_id -- 
            ,ywlx -- 
            ,status_id -- 
            ,registrant -- 
            ,registration_org -- 
            ,registration_date -- 
            ,last_modified_date -- 
            ,last_modified_by_user_login -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,approval_date -- 
            ,approval_person -- 
            ,reject_reason -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.related_id, o.related_id) as related_id -- 
    ,nvl(n.ywlx, o.ywlx) as ywlx -- 
    ,nvl(n.status_id, o.status_id) as status_id -- 
    ,nvl(n.registrant, o.registrant) as registrant -- 
    ,nvl(n.registration_org, o.registration_org) as registration_org -- 
    ,nvl(n.registration_date, o.registration_date) as registration_date -- 
    ,nvl(n.last_modified_date, o.last_modified_date) as last_modified_date -- 
    ,nvl(n.last_modified_by_user_login, o.last_modified_by_user_login) as last_modified_by_user_login -- 
    ,nvl(n.last_updated_stamp, o.last_updated_stamp) as last_updated_stamp -- 
    ,nvl(n.last_updated_tx_stamp, o.last_updated_tx_stamp) as last_updated_tx_stamp -- 
    ,nvl(n.created_stamp, o.created_stamp) as created_stamp -- 
    ,nvl(n.created_tx_stamp, o.created_tx_stamp) as created_tx_stamp -- 
    ,nvl(n.approval_date, o.approval_date) as approval_date -- 
    ,nvl(n.approval_person, o.approval_person) as approval_person -- 
    ,nvl(n.reject_reason, o.reject_reason) as reject_reason -- 
    ,case when
            n.related_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.related_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.related_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.rpss_relatedparty_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.rpss_relatedparty where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.related_id = n.related_id
where (
        o.related_id is null
    )
    or (
        n.related_id is null
    )
    or (
        o.ywlx <> n.ywlx
        or o.status_id <> n.status_id
        or o.registrant <> n.registrant
        or o.registration_org <> n.registration_org
        or o.registration_date <> n.registration_date
        or o.last_modified_date <> n.last_modified_date
        or o.last_modified_by_user_login <> n.last_modified_by_user_login
        or o.last_updated_stamp <> n.last_updated_stamp
        or o.last_updated_tx_stamp <> n.last_updated_tx_stamp
        or o.created_stamp <> n.created_stamp
        or o.created_tx_stamp <> n.created_tx_stamp
        or o.approval_date <> n.approval_date
        or o.approval_person <> n.approval_person
        or o.reject_reason <> n.reject_reason
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.rpss_relatedparty_cl(
            related_id -- 
            ,ywlx -- 
            ,status_id -- 
            ,registrant -- 
            ,registration_org -- 
            ,registration_date -- 
            ,last_modified_date -- 
            ,last_modified_by_user_login -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,approval_date -- 
            ,approval_person -- 
            ,reject_reason -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.rpss_relatedparty_op(
            related_id -- 
            ,ywlx -- 
            ,status_id -- 
            ,registrant -- 
            ,registration_org -- 
            ,registration_date -- 
            ,last_modified_date -- 
            ,last_modified_by_user_login -- 
            ,last_updated_stamp -- 
            ,last_updated_tx_stamp -- 
            ,created_stamp -- 
            ,created_tx_stamp -- 
            ,approval_date -- 
            ,approval_person -- 
            ,reject_reason -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.related_id -- 
    ,o.ywlx -- 
    ,o.status_id -- 
    ,o.registrant -- 
    ,o.registration_org -- 
    ,o.registration_date -- 
    ,o.last_modified_date -- 
    ,o.last_modified_by_user_login -- 
    ,o.last_updated_stamp -- 
    ,o.last_updated_tx_stamp -- 
    ,o.created_stamp -- 
    ,o.created_tx_stamp -- 
    ,o.approval_date -- 
    ,o.approval_person -- 
    ,o.reject_reason -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.rpss_relatedparty_bk o
    left join ${iol_schema}.rpss_relatedparty_op n
        on
            o.related_id = n.related_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.rpss_relatedparty_cl d
        on
            o.related_id = d.related_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.rpss_relatedparty;

-- 4.2 exchange partition
alter table ${iol_schema}.rpss_relatedparty exchange partition p_19000101 with table ${iol_schema}.rpss_relatedparty_cl;
alter table ${iol_schema}.rpss_relatedparty exchange partition p_20991231 with table ${iol_schema}.rpss_relatedparty_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.rpss_relatedparty to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.rpss_relatedparty_op purge;
drop table ${iol_schema}.rpss_relatedparty_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.rpss_relatedparty_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'rpss_relatedparty',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
