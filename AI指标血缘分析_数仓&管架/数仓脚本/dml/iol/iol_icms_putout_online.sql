/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_putout_online
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
create table ${iol_schema}.icms_putout_online_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_putout_online
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_putout_online_op purge;
drop table ${iol_schema}.icms_putout_online_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_putout_online_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_putout_online where 0=1;

create table ${iol_schema}.icms_putout_online_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_putout_online where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_putout_online_cl(
            putoutno -- 出账流水号
            ,contractserialno -- 合同号
            ,hostnbr -- 信保转账交易流水
            ,dd_status -- 放款状态
            ,hostdate -- 信保转账交易日期
            ,firstpayamt -- 首付款金额
            ,migtflag -- 
            ,channel -- 渠道号
            ,isfirstpay -- 是否首付款1是2否
            ,firstpayratio -- 首付款比例%
            ,duebillserialno -- 借据号
            ,billamt -- 服务费
            ,oarateexaresult -- OA利率审批结果 0 不通过 1 通过1
            ,orderno -- 订单号
            ,ordersumamt -- 订单金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_putout_online_op(
            putoutno -- 出账流水号
            ,contractserialno -- 合同号
            ,hostnbr -- 信保转账交易流水
            ,dd_status -- 放款状态
            ,hostdate -- 信保转账交易日期
            ,firstpayamt -- 首付款金额
            ,migtflag -- 
            ,channel -- 渠道号
            ,isfirstpay -- 是否首付款1是2否
            ,firstpayratio -- 首付款比例%
            ,duebillserialno -- 借据号
            ,billamt -- 服务费
            ,oarateexaresult -- OA利率审批结果 0 不通过 1 通过1
            ,orderno -- 订单号
            ,ordersumamt -- 订单金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.putoutno, o.putoutno) as putoutno -- 出账流水号
    ,nvl(n.contractserialno, o.contractserialno) as contractserialno -- 合同号
    ,nvl(n.hostnbr, o.hostnbr) as hostnbr -- 信保转账交易流水
    ,nvl(n.dd_status, o.dd_status) as dd_status -- 放款状态
    ,nvl(n.hostdate, o.hostdate) as hostdate -- 信保转账交易日期
    ,nvl(n.firstpayamt, o.firstpayamt) as firstpayamt -- 首付款金额
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 
    ,nvl(n.channel, o.channel) as channel -- 渠道号
    ,nvl(n.isfirstpay, o.isfirstpay) as isfirstpay -- 是否首付款1是2否
    ,nvl(n.firstpayratio, o.firstpayratio) as firstpayratio -- 首付款比例%
    ,nvl(n.duebillserialno, o.duebillserialno) as duebillserialno -- 借据号
    ,nvl(n.billamt, o.billamt) as billamt -- 服务费
    ,nvl(n.oarateexaresult, o.oarateexaresult) as oarateexaresult -- OA利率审批结果 0 不通过 1 通过1
    ,nvl(n.orderno, o.orderno) as orderno -- 订单号
    ,nvl(n.ordersumamt, o.ordersumamt) as ordersumamt -- 订单金额
    ,case when
            n.putoutno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.putoutno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.putoutno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_putout_online_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_putout_online where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.putoutno = n.putoutno
where (
        o.putoutno is null
    )
    or (
        n.putoutno is null
    )
    or (
        o.contractserialno <> n.contractserialno
        or o.hostnbr <> n.hostnbr
        or o.dd_status <> n.dd_status
        or o.hostdate <> n.hostdate
        or o.firstpayamt <> n.firstpayamt
        or o.migtflag <> n.migtflag
        or o.channel <> n.channel
        or o.isfirstpay <> n.isfirstpay
        or o.firstpayratio <> n.firstpayratio
        or o.duebillserialno <> n.duebillserialno
        or o.billamt <> n.billamt
        or o.oarateexaresult <> n.oarateexaresult
        or o.orderno <> n.orderno
        or o.ordersumamt <> n.ordersumamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_putout_online_cl(
            putoutno -- 出账流水号
            ,contractserialno -- 合同号
            ,hostnbr -- 信保转账交易流水
            ,dd_status -- 放款状态
            ,hostdate -- 信保转账交易日期
            ,firstpayamt -- 首付款金额
            ,migtflag -- 
            ,channel -- 渠道号
            ,isfirstpay -- 是否首付款1是2否
            ,firstpayratio -- 首付款比例%
            ,duebillserialno -- 借据号
            ,billamt -- 服务费
            ,oarateexaresult -- OA利率审批结果 0 不通过 1 通过1
            ,orderno -- 订单号
            ,ordersumamt -- 订单金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_putout_online_op(
            putoutno -- 出账流水号
            ,contractserialno -- 合同号
            ,hostnbr -- 信保转账交易流水
            ,dd_status -- 放款状态
            ,hostdate -- 信保转账交易日期
            ,firstpayamt -- 首付款金额
            ,migtflag -- 
            ,channel -- 渠道号
            ,isfirstpay -- 是否首付款1是2否
            ,firstpayratio -- 首付款比例%
            ,duebillserialno -- 借据号
            ,billamt -- 服务费
            ,oarateexaresult -- OA利率审批结果 0 不通过 1 通过1
            ,orderno -- 订单号
            ,ordersumamt -- 订单金额
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.putoutno -- 出账流水号
    ,o.contractserialno -- 合同号
    ,o.hostnbr -- 信保转账交易流水
    ,o.dd_status -- 放款状态
    ,o.hostdate -- 信保转账交易日期
    ,o.firstpayamt -- 首付款金额
    ,o.migtflag -- 
    ,o.channel -- 渠道号
    ,o.isfirstpay -- 是否首付款1是2否
    ,o.firstpayratio -- 首付款比例%
    ,o.duebillserialno -- 借据号
    ,o.billamt -- 服务费
    ,o.oarateexaresult -- OA利率审批结果 0 不通过 1 通过1
    ,o.orderno -- 订单号
    ,o.ordersumamt -- 订单金额
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
from ${iol_schema}.icms_putout_online_bk o
    left join ${iol_schema}.icms_putout_online_op n
        on
            o.putoutno = n.putoutno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_putout_online_cl d
        on
            o.putoutno = d.putoutno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_putout_online;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_putout_online') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_putout_online drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_putout_online add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_putout_online exchange partition p_${batch_date} with table ${iol_schema}.icms_putout_online_cl;
alter table ${iol_schema}.icms_putout_online exchange partition p_20991231 with table ${iol_schema}.icms_putout_online_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_putout_online to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_putout_online_op purge;
drop table ${iol_schema}.icms_putout_online_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_putout_online_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_putout_online',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
