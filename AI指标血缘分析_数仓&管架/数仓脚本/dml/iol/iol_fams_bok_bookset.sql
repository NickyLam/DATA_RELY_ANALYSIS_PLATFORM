/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_bok_bookset
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
create table ${iol_schema}.fams_bok_bookset_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_bok_bookset;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_bookset_op purge;
drop table ${iol_schema}.fams_bok_bookset_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_bookset_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_bookset where 0=1;

create table ${iol_schema}.fams_bok_bookset_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_bookset where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_bookset_cl(
            bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,bookset_fullname -- 账套全称
            ,bookset_type -- 账套类别
            ,acct_mode -- 核算方式
            ,bok_spec_mode -- 特殊核算模型，普通分层核算、收益分层核算，普通情况为空
            ,acct_subject_id -- 核算主体代码
            ,acct_subject_type -- 核算主体类别
            ,standard_ccy -- 本位币
            ,bookset_id_tmpl -- 模板账套代码
            ,acct_standard -- 会计准则
            ,start_date -- 账套开始日
            ,end_date -- 账套结束日
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
        into ${iol_schema}.fams_bok_bookset_op(
            bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,bookset_fullname -- 账套全称
            ,bookset_type -- 账套类别
            ,acct_mode -- 核算方式
            ,bok_spec_mode -- 特殊核算模型，普通分层核算、收益分层核算，普通情况为空
            ,acct_subject_id -- 核算主体代码
            ,acct_subject_type -- 核算主体类别
            ,standard_ccy -- 本位币
            ,bookset_id_tmpl -- 模板账套代码
            ,acct_standard -- 会计准则
            ,start_date -- 账套开始日
            ,end_date -- 账套结束日
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
    ,nvl(n.bookset_name, o.bookset_name) as bookset_name -- 账套名称
    ,nvl(n.bookset_fullname, o.bookset_fullname) as bookset_fullname -- 账套全称
    ,nvl(n.bookset_type, o.bookset_type) as bookset_type -- 账套类别
    ,nvl(n.acct_mode, o.acct_mode) as acct_mode -- 核算方式
    ,nvl(n.bok_spec_mode, o.bok_spec_mode) as bok_spec_mode -- 特殊核算模型，普通分层核算、收益分层核算，普通情况为空
    ,nvl(n.acct_subject_id, o.acct_subject_id) as acct_subject_id -- 核算主体代码
    ,nvl(n.acct_subject_type, o.acct_subject_type) as acct_subject_type -- 核算主体类别
    ,nvl(n.standard_ccy, o.standard_ccy) as standard_ccy -- 本位币
    ,nvl(n.bookset_id_tmpl, o.bookset_id_tmpl) as bookset_id_tmpl -- 模板账套代码
    ,nvl(n.acct_standard, o.acct_standard) as acct_standard -- 会计准则
    ,nvl(n.start_date, o.start_date) as start_date -- 账套开始日
    ,nvl(n.end_date, o.end_date) as end_date -- 账套结束日
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.bookset_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bookset_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bookset_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_bok_bookset_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_bok_bookset where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bookset_id = n.bookset_id
where (
        o.bookset_id is null
    )
    or (
        n.bookset_id is null
    )
    or (
        o.bookset_name <> n.bookset_name
        or o.bookset_fullname <> n.bookset_fullname
        or o.bookset_type <> n.bookset_type
        or o.acct_mode <> n.acct_mode
        or o.bok_spec_mode <> n.bok_spec_mode
        or o.acct_subject_id <> n.acct_subject_id
        or o.acct_subject_type <> n.acct_subject_type
        or o.standard_ccy <> n.standard_ccy
        or o.bookset_id_tmpl <> n.bookset_id_tmpl
        or o.acct_standard <> n.acct_standard
        or o.start_date <> n.start_date
        or o.end_date <> n.end_date
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
        into ${iol_schema}.fams_bok_bookset_cl(
            bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,bookset_fullname -- 账套全称
            ,bookset_type -- 账套类别
            ,acct_mode -- 核算方式
            ,bok_spec_mode -- 特殊核算模型，普通分层核算、收益分层核算，普通情况为空
            ,acct_subject_id -- 核算主体代码
            ,acct_subject_type -- 核算主体类别
            ,standard_ccy -- 本位币
            ,bookset_id_tmpl -- 模板账套代码
            ,acct_standard -- 会计准则
            ,start_date -- 账套开始日
            ,end_date -- 账套结束日
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
        into ${iol_schema}.fams_bok_bookset_op(
            bookset_id -- 账套代码
            ,bookset_name -- 账套名称
            ,bookset_fullname -- 账套全称
            ,bookset_type -- 账套类别
            ,acct_mode -- 核算方式
            ,bok_spec_mode -- 特殊核算模型，普通分层核算、收益分层核算，普通情况为空
            ,acct_subject_id -- 核算主体代码
            ,acct_subject_type -- 核算主体类别
            ,standard_ccy -- 本位币
            ,bookset_id_tmpl -- 模板账套代码
            ,acct_standard -- 会计准则
            ,start_date -- 账套开始日
            ,end_date -- 账套结束日
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
    ,o.bookset_name -- 账套名称
    ,o.bookset_fullname -- 账套全称
    ,o.bookset_type -- 账套类别
    ,o.acct_mode -- 核算方式
    ,o.bok_spec_mode -- 特殊核算模型，普通分层核算、收益分层核算，普通情况为空
    ,o.acct_subject_id -- 核算主体代码
    ,o.acct_subject_type -- 核算主体类别
    ,o.standard_ccy -- 本位币
    ,o.bookset_id_tmpl -- 模板账套代码
    ,o.acct_standard -- 会计准则
    ,o.start_date -- 账套开始日
    ,o.end_date -- 账套结束日
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
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_bok_bookset_bk o
    left join ${iol_schema}.fams_bok_bookset_op n
        on
            o.bookset_id = n.bookset_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_bok_bookset_cl d
        on
            o.bookset_id = d.bookset_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_bok_bookset;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_bok_bookset exchange partition p_19000101 with table ${iol_schema}.fams_bok_bookset_cl;
alter table ${iol_schema}.fams_bok_bookset exchange partition p_20991231 with table ${iol_schema}.fams_bok_bookset_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_bok_bookset to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_bookset_op purge;
drop table ${iol_schema}.fams_bok_bookset_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_bok_bookset_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_bok_bookset',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
