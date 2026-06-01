/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_ft_consigonor
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
create table ${iol_schema}.nfss_ft_consigonor_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_ft_consigonor
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_ft_consigonor_op purge;
drop table ${iol_schema}.nfss_ft_consigonor_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ft_consigonor_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_ft_consigonor where 0=1;

create table ${iol_schema}.nfss_ft_consigonor_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_ft_consigonor where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_ft_consigonor_cl(
            ecif_id -- 主键序号
            ,ecif_name -- 客户姓名
            ,ecif_no -- 客户号
            ,id_type -- 证件类型
            ,id_no -- 证件号码
            ,phone -- 手机号
            ,dep -- 所属机构
            ,is_primary -- 是否是主委托人0 不是  1是
            ,sort_field -- 排序字段
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_ft_consigonor_op(
            ecif_id -- 主键序号
            ,ecif_name -- 客户姓名
            ,ecif_no -- 客户号
            ,id_type -- 证件类型
            ,id_no -- 证件号码
            ,phone -- 手机号
            ,dep -- 所属机构
            ,is_primary -- 是否是主委托人0 不是  1是
            ,sort_field -- 排序字段
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.ecif_id, o.ecif_id) as ecif_id -- 主键序号
    ,nvl(n.ecif_name, o.ecif_name) as ecif_name -- 客户姓名
    ,nvl(n.ecif_no, o.ecif_no) as ecif_no -- 客户号
    ,nvl(n.id_type, o.id_type) as id_type -- 证件类型
    ,nvl(n.id_no, o.id_no) as id_no -- 证件号码
    ,nvl(n.phone, o.phone) as phone -- 手机号
    ,nvl(n.dep, o.dep) as dep -- 所属机构
    ,nvl(n.is_primary, o.is_primary) as is_primary -- 是否是主委托人0 不是  1是
    ,nvl(n.sort_field, o.sort_field) as sort_field -- 排序字段
    ,nvl(n.created_by, o.created_by) as created_by -- 创建者
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 修改者
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_time, o.update_time) as update_time -- 修改时间
    ,case when
            n.ecif_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ecif_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ecif_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nfss_ft_consigonor_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_ft_consigonor where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ecif_id = n.ecif_id
where (
        o.ecif_id is null
    )
    or (
        n.ecif_id is null
    )
    or (
        o.ecif_name <> n.ecif_name
        or o.ecif_no <> n.ecif_no
        or o.id_type <> n.id_type
        or o.id_no <> n.id_no
        or o.phone <> n.phone
        or o.dep <> n.dep
        or o.is_primary <> n.is_primary
        or o.sort_field <> n.sort_field
        or o.created_by <> n.created_by
        or o.updated_by <> n.updated_by
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_ft_consigonor_cl(
            ecif_id -- 主键序号
            ,ecif_name -- 客户姓名
            ,ecif_no -- 客户号
            ,id_type -- 证件类型
            ,id_no -- 证件号码
            ,phone -- 手机号
            ,dep -- 所属机构
            ,is_primary -- 是否是主委托人0 不是  1是
            ,sort_field -- 排序字段
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_ft_consigonor_op(
            ecif_id -- 主键序号
            ,ecif_name -- 客户姓名
            ,ecif_no -- 客户号
            ,id_type -- 证件类型
            ,id_no -- 证件号码
            ,phone -- 手机号
            ,dep -- 所属机构
            ,is_primary -- 是否是主委托人0 不是  1是
            ,sort_field -- 排序字段
            ,created_by -- 创建者
            ,updated_by -- 修改者
            ,create_time -- 创建时间
            ,update_time -- 修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.ecif_id -- 主键序号
    ,o.ecif_name -- 客户姓名
    ,o.ecif_no -- 客户号
    ,o.id_type -- 证件类型
    ,o.id_no -- 证件号码
    ,o.phone -- 手机号
    ,o.dep -- 所属机构
    ,o.is_primary -- 是否是主委托人0 不是  1是
    ,o.sort_field -- 排序字段
    ,o.created_by -- 创建者
    ,o.updated_by -- 修改者
    ,o.create_time -- 创建时间
    ,o.update_time -- 修改时间
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
from ${iol_schema}.nfss_ft_consigonor_bk o
    left join ${iol_schema}.nfss_ft_consigonor_op n
        on
            o.ecif_id = n.ecif_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_ft_consigonor_cl d
        on
            o.ecif_id = d.ecif_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nfss_ft_consigonor;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nfss_ft_consigonor') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nfss_ft_consigonor drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nfss_ft_consigonor add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nfss_ft_consigonor exchange partition p_${batch_date} with table ${iol_schema}.nfss_ft_consigonor_cl;
alter table ${iol_schema}.nfss_ft_consigonor exchange partition p_20991231 with table ${iol_schema}.nfss_ft_consigonor_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_ft_consigonor to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_ft_consigonor_op purge;
drop table ${iol_schema}.nfss_ft_consigonor_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_ft_consigonor_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_ft_consigonor',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
