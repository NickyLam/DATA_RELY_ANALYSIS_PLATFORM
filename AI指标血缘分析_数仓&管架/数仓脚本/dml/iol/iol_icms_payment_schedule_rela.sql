/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_icms_payment_schedule_rela
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
create table ${iol_schema}.icms_payment_schedule_rela_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.icms_payment_schedule_rela
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_payment_schedule_rela_op purge;
drop table ${iol_schema}.icms_payment_schedule_rela_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.icms_payment_schedule_rela_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_payment_schedule_rela where 0=1;

create table ${iol_schema}.icms_payment_schedule_rela_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.icms_payment_schedule_rela where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_payment_schedule_rela_cl(
            keyid -- 主键
            ,repaymentdate -- 还款计划日期
            ,serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,adjusttype -- 调整类型
            ,seqid -- 期次
            ,repayinterest -- 计划还款利息
            ,discountcharges -- 贴息
            ,relativeserialno -- 关联变更申请流水号
            ,transt -- 核心是否已执行0未执行1已执行
            ,putoutno -- 出账号
            ,repaycorpus -- 计划还款本金
            ,currency -- 币种
            ,finishinterest -- 还本日期是否结息(0-不结息1-结息)
            ,corpusamount -- 本金余额
            ,accountmanageobjectno -- 关联提前还款申请流水号
            ,duebillno -- 借据号
            ,realinterest -- 实际利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_payment_schedule_rela_op(
            keyid -- 主键
            ,repaymentdate -- 还款计划日期
            ,serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,adjusttype -- 调整类型
            ,seqid -- 期次
            ,repayinterest -- 计划还款利息
            ,discountcharges -- 贴息
            ,relativeserialno -- 关联变更申请流水号
            ,transt -- 核心是否已执行0未执行1已执行
            ,putoutno -- 出账号
            ,repaycorpus -- 计划还款本金
            ,currency -- 币种
            ,finishinterest -- 还本日期是否结息(0-不结息1-结息)
            ,corpusamount -- 本金余额
            ,accountmanageobjectno -- 关联提前还款申请流水号
            ,duebillno -- 借据号
            ,realinterest -- 实际利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.keyid, o.keyid) as keyid -- 主键
    ,nvl(n.repaymentdate, o.repaymentdate) as repaymentdate -- 还款计划日期
    ,nvl(n.serialno, o.serialno) as serialno -- 流水号
    ,nvl(n.migtflag, o.migtflag) as migtflag -- 迁移标志：crsrcrilcupl
    ,nvl(n.adjusttype, o.adjusttype) as adjusttype -- 调整类型
    ,nvl(n.seqid, o.seqid) as seqid -- 期次
    ,nvl(n.repayinterest, o.repayinterest) as repayinterest -- 计划还款利息
    ,nvl(n.discountcharges, o.discountcharges) as discountcharges -- 贴息
    ,nvl(n.relativeserialno, o.relativeserialno) as relativeserialno -- 关联变更申请流水号
    ,nvl(n.transt, o.transt) as transt -- 核心是否已执行0未执行1已执行
    ,nvl(n.putoutno, o.putoutno) as putoutno -- 出账号
    ,nvl(n.repaycorpus, o.repaycorpus) as repaycorpus -- 计划还款本金
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.finishinterest, o.finishinterest) as finishinterest -- 还本日期是否结息(0-不结息1-结息)
    ,nvl(n.corpusamount, o.corpusamount) as corpusamount -- 本金余额
    ,nvl(n.accountmanageobjectno, o.accountmanageobjectno) as accountmanageobjectno -- 关联提前还款申请流水号
    ,nvl(n.duebillno, o.duebillno) as duebillno -- 借据号
    ,nvl(n.realinterest, o.realinterest) as realinterest -- 实际利率
    ,case when
            n.keyid is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.keyid is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.keyid is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.icms_payment_schedule_rela_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.icms_payment_schedule_rela where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.keyid = n.keyid
