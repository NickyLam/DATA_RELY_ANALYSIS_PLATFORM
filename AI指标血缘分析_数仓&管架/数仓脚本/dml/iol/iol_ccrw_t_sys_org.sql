/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ccrw_t_sys_org
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
create table ${iol_schema}.ccrw_t_sys_org_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ccrw_t_sys_org
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccrw_t_sys_org_op purge;
drop table ${iol_schema}.ccrw_t_sys_org_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ccrw_t_sys_org_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccrw_t_sys_org where 0=1;

create table ${iol_schema}.ccrw_t_sys_org_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ccrw_t_sys_org where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccrw_t_sys_org_cl(
            org_id -- 机构ID
            ,org_name -- 机构名称
            ,org_abbr -- 机构简称
            ,brch_id -- 分行机构
            ,brch_name -- 分行机构名称
            ,parent_org_id -- 上级机构ID
            ,org_level -- 机构级次
            ,org_level_code -- 机构级次码
            ,sort_no -- 排序号
            ,remark -- 备注
            ,ver -- 数据版本
            ,org_type -- 机构类型0-全行，1-总行，2-分行，3-支行，4-团队
            ,short_name -- 机构简称
            ,is_law_org -- 是否法人联社,1=是、0=否
            ,law_org_id -- 所属法人机构号
            ,tel -- 部门机构电话
            ,addr -- 部门机构地址
            ,update_time -- 更新时间
            ,org_lng -- 经度
            ,org_lat -- 纬度
            ,is_show -- 显示标识
            ,is_statis -- 统计标识，1=总分支统计节点，2=团队，0非统计节点
            ,ccr_org -- 是否对公机构1=是，0=否
            ,org_status -- 机构状态
            ,is_protection -- 是否保护期 1-是,0-否
            ,protection_time_start -- 保护期开始日期
            ,protection_time_end -- 保护期结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccrw_t_sys_org_op(
            org_id -- 机构ID
            ,org_name -- 机构名称
            ,org_abbr -- 机构简称
            ,brch_id -- 分行机构
            ,brch_name -- 分行机构名称
            ,parent_org_id -- 上级机构ID
            ,org_level -- 机构级次
            ,org_level_code -- 机构级次码
            ,sort_no -- 排序号
            ,remark -- 备注
            ,ver -- 数据版本
            ,org_type -- 机构类型0-全行，1-总行，2-分行，3-支行，4-团队
            ,short_name -- 机构简称
            ,is_law_org -- 是否法人联社,1=是、0=否
            ,law_org_id -- 所属法人机构号
            ,tel -- 部门机构电话
            ,addr -- 部门机构地址
            ,update_time -- 更新时间
            ,org_lng -- 经度
            ,org_lat -- 纬度
            ,is_show -- 显示标识
            ,is_statis -- 统计标识，1=总分支统计节点，2=团队，0非统计节点
            ,ccr_org -- 是否对公机构1=是，0=否
            ,org_status -- 机构状态
            ,is_protection -- 是否保护期 1-是,0-否
            ,protection_time_start -- 保护期开始日期
            ,protection_time_end -- 保护期结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.org_id, o.org_id) as org_id -- 机构ID
    ,nvl(n.org_name, o.org_name) as org_name -- 机构名称
    ,nvl(n.org_abbr, o.org_abbr) as org_abbr -- 机构简称
    ,nvl(n.brch_id, o.brch_id) as brch_id -- 分行机构
    ,nvl(n.brch_name, o.brch_name) as brch_name -- 分行机构名称
    ,nvl(n.parent_org_id, o.parent_org_id) as parent_org_id -- 上级机构ID
    ,nvl(n.org_level, o.org_level) as org_level -- 机构级次
    ,nvl(n.org_level_code, o.org_level_code) as org_level_code -- 机构级次码
    ,nvl(n.sort_no, o.sort_no) as sort_no -- 排序号
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.ver, o.ver) as ver -- 数据版本
    ,nvl(n.org_type, o.org_type) as org_type -- 机构类型0-全行，1-总行，2-分行，3-支行，4-团队
    ,nvl(n.short_name, o.short_name) as short_name -- 机构简称
    ,nvl(n.is_law_org, o.is_law_org) as is_law_org -- 是否法人联社,1=是、0=否
    ,nvl(n.law_org_id, o.law_org_id) as law_org_id -- 所属法人机构号
    ,nvl(n.tel, o.tel) as tel -- 部门机构电话
    ,nvl(n.addr, o.addr) as addr -- 部门机构地址
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.org_lng, o.org_lng) as org_lng -- 经度
    ,nvl(n.org_lat, o.org_lat) as org_lat -- 纬度
    ,nvl(n.is_show, o.is_show) as is_show -- 显示标识
    ,nvl(n.is_statis, o.is_statis) as is_statis -- 统计标识，1=总分支统计节点，2=团队，0非统计节点
    ,nvl(n.ccr_org, o.ccr_org) as ccr_org -- 是否对公机构1=是，0=否
    ,nvl(n.org_status, o.org_status) as org_status -- 机构状态
    ,nvl(n.is_protection, o.is_protection) as is_protection -- 是否保护期 1-是,0-否
    ,nvl(n.protection_time_start, o.protection_time_start) as protection_time_start -- 保护期开始日期
    ,nvl(n.protection_time_end, o.protection_time_end) as protection_time_end -- 保护期结束日期
    ,case when
            n.org_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.org_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.org_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ccrw_t_sys_org_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ccrw_t_sys_org where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.org_id = n.org_id
