/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_wph_payment_sched
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
create table ${iol_schema}.icms_wph_payment_sched_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_wph_payment_sched
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_payment_sched_op purge;
drop table ${iol_schema}.icms_wph_payment_sched_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_wph_payment_sched_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_payment_sched where 0=1;

create table ${iol_schema}.icms_wph_payment_sched_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_wph_payment_sched where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_payment_sched_cl(
            trandate -- 交易日期
            ,internalkey -- 借据号
            ,prodtype -- 产品类型
            ,stageno -- 期次
            ,ccy -- 币种
            ,schedamt -- 应还总金额
            ,priamt -- 应还本金金额
            ,intamt -- 应还利息金额
            ,odpamt -- 应还罚息金额
            ,odiamt -- 应还复利金额
            ,startdate -- 起始日期
            ,enddate -- 终止日期
            ,graceperioddate -- 宽限日期
            ,schedpaid -- 实还总金额
            ,pripaid -- 实还本金金额
            ,intpaid -- 实还利息金额
            ,odppaid -- 实还罚息金额
            ,odipaid -- 实还复利金额
            ,periodstatus -- 期次状态
            ,perdueday -- 逾期天数
            ,settledate -- 结清日期
            ,schedbal -- 当期总余额
            ,pribal -- 当期本金余额
            ,intbal -- 当期利息余额
            ,odpbal -- 当期罚息余额
            ,odibal -- 当期复利余额
            ,inputdate -- 登记日期
            ,bizdate -- 流程日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_payment_sched_op(
            trandate -- 交易日期
            ,internalkey -- 借据号
            ,prodtype -- 产品类型
            ,stageno -- 期次
            ,ccy -- 币种
            ,schedamt -- 应还总金额
            ,priamt -- 应还本金金额
            ,intamt -- 应还利息金额
            ,odpamt -- 应还罚息金额
            ,odiamt -- 应还复利金额
            ,startdate -- 起始日期
            ,enddate -- 终止日期
            ,graceperioddate -- 宽限日期
            ,schedpaid -- 实还总金额
            ,pripaid -- 实还本金金额
            ,intpaid -- 实还利息金额
            ,odppaid -- 实还罚息金额
            ,odipaid -- 实还复利金额
            ,periodstatus -- 期次状态
            ,perdueday -- 逾期天数
            ,settledate -- 结清日期
            ,schedbal -- 当期总余额
            ,pribal -- 当期本金余额
            ,intbal -- 当期利息余额
            ,odpbal -- 当期罚息余额
            ,odibal -- 当期复利余额
            ,inputdate -- 登记日期
            ,bizdate -- 流程日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trandate, o.trandate) as trandate -- 交易日期
    ,nvl(n.internalkey, o.internalkey) as internalkey -- 借据号
    ,nvl(n.prodtype, o.prodtype) as prodtype -- 产品类型
    ,nvl(n.stageno, o.stageno) as stageno -- 期次
    ,nvl(n.ccy, o.ccy) as ccy -- 币种
    ,nvl(n.schedamt, o.schedamt) as schedamt -- 应还总金额
    ,nvl(n.priamt, o.priamt) as priamt -- 应还本金金额
    ,nvl(n.intamt, o.intamt) as intamt -- 应还利息金额
    ,nvl(n.odpamt, o.odpamt) as odpamt -- 应还罚息金额
    ,nvl(n.odiamt, o.odiamt) as odiamt -- 应还复利金额
    ,nvl(n.startdate, o.startdate) as startdate -- 起始日期
    ,nvl(n.enddate, o.enddate) as enddate -- 终止日期
    ,nvl(n.graceperioddate, o.graceperioddate) as graceperioddate -- 宽限日期
    ,nvl(n.schedpaid, o.schedpaid) as schedpaid -- 实还总金额
    ,nvl(n.pripaid, o.pripaid) as pripaid -- 实还本金金额
    ,nvl(n.intpaid, o.intpaid) as intpaid -- 实还利息金额
    ,nvl(n.odppaid, o.odppaid) as odppaid -- 实还罚息金额
    ,nvl(n.odipaid, o.odipaid) as odipaid -- 实还复利金额
    ,nvl(n.periodstatus, o.periodstatus) as periodstatus -- 期次状态
    ,nvl(n.perdueday, o.perdueday) as perdueday -- 逾期天数
    ,nvl(n.settledate, o.settledate) as settledate -- 结清日期
    ,nvl(n.schedbal, o.schedbal) as schedbal -- 当期总余额
    ,nvl(n.pribal, o.pribal) as pribal -- 当期本金余额
    ,nvl(n.intbal, o.intbal) as intbal -- 当期利息余额
    ,nvl(n.odpbal, o.odpbal) as odpbal -- 当期罚息余额
    ,nvl(n.odibal, o.odibal) as odibal -- 当期复利余额
    ,nvl(n.inputdate, o.inputdate) as inputdate -- 登记日期
    ,nvl(n.bizdate, o.bizdate) as bizdate -- 流程日期
    ,case when
            n.internalkey is null
            and n.stageno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.internalkey is null
            and n.stageno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.internalkey is null
            and n.stageno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_wph_payment_sched_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_wph_payment_sched where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.internalkey = n.internalkey
            and o.stageno = n.stageno
where (
        o.internalkey is null
        and o.stageno is null
    )
    or (
        n.internalkey is null
        and n.stageno is null
    )
    or (
        o.trandate <> n.trandate
        or o.prodtype <> n.prodtype
        or o.ccy <> n.ccy
        or o.schedamt <> n.schedamt
        or o.priamt <> n.priamt
        or o.intamt <> n.intamt
        or o.odpamt <> n.odpamt
        or o.odiamt <> n.odiamt
        or o.startdate <> n.startdate
        or o.enddate <> n.enddate
        or o.graceperioddate <> n.graceperioddate
        or o.schedpaid <> n.schedpaid
        or o.pripaid <> n.pripaid
        or o.intpaid <> n.intpaid
        or o.odppaid <> n.odppaid
        or o.odipaid <> n.odipaid
        or o.periodstatus <> n.periodstatus
        or o.perdueday <> n.perdueday
        or o.settledate <> n.settledate
        or o.schedbal <> n.schedbal
        or o.pribal <> n.pribal
        or o.intbal <> n.intbal
        or o.odpbal <> n.odpbal
        or o.odibal <> n.odibal
        or o.inputdate <> n.inputdate
        or o.bizdate <> n.bizdate
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_wph_payment_sched_cl(
            trandate -- 交易日期
            ,internalkey -- 借据号
            ,prodtype -- 产品类型
            ,stageno -- 期次
            ,ccy -- 币种
            ,schedamt -- 应还总金额
            ,priamt -- 应还本金金额
            ,intamt -- 应还利息金额
            ,odpamt -- 应还罚息金额
            ,odiamt -- 应还复利金额
            ,startdate -- 起始日期
            ,enddate -- 终止日期
            ,graceperioddate -- 宽限日期
            ,schedpaid -- 实还总金额
            ,pripaid -- 实还本金金额
            ,intpaid -- 实还利息金额
            ,odppaid -- 实还罚息金额
            ,odipaid -- 实还复利金额
            ,periodstatus -- 期次状态
            ,perdueday -- 逾期天数
            ,settledate -- 结清日期
            ,schedbal -- 当期总余额
            ,pribal -- 当期本金余额
            ,intbal -- 当期利息余额
            ,odpbal -- 当期罚息余额
            ,odibal -- 当期复利余额
            ,inputdate -- 登记日期
            ,bizdate -- 流程日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_wph_payment_sched_op(
            trandate -- 交易日期
            ,internalkey -- 借据号
            ,prodtype -- 产品类型
            ,stageno -- 期次
            ,ccy -- 币种
            ,schedamt -- 应还总金额
            ,priamt -- 应还本金金额
            ,intamt -- 应还利息金额
            ,odpamt -- 应还罚息金额
            ,odiamt -- 应还复利金额
            ,startdate -- 起始日期
            ,enddate -- 终止日期
            ,graceperioddate -- 宽限日期
            ,schedpaid -- 实还总金额
            ,pripaid -- 实还本金金额
            ,intpaid -- 实还利息金额
            ,odppaid -- 实还罚息金额
            ,odipaid -- 实还复利金额
            ,periodstatus -- 期次状态
            ,perdueday -- 逾期天数
            ,settledate -- 结清日期
            ,schedbal -- 当期总余额
            ,pribal -- 当期本金余额
            ,intbal -- 当期利息余额
            ,odpbal -- 当期罚息余额
            ,odibal -- 当期复利余额
            ,inputdate -- 登记日期
            ,bizdate -- 流程日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trandate -- 交易日期
    ,o.internalkey -- 借据号
    ,o.prodtype -- 产品类型
    ,o.stageno -- 期次
    ,o.ccy -- 币种
    ,o.schedamt -- 应还总金额
    ,o.priamt -- 应还本金金额
    ,o.intamt -- 应还利息金额
    ,o.odpamt -- 应还罚息金额
    ,o.odiamt -- 应还复利金额
    ,o.startdate -- 起始日期
    ,o.enddate -- 终止日期
    ,o.graceperioddate -- 宽限日期
    ,o.schedpaid -- 实还总金额
    ,o.pripaid -- 实还本金金额
    ,o.intpaid -- 实还利息金额
    ,o.odppaid -- 实还罚息金额
    ,o.odipaid -- 实还复利金额
    ,o.periodstatus -- 期次状态
    ,o.perdueday -- 逾期天数
    ,o.settledate -- 结清日期
    ,o.schedbal -- 当期总余额
    ,o.pribal -- 当期本金余额
    ,o.intbal -- 当期利息余额
    ,o.odpbal -- 当期罚息余额
    ,o.odibal -- 当期复利余额
    ,o.inputdate -- 登记日期
    ,o.bizdate -- 流程日期
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
from ${iol_schema}.icms_wph_payment_sched_bk o
    left join ${iol_schema}.icms_wph_payment_sched_op n
        on
            o.internalkey = n.internalkey
            and o.stageno = n.stageno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_wph_payment_sched_cl d
        on
            o.internalkey = d.internalkey
            and o.stageno = d.stageno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_wph_payment_sched;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_wph_payment_sched') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_wph_payment_sched drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_wph_payment_sched add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_wph_payment_sched exchange partition p_${batch_date} with table ${iol_schema}.icms_wph_payment_sched_cl;
alter table ${iol_schema}.icms_wph_payment_sched exchange partition p_20991231 with table ${iol_schema}.icms_wph_payment_sched_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_wph_payment_sched to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_wph_payment_sched_op purge;
drop table ${iol_schema}.icms_wph_payment_sched_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_wph_payment_sched_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_wph_payment_sched',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
