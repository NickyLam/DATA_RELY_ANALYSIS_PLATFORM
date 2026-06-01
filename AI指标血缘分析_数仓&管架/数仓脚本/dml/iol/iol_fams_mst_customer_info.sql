/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_fams_mst_customer_info
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
create table ${iol_schema}.fams_mst_customer_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.fams_mst_customer_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_customer_info_op purge;
drop table ${iol_schema}.fams_mst_customer_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.fams_mst_customer_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_customer_info where 0=1;

create table ${iol_schema}.fams_mst_customer_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.fams_mst_customer_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_customer_info_cl(
            customer_id -- 客户代码
            ,customer_name -- 客户名称
            ,customer_abbr -- 客户简称
            ,customer_type -- 客户类型，企业法人、自然人
            ,is_issuer -- 是否发行人
            ,is_asste_manager -- 是否管理人
            ,is_truster -- 是否托管人
            ,is_saler -- 是否承销商
            ,is_financier -- 是否融资人
            ,is_guarantee -- 是否担保人
            ,is_rating_agencies -- 是否评级机构
            ,is_pledgor -- 是否出质人
            ,is_deposit_bank -- 是否存放行
            ,is_invest_adviser -- 是否投资顾问
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_mst_customer_info_op(
            customer_id -- 客户代码
            ,customer_name -- 客户名称
            ,customer_abbr -- 客户简称
            ,customer_type -- 客户类型，企业法人、自然人
            ,is_issuer -- 是否发行人
            ,is_asste_manager -- 是否管理人
            ,is_truster -- 是否托管人
            ,is_saler -- 是否承销商
            ,is_financier -- 是否融资人
            ,is_guarantee -- 是否担保人
            ,is_rating_agencies -- 是否评级机构
            ,is_pledgor -- 是否出质人
            ,is_deposit_bank -- 是否存放行
            ,is_invest_adviser -- 是否投资顾问
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.customer_id, o.customer_id) as customer_id -- 客户代码
    ,nvl(n.customer_name, o.customer_name) as customer_name -- 客户名称
    ,nvl(n.customer_abbr, o.customer_abbr) as customer_abbr -- 客户简称
    ,nvl(n.customer_type, o.customer_type) as customer_type -- 客户类型，企业法人、自然人
    ,nvl(n.is_issuer, o.is_issuer) as is_issuer -- 是否发行人
    ,nvl(n.is_asste_manager, o.is_asste_manager) as is_asste_manager -- 是否管理人
    ,nvl(n.is_truster, o.is_truster) as is_truster -- 是否托管人
    ,nvl(n.is_saler, o.is_saler) as is_saler -- 是否承销商
    ,nvl(n.is_financier, o.is_financier) as is_financier -- 是否融资人
    ,nvl(n.is_guarantee, o.is_guarantee) as is_guarantee -- 是否担保人
    ,nvl(n.is_rating_agencies, o.is_rating_agencies) as is_rating_agencies -- 是否评级机构
    ,nvl(n.is_pledgor, o.is_pledgor) as is_pledgor -- 是否出质人
    ,nvl(n.is_deposit_bank, o.is_deposit_bank) as is_deposit_bank -- 是否存放行
    ,nvl(n.is_invest_adviser, o.is_invest_adviser) as is_invest_adviser -- 是否投资顾问
    ,nvl(n.create_user, o.create_user) as create_user -- 创建人
    ,nvl(n.create_dept, o.create_dept) as create_dept -- 创建部门
    ,nvl(n.create_time, o.create_time) as create_time -- 创建时间
    ,nvl(n.update_user, o.update_user) as update_user -- 更新人
    ,nvl(n.update_time, o.update_time) as update_time -- 更新时间
    ,case when
            n.customer_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.customer_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.customer_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.fams_mst_customer_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.fams_mst_customer_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.customer_id = n.customer_id
where (
        o.customer_id is null
    )
    or (
        n.customer_id is null
    )
    or (
        o.customer_name <> n.customer_name
        or o.customer_abbr <> n.customer_abbr
        or o.customer_type <> n.customer_type
        or o.is_issuer <> n.is_issuer
        or o.is_asste_manager <> n.is_asste_manager
        or o.is_truster <> n.is_truster
        or o.is_saler <> n.is_saler
        or o.is_financier <> n.is_financier
        or o.is_guarantee <> n.is_guarantee
        or o.is_rating_agencies <> n.is_rating_agencies
        or o.is_pledgor <> n.is_pledgor
        or o.is_deposit_bank <> n.is_deposit_bank
        or o.is_invest_adviser <> n.is_invest_adviser
        or o.create_user <> n.create_user
        or o.create_dept <> n.create_dept
        or o.create_time <> n.create_time
        or o.update_user <> n.update_user
        or o.update_time <> n.update_time
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.fams_mst_customer_info_cl(
            customer_id -- 客户代码
            ,customer_name -- 客户名称
            ,customer_abbr -- 客户简称
            ,customer_type -- 客户类型，企业法人、自然人
            ,is_issuer -- 是否发行人
            ,is_asste_manager -- 是否管理人
            ,is_truster -- 是否托管人
            ,is_saler -- 是否承销商
            ,is_financier -- 是否融资人
            ,is_guarantee -- 是否担保人
            ,is_rating_agencies -- 是否评级机构
            ,is_pledgor -- 是否出质人
            ,is_deposit_bank -- 是否存放行
            ,is_invest_adviser -- 是否投资顾问
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.fams_mst_customer_info_op(
            customer_id -- 客户代码
            ,customer_name -- 客户名称
            ,customer_abbr -- 客户简称
            ,customer_type -- 客户类型，企业法人、自然人
            ,is_issuer -- 是否发行人
            ,is_asste_manager -- 是否管理人
            ,is_truster -- 是否托管人
            ,is_saler -- 是否承销商
            ,is_financier -- 是否融资人
            ,is_guarantee -- 是否担保人
            ,is_rating_agencies -- 是否评级机构
            ,is_pledgor -- 是否出质人
            ,is_deposit_bank -- 是否存放行
            ,is_invest_adviser -- 是否投资顾问
            ,create_user -- 创建人
            ,create_dept -- 创建部门
            ,create_time -- 创建时间
            ,update_user -- 更新人
            ,update_time -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.customer_id -- 客户代码
    ,o.customer_name -- 客户名称
    ,o.customer_abbr -- 客户简称
    ,o.customer_type -- 客户类型，企业法人、自然人
    ,o.is_issuer -- 是否发行人
    ,o.is_asste_manager -- 是否管理人
    ,o.is_truster -- 是否托管人
    ,o.is_saler -- 是否承销商
    ,o.is_financier -- 是否融资人
    ,o.is_guarantee -- 是否担保人
    ,o.is_rating_agencies -- 是否评级机构
    ,o.is_pledgor -- 是否出质人
    ,o.is_deposit_bank -- 是否存放行
    ,o.is_invest_adviser -- 是否投资顾问
    ,o.create_user -- 创建人
    ,o.create_dept -- 创建部门
    ,o.create_time -- 创建时间
    ,o.update_user -- 更新人
    ,o.update_time -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.fams_mst_customer_info_bk o
    left join ${iol_schema}.fams_mst_customer_info_op n
        on
            o.customer_id = n.customer_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.fams_mst_customer_info_cl d
        on
            o.customer_id = d.customer_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.fams_mst_customer_info;

-- 4.2 exchange partition
alter table ${iol_schema}.fams_mst_customer_info exchange partition p_19000101 with table ${iol_schema}.fams_mst_customer_info_cl;
alter table ${iol_schema}.fams_mst_customer_info exchange partition p_20991231 with table ${iol_schema}.fams_mst_customer_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.fams_mst_customer_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.fams_mst_customer_info_op purge;
drop table ${iol_schema}.fams_mst_customer_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.fams_mst_customer_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'fams_mst_customer_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
