/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_bdps_property_payment_info
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
create table ${iol_schema}.bdps_property_payment_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.bdps_property_payment_info;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_property_payment_info_op purge;
drop table ${iol_schema}.bdps_property_payment_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.bdps_property_payment_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_property_payment_info where 0=1;

create table ${iol_schema}.bdps_property_payment_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.bdps_property_payment_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_property_payment_info_cl(
            id -- 序号、主键
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,property_type -- 资产类型 1-理财产品
            ,product_no -- 产品编号
            ,cust_no -- 客户号
            ,txn_type -- 回款来源 系统简称
            ,is_coneal -- 是否止付 0- 否1- 是
            ,bail_account -- 保证金账号
            ,bail_sub_no -- 保证金账号子户
            ,payment_flag -- 是否兑付成功 0- 否1- 是
            ,payment_date -- 兑付日期
            ,total_amt -- 金额
            ,remark -- 附言
            ,last_upd_time -- 最后更新时间
            ,misc -- 备注
            ,profit_amt -- 收益金额
            ,coneal_nbr -- 止付流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_property_payment_info_op(
            id -- 序号、主键
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,property_type -- 资产类型 1-理财产品
            ,product_no -- 产品编号
            ,cust_no -- 客户号
            ,txn_type -- 回款来源 系统简称
            ,is_coneal -- 是否止付 0- 否1- 是
            ,bail_account -- 保证金账号
            ,bail_sub_no -- 保证金账号子户
            ,payment_flag -- 是否兑付成功 0- 否1- 是
            ,payment_date -- 兑付日期
            ,total_amt -- 金额
            ,remark -- 附言
            ,last_upd_time -- 最后更新时间
            ,misc -- 备注
            ,profit_amt -- 收益金额
            ,coneal_nbr -- 止付流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.id, o.id) as id -- 序号、主键
    ,nvl(n.property_id, o.property_id) as property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
    ,nvl(n.property_type, o.property_type) as property_type -- 资产类型 1-理财产品
    ,nvl(n.product_no, o.product_no) as product_no -- 产品编号
    ,nvl(n.cust_no, o.cust_no) as cust_no -- 客户号
    ,nvl(n.txn_type, o.txn_type) as txn_type -- 回款来源 系统简称
    ,nvl(n.is_coneal, o.is_coneal) as is_coneal -- 是否止付 0- 否1- 是
    ,nvl(n.bail_account, o.bail_account) as bail_account -- 保证金账号
    ,nvl(n.bail_sub_no, o.bail_sub_no) as bail_sub_no -- 保证金账号子户
    ,nvl(n.payment_flag, o.payment_flag) as payment_flag -- 是否兑付成功 0- 否1- 是
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 兑付日期
    ,nvl(n.total_amt, o.total_amt) as total_amt -- 金额
    ,nvl(n.remark, o.remark) as remark -- 附言
    ,nvl(n.last_upd_time, o.last_upd_time) as last_upd_time -- 最后更新时间
    ,nvl(n.misc, o.misc) as misc -- 备注
    ,nvl(n.profit_amt, o.profit_amt) as profit_amt -- 收益金额
    ,nvl(n.coneal_nbr, o.coneal_nbr) as coneal_nbr -- 止付流水
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
from (select * from ${iol_schema}.bdps_property_payment_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.bdps_property_payment_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.id = n.id
where (
        o.id is null
    )
    or (
        n.id is null
    )
    or (
        o.property_id <> n.property_id
        or o.property_type <> n.property_type
        or o.product_no <> n.product_no
        or o.cust_no <> n.cust_no
        or o.txn_type <> n.txn_type
        or o.is_coneal <> n.is_coneal
        or o.bail_account <> n.bail_account
        or o.bail_sub_no <> n.bail_sub_no
        or o.payment_flag <> n.payment_flag
        or o.payment_date <> n.payment_date
        or o.total_amt <> n.total_amt
        or o.remark <> n.remark
        or o.last_upd_time <> n.last_upd_time
        or o.misc <> n.misc
        or o.profit_amt <> n.profit_amt
        or o.coneal_nbr <> n.coneal_nbr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.bdps_property_payment_info_cl(
            id -- 序号、主键
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,property_type -- 资产类型 1-理财产品
            ,product_no -- 产品编号
            ,cust_no -- 客户号
            ,txn_type -- 回款来源 系统简称
            ,is_coneal -- 是否止付 0- 否1- 是
            ,bail_account -- 保证金账号
            ,bail_sub_no -- 保证金账号子户
            ,payment_flag -- 是否兑付成功 0- 否1- 是
            ,payment_date -- 兑付日期
            ,total_amt -- 金额
            ,remark -- 附言
            ,last_upd_time -- 最后更新时间
            ,misc -- 备注
            ,profit_amt -- 收益金额
            ,coneal_nbr -- 止付流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.bdps_property_payment_info_op(
            id -- 序号、主键
            ,property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
            ,property_type -- 资产类型 1-理财产品
            ,product_no -- 产品编号
            ,cust_no -- 客户号
            ,txn_type -- 回款来源 系统简称
            ,is_coneal -- 是否止付 0- 否1- 是
            ,bail_account -- 保证金账号
            ,bail_sub_no -- 保证金账号子户
            ,payment_flag -- 是否兑付成功 0- 否1- 是
            ,payment_date -- 兑付日期
            ,total_amt -- 金额
            ,remark -- 附言
            ,last_upd_time -- 最后更新时间
            ,misc -- 备注
            ,profit_amt -- 收益金额
            ,coneal_nbr -- 止付流水
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.id -- 序号、主键
    ,o.property_id -- 资产ID 关联“CUSTOMER_PROPERTY_INFO”的id
    ,o.property_type -- 资产类型 1-理财产品
    ,o.product_no -- 产品编号
    ,o.cust_no -- 客户号
    ,o.txn_type -- 回款来源 系统简称
    ,o.is_coneal -- 是否止付 0- 否1- 是
    ,o.bail_account -- 保证金账号
    ,o.bail_sub_no -- 保证金账号子户
    ,o.payment_flag -- 是否兑付成功 0- 否1- 是
    ,o.payment_date -- 兑付日期
    ,o.total_amt -- 金额
    ,o.remark -- 附言
    ,o.last_upd_time -- 最后更新时间
    ,o.misc -- 备注
    ,o.profit_amt -- 收益金额
    ,o.coneal_nbr -- 止付流水
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.bdps_property_payment_info_bk o
    left join ${iol_schema}.bdps_property_payment_info_op n
        on
            o.id = n.id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.bdps_property_payment_info_cl d
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
-- truncate table ${iol_schema}.bdps_property_payment_info;

-- 4.2 exchange partition
alter table ${iol_schema}.bdps_property_payment_info exchange partition p_19000101 with table ${iol_schema}.bdps_property_payment_info_cl;
alter table ${iol_schema}.bdps_property_payment_info exchange partition p_20991231 with table ${iol_schema}.bdps_property_payment_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.bdps_property_payment_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.bdps_property_payment_info_op purge;
drop table ${iol_schema}.bdps_property_payment_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.bdps_property_payment_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'bdps_property_payment_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
