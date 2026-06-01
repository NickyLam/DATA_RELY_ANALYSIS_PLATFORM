/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a08tbankinfotmp
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
create table ${iol_schema}.mpcs_a08tbankinfotmp_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a08tbankinfotmp;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tbankinfotmp_op purge;
drop table ${iol_schema}.mpcs_a08tbankinfotmp_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a08tbankinfotmp_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tbankinfotmp where 0=1;

create table ${iol_schema}.mpcs_a08tbankinfotmp_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a08tbankinfotmp where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08tbankinfotmp_cl(
            trndt -- 
            ,transmitdt -- 
            ,transseq -- 
            ,sndbrn -- 
            ,sndupbrn -- 
            ,rcvbrn -- 
            ,rcvupbrn -- 
            ,syscd -- 
            ,chngtp -- 
            ,bkcd -- 
            ,bkstatus -- 
            ,banktype -- 
            ,bkctgycd -- 
            ,drctbkcd -- 
            ,bkname -- 
            ,bksname -- 
            ,lglprsn -- 
            ,hghptcpt -- 
            ,brbkcd -- 
            ,chrgbkcd -- 
            ,ndcd -- 
            ,citycd -- 
            ,sgn -- 
            ,tel -- 
            ,chngnb -- 
            ,fctvdt -- 
            ,ifctvdt -- 
            ,acctbkcdinf -- 入账行行号信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08tbankinfotmp_op(
            trndt -- 
            ,transmitdt -- 
            ,transseq -- 
            ,sndbrn -- 
            ,sndupbrn -- 
            ,rcvbrn -- 
            ,rcvupbrn -- 
            ,syscd -- 
            ,chngtp -- 
            ,bkcd -- 
            ,bkstatus -- 
            ,banktype -- 
            ,bkctgycd -- 
            ,drctbkcd -- 
            ,bkname -- 
            ,bksname -- 
            ,lglprsn -- 
            ,hghptcpt -- 
            ,brbkcd -- 
            ,chrgbkcd -- 
            ,ndcd -- 
            ,citycd -- 
            ,sgn -- 
            ,tel -- 
            ,chngnb -- 
            ,fctvdt -- 
            ,ifctvdt -- 
            ,acctbkcdinf -- 入账行行号信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.trndt, o.trndt) as trndt -- 
    ,nvl(n.transmitdt, o.transmitdt) as transmitdt -- 
    ,nvl(n.transseq, o.transseq) as transseq -- 
    ,nvl(n.sndbrn, o.sndbrn) as sndbrn -- 
    ,nvl(n.sndupbrn, o.sndupbrn) as sndupbrn -- 
    ,nvl(n.rcvbrn, o.rcvbrn) as rcvbrn -- 
    ,nvl(n.rcvupbrn, o.rcvupbrn) as rcvupbrn -- 
    ,nvl(n.syscd, o.syscd) as syscd -- 
    ,nvl(n.chngtp, o.chngtp) as chngtp -- 
    ,nvl(n.bkcd, o.bkcd) as bkcd -- 
    ,nvl(n.bkstatus, o.bkstatus) as bkstatus -- 
    ,nvl(n.banktype, o.banktype) as banktype -- 
    ,nvl(n.bkctgycd, o.bkctgycd) as bkctgycd -- 
    ,nvl(n.drctbkcd, o.drctbkcd) as drctbkcd -- 
    ,nvl(n.bkname, o.bkname) as bkname -- 
    ,nvl(n.bksname, o.bksname) as bksname -- 
    ,nvl(n.lglprsn, o.lglprsn) as lglprsn -- 
    ,nvl(n.hghptcpt, o.hghptcpt) as hghptcpt -- 
    ,nvl(n.brbkcd, o.brbkcd) as brbkcd -- 
    ,nvl(n.chrgbkcd, o.chrgbkcd) as chrgbkcd -- 
    ,nvl(n.ndcd, o.ndcd) as ndcd -- 
    ,nvl(n.citycd, o.citycd) as citycd -- 
    ,nvl(n.sgn, o.sgn) as sgn -- 
    ,nvl(n.tel, o.tel) as tel -- 
    ,nvl(n.chngnb, o.chngnb) as chngnb -- 
    ,nvl(n.fctvdt, o.fctvdt) as fctvdt -- 
    ,nvl(n.ifctvdt, o.ifctvdt) as ifctvdt -- 
    ,nvl(n.acctbkcdinf, o.acctbkcdinf) as acctbkcdinf -- 入账行行号信息
    ,case when
            n.transseq is null
            and n.bkcd is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.transseq is null
            and n.bkcd is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.transseq is null
            and n.bkcd is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a08tbankinfotmp_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a08tbankinfotmp where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.transseq = n.transseq
            and o.bkcd = n.bkcd
where (
        o.transseq is null
        and o.bkcd is null
    )
    or (
        n.transseq is null
        and n.bkcd is null
    )
    or (
        o.trndt <> n.trndt
        or o.transmitdt <> n.transmitdt
        or o.sndbrn <> n.sndbrn
        or o.sndupbrn <> n.sndupbrn
        or o.rcvbrn <> n.rcvbrn
        or o.rcvupbrn <> n.rcvupbrn
        or o.syscd <> n.syscd
        or o.chngtp <> n.chngtp
        or o.bkstatus <> n.bkstatus
        or o.banktype <> n.banktype
        or o.bkctgycd <> n.bkctgycd
        or o.drctbkcd <> n.drctbkcd
        or o.bkname <> n.bkname
        or o.bksname <> n.bksname
        or o.lglprsn <> n.lglprsn
        or o.hghptcpt <> n.hghptcpt
        or o.brbkcd <> n.brbkcd
        or o.chrgbkcd <> n.chrgbkcd
        or o.ndcd <> n.ndcd
        or o.citycd <> n.citycd
        or o.sgn <> n.sgn
        or o.tel <> n.tel
        or o.chngnb <> n.chngnb
        or o.fctvdt <> n.fctvdt
        or o.ifctvdt <> n.ifctvdt
        or o.acctbkcdinf <> n.acctbkcdinf
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a08tbankinfotmp_cl(
            trndt -- 
            ,transmitdt -- 
            ,transseq -- 
            ,sndbrn -- 
            ,sndupbrn -- 
            ,rcvbrn -- 
            ,rcvupbrn -- 
            ,syscd -- 
            ,chngtp -- 
            ,bkcd -- 
            ,bkstatus -- 
            ,banktype -- 
            ,bkctgycd -- 
            ,drctbkcd -- 
            ,bkname -- 
            ,bksname -- 
            ,lglprsn -- 
            ,hghptcpt -- 
            ,brbkcd -- 
            ,chrgbkcd -- 
            ,ndcd -- 
            ,citycd -- 
            ,sgn -- 
            ,tel -- 
            ,chngnb -- 
            ,fctvdt -- 
            ,ifctvdt -- 
            ,acctbkcdinf -- 入账行行号信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a08tbankinfotmp_op(
            trndt -- 
            ,transmitdt -- 
            ,transseq -- 
            ,sndbrn -- 
            ,sndupbrn -- 
            ,rcvbrn -- 
            ,rcvupbrn -- 
            ,syscd -- 
            ,chngtp -- 
            ,bkcd -- 
            ,bkstatus -- 
            ,banktype -- 
            ,bkctgycd -- 
            ,drctbkcd -- 
            ,bkname -- 
            ,bksname -- 
            ,lglprsn -- 
            ,hghptcpt -- 
            ,brbkcd -- 
            ,chrgbkcd -- 
            ,ndcd -- 
            ,citycd -- 
            ,sgn -- 
            ,tel -- 
            ,chngnb -- 
            ,fctvdt -- 
            ,ifctvdt -- 
            ,acctbkcdinf -- 入账行行号信息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.trndt -- 
    ,o.transmitdt -- 
    ,o.transseq -- 
    ,o.sndbrn -- 
    ,o.sndupbrn -- 
    ,o.rcvbrn -- 
    ,o.rcvupbrn -- 
    ,o.syscd -- 
    ,o.chngtp -- 
    ,o.bkcd -- 
    ,o.bkstatus -- 
    ,o.banktype -- 
    ,o.bkctgycd -- 
    ,o.drctbkcd -- 
    ,o.bkname -- 
    ,o.bksname -- 
    ,o.lglprsn -- 
    ,o.hghptcpt -- 
    ,o.brbkcd -- 
    ,o.chrgbkcd -- 
    ,o.ndcd -- 
    ,o.citycd -- 
    ,o.sgn -- 
    ,o.tel -- 
    ,o.chngnb -- 
    ,o.fctvdt -- 
    ,o.ifctvdt -- 
    ,o.acctbkcdinf -- 入账行行号信息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a08tbankinfotmp_bk o
    left join ${iol_schema}.mpcs_a08tbankinfotmp_op n
        on
            o.transseq = n.transseq
            and o.bkcd = n.bkcd
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a08tbankinfotmp_cl d
        on
            o.transseq = d.transseq
            and o.bkcd = d.bkcd
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a08tbankinfotmp;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a08tbankinfotmp exchange partition p_19000101 with table ${iol_schema}.mpcs_a08tbankinfotmp_cl;
alter table ${iol_schema}.mpcs_a08tbankinfotmp exchange partition p_20991231 with table ${iol_schema}.mpcs_a08tbankinfotmp_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a08tbankinfotmp to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a08tbankinfotmp_op purge;
drop table ${iol_schema}.mpcs_a08tbankinfotmp_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a08tbankinfotmp_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a08tbankinfotmp',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
