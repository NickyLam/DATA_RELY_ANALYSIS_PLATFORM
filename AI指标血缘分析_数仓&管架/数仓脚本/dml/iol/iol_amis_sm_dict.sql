/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amis_sm_dict
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
create table ${iol_schema}.amis_sm_dict_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amis_sm_dict
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_sm_dict_op purge;
drop table ${iol_schema}.amis_sm_dict_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_sm_dict_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_sm_dict where 0=1;

create table ${iol_schema}.amis_sm_dict_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_sm_dict where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_sm_dict_cl(
            sm_dict_uuid -- 参数类别主键UUID
            ,dict_code -- 参数类别编号
            ,dict_name -- 参数类别名称
            ,dict_desc -- 参数类别描述
            ,edit -- 系统参数标志
            ,del_flag -- 删除标志
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人姓名
            ,create_org_name -- 创建机构
            ,create_time -- 创建时间
            ,edit_desc -- 系统参数标志描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_sm_dict_op(
            sm_dict_uuid -- 参数类别主键UUID
            ,dict_code -- 参数类别编号
            ,dict_name -- 参数类别名称
            ,dict_desc -- 参数类别描述
            ,edit -- 系统参数标志
            ,del_flag -- 删除标志
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人姓名
            ,create_org_name -- 创建机构
            ,create_time -- 创建时间
            ,edit_desc -- 系统参数标志描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sm_dict_uuid, o.sm_dict_uuid) as sm_dict_uuid -- 参数类别主键UUID
    ,nvl(n.dict_code, o.dict_code) as dict_code -- 参数类别编号
    ,nvl(n.dict_name, o.dict_name) as dict_name -- 参数类别名称
    ,nvl(n.dict_desc, o.dict_desc) as dict_desc -- 参数类别描述
    ,nvl(n.edit, o.edit) as edit -- 系统参数标志
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 删除标志
    ,nvl(n.create_person_uuid, o.create_person_uuid) as create_person_uuid -- 创建人UUID
    ,nvl(n.create_person_name, o.create_person_name) as create_person_name -- 创建人姓名
    ,nvl(n.create_org_name, o.create_org_name) as create_org_name -- 创建机构
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.edit_desc, o.edit_desc) as edit_desc -- 系统参数标志描述
    ,case when
            n.sm_dict_uuid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sm_dict_uuid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sm_dict_uuid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amis_sm_dict_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amis_sm_dict where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sm_dict_uuid = n.sm_dict_uuid
where (
        o.sm_dict_uuid is null
    )
    or (
        n.sm_dict_uuid is null
    )
    or (
        o.dict_code <> n.dict_code
        or o.dict_name <> n.dict_name
        or o.dict_desc <> n.dict_desc
        or o.edit <> n.edit
        or o.del_flag <> n.del_flag
        or o.create_person_uuid <> n.create_person_uuid
        or o.create_person_name <> n.create_person_name
        or o.create_org_name <> n.create_org_name
        or o.create_time <> n.create_time
        or o.edit_desc <> n.edit_desc
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_sm_dict_cl(
            sm_dict_uuid -- 参数类别主键UUID
            ,dict_code -- 参数类别编号
            ,dict_name -- 参数类别名称
            ,dict_desc -- 参数类别描述
            ,edit -- 系统参数标志
            ,del_flag -- 删除标志
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人姓名
            ,create_org_name -- 创建机构
            ,create_time -- 创建时间
            ,edit_desc -- 系统参数标志描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_sm_dict_op(
            sm_dict_uuid -- 参数类别主键UUID
            ,dict_code -- 参数类别编号
            ,dict_name -- 参数类别名称
            ,dict_desc -- 参数类别描述
            ,edit -- 系统参数标志
            ,del_flag -- 删除标志
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人姓名
            ,create_org_name -- 创建机构
            ,create_time -- 创建时间
            ,edit_desc -- 系统参数标志描述
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sm_dict_uuid -- 参数类别主键UUID
    ,o.dict_code -- 参数类别编号
    ,o.dict_name -- 参数类别名称
    ,o.dict_desc -- 参数类别描述
    ,o.edit -- 系统参数标志
    ,o.del_flag -- 删除标志
    ,o.create_person_uuid -- 创建人UUID
    ,o.create_person_name -- 创建人姓名
    ,o.create_org_name -- 创建机构
    ,o.create_time -- 创建时间
    ,o.edit_desc -- 系统参数标志描述
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
from ${iol_schema}.amis_sm_dict_bk o
    left join ${iol_schema}.amis_sm_dict_op n
        on
            o.sm_dict_uuid = n.sm_dict_uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amis_sm_dict_cl d
        on
            o.sm_dict_uuid = d.sm_dict_uuid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amis_sm_dict;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amis_sm_dict') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amis_sm_dict drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amis_sm_dict add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amis_sm_dict exchange partition p_${batch_date} with table ${iol_schema}.amis_sm_dict_cl;
alter table ${iol_schema}.amis_sm_dict exchange partition p_20991231 with table ${iol_schema}.amis_sm_dict_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amis_sm_dict to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_sm_dict_op purge;
drop table ${iol_schema}.amis_sm_dict_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amis_sm_dict_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amis_sm_dict',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
