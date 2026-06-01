/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_nfss_ca_product_additional_info
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
create table ${iol_schema}.nfss_ca_product_additional_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.nfss_ca_product_additional_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_ca_product_additional_info_op purge;
drop table ${iol_schema}.nfss_ca_product_additional_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.nfss_ca_product_additional_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_ca_product_additional_info where 0=1;

create table ${iol_schema}.nfss_ca_product_additional_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.nfss_ca_product_additional_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_ca_product_additional_info_cl(
            id -- 主键
            ,prod_id -- 关联产品表id
            ,prd_cd -- 产品代码
            ,prd_name -- 产品名称
            ,prod_desc -- 产品说明
            ,invest_direction -- 投资方向
            ,invt_range -- 投资范围
            ,inc_measr -- 增信措施
            ,purch_rule -- 购买规则
            ,income_rule -- 收益规则
            ,rede_rule -- 赎回规则
            ,liqdt_cash -- 清算兑付
            ,created_time -- 创建时间
            ,created_by -- 创建人
            ,updated_time -- 更新时间
            ,updated_by -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_ca_product_additional_info_op(
            id -- 主键
            ,prod_id -- 关联产品表id
            ,prd_cd -- 产品代码
            ,prd_name -- 产品名称
            ,prod_desc -- 产品说明
            ,invest_direction -- 投资方向
            ,invt_range -- 投资范围
            ,inc_measr -- 增信措施
            ,purch_rule -- 购买规则
            ,income_rule -- 收益规则
            ,rede_rule -- 赎回规则
            ,liqdt_cash -- 清算兑付
            ,created_time -- 创建时间
            ,created_by -- 创建人
            ,updated_time -- 更新时间
            ,updated_by -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 主键
    ,nvl(n.prod_id, o.prod_id) as prod_id -- 关联产品表id
    ,nvl(n.prd_cd, o.prd_cd) as prd_cd -- 产品代码
    ,nvl(n.prd_name, o.prd_name) as prd_name -- 产品名称
    ,nvl(n.prod_desc, o.prod_desc) as prod_desc -- 产品说明
    ,nvl(n.invest_direction, o.invest_direction) as invest_direction -- 投资方向
    ,nvl(n.invt_range, o.invt_range) as invt_range -- 投资范围
    ,nvl(n.inc_measr, o.inc_measr) as inc_measr -- 增信措施
    ,nvl(n.purch_rule, o.purch_rule) as purch_rule -- 购买规则
    ,nvl(n.income_rule, o.income_rule) as income_rule -- 收益规则
    ,nvl(n.rede_rule, o.rede_rule) as rede_rule -- 赎回规则
    ,nvl(n.liqdt_cash, o.liqdt_cash) as liqdt_cash -- 清算兑付
    ,nvl(n.created_time, o.created_time) as created_time -- 创建时间
    ,nvl(n.created_by, o.created_by) as created_by -- 创建人
    ,nvl(n.updated_time, o.updated_time) as updated_time -- 更新时间
    ,nvl(n.updated_by, o.updated_by) as updated_by -- 更新人
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
from (select * from ${iol_schema}.nfss_ca_product_additional_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.nfss_ca_product_additional_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.prod_id <> n.prod_id
        or o.prd_cd <> n.prd_cd
        or o.prd_name <> n.prd_name
        or o.prod_desc <> n.prod_desc
        or o.invest_direction <> n.invest_direction
        or o.invt_range <> n.invt_range
        or o.inc_measr <> n.inc_measr
        or o.purch_rule <> n.purch_rule
        or o.income_rule <> n.income_rule
        or o.rede_rule <> n.rede_rule
        or o.liqdt_cash <> n.liqdt_cash
        or o.created_time <> n.created_time
        or o.created_by <> n.created_by
        or o.updated_time <> n.updated_time
        or o.updated_by <> n.updated_by
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.nfss_ca_product_additional_info_cl(
            id -- 主键
            ,prod_id -- 关联产品表id
            ,prd_cd -- 产品代码
            ,prd_name -- 产品名称
            ,prod_desc -- 产品说明
            ,invest_direction -- 投资方向
            ,invt_range -- 投资范围
            ,inc_measr -- 增信措施
            ,purch_rule -- 购买规则
            ,income_rule -- 收益规则
            ,rede_rule -- 赎回规则
            ,liqdt_cash -- 清算兑付
            ,created_time -- 创建时间
            ,created_by -- 创建人
            ,updated_time -- 更新时间
            ,updated_by -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.nfss_ca_product_additional_info_op(
            id -- 主键
            ,prod_id -- 关联产品表id
            ,prd_cd -- 产品代码
            ,prd_name -- 产品名称
            ,prod_desc -- 产品说明
            ,invest_direction -- 投资方向
            ,invt_range -- 投资范围
            ,inc_measr -- 增信措施
            ,purch_rule -- 购买规则
            ,income_rule -- 收益规则
            ,rede_rule -- 赎回规则
            ,liqdt_cash -- 清算兑付
            ,created_time -- 创建时间
            ,created_by -- 创建人
            ,updated_time -- 更新时间
            ,updated_by -- 更新人
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 主键
    ,o.prod_id -- 关联产品表id
    ,o.prd_cd -- 产品代码
    ,o.prd_name -- 产品名称
    ,o.prod_desc -- 产品说明
    ,o.invest_direction -- 投资方向
    ,o.invt_range -- 投资范围
    ,o.inc_measr -- 增信措施
    ,o.purch_rule -- 购买规则
    ,o.income_rule -- 收益规则
    ,o.rede_rule -- 赎回规则
    ,o.liqdt_cash -- 清算兑付
    ,o.created_time -- 创建时间
    ,o.created_by -- 创建人
    ,o.updated_time -- 更新时间
    ,o.updated_by -- 更新人
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.nfss_ca_product_additional_info_bk o
    left join ${iol_schema}.nfss_ca_product_additional_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.nfss_ca_product_additional_info_cl d
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
-- truncate table ${iol_schema}.nfss_ca_product_additional_info;

-- 4.2 exchange partition
alter table ${iol_schema}.nfss_ca_product_additional_info exchange partition p_19000101 with table ${iol_schema}.nfss_ca_product_additional_info_cl;
alter table ${iol_schema}.nfss_ca_product_additional_info exchange partition p_20991231 with table ${iol_schema}.nfss_ca_product_additional_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.nfss_ca_product_additional_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.nfss_ca_product_additional_info_op purge;
drop table ${iol_schema}.nfss_ca_product_additional_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.nfss_ca_product_additional_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'nfss_ca_product_additional_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
