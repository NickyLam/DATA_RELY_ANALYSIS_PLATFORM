/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a02tcontracttranlist
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
create table ${iol_schema}.mpcs_a02tcontracttranlist_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a02tcontracttranlist
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a02tcontracttranlist_op purge;
drop table ${iol_schema}.mpcs_a02tcontracttranlist_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a02tcontracttranlist_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a02tcontracttranlist where 0=1;

create table ${iol_schema}.mpcs_a02tcontracttranlist_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a02tcontracttranlist where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a02tcontracttranlist_cl(
            fntseqno -- 
            ,chnlid -- 
            ,chnlseqno -- 
            ,thirdseqno -- 
            ,hostseqno -- 
            ,trntype -- 
            ,maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,acctno -- 
            ,trndt -- 
            ,trnts -- 
            ,trnbrcno -- 
            ,tlrno -- 
            ,authtlrno -- 
            ,fnttrncd -- 
            ,dsttrncd -- 
            ,trnname -- 
            ,trnresult -- 
            ,chkflag -- 
            ,prttimes -- 
            ,prtworkno -- 
            ,memo -- 
            ,opdata -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a02tcontracttranlist_op(
            fntseqno -- 
            ,chnlid -- 
            ,chnlseqno -- 
            ,thirdseqno -- 
            ,hostseqno -- 
            ,trntype -- 
            ,maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,acctno -- 
            ,trndt -- 
            ,trnts -- 
            ,trnbrcno -- 
            ,tlrno -- 
            ,authtlrno -- 
            ,fnttrncd -- 
            ,dsttrncd -- 
            ,trnname -- 
            ,trnresult -- 
            ,chkflag -- 
            ,prttimes -- 
            ,prtworkno -- 
            ,memo -- 
            ,opdata -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.fntseqno, o.fntseqno) as fntseqno -- 
    ,nvl(n.chnlid, o.chnlid) as chnlid -- 
    ,nvl(n.chnlseqno, o.chnlseqno) as chnlseqno -- 
    ,nvl(n.thirdseqno, o.thirdseqno) as thirdseqno -- 
    ,nvl(n.hostseqno, o.hostseqno) as hostseqno -- 
    ,nvl(n.trntype, o.trntype) as trntype -- 
    ,nvl(n.maincontractno, o.maincontractno) as maincontractno -- 
    ,nvl(n.contractno, o.contractno) as contractno -- 
    ,nvl(n.custno, o.custno) as custno -- 
    ,nvl(n.acctno, o.acctno) as acctno -- 
    ,nvl(n.trndt, o.trndt) as trndt -- 
    ,nvl(n.trnts, o.trnts) as trnts -- 
    ,nvl(n.trnbrcno, o.trnbrcno) as trnbrcno -- 
    ,nvl(n.tlrno, o.tlrno) as tlrno -- 
    ,nvl(n.authtlrno, o.authtlrno) as authtlrno -- 
    ,nvl(n.fnttrncd, o.fnttrncd) as fnttrncd -- 
    ,nvl(n.dsttrncd, o.dsttrncd) as dsttrncd -- 
    ,nvl(n.trnname, o.trnname) as trnname -- 
    ,nvl(n.trnresult, o.trnresult) as trnresult -- 
    ,nvl(n.chkflag, o.chkflag) as chkflag -- 
    ,nvl(n.prttimes, o.prttimes) as prttimes -- 
    ,nvl(n.prtworkno, o.prtworkno) as prtworkno -- 
    ,nvl(n.memo, o.memo) as memo -- 
    ,nvl(n.opdata, o.opdata) as opdata -- 
    ,case when
            n.fntseqno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.fntseqno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.fntseqno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a02tcontracttranlist_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a02tcontracttranlist where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.fntseqno = n.fntseqno
where (
        o.fntseqno is null
    )
    or (
        n.fntseqno is null
    )
    or (
        o.chnlid <> n.chnlid
        or o.chnlseqno <> n.chnlseqno
        or o.thirdseqno <> n.thirdseqno
        or o.hostseqno <> n.hostseqno
        or o.trntype <> n.trntype
        or o.maincontractno <> n.maincontractno
        or o.contractno <> n.contractno
        or o.custno <> n.custno
        or o.acctno <> n.acctno
        or o.trndt <> n.trndt
        or o.trnts <> n.trnts
        or o.trnbrcno <> n.trnbrcno
        or o.tlrno <> n.tlrno
        or o.authtlrno <> n.authtlrno
        or o.fnttrncd <> n.fnttrncd
        or o.dsttrncd <> n.dsttrncd
        or o.trnname <> n.trnname
        or o.trnresult <> n.trnresult
        or o.chkflag <> n.chkflag
        or o.prttimes <> n.prttimes
        or o.prtworkno <> n.prtworkno
        or o.memo <> n.memo
        or o.opdata <> n.opdata
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a02tcontracttranlist_cl(
            fntseqno -- 
            ,chnlid -- 
            ,chnlseqno -- 
            ,thirdseqno -- 
            ,hostseqno -- 
            ,trntype -- 
            ,maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,acctno -- 
            ,trndt -- 
            ,trnts -- 
            ,trnbrcno -- 
            ,tlrno -- 
            ,authtlrno -- 
            ,fnttrncd -- 
            ,dsttrncd -- 
            ,trnname -- 
            ,trnresult -- 
            ,chkflag -- 
            ,prttimes -- 
            ,prtworkno -- 
            ,memo -- 
            ,opdata -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a02tcontracttranlist_op(
            fntseqno -- 
            ,chnlid -- 
            ,chnlseqno -- 
            ,thirdseqno -- 
            ,hostseqno -- 
            ,trntype -- 
            ,maincontractno -- 
            ,contractno -- 
            ,custno -- 
            ,acctno -- 
            ,trndt -- 
            ,trnts -- 
            ,trnbrcno -- 
            ,tlrno -- 
            ,authtlrno -- 
            ,fnttrncd -- 
            ,dsttrncd -- 
            ,trnname -- 
            ,trnresult -- 
            ,chkflag -- 
            ,prttimes -- 
            ,prtworkno -- 
            ,memo -- 
            ,opdata -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.fntseqno -- 
    ,o.chnlid -- 
    ,o.chnlseqno -- 
    ,o.thirdseqno -- 
    ,o.hostseqno -- 
    ,o.trntype -- 
    ,o.maincontractno -- 
    ,o.contractno -- 
    ,o.custno -- 
    ,o.acctno -- 
    ,o.trndt -- 
    ,o.trnts -- 
    ,o.trnbrcno -- 
    ,o.tlrno -- 
    ,o.authtlrno -- 
    ,o.fnttrncd -- 
    ,o.dsttrncd -- 
    ,o.trnname -- 
    ,o.trnresult -- 
    ,o.chkflag -- 
    ,o.prttimes -- 
    ,o.prtworkno -- 
    ,o.memo -- 
    ,o.opdata -- 
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
from ${iol_schema}.mpcs_a02tcontracttranlist_bk o
    left join ${iol_schema}.mpcs_a02tcontracttranlist_op n
        on
            o.fntseqno = n.fntseqno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a02tcontracttranlist_cl d
        on
            o.fntseqno = d.fntseqno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
--truncate table ${iol_schema}.mpcs_a02tcontracttranlist;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('mpcs_a02tcontracttranlist') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.mpcs_a02tcontracttranlist drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.mpcs_a02tcontracttranlist add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.mpcs_a02tcontracttranlist exchange partition p_${batch_date} with table ${iol_schema}.mpcs_a02tcontracttranlist_cl;
alter table ${iol_schema}.mpcs_a02tcontracttranlist exchange partition p_20991231 with table ${iol_schema}.mpcs_a02tcontracttranlist_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a02tcontracttranlist to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a02tcontracttranlist_op purge;
drop table ${iol_schema}.mpcs_a02tcontracttranlist_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a02tcontracttranlist_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a02tcontracttranlist',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
