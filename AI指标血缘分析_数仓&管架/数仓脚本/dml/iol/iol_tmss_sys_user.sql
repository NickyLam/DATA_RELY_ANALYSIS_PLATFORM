/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tmss_sys_user
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
create table ${iol_schema}.tmss_sys_user_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tmss_sys_user
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tmss_sys_user_op purge;
drop table ${iol_schema}.tmss_sys_user_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tmss_sys_user_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tmss_sys_user where 0=1;

create table ${iol_schema}.tmss_sys_user_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tmss_sys_user where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tmss_sys_user_cl(
            id -- 
            ,begin_use_time -- 
            ,code -- 
            ,email -- 
            ,is_admin -- 
            ,login_name -- 
            ,password -- 
            ,phone -- 
            ,salt -- 
            ,sex -- 
            ,status -- 
            ,username -- 
            ,corp_id -- 
            ,user_cadn -- 
            ,login_type -- 用户登录方式 ：0用户密码方式，1证书认证＋用户密码方式，2证书认证方式
            ,create_time -- 
            ,create_by -- 
            ,update_time -- 
            ,update_by -- 
            ,show_report -- 
            ,sys_skin -- 
            ,tenant_id -- 租户ID
            ,hx_wy_user_id -- 华兴网银用户id
            ,cert_code -- 操作员证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tmss_sys_user_op(
            id -- 
            ,begin_use_time -- 
            ,code -- 
            ,email -- 
            ,is_admin -- 
            ,login_name -- 
            ,password -- 
            ,phone -- 
            ,salt -- 
            ,sex -- 
            ,status -- 
            ,username -- 
            ,corp_id -- 
            ,user_cadn -- 
            ,login_type -- 用户登录方式 ：0用户密码方式，1证书认证＋用户密码方式，2证书认证方式
            ,create_time -- 
            ,create_by -- 
            ,update_time -- 
            ,update_by -- 
            ,show_report -- 
            ,sys_skin -- 
            ,tenant_id -- 租户ID
            ,hx_wy_user_id -- 华兴网银用户id
            ,cert_code -- 操作员证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.begin_use_time, o.begin_use_time) as begin_use_time -- 
    ,nvl(n.code, o.code) as code -- 
    ,nvl(n.email, o.email) as email -- 
    ,nvl(n.is_admin, o.is_admin) as is_admin -- 
    ,nvl(n.login_name, o.login_name) as login_name -- 
    ,nvl(n.password, o.password) as password -- 
    ,nvl(n.phone, o.phone) as phone -- 
    ,nvl(n.salt, o.salt) as salt -- 
    ,nvl(n.sex, o.sex) as sex -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.username, o.username) as username -- 
    ,nvl(n.corp_id, o.corp_id) as corp_id -- 
    ,nvl(n.user_cadn, o.user_cadn) as user_cadn -- 
    ,nvl(n.login_type, o.login_type) as login_type -- 用户登录方式 ：0用户密码方式，1证书认证＋用户密码方式，2证书认证方式
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.create_by, o.create_by) as create_by -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.update_by, o.update_by) as update_by -- 
    ,nvl(n.show_report, o.show_report) as show_report -- 
    ,nvl(n.sys_skin, o.sys_skin) as sys_skin -- 
    ,nvl(n.tenant_id, o.tenant_id) as tenant_id -- 租户ID
    ,nvl(n.hx_wy_user_id, o.hx_wy_user_id) as hx_wy_user_id -- 华兴网银用户id
    ,nvl(n.cert_code, o.cert_code) as cert_code -- 操作员证件号码
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
from (select * from ${iol_schema}.tmss_sys_user_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tmss_sys_user where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.begin_use_time <> n.begin_use_time
        or o.code <> n.code
        or o.email <> n.email
        or o.is_admin <> n.is_admin
        or o.login_name <> n.login_name
        or o.password <> n.password
        or o.phone <> n.phone
        or o.salt <> n.salt
        or o.sex <> n.sex
        or o.status <> n.status
        or o.username <> n.username
        or o.corp_id <> n.corp_id
        or o.user_cadn <> n.user_cadn
        or o.login_type <> n.login_type
        or o.create_time <> n.create_time
        or o.create_by <> n.create_by
        or o.update_time <> n.update_time
        or o.update_by <> n.update_by
        or o.show_report <> n.show_report
        or o.sys_skin <> n.sys_skin
        or o.tenant_id <> n.tenant_id
        or o.hx_wy_user_id <> n.hx_wy_user_id
        or o.cert_code <> n.cert_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tmss_sys_user_cl(
            id -- 
            ,begin_use_time -- 
            ,code -- 
            ,email -- 
            ,is_admin -- 
            ,login_name -- 
            ,password -- 
            ,phone -- 
            ,salt -- 
            ,sex -- 
            ,status -- 
            ,username -- 
            ,corp_id -- 
            ,user_cadn -- 
            ,login_type -- 用户登录方式 ：0用户密码方式，1证书认证＋用户密码方式，2证书认证方式
            ,create_time -- 
            ,create_by -- 
            ,update_time -- 
            ,update_by -- 
            ,show_report -- 
            ,sys_skin -- 
            ,tenant_id -- 租户ID
            ,hx_wy_user_id -- 华兴网银用户id
            ,cert_code -- 操作员证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tmss_sys_user_op(
            id -- 
            ,begin_use_time -- 
            ,code -- 
            ,email -- 
            ,is_admin -- 
            ,login_name -- 
            ,password -- 
            ,phone -- 
            ,salt -- 
            ,sex -- 
            ,status -- 
            ,username -- 
            ,corp_id -- 
            ,user_cadn -- 
            ,login_type -- 用户登录方式 ：0用户密码方式，1证书认证＋用户密码方式，2证书认证方式
            ,create_time -- 
            ,create_by -- 
            ,update_time -- 
            ,update_by -- 
            ,show_report -- 
            ,sys_skin -- 
            ,tenant_id -- 租户ID
            ,hx_wy_user_id -- 华兴网银用户id
            ,cert_code -- 操作员证件号码
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.begin_use_time -- 
    ,o.code -- 
    ,o.email -- 
    ,o.is_admin -- 
    ,o.login_name -- 
    ,o.password -- 
    ,o.phone -- 
    ,o.salt -- 
    ,o.sex -- 
    ,o.status -- 
    ,o.username -- 
    ,o.corp_id -- 
    ,o.user_cadn -- 
    ,o.login_type -- 用户登录方式 ：0用户密码方式，1证书认证＋用户密码方式，2证书认证方式
    ,o.create_time -- 
    ,o.create_by -- 
    ,o.update_time -- 
    ,o.update_by -- 
    ,o.show_report -- 
    ,o.sys_skin -- 
    ,o.tenant_id -- 租户ID
    ,o.hx_wy_user_id -- 华兴网银用户id
    ,o.cert_code -- 操作员证件号码
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
from ${iol_schema}.tmss_sys_user_bk o
    left join ${iol_schema}.tmss_sys_user_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tmss_sys_user_cl d
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
--truncate table ${iol_schema}.tmss_sys_user;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tmss_sys_user') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tmss_sys_user drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tmss_sys_user add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tmss_sys_user exchange partition p_${batch_date} with table ${iol_schema}.tmss_sys_user_cl;
alter table ${iol_schema}.tmss_sys_user exchange partition p_20991231 with table ${iol_schema}.tmss_sys_user_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tmss_sys_user to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tmss_sys_user_op purge;
drop table ${iol_schema}.tmss_sys_user_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tmss_sys_user_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tmss_sys_user',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
