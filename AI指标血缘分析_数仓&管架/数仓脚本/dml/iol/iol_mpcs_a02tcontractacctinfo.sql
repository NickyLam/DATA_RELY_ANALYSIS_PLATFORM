/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a02tcontractacctinfo
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
create table ${iol_schema}.mpcs_a02tcontractacctinfo_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a02tcontractacctinfo
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a02tcontractacctinfo_op purge;
drop table ${iol_schema}.mpcs_a02tcontractacctinfo_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a02tcontractacctinfo_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a02tcontractacctinfo where 0=1;

create table ${iol_schema}.mpcs_a02tcontractacctinfo_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a02tcontractacctinfo where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a02tcontractacctinfo_cl(
            maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,acctno -- 
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
            ,chnid -- 渠道号
            ,orisigndt -- 原签约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a02tcontractacctinfo_op(
            maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,acctno -- 
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
            ,chnid -- 渠道号
            ,orisigndt -- 原签约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.maincontractno, o.maincontractno) as maincontractno -- 
    ,nvl(n.contractno, o.contractno) as contractno -- 
    ,nvl(n.custno, o.custno) as custno -- 
    ,nvl(n.acctno, o.acctno) as acctno -- 
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
    ,nvl(n.chnid, o.chnid) as chnid -- 渠道号
    ,nvl(n.orisigndt, o.orisigndt) as orisigndt -- 原签约日期
    ,case when
            n.contractno is null
            and n.acctno is null
            and n.signdt is null
            and n.signseqno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.contractno is null
            and n.acctno is null
            and n.signdt is null
            and n.signseqno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.contractno is null
            and n.acctno is null
            and n.signdt is null
            and n.signseqno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a02tcontractacctinfo_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a02tcontractacctinfo where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.contractno = n.contractno
            and o.acctno = n.acctno
            and o.signdt = n.signdt
            and o.signseqno = n.signseqno
where (
        o.contractno is null
        and o.acctno is null
        and o.signdt is null
        and o.signseqno is null
    )
    or (
        n.contractno is null
        and n.acctno is null
        and n.signdt is null
        and n.signseqno is null
    )
    or (
        o.maincontractno <> n.maincontractno
        or o.custno <> n.custno
        or o.signbrcno <> n.signbrcno
        or o.signtlrno <> n.signtlrno
        or o.unsigndt <> n.unsigndt
        or o.unsignbrcno <> n.unsignbrcno
        or o.unsigntlrno <> n.unsigntlrno
        or o.unsignseqno <> n.unsignseqno
        or o.contractstat <> n.contractstat
        or o.memo <> n.memo
        or o.chnid <> n.chnid
        or o.orisigndt <> n.orisigndt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a02tcontractacctinfo_cl(
            maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,acctno -- 
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
            ,chnid -- 渠道号
            ,orisigndt -- 原签约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a02tcontractacctinfo_op(
            maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,acctno -- 
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
            ,chnid -- 渠道号
            ,orisigndt -- 原签约日期
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.maincontractno -- 
    ,o.contractno -- 
    ,o.custno -- 
    ,o.acctno -- 
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
    ,o.chnid -- 渠道号
    ,o.orisigndt -- 原签约日期
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
from ${iol_schema}.mpcs_a02tcontractacctinfo_bk o
    left join ${iol_schema}.mpcs_a02tcontractacctinfo_op n
        on
            o.contractno = n.contractno
            and o.acctno = n.acctno
            and o.signdt = n.signdt
            and o.signseqno = n.signseqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a02tcontractacctinfo_cl d
        on
            o.contractno = d.contractno
            and o.acctno = d.acctno
            and o.signdt = d.signdt
            and o.signseqno = d.signseqno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a02tcontractacctinfo;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a02tcontractacctinfo') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a02tcontractacctinfo drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a02tcontractacctinfo add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a02tcontractacctinfo exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a02tcontractacctinfo_cl;
alter table ${iol_schema}.mpcs_a02tcontractacctinfo exchange partition p_20991231 with table ${iol_schema}.mpcs_a02tcontractacctinfo_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a02tcontractacctinfo to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a02tcontractacctinfo_op purge;
drop table ${iol_schema}.mpcs_a02tcontractacctinfo_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a02tcontractacctinfo_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a02tcontractacctinfo',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
