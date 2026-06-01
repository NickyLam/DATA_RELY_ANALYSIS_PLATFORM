/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_amis_sm_dict_param
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
create table ${iol_schema}.amis_sm_dict_param_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.amis_sm_dict_param
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_sm_dict_param_op purge;
drop table ${iol_schema}.amis_sm_dict_param_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.amis_sm_dict_param_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_sm_dict_param where 0=1;

create table ${iol_schema}.amis_sm_dict_param_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.amis_sm_dict_param where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_sm_dict_param_cl(
            sm_dict_param_uuid -- 参数码表主键UUID
            ,sm_dict_uuid -- 参数类别UUID
            ,dict_param_code -- 参数编号
            ,dict_param_name -- 参数名称
            ,dict_param_desc -- 参数描述
            ,dict_param_seq -- 参数排序号
            ,edit -- 系统参数标志
            ,del_flag -- 删除标志
            ,dict_param_ext1 -- 扩展字段
            ,parent_uuid -- 父节点UUID
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人姓名
            ,create_org_name -- 创建机构
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_sm_dict_param_op(
            sm_dict_param_uuid -- 参数码表主键UUID
            ,sm_dict_uuid -- 参数类别UUID
            ,dict_param_code -- 参数编号
            ,dict_param_name -- 参数名称
            ,dict_param_desc -- 参数描述
            ,dict_param_seq -- 参数排序号
            ,edit -- 系统参数标志
            ,del_flag -- 删除标志
            ,dict_param_ext1 -- 扩展字段
            ,parent_uuid -- 父节点UUID
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人姓名
            ,create_org_name -- 创建机构
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sm_dict_param_uuid, o.sm_dict_param_uuid) as sm_dict_param_uuid -- 参数码表主键UUID
    ,nvl(n.sm_dict_uuid, o.sm_dict_uuid) as sm_dict_uuid -- 参数类别UUID
    ,nvl(n.dict_param_code, o.dict_param_code) as dict_param_code -- 参数编号
    ,nvl(n.dict_param_name, o.dict_param_name) as dict_param_name -- 参数名称
    ,nvl(n.dict_param_desc, o.dict_param_desc) as dict_param_desc -- 参数描述
    ,nvl(n.dict_param_seq, o.dict_param_seq) as dict_param_seq -- 参数排序号
    ,nvl(n.edit, o.edit) as edit -- 系统参数标志
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 删除标志
    ,nvl(n.dict_param_ext1, o.dict_param_ext1) as dict_param_ext1 -- 扩展字段
    ,nvl(n.parent_uuid, o.parent_uuid) as parent_uuid -- 父节点UUID
    ,nvl(n.create_person_uuid, o.create_person_uuid) as create_person_uuid -- 创建人UUID
    ,nvl(n.create_person_name, o.create_person_name) as create_person_name -- 创建人姓名
    ,nvl(n.create_org_name, o.create_org_name) as create_org_name -- 创建机构
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,case when
            n.sm_dict_param_uuid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sm_dict_param_uuid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sm_dict_param_uuid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.amis_sm_dict_param_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.amis_sm_dict_param where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sm_dict_param_uuid = n.sm_dict_param_uuid
where (
        o.sm_dict_param_uuid is null
    )
    or (
        n.sm_dict_param_uuid is null
    )
    or (
        o.sm_dict_uuid <> n.sm_dict_uuid
        or o.dict_param_code <> n.dict_param_code
        or o.dict_param_name <> n.dict_param_name
        or o.dict_param_desc <> n.dict_param_desc
        or o.dict_param_seq <> n.dict_param_seq
        or o.edit <> n.edit
        or o.del_flag <> n.del_flag
        or o.dict_param_ext1 <> n.dict_param_ext1
        or o.parent_uuid <> n.parent_uuid
        or o.create_person_uuid <> n.create_person_uuid
        or o.create_person_name <> n.create_person_name
        or o.create_org_name <> n.create_org_name
        or o.create_time <> n.create_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.amis_sm_dict_param_cl(
            sm_dict_param_uuid -- 参数码表主键UUID
            ,sm_dict_uuid -- 参数类别UUID
            ,dict_param_code -- 参数编号
            ,dict_param_name -- 参数名称
            ,dict_param_desc -- 参数描述
            ,dict_param_seq -- 参数排序号
            ,edit -- 系统参数标志
            ,del_flag -- 删除标志
            ,dict_param_ext1 -- 扩展字段
            ,parent_uuid -- 父节点UUID
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人姓名
            ,create_org_name -- 创建机构
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.amis_sm_dict_param_op(
            sm_dict_param_uuid -- 参数码表主键UUID
            ,sm_dict_uuid -- 参数类别UUID
            ,dict_param_code -- 参数编号
            ,dict_param_name -- 参数名称
            ,dict_param_desc -- 参数描述
            ,dict_param_seq -- 参数排序号
            ,edit -- 系统参数标志
            ,del_flag -- 删除标志
            ,dict_param_ext1 -- 扩展字段
            ,parent_uuid -- 父节点UUID
            ,create_person_uuid -- 创建人UUID
            ,create_person_name -- 创建人姓名
            ,create_org_name -- 创建机构
            ,create_time -- 创建时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sm_dict_param_uuid -- 参数码表主键UUID
    ,o.sm_dict_uuid -- 参数类别UUID
    ,o.dict_param_code -- 参数编号
    ,o.dict_param_name -- 参数名称
    ,o.dict_param_desc -- 参数描述
    ,o.dict_param_seq -- 参数排序号
    ,o.edit -- 系统参数标志
    ,o.del_flag -- 删除标志
    ,o.dict_param_ext1 -- 扩展字段
    ,o.parent_uuid -- 父节点UUID
    ,o.create_person_uuid -- 创建人UUID
    ,o.create_person_name -- 创建人姓名
    ,o.create_org_name -- 创建机构
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
from ${iol_schema}.amis_sm_dict_param_bk o
    left join ${iol_schema}.amis_sm_dict_param_op n
        on
            o.sm_dict_param_uuid = n.sm_dict_param_uuid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.amis_sm_dict_param_cl d
        on
            o.sm_dict_param_uuid = d.sm_dict_param_uuid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.amis_sm_dict_param;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('amis_sm_dict_param') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.amis_sm_dict_param drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.amis_sm_dict_param add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.amis_sm_dict_param exchange partition p_${batch_date} with table ${iol_schema}.amis_sm_dict_param_cl;
alter table ${iol_schema}.amis_sm_dict_param exchange partition p_20991231 with table ${iol_schema}.amis_sm_dict_param_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.amis_sm_dict_param to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.amis_sm_dict_param_op purge;
drop table ${iol_schema}.amis_sm_dict_param_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.amis_sm_dict_param_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'amis_sm_dict_param',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
