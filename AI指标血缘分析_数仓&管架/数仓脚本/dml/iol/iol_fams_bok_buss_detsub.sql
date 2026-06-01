/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_bok_buss_detsub
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
create table ${iol_schema}.fams_bok_buss_detsub_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_bok_buss_detsub;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_buss_detsub_op purge;
drop table ${iol_schema}.fams_bok_buss_detsub_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_buss_detsub_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_buss_detsub where 0=1;

create table ${iol_schema}.fams_bok_buss_detsub_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_bok_buss_detsub where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_buss_detsub_cl(
            bookset_id -- 账套代码
            ,detail_subject_no -- 四级科目号
            ,detail_subject_name -- 四级科目名称
            ,fsubject_id -- 上级科目号
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,detail_subject_no_tail -- 四级科目尾号，不含三级科目
            ,detail_subname_tail -- 四级科目尾号名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_buss_detsub_op(
            bookset_id -- 账套代码
            ,detail_subject_no -- 四级科目号
            ,detail_subject_name -- 四级科目名称
            ,fsubject_id -- 上级科目号
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,detail_subject_no_tail -- 四级科目尾号，不含三级科目
            ,detail_subname_tail -- 四级科目尾号名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.bookset_id, o.bookset_id) as bookset_id -- 账套代码
    ,nvl(n.detail_subject_no, o.detail_subject_no) as detail_subject_no -- 四级科目号
    ,nvl(n.detail_subject_name, o.detail_subject_name) as detail_subject_name -- 四级科目名称
    ,nvl(n.fsubject_id, o.fsubject_id) as fsubject_id -- 上级科目号
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,nvl(n.detail_subject_no_tail, o.detail_subject_no_tail) as detail_subject_no_tail -- 四级科目尾号，不含三级科目
    ,nvl(n.detail_subname_tail, o.detail_subname_tail) as detail_subname_tail -- 四级科目尾号名称
    ,case when
            n.bookset_id is null
            and n.detail_subject_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.bookset_id is null
            and n.detail_subject_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.bookset_id is null
            and n.detail_subject_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_bok_buss_detsub_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_bok_buss_detsub where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bookset_id = n.bookset_id
            and o.detail_subject_no = n.detail_subject_no
where (
        o.bookset_id is null
        and o.detail_subject_no is null
    )
    or (
        n.bookset_id is null
        and n.detail_subject_no is null
    )
    or (
        o.detail_subject_name <> n.detail_subject_name
        or o.fsubject_id <> n.fsubject_id
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
        or o.detail_subject_no_tail <> n.detail_subject_no_tail
        or o.detail_subname_tail <> n.detail_subname_tail
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_bok_buss_detsub_cl(
            bookset_id -- 账套代码
            ,detail_subject_no -- 四级科目号
            ,detail_subject_name -- 四级科目名称
            ,fsubject_id -- 上级科目号
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,detail_subject_no_tail -- 四级科目尾号，不含三级科目
            ,detail_subname_tail -- 四级科目尾号名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_bok_buss_detsub_op(
            bookset_id -- 账套代码
            ,detail_subject_no -- 四级科目号
            ,detail_subject_name -- 四级科目名称
            ,fsubject_id -- 上级科目号
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,detail_subject_no_tail -- 四级科目尾号，不含三级科目
            ,detail_subname_tail -- 四级科目尾号名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.bookset_id -- 账套代码
    ,o.detail_subject_no -- 四级科目号
    ,o.detail_subject_name -- 四级科目名称
    ,o.fsubject_id -- 上级科目号
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.detail_subject_no_tail -- 四级科目尾号，不含三级科目
    ,o.detail_subname_tail -- 四级科目尾号名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_bok_buss_detsub_bk o
    left join ${iol_schema}.fams_bok_buss_detsub_op n
        on
            o.bookset_id = n.bookset_id
            and o.detail_subject_no = n.detail_subject_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_bok_buss_detsub_cl d
        on
            o.bookset_id = d.bookset_id
            and o.detail_subject_no = d.detail_subject_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_bok_buss_detsub;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_bok_buss_detsub exchange partition p_19000101 with table ${iol_schema}.fams_bok_buss_detsub_cl;
alter table ${iol_schema}.fams_bok_buss_detsub exchange partition p_20991231 with table ${iol_schema}.fams_bok_buss_detsub_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_bok_buss_detsub to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_buss_detsub_op purge;
drop table ${iol_schema}.fams_bok_buss_detsub_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_bok_buss_detsub_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_bok_buss_detsub',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
