/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_hgls_loan_branch_website
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
create table ${iol_schema}.hgls_loan_branch_website_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.hgls_loan_branch_website
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_branch_website_op purge;
drop table ${iol_schema}.hgls_loan_branch_website_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.hgls_loan_branch_website_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_branch_website where 0=1;

create table ${iol_schema}.hgls_loan_branch_website_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.hgls_loan_branch_website where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_branch_website_cl(
            id -- 主键id
            ,bank_name -- 支行名称
            ,bank_phone -- 支行电话
            ,province_region -- 支行住址的省市区,多级斜杠隔开
            ,address -- 支行具体地址
            ,start_time -- 营业开始时间
            ,end_time -- 营业结束时间
            ,system_type -- 系统类型，1，业务系统，2营销系统
            ,enterprise_code -- 企业注册码
            ,org_num -- 机构号
            ,busi_cover_area -- 业务覆盖区域
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识
            ,code -- 唯一编码
            ,bank_credit_accounts -- 机构征信查询账户
            ,bank_credit_recheck_user -- 机构征信复核用户
            ,parent_code -- 上级机构code
            ,org_type -- 机构类型，1：总行2：分行3：支行
            ,org_level -- 机构层级，总行一级，下级依次递增，最多不超过六级
            ,corporcate_bank_num -- 法人行行号
            ,corporate_name -- 企业名称（合同用）
            ,core_org_num -- 核心机构号
            ,business_label -- 行业客群标签
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_branch_website_op(
            id -- 主键id
            ,bank_name -- 支行名称
            ,bank_phone -- 支行电话
            ,province_region -- 支行住址的省市区,多级斜杠隔开
            ,address -- 支行具体地址
            ,start_time -- 营业开始时间
            ,end_time -- 营业结束时间
            ,system_type -- 系统类型，1，业务系统，2营销系统
            ,enterprise_code -- 企业注册码
            ,org_num -- 机构号
            ,busi_cover_area -- 业务覆盖区域
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识
            ,code -- 唯一编码
            ,bank_credit_accounts -- 机构征信查询账户
            ,bank_credit_recheck_user -- 机构征信复核用户
            ,parent_code -- 上级机构code
            ,org_type -- 机构类型，1：总行2：分行3：支行
            ,org_level -- 机构层级，总行一级，下级依次递增，最多不超过六级
            ,corporcate_bank_num -- 法人行行号
            ,corporate_name -- 企业名称（合同用）
            ,core_org_num -- 核心机构号
            ,business_label -- 行业客群标签
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键id
    ,nvl(n.bank_name, o.bank_name) as bank_name -- 支行名称
    ,nvl(n.bank_phone, o.bank_phone) as bank_phone -- 支行电话
    ,nvl(n.province_region, o.province_region) as province_region -- 支行住址的省市区,多级斜杠隔开
    ,nvl(n.address, o.address) as address -- 支行具体地址
    ,nvl(n.start_time, o.start_time) as start_time -- 营业开始时间
    ,nvl(n.end_time, o.end_time) as end_time -- 营业结束时间
    ,nvl(n.system_type, o.system_type) as system_type -- 系统类型，1，业务系统，2营销系统
    ,nvl(n.enterprise_code, o.enterprise_code) as enterprise_code -- 企业注册码
    ,nvl(n.org_num, o.org_num) as org_num -- 机构号
    ,nvl(n.busi_cover_area, o.busi_cover_area) as busi_cover_area -- 业务覆盖区域
    ,nvl(n.create_date, o.create_date) as create_date -- 申请日期
    ,nvl(n.update_date, o.update_date) as update_date -- 更新时间
    ,nvl(n.isdel, o.isdel) as isdel -- 删除标识
    ,nvl(n.code, o.code) as code -- 唯一编码
    ,nvl(n.bank_credit_accounts, o.bank_credit_accounts) as bank_credit_accounts -- 机构征信查询账户
    ,nvl(n.bank_credit_recheck_user, o.bank_credit_recheck_user) as bank_credit_recheck_user -- 机构征信复核用户
    ,nvl(n.parent_code, o.parent_code) as parent_code -- 上级机构code
    ,nvl(n.org_type, o.org_type) as org_type -- 机构类型，1：总行2：分行3：支行
    ,nvl(n.org_level, o.org_level) as org_level -- 机构层级，总行一级，下级依次递增，最多不超过六级
    ,nvl(n.corporcate_bank_num, o.corporcate_bank_num) as corporcate_bank_num -- 法人行行号
    ,nvl(n.corporate_name, o.corporate_name) as corporate_name -- 企业名称（合同用）
    ,nvl(n.core_org_num, o.core_org_num) as core_org_num -- 核心机构号
    ,nvl(n.business_label, o.business_label) as business_label -- 行业客群标签
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
from (select * from ${iol_schema}.hgls_loan_branch_website_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.hgls_loan_branch_website where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.bank_name <> n.bank_name
        or o.bank_phone <> n.bank_phone
        or o.province_region <> n.province_region
        or o.address <> n.address
        or o.start_time <> n.start_time
        or o.end_time <> n.end_time
        or o.system_type <> n.system_type
        or o.enterprise_code <> n.enterprise_code
        or o.org_num <> n.org_num
        or o.busi_cover_area <> n.busi_cover_area
        or o.create_date <> n.create_date
        or o.update_date <> n.update_date
        or o.isdel <> n.isdel
        or o.code <> n.code
        or o.bank_credit_accounts <> n.bank_credit_accounts
        or o.bank_credit_recheck_user <> n.bank_credit_recheck_user
        or o.parent_code <> n.parent_code
        or o.org_type <> n.org_type
        or o.org_level <> n.org_level
        or o.corporcate_bank_num <> n.corporcate_bank_num
        or o.corporate_name <> n.corporate_name
        or o.core_org_num <> n.core_org_num
        or o.business_label <> n.business_label
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.hgls_loan_branch_website_cl(
            id -- 主键id
            ,bank_name -- 支行名称
            ,bank_phone -- 支行电话
            ,province_region -- 支行住址的省市区,多级斜杠隔开
            ,address -- 支行具体地址
            ,start_time -- 营业开始时间
            ,end_time -- 营业结束时间
            ,system_type -- 系统类型，1，业务系统，2营销系统
            ,enterprise_code -- 企业注册码
            ,org_num -- 机构号
            ,busi_cover_area -- 业务覆盖区域
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识
            ,code -- 唯一编码
            ,bank_credit_accounts -- 机构征信查询账户
            ,bank_credit_recheck_user -- 机构征信复核用户
            ,parent_code -- 上级机构code
            ,org_type -- 机构类型，1：总行2：分行3：支行
            ,org_level -- 机构层级，总行一级，下级依次递增，最多不超过六级
            ,corporcate_bank_num -- 法人行行号
            ,corporate_name -- 企业名称（合同用）
            ,core_org_num -- 核心机构号
            ,business_label -- 行业客群标签
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.hgls_loan_branch_website_op(
            id -- 主键id
            ,bank_name -- 支行名称
            ,bank_phone -- 支行电话
            ,province_region -- 支行住址的省市区,多级斜杠隔开
            ,address -- 支行具体地址
            ,start_time -- 营业开始时间
            ,end_time -- 营业结束时间
            ,system_type -- 系统类型，1，业务系统，2营销系统
            ,enterprise_code -- 企业注册码
            ,org_num -- 机构号
            ,busi_cover_area -- 业务覆盖区域
            ,create_date -- 申请日期
            ,update_date -- 更新时间
            ,isdel -- 删除标识
            ,code -- 唯一编码
            ,bank_credit_accounts -- 机构征信查询账户
            ,bank_credit_recheck_user -- 机构征信复核用户
            ,parent_code -- 上级机构code
            ,org_type -- 机构类型，1：总行2：分行3：支行
            ,org_level -- 机构层级，总行一级，下级依次递增，最多不超过六级
            ,corporcate_bank_num -- 法人行行号
            ,corporate_name -- 企业名称（合同用）
            ,core_org_num -- 核心机构号
            ,business_label -- 行业客群标签
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键id
    ,o.bank_name -- 支行名称
    ,o.bank_phone -- 支行电话
    ,o.province_region -- 支行住址的省市区,多级斜杠隔开
    ,o.address -- 支行具体地址
    ,o.start_time -- 营业开始时间
    ,o.end_time -- 营业结束时间
    ,o.system_type -- 系统类型，1，业务系统，2营销系统
    ,o.enterprise_code -- 企业注册码
    ,o.org_num -- 机构号
    ,o.busi_cover_area -- 业务覆盖区域
    ,o.create_date -- 申请日期
    ,o.update_date -- 更新时间
    ,o.isdel -- 删除标识
    ,o.code -- 唯一编码
    ,o.bank_credit_accounts -- 机构征信查询账户
    ,o.bank_credit_recheck_user -- 机构征信复核用户
    ,o.parent_code -- 上级机构code
    ,o.org_type -- 机构类型，1：总行2：分行3：支行
    ,o.org_level -- 机构层级，总行一级，下级依次递增，最多不超过六级
    ,o.corporcate_bank_num -- 法人行行号
    ,o.corporate_name -- 企业名称（合同用）
    ,o.core_org_num -- 核心机构号
    ,o.business_label -- 行业客群标签
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
from ${iol_schema}.hgls_loan_branch_website_bk o
    left join ${iol_schema}.hgls_loan_branch_website_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.hgls_loan_branch_website_cl d
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
--truncate table ${iol_schema}.hgls_loan_branch_website;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('hgls_loan_branch_website') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.hgls_loan_branch_website drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.hgls_loan_branch_website add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.hgls_loan_branch_website exchange partition p_${batch_date} with table ${iol_schema}.hgls_loan_branch_website_cl;
alter table ${iol_schema}.hgls_loan_branch_website exchange partition p_20991231 with table ${iol_schema}.hgls_loan_branch_website_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.hgls_loan_branch_website to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.hgls_loan_branch_website_op purge;
drop table ${iol_schema}.hgls_loan_branch_website_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.hgls_loan_branch_website_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'hgls_loan_branch_website',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
