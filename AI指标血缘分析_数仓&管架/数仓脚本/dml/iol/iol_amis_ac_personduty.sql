/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amis_ac_personduty
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
create table ${iol_schema}.amis_ac_personduty_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amis_ac_personduty
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_ac_personduty_op purge;
drop table ${iol_schema}.amis_ac_personduty_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_ac_personduty_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_ac_personduty where 0=1;

create table ${iol_schema}.amis_ac_personduty_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_ac_personduty where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_ac_personduty_cl(
            ac_personduty_uuid -- 主键
            ,ac_project_uuid -- 问责项目uuid
            ,personduty_name -- 责任人名称
            ,active_code -- 在职状态代码
            ,active_name -- 在职状态名称
            ,sex -- 性别
            ,old_orgname -- 原所在机构
            ,old_station -- 原岗位
            ,level_code -- 责任人层级代码
            ,level_name -- 责任人层级名称
            ,curr_org_uuid -- 现所在机构UUID
            ,curr_org_name -- 现所在机构名称
            ,curr_station -- 现岗位
            ,duty_code　 -- 免责标志代码
            ,duty_name -- 免责标志名称
            ,reason_desc -- 免责理由描述
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人名称
            ,create_org_name -- 创建人机构
            ,create_time　 -- 创建时间
            ,deleted -- 是否删除,1：删除，0未删除
            ,ac_project_code -- 问责项目编号
            ,ac_project_name -- 问责项目名称
            ,ext1 -- 扩展字段1
            ,ext2 -- 扩展字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_ac_personduty_op(
            ac_personduty_uuid -- 主键
            ,ac_project_uuid -- 问责项目uuid
            ,personduty_name -- 责任人名称
            ,active_code -- 在职状态代码
            ,active_name -- 在职状态名称
            ,sex -- 性别
            ,old_orgname -- 原所在机构
            ,old_station -- 原岗位
            ,level_code -- 责任人层级代码
            ,level_name -- 责任人层级名称
            ,curr_org_uuid -- 现所在机构UUID
            ,curr_org_name -- 现所在机构名称
            ,curr_station -- 现岗位
            ,duty_code　 -- 免责标志代码
            ,duty_name -- 免责标志名称
            ,reason_desc -- 免责理由描述
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人名称
            ,create_org_name -- 创建人机构
            ,create_time　 -- 创建时间
            ,deleted -- 是否删除,1：删除，0未删除
            ,ac_project_code -- 问责项目编号
            ,ac_project_name -- 问责项目名称
            ,ext1 -- 扩展字段1
            ,ext2 -- 扩展字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ac_personduty_uuid, o.ac_personduty_uuid) as ac_personduty_uuid -- 主键
    ,nvl(n.ac_project_uuid, o.ac_project_uuid) as ac_project_uuid -- 问责项目uuid
    ,nvl(n.personduty_name, o.personduty_name) as personduty_name -- 责任人名称
    ,nvl(n.active_code, o.active_code) as active_code -- 在职状态代码
    ,nvl(n.active_name, o.active_name) as active_name -- 在职状态名称
    ,nvl(n.sex, o.sex) as sex -- 性别
    ,nvl(n.old_orgname, o.old_orgname) as old_orgname -- 原所在机构
    ,nvl(n.old_station, o.old_station) as old_station -- 原岗位
    ,nvl(n.level_code, o.level_code) as level_code -- 责任人层级代码
    ,nvl(n.level_name, o.level_name) as level_name -- 责任人层级名称
    ,nvl(n.curr_org_uuid, o.curr_org_uuid) as curr_org_uuid -- 现所在机构UUID
    ,nvl(n.curr_org_name, o.curr_org_name) as curr_org_name -- 现所在机构名称
    ,nvl(n.curr_station, o.curr_station) as curr_station -- 现岗位
    ,nvl(n.duty_code　, o.duty_code　) as duty_code　 -- 免责标志代码
    ,nvl(n.duty_name, o.duty_name) as duty_name -- 免责标志名称
    ,nvl(n.reason_desc, o.reason_desc) as reason_desc -- 免责理由描述
    ,nvl(n.create_person_uuid, o.create_person_uuid) as create_person_uuid -- 创建人UUID
    ,nvl(n.create_person_name, o.create_person_name) as create_person_name -- 创建人名称
    ,nvl(n.create_org_name, o.create_org_name) as create_org_name -- 创建人机构
    ,nvl(n.create_time　, o.create_time　) as create_time　 -- 创建时间
    ,nvl(n.deleted, o.deleted) as deleted -- 是否删除,1：删除，0未删除
    ,nvl(n.ac_project_code, o.ac_project_code) as ac_project_code -- 问责项目编号
    ,nvl(n.ac_project_name, o.ac_project_name) as ac_project_name -- 问责项目名称
    ,nvl(n.ext1, o.ext1) as ext1 -- 扩展字段1
    ,nvl(n.ext2, o.ext2) as ext2 -- 扩展字段2
    ,case when
            n.ac_personduty_uuid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ac_personduty_uuid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ac_personduty_uuid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amis_ac_personduty_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amis_ac_personduty where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ac_personduty_uuid = n.ac_personduty_uuid
where (
        o.ac_personduty_uuid is null
    )
    or (
        n.ac_personduty_uuid is null
    )
    or (
        o.ac_project_uuid <> n.ac_project_uuid
        or o.personduty_name <> n.personduty_name
        or o.active_code <> n.active_code
        or o.active_name <> n.active_name
        or o.sex <> n.sex
        or o.old_orgname <> n.old_orgname
        or o.old_station <> n.old_station
        or o.level_code <> n.level_code
        or o.level_name <> n.level_name
        or o.curr_org_uuid <> n.curr_org_uuid
        or o.curr_org_name <> n.curr_org_name
        or o.curr_station <> n.curr_station
        or o.duty_code　 <> n.duty_code　
        or o.duty_name <> n.duty_name
        or o.reason_desc <> n.reason_desc
        or o.create_person_uuid <> n.create_person_uuid
        or o.create_person_name <> n.create_person_name
        or o.create_org_name <> n.create_org_name
        or o.create_time　 <> n.create_time　
        or o.deleted <> n.deleted
        or o.ac_project_code <> n.ac_project_code
        or o.ac_project_name <> n.ac_project_name
        or o.ext1 <> n.ext1
        or o.ext2 <> n.ext2
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_ac_personduty_cl(
            ac_personduty_uuid -- 主键
            ,ac_project_uuid -- 问责项目uuid
            ,personduty_name -- 责任人名称
            ,active_code -- 在职状态代码
            ,active_name -- 在职状态名称
            ,sex -- 性别
            ,old_orgname -- 原所在机构
            ,old_station -- 原岗位
            ,level_code -- 责任人层级代码
            ,level_name -- 责任人层级名称
            ,curr_org_uuid -- 现所在机构UUID
            ,curr_org_name -- 现所在机构名称
            ,curr_station -- 现岗位
            ,duty_code　 -- 免责标志代码
            ,duty_name -- 免责标志名称
            ,reason_desc -- 免责理由描述
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人名称
            ,create_org_name -- 创建人机构
            ,create_time　 -- 创建时间
            ,deleted -- 是否删除,1：删除，0未删除
            ,ac_project_code -- 问责项目编号
            ,ac_project_name -- 问责项目名称
            ,ext1 -- 扩展字段1
            ,ext2 -- 扩展字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_ac_personduty_op(
            ac_personduty_uuid -- 主键
            ,ac_project_uuid -- 问责项目uuid
            ,personduty_name -- 责任人名称
            ,active_code -- 在职状态代码
            ,active_name -- 在职状态名称
            ,sex -- 性别
            ,old_orgname -- 原所在机构
            ,old_station -- 原岗位
            ,level_code -- 责任人层级代码
            ,level_name -- 责任人层级名称
            ,curr_org_uuid -- 现所在机构UUID
            ,curr_org_name -- 现所在机构名称
            ,curr_station -- 现岗位
            ,duty_code　 -- 免责标志代码
            ,duty_name -- 免责标志名称
            ,reason_desc -- 免责理由描述
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人名称
            ,create_org_name -- 创建人机构
            ,create_time　 -- 创建时间
            ,deleted -- 是否删除,1：删除，0未删除
            ,ac_project_code -- 问责项目编号
            ,ac_project_name -- 问责项目名称
            ,ext1 -- 扩展字段1
            ,ext2 -- 扩展字段2
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ac_personduty_uuid -- 主键
    ,o.ac_project_uuid -- 问责项目uuid
    ,o.personduty_name -- 责任人名称
    ,o.active_code -- 在职状态代码
    ,o.active_name -- 在职状态名称
    ,o.sex -- 性别
    ,o.old_orgname -- 原所在机构
    ,o.old_station -- 原岗位
    ,o.level_code -- 责任人层级代码
    ,o.level_name -- 责任人层级名称
    ,o.curr_org_uuid -- 现所在机构UUID
    ,o.curr_org_name -- 现所在机构名称
    ,o.curr_station -- 现岗位
    ,o.duty_code　 -- 免责标志代码
    ,o.duty_name -- 免责标志名称
    ,o.reason_desc -- 免责理由描述
    ,o.create_person_uuid -- 创建人UUID
    ,o.create_person_name -- 创建人名称
    ,o.create_org_name -- 创建人机构
    ,o.create_time　 -- 创建时间
    ,o.deleted -- 是否删除,1：删除，0未删除
    ,o.ac_project_code -- 问责项目编号
    ,o.ac_project_name -- 问责项目名称
    ,o.ext1 -- 扩展字段1
    ,o.ext2 -- 扩展字段2
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
from ${iol_schema}.amis_ac_personduty_bk o
    left join ${iol_schema}.amis_ac_personduty_op n
        on
            o.ac_personduty_uuid = n.ac_personduty_uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amis_ac_personduty_cl d
        on
            o.ac_personduty_uuid = d.ac_personduty_uuid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amis_ac_personduty;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amis_ac_personduty') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amis_ac_personduty drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amis_ac_personduty add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amis_ac_personduty exchange partition p_${batch_date} with table ${iol_schema}.amis_ac_personduty_cl;
alter table ${iol_schema}.amis_ac_personduty exchange partition p_20991231 with table ${iol_schema}.amis_ac_personduty_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amis_ac_personduty to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_ac_personduty_op purge;
drop table ${iol_schema}.amis_ac_personduty_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amis_ac_personduty_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amis_ac_personduty',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
