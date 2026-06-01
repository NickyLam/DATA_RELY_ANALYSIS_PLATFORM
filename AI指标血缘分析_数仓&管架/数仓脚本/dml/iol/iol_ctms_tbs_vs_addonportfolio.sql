/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_addonportfolio
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
create table ${iol_schema}.ctms_tbs_vs_addonportfolio_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_addonportfolio;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_addonportfolio_op purge;
drop table ${iol_schema}.ctms_tbs_vs_addonportfolio_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_addonportfolio_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_addonportfolio where 0=1;

create table ${iol_schema}.ctms_tbs_vs_addonportfolio_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_addonportfolio where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_addonportfolio_cl(
            addonportfolio_id -- 从属投资组合ID
            ,aspclient_id -- 部门ID
            ,owner_number -- 拥有者ID
            ,owner_code -- 拥有者代码
            ,owner_name -- 拥有者名称
            ,portfolio_id -- 投组ID
            ,portfolioname -- 投组名称
            ,keepfolder_id_default -- 默认账户ID
            ,assettype_id_default -- 默认资产类型ID
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源应用设置ID
            ,buztype_id_default -- 业务类型ID
            ,status -- 状态
            ,nstd_id_default -- 非标资产类别
            ,pntt_type -- 
            ,asset_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_addonportfolio_op(
            addonportfolio_id -- 从属投资组合ID
            ,aspclient_id -- 部门ID
            ,owner_number -- 拥有者ID
            ,owner_code -- 拥有者代码
            ,owner_name -- 拥有者名称
            ,portfolio_id -- 投组ID
            ,portfolioname -- 投组名称
            ,keepfolder_id_default -- 默认账户ID
            ,assettype_id_default -- 默认资产类型ID
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源应用设置ID
            ,buztype_id_default -- 业务类型ID
            ,status -- 状态
            ,nstd_id_default -- 非标资产类别
            ,pntt_type -- 
            ,asset_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.addonportfolio_id, o.addonportfolio_id) as addonportfolio_id -- 从属投资组合ID
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门ID
    ,nvl(n.owner_number, o.owner_number) as owner_number -- 拥有者ID
    ,nvl(n.owner_code, o.owner_code) as owner_code -- 拥有者代码
    ,nvl(n.owner_name, o.owner_name) as owner_name -- 拥有者名称
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 投组ID
    ,nvl(n.portfolioname, o.portfolioname) as portfolioname -- 投组名称
    ,nvl(n.keepfolder_id_default, o.keepfolder_id_default) as keepfolder_id_default -- 默认账户ID
    ,nvl(n.assettype_id_default, o.assettype_id_default) as assettype_id_default -- 默认资产类型ID
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 数据源应用设置ID
    ,nvl(n.buztype_id_default, o.buztype_id_default) as buztype_id_default -- 业务类型ID
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.nstd_id_default, o.nstd_id_default) as nstd_id_default -- 非标资产类别
    ,nvl(n.pntt_type, o.pntt_type) as pntt_type -- 
    ,nvl(n.asset_code, o.asset_code) as asset_code -- 
    ,case when
            n.addonportfolio_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.addonportfolio_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.addonportfolio_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_addonportfolio_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_addonportfolio where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.addonportfolio_id = n.addonportfolio_id
where (
        o.addonportfolio_id is null
    )
    or (
        n.addonportfolio_id is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.owner_number <> n.owner_number
        or o.owner_code <> n.owner_code
        or o.owner_name <> n.owner_name
        or o.portfolio_id <> n.portfolio_id
        or o.portfolioname <> n.portfolioname
        or o.keepfolder_id_default <> n.keepfolder_id_default
        or o.assettype_id_default <> n.assettype_id_default
        or o.lastmodified <> n.lastmodified
        or o.datasymbol_id <> n.datasymbol_id
        or o.buztype_id_default <> n.buztype_id_default
        or o.status <> n.status
        or o.nstd_id_default <> n.nstd_id_default
        or o.pntt_type <> n.pntt_type
        or o.asset_code <> n.asset_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_addonportfolio_cl(
            addonportfolio_id -- 从属投资组合ID
            ,aspclient_id -- 部门ID
            ,owner_number -- 拥有者ID
            ,owner_code -- 拥有者代码
            ,owner_name -- 拥有者名称
            ,portfolio_id -- 投组ID
            ,portfolioname -- 投组名称
            ,keepfolder_id_default -- 默认账户ID
            ,assettype_id_default -- 默认资产类型ID
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源应用设置ID
            ,buztype_id_default -- 业务类型ID
            ,status -- 状态
            ,nstd_id_default -- 非标资产类别
            ,pntt_type -- 
            ,asset_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_addonportfolio_op(
            addonportfolio_id -- 从属投资组合ID
            ,aspclient_id -- 部门ID
            ,owner_number -- 拥有者ID
            ,owner_code -- 拥有者代码
            ,owner_name -- 拥有者名称
            ,portfolio_id -- 投组ID
            ,portfolioname -- 投组名称
            ,keepfolder_id_default -- 默认账户ID
            ,assettype_id_default -- 默认资产类型ID
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源应用设置ID
            ,buztype_id_default -- 业务类型ID
            ,status -- 状态
            ,nstd_id_default -- 非标资产类别
            ,pntt_type -- 
            ,asset_code -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.addonportfolio_id -- 从属投资组合ID
    ,o.aspclient_id -- 部门ID
    ,o.owner_number -- 拥有者ID
    ,o.owner_code -- 拥有者代码
    ,o.owner_name -- 拥有者名称
    ,o.portfolio_id -- 投组ID
    ,o.portfolioname -- 投组名称
    ,o.keepfolder_id_default -- 默认账户ID
    ,o.assettype_id_default -- 默认资产类型ID
    ,o.lastmodified -- 最后修改时间
    ,o.datasymbol_id -- 数据源应用设置ID
    ,o.buztype_id_default -- 业务类型ID
    ,o.status -- 状态
    ,o.nstd_id_default -- 非标资产类别
    ,o.pntt_type -- 
    ,o.asset_code -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_addonportfolio_bk o
    left join ${iol_schema}.ctms_tbs_vs_addonportfolio_op n
        on
            o.addonportfolio_id = n.addonportfolio_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_addonportfolio_cl d
        on
            o.addonportfolio_id = d.addonportfolio_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_vs_addonportfolio;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_addonportfolio exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_addonportfolio_cl;
alter table ${iol_schema}.ctms_tbs_vs_addonportfolio exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_addonportfolio_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_addonportfolio to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_addonportfolio_op purge;
drop table ${iol_schema}.ctms_tbs_vs_addonportfolio_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_addonportfolio_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_addonportfolio',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
