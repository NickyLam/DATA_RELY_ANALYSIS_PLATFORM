/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_alss_ams_blacklist_category
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
create table ${iol_schema}.alss_ams_blacklist_category_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.alss_ams_blacklist_category
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alss_ams_blacklist_category_op purge;
drop table ${iol_schema}.alss_ams_blacklist_category_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.alss_ams_blacklist_category_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alss_ams_blacklist_category where 0=1;

create table ${iol_schema}.alss_ams_blacklist_category_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.alss_ams_blacklist_category where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.alss_ams_blacklist_category_cl(
            black_id -- 名单编号
            ,black_type -- 名单大类（迁移时等于名单名称）
            ,black_nane -- 名单名称
            ,black_source -- 名单来源
            ,black_desc -- 名单说明
            ,control_measure_desc -- 管控措施说明
            ,supervise_file -- 监管文件参考
            ,effective_region -- 生效地区
            ,data_permisions -- 数据维护权限
            ,effective_date -- 有效期限
            ,black_status -- 名单状态（1已生效/0已失效）
            ,add_user -- 新增操作人员
            ,add_date -- 新增时间
            ,del_user -- 删除操作人员
            ,del_date -- 删除时间
            ,exp_user -- 失效操作人员
            ,exp_time -- 失效操作时间
            ,last_update_user -- 最后更新人员
            ,last_update_date -- 最后更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.alss_ams_blacklist_category_op(
            black_id -- 名单编号
            ,black_type -- 名单大类（迁移时等于名单名称）
            ,black_nane -- 名单名称
            ,black_source -- 名单来源
            ,black_desc -- 名单说明
            ,control_measure_desc -- 管控措施说明
            ,supervise_file -- 监管文件参考
            ,effective_region -- 生效地区
            ,data_permisions -- 数据维护权限
            ,effective_date -- 有效期限
            ,black_status -- 名单状态（1已生效/0已失效）
            ,add_user -- 新增操作人员
            ,add_date -- 新增时间
            ,del_user -- 删除操作人员
            ,del_date -- 删除时间
            ,exp_user -- 失效操作人员
            ,exp_time -- 失效操作时间
            ,last_update_user -- 最后更新人员
            ,last_update_date -- 最后更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.black_id, o.black_id) as black_id -- 名单编号
    ,nvl(n.black_type, o.black_type) as black_type -- 名单大类（迁移时等于名单名称）
    ,nvl(n.black_nane, o.black_nane) as black_nane -- 名单名称
    ,nvl(n.black_source, o.black_source) as black_source -- 名单来源
    ,nvl(n.black_desc, o.black_desc) as black_desc -- 名单说明
    ,nvl(n.control_measure_desc, o.control_measure_desc) as control_measure_desc -- 管控措施说明
    ,nvl(n.supervise_file, o.supervise_file) as supervise_file -- 监管文件参考
    ,nvl(n.effective_region, o.effective_region) as effective_region -- 生效地区
    ,nvl(n.data_permisions, o.data_permisions) as data_permisions -- 数据维护权限
    ,nvl(n.effective_date, o.effective_date) as effective_date -- 有效期限
    ,nvl(n.black_status, o.black_status) as black_status -- 名单状态（1已生效/0已失效）
    ,nvl(n.add_user, o.add_user) as add_user -- 新增操作人员
    ,nvl(n.add_date, o.add_date) as add_date -- 新增时间
    ,nvl(n.del_user, o.del_user) as del_user -- 删除操作人员
    ,nvl(n.del_date, o.del_date) as del_date -- 删除时间
    ,nvl(n.exp_user, o.exp_user) as exp_user -- 失效操作人员
    ,nvl(n.exp_time, o.exp_time) as exp_time -- 失效操作时间
    ,nvl(n.last_update_user, o.last_update_user) as last_update_user -- 最后更新人员
    ,nvl(n.last_update_date, o.last_update_date) as last_update_date -- 最后更新时间
    ,case when
            n.black_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.black_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.black_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.alss_ams_blacklist_category_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.alss_ams_blacklist_category where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.black_id = n.black_id
where (
        o.black_id is null
    )
    or (
        n.black_id is null
    )
    or (
        o.black_type <> n.black_type
        or o.black_nane <> n.black_nane
        or o.black_source <> n.black_source
        or o.black_desc <> n.black_desc
        or o.control_measure_desc <> n.control_measure_desc
        or o.supervise_file <> n.supervise_file
        or o.effective_region <> n.effective_region
        or o.data_permisions <> n.data_permisions
        or o.effective_date <> n.effective_date
        or o.black_status <> n.black_status
        or o.add_user <> n.add_user
        or o.add_date <> n.add_date
        or o.del_user <> n.del_user
        or o.del_date <> n.del_date
        or o.exp_user <> n.exp_user
        or o.exp_time <> n.exp_time
        or o.last_update_user <> n.last_update_user
        or o.last_update_date <> n.last_update_date
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.alss_ams_blacklist_category_cl(
            black_id -- 名单编号
            ,black_type -- 名单大类（迁移时等于名单名称）
            ,black_nane -- 名单名称
            ,black_source -- 名单来源
            ,black_desc -- 名单说明
            ,control_measure_desc -- 管控措施说明
            ,supervise_file -- 监管文件参考
            ,effective_region -- 生效地区
            ,data_permisions -- 数据维护权限
            ,effective_date -- 有效期限
            ,black_status -- 名单状态（1已生效/0已失效）
            ,add_user -- 新增操作人员
            ,add_date -- 新增时间
            ,del_user -- 删除操作人员
            ,del_date -- 删除时间
            ,exp_user -- 失效操作人员
            ,exp_time -- 失效操作时间
            ,last_update_user -- 最后更新人员
            ,last_update_date -- 最后更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.alss_ams_blacklist_category_op(
            black_id -- 名单编号
            ,black_type -- 名单大类（迁移时等于名单名称）
            ,black_nane -- 名单名称
            ,black_source -- 名单来源
            ,black_desc -- 名单说明
            ,control_measure_desc -- 管控措施说明
            ,supervise_file -- 监管文件参考
            ,effective_region -- 生效地区
            ,data_permisions -- 数据维护权限
            ,effective_date -- 有效期限
            ,black_status -- 名单状态（1已生效/0已失效）
            ,add_user -- 新增操作人员
            ,add_date -- 新增时间
            ,del_user -- 删除操作人员
            ,del_date -- 删除时间
            ,exp_user -- 失效操作人员
            ,exp_time -- 失效操作时间
            ,last_update_user -- 最后更新人员
            ,last_update_date -- 最后更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.black_id -- 名单编号
    ,o.black_type -- 名单大类（迁移时等于名单名称）
    ,o.black_nane -- 名单名称
    ,o.black_source -- 名单来源
    ,o.black_desc -- 名单说明
    ,o.control_measure_desc -- 管控措施说明
    ,o.supervise_file -- 监管文件参考
    ,o.effective_region -- 生效地区
    ,o.data_permisions -- 数据维护权限
    ,o.effective_date -- 有效期限
    ,o.black_status -- 名单状态（1已生效/0已失效）
    ,o.add_user -- 新增操作人员
    ,o.add_date -- 新增时间
    ,o.del_user -- 删除操作人员
    ,o.del_date -- 删除时间
    ,o.exp_user -- 失效操作人员
    ,o.exp_time -- 失效操作时间
    ,o.last_update_user -- 最后更新人员
    ,o.last_update_date -- 最后更新时间
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
from ${iol_schema}.alss_ams_blacklist_category_bk o
    left join ${iol_schema}.alss_ams_blacklist_category_op n
        on
            o.black_id = n.black_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.alss_ams_blacklist_category_cl d
        on
            o.black_id = d.black_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.alss_ams_blacklist_category;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('alss_ams_blacklist_category') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.alss_ams_blacklist_category drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.alss_ams_blacklist_category add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.alss_ams_blacklist_category exchange partition p_${batch_date} with table ${iol_schema}.alss_ams_blacklist_category_cl;
alter table ${iol_schema}.alss_ams_blacklist_category exchange partition p_20991231 with table ${iol_schema}.alss_ams_blacklist_category_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.alss_ams_blacklist_category to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.alss_ams_blacklist_category_op purge;
drop table ${iol_schema}.alss_ams_blacklist_category_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.alss_ams_blacklist_category_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'alss_ams_blacklist_category',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
