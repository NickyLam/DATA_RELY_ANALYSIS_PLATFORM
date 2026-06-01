/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_assetpackageinfo
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
create table ${iol_schema}.mims_si_assetpackageinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_assetpackageinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_assetpackageinfo_op purge;
drop table ${iol_schema}.mims_si_assetpackageinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_assetpackageinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_assetpackageinfo where 0=1;

create table ${iol_schema}.mims_si_assetpackageinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_assetpackageinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_assetpackageinfo_cl(
            sertalno -- 资产包编号
            ,apname -- 资产包名称
            ,status -- 资产包状态
            ,transdate -- 转让日
            ,updatedate -- 更新时间
            ,filereadflag -- 是否已读取文件 0-未读取 1-读取
            ,flag -- 资产包是否有效 0-无效 1-有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_assetpackageinfo_op(
            sertalno -- 资产包编号
            ,apname -- 资产包名称
            ,status -- 资产包状态
            ,transdate -- 转让日
            ,updatedate -- 更新时间
            ,filereadflag -- 是否已读取文件 0-未读取 1-读取
            ,flag -- 资产包是否有效 0-无效 1-有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sertalno, o.sertalno) as sertalno -- 资产包编号
    ,nvl(n.apname, o.apname) as apname -- 资产包名称
    ,nvl(n.status, o.status) as status -- 资产包状态
    ,nvl(n.transdate, o.transdate) as transdate -- 转让日
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新时间
    ,nvl(n.filereadflag, o.filereadflag) as filereadflag -- 是否已读取文件 0-未读取 1-读取
    ,nvl(n.flag, o.flag) as flag -- 资产包是否有效 0-无效 1-有效
    ,case when
            n.sertalno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sertalno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sertalno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_assetpackageinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_assetpackageinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sertalno = n.sertalno
where (
        o.sertalno is null
    )
    or (
        n.sertalno is null
    )
    or (
        o.apname <> n.apname
        or o.status <> n.status
        or o.transdate <> n.transdate
        or o.updatedate <> n.updatedate
        or o.filereadflag <> n.filereadflag
        or o.flag <> n.flag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_assetpackageinfo_cl(
            sertalno -- 资产包编号
            ,apname -- 资产包名称
            ,status -- 资产包状态
            ,transdate -- 转让日
            ,updatedate -- 更新时间
            ,filereadflag -- 是否已读取文件 0-未读取 1-读取
            ,flag -- 资产包是否有效 0-无效 1-有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_assetpackageinfo_op(
            sertalno -- 资产包编号
            ,apname -- 资产包名称
            ,status -- 资产包状态
            ,transdate -- 转让日
            ,updatedate -- 更新时间
            ,filereadflag -- 是否已读取文件 0-未读取 1-读取
            ,flag -- 资产包是否有效 0-无效 1-有效
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sertalno -- 资产包编号
    ,o.apname -- 资产包名称
    ,o.status -- 资产包状态
    ,o.transdate -- 转让日
    ,o.updatedate -- 更新时间
    ,o.filereadflag -- 是否已读取文件 0-未读取 1-读取
    ,o.flag -- 资产包是否有效 0-无效 1-有效
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mims_si_assetpackageinfo_bk o
    left join ${iol_schema}.mims_si_assetpackageinfo_op n
        on
            o.sertalno = n.sertalno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_assetpackageinfo_cl d
        on
            o.sertalno = d.sertalno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mims_si_assetpackageinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mims_si_assetpackageinfo exchange partition p_19000101 with table ${iol_schema}.mims_si_assetpackageinfo_cl;
alter table ${iol_schema}.mims_si_assetpackageinfo exchange partition p_20991231 with table ${iol_schema}.mims_si_assetpackageinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_assetpackageinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_assetpackageinfo_op purge;
drop table ${iol_schema}.mims_si_assetpackageinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_assetpackageinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_assetpackageinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
