/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_issuer
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
create table ${iol_schema}.ctms_tbs_vs_issuer_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_issuer;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_issuer_op purge;
drop table ${iol_schema}.ctms_tbs_vs_issuer_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_issuer_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_issuer where 0=1;

create table ${iol_schema}.ctms_tbs_vs_issuer_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_issuer where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_issuer_cl(
            issuer_id -- 发行人ID
            ,status -- 状态
            ,issuer_name_zh -- 中文名称
            ,issuer_name_en -- 英文名称
            ,modify_date -- 修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_issuer_op(
            issuer_id -- 发行人ID
            ,status -- 状态
            ,issuer_name_zh -- 中文名称
            ,issuer_name_en -- 英文名称
            ,modify_date -- 修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.issuer_id, o.issuer_id) as issuer_id -- 发行人ID
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.issuer_name_zh, o.issuer_name_zh) as issuer_name_zh -- 中文名称
    ,nvl(n.issuer_name_en, o.issuer_name_en) as issuer_name_en -- 英文名称
    ,nvl(n.modify_date, o.modify_date) as modify_date -- 修改日期
    ,case when
            n.issuer_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.issuer_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.issuer_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_issuer_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_issuer where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.issuer_id = n.issuer_id
where (
        o.issuer_id is null
    )
    or (
        n.issuer_id is null
    )
    or (
        o.status <> n.status
        or o.issuer_name_zh <> n.issuer_name_zh
        or o.issuer_name_en <> n.issuer_name_en
        or o.modify_date <> n.modify_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_issuer_cl(
            issuer_id -- 发行人ID
            ,status -- 状态
            ,issuer_name_zh -- 中文名称
            ,issuer_name_en -- 英文名称
            ,modify_date -- 修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_issuer_op(
            issuer_id -- 发行人ID
            ,status -- 状态
            ,issuer_name_zh -- 中文名称
            ,issuer_name_en -- 英文名称
            ,modify_date -- 修改日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.issuer_id -- 发行人ID
    ,o.status -- 状态
    ,o.issuer_name_zh -- 中文名称
    ,o.issuer_name_en -- 英文名称
    ,o.modify_date -- 修改日期
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_issuer_bk o
    left join ${iol_schema}.ctms_tbs_vs_issuer_op n
        on
            o.issuer_id = n.issuer_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_issuer_cl d
        on
            o.issuer_id = d.issuer_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_vs_issuer;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_issuer exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_issuer_cl;
alter table ${iol_schema}.ctms_tbs_vs_issuer exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_issuer_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_issuer to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_issuer_op purge;
drop table ${iol_schema}.ctms_tbs_vs_issuer_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_issuer_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_issuer',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