where (
        o.org_id is null
    )
    or (
        n.org_id is null
    )
    or (
        o.org_name <> n.org_name
        or o.org_abbr <> n.org_abbr
        or o.brch_id <> n.brch_id
        or o.brch_name <> n.brch_name
        or o.parent_org_id <> n.parent_org_id
        or o.org_level <> n.org_level
        or o.org_level_code <> n.org_level_code
        or o.sort_no <> n.sort_no
        or o.remark <> n.remark
        or o.ver <> n.ver
        or o.org_type <> n.org_type
        or o.short_name <> n.short_name
        or o.is_law_org <> n.is_law_org
        or o.law_org_id <> n.law_org_id
        or o.tel <> n.tel
        or o.addr <> n.addr
        or o.update_time <> n.update_time
        or o.org_lng <> n.org_lng
        or o.org_lat <> n.org_lat
        or o.is_show <> n.is_show
        or o.is_statis <> n.is_statis
        or o.ccr_org <> n.ccr_org
        or o.org_status <> n.org_status
        or o.is_protection <> n.is_protection
        or o.protection_time_start <> n.protection_time_start
        or o.protection_time_end <> n.protection_time_end
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ccrw_t_sys_org_cl(
            org_id -- 机构ID
            ,org_name -- 机构名称
            ,org_abbr -- 机构简称
            ,brch_id -- 分行机构
            ,brch_name -- 分行机构名称
            ,parent_org_id -- 上级机构ID
            ,org_level -- 机构级次
            ,org_level_code -- 机构级次码
            ,sort_no -- 排序号
            ,remark -- 备注
            ,ver -- 数据版本
            ,org_type -- 机构类型0-全行，1-总行，2-分行，3-支行，4-团队
            ,short_name -- 机构简称
            ,is_law_org -- 是否法人联社,1=是、0=否
            ,law_org_id -- 所属法人机构号
            ,tel -- 部门机构电话
            ,addr -- 部门机构地址
            ,update_time -- 更新时间
            ,org_lng -- 经度
            ,org_lat -- 纬度
            ,is_show -- 显示标识
            ,is_statis -- 统计标识，1=总分支统计节点，2=团队，0非统计节点
            ,ccr_org -- 是否对公机构1=是，0=否
            ,org_status -- 机构状态
            ,is_protection -- 是否保护期 1-是,0-否
            ,protection_time_start -- 保护期开始日期
            ,protection_time_end -- 保护期结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ccrw_t_sys_org_op(
            org_id -- 机构ID
            ,org_name -- 机构名称
            ,org_abbr -- 机构简称
            ,brch_id -- 分行机构
            ,brch_name -- 分行机构名称
            ,parent_org_id -- 上级机构ID
            ,org_level -- 机构级次
            ,org_level_code -- 机构级次码
            ,sort_no -- 排序号
            ,remark -- 备注
            ,ver -- 数据版本
            ,org_type -- 机构类型0-全行，1-总行，2-分行，3-支行，4-团队
            ,short_name -- 机构简称
            ,is_law_org -- 是否法人联社,1=是、0=否
            ,law_org_id -- 所属法人机构号
            ,tel -- 部门机构电话
            ,addr -- 部门机构地址
            ,update_time -- 更新时间
            ,org_lng -- 经度
            ,org_lat -- 纬度
            ,is_show -- 显示标识
            ,is_statis -- 统计标识，1=总分支统计节点，2=团队，0非统计节点
            ,ccr_org -- 是否对公机构1=是，0=否
            ,org_status -- 机构状态
            ,is_protection -- 是否保护期 1-是,0-否
            ,protection_time_start -- 保护期开始日期
            ,protection_time_end -- 保护期结束日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.org_id -- 机构ID
    ,o.org_name -- 机构名称
    ,o.org_abbr -- 机构简称
    ,o.brch_id -- 分行机构
    ,o.brch_name -- 分行机构名称
    ,o.parent_org_id -- 上级机构ID
    ,o.org_level -- 机构级次
    ,o.org_level_code -- 机构级次码
    ,o.sort_no -- 排序号
    ,o.remark -- 备注
    ,o.ver -- 数据版本
    ,o.org_type -- 机构类型0-全行，1-总行，2-分行，3-支行，4-团队
    ,o.short_name -- 机构简称
    ,o.is_law_org -- 是否法人联社,1=是、0=否
    ,o.law_org_id -- 所属法人机构号
    ,o.tel -- 部门机构电话
    ,o.addr -- 部门机构地址
    ,o.update_time -- 更新时间
    ,o.org_lng -- 经度
    ,o.org_lat -- 纬度
    ,o.is_show -- 显示标识
    ,o.is_statis -- 统计标识，1=总分支统计节点，2=团队，0非统计节点
    ,o.ccr_org -- 是否对公机构1=是，0=否
    ,o.org_status -- 机构状态
    ,o.is_protection -- 是否保护期 1-是,0-否
    ,o.protection_time_start -- 保护期开始日期
    ,o.protection_time_end -- 保护期结束日期
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
from ${iol_schema}.ccrw_t_sys_org_bk o
    left join ${iol_schema}.ccrw_t_sys_org_op n
        on
            o.org_id = n.org_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ccrw_t_sys_org_cl d
        on
            o.org_id = d.org_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.ccrw_t_sys_org;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('ccrw_t_sys_org') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.ccrw_t_sys_org drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.ccrw_t_sys_org add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.ccrw_t_sys_org exchange partition p_${batch_date} with table ${iol_schema}.ccrw_t_sys_org_cl;
alter table ${iol_schema}.ccrw_t_sys_org exchange partition p_20991231 with table ${iol_schema}.ccrw_t_sys_org_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ccrw_t_sys_org to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ccrw_t_sys_org_op purge;
drop table ${iol_schema}.ccrw_t_sys_org_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ccrw_t_sys_org_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ccrw_t_sys_org',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
