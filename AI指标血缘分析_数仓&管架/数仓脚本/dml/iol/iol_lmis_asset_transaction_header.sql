/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_lmis_asset_transaction_header
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
create table ${iol_schema}.lmis_asset_transaction_header_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.lmis_asset_transaction_header
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.lmis_asset_transaction_header_op purge;
drop table ${iol_schema}.lmis_asset_transaction_header_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.lmis_asset_transaction_header_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.lmis_asset_transaction_header where 0=1;

create table ${iol_schema}.lmis_asset_transaction_header_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.lmis_asset_transaction_header where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.lmis_asset_transaction_header_cl(
            id -- ID
            ,book_code -- 账簿CODE
            ,asset_id -- 资产ID
            ,transaction_number -- 事物处理编号
            ,period_name -- 期间
            ,transaction_type_code -- 事务类型代码
            ,transaction_type_desc -- 事务类型描述
            ,transaction_subtype_code -- 明细事务类型代码
            ,transaction_subtype_desc -- 明细事务类型描述
            ,transaction_date_entered -- 事物处理业务日期
            ,date_effective -- 事物处理有效日期（记账日期）
            ,account_flag -- 会计核算标识
            ,account_status -- 凭证入账状态
            ,source_code -- 来源事物处理接口代码
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,reverse_flag -- 是否冲销
            ,reverse_transaction_header_id -- 待冲销事务ID
            ,credential_create_user -- 凭证创建用户
            ,credential_approval_user -- 凭证审批用户
            ,lease_approval_status -- 租赁资产审核状态
            ,error_msg -- 错误信息
            ,company_code -- 
            ,company_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.lmis_asset_transaction_header_op(
            id -- ID
            ,book_code -- 账簿CODE
            ,asset_id -- 资产ID
            ,transaction_number -- 事物处理编号
            ,period_name -- 期间
            ,transaction_type_code -- 事务类型代码
            ,transaction_type_desc -- 事务类型描述
            ,transaction_subtype_code -- 明细事务类型代码
            ,transaction_subtype_desc -- 明细事务类型描述
            ,transaction_date_entered -- 事物处理业务日期
            ,date_effective -- 事物处理有效日期（记账日期）
            ,account_flag -- 会计核算标识
            ,account_status -- 凭证入账状态
            ,source_code -- 来源事物处理接口代码
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,reverse_flag -- 是否冲销
            ,reverse_transaction_header_id -- 待冲销事务ID
            ,credential_create_user -- 凭证创建用户
            ,credential_approval_user -- 凭证审批用户
            ,lease_approval_status -- 租赁资产审核状态
            ,error_msg -- 错误信息
            ,company_code -- 
            ,company_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- ID
    ,nvl(n.book_code, o.book_code) as book_code -- 账簿CODE
    ,nvl(n.asset_id, o.asset_id) as asset_id -- 资产ID
    ,nvl(n.transaction_number, o.transaction_number) as transaction_number -- 事物处理编号
    ,nvl(n.period_name, o.period_name) as period_name -- 期间
    ,nvl(n.transaction_type_code, o.transaction_type_code) as transaction_type_code -- 事务类型代码
    ,nvl(n.transaction_type_desc, o.transaction_type_desc) as transaction_type_desc -- 事务类型描述
    ,nvl(n.transaction_subtype_code, o.transaction_subtype_code) as transaction_subtype_code -- 明细事务类型代码
    ,nvl(n.transaction_subtype_desc, o.transaction_subtype_desc) as transaction_subtype_desc -- 明细事务类型描述
    ,nvl(n.transaction_date_entered, o.transaction_date_entered) as transaction_date_entered -- 事物处理业务日期
    ,nvl(n.date_effective, o.date_effective) as date_effective -- 事物处理有效日期（记账日期）
    ,nvl(n.account_flag, o.account_flag) as account_flag -- 会计核算标识
    ,nvl(n.account_status, o.account_status) as account_status -- 凭证入账状态
    ,nvl(n.source_code, o.source_code) as source_code -- 来源事物处理接口代码
    ,nvl(n.tenant_id, o.tenant_id) as tenant_id -- 租户ID
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.created_date, o.created_date) as created_date -- 创建时间
    ,nvl(n.last_updated_by, o.last_updated_by) as last_updated_by -- 最后更新人
    ,nvl(n.last_updated_date, o.last_updated_date) as last_updated_date -- 最后更新时间
    ,nvl(n.version_number, o.version_number) as version_number -- 版本号
    ,nvl(n.reverse_flag, o.reverse_flag) as reverse_flag -- 是否冲销
    ,nvl(n.reverse_transaction_header_id, o.reverse_transaction_header_id) as reverse_transaction_header_id -- 待冲销事务ID
    ,nvl(n.credential_create_user, o.credential_create_user) as credential_create_user -- 凭证创建用户
    ,nvl(n.credential_approval_user, o.credential_approval_user) as credential_approval_user -- 凭证审批用户
    ,nvl(n.lease_approval_status, o.lease_approval_status) as lease_approval_status -- 租赁资产审核状态
    ,nvl(n.error_msg, o.error_msg) as error_msg -- 错误信息
    ,nvl(n.company_code, o.company_code) as company_code -- 
    ,nvl(n.company_id, o.company_id) as company_id -- 
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
from (select * from ${iol_schema}.lmis_asset_transaction_header_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.lmis_asset_transaction_header where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.book_code <> n.book_code
        or o.asset_id <> n.asset_id
        or o.transaction_number <> n.transaction_number
        or o.period_name <> n.period_name
        or o.transaction_type_code <> n.transaction_type_code
        or o.transaction_type_desc <> n.transaction_type_desc
        or o.transaction_subtype_code <> n.transaction_subtype_code
        or o.transaction_subtype_desc <> n.transaction_subtype_desc
        or o.transaction_date_entered <> n.transaction_date_entered
        or o.date_effective <> n.date_effective
        or o.account_flag <> n.account_flag
        or o.account_status <> n.account_status
        or o.source_code <> n.source_code
        or o.tenant_id <> n.tenant_id
        or o.created_by <> n.created_by
        or o.created_date <> n.created_date
        or o.last_updated_by <> n.last_updated_by
        or o.last_updated_date <> n.last_updated_date
        or o.version_number <> n.version_number
        or o.reverse_flag <> n.reverse_flag
        or o.reverse_transaction_header_id <> n.reverse_transaction_header_id
        or o.credential_create_user <> n.credential_create_user
        or o.credential_approval_user <> n.credential_approval_user
        or o.lease_approval_status <> n.lease_approval_status
        or o.error_msg <> n.error_msg
        or o.company_code <> n.company_code
        or o.company_id <> n.company_id
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.lmis_asset_transaction_header_cl(
            id -- ID
            ,book_code -- 账簿CODE
            ,asset_id -- 资产ID
            ,transaction_number -- 事物处理编号
            ,period_name -- 期间
            ,transaction_type_code -- 事务类型代码
            ,transaction_type_desc -- 事务类型描述
            ,transaction_subtype_code -- 明细事务类型代码
            ,transaction_subtype_desc -- 明细事务类型描述
            ,transaction_date_entered -- 事物处理业务日期
            ,date_effective -- 事物处理有效日期（记账日期）
            ,account_flag -- 会计核算标识
            ,account_status -- 凭证入账状态
            ,source_code -- 来源事物处理接口代码
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,reverse_flag -- 是否冲销
            ,reverse_transaction_header_id -- 待冲销事务ID
            ,credential_create_user -- 凭证创建用户
            ,credential_approval_user -- 凭证审批用户
            ,lease_approval_status -- 租赁资产审核状态
            ,error_msg -- 错误信息
            ,company_code -- 
            ,company_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.lmis_asset_transaction_header_op(
            id -- ID
            ,book_code -- 账簿CODE
            ,asset_id -- 资产ID
            ,transaction_number -- 事物处理编号
            ,period_name -- 期间
            ,transaction_type_code -- 事务类型代码
            ,transaction_type_desc -- 事务类型描述
            ,transaction_subtype_code -- 明细事务类型代码
            ,transaction_subtype_desc -- 明细事务类型描述
            ,transaction_date_entered -- 事物处理业务日期
            ,date_effective -- 事物处理有效日期（记账日期）
            ,account_flag -- 会计核算标识
            ,account_status -- 凭证入账状态
            ,source_code -- 来源事物处理接口代码
            ,tenant_id -- 租户ID
            ,created_by -- 创建人
            ,created_date -- 创建时间
            ,last_updated_by -- 最后更新人
            ,last_updated_date -- 最后更新时间
            ,version_number -- 版本号
            ,reverse_flag -- 是否冲销
            ,reverse_transaction_header_id -- 待冲销事务ID
            ,credential_create_user -- 凭证创建用户
            ,credential_approval_user -- 凭证审批用户
            ,lease_approval_status -- 租赁资产审核状态
            ,error_msg -- 错误信息
            ,company_code -- 
            ,company_id -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- ID
    ,o.book_code -- 账簿CODE
    ,o.asset_id -- 资产ID
    ,o.transaction_number -- 事物处理编号
    ,o.period_name -- 期间
    ,o.transaction_type_code -- 事务类型代码
    ,o.transaction_type_desc -- 事务类型描述
    ,o.transaction_subtype_code -- 明细事务类型代码
    ,o.transaction_subtype_desc -- 明细事务类型描述
    ,o.transaction_date_entered -- 事物处理业务日期
    ,o.date_effective -- 事物处理有效日期（记账日期）
    ,o.account_flag -- 会计核算标识
    ,o.account_status -- 凭证入账状态
    ,o.source_code -- 来源事物处理接口代码
    ,o.tenant_id -- 租户ID
    ,o.created_by -- 创建人
    ,o.created_date -- 创建时间
    ,o.last_updated_by -- 最后更新人
    ,o.last_updated_date -- 最后更新时间
    ,o.version_number -- 版本号
    ,o.reverse_flag -- 是否冲销
    ,o.reverse_transaction_header_id -- 待冲销事务ID
    ,o.credential_create_user -- 凭证创建用户
    ,o.credential_approval_user -- 凭证审批用户
    ,o.lease_approval_status -- 租赁资产审核状态
    ,o.error_msg -- 错误信息
    ,o.company_code -- 
    ,o.company_id -- 
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
from ${iol_schema}.lmis_asset_transaction_header_bk o
    left join ${iol_schema}.lmis_asset_transaction_header_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.lmis_asset_transaction_header_cl d
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
--truncate table ${iol_schema}.lmis_asset_transaction_header;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('lmis_asset_transaction_header') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.lmis_asset_transaction_header drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.lmis_asset_transaction_header add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.lmis_asset_transaction_header exchange partition p_${batch_date} with table ${iol_schema}.lmis_asset_transaction_header_cl;
alter table ${iol_schema}.lmis_asset_transaction_header exchange partition p_20991231 with table ${iol_schema}.lmis_asset_transaction_header_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.lmis_asset_transaction_header to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.lmis_asset_transaction_header_op purge;
drop table ${iol_schema}.lmis_asset_transaction_header_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.lmis_asset_transaction_header_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'lmis_asset_transaction_header',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
