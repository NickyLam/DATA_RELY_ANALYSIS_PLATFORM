/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_pbms_tbl_dic_param
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
create table ${iol_schema}.pbms_tbl_dic_param_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.pbms_tbl_dic_param
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_dic_param_op purge;
drop table ${iol_schema}.pbms_tbl_dic_param_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.pbms_tbl_dic_param_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_dic_param where 0=1;

create table ${iol_schema}.pbms_tbl_dic_param_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.pbms_tbl_dic_param where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_dic_param_cl(
            pk_dic_param -- 流水号
            ,param_code -- 参数编码
            ,param_name -- 参数名称
            ,param_desc -- 描述
            ,param_order -- 显示顺序
            ,parent_code -- 父code
            ,field1 -- 保留字段
            ,crt_time -- 创建时间
            ,upd_time -- 最后修改时间
            ,obj_version -- 版本号
            ,flag_enable -- 是否有效
            ,usage_key -- 部门标识
            ,param_desc2 -- 参数描述2
            ,param_desc3 -- 参数描述3
            ,param_system -- 归属系统
            ,create_time -- 创建日期
            ,update_time -- 更新日期
            ,del_flag -- 逻辑删除标志
            ,created_by -- 创建人
            ,updated_by -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_dic_param_op(
            pk_dic_param -- 流水号
            ,param_code -- 参数编码
            ,param_name -- 参数名称
            ,param_desc -- 描述
            ,param_order -- 显示顺序
            ,parent_code -- 父code
            ,field1 -- 保留字段
            ,crt_time -- 创建时间
            ,upd_time -- 最后修改时间
            ,obj_version -- 版本号
            ,flag_enable -- 是否有效
            ,usage_key -- 部门标识
            ,param_desc2 -- 参数描述2
            ,param_desc3 -- 参数描述3
            ,param_system -- 归属系统
            ,create_time -- 创建日期
            ,update_time -- 更新日期
            ,del_flag -- 逻辑删除标志
            ,created_by -- 创建人
            ,updated_by -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.pk_dic_param, o.pk_dic_param) as pk_dic_param -- 流水号
    ,nvl(n.param_code, o.param_code) as param_code -- 参数编码
    ,nvl(n.param_name, o.param_name) as param_name -- 参数名称
    ,nvl(n.param_desc, o.param_desc) as param_desc -- 描述
    ,nvl(n.param_order, o.param_order) as param_order -- 显示顺序
    ,nvl(n.parent_code, o.parent_code) as parent_code -- 父code
    ,nvl(n.field1, o.field1) as field1 -- 保留字段
    ,nvl(n.crt_time, o.crt_time) as crt_time -- 创建时间
    ,nvl(n.upd_time, o.upd_time) as upd_time -- 最后修改时间
    ,nvl(n.obj_version, o.obj_version) as obj_version -- 版本号
    ,nvl(n.flag_enable, o.flag_enable) as flag_enable -- 是否有效
    ,nvl(n.usage_key, o.usage_key) as usage_key -- 部门标识
    ,nvl(n.param_desc2, o.param_desc2) as param_desc2 -- 参数描述2
    ,nvl(n.param_desc3, o.param_desc3) as param_desc3 -- 参数描述3
    ,nvl(n.param_system, o.param_system) as param_system -- 归属系统
    ,nvl(n.create_time, o.create_time) as create_time -- 创建日期
    ,nvl(n.update_time, o.update_time) as update_time -- 更新日期
    ,nvl(n.del_flag, o.del_flag) as del_flag -- 逻辑删除标志
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 更新人
    ,case when
            n.pk_dic_param is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.pk_dic_param is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.pk_dic_param is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.pbms_tbl_dic_param_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.pbms_tbl_dic_param where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.pk_dic_param = n.pk_dic_param
where (
        o.pk_dic_param is null
    )
    or (
        n.pk_dic_param is null
    )
    or (
        o.param_code <> n.param_code
        or o.param_name <> n.param_name
        or o.param_desc <> n.param_desc
        or o.param_order <> n.param_order
        or o.parent_code <> n.parent_code
        or o.field1 <> n.field1
        or o.crt_time <> n.crt_time
        or o.upd_time <> n.upd_time
        or o.obj_version <> n.obj_version
        or o.flag_enable <> n.flag_enable
        or o.usage_key <> n.usage_key
        or o.param_desc2 <> n.param_desc2
        or o.param_desc3 <> n.param_desc3
        or o.param_system <> n.param_system
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.del_flag <> n.del_flag
        or o.created_by <> n.created_by
        or o.updated_by <> n.updated_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.pbms_tbl_dic_param_cl(
            pk_dic_param -- 流水号
            ,param_code -- 参数编码
            ,param_name -- 参数名称
            ,param_desc -- 描述
            ,param_order -- 显示顺序
            ,parent_code -- 父code
            ,field1 -- 保留字段
            ,crt_time -- 创建时间
            ,upd_time -- 最后修改时间
            ,obj_version -- 版本号
            ,flag_enable -- 是否有效
            ,usage_key -- 部门标识
            ,param_desc2 -- 参数描述2
            ,param_desc3 -- 参数描述3
            ,param_system -- 归属系统
            ,create_time -- 创建日期
            ,update_time -- 更新日期
            ,del_flag -- 逻辑删除标志
            ,created_by -- 创建人
            ,updated_by -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.pbms_tbl_dic_param_op(
            pk_dic_param -- 流水号
            ,param_code -- 参数编码
            ,param_name -- 参数名称
            ,param_desc -- 描述
            ,param_order -- 显示顺序
            ,parent_code -- 父code
            ,field1 -- 保留字段
            ,crt_time -- 创建时间
            ,upd_time -- 最后修改时间
            ,obj_version -- 版本号
            ,flag_enable -- 是否有效
            ,usage_key -- 部门标识
            ,param_desc2 -- 参数描述2
            ,param_desc3 -- 参数描述3
            ,param_system -- 归属系统
            ,create_time -- 创建日期
            ,update_time -- 更新日期
            ,del_flag -- 逻辑删除标志
            ,created_by -- 创建人
            ,updated_by -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.pk_dic_param -- 流水号
    ,o.param_code -- 参数编码
    ,o.param_name -- 参数名称
    ,o.param_desc -- 描述
    ,o.param_order -- 显示顺序
    ,o.parent_code -- 父code
    ,o.field1 -- 保留字段
    ,o.crt_time -- 创建时间
    ,o.upd_time -- 最后修改时间
    ,o.obj_version -- 版本号
    ,o.flag_enable -- 是否有效
    ,o.usage_key -- 部门标识
    ,o.param_desc2 -- 参数描述2
    ,o.param_desc3 -- 参数描述3
    ,o.param_system -- 归属系统
    ,o.create_time -- 创建日期
    ,o.update_time -- 更新日期
    ,o.del_flag -- 逻辑删除标志
    ,o.created_by -- 创建人
    ,o.updated_by -- 更新人
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
from ${iol_schema}.pbms_tbl_dic_param_bk o
    left join ${iol_schema}.pbms_tbl_dic_param_op n
        on
            o.pk_dic_param = n.pk_dic_param
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.pbms_tbl_dic_param_cl d
        on
            o.pk_dic_param = d.pk_dic_param
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.pbms_tbl_dic_param;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('pbms_tbl_dic_param') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.pbms_tbl_dic_param drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.pbms_tbl_dic_param add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.pbms_tbl_dic_param exchange partition p_${batch_date} with table ${iol_schema}.pbms_tbl_dic_param_cl;
alter table ${iol_schema}.pbms_tbl_dic_param exchange partition p_20991231 with table ${iol_schema}.pbms_tbl_dic_param_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.pbms_tbl_dic_param to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.pbms_tbl_dic_param_op purge;
drop table ${iol_schema}.pbms_tbl_dic_param_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.pbms_tbl_dic_param_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'pbms_tbl_dic_param',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
