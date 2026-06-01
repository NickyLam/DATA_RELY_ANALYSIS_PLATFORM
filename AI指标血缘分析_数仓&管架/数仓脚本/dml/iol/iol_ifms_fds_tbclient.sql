/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ifms_fds_tbclient
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
create table ${iol_schema}.ifms_fds_tbclient_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ifms_fds_tbclient;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbclient_op purge;
drop table ${iol_schema}.ifms_fds_tbclient_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ifms_fds_tbclient_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbclient where 0=1;

create table ${iol_schema}.ifms_fds_tbclient_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ifms_fds_tbclient where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbclient_cl(
            in_client_no -- 
            ,client_type -- 
            ,client_group -- 
            ,id_type -- 
            ,id_code -- 
            ,short_name -- 
            ,client_name -- 
            ,address -- 
            ,post_code -- 
            ,tel -- 
            ,fax -- 
            ,mobile -- 
            ,email -- 
            ,sex -- 
            ,send_freq -- 
            ,send_mode -- 
            ,risk_level -- 
            ,risk_date -- 
            ,birthday -- 
            ,id_code_date -- 
            ,education -- 
            ,income -- 
            ,vocation -- 
            ,nationality -- 
            ,channels -- 
            ,prd_types -- 
            ,client_manager -- 
            ,open_branch -- 
            ,status -- 
            ,modi_date -- 
            ,modi_time -- 
            ,modify_info -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbclient_op(
            in_client_no -- 
            ,client_type -- 
            ,client_group -- 
            ,id_type -- 
            ,id_code -- 
            ,short_name -- 
            ,client_name -- 
            ,address -- 
            ,post_code -- 
            ,tel -- 
            ,fax -- 
            ,mobile -- 
            ,email -- 
            ,sex -- 
            ,send_freq -- 
            ,send_mode -- 
            ,risk_level -- 
            ,risk_date -- 
            ,birthday -- 
            ,id_code_date -- 
            ,education -- 
            ,income -- 
            ,vocation -- 
            ,nationality -- 
            ,channels -- 
            ,prd_types -- 
            ,client_manager -- 
            ,open_branch -- 
            ,status -- 
            ,modi_date -- 
            ,modi_time -- 
            ,modify_info -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.in_client_no, o.in_client_no) as in_client_no -- 
    ,nvl(n.client_type, o.client_type) as client_type -- 
    ,nvl(n.client_group, o.client_group) as client_group -- 
    ,nvl(n.id_type, o.id_type) as id_type -- 
    ,nvl(n.id_code, o.id_code) as id_code -- 
    ,nvl(n.short_name, o.short_name) as short_name -- 
    ,nvl(n.client_name, o.client_name) as client_name -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.post_code, o.post_code) as post_code -- 
    ,nvl(n.tel, o.tel) as tel -- 
    ,nvl(n.fax, o.fax) as fax -- 
    ,nvl(n.mobile, o.mobile) as mobile -- 
    ,nvl(n.email, o.email) as email -- 
    ,nvl(n.sex, o.sex) as sex -- 
    ,nvl(n.send_freq, o.send_freq) as send_freq -- 
    ,nvl(n.send_mode, o.send_mode) as send_mode -- 
    ,nvl(n.risk_level, o.risk_level) as risk_level -- 
    ,nvl(n.risk_date, o.risk_date) as risk_date -- 
    ,nvl(n.birthday, o.birthday) as birthday -- 
    ,nvl(n.id_code_date, o.id_code_date) as id_code_date -- 
    ,nvl(n.education, o.education) as education -- 
    ,nvl(n.income, o.income) as income -- 
    ,nvl(n.vocation, o.vocation) as vocation -- 
    ,nvl(n.nationality, o.nationality) as nationality -- 
    ,nvl(n.channels, o.channels) as channels -- 
    ,nvl(n.prd_types, o.prd_types) as prd_types -- 
    ,nvl(n.client_manager, o.client_manager) as client_manager -- 
    ,nvl(n.open_branch, o.open_branch) as open_branch -- 
    ,nvl(n.status, o.status) as status -- 
    ,nvl(n.modi_date, o.modi_date) as modi_date -- 
    ,nvl(n.modi_time, o.modi_time) as modi_time -- 
    ,nvl(n.modify_info, o.modify_info) as modify_info -- 
    ,nvl(n.reserve1, o.reserve1) as reserve1 -- 
    ,nvl(n.reserve2, o.reserve2) as reserve2 -- 
    ,nvl(n.reserve3, o.reserve3) as reserve3 -- 
    ,nvl(n.reserve4, o.reserve4) as reserve4 -- 
    ,case when
            n.in_client_no is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.in_client_no is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.in_client_no is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ifms_fds_tbclient_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ifms_fds_tbclient where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.in_client_no = n.in_client_no
