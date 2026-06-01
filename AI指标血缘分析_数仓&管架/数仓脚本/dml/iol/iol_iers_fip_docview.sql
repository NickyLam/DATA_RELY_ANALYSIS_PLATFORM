/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_iers_fip_docview
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
create table ${iol_schema}.iers_fip_docview_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.iers_fip_docview
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fip_docview_op purge;
drop table ${iol_schema}.iers_fip_docview_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.iers_fip_docview_op nologging
for exchange with table
${iol_schema}.iers_fip_docview;

create table ${iol_schema}.iers_fip_docview_cl nologging
for exchange with table
${iol_schema}.iers_fip_docview;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fip_docview_cl(
            creationtime -- 创建时间
            ,creator -- 创建人
            ,desdocid -- 目标档案类型
            ,dr -- 删除标志
            ,explanation -- 备注
            ,explanation2 -- 备注2
            ,explanation3 -- 备注3
            ,explanation4 -- 备注4
            ,explanation5 -- 备注5
            ,explanation6 -- 备注6
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,orgtype -- 组织类型
            ,pk_classview -- 对象标识
            ,pk_group -- 集团
            ,pk_org -- 组织
            ,pk_setorg1 -- 关联组织
            ,ts -- 时间戳
            ,viewcode -- 编码
            ,viewname -- 名称
            ,viewname2 -- 名称2
            ,viewname3 -- 名称3
            ,viewname4 -- 名称4
            ,viewname5 -- 名称5
            ,viewname6 -- 名称6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fip_docview_op(
            creationtime -- 创建时间
            ,creator -- 创建人
            ,desdocid -- 目标档案类型
            ,dr -- 删除标志
            ,explanation -- 备注
            ,explanation2 -- 备注2
            ,explanation3 -- 备注3
            ,explanation4 -- 备注4
            ,explanation5 -- 备注5
            ,explanation6 -- 备注6
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,orgtype -- 组织类型
            ,pk_classview -- 对象标识
            ,pk_group -- 集团
            ,pk_org -- 组织
            ,pk_setorg1 -- 关联组织
            ,ts -- 时间戳
            ,viewcode -- 编码
            ,viewname -- 名称
            ,viewname2 -- 名称2
            ,viewname3 -- 名称3
            ,viewname4 -- 名称4
            ,viewname5 -- 名称5
            ,viewname6 -- 名称6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.creationtime, o.creationtime) as creationtime -- 创建时间
    ,nvl(n.creator, o.creator) as creator -- 创建人
    ,nvl(n.desdocid, o.desdocid) as desdocid -- 目标档案类型
    ,nvl(n.dr, o.dr) as dr -- 删除标志
    ,nvl(n.explanation, o.explanation) as explanation -- 备注
    ,nvl(n.explanation2, o.explanation2) as explanation2 -- 备注2
    ,nvl(n.explanation3, o.explanation3) as explanation3 -- 备注3
    ,nvl(n.explanation4, o.explanation4) as explanation4 -- 备注4
    ,nvl(n.explanation5, o.explanation5) as explanation5 -- 备注5
    ,nvl(n.explanation6, o.explanation6) as explanation6 -- 备注6
    ,nvl(n.modifiedtime, o.modifiedtime) as modifiedtime -- 修改时间
    ,nvl(n.modifier, o.modifier) as modifier -- 修改人
    ,nvl(n.orgtype, o.orgtype) as orgtype -- 组织类型
    ,nvl(n.pk_classview, o.pk_classview) as pk_classview -- 对象标识
    ,nvl(n.pk_group, o.pk_group) as pk_group -- 集团
    ,nvl(n.pk_org, o.pk_org) as pk_org -- 组织
    ,nvl(n.pk_setorg1, o.pk_setorg1) as pk_setorg1 -- 关联组织
    ,nvl(n.ts, o.ts) as ts -- 时间戳
    ,nvl(n.viewcode, o.viewcode) as viewcode -- 编码
    ,nvl(n.viewname, o.viewname) as viewname -- 名称
    ,nvl(n.viewname2, o.viewname2) as viewname2 -- 名称2
    ,nvl(n.viewname3, o.viewname3) as viewname3 -- 名称3
    ,nvl(n.viewname4, o.viewname4) as viewname4 -- 名称4
    ,nvl(n.viewname5, o.viewname5) as viewname5 -- 名称5
    ,nvl(n.viewname6, o.viewname6) as viewname6 -- 名称6
    ,case when
            n.pk_classview is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_classview is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_classview is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.iers_fip_docview_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.iers_fip_docview where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_classview = n.pk_classview
where (
        o.pk_classview is null
    )
    or (
        n.pk_classview is null
    )
    or (
        o.creationtime <> n.creationtime
        or o.creator <> n.creator
        or o.desdocid <> n.desdocid
        or o.dr <> n.dr
        or o.explanation <> n.explanation
        or o.explanation2 <> n.explanation2
        or o.explanation3 <> n.explanation3
        or o.explanation4 <> n.explanation4
        or o.explanation5 <> n.explanation5
        or o.explanation6 <> n.explanation6
        or o.modifiedtime <> n.modifiedtime
        or o.modifier <> n.modifier
        or o.orgtype <> n.orgtype
        or o.pk_group <> n.pk_group
        or o.pk_org <> n.pk_org
        or o.pk_setorg1 <> n.pk_setorg1
        or o.ts <> n.ts
        or o.viewcode <> n.viewcode
        or o.viewname <> n.viewname
        or o.viewname2 <> n.viewname2
        or o.viewname3 <> n.viewname3
        or o.viewname4 <> n.viewname4
        or o.viewname5 <> n.viewname5
        or o.viewname6 <> n.viewname6
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.iers_fip_docview_cl(
            creationtime -- 创建时间
            ,creator -- 创建人
            ,desdocid -- 目标档案类型
            ,dr -- 删除标志
            ,explanation -- 备注
            ,explanation2 -- 备注2
            ,explanation3 -- 备注3
            ,explanation4 -- 备注4
            ,explanation5 -- 备注5
            ,explanation6 -- 备注6
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,orgtype -- 组织类型
            ,pk_classview -- 对象标识
            ,pk_group -- 集团
            ,pk_org -- 组织
            ,pk_setorg1 -- 关联组织
            ,ts -- 时间戳
            ,viewcode -- 编码
            ,viewname -- 名称
            ,viewname2 -- 名称2
            ,viewname3 -- 名称3
            ,viewname4 -- 名称4
            ,viewname5 -- 名称5
            ,viewname6 -- 名称6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.iers_fip_docview_op(
            creationtime -- 创建时间
            ,creator -- 创建人
            ,desdocid -- 目标档案类型
            ,dr -- 删除标志
            ,explanation -- 备注
            ,explanation2 -- 备注2
            ,explanation3 -- 备注3
            ,explanation4 -- 备注4
            ,explanation5 -- 备注5
            ,explanation6 -- 备注6
            ,modifiedtime -- 修改时间
            ,modifier -- 修改人
            ,orgtype -- 组织类型
            ,pk_classview -- 对象标识
            ,pk_group -- 集团
            ,pk_org -- 组织
            ,pk_setorg1 -- 关联组织
            ,ts -- 时间戳
            ,viewcode -- 编码
            ,viewname -- 名称
            ,viewname2 -- 名称2
            ,viewname3 -- 名称3
            ,viewname4 -- 名称4
            ,viewname5 -- 名称5
            ,viewname6 -- 名称6
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.creationtime -- 创建时间
    ,o.creator -- 创建人
    ,o.desdocid -- 目标档案类型
    ,o.dr -- 删除标志
    ,o.explanation -- 备注
    ,o.explanation2 -- 备注2
    ,o.explanation3 -- 备注3
    ,o.explanation4 -- 备注4
    ,o.explanation5 -- 备注5
    ,o.explanation6 -- 备注6
    ,o.modifiedtime -- 修改时间
    ,o.modifier -- 修改人
    ,o.orgtype -- 组织类型
    ,o.pk_classview -- 对象标识
    ,o.pk_group -- 集团
    ,o.pk_org -- 组织
    ,o.pk_setorg1 -- 关联组织
    ,o.ts -- 时间戳
    ,o.viewcode -- 编码
    ,o.viewname -- 名称
    ,o.viewname2 -- 名称2
    ,o.viewname3 -- 名称3
    ,o.viewname4 -- 名称4
    ,o.viewname5 -- 名称5
    ,o.viewname6 -- 名称6
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
from ${iol_schema}.iers_fip_docview_bk o
    left join ${iol_schema}.iers_fip_docview_op n
        on
            o.pk_classview = n.pk_classview
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.iers_fip_docview_cl d
        on
            o.pk_classview = d.pk_classview
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.iers_fip_docview;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('iers_fip_docview') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.iers_fip_docview drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.iers_fip_docview add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.iers_fip_docview exchange partition p_${batch_date} with table ${iol_schema}.iers_fip_docview_cl;
alter table ${iol_schema}.iers_fip_docview exchange partition p_20991231 with table ${iol_schema}.iers_fip_docview_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.iers_fip_docview to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.iers_fip_docview_op purge;
drop table ${iol_schema}.iers_fip_docview_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.iers_fip_docview_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'iers_fip_docview',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
