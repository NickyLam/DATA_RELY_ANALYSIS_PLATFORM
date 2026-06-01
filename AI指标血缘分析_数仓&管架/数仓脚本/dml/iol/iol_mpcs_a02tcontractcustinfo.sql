/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a02tcontractcustinfo
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
create table ${iol_schema}.mpcs_a02tcontractcustinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a02tcontractcustinfo;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a02tcontractcustinfo_op purge;
drop table ${iol_schema}.mpcs_a02tcontractcustinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a02tcontractcustinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a02tcontractcustinfo where 0=1;

create table ${iol_schema}.mpcs_a02tcontractcustinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a02tcontractcustinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a02tcontractcustinfo_cl(
            maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,signdt -- 
            ,signbrcno -- 
            ,signtlrno -- 
            ,signseqno -- 
            ,unsigndt -- 
            ,unsignbrcno -- 
            ,unsigntlrno -- 
            ,unsignseqno -- 
            ,contractstat -- 
            ,memo -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a02tcontractcustinfo_op(
            maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,signdt -- 
            ,signbrcno -- 
            ,signtlrno -- 
            ,signseqno -- 
            ,unsigndt -- 
            ,unsignbrcno -- 
            ,unsigntlrno -- 
            ,unsignseqno -- 
            ,contractstat -- 
            ,memo -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.maincontractno, o.maincontractno) as maincontractno -- 
    ,nvl(n.contractno, o.contractno) as contractno -- 
    ,nvl(n.custno, o.custno) as custno -- 
    ,nvl(n.signdt, o.signdt) as signdt -- 
    ,nvl(n.signbrcno, o.signbrcno) as signbrcno -- 
    ,nvl(n.signtlrno, o.signtlrno) as signtlrno -- 
    ,nvl(n.signseqno, o.signseqno) as signseqno -- 
    ,nvl(n.unsigndt, o.unsigndt) as unsigndt -- 
    ,nvl(n.unsignbrcno, o.unsignbrcno) as unsignbrcno -- 
    ,nvl(n.unsigntlrno, o.unsigntlrno) as unsigntlrno -- 
    ,nvl(n.unsignseqno, o.unsignseqno) as unsignseqno -- 
    ,nvl(n.contractstat, o.contractstat) as contractstat -- 
    ,nvl(n.memo, o.memo) as memo -- 
    ,case when
            n.maincontractno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.maincontractno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.maincontractno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a02tcontractcustinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a02tcontractcustinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.maincontractno = n.maincontractno
where (
        o.maincontractno is null
    )
    or (
        n.maincontractno is null
    )
    or (
        o.contractno <> n.contractno
        or o.custno <> n.custno
        or o.signdt <> n.signdt
        or o.signbrcno <> n.signbrcno
        or o.signtlrno <> n.signtlrno
        or o.signseqno <> n.signseqno
        or o.unsigndt <> n.unsigndt
        or o.unsignbrcno <> n.unsignbrcno
        or o.unsigntlrno <> n.unsigntlrno
        or o.unsignseqno <> n.unsignseqno
        or o.contractstat <> n.contractstat
        or o.memo <> n.memo
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a02tcontractcustinfo_cl(
            maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,signdt -- 
            ,signbrcno -- 
            ,signtlrno -- 
            ,signseqno -- 
            ,unsigndt -- 
            ,unsignbrcno -- 
            ,unsigntlrno -- 
            ,unsignseqno -- 
            ,contractstat -- 
            ,memo -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a02tcontractcustinfo_op(
            maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,signdt -- 
            ,signbrcno -- 
            ,signtlrno -- 
            ,signseqno -- 
            ,unsigndt -- 
            ,unsignbrcno -- 
            ,unsigntlrno -- 
            ,unsignseqno -- 
            ,contractstat -- 
            ,memo -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.maincontractno -- 
    ,o.contractno -- 
    ,o.custno -- 
    ,o.signdt -- 
    ,o.signbrcno -- 
    ,o.signtlrno -- 
    ,o.signseqno -- 
    ,o.unsigndt -- 
    ,o.unsignbrcno -- 
    ,o.unsigntlrno -- 
    ,o.unsignseqno -- 
    ,o.contractstat -- 
    ,o.memo -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a02tcontractcustinfo_bk o
    left join ${iol_schema}.mpcs_a02tcontractcustinfo_op n
        on
            o.maincontractno = n.maincontractno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a02tcontractcustinfo_cl d
        on
            o.maincontractno = d.maincontractno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a02tcontractcustinfo;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a02tcontractcustinfo exchange partition p_19000101 with table ${iol_schema}.mpcs_a02tcontractcustinfo_cl;
alter table ${iol_schema}.mpcs_a02tcontractcustinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a02tcontractcustinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a02tcontractcustinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a02tcontractcustinfo_op purge;
drop table ${iol_schema}.mpcs_a02tcontractcustinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a02tcontractcustinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a02tcontractcustinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