where (
        o.in_client_no is null
    )
    or (
        n.in_client_no is null
    )
    or (
        o.client_type <> n.client_type
        or o.client_group <> n.client_group
        or o.id_type <> n.id_type
        or o.id_code <> n.id_code
        or o.short_name <> n.short_name
        or o.client_name <> n.client_name
        or o.address <> n.address
        or o.post_code <> n.post_code
        or o.tel <> n.tel
        or o.fax <> n.fax
        or o.mobile <> n.mobile
        or o.email <> n.email
        or o.sex <> n.sex
        or o.send_freq <> n.send_freq
        or o.send_mode <> n.send_mode
        or o.risk_level <> n.risk_level
        or o.risk_date <> n.risk_date
        or o.birthday <> n.birthday
        or o.id_code_date <> n.id_code_date
        or o.education <> n.education
        or o.income <> n.income
        or o.vocation <> n.vocation
        or o.nationality <> n.nationality
        or o.channels <> n.channels
        or o.prd_types <> n.prd_types
        or o.client_manager <> n.client_manager
        or o.open_branch <> n.open_branch
        or o.status <> n.status
        or o.modi_date <> n.modi_date
        or o.modi_time <> n.modi_time
        or o.modify_info <> n.modify_info
        or o.reserve1 <> n.reserve1
        or o.reserve2 <> n.reserve2
        or o.reserve3 <> n.reserve3
        or o.reserve4 <> n.reserve4
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ifms_fds_tbclient_cl(
            in_client_no -- 
            ,client_type -- 
            ,client_group -- 
            ,id_type -- 
            ,id_code -- 
            ,short_name -- 
            ,client_name -- 
            ,address -- 
            ,post_code -- 
            ,tel -- 
            ,fax -- 
            ,mobile -- 
            ,email -- 
            ,sex -- 
            ,send_freq -- 
            ,send_mode -- 
            ,risk_level -- 
            ,risk_date -- 
            ,birthday -- 
            ,id_code_date -- 
            ,education -- 
            ,income -- 
            ,vocation -- 
            ,nationality -- 
            ,channels -- 
            ,prd_types -- 
            ,client_manager -- 
            ,open_branch -- 
            ,status -- 
            ,modi_date -- 
            ,modi_time -- 
            ,modify_info -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ifms_fds_tbclient_op(
            in_client_no -- 
            ,client_type -- 
            ,client_group -- 
            ,id_type -- 
            ,id_code -- 
            ,short_name -- 
            ,client_name -- 
            ,address -- 
            ,post_code -- 
            ,tel -- 
            ,fax -- 
            ,mobile -- 
            ,email -- 
            ,sex -- 
            ,send_freq -- 
            ,send_mode -- 
            ,risk_level -- 
            ,risk_date -- 
            ,birthday -- 
            ,id_code_date -- 
            ,education -- 
            ,income -- 
            ,vocation -- 
            ,nationality -- 
            ,channels -- 
            ,prd_types -- 
            ,client_manager -- 
            ,open_branch -- 
            ,status -- 
            ,modi_date -- 
            ,modi_time -- 
            ,modify_info -- 
            ,reserve1 -- 
            ,reserve2 -- 
            ,reserve3 -- 
            ,reserve4 -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.in_client_no -- 
    ,o.client_type -- 
    ,o.client_group -- 
    ,o.id_type -- 
    ,o.id_code -- 
    ,o.short_name -- 
    ,o.client_name -- 
    ,o.address -- 
    ,o.post_code -- 
    ,o.tel -- 
    ,o.fax -- 
    ,o.mobile -- 
    ,o.email -- 
    ,o.sex -- 
    ,o.send_freq -- 
    ,o.send_mode -- 
    ,o.risk_level -- 
    ,o.risk_date -- 
    ,o.birthday -- 
    ,o.id_code_date -- 
    ,o.education -- 
    ,o.income -- 
    ,o.vocation -- 
    ,o.nationality -- 
    ,o.channels -- 
    ,o.prd_types -- 
    ,o.client_manager -- 
    ,o.open_branch -- 
    ,o.status -- 
    ,o.modi_date -- 
    ,o.modi_time -- 
    ,o.modify_info -- 
    ,o.reserve1 -- 
    ,o.reserve2 -- 
    ,o.reserve3 -- 
    ,o.reserve4 -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ifms_fds_tbclient_bk o
    left join ${iol_schema}.ifms_fds_tbclient_op n
        on
            o.in_client_no = n.in_client_no
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ifms_fds_tbclient_cl d
        on
            o.in_client_no = d.in_client_no
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ifms_fds_tbclient;

-- 4.2 exchange partition
alter table ${iol_schema}.ifms_fds_tbclient exchange partition p_19000101 with table ${iol_schema}.ifms_fds_tbclient_cl;
alter table ${iol_schema}.ifms_fds_tbclient exchange partition p_20991231 with table ${iol_schema}.ifms_fds_tbclient_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ifms_fds_tbclient to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ifms_fds_tbclient_op purge;
drop table ${iol_schema}.ifms_fds_tbclient_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ifms_fds_tbclient_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ifms_fds_tbclient',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
