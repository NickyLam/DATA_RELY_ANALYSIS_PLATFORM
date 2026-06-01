/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_bok_subject
CreateDate: 20180515
Logs:
    zjj 2018-05-15 新建脚本
*/

set timing on

-- 1.1 alter parallel
alter session force parallel query parallel 8;
alter session force parallel dml parallel 8;
-- alter session force parallel ddl parallel 8;

-- 2.1 create backup table
-- if backup table is exists, mean script if failed on last time
whenever sqlerror continue none ;
create table ${iol_schema}.fams_bok_subject_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_bok_subject
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_subject_op purge;
drop table ${iol_schema}.fams_bok_subject_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_bok_subject_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.fams_bok_subject where 0=1;

create table ${iol_schema}.fams_bok_subject_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.fams_bok_subject where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.fams_bok_subject_op(
        bookset_id -- 账套代码
        ,subject_no -- 科目号
        ,subject_name -- 科目名称
        ,fsubject_id -- 上级科目号
        ,bal_flag -- 余额方向
        ,subject_type -- 科目类型
        ,subject_level -- 科目级别
        ,acc_qua_flag -- 是否核算数量
        ,acc_int_flag -- 是否计息
        ,overdrawn_flag -- 是否允许透支
        ,gen_detsub_flag -- 是否生成四级科目
        ,base_subject_nature -- 基础科目性质
        ,inv_aim -- 投资目的
        ,sec_manage_acct_id -- 证券管理户代码
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
    n.bookset_id -- 账套代码
    ,n.subject_no -- 科目号
    ,n.subject_name -- 科目名称
    ,n.fsubject_id -- 上级科目号
    ,n.bal_flag -- 余额方向
    ,n.subject_type -- 科目类型
    ,n.subject_level -- 科目级别
    ,n.acc_qua_flag -- 是否核算数量
    ,n.acc_int_flag -- 是否计息
    ,n.overdrawn_flag -- 是否允许透支
    ,n.gen_detsub_flag -- 是否生成四级科目
    ,n.base_subject_nature -- 基础科目性质
    ,n.inv_aim -- 投资目的
    ,n.sec_manage_acct_id -- 证券管理户代码
    ,n.create_user -- 创建人
    ,n.create_dept -- 创建部门
    ,n.create_time -- 创建时间
    ,n.update_user -- 更新人
    ,n.update_time -- 更新时间
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_bok_subject_bk o
    right join (select * from ${itl_schema}.fams_bok_subject where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.bookset_id = n.bookset_id
            and o.subject_no = n.subject_no
where (
        o.bookset_id is null
        and o.subject_no is null
    )
    or (
        o.subject_name <> n.subject_name
        or o.fsubject_id <> n.fsubject_id
        or o.bal_flag <> n.bal_flag
        or o.subject_type <> n.subject_type
        or o.subject_level <> n.subject_level
        or o.acc_qua_flag <> n.acc_qua_flag
        or o.acc_int_flag <> n.acc_int_flag
        or o.overdrawn_flag <> n.overdrawn_flag
        or o.gen_detsub_flag <> n.gen_detsub_flag
        or o.base_subject_nature <> n.base_subject_nature
        or o.inv_aim <> n.inv_aim
        or o.sec_manage_acct_id <> n.sec_manage_acct_id
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
        into ${iol_schema}.fams_bok_subject_cl(
            bookset_id -- 账套代码
        ,subject_no -- 科目号
        ,subject_name -- 科目名称
        ,fsubject_id -- 上级科目号
        ,bal_flag -- 余额方向
        ,subject_type -- 科目类型
        ,subject_level -- 科目级别
        ,acc_qua_flag -- 是否核算数量
        ,acc_int_flag -- 是否计息
        ,overdrawn_flag -- 是否允许透支
        ,gen_detsub_flag -- 是否生成四级科目
        ,base_subject_nature -- 基础科目性质
        ,inv_aim -- 投资目的
        ,sec_manage_acct_id -- 证券管理户代码
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
        into ${iol_schema}.fams_bok_subject_op(
            bookset_id -- 账套代码
        ,subject_no -- 科目号
        ,subject_name -- 科目名称
        ,fsubject_id -- 上级科目号
        ,bal_flag -- 余额方向
        ,subject_type -- 科目类型
        ,subject_level -- 科目级别
        ,acc_qua_flag -- 是否核算数量
        ,acc_int_flag -- 是否计息
        ,overdrawn_flag -- 是否允许透支
        ,gen_detsub_flag -- 是否生成四级科目
        ,base_subject_nature -- 基础科目性质
        ,inv_aim -- 投资目的
        ,sec_manage_acct_id -- 证券管理户代码
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
    ,o.subject_no -- 科目号
    ,o.subject_name -- 科目名称
    ,o.fsubject_id -- 上级科目号
    ,o.bal_flag -- 余额方向
    ,o.subject_type -- 科目类型
    ,o.subject_level -- 科目级别
    ,o.acc_qua_flag -- 是否核算数量
    ,o.acc_int_flag -- 是否计息
    ,o.overdrawn_flag -- 是否允许透支
    ,o.gen_detsub_flag -- 是否生成四级科目
    ,o.base_subject_nature -- 基础科目性质
    ,o.inv_aim -- 投资目的
    ,o.sec_manage_acct_id -- 证券管理户代码
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
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,o.etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_bok_subject_bk o
    left join ${iol_schema}.fams_bok_subject_op n
        on
            o.bookset_id = n.bookset_id
            and o.subject_no = n.subject_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.fams_bok_subject;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('fams_bok_subject') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.fams_bok_subject drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.fams_bok_subject add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.fams_bok_subject exchange partition p_${batch_date} with table ${iol_schema}.fams_bok_subject_cl;
alter table ${iol_schema}.fams_bok_subject exchange partition p_20991231 with table ${iol_schema}.fams_bok_subject_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_bok_subject to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_bok_subject_op purge;
drop table ${iol_schema}.fams_bok_subject_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_bok_subject_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_bok_subject',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
