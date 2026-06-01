/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_zjbk_bat_repayment
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
create table ${iol_schema}.icms_zjbk_bat_repayment_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_zjbk_bat_repayment
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_bat_repayment_op purge;
drop table ${iol_schema}.icms_zjbk_bat_repayment_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_zjbk_bat_repayment_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_bat_repayment where 0=1;

create table ${iol_schema}.icms_zjbk_bat_repayment_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_zjbk_bat_repayment where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_bat_repayment_cl(
            serialno -- 流水号
            ,curdate -- 账务日期
            ,loanid -- 借据号
            ,trantime -- 交易时间
            ,seqno -- 交易流水号
            ,totalamt -- 交易金额
            ,incomeamt -- 实收金额
            ,prinamt -- 本金发生额
            ,intamt -- 利息发生额
            ,pnltintamt -- 罚息发生额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,productno -- 产品编号
            ,outloanchannelno -- 平台订单号
            ,interesttransferstatus -- 非应计状态
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户开户机构名称
            ,repayaccountno -- 还款账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_bat_repayment_op(
            serialno -- 流水号
            ,curdate -- 账务日期
            ,loanid -- 借据号
            ,trantime -- 交易时间
            ,seqno -- 交易流水号
            ,totalamt -- 交易金额
            ,incomeamt -- 实收金额
            ,prinamt -- 本金发生额
            ,intamt -- 利息发生额
            ,pnltintamt -- 罚息发生额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,productno -- 产品编号
            ,outloanchannelno -- 平台订单号
            ,interesttransferstatus -- 非应计状态
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户开户机构名称
            ,repayaccountno -- 还款账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.curdate, o.curdate) as curdate -- 账务日期
    ,nvl(n.loanid, o.loanid) as loanid -- 借据号
    ,nvl(n.trantime, o.trantime) as trantime -- 交易时间
    ,nvl(n.seqno, o.seqno) as seqno -- 交易流水号
    ,nvl(n.totalamt, o.totalamt) as totalamt -- 交易金额
    ,nvl(n.incomeamt, o.incomeamt) as incomeamt -- 实收金额
    ,nvl(n.prinamt, o.prinamt) as prinamt -- 本金发生额
    ,nvl(n.intamt, o.intamt) as intamt -- 利息发生额
    ,nvl(n.pnltintamt, o.pnltintamt) as pnltintamt -- 罚息发生额
    ,nvl(n.prepmtfeerepay, o.prepmtfeerepay) as prepmtfeerepay -- 已还提前还款手续费
    ,nvl(n.productno, o.productno) as productno -- 产品编号
    ,nvl(n.outloanchannelno, o.outloanchannelno) as outloanchannelno -- 平台订单号
    ,nvl(n.interesttransferstatus, o.interesttransferstatus) as interesttransferstatus -- 非应计状态
    ,nvl(n.repayaccounttype, o.repayaccounttype) as repayaccounttype -- 还款账户类型
    ,nvl(n.repayaccountname, o.repayaccountname) as repayaccountname -- 还款账户开户机构名称
    ,nvl(n.repayaccountno, o.repayaccountno) as repayaccountno -- 还款账户编号
    ,case when
            n.serialno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.serialno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.serialno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_zjbk_bat_repayment_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_zjbk_bat_repayment where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.curdate <> n.curdate
        or o.loanid <> n.loanid
        or o.trantime <> n.trantime
        or o.seqno <> n.seqno
        or o.totalamt <> n.totalamt
        or o.incomeamt <> n.incomeamt
        or o.prinamt <> n.prinamt
        or o.intamt <> n.intamt
        or o.pnltintamt <> n.pnltintamt
        or o.prepmtfeerepay <> n.prepmtfeerepay
        or o.productno <> n.productno
        or o.outloanchannelno <> n.outloanchannelno
        or o.interesttransferstatus <> n.interesttransferstatus
        or o.repayaccounttype <> n.repayaccounttype
        or o.repayaccountname <> n.repayaccountname
        or o.repayaccountno <> n.repayaccountno
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_zjbk_bat_repayment_cl(
            serialno -- 流水号
            ,curdate -- 账务日期
            ,loanid -- 借据号
            ,trantime -- 交易时间
            ,seqno -- 交易流水号
            ,totalamt -- 交易金额
            ,incomeamt -- 实收金额
            ,prinamt -- 本金发生额
            ,intamt -- 利息发生额
            ,pnltintamt -- 罚息发生额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,productno -- 产品编号
            ,outloanchannelno -- 平台订单号
            ,interesttransferstatus -- 非应计状态
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户开户机构名称
            ,repayaccountno -- 还款账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_zjbk_bat_repayment_op(
            serialno -- 流水号
            ,curdate -- 账务日期
            ,loanid -- 借据号
            ,trantime -- 交易时间
            ,seqno -- 交易流水号
            ,totalamt -- 交易金额
            ,incomeamt -- 实收金额
            ,prinamt -- 本金发生额
            ,intamt -- 利息发生额
            ,pnltintamt -- 罚息发生额
            ,prepmtfeerepay -- 已还提前还款手续费
            ,productno -- 产品编号
            ,outloanchannelno -- 平台订单号
            ,interesttransferstatus -- 非应计状态
            ,repayaccounttype -- 还款账户类型
            ,repayaccountname -- 还款账户开户机构名称
            ,repayaccountno -- 还款账户编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.curdate -- 账务日期
    ,o.loanid -- 借据号
    ,o.trantime -- 交易时间
    ,o.seqno -- 交易流水号
    ,o.totalamt -- 交易金额
    ,o.incomeamt -- 实收金额
    ,o.prinamt -- 本金发生额
    ,o.intamt -- 利息发生额
    ,o.pnltintamt -- 罚息发生额
    ,o.prepmtfeerepay -- 已还提前还款手续费
    ,o.productno -- 产品编号
    ,o.outloanchannelno -- 平台订单号
    ,o.interesttransferstatus -- 非应计状态
    ,o.repayaccounttype -- 还款账户类型
    ,o.repayaccountname -- 还款账户开户机构名称
    ,o.repayaccountno -- 还款账户编号
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
from ${iol_schema}.icms_zjbk_bat_repayment_bk o
    left join ${iol_schema}.icms_zjbk_bat_repayment_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_zjbk_bat_repayment_cl d
        on
            o.serialno = d.serialno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_zjbk_bat_repayment;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_zjbk_bat_repayment') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_zjbk_bat_repayment drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_zjbk_bat_repayment add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_zjbk_bat_repayment exchange partition p_${batch_date} with table ${iol_schema}.icms_zjbk_bat_repayment_cl;
alter table ${iol_schema}.icms_zjbk_bat_repayment exchange partition p_20991231 with table ${iol_schema}.icms_zjbk_bat_repayment_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_zjbk_bat_repayment to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_zjbk_bat_repayment_op purge;
drop table ${iol_schema}.icms_zjbk_bat_repayment_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_zjbk_bat_repayment_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_zjbk_bat_repayment',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
