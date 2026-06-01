/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_tsys_user
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
create table ${iol_schema}.ifms_tsys_user_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_tsys_user;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tsys_user_op purge;
drop table ${iol_schema}.ifms_tsys_user_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_tsys_user_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tsys_user where 0=1;

create table ${iol_schema}.ifms_tsys_user_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_tsys_user where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tsys_user_cl(
            user_id -- 
            ,branch_code -- 
            ,dep_code -- 
            ,user_name -- 
            ,user_pwd -- 
            ,user_type -- 
            ,user_status -- 
            ,lock_status -- 
            ,create_date -- 
            ,modify_date -- 
            ,pass_modify_date -- 
            ,remark -- 
            ,ext_field_1 -- 
            ,ext_field_2 -- 
            ,ext_field_3 -- 
            ,ext_field_4 -- 
            ,ext_field_5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tsys_user_op(
            user_id -- 
            ,branch_code -- 
            ,dep_code -- 
            ,user_name -- 
            ,user_pwd -- 
            ,user_type -- 
            ,user_status -- 
            ,lock_status -- 
            ,create_date -- 
            ,modify_date -- 
            ,pass_modify_date -- 
            ,remark -- 
            ,ext_field_1 -- 
            ,ext_field_2 -- 
            ,ext_field_3 -- 
            ,ext_field_4 -- 
            ,ext_field_5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.user_id, o.user_id) as user_id -- 
    ,nvl(n.branch_code, o.branch_code) as branch_code -- 
    ,nvl(n.dep_code, o.dep_code) as dep_code -- 
    ,nvl(n.user_name, o.user_name) as user_name -- 
    ,nvl(n.user_pwd, o.user_pwd) as user_pwd -- 
    ,nvl(n.user_type, o.user_type) as user_type -- 
    ,nvl(n.user_status, o.user_status) as user_status -- 
    ,nvl(n.lock_status, o.lock_status) as lock_status -- 
    ,nvl(n.create_date, o.create_date) as create_date -- 
    ,nvl(n.modify_date, o.modify_date) as modify_date -- 
    ,nvl(n.pass_modify_date, o.pass_modify_date) as pass_modify_date -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.ext_field_1, o.ext_field_1) as ext_field_1 -- 
    ,nvl(n.ext_field_2, o.ext_field_2) as ext_field_2 -- 
    ,nvl(n.ext_field_3, o.ext_field_3) as ext_field_3 -- 
    ,nvl(n.ext_field_4, o.ext_field_4) as ext_field_4 -- 
    ,nvl(n.ext_field_5, o.ext_field_5) as ext_field_5 -- 
    ,case when
            n.user_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.user_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.user_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_tsys_user_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_tsys_user where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.user_id = n.user_id
where (
        o.user_id is null
    )
    or (
        n.user_id is null
    )
    or (
        o.branch_code <> n.branch_code
        or o.dep_code <> n.dep_code
        or o.user_name <> n.user_name
        or o.user_pwd <> n.user_pwd
        or o.user_type <> n.user_type
        or o.user_status <> n.user_status
        or o.lock_status <> n.lock_status
        or o.create_date <> n.create_date
        or o.modify_date <> n.modify_date
        or o.pass_modify_date <> n.pass_modify_date
        or o.remark <> n.remark
        or o.ext_field_1 <> n.ext_field_1
        or o.ext_field_2 <> n.ext_field_2
        or o.ext_field_3 <> n.ext_field_3
        or o.ext_field_4 <> n.ext_field_4
        or o.ext_field_5 <> n.ext_field_5
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_tsys_user_cl(
            user_id -- 
            ,branch_code -- 
            ,dep_code -- 
            ,user_name -- 
            ,user_pwd -- 
            ,user_type -- 
            ,user_status -- 
            ,lock_status -- 
            ,create_date -- 
            ,modify_date -- 
            ,pass_modify_date -- 
            ,remark -- 
            ,ext_field_1 -- 
            ,ext_field_2 -- 
            ,ext_field_3 -- 
            ,ext_field_4 -- 
            ,ext_field_5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_tsys_user_op(
            user_id -- 
            ,branch_code -- 
            ,dep_code -- 
            ,user_name -- 
            ,user_pwd -- 
            ,user_type -- 
            ,user_status -- 
            ,lock_status -- 
            ,create_date -- 
            ,modify_date -- 
            ,pass_modify_date -- 
            ,remark -- 
            ,ext_field_1 -- 
            ,ext_field_2 -- 
            ,ext_field_3 -- 
            ,ext_field_4 -- 
            ,ext_field_5 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.user_id -- 
    ,o.branch_code -- 
    ,o.dep_code -- 
    ,o.user_name -- 
    ,o.user_pwd -- 
    ,o.user_type -- 
    ,o.user_status -- 
    ,o.lock_status -- 
    ,o.create_date -- 
    ,o.modify_date -- 
    ,o.pass_modify_date -- 
    ,o.remark -- 
    ,o.ext_field_1 -- 
    ,o.ext_field_2 -- 
    ,o.ext_field_3 -- 
    ,o.ext_field_4 -- 
    ,o.ext_field_5 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_tsys_user_bk o
    left join ${iol_schema}.ifms_tsys_user_op n
        on
            o.user_id = n.user_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_tsys_user_cl d
        on
            o.user_id = d.user_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_tsys_user;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_tsys_user exchange partition p_19000101 with table ${iol_schema}.ifms_tsys_user_cl;
alter table ${iol_schema}.ifms_tsys_user exchange partition p_20991231 with table ${iol_schema}.ifms_tsys_user_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_tsys_user to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_tsys_user_op purge;
drop table ${iol_schema}.ifms_tsys_user_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_tsys_user_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_tsys_user',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
