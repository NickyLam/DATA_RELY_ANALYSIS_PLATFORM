/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_irproduct_paymentinfo
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
create table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_irproduct_paymentinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_op purge;
drop table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_irproduct_paymentinfo where 0=1;

create table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_irproduct_paymentinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_cl(
            i_code -- 金融工具代码
            ,a_type -- 金融工具资产类型
            ,m_type -- 金融工具市场类型
            ,payment_date -- 支付日期
            ,notional -- 本金
            ,ai -- 利息
            ,amount -- 总金额
            ,updatetime -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_op(
            i_code -- 金融工具代码
            ,a_type -- 金融工具资产类型
            ,m_type -- 金融工具市场类型
            ,payment_date -- 支付日期
            ,notional -- 本金
            ,ai -- 利息
            ,amount -- 总金额
            ,updatetime -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 金融工具资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 金融工具市场类型
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 支付日期
    ,nvl(n.notional, o.notional) as notional -- 本金
    ,nvl(n.ai, o.ai) as ai -- 利息
    ,nvl(n.amount, o.amount) as amount -- 总金额
    ,nvl(n.updatetime, o.updatetime) as updatetime -- 更新时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.payment_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.payment_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.payment_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_irproduct_paymentinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.payment_date = n.payment_date
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
        and o.payment_date is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
        and n.payment_date is null
    )
    or (
        o.notional <> n.notional
        or o.ai <> n.ai
        or o.amount <> n.amount
        or o.updatetime <> n.updatetime
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_cl(
            i_code -- 金融工具代码
            ,a_type -- 金融工具资产类型
            ,m_type -- 金融工具市场类型
            ,payment_date -- 支付日期
            ,notional -- 本金
            ,ai -- 利息
            ,amount -- 总金额
            ,updatetime -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_op(
            i_code -- 金融工具代码
            ,a_type -- 金融工具资产类型
            ,m_type -- 金融工具市场类型
            ,payment_date -- 支付日期
            ,notional -- 本金
            ,ai -- 利息
            ,amount -- 总金额
            ,updatetime -- 更新时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 金融工具代码
    ,o.a_type -- 金融工具资产类型
    ,o.m_type -- 金融工具市场类型
    ,o.payment_date -- 支付日期
    ,o.notional -- 本金
    ,o.ai -- 利息
    ,o.amount -- 总金额
    ,o.updatetime -- 更新时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_bk o
    left join ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.payment_date = n.payment_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
            and o.payment_date = d.payment_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_cl;
alter table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_irproduct_paymentinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_op purge;
drop table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_irproduct_paymentinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_irproduct_paymentinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
