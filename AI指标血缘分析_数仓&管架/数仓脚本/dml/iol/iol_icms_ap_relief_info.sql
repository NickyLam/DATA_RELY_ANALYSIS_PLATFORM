/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_ap_relief_info
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
create table ${iol_schema}.icms_ap_relief_info_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_ap_relief_info
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_relief_info_op purge;
drop table ${iol_schema}.icms_ap_relief_info_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_ap_relief_info_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_relief_info where 0=1;

create table ${iol_schema}.icms_ap_relief_info_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_ap_relief_info where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_relief_info_cl(
            reliefno -- 减免明细编号
            ,prereliefbalance -- 减免前本金余额元）
            ,updatedate -- 更新日期
            ,currency -- 币种
            ,reliefonbalinterest -- 减免表内利息金额元）
            ,inputuserid -- 登记人
            ,preoutdebitinterest -- 减免前表外欠息金额元）
            ,reliefbalance -- 减免本金金额元）
            ,payonbalinterest -- 应还表内利息金额元）
            ,reliefoutbalinterest -- 减免表外利息金额元）
            ,programno -- 方案编号
            ,paybalance -- 应还本金金额元）
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,preondebitinterest -- 减免前表内欠息金额元）
            ,payoutbalinterest -- 应还表外利息金额元）
            ,contractno -- 合同流水号
            ,intamt -- 欠息
            ,odiamt -- 复息
            ,odpamt -- 罚息
            ,reduceintamt -- 减免欠息
            ,reduceodiamt -- 减免复息
            ,reduceodpamt -- 减免罚息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_relief_info_op(
            reliefno -- 减免明细编号
            ,prereliefbalance -- 减免前本金余额元）
            ,updatedate -- 更新日期
            ,currency -- 币种
            ,reliefonbalinterest -- 减免表内利息金额元）
            ,inputuserid -- 登记人
            ,preoutdebitinterest -- 减免前表外欠息金额元）
            ,reliefbalance -- 减免本金金额元）
            ,payonbalinterest -- 应还表内利息金额元）
            ,reliefoutbalinterest -- 减免表外利息金额元）
            ,programno -- 方案编号
            ,paybalance -- 应还本金金额元）
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,preondebitinterest -- 减免前表内欠息金额元）
            ,payoutbalinterest -- 应还表外利息金额元）
            ,contractno -- 合同流水号
            ,intamt -- 欠息
            ,odiamt -- 复息
            ,odpamt -- 罚息
            ,reduceintamt -- 减免欠息
            ,reduceodiamt -- 减免复息
            ,reduceodpamt -- 减免罚息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.reliefno, o.reliefno) as reliefno -- 减免明细编号
    ,nvl(n.prereliefbalance, o.prereliefbalance) as prereliefbalance -- 减免前本金余额元）
    ,nvl(n.updatedate, o.updatedate) as updatedate -- 更新日期
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.reliefonbalinterest, o.reliefonbalinterest) as reliefonbalinterest -- 减免表内利息金额元）
    ,nvl(n.inputuserid, o.inputuserid) as inputuserid -- 登记人
    ,nvl(n.preoutdebitinterest, o.preoutdebitinterest) as preoutdebitinterest -- 减免前表外欠息金额元）
    ,nvl(n.reliefbalance, o.reliefbalance) as reliefbalance -- 减免本金金额元）
    ,nvl(n.payonbalinterest, o.payonbalinterest) as payonbalinterest -- 应还表内利息金额元）
    ,nvl(n.reliefoutbalinterest, o.reliefoutbalinterest) as reliefoutbalinterest -- 减免表外利息金额元）
    ,nvl(n.programno, o.programno) as programno -- 方案编号
    ,nvl(n.paybalance, o.paybalance) as paybalance -- 应还本金金额元）
    ,nvl(n.inputorgid, o.inputorgid) as inputorgid -- 登记机构
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.preondebitinterest, o.preondebitinterest) as preondebitinterest -- 减免前表内欠息金额元）
    ,nvl(n.payoutbalinterest, o.payoutbalinterest) as payoutbalinterest -- 应还表外利息金额元）
    ,nvl(n.contractno, o.contractno) as contractno -- 合同流水号
    ,nvl(n.intamt, o.intamt) as intamt -- 欠息
    ,nvl(n.odiamt, o.odiamt) as odiamt -- 复息
    ,nvl(n.odpamt, o.odpamt) as odpamt -- 罚息
    ,nvl(n.reduceintamt, o.reduceintamt) as reduceintamt -- 减免欠息
    ,nvl(n.reduceodiamt, o.reduceodiamt) as reduceodiamt -- 减免复息
    ,nvl(n.reduceodpamt, o.reduceodpamt) as reduceodpamt -- 减免罚息
    ,case when
            n.reliefno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.reliefno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.reliefno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_ap_relief_info_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_ap_relief_info where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.reliefno = n.reliefno
