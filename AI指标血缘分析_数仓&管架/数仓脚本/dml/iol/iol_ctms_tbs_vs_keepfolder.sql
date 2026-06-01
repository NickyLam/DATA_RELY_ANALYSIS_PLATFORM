/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_keepfolder
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
create table ${iol_schema}.ctms_tbs_vs_keepfolder_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_keepfolder;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_keepfolder_op purge;
drop table ${iol_schema}.ctms_tbs_vs_keepfolder_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_keepfolder_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_keepfolder where 0=1;

create table ${iol_schema}.ctms_tbs_vs_keepfolder_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_keepfolder where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_keepfolder_cl(
            keepfolder_id -- 账户ID
            ,aspclient_id -- 部门ID
            ,keepfolder_code -- 账户代码
            ,keepfolder_shortname -- 账户简称
            ,lastmodified -- 最后修改时间
            ,costmethod -- 核算方式
            ,calcdayenddate1 -- 收盘日
            ,calcdayenddate2 -- 交易日
            ,controlfactor -- 控制因素
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_keepfolder_op(
            keepfolder_id -- 账户ID
            ,aspclient_id -- 部门ID
            ,keepfolder_code -- 账户代码
            ,keepfolder_shortname -- 账户简称
            ,lastmodified -- 最后修改时间
            ,costmethod -- 核算方式
            ,calcdayenddate1 -- 收盘日
            ,calcdayenddate2 -- 交易日
            ,controlfactor -- 控制因素
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门ID
    ,nvl(n.keepfolder_code, o.keepfolder_code) as keepfolder_code -- 账户代码
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户简称
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.costmethod, o.costmethod) as costmethod -- 核算方式
    ,nvl(n.calcdayenddate1, o.calcdayenddate1) as calcdayenddate1 -- 收盘日
    ,nvl(n.calcdayenddate2, o.calcdayenddate2) as calcdayenddate2 -- 交易日
    ,nvl(n.controlfactor, o.controlfactor) as controlfactor -- 控制因素
    ,case when
            n.keepfolder_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.keepfolder_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.keepfolder_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_keepfolder_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_keepfolder where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.keepfolder_id = n.keepfolder_id
where (
        o.keepfolder_id is null
    )
    or (
        n.keepfolder_id is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.keepfolder_code <> n.keepfolder_code
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.lastmodified <> n.lastmodified
        or o.costmethod <> n.costmethod
        or o.calcdayenddate1 <> n.calcdayenddate1
        or o.calcdayenddate2 <> n.calcdayenddate2
        or o.controlfactor <> n.controlfactor
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_keepfolder_cl(
            keepfolder_id -- 账户ID
            ,aspclient_id -- 部门ID
            ,keepfolder_code -- 账户代码
            ,keepfolder_shortname -- 账户简称
            ,lastmodified -- 最后修改时间
            ,costmethod -- 核算方式
            ,calcdayenddate1 -- 收盘日
            ,calcdayenddate2 -- 交易日
            ,controlfactor -- 控制因素
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_keepfolder_op(
            keepfolder_id -- 账户ID
            ,aspclient_id -- 部门ID
            ,keepfolder_code -- 账户代码
            ,keepfolder_shortname -- 账户简称
            ,lastmodified -- 最后修改时间
            ,costmethod -- 核算方式
            ,calcdayenddate1 -- 收盘日
            ,calcdayenddate2 -- 交易日
            ,controlfactor -- 控制因素
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.keepfolder_id -- 账户ID
    ,o.aspclient_id -- 部门ID
    ,o.keepfolder_code -- 账户代码
    ,o.keepfolder_shortname -- 账户简称
    ,o.lastmodified -- 最后修改时间
    ,o.costmethod -- 核算方式
    ,o.calcdayenddate1 -- 收盘日
    ,o.calcdayenddate2 -- 交易日
    ,o.controlfactor -- 控制因素
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_keepfolder_bk o
    left join ${iol_schema}.ctms_tbs_vs_keepfolder_op n
        on
            o.keepfolder_id = n.keepfolder_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_keepfolder_cl d
        on
            o.keepfolder_id = d.keepfolder_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_vs_keepfolder;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_keepfolder exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_keepfolder_cl;
alter table ${iol_schema}.ctms_tbs_vs_keepfolder exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_keepfolder_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_keepfolder to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_keepfolder_op purge;
drop table ${iol_schema}.ctms_tbs_vs_keepfolder_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_keepfolder_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_keepfolder',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
