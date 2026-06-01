/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_tmss_sys_corp
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
create table ${iol_schema}.tmss_sys_corp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.tmss_sys_corp
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tmss_sys_corp_op purge;
drop table ${iol_schema}.tmss_sys_corp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.tmss_sys_corp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tmss_sys_corp where 0=1;

create table ${iol_schema}.tmss_sys_corp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.tmss_sys_corp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tmss_sys_corp_cl(
            id -- 
            ,account_licence -- 
            ,address -- 
            ,city -- 
            ,code -- 
            ,collect_flag -- collectFlag
            ,ctl_budget -- 
            ,head_person -- 
            ,listed_company -- listedCompany
            ,name -- 
            ,parent_id -- 
            ,parent_ids -- 
            ,province -- 
            ,sort -- sort
            ,status -- status
            ,type -- 
            ,use_account_code -- 
            ,net_id -- 
            ,rat_group -- 集团统一授信主体
            ,create_time -- 
            ,create_by -- 
            ,update_time -- 
            ,update_by -- 
            ,is_limit_quota -- 
            ,day_limit_quota -- 
            ,month_limit_quota -- 
            ,name_en -- 
            ,address_en -- 
            ,cur_id -- 
            ,unit_attribute -- 
            ,unit_cm -- 
            ,country_id -- 
            ,tenant_id -- 租户ID
            ,soc_code -- 统一社会信用代码
            ,corp_tenant_code -- 单位客户号
            ,bank_code -- 银行端成员单位对应的联行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tmss_sys_corp_op(
            id -- 
            ,account_licence -- 
            ,address -- 
            ,city -- 
            ,code -- 
            ,collect_flag -- collectFlag
            ,ctl_budget -- 
            ,head_person -- 
            ,listed_company -- listedCompany
            ,name -- 
            ,parent_id -- 
            ,parent_ids -- 
            ,province -- 
            ,sort -- sort
            ,status -- status
            ,type -- 
            ,use_account_code -- 
            ,net_id -- 
            ,rat_group -- 集团统一授信主体
            ,create_time -- 
            ,create_by -- 
            ,update_time -- 
            ,update_by -- 
            ,is_limit_quota -- 
            ,day_limit_quota -- 
            ,month_limit_quota -- 
            ,name_en -- 
            ,address_en -- 
            ,cur_id -- 
            ,unit_attribute -- 
            ,unit_cm -- 
            ,country_id -- 
            ,tenant_id -- 租户ID
            ,soc_code -- 统一社会信用代码
            ,corp_tenant_code -- 单位客户号
            ,bank_code -- 银行端成员单位对应的联行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.account_licence, o.account_licence) as account_licence -- 
    ,nvl(n.address, o.address) as address -- 
    ,nvl(n.city, o.city) as city -- 
    ,nvl(n.code, o.code) as code -- 
    ,nvl(n.collect_flag, o.collect_flag) as collect_flag -- collectFlag
    ,nvl(n.ctl_budget, o.ctl_budget) as ctl_budget -- 
    ,nvl(n.head_person, o.head_person) as head_person -- 
    ,nvl(n.listed_company, o.listed_company) as listed_company -- listedCompany
    ,nvl(n.name, o.name) as name -- 
    ,nvl(n.parent_id, o.parent_id) as parent_id -- 
    ,nvl(n.parent_ids, o.parent_ids) as parent_ids -- 
    ,nvl(n.province, o.province) as province -- 
    ,nvl(n.sort, o.sort) as sort -- sort
    ,nvl(n.status, o.status) as status -- status
    ,nvl(n.type, o.type) as type -- 
    ,nvl(n.use_account_code, o.use_account_code) as use_account_code -- 
    ,nvl(n.net_id, o.net_id) as net_id -- 
    ,nvl(n.rat_group, o.rat_group) as rat_group -- 集团统一授信主体
    ,nvl(n.create_time, o.create_time) as create_time -- 
    ,nvl(n.create_by, o.create_by) as create_by -- 
    ,nvl(n.update_time, o.update_time) as update_time -- 
    ,nvl(n.update_by, o.update_by) as update_by -- 
    ,nvl(n.is_limit_quota, o.is_limit_quota) as is_limit_quota -- 
    ,nvl(n.day_limit_quota, o.day_limit_quota) as day_limit_quota -- 
    ,nvl(n.month_limit_quota, o.month_limit_quota) as month_limit_quota -- 
    ,nvl(n.name_en, o.name_en) as name_en -- 
    ,nvl(n.address_en, o.address_en) as address_en -- 
    ,nvl(n.cur_id, o.cur_id) as cur_id -- 
    ,nvl(n.unit_attribute, o.unit_attribute) as unit_attribute -- 
    ,nvl(n.unit_cm, o.unit_cm) as unit_cm -- 
    ,nvl(n.country_id, o.country_id) as country_id -- 
    ,nvl(n.tenant_id, o.tenant_id) as tenant_id -- 租户ID
    ,nvl(n.soc_code, o.soc_code) as soc_code -- 统一社会信用代码
    ,nvl(n.corp_tenant_code, o.corp_tenant_code) as corp_tenant_code -- 单位客户号
    ,nvl(n.bank_code, o.bank_code) as bank_code -- 银行端成员单位对应的联行号
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
from (select * from ${iol_schema}.tmss_sys_corp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.tmss_sys_corp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.account_licence <> n.account_licence
        or o.address <> n.address
        or o.city <> n.city
        or o.code <> n.code
        or o.collect_flag <> n.collect_flag
        or o.ctl_budget <> n.ctl_budget
        or o.head_person <> n.head_person
        or o.listed_company <> n.listed_company
        or o.name <> n.name
        or o.parent_id <> n.parent_id
        or o.parent_ids <> n.parent_ids
        or o.province <> n.province
        or o.sort <> n.sort
        or o.status <> n.status
        or o.type <> n.type
        or o.use_account_code <> n.use_account_code
        or o.net_id <> n.net_id
        or o.rat_group <> n.rat_group
        or o.create_time <> n.create_time
        or o.create_by <> n.create_by
        or o.update_time <> n.update_time
        or o.update_by <> n.update_by
        or o.is_limit_quota <> n.is_limit_quota
        or o.day_limit_quota <> n.day_limit_quota
        or o.month_limit_quota <> n.month_limit_quota
        or o.name_en <> n.name_en
        or o.address_en <> n.address_en
        or o.cur_id <> n.cur_id
        or o.unit_attribute <> n.unit_attribute
        or o.unit_cm <> n.unit_cm
        or o.country_id <> n.country_id
        or o.tenant_id <> n.tenant_id
        or o.soc_code <> n.soc_code
        or o.corp_tenant_code <> n.corp_tenant_code
        or o.bank_code <> n.bank_code
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.tmss_sys_corp_cl(
            id -- 
            ,account_licence -- 
            ,address -- 
            ,city -- 
            ,code -- 
            ,collect_flag -- collectFlag
            ,ctl_budget -- 
            ,head_person -- 
            ,listed_company -- listedCompany
            ,name -- 
            ,parent_id -- 
            ,parent_ids -- 
            ,province -- 
            ,sort -- sort
            ,status -- status
            ,type -- 
            ,use_account_code -- 
            ,net_id -- 
            ,rat_group -- 集团统一授信主体
            ,create_time -- 
            ,create_by -- 
            ,update_time -- 
            ,update_by -- 
            ,is_limit_quota -- 
            ,day_limit_quota -- 
            ,month_limit_quota -- 
            ,name_en -- 
            ,address_en -- 
            ,cur_id -- 
            ,unit_attribute -- 
            ,unit_cm -- 
            ,country_id -- 
            ,tenant_id -- 租户ID
            ,soc_code -- 统一社会信用代码
            ,corp_tenant_code -- 单位客户号
            ,bank_code -- 银行端成员单位对应的联行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.tmss_sys_corp_op(
            id -- 
            ,account_licence -- 
            ,address -- 
            ,city -- 
            ,code -- 
            ,collect_flag -- collectFlag
            ,ctl_budget -- 
            ,head_person -- 
            ,listed_company -- listedCompany
            ,name -- 
            ,parent_id -- 
            ,parent_ids -- 
            ,province -- 
            ,sort -- sort
            ,status -- status
            ,type -- 
            ,use_account_code -- 
            ,net_id -- 
            ,rat_group -- 集团统一授信主体
            ,create_time -- 
            ,create_by -- 
            ,update_time -- 
            ,update_by -- 
            ,is_limit_quota -- 
            ,day_limit_quota -- 
            ,month_limit_quota -- 
            ,name_en -- 
            ,address_en -- 
            ,cur_id -- 
            ,unit_attribute -- 
            ,unit_cm -- 
            ,country_id -- 
            ,tenant_id -- 租户ID
            ,soc_code -- 统一社会信用代码
            ,corp_tenant_code -- 单位客户号
            ,bank_code -- 银行端成员单位对应的联行号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.account_licence -- 
    ,o.address -- 
    ,o.city -- 
    ,o.code -- 
    ,o.collect_flag -- collectFlag
    ,o.ctl_budget -- 
    ,o.head_person -- 
    ,o.listed_company -- listedCompany
    ,o.name -- 
    ,o.parent_id -- 
    ,o.parent_ids -- 
    ,o.province -- 
    ,o.sort -- sort
    ,o.status -- status
    ,o.type -- 
    ,o.use_account_code -- 
    ,o.net_id -- 
    ,o.rat_group -- 集团统一授信主体
    ,o.create_time -- 
    ,o.create_by -- 
    ,o.update_time -- 
    ,o.update_by -- 
    ,o.is_limit_quota -- 
    ,o.day_limit_quota -- 
    ,o.month_limit_quota -- 
    ,o.name_en -- 
    ,o.address_en -- 
    ,o.cur_id -- 
    ,o.unit_attribute -- 
    ,o.unit_cm -- 
    ,o.country_id -- 
    ,o.tenant_id -- 租户ID
    ,o.soc_code -- 统一社会信用代码
    ,o.corp_tenant_code -- 单位客户号
    ,o.bank_code -- 银行端成员单位对应的联行号
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
from ${iol_schema}.tmss_sys_corp_bk o
    left join ${iol_schema}.tmss_sys_corp_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.tmss_sys_corp_cl d
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
--truncate table ${iol_schema}.tmss_sys_corp;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('tmss_sys_corp') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.tmss_sys_corp drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.tmss_sys_corp add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.tmss_sys_corp exchange partition p_${batch_date} with table ${iol_schema}.tmss_sys_corp_cl;
alter table ${iol_schema}.tmss_sys_corp exchange partition p_20991231 with table ${iol_schema}.tmss_sys_corp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.tmss_sys_corp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.tmss_sys_corp_op purge;
drop table ${iol_schema}.tmss_sys_corp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.tmss_sys_corp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'tmss_sys_corp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
