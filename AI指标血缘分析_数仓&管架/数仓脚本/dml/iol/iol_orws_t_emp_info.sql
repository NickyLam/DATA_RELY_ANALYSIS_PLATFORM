/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_orws_t_emp_info
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
create table ${iol_schema}.orws_t_emp_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.orws_t_emp_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_emp_info_op purge;
drop table ${iol_schema}.orws_t_emp_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.orws_t_emp_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_emp_info where 0=1;

create table ${iol_schema}.orws_t_emp_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.orws_t_emp_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_emp_info_cl(
            id -- 
            ,employeeinfo -- 
            ,name -- 
            ,sex -- 
            ,born_date -- 
            ,marriage -- 
            ,office_call -- 
            ,mobile -- 
            ,isservice -- 
            ,to_organ -- 
            ,emp_no -- 
            ,teller_no -- 
            ,job_date -- 
            ,become_date -- 
            ,emptype -- 
            ,status -- 
            ,dimission_date -- 
            ,position -- 
            ,teller_level -- 
            ,position_type -- 
            ,service_date -- 
            ,workroom -- 
            ,speciality -- 
            ,create_time -- 
            ,update_time -- 
            ,create_emp -- 
            ,update_emp -- 
            ,address -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_emp_info_op(
            id -- 
            ,employeeinfo -- 
            ,name -- 
            ,sex -- 
            ,born_date -- 
            ,marriage -- 
            ,office_call -- 
            ,mobile -- 
            ,isservice -- 
            ,to_organ -- 
            ,emp_no -- 
            ,teller_no -- 
            ,job_date -- 
            ,become_date -- 
            ,emptype -- 
            ,status -- 
            ,dimission_date -- 
            ,position -- 
            ,teller_level -- 
            ,position_type -- 
            ,service_date -- 
            ,workroom -- 
            ,speciality -- 
            ,create_time -- 
            ,update_time -- 
            ,create_emp -- 
            ,update_emp -- 
            ,address -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.employeeinfo, o.employeeinfo) as employeeinfo -- 
    ,nvl(n.name, o.name) as name -- 
    ,nvl(n.sex, o.sex) as sex -- 
    ,nvl(n.born_date, o.born_date) as born_date -- 
    ,nvl(n.marriage, o.marriage) as marriage -- 
    ,nvl(n.office_call, o.office_call) as office_call -- 
    ,nvl(n.mobile, o.mobile) as mobile -- 
    ,nvl(n.isservice, o.isservice) as isservice -- 
    ,nvl(n.to_organ, o.to_organ) as to_organ -- 
    ,nvl(n.emp_no, o.emp_no) as emp_no -- 
    ,nvl(n.teller_no, o.teller_no) as teller_no -- 
    ,nvl(n.job_date, o.job_date) as job_date -- 
    ,nvl(n.become_date, o.become_date) as become_date -- 
    ,nvl(n.emptype, o.emptype) as emptype -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.dimission_date, o.dimission_date) as dimission_date -- 
    ,nvl(n.position, o.position) as position -- 
    ,nvl(n.teller_level, o.teller_level) as teller_level -- 
    ,nvl(n.position_type, o.position_type) as position_type -- 
    ,nvl(n.service_date, o.service_date) as service_date -- 
    ,nvl(n.workroom, o.workroom) as workroom -- 
    ,nvl(n.speciality, o.speciality) as speciality -- 
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.create_emp, o.create_emp) as create_emp -- 
    ,nvl(n.update_emp, o.update_emp) as update_emp -- 
    ,nvl(n.address, o.address) as address -- 
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
from (select * from ${iol_schema}.orws_t_emp_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.orws_t_emp_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.employeeinfo <> n.employeeinfo
        or o.name <> n.name
        or o.sex <> n.sex
        or o.born_date <> n.born_date
        or o.marriage <> n.marriage
        or o.office_call <> n.office_call
        or o.mobile <> n.mobile
        or o.isservice <> n.isservice
        or o.to_organ <> n.to_organ
        or o.emp_no <> n.emp_no
        or o.teller_no <> n.teller_no
        or o.job_date <> n.job_date
        or o.become_date <> n.become_date
        or o.emptype <> n.emptype
        or o.status <> n.status
        or o.dimission_date <> n.dimission_date
        or o.position <> n.position
        or o.teller_level <> n.teller_level
        or o.position_type <> n.position_type
        or o.service_date <> n.service_date
        or o.workroom <> n.workroom
        or o.speciality <> n.speciality
        or o.create_time <> n.create_time
        or o.update_time <> n.update_time
        or o.create_emp <> n.create_emp
        or o.update_emp <> n.update_emp
        or o.address <> n.address
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.orws_t_emp_info_cl(
            id -- 
            ,employeeinfo -- 
            ,name -- 
            ,sex -- 
            ,born_date -- 
            ,marriage -- 
            ,office_call -- 
            ,mobile -- 
            ,isservice -- 
            ,to_organ -- 
            ,emp_no -- 
            ,teller_no -- 
            ,job_date -- 
            ,become_date -- 
            ,emptype -- 
            ,status -- 
            ,dimission_date -- 
            ,position -- 
            ,teller_level -- 
            ,position_type -- 
            ,service_date -- 
            ,workroom -- 
            ,speciality -- 
            ,create_time -- 
            ,update_time -- 
            ,create_emp -- 
            ,update_emp -- 
            ,address -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.orws_t_emp_info_op(
            id -- 
            ,employeeinfo -- 
            ,name -- 
            ,sex -- 
            ,born_date -- 
            ,marriage -- 
            ,office_call -- 
            ,mobile -- 
            ,isservice -- 
            ,to_organ -- 
            ,emp_no -- 
            ,teller_no -- 
            ,job_date -- 
            ,become_date -- 
            ,emptype -- 
            ,status -- 
            ,dimission_date -- 
            ,position -- 
            ,teller_level -- 
            ,position_type -- 
            ,service_date -- 
            ,workroom -- 
            ,speciality -- 
            ,create_time -- 
            ,update_time -- 
            ,create_emp -- 
            ,update_emp -- 
            ,address -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.employeeinfo -- 
    ,o.name -- 
    ,o.sex -- 
    ,o.born_date -- 
    ,o.marriage -- 
    ,o.office_call -- 
    ,o.mobile -- 
    ,o.isservice -- 
    ,o.to_organ -- 
    ,o.emp_no -- 
    ,o.teller_no -- 
    ,o.job_date -- 
    ,o.become_date -- 
    ,o.emptype -- 
    ,o.status -- 
    ,o.dimission_date -- 
    ,o.position -- 
    ,o.teller_level -- 
    ,o.position_type -- 
    ,o.service_date -- 
    ,o.workroom -- 
    ,o.speciality -- 
    ,o.create_time -- 
    ,o.update_time -- 
    ,o.create_emp -- 
    ,o.update_emp -- 
    ,o.address -- 
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
from ${iol_schema}.orws_t_emp_info_bk o
    left join ${iol_schema}.orws_t_emp_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.orws_t_emp_info_cl d
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
--truncate table ${iol_schema}.orws_t_emp_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('orws_t_emp_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.orws_t_emp_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.orws_t_emp_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.orws_t_emp_info exchange partition p_${batch_date} with table ${iol_schema}.orws_t_emp_info_cl;
alter table ${iol_schema}.orws_t_emp_info exchange partition p_20991231 with table ${iol_schema}.orws_t_emp_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.orws_t_emp_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.orws_t_emp_info_op purge;
drop table ${iol_schema}.orws_t_emp_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.orws_t_emp_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'orws_t_emp_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
