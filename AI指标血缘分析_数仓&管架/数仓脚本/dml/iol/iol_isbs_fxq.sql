/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_fxq
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
create table ${iol_schema}.isbs_fxq_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_fxq;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fxq_op purge;
drop table ${iol_schema}.isbs_fxq_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fxq_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fxq where 0=1;

create table ${iol_schema}.isbs_fxq_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fxq where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fxq_cl(
            opidtp -- 
            ,agidno -- 
            ,opbrtp -- 
            ,tranad -- 
            ,tranrc -- 
            ,itstsq -- 
            ,trninr -- 
            ,pscrtx -- 
            ,trandt -- 
            ,opcuna -- 
            ,relatp -- 
            ,crcycd -- 
            ,tranbr -- 
            ,opcnty -- 
            ,tranct -- 
            ,frtran -- 
            ,opbrar -- 
            ,opidno -- 
            ,opactp -- 
            ,tranti -- 
            ,opbrna -- 
            ,opbrno -- 
            ,tranam -- 
            ,opacno -- 
            ,agenna -- 
            ,accttp -- 
            ,acctbr -- 
            ,agidtp -- 
            ,custno -- 
            ,agennt -- 
            ,transq -- 
            ,tranmt -- 
            ,amntcd -- 
            ,acctno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fxq_op(
            opidtp -- 
            ,agidno -- 
            ,opbrtp -- 
            ,tranad -- 
            ,tranrc -- 
            ,itstsq -- 
            ,trninr -- 
            ,pscrtx -- 
            ,trandt -- 
            ,opcuna -- 
            ,relatp -- 
            ,crcycd -- 
            ,tranbr -- 
            ,opcnty -- 
            ,tranct -- 
            ,frtran -- 
            ,opbrar -- 
            ,opidno -- 
            ,opactp -- 
            ,tranti -- 
            ,opbrna -- 
            ,opbrno -- 
            ,tranam -- 
            ,opacno -- 
            ,agenna -- 
            ,accttp -- 
            ,acctbr -- 
            ,agidtp -- 
            ,custno -- 
            ,agennt -- 
            ,transq -- 
            ,tranmt -- 
            ,amntcd -- 
            ,acctno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.opidtp, o.opidtp) as opidtp -- 
    ,nvl(n.agidno, o.agidno) as agidno -- 
    ,nvl(n.opbrtp, o.opbrtp) as opbrtp -- 
    ,nvl(n.tranad, o.tranad) as tranad -- 
    ,nvl(n.tranrc, o.tranrc) as tranrc -- 
    ,nvl(n.itstsq, o.itstsq) as itstsq -- 
    ,nvl(n.trninr, o.trninr) as trninr -- 
    ,nvl(n.pscrtx, o.pscrtx) as pscrtx -- 
    ,nvl(n.trandt, o.trandt) as trandt -- 
    ,nvl(n.opcuna, o.opcuna) as opcuna -- 
    ,nvl(n.relatp, o.relatp) as relatp -- 
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 
    ,nvl(n.tranbr, o.tranbr) as tranbr -- 
    ,nvl(n.opcnty, o.opcnty) as opcnty -- 
    ,nvl(n.tranct, o.tranct) as tranct -- 
    ,nvl(n.frtran, o.frtran) as frtran -- 
    ,nvl(n.opbrar, o.opbrar) as opbrar -- 
    ,nvl(n.opidno, o.opidno) as opidno -- 
    ,nvl(n.opactp, o.opactp) as opactp -- 
    ,nvl(n.tranti, o.tranti) as tranti -- 
    ,nvl(n.opbrna, o.opbrna) as opbrna -- 
    ,nvl(n.opbrno, o.opbrno) as opbrno -- 
    ,nvl(n.tranam, o.tranam) as tranam -- 
    ,nvl(n.opacno, o.opacno) as opacno -- 
    ,nvl(n.agenna, o.agenna) as agenna -- 
    ,nvl(n.accttp, o.accttp) as accttp -- 
    ,nvl(n.acctbr, o.acctbr) as acctbr -- 
    ,nvl(n.agidtp, o.agidtp) as agidtp -- 
    ,nvl(n.custno, o.custno) as custno -- 
    ,nvl(n.agennt, o.agennt) as agennt -- 
    ,nvl(n.transq, o.transq) as transq -- 
    ,nvl(n.tranmt, o.tranmt) as tranmt -- 
    ,nvl(n.amntcd, o.amntcd) as amntcd -- 
    ,nvl(n.acctno, o.acctno) as acctno -- 
    ,case when
            n.trninr is null
            and n.acctno is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.trninr is null
            and n.acctno is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.trninr is null
            and n.acctno is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_fxq_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_fxq where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.trninr = n.trninr
            and o.acctno = n.acctno
where (
        o.trninr is null
        and o.acctno is null
    )
    or (
        n.trninr is null
        and n.acctno is null
    )
    or (
        o.opidtp <> n.opidtp
        or o.agidno <> n.agidno
        or o.opbrtp <> n.opbrtp
        or o.tranad <> n.tranad
        or o.tranrc <> n.tranrc
        or o.itstsq <> n.itstsq
        or o.pscrtx <> n.pscrtx
        or o.trandt <> n.trandt
        or o.opcuna <> n.opcuna
        or o.relatp <> n.relatp
        or o.crcycd <> n.crcycd
        or o.tranbr <> n.tranbr
        or o.opcnty <> n.opcnty
        or o.tranct <> n.tranct
        or o.frtran <> n.frtran
        or o.opbrar <> n.opbrar
        or o.opidno <> n.opidno
        or o.opactp <> n.opactp
        or o.tranti <> n.tranti
        or o.opbrna <> n.opbrna
        or o.opbrno <> n.opbrno
        or o.tranam <> n.tranam
        or o.opacno <> n.opacno
        or o.agenna <> n.agenna
        or o.accttp <> n.accttp
        or o.acctbr <> n.acctbr
        or o.agidtp <> n.agidtp
        or o.custno <> n.custno
        or o.agennt <> n.agennt
        or o.transq <> n.transq
        or o.tranmt <> n.tranmt
        or o.amntcd <> n.amntcd
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fxq_cl(
            opidtp -- 
            ,agidno -- 
            ,opbrtp -- 
            ,tranad -- 
            ,tranrc -- 
            ,itstsq -- 
            ,trninr -- 
            ,pscrtx -- 
            ,trandt -- 
            ,opcuna -- 
            ,relatp -- 
            ,crcycd -- 
            ,tranbr -- 
            ,opcnty -- 
            ,tranct -- 
            ,frtran -- 
            ,opbrar -- 
            ,opidno -- 
            ,opactp -- 
            ,tranti -- 
            ,opbrna -- 
            ,opbrno -- 
            ,tranam -- 
            ,opacno -- 
            ,agenna -- 
            ,accttp -- 
            ,acctbr -- 
            ,agidtp -- 
            ,custno -- 
            ,agennt -- 
            ,transq -- 
            ,tranmt -- 
            ,amntcd -- 
            ,acctno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fxq_op(
            opidtp -- 
            ,agidno -- 
            ,opbrtp -- 
            ,tranad -- 
            ,tranrc -- 
            ,itstsq -- 
            ,trninr -- 
            ,pscrtx -- 
            ,trandt -- 
            ,opcuna -- 
            ,relatp -- 
            ,crcycd -- 
            ,tranbr -- 
            ,opcnty -- 
            ,tranct -- 
            ,frtran -- 
            ,opbrar -- 
            ,opidno -- 
            ,opactp -- 
            ,tranti -- 
            ,opbrna -- 
            ,opbrno -- 
            ,tranam -- 
            ,opacno -- 
            ,agenna -- 
            ,accttp -- 
            ,acctbr -- 
            ,agidtp -- 
            ,custno -- 
            ,agennt -- 
            ,transq -- 
            ,tranmt -- 
            ,amntcd -- 
            ,acctno -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.opidtp -- 
    ,o.agidno -- 
    ,o.opbrtp -- 
    ,o.tranad -- 
    ,o.tranrc -- 
    ,o.itstsq -- 
    ,o.trninr -- 
    ,o.pscrtx -- 
    ,o.trandt -- 
    ,o.opcuna -- 
    ,o.relatp -- 
    ,o.crcycd -- 
    ,o.tranbr -- 
    ,o.opcnty -- 
    ,o.tranct -- 
    ,o.frtran -- 
    ,o.opbrar -- 
    ,o.opidno -- 
    ,o.opactp -- 
    ,o.tranti -- 
    ,o.opbrna -- 
    ,o.opbrno -- 
    ,o.tranam -- 
    ,o.opacno -- 
    ,o.agenna -- 
    ,o.accttp -- 
    ,o.acctbr -- 
    ,o.agidtp -- 
    ,o.custno -- 
    ,o.agennt -- 
    ,o.transq -- 
    ,o.tranmt -- 
    ,o.amntcd -- 
    ,o.acctno -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_fxq_bk o
    left join ${iol_schema}.isbs_fxq_op n
        on
            o.trninr = n.trninr
            and o.acctno = n.acctno
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fxq_cl d
        on
            o.trninr = d.trninr
            and o.acctno = d.acctno
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_fxq;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_fxq exchange partition p_19000101 with table ${iol_schema}.isbs_fxq_cl;
alter table ${iol_schema}.isbs_fxq exchange partition p_20991231 with table ${iol_schema}.isbs_fxq_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_fxq to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fxq_op purge;
drop table ${iol_schema}.isbs_fxq_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_fxq_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_fxq',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
