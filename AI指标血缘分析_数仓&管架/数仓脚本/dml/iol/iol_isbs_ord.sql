/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_ord
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
create table ${iol_schema}.isbs_ord_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_ord;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ord_op purge;
drop table ${iol_schema}.isbs_ord_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ord_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ord where 0=1;

create table ${iol_schema}.isbs_ord_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ord where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ord_cl(
            totdur -- 
            ,bchkeyinr -- 
            ,sta -- 
            ,extkey -- 
            ,branchinr -- 
            ,etyextkey -- 
            ,inr -- 
            ,inftxt -- 
            ,cpldattim -- 
            ,smhinr -- 
            ,chkflg -- 
            ,ownusg -- 
            ,objtyp -- 
            ,nam -- 
            ,stadattim -- 
            ,tardattim -- 
            ,slacla -- 
            ,ptainr -- 
            ,inidattim -- 
            ,infdsp -- 
            ,frm -- 
            ,etgextkey -- 
            ,sdhflg -- 
            ,ownusr -- 
            ,objinr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ord_op(
            totdur -- 
            ,bchkeyinr -- 
            ,sta -- 
            ,extkey -- 
            ,branchinr -- 
            ,etyextkey -- 
            ,inr -- 
            ,inftxt -- 
            ,cpldattim -- 
            ,smhinr -- 
            ,chkflg -- 
            ,ownusg -- 
            ,objtyp -- 
            ,nam -- 
            ,stadattim -- 
            ,tardattim -- 
            ,slacla -- 
            ,ptainr -- 
            ,inidattim -- 
            ,infdsp -- 
            ,frm -- 
            ,etgextkey -- 
            ,sdhflg -- 
            ,ownusr -- 
            ,objinr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.totdur, o.totdur) as totdur -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.sta, o.sta) as sta -- 
    ,nvl(n.extkey, o.extkey) as extkey -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.inftxt, o.inftxt) as inftxt -- 
    ,nvl(n.cpldattim, o.cpldattim) as cpldattim -- 
    ,nvl(n.smhinr, o.smhinr) as smhinr -- 
    ,nvl(n.chkflg, o.chkflg) as chkflg -- 
    ,nvl(n.ownusg, o.ownusg) as ownusg -- 
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.stadattim, o.stadattim) as stadattim -- 
    ,nvl(n.tardattim, o.tardattim) as tardattim -- 
    ,nvl(n.slacla, o.slacla) as slacla -- 
    ,nvl(n.ptainr, o.ptainr) as ptainr -- 
    ,nvl(n.inidattim, o.inidattim) as inidattim -- 
    ,nvl(n.infdsp, o.infdsp) as infdsp -- 
    ,nvl(n.frm, o.frm) as frm -- 
    ,nvl(n.etgextkey, o.etgextkey) as etgextkey -- 
    ,nvl(n.sdhflg, o.sdhflg) as sdhflg -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.objinr, o.objinr) as objinr -- 
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
from (select * from ${iol_schema}.isbs_ord_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_ord where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.totdur <> n.totdur
        or o.bchkeyinr <> n.bchkeyinr
        or o.sta <> n.sta
        or o.extkey <> n.extkey
        or o.branchinr <> n.branchinr
        or o.etyextkey <> n.etyextkey
        or o.inftxt <> n.inftxt
        or o.cpldattim <> n.cpldattim
        or o.smhinr <> n.smhinr
        or o.chkflg <> n.chkflg
        or o.ownusg <> n.ownusg
        or o.objtyp <> n.objtyp
        or o.nam <> n.nam
        or o.stadattim <> n.stadattim
        or o.tardattim <> n.tardattim
        or o.slacla <> n.slacla
        or o.ptainr <> n.ptainr
        or o.inidattim <> n.inidattim
        or o.infdsp <> n.infdsp
        or o.frm <> n.frm
        or o.etgextkey <> n.etgextkey
        or o.sdhflg <> n.sdhflg
        or o.ownusr <> n.ownusr
        or o.objinr <> n.objinr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ord_cl(
            totdur -- 
            ,bchkeyinr -- 
            ,sta -- 
            ,extkey -- 
            ,branchinr -- 
            ,etyextkey -- 
            ,inr -- 
            ,inftxt -- 
            ,cpldattim -- 
            ,smhinr -- 
            ,chkflg -- 
            ,ownusg -- 
            ,objtyp -- 
            ,nam -- 
            ,stadattim -- 
            ,tardattim -- 
            ,slacla -- 
            ,ptainr -- 
            ,inidattim -- 
            ,infdsp -- 
            ,frm -- 
            ,etgextkey -- 
            ,sdhflg -- 
            ,ownusr -- 
            ,objinr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ord_op(
            totdur -- 
            ,bchkeyinr -- 
            ,sta -- 
            ,extkey -- 
            ,branchinr -- 
            ,etyextkey -- 
            ,inr -- 
            ,inftxt -- 
            ,cpldattim -- 
            ,smhinr -- 
            ,chkflg -- 
            ,ownusg -- 
            ,objtyp -- 
            ,nam -- 
            ,stadattim -- 
            ,tardattim -- 
            ,slacla -- 
            ,ptainr -- 
            ,inidattim -- 
            ,infdsp -- 
            ,frm -- 
            ,etgextkey -- 
            ,sdhflg -- 
            ,ownusr -- 
            ,objinr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.totdur -- 
    ,o.bchkeyinr -- 
    ,o.sta -- 
    ,o.extkey -- 
    ,o.branchinr -- 
    ,o.etyextkey -- 
    ,o.inr -- 
    ,o.inftxt -- 
    ,o.cpldattim -- 
    ,o.smhinr -- 
    ,o.chkflg -- 
    ,o.ownusg -- 
    ,o.objtyp -- 
    ,o.nam -- 
    ,o.stadattim -- 
    ,o.tardattim -- 
    ,o.slacla -- 
    ,o.ptainr -- 
    ,o.inidattim -- 
    ,o.infdsp -- 
    ,o.frm -- 
    ,o.etgextkey -- 
    ,o.sdhflg -- 
    ,o.ownusr -- 
    ,o.objinr -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_ord_bk o
    left join ${iol_schema}.isbs_ord_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_ord_cl d
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
-- truncate table ${iol_schema}.isbs_ord;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_ord exchange partition p_19000101 with table ${iol_schema}.isbs_ord_cl;
alter table ${iol_schema}.isbs_ord exchange partition p_20991231 with table ${iol_schema}.isbs_ord_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_ord to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ord_op purge;
drop table ${iol_schema}.isbs_ord_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_ord_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_ord',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
