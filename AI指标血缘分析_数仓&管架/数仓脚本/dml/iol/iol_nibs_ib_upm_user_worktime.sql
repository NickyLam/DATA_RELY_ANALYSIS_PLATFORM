/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nibs_ib_upm_user_worktime
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
create table ${iol_schema}.nibs_ib_upm_user_worktime_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nibs_ib_upm_user_worktime
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_upm_user_worktime_op purge;
drop table ${iol_schema}.nibs_ib_upm_user_worktime_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nibs_ib_upm_user_worktime_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_upm_user_worktime where 0=1;

create table ${iol_schema}.nibs_ib_upm_user_worktime_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nibs_ib_upm_user_worktime where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_upm_user_worktime_cl(
            usernum -- 柜员号
            ,branchnum -- 机构号
            ,logindatestr -- 登入日期 yyyymmdd
            ,logintime -- 登入时间 yyyymmdd hhmmss
            ,logouttime -- 登出时间 yyyymmdd hhmmss
            ,totaltimesecond -- 总时长 秒
            ,trantimesecond -- 交易时长 秒
            ,leveltimesecond -- 离柜时长 秒
            ,onlineleisuresecond -- 在线空闲时长 秒
            ,singoutfalg -- 是否进行进行了日终签退 0-否 1-是
            ,userstatus -- 柜员在登陆状态|o-在线 l-离线
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_upm_user_worktime_op(
            usernum -- 柜员号
            ,branchnum -- 机构号
            ,logindatestr -- 登入日期 yyyymmdd
            ,logintime -- 登入时间 yyyymmdd hhmmss
            ,logouttime -- 登出时间 yyyymmdd hhmmss
            ,totaltimesecond -- 总时长 秒
            ,trantimesecond -- 交易时长 秒
            ,leveltimesecond -- 离柜时长 秒
            ,onlineleisuresecond -- 在线空闲时长 秒
            ,singoutfalg -- 是否进行进行了日终签退 0-否 1-是
            ,userstatus -- 柜员在登陆状态|o-在线 l-离线
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.usernum, o.usernum) as usernum -- 柜员号
    ,nvl(n.branchnum, o.branchnum) as branchnum -- 机构号
    ,nvl(n.logindatestr, o.logindatestr) as logindatestr -- 登入日期 yyyymmdd
    ,nvl(n.logintime, o.logintime) as logintime -- 登入时间 yyyymmdd hhmmss
    ,nvl(n.logouttime, o.logouttime) as logouttime -- 登出时间 yyyymmdd hhmmss
    ,nvl(n.totaltimesecond, o.totaltimesecond) as totaltimesecond -- 总时长 秒
    ,nvl(n.trantimesecond, o.trantimesecond) as trantimesecond -- 交易时长 秒
    ,nvl(n.leveltimesecond, o.leveltimesecond) as leveltimesecond -- 离柜时长 秒
    ,nvl(n.onlineleisuresecond, o.onlineleisuresecond) as onlineleisuresecond -- 在线空闲时长 秒
    ,nvl(n.singoutfalg, o.singoutfalg) as singoutfalg -- 是否进行进行了日终签退 0-否 1-是
    ,nvl(n.userstatus, o.userstatus) as userstatus -- 柜员在登陆状态|o-在线 l-离线
    ,case when
            n.usernum is null
            and n.branchnum is null
            and n.logindatestr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.usernum is null
            and n.branchnum is null
            and n.logindatestr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.usernum is null
            and n.branchnum is null
            and n.logindatestr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.nibs_ib_upm_user_worktime_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nibs_ib_upm_user_worktime where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.usernum = n.usernum
            and o.branchnum = n.branchnum
            and o.logindatestr = n.logindatestr
where (
        o.usernum is null
        and o.branchnum is null
        and o.logindatestr is null
    )
    or (
        n.usernum is null
        and n.branchnum is null
        and n.logindatestr is null
    )
    or (
        o.logintime <> n.logintime
        or o.logouttime <> n.logouttime
        or o.totaltimesecond <> n.totaltimesecond
        or o.trantimesecond <> n.trantimesecond
        or o.leveltimesecond <> n.leveltimesecond
        or o.onlineleisuresecond <> n.onlineleisuresecond
        or o.singoutfalg <> n.singoutfalg
        or o.userstatus <> n.userstatus
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nibs_ib_upm_user_worktime_cl(
            usernum -- 柜员号
            ,branchnum -- 机构号
            ,logindatestr -- 登入日期 yyyymmdd
            ,logintime -- 登入时间 yyyymmdd hhmmss
            ,logouttime -- 登出时间 yyyymmdd hhmmss
            ,totaltimesecond -- 总时长 秒
            ,trantimesecond -- 交易时长 秒
            ,leveltimesecond -- 离柜时长 秒
            ,onlineleisuresecond -- 在线空闲时长 秒
            ,singoutfalg -- 是否进行进行了日终签退 0-否 1-是
            ,userstatus -- 柜员在登陆状态|o-在线 l-离线
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nibs_ib_upm_user_worktime_op(
            usernum -- 柜员号
            ,branchnum -- 机构号
            ,logindatestr -- 登入日期 yyyymmdd
            ,logintime -- 登入时间 yyyymmdd hhmmss
            ,logouttime -- 登出时间 yyyymmdd hhmmss
            ,totaltimesecond -- 总时长 秒
            ,trantimesecond -- 交易时长 秒
            ,leveltimesecond -- 离柜时长 秒
            ,onlineleisuresecond -- 在线空闲时长 秒
            ,singoutfalg -- 是否进行进行了日终签退 0-否 1-是
            ,userstatus -- 柜员在登陆状态|o-在线 l-离线
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.usernum -- 柜员号
    ,o.branchnum -- 机构号
    ,o.logindatestr -- 登入日期 yyyymmdd
    ,o.logintime -- 登入时间 yyyymmdd hhmmss
    ,o.logouttime -- 登出时间 yyyymmdd hhmmss
    ,o.totaltimesecond -- 总时长 秒
    ,o.trantimesecond -- 交易时长 秒
    ,o.leveltimesecond -- 离柜时长 秒
    ,o.onlineleisuresecond -- 在线空闲时长 秒
    ,o.singoutfalg -- 是否进行进行了日终签退 0-否 1-是
    ,o.userstatus -- 柜员在登陆状态|o-在线 l-离线
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
from ${iol_schema}.nibs_ib_upm_user_worktime_bk o
    left join ${iol_schema}.nibs_ib_upm_user_worktime_op n
        on
            o.usernum = n.usernum
            and o.branchnum = n.branchnum
            and o.logindatestr = n.logindatestr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nibs_ib_upm_user_worktime_cl d
        on
            o.usernum = d.usernum
            and o.branchnum = d.branchnum
            and o.logindatestr = d.logindatestr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.nibs_ib_upm_user_worktime;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('nibs_ib_upm_user_worktime') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.nibs_ib_upm_user_worktime drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.nibs_ib_upm_user_worktime add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.nibs_ib_upm_user_worktime exchange partition p_${batch_date} with table ${iol_schema}.nibs_ib_upm_user_worktime_cl;
alter table ${iol_schema}.nibs_ib_upm_user_worktime exchange partition p_20991231 with table ${iol_schema}.nibs_ib_upm_user_worktime_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nibs_ib_upm_user_worktime to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nibs_ib_upm_user_worktime_op purge;
drop table ${iol_schema}.nibs_ib_upm_user_worktime_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nibs_ib_upm_user_worktime_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nibs_ib_upm_user_worktime',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