where (
        o.keyid is null
    )
    or (
        n.keyid is null
    )
    or (
        o.repaymentdate <> n.repaymentdate
        or o.serialno <> n.serialno
        or o.migtflag <> n.migtflag
        or o.adjusttype <> n.adjusttype
        or o.seqid <> n.seqid
        or o.repayinterest <> n.repayinterest
        or o.discountcharges <> n.discountcharges
        or o.relativeserialno <> n.relativeserialno
        or o.transt <> n.transt
        or o.putoutno <> n.putoutno
        or o.repaycorpus <> n.repaycorpus
        or o.currency <> n.currency
        or o.finishinterest <> n.finishinterest
        or o.corpusamount <> n.corpusamount
        or o.accountmanageobjectno <> n.accountmanageobjectno
        or o.duebillno <> n.duebillno
        or o.realinterest <> n.realinterest
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.icms_payment_schedule_rela_cl(
            keyid -- 主键
            ,repaymentdate -- 还款计划日期
            ,serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,adjusttype -- 调整类型
            ,seqid -- 期次
            ,repayinterest -- 计划还款利息
            ,discountcharges -- 贴息
            ,relativeserialno -- 关联变更申请流水号
            ,transt -- 核心是否已执行0未执行1已执行
            ,putoutno -- 出账号
            ,repaycorpus -- 计划还款本金
            ,currency -- 币种
            ,finishinterest -- 还本日期是否结息(0-不结息1-结息)
            ,corpusamount -- 本金余额
            ,accountmanageobjectno -- 关联提前还款申请流水号
            ,duebillno -- 借据号
            ,realinterest -- 实际利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.icms_payment_schedule_rela_op(
            keyid -- 主键
            ,repaymentdate -- 还款计划日期
            ,serialno -- 流水号
            ,migtflag -- 迁移标志：crsrcrilcupl
            ,adjusttype -- 调整类型
            ,seqid -- 期次
            ,repayinterest -- 计划还款利息
            ,discountcharges -- 贴息
            ,relativeserialno -- 关联变更申请流水号
            ,transt -- 核心是否已执行0未执行1已执行
            ,putoutno -- 出账号
            ,repaycorpus -- 计划还款本金
            ,currency -- 币种
            ,finishinterest -- 还本日期是否结息(0-不结息1-结息)
            ,corpusamount -- 本金余额
            ,accountmanageobjectno -- 关联提前还款申请流水号
            ,duebillno -- 借据号
            ,realinterest -- 实际利率
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.keyid -- 主键
    ,o.repaymentdate -- 还款计划日期
    ,o.serialno -- 流水号
    ,o.migtflag -- 迁移标志：crsrcrilcupl
    ,o.adjusttype -- 调整类型
    ,o.seqid -- 期次
    ,o.repayinterest -- 计划还款利息
    ,o.discountcharges -- 贴息
    ,o.relativeserialno -- 关联变更申请流水号
    ,o.transt -- 核心是否已执行0未执行1已执行
    ,o.putoutno -- 出账号
    ,o.repaycorpus -- 计划还款本金
    ,o.currency -- 币种
    ,o.finishinterest -- 还本日期是否结息(0-不结息1-结息)
    ,o.corpusamount -- 本金余额
    ,o.accountmanageobjectno -- 关联提前还款申请流水号
    ,o.duebillno -- 借据号
    ,o.realinterest -- 实际利率
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
from ${iol_schema}.icms_payment_schedule_rela_bk o
    left join ${iol_schema}.icms_payment_schedule_rela_op n
        on
            o.keyid = n.keyid
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.icms_payment_schedule_rela_cl d
        on
            o.keyid = d.keyid
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.icms_payment_schedule_rela;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('icms_payment_schedule_rela') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.icms_payment_schedule_rela drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.icms_payment_schedule_rela add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.icms_payment_schedule_rela exchange partition p_${batch_date} with table ${iol_schema}.icms_payment_schedule_rela_cl;
alter table ${iol_schema}.icms_payment_schedule_rela exchange partition p_20991231 with table ${iol_schema}.icms_payment_schedule_rela_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.icms_payment_schedule_rela to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.icms_payment_schedule_rela_op purge;
drop table ${iol_schema}.icms_payment_schedule_rela_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.icms_payment_schedule_rela_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'icms_payment_schedule_rela',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
