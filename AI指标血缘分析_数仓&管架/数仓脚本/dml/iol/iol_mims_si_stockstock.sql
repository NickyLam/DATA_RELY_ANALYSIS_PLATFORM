/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mims_si_stockstock
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
create table ${iol_schema}.mims_si_stockstock_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mims_si_stockstock
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_stockstock_op purge;
drop table ${iol_schema}.mims_si_stockstock_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mims_si_stockstock_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_stockstock where 0=1;

create table ${iol_schema}.mims_si_stockstock_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mims_si_stockstock where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_stockstock_cl(
            sccode -- 押品编号
            ,financingamount -- 平仓融资金额
            ,repaymenttime -- 还款时间
            ,closingamount -- 平仓押品金额
            ,closingtime -- 平仓时间
            ,closingstock -- 是否在报告期内平仓股票        0 否、1 是
            ,closingprice -- 每股平仓平均价格
            ,credno -- 借据号
            ,reportperiod -- 报告期季度
            ,reportperiodyear -- 报告期起始年份
            ,reportperiodclosing -- 报告期内是否发生平仓        0 否、1 是
            ,guartype -- 押品类型编号
            ,isdeal -- 是否场内交易
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_stockstock_op(
            sccode -- 押品编号
            ,financingamount -- 平仓融资金额
            ,repaymenttime -- 还款时间
            ,closingamount -- 平仓押品金额
            ,closingtime -- 平仓时间
            ,closingstock -- 是否在报告期内平仓股票        0 否、1 是
            ,closingprice -- 每股平仓平均价格
            ,credno -- 借据号
            ,reportperiod -- 报告期季度
            ,reportperiodyear -- 报告期起始年份
            ,reportperiodclosing -- 报告期内是否发生平仓        0 否、1 是
            ,guartype -- 押品类型编号
            ,isdeal -- 是否场内交易
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.sccode, o.sccode) as sccode -- 押品编号
    ,nvl(n.financingamount, o.financingamount) as financingamount -- 平仓融资金额
    ,nvl(n.repaymenttime, o.repaymenttime) as repaymenttime -- 还款时间
    ,nvl(n.closingamount, o.closingamount) as closingamount -- 平仓押品金额
    ,nvl(n.closingtime, o.closingtime) as closingtime -- 平仓时间
    ,nvl(n.closingstock, o.closingstock) as closingstock -- 是否在报告期内平仓股票        0 否、1 是
    ,nvl(n.closingprice, o.closingprice) as closingprice -- 每股平仓平均价格
    ,nvl(n.credno, o.credno) as credno -- 借据号
    ,nvl(n.reportperiod, o.reportperiod) as reportperiod -- 报告期季度
    ,nvl(n.reportperiodyear, o.reportperiodyear) as reportperiodyear -- 报告期起始年份
    ,nvl(n.reportperiodclosing, o.reportperiodclosing) as reportperiodclosing -- 报告期内是否发生平仓        0 否、1 是
    ,nvl(n.guartype, o.guartype) as guartype -- 押品类型编号
    ,nvl(n.isdeal, o.isdeal) as isdeal -- 是否场内交易
    ,case when
            n.sccode is null
            and n.credno is null
            and n.reportperiod is null
            and n.reportperiodyear is null
            and n.guartype is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.sccode is null
            and n.credno is null
            and n.reportperiod is null
            and n.reportperiodyear is null
            and n.guartype is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.sccode is null
            and n.credno is null
            and n.reportperiod is null
            and n.reportperiodyear is null
            and n.guartype is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mims_si_stockstock_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mims_si_stockstock where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.sccode = n.sccode
            and o.credno = n.credno
            and o.reportperiod = n.reportperiod
            and o.reportperiodyear = n.reportperiodyear
            and o.guartype = n.guartype
where (
        o.sccode is null
        and o.credno is null
        and o.reportperiod is null
        and o.reportperiodyear is null
        and o.guartype is null
    )
    or (
        n.sccode is null
        and n.credno is null
        and n.reportperiod is null
        and n.reportperiodyear is null
        and n.guartype is null
    )
    or (
        o.financingamount <> n.financingamount
        or o.repaymenttime <> n.repaymenttime
        or o.closingamount <> n.closingamount
        or o.closingtime <> n.closingtime
        or o.closingstock <> n.closingstock
        or o.closingprice <> n.closingprice
        or o.reportperiodclosing <> n.reportperiodclosing
        or o.isdeal <> n.isdeal
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mims_si_stockstock_cl(
            sccode -- 押品编号
            ,financingamount -- 平仓融资金额
            ,repaymenttime -- 还款时间
            ,closingamount -- 平仓押品金额
            ,closingtime -- 平仓时间
            ,closingstock -- 是否在报告期内平仓股票        0 否、1 是
            ,closingprice -- 每股平仓平均价格
            ,credno -- 借据号
            ,reportperiod -- 报告期季度
            ,reportperiodyear -- 报告期起始年份
            ,reportperiodclosing -- 报告期内是否发生平仓        0 否、1 是
            ,guartype -- 押品类型编号
            ,isdeal -- 是否场内交易
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mims_si_stockstock_op(
            sccode -- 押品编号
            ,financingamount -- 平仓融资金额
            ,repaymenttime -- 还款时间
            ,closingamount -- 平仓押品金额
            ,closingtime -- 平仓时间
            ,closingstock -- 是否在报告期内平仓股票        0 否、1 是
            ,closingprice -- 每股平仓平均价格
            ,credno -- 借据号
            ,reportperiod -- 报告期季度
            ,reportperiodyear -- 报告期起始年份
            ,reportperiodclosing -- 报告期内是否发生平仓        0 否、1 是
            ,guartype -- 押品类型编号
            ,isdeal -- 是否场内交易
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.sccode -- 押品编号
    ,o.financingamount -- 平仓融资金额
    ,o.repaymenttime -- 还款时间
    ,o.closingamount -- 平仓押品金额
    ,o.closingtime -- 平仓时间
    ,o.closingstock -- 是否在报告期内平仓股票        0 否、1 是
    ,o.closingprice -- 每股平仓平均价格
    ,o.credno -- 借据号
    ,o.reportperiod -- 报告期季度
    ,o.reportperiodyear -- 报告期起始年份
    ,o.reportperiodclosing -- 报告期内是否发生平仓        0 否、1 是
    ,o.guartype -- 押品类型编号
    ,o.isdeal -- 是否场内交易
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
from ${iol_schema}.mims_si_stockstock_bk o
    left join ${iol_schema}.mims_si_stockstock_op n
        on
            o.sccode = n.sccode
            and o.credno = n.credno
            and o.reportperiod = n.reportperiod
            and o.reportperiodyear = n.reportperiodyear
            and o.guartype = n.guartype
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mims_si_stockstock_cl d
        on
            o.sccode = d.sccode
            and o.credno = d.credno
            and o.reportperiod = d.reportperiod
            and o.reportperiodyear = d.reportperiodyear
            and o.guartype = d.guartype
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mims_si_stockstock;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mims_si_stockstock') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mims_si_stockstock drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mims_si_stockstock add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mims_si_stockstock exchange partition p_${batch_date} with table ${iol_schema}.mims_si_stockstock_cl;
alter table ${iol_schema}.mims_si_stockstock exchange partition p_20991231 with table ${iol_schema}.mims_si_stockstock_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mims_si_stockstock to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mims_si_stockstock_op purge;
drop table ${iol_schema}.mims_si_stockstock_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mims_si_stockstock_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mims_si_stockstock',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
