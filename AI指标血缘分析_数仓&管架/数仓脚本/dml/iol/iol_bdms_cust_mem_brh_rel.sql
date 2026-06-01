/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdms_cust_mem_brh_rel
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
create table ${iol_schema}.bdms_cust_mem_brh_rel_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdms_cust_mem_brh_rel;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cust_mem_brh_rel_op purge;
drop table ${iol_schema}.bdms_cust_mem_brh_rel_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdms_cust_mem_brh_rel_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cust_mem_brh_rel where 0=1;

create table ${iol_schema}.bdms_cust_mem_brh_rel_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdms_cust_mem_brh_rel where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cust_mem_brh_rel_cl(
            id -- id
            ,cust_id -- 客户信息id
            ,brh_no -- 会员机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cust_mem_brh_rel_op(
            id -- id
            ,cust_id -- 客户信息id
            ,brh_no -- 会员机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- id
    ,nvl(n.cust_id, o.cust_id) as cust_id -- 客户信息id
    ,nvl(n.brh_no, o.brh_no) as brh_no -- 会员机构编号
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
from (select * from ${iol_schema}.bdms_cust_mem_brh_rel_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdms_cust_mem_brh_rel where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.cust_id <> n.cust_id
        or o.brh_no <> n.brh_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdms_cust_mem_brh_rel_cl(
            id -- id
            ,cust_id -- 客户信息id
            ,brh_no -- 会员机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdms_cust_mem_brh_rel_op(
            id -- id
            ,cust_id -- 客户信息id
            ,brh_no -- 会员机构编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- id
    ,o.cust_id -- 客户信息id
    ,o.brh_no -- 会员机构编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdms_cust_mem_brh_rel_bk o
    left join ${iol_schema}.bdms_cust_mem_brh_rel_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdms_cust_mem_brh_rel_cl d
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
-- truncate table ${iol_schema}.bdms_cust_mem_brh_rel;

-- 4.2 exchange partition
alter table ${iol_schema}.bdms_cust_mem_brh_rel exchange partition p_19000101 with table ${iol_schema}.bdms_cust_mem_brh_rel_cl;
alter table ${iol_schema}.bdms_cust_mem_brh_rel exchange partition p_20991231 with table ${iol_schema}.bdms_cust_mem_brh_rel_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdms_cust_mem_brh_rel to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdms_cust_mem_brh_rel_op purge;
drop table ${iol_schema}.bdms_cust_mem_brh_rel_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdms_cust_mem_brh_rel_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdms_cust_mem_brh_rel',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
