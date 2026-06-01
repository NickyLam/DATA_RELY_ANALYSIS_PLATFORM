/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_temp_info
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
create table ${iol_schema}.orws_temp_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orws_temp_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_temp_info_op purge;
drop table ${iol_schema}.orws_temp_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_temp_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_temp_info where 0=1;

create table ${iol_schema}.orws_temp_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_temp_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_temp_info_cl(
            id -- 
            ,name -- 
            ,employee_no -- 
            ,sex -- 
            ,folk -- 
            ,native_place -- 
            ,born_date -- 
            ,address -- 
            ,edu_degree -- 
            ,is_fulltime -- 
            ,employeement_type -- 
            ,clerk_level -- 
            ,status -- 
            ,mobile -- 
            ,organ_id -- 
            ,organ_name -- 
            ,organ_number -- 
            ,to_organ -- 
            ,to_group -- 
            ,employee_id -- 
            ,become_date -- 
            ,create_time -- 
            ,update_time -- 
            ,create_user_id -- 
            ,update_user_id -- 
            ,email -- 
            ,office_call -- 
            ,emp_no -- 
            ,ismain -- 
            ,belong_emp_no -- 
            ,external_status -- 
            ,domainid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_temp_info_op(
            id -- 
            ,name -- 
            ,employee_no -- 
            ,sex -- 
            ,folk -- 
            ,native_place -- 
            ,born_date -- 
            ,address -- 
            ,edu_degree -- 
            ,is_fulltime -- 
            ,employeement_type -- 
            ,clerk_level -- 
            ,status -- 
            ,mobile -- 
            ,organ_id -- 
            ,organ_name -- 
            ,organ_number -- 
            ,to_organ -- 
            ,to_group -- 
            ,employee_id -- 
            ,become_date -- 
            ,create_time -- 
            ,update_time -- 
            ,create_user_id -- 
            ,update_user_id -- 
            ,email -- 
            ,office_call -- 
            ,emp_no -- 
            ,ismain -- 
            ,belong_emp_no -- 
            ,external_status -- 
            ,domainid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.name, o.name) as name -- 
    ,nvl(n.employee_no, o.employee_no) as employee_no -- 
    ,nvl(n.sex, o.sex) as sex -- 
    ,nvl(n.folk, o.folk) as folk -- 
    ,nvl(n.native_place, o.native_place) as native_place -- 
    ,nvl(n.born_date, o.born_date) as born_date -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.edu_degree, o.edu_degree) as edu_degree -- 
    ,nvl(n.is_fulltime, o.is_fulltime) as is_fulltime -- 
    ,nvl(n.employeement_type, o.employeement_type) as employeement_type -- 
    ,nvl(n.clerk_level, o.clerk_level) as clerk_level -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.mobile, o.mobile) as mobile -- 
    ,nvl(n.organ_id, o.organ_id) as organ_id -- 
    ,nvl(n.organ_name, o.organ_name) as organ_name -- 
    ,nvl(n.organ_number, o.organ_number) as organ_number -- 
    ,nvl(n.to_organ, o.to_organ) as to_organ -- 
    ,nvl(n.to_group, o.to_group) as to_group -- 
    ,nvl(n.employee_id, o.employee_id) as employee_id -- 
    ,nvl(n.become_date, o.become_date) as become_date -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.create_user_id, o.create_user_id) as create_user_id -- 
    ,nvl(n.update_user_id, o.update_user_id) as update_user_id -- 
    ,nvl(n.email, o.email) as email -- 
    ,nvl(n.office_call, o.office_call) as office_call -- 
    ,nvl(n.emp_no, o.emp_no) as emp_no -- 
    ,nvl(n.ismain, o.ismain) as ismain -- 
    ,nvl(n.belong_emp_no, o.belong_emp_no) as belong_emp_no -- 
    ,nvl(n.external_status, o.external_status) as external_status -- 
    ,nvl(n.domainid, o.domainid) as domainid -- 
    ,case when
            n.id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.orws_temp_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orws_temp_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.name <> n.name
        or o.employee_no <> n.employee_no
        or o.sex <> n.sex
        or o.folk <> n.folk
        or o.native_place <> n.native_place
        or o.born_date <> n.born_date
        or o.address <> n.address
        or o.edu_degree <> n.edu_degree
        or o.is_fulltime <> n.is_fulltime
        or o.employeement_type <> n.employeement_type
        or o.clerk_level <> n.clerk_level
        or o.status <> n.status
        or o.mobile <> n.mobile
        or o.organ_id <> n.organ_id
        or o.organ_name <> n.organ_name
        or o.organ_number <> n.organ_number
        or o.to_organ <> n.to_organ
        or o.to_group <> n.to_group
        or o.employee_id <> n.employee_id
        or o.become_date <> n.become_date
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.create_user_id <> n.create_user_id
        or o.update_user_id <> n.update_user_id
        or o.email <> n.email
        or o.office_call <> n.office_call
        or o.emp_no <> n.emp_no
        or o.ismain <> n.ismain
        or o.belong_emp_no <> n.belong_emp_no
        or o.external_status <> n.external_status
        or o.domainid <> n.domainid
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_temp_info_cl(
            id -- 
            ,name -- 
            ,employee_no -- 
            ,sex -- 
            ,folk -- 
            ,native_place -- 
            ,born_date -- 
            ,address -- 
            ,edu_degree -- 
            ,is_fulltime -- 
            ,employeement_type -- 
            ,clerk_level -- 
            ,status -- 
            ,mobile -- 
            ,organ_id -- 
            ,organ_name -- 
            ,organ_number -- 
            ,to_organ -- 
            ,to_group -- 
            ,employee_id -- 
            ,become_date -- 
            ,create_time -- 
            ,update_time -- 
            ,create_user_id -- 
            ,update_user_id -- 
            ,email -- 
            ,office_call -- 
            ,emp_no -- 
            ,ismain -- 
            ,belong_emp_no -- 
            ,external_status -- 
            ,domainid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_temp_info_op(
            id -- 
            ,name -- 
            ,employee_no -- 
            ,sex -- 
            ,folk -- 
            ,native_place -- 
            ,born_date -- 
            ,address -- 
            ,edu_degree -- 
            ,is_fulltime -- 
            ,employeement_type -- 
            ,clerk_level -- 
            ,status -- 
            ,mobile -- 
            ,organ_id -- 
            ,organ_name -- 
            ,organ_number -- 
            ,to_organ -- 
            ,to_group -- 
            ,employee_id -- 
            ,become_date -- 
            ,create_time -- 
            ,update_time -- 
            ,create_user_id -- 
            ,update_user_id -- 
            ,email -- 
            ,office_call -- 
            ,emp_no -- 
            ,ismain -- 
            ,belong_emp_no -- 
            ,external_status -- 
            ,domainid -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.name -- 
    ,o.employee_no -- 
    ,o.sex -- 
    ,o.folk -- 
    ,o.native_place -- 
    ,o.born_date -- 
    ,o.address -- 
    ,o.edu_degree -- 
    ,o.is_fulltime -- 
    ,o.employeement_type -- 
    ,o.clerk_level -- 
    ,o.status -- 
    ,o.mobile -- 
    ,o.organ_id -- 
    ,o.organ_name -- 
    ,o.organ_number -- 
    ,o.to_organ -- 
    ,o.to_group -- 
    ,o.employee_id -- 
    ,o.become_date -- 
    ,o.create_time -- 
    ,o.update_time -- 
    ,o.create_user_id -- 
    ,o.update_user_id -- 
    ,o.email -- 
    ,o.office_call -- 
    ,o.emp_no -- 
    ,o.ismain -- 
    ,o.belong_emp_no -- 
    ,o.external_status -- 
    ,o.domainid -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.orws_temp_info_bk o
    left join ${iol_schema}.orws_temp_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orws_temp_info_cl d
        on
            o.id = d.id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.orws_temp_info;

-- 4.2 exchange partition
alter table ${iol_schema}.orws_temp_info exchange partition p_19000101 with table ${iol_schema}.orws_temp_info_cl;
alter table ${iol_schema}.orws_temp_info exchange partition p_20991231 with table ${iol_schema}.orws_temp_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orws_temp_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_temp_info_op purge;
drop table ${iol_schema}.orws_temp_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orws_temp_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orws_temp_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
