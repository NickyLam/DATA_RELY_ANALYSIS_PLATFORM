/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_cpt
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
create table ${iol_schema}.isbs_cpt_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_cpt;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cpt_op purge;
drop table ${iol_schema}.isbs_cpt_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cpt_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cpt where 0=1;

create table ${iol_schema}.isbs_cpt_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cpt where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cpt_cl(
            inr -- 唯一ID
            ,fldmodblk -- 模块下修正过的字段
            ,narhis -- 历史附言
            ,contag72 -- 附言
            ,contag79 -- 79域
            ,contag70 -- 付款详情
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cpt_op(
            inr -- 唯一ID
            ,fldmodblk -- 模块下修正过的字段
            ,narhis -- 历史附言
            ,contag72 -- 附言
            ,contag79 -- 79域
            ,contag70 -- 付款详情
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 唯一ID
    ,nvl(n.fldmodblk, o.fldmodblk) as fldmodblk -- 模块下修正过的字段
    ,nvl(n.narhis, o.narhis) as narhis -- 历史附言
    ,nvl(n.contag72, o.contag72) as contag72 -- 附言
    ,nvl(n.contag79, o.contag79) as contag79 -- 79域
    ,nvl(n.contag70, o.contag70) as contag70 -- 付款详情
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_cpt_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_cpt where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.fldmodblk <> n.fldmodblk
        or o.narhis <> n.narhis
        or o.contag72 <> n.contag72
        or o.contag79 <> n.contag79
        or o.contag70 <> n.contag70
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cpt_cl(
            inr -- 唯一ID
            ,fldmodblk -- 模块下修正过的字段
            ,narhis -- 历史附言
            ,contag72 -- 附言
            ,contag79 -- 79域
            ,contag70 -- 付款详情
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cpt_op(
            inr -- 唯一ID
            ,fldmodblk -- 模块下修正过的字段
            ,narhis -- 历史附言
            ,contag72 -- 附言
            ,contag79 -- 79域
            ,contag70 -- 付款详情
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 唯一ID
    ,o.fldmodblk -- 模块下修正过的字段
    ,o.narhis -- 历史附言
    ,o.contag72 -- 附言
    ,o.contag79 -- 79域
    ,o.contag70 -- 付款详情
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_cpt_bk o
    left join ${iol_schema}.isbs_cpt_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_cpt_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_cpt;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_cpt exchange partition p_19000101 with table ${iol_schema}.isbs_cpt_cl;
alter table ${iol_schema}.isbs_cpt exchange partition p_20991231 with table ${iol_schema}.isbs_cpt_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_cpt to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cpt_op purge;
drop table ${iol_schema}.isbs_cpt_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_cpt_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_cpt',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
