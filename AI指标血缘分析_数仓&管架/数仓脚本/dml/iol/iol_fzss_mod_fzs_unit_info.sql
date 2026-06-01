/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fzss_mod_fzs_unit_info
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
create table ${iol_schema}.fzss_mod_fzs_unit_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fzss_mod_fzs_unit_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_unit_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_unit_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fzss_mod_fzs_unit_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_unit_info where 0=1;

create table ${iol_schema}.fzss_mod_fzs_unit_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fzss_mod_fzs_unit_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_unit_info_cl(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,vbrno -- 虚拟机构号
            ,tellerno -- 柜员号
            ,open_brno -- 子账户开户机构号
            ,cache_status -- 缓存状态 [枚举: 1-初始态,2-失效态]
            ,data_version -- 数据版本
            ,data_cache_version -- 数据缓存版本
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_unit_info_op(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,vbrno -- 虚拟机构号
            ,tellerno -- 柜员号
            ,open_brno -- 子账户开户机构号
            ,cache_status -- 缓存状态 [枚举: 1-初始态,2-失效态]
            ,data_version -- 数据版本
            ,data_cache_version -- 数据缓存版本
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.corp_id, o.corp_id) as corp_id -- 平台商户号
    ,nvl(n.mybank, o.mybank) as mybank -- 法人标识代码
    ,nvl(n.zone_no, o.zone_no) as zone_no -- 分行号
    ,nvl(n.vbrno, o.vbrno) as vbrno -- 虚拟机构号
    ,nvl(n.tellerno, o.tellerno) as tellerno -- 柜员号
    ,nvl(n.open_brno, o.open_brno) as open_brno -- 子账户开户机构号
    ,nvl(n.cache_status, o.cache_status) as cache_status -- 缓存状态 [枚举: 1-初始态,2-失效态]
    ,nvl(n.data_version, o.data_version) as data_version -- 数据版本
    ,nvl(n.data_cache_version, o.data_cache_version) as data_cache_version -- 数据缓存版本
    ,nvl(n.create_timestamp, o.create_timestamp) as create_timestamp -- 创建时间戳
    ,nvl(n.update_timestamp, o.update_timestamp) as update_timestamp -- 更新时间戳
    ,case when
            n.corp_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.corp_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.corp_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fzss_mod_fzs_unit_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fzss_mod_fzs_unit_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.corp_id = n.corp_id
where (
        o.corp_id is null
    )
    or (
        n.corp_id is null
    )
    or (
        o.mybank <> n.mybank
        or o.zone_no <> n.zone_no
        or o.vbrno <> n.vbrno
        or o.tellerno <> n.tellerno
        or o.open_brno <> n.open_brno
        or o.cache_status <> n.cache_status
        or o.data_version <> n.data_version
        or o.data_cache_version <> n.data_cache_version
        or o.create_timestamp <> n.create_timestamp
        or o.update_timestamp <> n.update_timestamp
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fzss_mod_fzs_unit_info_cl(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,vbrno -- 虚拟机构号
            ,tellerno -- 柜员号
            ,open_brno -- 子账户开户机构号
            ,cache_status -- 缓存状态 [枚举: 1-初始态,2-失效态]
            ,data_version -- 数据版本
            ,data_cache_version -- 数据缓存版本
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fzss_mod_fzs_unit_info_op(
            corp_id -- 平台商户号
            ,mybank -- 法人标识代码
            ,zone_no -- 分行号
            ,vbrno -- 虚拟机构号
            ,tellerno -- 柜员号
            ,open_brno -- 子账户开户机构号
            ,cache_status -- 缓存状态 [枚举: 1-初始态,2-失效态]
            ,data_version -- 数据版本
            ,data_cache_version -- 数据缓存版本
            ,create_timestamp -- 创建时间戳
            ,update_timestamp -- 更新时间戳
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.corp_id -- 平台商户号
    ,o.mybank -- 法人标识代码
    ,o.zone_no -- 分行号
    ,o.vbrno -- 虚拟机构号
    ,o.tellerno -- 柜员号
    ,o.open_brno -- 子账户开户机构号
    ,o.cache_status -- 缓存状态 [枚举: 1-初始态,2-失效态]
    ,o.data_version -- 数据版本
    ,o.data_cache_version -- 数据缓存版本
    ,o.create_timestamp -- 创建时间戳
    ,o.update_timestamp -- 更新时间戳
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
from ${iol_schema}.fzss_mod_fzs_unit_info_bk o
    left join ${iol_schema}.fzss_mod_fzs_unit_info_op n
        on
            o.corp_id = n.corp_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fzss_mod_fzs_unit_info_cl d
        on
            o.corp_id = d.corp_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fzss_mod_fzs_unit_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fzss_mod_fzs_unit_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fzss_mod_fzs_unit_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fzss_mod_fzs_unit_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fzss_mod_fzs_unit_info exchange partition p_${batch_date} with table ${iol_schema}.fzss_mod_fzs_unit_info_cl;
alter table ${iol_schema}.fzss_mod_fzs_unit_info exchange partition p_20991231 with table ${iol_schema}.fzss_mod_fzs_unit_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fzss_mod_fzs_unit_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fzss_mod_fzs_unit_info_op purge;
drop table ${iol_schema}.fzss_mod_fzs_unit_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fzss_mod_fzs_unit_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fzss_mod_fzs_unit_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
