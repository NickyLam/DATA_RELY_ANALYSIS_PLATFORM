/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_upm_menuview_info
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
create table ${iol_schema}.nibs_ib_upm_menuview_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nibs_ib_upm_menuview_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_upm_menuview_info_op purge;
drop table ${iol_schema}.nibs_ib_upm_menuview_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_menuview_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_upm_menuview_info where 0=1;

create table ${iol_schema}.nibs_ib_upm_menuview_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_upm_menuview_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_upm_menuview_info_cl(
            appnum -- 应用编码
            ,menuviewnum -- 菜单视图编号,当实体类型为T时不能为空
            ,menuviewname -- 菜单视图名称
            ,sortnum -- 排序号
            ,mainbranch -- 维护机构
            ,mainuser -- 维护用户
            ,maindate -- 维护日期
            ,maintime -- 维护时间
            ,activerule -- 应用规则
            ,entry -- 应用入口路径
            ,activityflag -- 是否启用【0-否 1-是】
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_upm_menuview_info_op(
            appnum -- 应用编码
            ,menuviewnum -- 菜单视图编号,当实体类型为T时不能为空
            ,menuviewname -- 菜单视图名称
            ,sortnum -- 排序号
            ,mainbranch -- 维护机构
            ,mainuser -- 维护用户
            ,maindate -- 维护日期
            ,maintime -- 维护时间
            ,activerule -- 应用规则
            ,entry -- 应用入口路径
            ,activityflag -- 是否启用【0-否 1-是】
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.appnum, o.appnum) as appnum -- 应用编码
    ,nvl(n.menuviewnum, o.menuviewnum) as menuviewnum -- 菜单视图编号,当实体类型为T时不能为空
    ,nvl(n.menuviewname, o.menuviewname) as menuviewname -- 菜单视图名称
    ,nvl(n.sortnum, o.sortnum) as sortnum -- 排序号
    ,nvl(n.mainbranch, o.mainbranch) as mainbranch -- 维护机构
    ,nvl(n.mainuser, o.mainuser) as mainuser -- 维护用户
    ,nvl(n.maindate, o.maindate) as maindate -- 维护日期
    ,nvl(n.maintime, o.maintime) as maintime -- 维护时间
    ,nvl(n.activerule, o.activerule) as activerule -- 应用规则
    ,nvl(n.entry, o.entry) as entry -- 应用入口路径
    ,nvl(n.activityflag, o.activityflag) as activityflag -- 是否启用【0-否 1-是】
    ,case when
            n.appnum is null
            and n.menuviewnum is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.appnum is null
            and n.menuviewnum is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.appnum is null
            and n.menuviewnum is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nibs_ib_upm_menuview_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nibs_ib_upm_menuview_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.appnum = n.appnum
            and o.menuviewnum = n.menuviewnum
where (
        o.appnum is null
        and o.menuviewnum is null
    )
    or (
        n.appnum is null
        and n.menuviewnum is null
    )
    or (
        o.menuviewname <> n.menuviewname
        or o.sortnum <> n.sortnum
        or o.mainbranch <> n.mainbranch
        or o.mainuser <> n.mainuser
        or o.maindate <> n.maindate
        or o.maintime <> n.maintime
        or o.activerule <> n.activerule
        or o.entry <> n.entry
        or o.activityflag <> n.activityflag
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_upm_menuview_info_cl(
            appnum -- 应用编码
            ,menuviewnum -- 菜单视图编号,当实体类型为T时不能为空
            ,menuviewname -- 菜单视图名称
            ,sortnum -- 排序号
            ,mainbranch -- 维护机构
            ,mainuser -- 维护用户
            ,maindate -- 维护日期
            ,maintime -- 维护时间
            ,activerule -- 应用规则
            ,entry -- 应用入口路径
            ,activityflag -- 是否启用【0-否 1-是】
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_upm_menuview_info_op(
            appnum -- 应用编码
            ,menuviewnum -- 菜单视图编号,当实体类型为T时不能为空
            ,menuviewname -- 菜单视图名称
            ,sortnum -- 排序号
            ,mainbranch -- 维护机构
            ,mainuser -- 维护用户
            ,maindate -- 维护日期
            ,maintime -- 维护时间
            ,activerule -- 应用规则
            ,entry -- 应用入口路径
            ,activityflag -- 是否启用【0-否 1-是】
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.appnum -- 应用编码
    ,o.menuviewnum -- 菜单视图编号,当实体类型为T时不能为空
    ,o.menuviewname -- 菜单视图名称
    ,o.sortnum -- 排序号
    ,o.mainbranch -- 维护机构
    ,o.mainuser -- 维护用户
    ,o.maindate -- 维护日期
    ,o.maintime -- 维护时间
    ,o.activerule -- 应用规则
    ,o.entry -- 应用入口路径
    ,o.activityflag -- 是否启用【0-否 1-是】
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
from ${iol_schema}.nibs_ib_upm_menuview_info_bk o
    left join ${iol_schema}.nibs_ib_upm_menuview_info_op n
        on
            o.appnum = n.appnum
            and o.menuviewnum = n.menuviewnum
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nibs_ib_upm_menuview_info_cl d
        on
            o.appnum = d.appnum
            and o.menuviewnum = d.menuviewnum
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nibs_ib_upm_menuview_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nibs_ib_upm_menuview_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nibs_ib_upm_menuview_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nibs_ib_upm_menuview_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nibs_ib_upm_menuview_info exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_upm_menuview_info_cl;
alter table ${iol_schema}.nibs_ib_upm_menuview_info exchange partition p_20991231 with table ${iol_schema}.nibs_ib_upm_menuview_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_upm_menuview_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_upm_menuview_info_op purge;
drop table ${iol_schema}.nibs_ib_upm_menuview_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nibs_ib_upm_menuview_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_upm_menuview_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
