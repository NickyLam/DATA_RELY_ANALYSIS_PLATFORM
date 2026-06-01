/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_financial_product
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
create table ${iol_schema}.bdps_financial_product_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_financial_product;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_financial_product_op purge;
drop table ${iol_schema}.bdps_financial_product_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_financial_product_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_financial_product where 0=1;

create table ${iol_schema}.bdps_financial_product_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_financial_product where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_financial_product_cl(
            id -- 
            ,product_no -- 产品编号
            ,product_name -- 产品名称
            ,matudt -- 期限
            ,start_date -- 起息日
            ,maturity_date -- 到期日
            ,quotient -- 份额
            ,available_quotient -- 可用份额
            ,yield_rate -- 收益率
            ,is_breakeven -- 是否保本 11-保本12-非保本
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,product_type -- 产品类型
            ,bank_account -- 理财产品账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_financial_product_op(
            id -- 
            ,product_no -- 产品编号
            ,product_name -- 产品名称
            ,matudt -- 期限
            ,start_date -- 起息日
            ,maturity_date -- 到期日
            ,quotient -- 份额
            ,available_quotient -- 可用份额
            ,yield_rate -- 收益率
            ,is_breakeven -- 是否保本 11-保本12-非保本
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,product_type -- 产品类型
            ,bank_account -- 理财产品账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 
    ,nvl(n.product_no, o.product_no) as product_no -- 产品编号
    ,nvl(n.product_name, o.product_name) as product_name -- 产品名称
    ,nvl(n.matudt, o.matudt) as matudt -- 期限
    ,nvl(n.start_date, o.start_date) as start_date -- 起息日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.quotient, o.quotient) as quotient -- 份额
    ,nvl(n.available_quotient, o.available_quotient) as available_quotient -- 可用份额
    ,nvl(n.yield_rate, o.yield_rate) as yield_rate -- 收益率
    ,nvl(n.is_breakeven, o.is_breakeven) as is_breakeven -- 是否保本 11-保本12-非保本
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后更新时间
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.product_type, o.product_type) as product_type -- 产品类型
    ,nvl(n.bank_account, o.bank_account) as bank_account -- 理财产品账号
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
from (select * from ${iol_schema}.bdps_financial_product_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_financial_product where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.product_no <> n.product_no
        or o.product_name <> n.product_name
        or o.matudt <> n.matudt
        or o.start_date <> n.start_date
        or o.maturity_date <> n.maturity_date
        or o.quotient <> n.quotient
        or o.available_quotient <> n.available_quotient
        or o.yield_rate <> n.yield_rate
        or o.is_breakeven <> n.is_breakeven
        or o.last_upd_time <> n.last_upd_time
        or o.remark <> n.remark
        or o.product_type <> n.product_type
        or o.bank_account <> n.bank_account
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_financial_product_cl(
            id -- 
            ,product_no -- 产品编号
            ,product_name -- 产品名称
            ,matudt -- 期限
            ,start_date -- 起息日
            ,maturity_date -- 到期日
            ,quotient -- 份额
            ,available_quotient -- 可用份额
            ,yield_rate -- 收益率
            ,is_breakeven -- 是否保本 11-保本12-非保本
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,product_type -- 产品类型
            ,bank_account -- 理财产品账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_financial_product_op(
            id -- 
            ,product_no -- 产品编号
            ,product_name -- 产品名称
            ,matudt -- 期限
            ,start_date -- 起息日
            ,maturity_date -- 到期日
            ,quotient -- 份额
            ,available_quotient -- 可用份额
            ,yield_rate -- 收益率
            ,is_breakeven -- 是否保本 11-保本12-非保本
            ,last_upd_time -- 最后更新时间
            ,remark -- 备注
            ,product_type -- 产品类型
            ,bank_account -- 理财产品账号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 
    ,o.product_no -- 产品编号
    ,o.product_name -- 产品名称
    ,o.matudt -- 期限
    ,o.start_date -- 起息日
    ,o.maturity_date -- 到期日
    ,o.quotient -- 份额
    ,o.available_quotient -- 可用份额
    ,o.yield_rate -- 收益率
    ,o.is_breakeven -- 是否保本 11-保本12-非保本
    ,o.last_upd_time -- 最后更新时间
    ,o.remark -- 备注
    ,o.product_type -- 产品类型
    ,o.bank_account -- 理财产品账号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_financial_product_bk o
    left join ${iol_schema}.bdps_financial_product_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_financial_product_cl d
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
-- truncate table ${iol_schema}.bdps_financial_product;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_financial_product exchange partition p_19000101 with table ${iol_schema}.bdps_financial_product_cl;
alter table ${iol_schema}.bdps_financial_product exchange partition p_20991231 with table ${iol_schema}.bdps_financial_product_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_financial_product to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_financial_product_op purge;
drop table ${iol_schema}.bdps_financial_product_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_financial_product_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_financial_product',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
