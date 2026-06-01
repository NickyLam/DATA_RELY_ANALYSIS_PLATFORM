/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_ftp_spread_maintenance
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
create table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_ftp_spread_maintenance;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_op purge;
drop table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_ftp_spread_maintenance where 0=1;

create table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_ftp_spread_maintenance where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_cl(
            id -- 
            ,status -- 状态0-未生效1-已生效
            ,is_current -- 是否活期业务
            ,trade_id -- 交易id
            ,i_code -- 金融工具代码
            ,current_account -- 活期账户
            ,new_spread -- 新点差
            ,update_user -- 
            ,effect_time -- 
            ,update_user_id -- 
            ,origin_spread -- 原点差
            ,a_type -- 
            ,m_type -- 
            ,accid -- 投组ID
            ,accountname -- 投组名称
            ,i_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_op(
            id -- 
            ,status -- 状态0-未生效1-已生效
            ,is_current -- 是否活期业务
            ,trade_id -- 交易id
            ,i_code -- 金融工具代码
            ,current_account -- 活期账户
            ,new_spread -- 新点差
            ,update_user -- 
            ,effect_time -- 
            ,update_user_id -- 
            ,origin_spread -- 原点差
            ,a_type -- 
            ,m_type -- 
            ,accid -- 投组ID
            ,accountname -- 投组名称
            ,i_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.status, o.status) as status -- 状态0-未生效1-已生效
    ,nvl(n.is_current, o.is_current) as is_current -- 是否活期业务
    ,nvl(n.trade_id, o.trade_id) as trade_id -- 交易id
    ,nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.current_account, o.current_account) as current_account -- 活期账户
    ,nvl(n.new_spread, o.new_spread) as new_spread -- 新点差
    ,nvl(n.update_user, o.update_user) as update_user -- 
    ,nvl(n.effect_time, o.effect_time) as effect_time -- 
    ,nvl(n.update_user_id, o.update_user_id) as update_user_id -- 
    ,nvl(n.origin_spread, o.origin_spread) as origin_spread -- 原点差
    ,nvl(n.a_type, o.a_type) as a_type -- 
    ,nvl(n.m_type, o.m_type) as m_type -- 
    ,nvl(n.accid, o.accid) as accid -- 投组ID
    ,nvl(n.accountname, o.accountname) as accountname -- 投组名称
    ,nvl(n.i_name, o.i_name) as i_name -- 
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
from (select * from ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_ftp_spread_maintenance where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.status <> n.status
        or o.is_current <> n.is_current
        or o.trade_id <> n.trade_id
        or o.i_code <> n.i_code
        or o.current_account <> n.current_account
        or o.new_spread <> n.new_spread
        or o.update_user <> n.update_user
        or o.effect_time <> n.effect_time
        or o.update_user_id <> n.update_user_id
        or o.origin_spread <> n.origin_spread
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.accid <> n.accid
        or o.accountname <> n.accountname
        or o.i_name <> n.i_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_cl(
            id -- 
            ,status -- 状态0-未生效1-已生效
            ,is_current -- 是否活期业务
            ,trade_id -- 交易id
            ,i_code -- 金融工具代码
            ,current_account -- 活期账户
            ,new_spread -- 新点差
            ,update_user -- 
            ,effect_time -- 
            ,update_user_id -- 
            ,origin_spread -- 原点差
            ,a_type -- 
            ,m_type -- 
            ,accid -- 投组ID
            ,accountname -- 投组名称
            ,i_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_op(
            id -- 
            ,status -- 状态0-未生效1-已生效
            ,is_current -- 是否活期业务
            ,trade_id -- 交易id
            ,i_code -- 金融工具代码
            ,current_account -- 活期账户
            ,new_spread -- 新点差
            ,update_user -- 
            ,effect_time -- 
            ,update_user_id -- 
            ,origin_spread -- 原点差
            ,a_type -- 
            ,m_type -- 
            ,accid -- 投组ID
            ,accountname -- 投组名称
            ,i_name -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.status -- 状态0-未生效1-已生效
    ,o.is_current -- 是否活期业务
    ,o.trade_id -- 交易id
    ,o.i_code -- 金融工具代码
    ,o.current_account -- 活期账户
    ,o.new_spread -- 新点差
    ,o.update_user -- 
    ,o.effect_time -- 
    ,o.update_user_id -- 
    ,o.origin_spread -- 原点差
    ,o.a_type -- 
    ,o.m_type -- 
    ,o.accid -- 投组ID
    ,o.accountname -- 投组名称
    ,o.i_name -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_bk o
    left join ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_cl d
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
-- truncate table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_cl;
alter table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_ftp_spread_maintenance to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_op purge;
drop table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_ftp_spread_maintenance_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_ftp_spread_maintenance',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
