/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_svbs_tl9_resourcebasic
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
create table ${iol_schema}.svbs_tl9_resourcebasic_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.svbs_tl9_resourcebasic
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svbs_tl9_resourcebasic_op purge;
drop table ${iol_schema}.svbs_tl9_resourcebasic_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.svbs_tl9_resourcebasic_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.svbs_tl9_resourcebasic where 0=1;

create table ${iol_schema}.svbs_tl9_resourcebasic_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.svbs_tl9_resourcebasic where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svbs_tl9_resourcebasic_cl(
            resourceid -- 资源ID
            ,parent -- 父级资源ID
            ,resourcename -- 资源名称
            ,accesscontrol -- 访问控制
            ,updatetime -- 更新日期
            ,createtime -- 创建日期
            ,recordstatus -- 记录状态
            ,resourcetypeid -- 资源类型ID
            ,icon -- 图标
            ,catalog_id -- 分类ID
            ,specialflag -- 特别ID
            ,showflag -- 显示标志
            ,systemid -- 系统标识
            ,url -- 资源路径
            ,given_name -- 资源英文名称
            ,details -- 详情
            ,sort_no -- 排序序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svbs_tl9_resourcebasic_op(
            resourceid -- 资源ID
            ,parent -- 父级资源ID
            ,resourcename -- 资源名称
            ,accesscontrol -- 访问控制
            ,updatetime -- 更新日期
            ,createtime -- 创建日期
            ,recordstatus -- 记录状态
            ,resourcetypeid -- 资源类型ID
            ,icon -- 图标
            ,catalog_id -- 分类ID
            ,specialflag -- 特别ID
            ,showflag -- 显示标志
            ,systemid -- 系统标识
            ,url -- 资源路径
            ,given_name -- 资源英文名称
            ,details -- 详情
            ,sort_no -- 排序序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.resourceid, o.resourceid) as resourceid -- 资源ID
    ,nvl(n.parent, o.parent) as parent -- 父级资源ID
    ,nvl(n.resourcename, o.resourcename) as resourcename -- 资源名称
    ,nvl(n.accesscontrol, o.accesscontrol) as accesscontrol -- 访问控制
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新日期
    ,nvl(n.createtime, o.createtime) as createtime -- 创建日期
    ,nvl(n.recordstatus, o.recordstatus) as recordstatus -- 记录状态
    ,nvl(n.resourcetypeid, o.resourcetypeid) as resourcetypeid -- 资源类型ID
    ,nvl(n.icon, o.icon) as icon -- 图标
    ,nvl(n.catalog_id, o.catalog_id) as catalog_id -- 分类ID
    ,nvl(n.specialflag, o.specialflag) as specialflag -- 特别ID
    ,nvl(n.showflag, o.showflag) as showflag -- 显示标志
    ,nvl(n.systemid, o.systemid) as systemid -- 系统标识
    ,nvl(n.url, o.url) as url -- 资源路径
    ,nvl(n.given_name, o.given_name) as given_name -- 资源英文名称
    ,nvl(n.details, o.details) as details -- 详情
    ,nvl(n.sort_no, o.sort_no) as sort_no -- 排序序号
    ,case when
            n.resourceid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.resourceid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.resourceid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.svbs_tl9_resourcebasic_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.svbs_tl9_resourcebasic where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.resourceid = n.resourceid
where (
        o.resourceid is null
    )
    or (
        n.resourceid is null
    )
    or (
        o.parent <> n.parent
        or o.resourcename <> n.resourcename
        or o.accesscontrol <> n.accesscontrol
        or o.updatetime <> n.updatetime
        or o.createtime <> n.createtime
        or o.recordstatus <> n.recordstatus
        or o.resourcetypeid <> n.resourcetypeid
        or o.icon <> n.icon
        or o.catalog_id <> n.catalog_id
        or o.specialflag <> n.specialflag
        or o.showflag <> n.showflag
        or o.systemid <> n.systemid
        or o.url <> n.url
        or o.given_name <> n.given_name
        or o.details <> n.details
        or o.sort_no <> n.sort_no
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.svbs_tl9_resourcebasic_cl(
            resourceid -- 资源ID
            ,parent -- 父级资源ID
            ,resourcename -- 资源名称
            ,accesscontrol -- 访问控制
            ,updatetime -- 更新日期
            ,createtime -- 创建日期
            ,recordstatus -- 记录状态
            ,resourcetypeid -- 资源类型ID
            ,icon -- 图标
            ,catalog_id -- 分类ID
            ,specialflag -- 特别ID
            ,showflag -- 显示标志
            ,systemid -- 系统标识
            ,url -- 资源路径
            ,given_name -- 资源英文名称
            ,details -- 详情
            ,sort_no -- 排序序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.svbs_tl9_resourcebasic_op(
            resourceid -- 资源ID
            ,parent -- 父级资源ID
            ,resourcename -- 资源名称
            ,accesscontrol -- 访问控制
            ,updatetime -- 更新日期
            ,createtime -- 创建日期
            ,recordstatus -- 记录状态
            ,resourcetypeid -- 资源类型ID
            ,icon -- 图标
            ,catalog_id -- 分类ID
            ,specialflag -- 特别ID
            ,showflag -- 显示标志
            ,systemid -- 系统标识
            ,url -- 资源路径
            ,given_name -- 资源英文名称
            ,details -- 详情
            ,sort_no -- 排序序号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.resourceid -- 资源ID
    ,o.parent -- 父级资源ID
    ,o.resourcename -- 资源名称
    ,o.accesscontrol -- 访问控制
    ,o.updatetime -- 更新日期
    ,o.createtime -- 创建日期
    ,o.recordstatus -- 记录状态
    ,o.resourcetypeid -- 资源类型ID
    ,o.icon -- 图标
    ,o.catalog_id -- 分类ID
    ,o.specialflag -- 特别ID
    ,o.showflag -- 显示标志
    ,o.systemid -- 系统标识
    ,o.url -- 资源路径
    ,o.given_name -- 资源英文名称
    ,o.details -- 详情
    ,o.sort_no -- 排序序号
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
from ${iol_schema}.svbs_tl9_resourcebasic_bk o
    left join ${iol_schema}.svbs_tl9_resourcebasic_op n
        on
            o.resourceid = n.resourceid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.svbs_tl9_resourcebasic_cl d
        on
            o.resourceid = d.resourceid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.svbs_tl9_resourcebasic;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('svbs_tl9_resourcebasic') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.svbs_tl9_resourcebasic drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.svbs_tl9_resourcebasic add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.svbs_tl9_resourcebasic exchange partition p_${batch_date} with table ${iol_schema}.svbs_tl9_resourcebasic_cl;
alter table ${iol_schema}.svbs_tl9_resourcebasic exchange partition p_20991231 with table ${iol_schema}.svbs_tl9_resourcebasic_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.svbs_tl9_resourcebasic to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.svbs_tl9_resourcebasic_op purge;
drop table ${iol_schema}.svbs_tl9_resourcebasic_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.svbs_tl9_resourcebasic_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'svbs_tl9_resourcebasic',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
