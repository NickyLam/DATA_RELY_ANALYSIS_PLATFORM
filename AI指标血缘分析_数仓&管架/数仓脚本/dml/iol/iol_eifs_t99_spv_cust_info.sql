/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_eifs_t99_spv_cust_info
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
create table ${iol_schema}.eifs_t99_spv_cust_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.eifs_t99_spv_cust_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t99_spv_cust_info_op purge;
drop table ${iol_schema}.eifs_t99_spv_cust_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.eifs_t99_spv_cust_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t99_spv_cust_info where 0=1;

create table ${iol_schema}.eifs_t99_spv_cust_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.eifs_t99_spv_cust_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t99_spv_cust_info_cl(
            cust_num -- spv客户号
            ,org_cust_num -- 主机构客户号
            ,cust_name -- spv名称
            ,spv_ytpe -- spv类型
            ,prod_stat_cd -- 资管产品统计编码
            ,spv_cd -- spv代码
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,is_cash_magm -- 是否现金管理类理财
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t99_spv_cust_info_op(
            cust_num -- spv客户号
            ,org_cust_num -- 主机构客户号
            ,cust_name -- spv名称
            ,spv_ytpe -- spv类型
            ,prod_stat_cd -- 资管产品统计编码
            ,spv_cd -- spv代码
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,is_cash_magm -- 是否现金管理类理财
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.cust_num, o.cust_num) as cust_num -- spv客户号
    ,nvl(n.org_cust_num, o.org_cust_num) as org_cust_num -- 主机构客户号
    ,nvl(n.cust_name, o.cust_name) as cust_name -- spv名称
    ,nvl(n.spv_ytpe, o.spv_ytpe) as spv_ytpe -- spv类型
    ,nvl(n.prod_stat_cd, o.prod_stat_cd) as prod_stat_cd -- 资管产品统计编码
    ,nvl(n.spv_cd, o.spv_cd) as spv_cd -- spv代码
    ,nvl(n.create_te, o.create_te) as create_te -- 创建柜员
    ,nvl(n.create_org, o.create_org) as create_org -- 创建机构号
    ,nvl(n.init_system_id, o.init_system_id) as init_system_id -- 创建渠道
    ,nvl(n.init_created_ts, o.init_created_ts) as init_created_ts -- 源系统创建时间
    ,nvl(n.created_ts, o.created_ts) as created_ts -- 进入ecif的时间
    ,nvl(n.updated_ts, o.updated_ts) as updated_ts -- 在ecif中失效的时间
    ,nvl(n.last_updated_te, o.last_updated_te) as last_updated_te -- 最新更新柜员
    ,nvl(n.last_updated_org, o.last_updated_org) as last_updated_org -- 最新更新机构号
    ,nvl(n.last_system_id, o.last_system_id) as last_system_id -- 最新更新渠道
    ,nvl(n.last_updated_ts, o.last_updated_ts) as last_updated_ts -- 最新更新时间
    ,nvl(n.is_cash_magm, o.is_cash_magm) as is_cash_magm -- 是否现金管理类理财
    ,case when
            n.cust_num is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.cust_num is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.cust_num is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.eifs_t99_spv_cust_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.eifs_t99_spv_cust_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.cust_num = n.cust_num
where (
        o.cust_num is null
    )
    or (
        n.cust_num is null
    )
    or (
        o.org_cust_num <> n.org_cust_num
        or o.cust_name <> n.cust_name
        or o.spv_ytpe <> n.spv_ytpe
        or o.prod_stat_cd <> n.prod_stat_cd
        or o.spv_cd <> n.spv_cd
        or o.create_te <> n.create_te
        or o.create_org <> n.create_org
        or o.init_system_id <> n.init_system_id
        or o.init_created_ts <> n.init_created_ts
        or o.created_ts <> n.created_ts
        or o.updated_ts <> n.updated_ts
        or o.last_updated_te <> n.last_updated_te
        or o.last_updated_org <> n.last_updated_org
        or o.last_system_id <> n.last_system_id
        or o.last_updated_ts <> n.last_updated_ts
        or o.is_cash_magm <> n.is_cash_magm
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.eifs_t99_spv_cust_info_cl(
            cust_num -- spv客户号
            ,org_cust_num -- 主机构客户号
            ,cust_name -- spv名称
            ,spv_ytpe -- spv类型
            ,prod_stat_cd -- 资管产品统计编码
            ,spv_cd -- spv代码
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,is_cash_magm -- 是否现金管理类理财
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.eifs_t99_spv_cust_info_op(
            cust_num -- spv客户号
            ,org_cust_num -- 主机构客户号
            ,cust_name -- spv名称
            ,spv_ytpe -- spv类型
            ,prod_stat_cd -- 资管产品统计编码
            ,spv_cd -- spv代码
            ,create_te -- 创建柜员
            ,create_org -- 创建机构号
            ,init_system_id -- 创建渠道
            ,init_created_ts -- 源系统创建时间
            ,created_ts -- 进入ecif的时间
            ,updated_ts -- 在ecif中失效的时间
            ,last_updated_te -- 最新更新柜员
            ,last_updated_org -- 最新更新机构号
            ,last_system_id -- 最新更新渠道
            ,last_updated_ts -- 最新更新时间
            ,is_cash_magm -- 是否现金管理类理财
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.cust_num -- spv客户号
    ,o.org_cust_num -- 主机构客户号
    ,o.cust_name -- spv名称
    ,o.spv_ytpe -- spv类型
    ,o.prod_stat_cd -- 资管产品统计编码
    ,o.spv_cd -- spv代码
    ,o.create_te -- 创建柜员
    ,o.create_org -- 创建机构号
    ,o.init_system_id -- 创建渠道
    ,o.init_created_ts -- 源系统创建时间
    ,o.created_ts -- 进入ecif的时间
    ,o.updated_ts -- 在ecif中失效的时间
    ,o.last_updated_te -- 最新更新柜员
    ,o.last_updated_org -- 最新更新机构号
    ,o.last_system_id -- 最新更新渠道
    ,o.last_updated_ts -- 最新更新时间
    ,o.is_cash_magm -- 是否现金管理类理财
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
from ${iol_schema}.eifs_t99_spv_cust_info_bk o
    left join ${iol_schema}.eifs_t99_spv_cust_info_op n
        on
            o.cust_num = n.cust_num
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.eifs_t99_spv_cust_info_cl d
        on
            o.cust_num = d.cust_num
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.eifs_t99_spv_cust_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('eifs_t99_spv_cust_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.eifs_t99_spv_cust_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.eifs_t99_spv_cust_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.eifs_t99_spv_cust_info exchange partition p_${batch_date} with table ${iol_schema}.eifs_t99_spv_cust_info_cl;
alter table ${iol_schema}.eifs_t99_spv_cust_info exchange partition p_20991231 with table ${iol_schema}.eifs_t99_spv_cust_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.eifs_t99_spv_cust_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.eifs_t99_spv_cust_info_op purge;
drop table ${iol_schema}.eifs_t99_spv_cust_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.eifs_t99_spv_cust_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'eifs_t99_spv_cust_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
