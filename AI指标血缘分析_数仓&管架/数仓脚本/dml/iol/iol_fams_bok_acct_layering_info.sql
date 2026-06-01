/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_bok_acct_layering_info
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
create table ${iol_schema}.fams_bok_acct_layering_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_bok_acct_layering_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_acct_layering_info_op purge;
drop table ${iol_schema}.fams_bok_acct_layering_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_acct_layering_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_acct_layering_info where 0=1;

create table ${iol_schema}.fams_bok_acct_layering_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_acct_layering_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_acct_layering_info_cl(
            bookset_id -- 账套代码
            ,layering_id -- 分层代码
            ,layering_name -- 分层名称
            ,f_layering_id -- 上层代码
            ,bok_detail_id -- 账务明细代码
            ,busi_id -- 业务明细代码
            ,busi_detail_type -- 业务明细类型
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,calendar_id -- 交易日历
            ,branch -- 分支序号
            ,lev -- 级别序号
            ,cur_lev -- 当前级别
            ,s_branch -- 下级最新序号
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_acct_layering_info_op(
            bookset_id -- 账套代码
            ,layering_id -- 分层代码
            ,layering_name -- 分层名称
            ,f_layering_id -- 上层代码
            ,bok_detail_id -- 账务明细代码
            ,busi_id -- 业务明细代码
            ,busi_detail_type -- 业务明细类型
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,calendar_id -- 交易日历
            ,branch -- 分支序号
            ,lev -- 级别序号
            ,cur_lev -- 当前级别
            ,s_branch -- 下级最新序号
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bookset_id, o.bookset_id) as bookset_id -- 账套代码
    ,nvl(n.layering_id, o.layering_id) as layering_id -- 分层代码
    ,nvl(n.layering_name, o.layering_name) as layering_name -- 分层名称
    ,nvl(n.f_layering_id, o.f_layering_id) as f_layering_id -- 上层代码
    ,nvl(n.bok_detail_id, o.bok_detail_id) as bok_detail_id -- 账务明细代码
    ,nvl(n.busi_id, o.busi_id) as busi_id -- 业务明细代码
    ,nvl(n.busi_detail_type, o.busi_detail_type) as busi_detail_type -- 业务明细类型
    ,nvl(n.vdate, o.vdate) as vdate -- 起息日
    ,nvl(n.mdate, o.mdate) as mdate -- 到期日
    ,nvl(n.calendar_id, o.calendar_id) as calendar_id -- 交易日历
    ,nvl(n.branch, o.branch) as branch -- 分支序号
    ,nvl(n.lev, o.lev) as lev -- 级别序号
    ,nvl(n.cur_lev, o.cur_lev) as cur_lev -- 当前级别
    ,nvl(n.s_branch, o.s_branch) as s_branch -- 下级最新序号
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.bookset_id is null
            and n.layering_id is null
            and n.busi_detail_type is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bookset_id is null
            and n.layering_id is null
            and n.busi_detail_type is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bookset_id is null
            and n.layering_id is null
            and n.busi_detail_type is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_bok_acct_layering_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_bok_acct_layering_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bookset_id = n.bookset_id
            and o.layering_id = n.layering_id
            and o.busi_detail_type = n.busi_detail_type
where (
        o.bookset_id is null
        and o.layering_id is null
        and o.busi_detail_type is null
    )
    or (
        n.bookset_id is null
        and n.layering_id is null
        and n.busi_detail_type is null
    )
    or (
        o.layering_name <> n.layering_name
        or o.f_layering_id <> n.f_layering_id
        or o.bok_detail_id <> n.bok_detail_id
        or o.busi_id <> n.busi_id
        or o.vdate <> n.vdate
        or o.mdate <> n.mdate
        or o.calendar_id <> n.calendar_id
        or o.branch <> n.branch
        or o.lev <> n.lev
        or o.cur_lev <> n.cur_lev
        or o.s_branch <> n.s_branch
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_acct_layering_info_cl(
            bookset_id -- 账套代码
            ,layering_id -- 分层代码
            ,layering_name -- 分层名称
            ,f_layering_id -- 上层代码
            ,bok_detail_id -- 账务明细代码
            ,busi_id -- 业务明细代码
            ,busi_detail_type -- 业务明细类型
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,calendar_id -- 交易日历
            ,branch -- 分支序号
            ,lev -- 级别序号
            ,cur_lev -- 当前级别
            ,s_branch -- 下级最新序号
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_acct_layering_info_op(
            bookset_id -- 账套代码
            ,layering_id -- 分层代码
            ,layering_name -- 分层名称
            ,f_layering_id -- 上层代码
            ,bok_detail_id -- 账务明细代码
            ,busi_id -- 业务明细代码
            ,busi_detail_type -- 业务明细类型
            ,vdate -- 起息日
            ,mdate -- 到期日
            ,calendar_id -- 交易日历
            ,branch -- 分支序号
            ,lev -- 级别序号
            ,cur_lev -- 当前级别
            ,s_branch -- 下级最新序号
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bookset_id -- 账套代码
    ,o.layering_id -- 分层代码
    ,o.layering_name -- 分层名称
    ,o.f_layering_id -- 上层代码
    ,o.bok_detail_id -- 账务明细代码
    ,o.busi_id -- 业务明细代码
    ,o.busi_detail_type -- 业务明细类型
    ,o.vdate -- 起息日
    ,o.mdate -- 到期日
    ,o.calendar_id -- 交易日历
    ,o.branch -- 分支序号
    ,o.lev -- 级别序号
    ,o.cur_lev -- 当前级别
    ,o.s_branch -- 下级最新序号
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
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
from ${iol_schema}.fams_bok_acct_layering_info_bk o
    left join ${iol_schema}.fams_bok_acct_layering_info_op n
        on
            o.bookset_id = n.bookset_id
            and o.layering_id = n.layering_id
            and o.busi_detail_type = n.busi_detail_type
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_bok_acct_layering_info_cl d
        on
            o.bookset_id = d.bookset_id
            and o.layering_id = d.layering_id
            and o.busi_detail_type = d.busi_detail_type
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_bok_acct_layering_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_bok_acct_layering_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_bok_acct_layering_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_bok_acct_layering_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_bok_acct_layering_info exchange partition p_${batch_date} with table ${iol_schema}.fams_bok_acct_layering_info_cl;
alter table ${iol_schema}.fams_bok_acct_layering_info exchange partition p_20991231 with table ${iol_schema}.fams_bok_acct_layering_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_bok_acct_layering_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_acct_layering_info_op purge;
drop table ${iol_schema}.fams_bok_acct_layering_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_bok_acct_layering_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_bok_acct_layering_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
