/*
Purpose:    偏源模型层-增量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_wind_insurerpremiumincome
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
whenever sqlerror continue none ;
create table ${iol_schema}.wind_insurerpremiumincome_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.wind_insurerpremiumincome;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_insurerpremiumincome_op purge;
drop table ${iol_schema}.wind_insurerpremiumincome_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.wind_insurerpremiumincome_op nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_insurerpremiumincome where 0=1;

create table ${iol_schema}.wind_insurerpremiumincome_cl nologging
compress ${option_switch} for query high
as select * from ${iol_schema}.wind_insurerpremiumincome where 0=1;

-- 3.1 get new, alter data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ into ${iol_schema}.wind_insurerpremiumincome_op(
        object_id -- 对象ID
        ,monthly -- 月度
        ,insurance_company -- 保险公司
        ,premium_category -- 保费类别
        ,company_category -- [内部]公司类别
        ,income -- 收入(万元)
        ,s_info_compcode -- 保险公司id
        ,enterprise_annuity -- 企业年金缴费
        ,entrusted_assets -- 受托管理资产
        ,investment_assets -- 投资管理资产
        ,insured_inv_newly_added -- 保户投资款新增缴费
        ,inv_linked_insurance_added -- 投连险独立账户新增增缴费
        ,start_dt -- 开始时间
        ,end_dt -- 结束时间
        ,id_mark -- 增删标志
        ,etl_timestamp -- ETL处理时间戳
    )
select
    n.object_id -- 对象ID
    ,n.monthly -- 月度
    ,n.insurance_company -- 保险公司
    ,n.premium_category -- 保费类别
    ,n.company_category -- [内部]公司类别
    ,n.income -- 收入(万元)
    ,n.s_info_compcode -- 保险公司id
    ,n.enterprise_annuity -- 企业年金缴费
    ,n.entrusted_assets -- 受托管理资产
    ,n.investment_assets -- 投资管理资产
    ,n.insured_inv_newly_added -- 保户投资款新增缴费
    ,n.inv_linked_insurance_added -- 投连险独立账户新增增缴费
    ,to_date('${batch_date}', 'yyyymmdd') as start_dt -- 开始时间
    ,to_date('20991231', 'yyyymmdd') as end_dt -- 结束时间
    ,'I' as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.wind_insurerpremiumincome_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd')) o
    right join (select * from ${itl_schema}.wind_insurerpremiumincome where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.monthly = n.monthly
            and o.insurance_company = n.insurance_company
            and o.premium_category = n.premium_category
            and o.company_category = n.company_category
where (
        o.monthly is null
        and o.insurance_company is null
        and o.premium_category is null
        and o.company_category is null
    )
    or (
        o.object_id <> n.object_id
        or o.income <> n.income
        or o.s_info_compcode <> n.s_info_compcode
        or o.enterprise_annuity <> n.enterprise_annuity
        or o.entrusted_assets <> n.entrusted_assets
        or o.investment_assets <> n.investment_assets
        or o.insured_inv_newly_added <> n.insured_inv_newly_added
        or o.inv_linked_insurance_added <> n.inv_linked_insurance_added
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.wind_insurerpremiumincome_cl(
            object_id -- 对象ID
        ,monthly -- 月度
        ,insurance_company -- 保险公司
        ,premium_category -- 保费类别
        ,company_category -- [内部]公司类别
        ,income -- 收入(万元)
        ,s_info_compcode -- 保险公司id
        ,enterprise_annuity -- 企业年金缴费
        ,entrusted_assets -- 受托管理资产
        ,investment_assets -- 投资管理资产
        ,insured_inv_newly_added -- 保户投资款新增缴费
        ,inv_linked_insurance_added -- 投连险独立账户新增增缴费
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.wind_insurerpremiumincome_op(
            object_id -- 对象ID
        ,monthly -- 月度
        ,insurance_company -- 保险公司
        ,premium_category -- 保费类别
        ,company_category -- [内部]公司类别
        ,income -- 收入(万元)
        ,s_info_compcode -- 保险公司id
        ,enterprise_annuity -- 企业年金缴费
        ,entrusted_assets -- 受托管理资产
        ,investment_assets -- 投资管理资产
        ,insured_inv_newly_added -- 保户投资款新增缴费
        ,inv_linked_insurance_added -- 投连险独立账户新增增缴费
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.object_id -- 对象ID
    ,o.monthly -- 月度
    ,o.insurance_company -- 保险公司
    ,o.premium_category -- 保费类别
    ,o.company_category -- [内部]公司类别
    ,o.income -- 收入(万元)
    ,o.s_info_compcode -- 保险公司id
    ,o.enterprise_annuity -- 企业年金缴费
    ,o.entrusted_assets -- 受托管理资产
    ,o.investment_assets -- 投资管理资产
    ,o.insured_inv_newly_added -- 保户投资款新增缴费
    ,o.inv_linked_insurance_added -- 投连险独立账户新增增缴费
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,case when n.start_dt is not null then 'I'
          when o.end_dt>=to_date('${batch_date}','yyyymmdd') then 'I'
          else o.id_mark
     end as id_mark  -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.wind_insurerpremiumincome_bk o
    left join ${iol_schema}.wind_insurerpremiumincome_op n
        on
            o.monthly = n.monthly
            and o.insurance_company = n.insurance_company
            and o.premium_category = n.premium_category
            and o.company_category = n.company_category
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
where o.start_dt < to_date('${batch_date}','yyyymmdd')
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.wind_insurerpremiumincome;

-- 4.2 exchange partition
alter table ${iol_schema}.wind_insurerpremiumincome exchange partition p_19000101 with table ${iol_schema}.wind_insurerpremiumincome_cl;
alter table ${iol_schema}.wind_insurerpremiumincome exchange partition p_20991231 with table ${iol_schema}.wind_insurerpremiumincome_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.wind_insurerpremiumincome to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.wind_insurerpremiumincome_op purge;
drop table ${iol_schema}.wind_insurerpremiumincome_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.wind_insurerpremiumincome_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'wind_insurerpremiumincome',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
