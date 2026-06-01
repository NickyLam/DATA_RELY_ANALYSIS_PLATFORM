/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_feb
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
create table ${iol_schema}.isbs_feb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_feb;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_feb_op purge;
drop table ${iol_schema}.isbs_feb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_feb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_feb where 0=1;

create table ${iol_schema}.isbs_feb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_feb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_feb_cl(
            actiondesc -- 
            ,credit -- 
            ,deal_date -- 
            ,balance -- 
            ,branch_code -- 
            ,currency_code -- 
            ,ver -- 
            ,remark -- 
            ,actiontype -- 
            ,accountno -- 
            ,feb_type -- 
            ,debit -- 
            ,inr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_feb_op(
            actiondesc -- 
            ,credit -- 
            ,deal_date -- 
            ,balance -- 
            ,branch_code -- 
            ,currency_code -- 
            ,ver -- 
            ,remark -- 
            ,actiontype -- 
            ,accountno -- 
            ,feb_type -- 
            ,debit -- 
            ,inr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.actiondesc, o.actiondesc) as actiondesc -- 
    ,nvl(n.credit, o.credit) as credit -- 
    ,nvl(n.deal_date, o.deal_date) as deal_date -- 
    ,nvl(n.balance, o.balance) as balance -- 
    ,nvl(n.branch_code, o.branch_code) as branch_code -- 
    ,nvl(n.currency_code, o.currency_code) as currency_code -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.remark, o.remark) as remark -- 
    ,nvl(n.actiontype, o.actiontype) as actiontype -- 
    ,nvl(n.accountno, o.accountno) as accountno -- 
    ,nvl(n.feb_type, o.feb_type) as feb_type -- 
    ,nvl(n.debit, o.debit) as debit -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,case when
            n.inr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.inr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.inr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_feb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_feb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.actiondesc <> n.actiondesc
        or o.credit <> n.credit
        or o.deal_date <> n.deal_date
        or o.balance <> n.balance
        or o.branch_code <> n.branch_code
        or o.currency_code <> n.currency_code
        or o.ver <> n.ver
        or o.remark <> n.remark
        or o.actiontype <> n.actiontype
        or o.accountno <> n.accountno
        or o.feb_type <> n.feb_type
        or o.debit <> n.debit
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_feb_cl(
            actiondesc -- 
            ,credit -- 
            ,deal_date -- 
            ,balance -- 
            ,branch_code -- 
            ,currency_code -- 
            ,ver -- 
            ,remark -- 
            ,actiontype -- 
            ,accountno -- 
            ,feb_type -- 
            ,debit -- 
            ,inr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_feb_op(
            actiondesc -- 
            ,credit -- 
            ,deal_date -- 
            ,balance -- 
            ,branch_code -- 
            ,currency_code -- 
            ,ver -- 
            ,remark -- 
            ,actiontype -- 
            ,accountno -- 
            ,feb_type -- 
            ,debit -- 
            ,inr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.actiondesc -- 
    ,o.credit -- 
    ,o.deal_date -- 
    ,o.balance -- 
    ,o.branch_code -- 
    ,o.currency_code -- 
    ,o.ver -- 
    ,o.remark -- 
    ,o.actiontype -- 
    ,o.accountno -- 
    ,o.feb_type -- 
    ,o.debit -- 
    ,o.inr -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_feb_bk o
    left join ${iol_schema}.isbs_feb_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_feb_cl d
        on
            o.inr = d.inr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_feb;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_feb exchange partition p_19000101 with table ${iol_schema}.isbs_feb_cl;
alter table ${iol_schema}.isbs_feb exchange partition p_20991231 with table ${iol_schema}.isbs_feb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_feb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_feb_op purge;
drop table ${iol_schema}.isbs_feb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_feb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_feb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
