/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amis_ac_dispatch
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
create table ${iol_schema}.amis_ac_dispatch_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amis_ac_dispatch
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_ac_dispatch_op purge;
drop table ${iol_schema}.amis_ac_dispatch_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_ac_dispatch_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_ac_dispatch where 0=1;

create table ${iol_schema}.amis_ac_dispatch_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_ac_dispatch where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_ac_dispatch_cl(
            ac_dispatch_uuid -- 问责发文uuid
            ,dispatch_no -- 发文文号
            ,dispatch_title -- 发文标题
            ,dispatch_deaprtment_uuid -- 发文单位uuid
            ,dispatch_deaprtment_name -- 发文单位名称
            ,dispath_time -- 发文时间
            ,pm_asset_uuid -- 关联问题资产uuid
            ,pm_asset_name -- 关联问题资产名称
            ,pm_problem_uuid -- 关联问题uuid
            ,pm_problem_name -- 关联问题名称
            ,entry_person_uuid -- 录入人uuid
            ,entry_person_name -- 录入人名称
            ,entry_org_uuid -- 录入机构uuid
            ,entry_org_name -- 录入机构名称
            ,deleted -- 删除标识
            ,ac_project_uuid -- 问责项目uuid
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_ac_dispatch_op(
            ac_dispatch_uuid -- 问责发文uuid
            ,dispatch_no -- 发文文号
            ,dispatch_title -- 发文标题
            ,dispatch_deaprtment_uuid -- 发文单位uuid
            ,dispatch_deaprtment_name -- 发文单位名称
            ,dispath_time -- 发文时间
            ,pm_asset_uuid -- 关联问题资产uuid
            ,pm_asset_name -- 关联问题资产名称
            ,pm_problem_uuid -- 关联问题uuid
            ,pm_problem_name -- 关联问题名称
            ,entry_person_uuid -- 录入人uuid
            ,entry_person_name -- 录入人名称
            ,entry_org_uuid -- 录入机构uuid
            ,entry_org_name -- 录入机构名称
            ,deleted -- 删除标识
            ,ac_project_uuid -- 问责项目uuid
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ac_dispatch_uuid, o.ac_dispatch_uuid) as ac_dispatch_uuid -- 问责发文uuid
    ,nvl(n.dispatch_no, o.dispatch_no) as dispatch_no -- 发文文号
    ,nvl(n.dispatch_title, o.dispatch_title) as dispatch_title -- 发文标题
    ,nvl(n.dispatch_deaprtment_uuid, o.dispatch_deaprtment_uuid) as dispatch_deaprtment_uuid -- 发文单位uuid
    ,nvl(n.dispatch_deaprtment_name, o.dispatch_deaprtment_name) as dispatch_deaprtment_name -- 发文单位名称
    ,nvl(n.dispath_time, o.dispath_time) as dispath_time -- 发文时间
    ,nvl(n.pm_asset_uuid, o.pm_asset_uuid) as pm_asset_uuid -- 关联问题资产uuid
    ,nvl(n.pm_asset_name, o.pm_asset_name) as pm_asset_name -- 关联问题资产名称
    ,nvl(n.pm_problem_uuid, o.pm_problem_uuid) as pm_problem_uuid -- 关联问题uuid
    ,nvl(n.pm_problem_name, o.pm_problem_name) as pm_problem_name -- 关联问题名称
    ,nvl(n.entry_person_uuid, o.entry_person_uuid) as entry_person_uuid -- 录入人uuid
    ,nvl(n.entry_person_name, o.entry_person_name) as entry_person_name -- 录入人名称
    ,nvl(n.entry_org_uuid, o.entry_org_uuid) as entry_org_uuid -- 录入机构uuid
    ,nvl(n.entry_org_name, o.entry_org_name) as entry_org_name -- 录入机构名称
    ,nvl(n.deleted, o.deleted) as deleted -- 删除标识
    ,nvl(n.ac_project_uuid, o.ac_project_uuid) as ac_project_uuid -- 问责项目uuid
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,case when
            n.ac_dispatch_uuid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ac_dispatch_uuid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ac_dispatch_uuid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amis_ac_dispatch_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amis_ac_dispatch where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ac_dispatch_uuid = n.ac_dispatch_uuid
where (
        o.ac_dispatch_uuid is null
    )
    or (
        n.ac_dispatch_uuid is null
    )
    or (
        o.dispatch_no <> n.dispatch_no
        or o.dispatch_title <> n.dispatch_title
        or o.dispatch_deaprtment_uuid <> n.dispatch_deaprtment_uuid
        or o.dispatch_deaprtment_name <> n.dispatch_deaprtment_name
        or o.dispath_time <> n.dispath_time
        or o.pm_asset_uuid <> n.pm_asset_uuid
        or o.pm_asset_name <> n.pm_asset_name
        or o.pm_problem_uuid <> n.pm_problem_uuid
        or o.pm_problem_name <> n.pm_problem_name
        or o.entry_person_uuid <> n.entry_person_uuid
        or o.entry_person_name <> n.entry_person_name
        or o.entry_org_uuid <> n.entry_org_uuid
        or o.entry_org_name <> n.entry_org_name
        or o.deleted <> n.deleted
        or o.ac_project_uuid <> n.ac_project_uuid
        or o.create_time <> n.create_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_ac_dispatch_cl(
            ac_dispatch_uuid -- 问责发文uuid
            ,dispatch_no -- 发文文号
            ,dispatch_title -- 发文标题
            ,dispatch_deaprtment_uuid -- 发文单位uuid
            ,dispatch_deaprtment_name -- 发文单位名称
            ,dispath_time -- 发文时间
            ,pm_asset_uuid -- 关联问题资产uuid
            ,pm_asset_name -- 关联问题资产名称
            ,pm_problem_uuid -- 关联问题uuid
            ,pm_problem_name -- 关联问题名称
            ,entry_person_uuid -- 录入人uuid
            ,entry_person_name -- 录入人名称
            ,entry_org_uuid -- 录入机构uuid
            ,entry_org_name -- 录入机构名称
            ,deleted -- 删除标识
            ,ac_project_uuid -- 问责项目uuid
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_ac_dispatch_op(
            ac_dispatch_uuid -- 问责发文uuid
            ,dispatch_no -- 发文文号
            ,dispatch_title -- 发文标题
            ,dispatch_deaprtment_uuid -- 发文单位uuid
            ,dispatch_deaprtment_name -- 发文单位名称
            ,dispath_time -- 发文时间
            ,pm_asset_uuid -- 关联问题资产uuid
            ,pm_asset_name -- 关联问题资产名称
            ,pm_problem_uuid -- 关联问题uuid
            ,pm_problem_name -- 关联问题名称
            ,entry_person_uuid -- 录入人uuid
            ,entry_person_name -- 录入人名称
            ,entry_org_uuid -- 录入机构uuid
            ,entry_org_name -- 录入机构名称
            ,deleted -- 删除标识
            ,ac_project_uuid -- 问责项目uuid
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ac_dispatch_uuid -- 问责发文uuid
    ,o.dispatch_no -- 发文文号
    ,o.dispatch_title -- 发文标题
    ,o.dispatch_deaprtment_uuid -- 发文单位uuid
    ,o.dispatch_deaprtment_name -- 发文单位名称
    ,o.dispath_time -- 发文时间
    ,o.pm_asset_uuid -- 关联问题资产uuid
    ,o.pm_asset_name -- 关联问题资产名称
    ,o.pm_problem_uuid -- 关联问题uuid
    ,o.pm_problem_name -- 关联问题名称
    ,o.entry_person_uuid -- 录入人uuid
    ,o.entry_person_name -- 录入人名称
    ,o.entry_org_uuid -- 录入机构uuid
    ,o.entry_org_name -- 录入机构名称
    ,o.deleted -- 删除标识
    ,o.ac_project_uuid -- 问责项目uuid
    ,o.create_time -- 创建时间
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
from ${iol_schema}.amis_ac_dispatch_bk o
    left join ${iol_schema}.amis_ac_dispatch_op n
        on
            o.ac_dispatch_uuid = n.ac_dispatch_uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amis_ac_dispatch_cl d
        on
            o.ac_dispatch_uuid = d.ac_dispatch_uuid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amis_ac_dispatch;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amis_ac_dispatch') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amis_ac_dispatch drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amis_ac_dispatch add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amis_ac_dispatch exchange partition p_${batch_date} with table ${iol_schema}.amis_ac_dispatch_cl;
alter table ${iol_schema}.amis_ac_dispatch exchange partition p_20991231 with table ${iol_schema}.amis_ac_dispatch_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amis_ac_dispatch to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_ac_dispatch_op purge;
drop table ${iol_schema}.amis_ac_dispatch_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amis_ac_dispatch_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amis_ac_dispatch',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
