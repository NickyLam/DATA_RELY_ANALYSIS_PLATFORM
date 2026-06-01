/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_finance_body
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
create table ${iol_schema}.ibms_ttrd_finance_body_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_finance_body;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_finance_body_op purge;
drop table ${iol_schema}.ibms_ttrd_finance_body_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_finance_body_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_finance_body where 0=1;

create table ${iol_schema}.ibms_ttrd_finance_body_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_finance_body where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_finance_body_cl(
            id -- 主键
            ,i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,actual_financier_id -- 融资人客户号
            ,financier_name -- 融资人名称
            ,financier_nature -- 融资人客户性质
            ,parent_group -- 融资人所属集团
            ,province_id -- 
            ,comp_area_province -- 融资人注册地（省）
            ,city_id -- 
            ,comp_area_city -- 融资人注册地（市）
            ,invest_amount -- 投资金额（元）
            ,financier_relevance_info -- 实际融资人关联方信息(华兴需求)
            ,business_category -- 行业归属
            ,business_category_name -- 行业归属名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_finance_body_op(
            id -- 主键
            ,i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,actual_financier_id -- 融资人客户号
            ,financier_name -- 融资人名称
            ,financier_nature -- 融资人客户性质
            ,parent_group -- 融资人所属集团
            ,province_id -- 
            ,comp_area_province -- 融资人注册地（省）
            ,city_id -- 
            ,comp_area_city -- 融资人注册地（市）
            ,invest_amount -- 投资金额（元）
            ,financier_relevance_info -- 实际融资人关联方信息(华兴需求)
            ,business_category -- 行业归属
            ,business_category_name -- 行业归属名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.i_code, o.i_code) as i_code -- 
    ,nvl(n.a_type, o.a_type) as a_type -- 
    ,nvl(n.m_type, o.m_type) as m_type -- 
    ,nvl(n.actual_financier_id, o.actual_financier_id) as actual_financier_id -- 融资人客户号
    ,nvl(n.financier_name, o.financier_name) as financier_name -- 融资人名称
    ,nvl(n.financier_nature, o.financier_nature) as financier_nature -- 融资人客户性质
    ,nvl(n.parent_group, o.parent_group) as parent_group -- 融资人所属集团
    ,nvl(n.province_id, o.province_id) as province_id -- 
    ,nvl(n.comp_area_province, o.comp_area_province) as comp_area_province -- 融资人注册地（省）
    ,nvl(n.city_id, o.city_id) as city_id -- 
    ,nvl(n.comp_area_city, o.comp_area_city) as comp_area_city -- 融资人注册地（市）
    ,nvl(n.invest_amount, o.invest_amount) as invest_amount -- 投资金额（元）
    ,nvl(n.financier_relevance_info, o.financier_relevance_info) as financier_relevance_info -- 实际融资人关联方信息(华兴需求)
    ,nvl(n.business_category, o.business_category) as business_category -- 行业归属
    ,nvl(n.business_category_name, o.business_category_name) as business_category_name -- 行业归属名称
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
from (select * from ${iol_schema}.ibms_ttrd_finance_body_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_finance_body where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.i_code <> n.i_code
        or o.a_type <> n.a_type
        or o.m_type <> n.m_type
        or o.actual_financier_id <> n.actual_financier_id
        or o.financier_name <> n.financier_name
        or o.financier_nature <> n.financier_nature
        or o.parent_group <> n.parent_group
        or o.province_id <> n.province_id
        or o.comp_area_province <> n.comp_area_province
        or o.city_id <> n.city_id
        or o.comp_area_city <> n.comp_area_city
        or o.invest_amount <> n.invest_amount
        or o.financier_relevance_info <> n.financier_relevance_info
        or o.business_category <> n.business_category
        or o.business_category_name <> n.business_category_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_finance_body_cl(
            id -- 主键
            ,i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,actual_financier_id -- 融资人客户号
            ,financier_name -- 融资人名称
            ,financier_nature -- 融资人客户性质
            ,parent_group -- 融资人所属集团
            ,province_id -- 
            ,comp_area_province -- 融资人注册地（省）
            ,city_id -- 
            ,comp_area_city -- 融资人注册地（市）
            ,invest_amount -- 投资金额（元）
            ,financier_relevance_info -- 实际融资人关联方信息(华兴需求)
            ,business_category -- 行业归属
            ,business_category_name -- 行业归属名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_finance_body_op(
            id -- 主键
            ,i_code -- 
            ,a_type -- 
            ,m_type -- 
            ,actual_financier_id -- 融资人客户号
            ,financier_name -- 融资人名称
            ,financier_nature -- 融资人客户性质
            ,parent_group -- 融资人所属集团
            ,province_id -- 
            ,comp_area_province -- 融资人注册地（省）
            ,city_id -- 
            ,comp_area_city -- 融资人注册地（市）
            ,invest_amount -- 投资金额（元）
            ,financier_relevance_info -- 实际融资人关联方信息(华兴需求)
            ,business_category -- 行业归属
            ,business_category_name -- 行业归属名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.i_code -- 
    ,o.a_type -- 
    ,o.m_type -- 
    ,o.actual_financier_id -- 融资人客户号
    ,o.financier_name -- 融资人名称
    ,o.financier_nature -- 融资人客户性质
    ,o.parent_group -- 融资人所属集团
    ,o.province_id -- 
    ,o.comp_area_province -- 融资人注册地（省）
    ,o.city_id -- 
    ,o.comp_area_city -- 融资人注册地（市）
    ,o.invest_amount -- 投资金额（元）
    ,o.financier_relevance_info -- 实际融资人关联方信息(华兴需求)
    ,o.business_category -- 行业归属
    ,o.business_category_name -- 行业归属名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_finance_body_bk o
    left join ${iol_schema}.ibms_ttrd_finance_body_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_finance_body_cl d
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
-- truncate table ${iol_schema}.ibms_ttrd_finance_body;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_finance_body exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_finance_body_cl;
alter table ${iol_schema}.ibms_ttrd_finance_body exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_finance_body_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_finance_body to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_finance_body_op purge;
drop table ${iol_schema}.ibms_ttrd_finance_body_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_finance_body_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_finance_body',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
