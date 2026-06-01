/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_fixedterm_account
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
create table ${iol_schema}.ibms_ttrd_fixedterm_account_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_fixedterm_account;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_fixedterm_account_op purge;
drop table ${iol_schema}.ibms_ttrd_fixedterm_account_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_fixedterm_account_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_fixedterm_account where 0=1;

create table ${iol_schema}.ibms_ttrd_fixedterm_account_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_fixedterm_account where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_fixedterm_account_cl(
            acct_id -- 主键ID
            ,acct_code -- 定期账户
            ,acct_name -- 定期账号名称
            ,bank_code -- 开户行号
            ,bank_name -- 开户行名称
            ,i_id -- 机构号
            ,party_id -- 
            ,core_acct_code -- 核心账号
            ,core_acct_name -- 核心账号名称
            ,currency -- 币种
            ,acct_type -- 账户类型
            ,status -- 账户状态
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_fixedterm_account_op(
            acct_id -- 主键ID
            ,acct_code -- 定期账户
            ,acct_name -- 定期账号名称
            ,bank_code -- 开户行号
            ,bank_name -- 开户行名称
            ,i_id -- 机构号
            ,party_id -- 
            ,core_acct_code -- 核心账号
            ,core_acct_name -- 核心账号名称
            ,currency -- 币种
            ,acct_type -- 账户类型
            ,status -- 账户状态
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.acct_id, o.acct_id) as acct_id -- 主键ID
    ,nvl(n.acct_code, o.acct_code) as acct_code -- 定期账户
    ,nvl(n.acct_name, o.acct_name) as acct_name -- 定期账号名称
    ,nvl(n.bank_code, o.bank_code) as bank_code -- 开户行号
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 开户行名称
    ,nvl(n.i_id, o.i_id) as i_id -- 机构号
    ,nvl(n.party_id, o.party_id) as party_id -- 
    ,nvl(n.core_acct_code, o.core_acct_code) as core_acct_code -- 核心账号
    ,nvl(n.core_acct_name, o.core_acct_name) as core_acct_name -- 核心账号名称
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.acct_type, o.acct_type) as acct_type -- 账户类型
    ,nvl(n.status, o.status) as status -- 账户状态
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.acct_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.acct_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.acct_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_fixedterm_account_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_fixedterm_account where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.acct_id = n.acct_id
where (
        o.acct_id is null
    )
    or (
        n.acct_id is null
    )
    or (
        o.acct_code <> n.acct_code
        or o.acct_name <> n.acct_name
        or o.bank_code <> n.bank_code
        or o.bank_name <> n.bank_name
        or o.i_id <> n.i_id
        or o.party_id <> n.party_id
        or o.core_acct_code <> n.core_acct_code
        or o.core_acct_name <> n.core_acct_name
        or o.currency <> n.currency
        or o.acct_type <> n.acct_type
        or o.status <> n.status
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_fixedterm_account_cl(
            acct_id -- 主键ID
            ,acct_code -- 定期账户
            ,acct_name -- 定期账号名称
            ,bank_code -- 开户行号
            ,bank_name -- 开户行名称
            ,i_id -- 机构号
            ,party_id -- 
            ,core_acct_code -- 核心账号
            ,core_acct_name -- 核心账号名称
            ,currency -- 币种
            ,acct_type -- 账户类型
            ,status -- 账户状态
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_fixedterm_account_op(
            acct_id -- 主键ID
            ,acct_code -- 定期账户
            ,acct_name -- 定期账号名称
            ,bank_code -- 开户行号
            ,bank_name -- 开户行名称
            ,i_id -- 机构号
            ,party_id -- 
            ,core_acct_code -- 核心账号
            ,core_acct_name -- 核心账号名称
            ,currency -- 币种
            ,acct_type -- 账户类型
            ,status -- 账户状态
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.acct_id -- 主键ID
    ,o.acct_code -- 定期账户
    ,o.acct_name -- 定期账号名称
    ,o.bank_code -- 开户行号
    ,o.bank_name -- 开户行名称
    ,o.i_id -- 机构号
    ,o.party_id -- 
    ,o.core_acct_code -- 核心账号
    ,o.core_acct_name -- 核心账号名称
    ,o.currency -- 币种
    ,o.acct_type -- 账户类型
    ,o.status -- 账户状态
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_fixedterm_account_bk o
    left join ${iol_schema}.ibms_ttrd_fixedterm_account_op n
        on
            o.acct_id = n.acct_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_fixedterm_account_cl d
        on
            o.acct_id = d.acct_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_fixedterm_account;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_fixedterm_account exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_fixedterm_account_cl;
alter table ${iol_schema}.ibms_ttrd_fixedterm_account exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_fixedterm_account_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_fixedterm_account to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_fixedterm_account_op purge;
drop table ${iol_schema}.ibms_ttrd_fixedterm_account_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_fixedterm_account_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_fixedterm_account',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