where (
        o.reliefno is null
    )
    or (
        n.reliefno is null
    )
    or (
        o.prereliefbalance <> n.prereliefbalance
        or o.updatedate <> n.updatedate
        or o.currency <> n.currency
        or o.reliefonbalinterest <> n.reliefonbalinterest
        or o.inputuserid <> n.inputuserid
        or o.preoutdebitinterest <> n.preoutdebitinterest
        or o.reliefbalance <> n.reliefbalance
        or o.payonbalinterest <> n.payonbalinterest
        or o.reliefoutbalinterest <> n.reliefoutbalinterest
        or o.programno <> n.programno
        or o.paybalance <> n.paybalance
        or o.inputorgid <> n.inputorgid
        or o.inputdate <> n.inputdate
        or o.preondebitinterest <> n.preondebitinterest
        or o.payoutbalinterest <> n.payoutbalinterest
        or o.contractno <> n.contractno
        or o.intamt <> n.intamt
        or o.odiamt <> n.odiamt
        or o.odpamt <> n.odpamt
        or o.reduceintamt <> n.reduceintamt
        or o.reduceodiamt <> n.reduceodiamt
        or o.reduceodpamt <> n.reduceodpamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_ap_relief_info_cl(
            reliefno -- 减免明细编号
            ,prereliefbalance -- 减免前本金余额元）
            ,updatedate -- 更新日期
            ,currency -- 币种
            ,reliefonbalinterest -- 减免表内利息金额元）
            ,inputuserid -- 登记人
            ,preoutdebitinterest -- 减免前表外欠息金额元）
            ,reliefbalance -- 减免本金金额元）
            ,payonbalinterest -- 应还表内利息金额元）
            ,reliefoutbalinterest -- 减免表外利息金额元）
            ,programno -- 方案编号
            ,paybalance -- 应还本金金额元）
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,preondebitinterest -- 减免前表内欠息金额元）
            ,payoutbalinterest -- 应还表外利息金额元）
            ,contractno -- 合同流水号
            ,intamt -- 欠息
            ,odiamt -- 复息
            ,odpamt -- 罚息
            ,reduceintamt -- 减免欠息
            ,reduceodiamt -- 减免复息
            ,reduceodpamt -- 减免罚息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_ap_relief_info_op(
            reliefno -- 减免明细编号
            ,prereliefbalance -- 减免前本金余额元）
            ,updatedate -- 更新日期
            ,currency -- 币种
            ,reliefonbalinterest -- 减免表内利息金额元）
            ,inputuserid -- 登记人
            ,preoutdebitinterest -- 减免前表外欠息金额元）
            ,reliefbalance -- 减免本金金额元）
            ,payonbalinterest -- 应还表内利息金额元）
            ,reliefoutbalinterest -- 减免表外利息金额元）
            ,programno -- 方案编号
            ,paybalance -- 应还本金金额元）
            ,inputorgid -- 登记机构
            ,inputdate -- 登记日期
            ,preondebitinterest -- 减免前表内欠息金额元）
            ,payoutbalinterest -- 应还表外利息金额元）
            ,contractno -- 合同流水号
            ,intamt -- 欠息
            ,odiamt -- 复息
            ,odpamt -- 罚息
            ,reduceintamt -- 减免欠息
            ,reduceodiamt -- 减免复息
            ,reduceodpamt -- 减免罚息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.reliefno -- 减免明细编号
    ,o.prereliefbalance -- 减免前本金余额元）
    ,o.updatedate -- 更新日期
    ,o.currency -- 币种
    ,o.reliefonbalinterest -- 减免表内利息金额元）
    ,o.inputuserid -- 登记人
    ,o.preoutdebitinterest -- 减免前表外欠息金额元）
    ,o.reliefbalance -- 减免本金金额元）
    ,o.payonbalinterest -- 应还表内利息金额元）
    ,o.reliefoutbalinterest -- 减免表外利息金额元）
    ,o.programno -- 方案编号
    ,o.paybalance -- 应还本金金额元）
    ,o.inputorgid -- 登记机构
    ,o.inputdate -- 登记日期
    ,o.preondebitinterest -- 减免前表内欠息金额元）
    ,o.payoutbalinterest -- 应还表外利息金额元）
    ,o.contractno -- 合同流水号
    ,o.intamt -- 欠息
    ,o.odiamt -- 复息
    ,o.odpamt -- 罚息
    ,o.reduceintamt -- 减免欠息
    ,o.reduceodiamt -- 减免复息
    ,o.reduceodpamt -- 减免罚息
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
from ${iol_schema}.icms_ap_relief_info_bk o
    left join ${iol_schema}.icms_ap_relief_info_op n
        on
            o.reliefno = n.reliefno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_ap_relief_info_cl d
        on
            o.reliefno = d.reliefno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_ap_relief_info;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_ap_relief_info') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_ap_relief_info drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_ap_relief_info add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_ap_relief_info exchange partition p_${batch_date} with table ${iol_schema}.icms_ap_relief_info_cl;
alter table ${iol_schema}.icms_ap_relief_info exchange partition p_20991231 with table ${iol_schema}.icms_ap_relief_info_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_ap_relief_info to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_ap_relief_info_op purge;
drop table ${iol_schema}.icms_ap_relief_info_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_ap_relief_info_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_ap_relief_info',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
