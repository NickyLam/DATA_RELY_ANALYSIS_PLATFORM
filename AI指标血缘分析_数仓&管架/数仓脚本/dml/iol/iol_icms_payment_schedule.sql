/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_payment_schedule
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
create table ${iol_schema}.icms_payment_schedule_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_payment_schedule
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_payment_schedule_op purge;
drop table ${iol_schema}.icms_payment_schedule_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_payment_schedule_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_payment_schedule where 0=1;

create table ${iol_schema}.icms_payment_schedule_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_payment_schedule where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_payment_schedule_cl(
            serialno -- 流水号
            ,accountmanageobjectno -- 关联提前还款申请流水号
            ,subrepaytype -- 子还款方式
            ,putoutno -- 出账号
            ,repaymentdate -- 还款计划日期
            ,repaycorpus -- 计划还款本金
            ,begindate -- 业务开始日期
            ,adjusttype -- 调整类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,duebillno -- 借据号
            ,finishinterest -- 是否结息
            ,realinterest -- 实际利率
            ,discountcharges -- 贴息
            ,seqid -- 期次
            ,currency -- 币种
            ,corpusamount -- 本金余额
            ,repayinterest -- 计划还款利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_payment_schedule_op(
            serialno -- 流水号
            ,accountmanageobjectno -- 关联提前还款申请流水号
            ,subrepaytype -- 子还款方式
            ,putoutno -- 出账号
            ,repaymentdate -- 还款计划日期
            ,repaycorpus -- 计划还款本金
            ,begindate -- 业务开始日期
            ,adjusttype -- 调整类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,duebillno -- 借据号
            ,finishinterest -- 是否结息
            ,realinterest -- 实际利率
            ,discountcharges -- 贴息
            ,seqid -- 期次
            ,currency -- 币种
            ,corpusamount -- 本金余额
            ,repayinterest -- 计划还款利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.accountmanageobjectno, o.accountmanageobjectno) as accountmanageobjectno -- 关联提前还款申请流水号
    ,nvl(n.subrepaytype, o.subrepaytype) as subrepaytype -- 子还款方式
    ,nvl(n.putoutno, o.putoutno) as putoutno -- 出账号
    ,nvl(n.repaymentdate, o.repaymentdate) as repaymentdate -- 还款计划日期
    ,nvl(n.repaycorpus, o.repaycorpus) as repaycorpus -- 计划还款本金
    ,nvl(n.begindate, o.begindate) as begindate -- 业务开始日期
    ,nvl(n.adjusttype, o.adjusttype) as adjusttype -- 调整类型
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.duebillno, o.duebillno) as duebillno -- 借据号
    ,nvl(n.finishinterest, o.finishinterest) as finishinterest -- 是否结息
    ,nvl(n.realinterest, o.realinterest) as realinterest -- 实际利率
    ,nvl(n.discountcharges, o.discountcharges) as discountcharges -- 贴息
    ,nvl(n.seqid, o.seqid) as seqid -- 期次
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.corpusamount, o.corpusamount) as corpusamount -- 本金余额
    ,nvl(n.repayinterest, o.repayinterest) as repayinterest -- 计划还款利息
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
from (select * from ${iol_schema}.icms_payment_schedule_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_payment_schedule where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.serialno = n.serialno
where (
        o.serialno is null
    )
    or (
        n.serialno is null
    )
    or (
        o.accountmanageobjectno <> n.accountmanageobjectno
        or o.subrepaytype <> n.subrepaytype
        or o.putoutno <> n.putoutno
        or o.repaymentdate <> n.repaymentdate
        or o.repaycorpus <> n.repaycorpus
        or o.begindate <> n.begindate
        or o.adjusttype <> n.adjusttype
        or o.migtflag <> n.migtflag
        or o.duebillno <> n.duebillno
        or o.finishinterest <> n.finishinterest
        or o.realinterest <> n.realinterest
        or o.discountcharges <> n.discountcharges
        or o.seqid <> n.seqid
        or o.currency <> n.currency
        or o.corpusamount <> n.corpusamount
        or o.repayinterest <> n.repayinterest
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_payment_schedule_cl(
            serialno -- 流水号
            ,accountmanageobjectno -- 关联提前还款申请流水号
            ,subrepaytype -- 子还款方式
            ,putoutno -- 出账号
            ,repaymentdate -- 还款计划日期
            ,repaycorpus -- 计划还款本金
            ,begindate -- 业务开始日期
            ,adjusttype -- 调整类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,duebillno -- 借据号
            ,finishinterest -- 是否结息
            ,realinterest -- 实际利率
            ,discountcharges -- 贴息
            ,seqid -- 期次
            ,currency -- 币种
            ,corpusamount -- 本金余额
            ,repayinterest -- 计划还款利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_payment_schedule_op(
            serialno -- 流水号
            ,accountmanageobjectno -- 关联提前还款申请流水号
            ,subrepaytype -- 子还款方式
            ,putoutno -- 出账号
            ,repaymentdate -- 还款计划日期
            ,repaycorpus -- 计划还款本金
            ,begindate -- 业务开始日期
            ,adjusttype -- 调整类型
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,duebillno -- 借据号
            ,finishinterest -- 是否结息
            ,realinterest -- 实际利率
            ,discountcharges -- 贴息
            ,seqid -- 期次
            ,currency -- 币种
            ,corpusamount -- 本金余额
            ,repayinterest -- 计划还款利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.serialno -- 流水号
    ,o.accountmanageobjectno -- 关联提前还款申请流水号
    ,o.subrepaytype -- 子还款方式
    ,o.putoutno -- 出账号
    ,o.repaymentdate -- 还款计划日期
    ,o.repaycorpus -- 计划还款本金
    ,o.begindate -- 业务开始日期
    ,o.adjusttype -- 调整类型
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.duebillno -- 借据号
    ,o.finishinterest -- 是否结息
    ,o.realinterest -- 实际利率
    ,o.discountcharges -- 贴息
    ,o.seqid -- 期次
    ,o.currency -- 币种
    ,o.corpusamount -- 本金余额
    ,o.repayinterest -- 计划还款利息
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
from ${iol_schema}.icms_payment_schedule_bk o
    left join ${iol_schema}.icms_payment_schedule_op n
        on
            o.serialno = n.serialno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_payment_schedule_cl d
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
--truncate table ${iol_schema}.icms_payment_schedule;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_payment_schedule') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_payment_schedule drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_payment_schedule add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_payment_schedule exchange partition p_${batch_date} with table ${iol_schema}.icms_payment_schedule_cl;
alter table ${iol_schema}.icms_payment_schedule exchange partition p_20991231 with table ${iol_schema}.icms_payment_schedule_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_payment_schedule to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_payment_schedule_op purge;
drop table ${iol_schema}.icms_payment_schedule_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_payment_schedule_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_payment_schedule',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
