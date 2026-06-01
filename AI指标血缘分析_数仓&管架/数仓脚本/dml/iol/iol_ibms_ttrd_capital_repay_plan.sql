/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ibms_ttrd_capital_repay_plan
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
create table ${iol_schema}.ibms_ttrd_capital_repay_plan_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ibms_ttrd_capital_repay_plan;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_capital_repay_plan_op purge;
drop table ${iol_schema}.ibms_ttrd_capital_repay_plan_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ibms_ttrd_capital_repay_plan_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_capital_repay_plan where 0=1;

create table ${iol_schema}.ibms_ttrd_capital_repay_plan_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ibms_ttrd_capital_repay_plan where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_capital_repay_plan_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,amount -- 还本金额
            ,repay_date -- 还款日期
            ,repay_type -- 还款类型0：还本1：付息
            ,remark -- 备注
            ,ai -- 偿还利息(元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_capital_repay_plan_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,amount -- 还本金额
            ,repay_date -- 还款日期
            ,repay_type -- 还款类型0：还本1：付息
            ,remark -- 备注
            ,ai -- 偿还利息(元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.i_code, o.i_code) as i_code -- 金融工具代码
    ,nvl(n.a_type, o.a_type) as a_type -- 资产类型
    ,nvl(n.m_type, o.m_type) as m_type -- 市场类型
    ,nvl(n.amount, o.amount) as amount -- 还本金额
    ,nvl(n.repay_date, o.repay_date) as repay_date -- 还款日期
    ,nvl(n.repay_type, o.repay_type) as repay_type -- 还款类型0：还本1：付息
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.ai, o.ai) as ai -- 偿还利息(元)
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.repay_date is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.repay_date is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.i_code is null
            and n.a_type is null
            and n.m_type is null
            and n.repay_date is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ibms_ttrd_capital_repay_plan_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ibms_ttrd_capital_repay_plan where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.repay_date = n.repay_date
where (
        o.i_code is null
        and o.a_type is null
        and o.m_type is null
        and o.repay_date is null
    )
    or (
        n.i_code is null
        and n.a_type is null
        and n.m_type is null
        and n.repay_date is null
    )
    or (
        o.amount <> n.amount
        or o.repay_type <> n.repay_type
        or o.remark <> n.remark
        or o.ai <> n.ai
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ibms_ttrd_capital_repay_plan_cl(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,amount -- 还本金额
            ,repay_date -- 还款日期
            ,repay_type -- 还款类型0：还本1：付息
            ,remark -- 备注
            ,ai -- 偿还利息(元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ibms_ttrd_capital_repay_plan_op(
            i_code -- 金融工具代码
            ,a_type -- 资产类型
            ,m_type -- 市场类型
            ,amount -- 还本金额
            ,repay_date -- 还款日期
            ,repay_type -- 还款类型0：还本1：付息
            ,remark -- 备注
            ,ai -- 偿还利息(元)
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.i_code -- 金融工具代码
    ,o.a_type -- 资产类型
    ,o.m_type -- 市场类型
    ,o.amount -- 还本金额
    ,o.repay_date -- 还款日期
    ,o.repay_type -- 还款类型0：还本1：付息
    ,o.remark -- 备注
    ,o.ai -- 偿还利息(元)
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ibms_ttrd_capital_repay_plan_bk o
    left join ${iol_schema}.ibms_ttrd_capital_repay_plan_op n
        on
            o.i_code = n.i_code
            and o.a_type = n.a_type
            and o.m_type = n.m_type
            and o.repay_date = n.repay_date
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ibms_ttrd_capital_repay_plan_cl d
        on
            o.i_code = d.i_code
            and o.a_type = d.a_type
            and o.m_type = d.m_type
            and o.repay_date = d.repay_date
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ibms_ttrd_capital_repay_plan;

-- 4.2 exchange partition
alter table ${iol_schema}.ibms_ttrd_capital_repay_plan exchange partition p_19000101 with table ${iol_schema}.ibms_ttrd_capital_repay_plan_cl;
alter table ${iol_schema}.ibms_ttrd_capital_repay_plan exchange partition p_20991231 with table ${iol_schema}.ibms_ttrd_capital_repay_plan_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ibms_ttrd_capital_repay_plan to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ibms_ttrd_capital_repay_plan_op purge;
drop table ${iol_schema}.ibms_ttrd_capital_repay_plan_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ibms_ttrd_capital_repay_plan_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ibms_ttrd_capital_repay_plan',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
