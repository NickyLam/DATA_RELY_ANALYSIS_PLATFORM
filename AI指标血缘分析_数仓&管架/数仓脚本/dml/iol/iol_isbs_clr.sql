/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_clr
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
create table ${iol_schema}.isbs_clr_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_clr;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_clr_op purge;
drop table ${iol_schema}.isbs_clr_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_clr_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_clr where 0=1;

create table ${iol_schema}.isbs_clr_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_clr where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_clr_cl(
            credat -- 
            ,amt -- 
            ,ownref -- 
            ,trntyp -- 
            ,opndat -- 
            ,bchkeyinr -- 
            ,sta -- 
            ,srcinr -- 
            ,sndptyinr -- 
            ,ownusr -- 
            ,cur -- 
            ,smhinr -- 
            ,nam -- 
            ,selconfrm -- 
            ,errmsg -- 
            ,clsdat -- 
            ,inr -- 
            ,srctyp -- 
            ,selconref -- 
            ,bussec -- 
            ,ver -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_clr_op(
            credat -- 
            ,amt -- 
            ,ownref -- 
            ,trntyp -- 
            ,opndat -- 
            ,bchkeyinr -- 
            ,sta -- 
            ,srcinr -- 
            ,sndptyinr -- 
            ,ownusr -- 
            ,cur -- 
            ,smhinr -- 
            ,nam -- 
            ,selconfrm -- 
            ,errmsg -- 
            ,clsdat -- 
            ,inr -- 
            ,srctyp -- 
            ,selconref -- 
            ,bussec -- 
            ,ver -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.credat, o.credat) as credat -- 
    ,nvl(n.amt, o.amt) as amt -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.trntyp, o.trntyp) as trntyp -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.sta, o.sta) as sta -- 
    ,nvl(n.srcinr, o.srcinr) as srcinr -- 
    ,nvl(n.sndptyinr, o.sndptyinr) as sndptyinr -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.cur, o.cur) as cur -- 
    ,nvl(n.smhinr, o.smhinr) as smhinr -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.selconfrm, o.selconfrm) as selconfrm -- 
    ,nvl(n.errmsg, o.errmsg) as errmsg -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.srctyp, o.srctyp) as srctyp -- 
    ,nvl(n.selconref, o.selconref) as selconref -- 
    ,nvl(n.bussec, o.bussec) as bussec -- 
    ,nvl(n.ver, o.ver) as ver -- 
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
from (select * from ${iol_schema}.isbs_clr_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_clr where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.credat <> n.credat
        or o.amt <> n.amt
        or o.ownref <> n.ownref
        or o.trntyp <> n.trntyp
        or o.opndat <> n.opndat
        or o.bchkeyinr <> n.bchkeyinr
        or o.sta <> n.sta
        or o.srcinr <> n.srcinr
        or o.sndptyinr <> n.sndptyinr
        or o.ownusr <> n.ownusr
        or o.cur <> n.cur
        or o.smhinr <> n.smhinr
        or o.nam <> n.nam
        or o.selconfrm <> n.selconfrm
        or o.errmsg <> n.errmsg
        or o.clsdat <> n.clsdat
        or o.srctyp <> n.srctyp
        or o.selconref <> n.selconref
        or o.bussec <> n.bussec
        or o.ver <> n.ver
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_clr_cl(
            credat -- 
            ,amt -- 
            ,ownref -- 
            ,trntyp -- 
            ,opndat -- 
            ,bchkeyinr -- 
            ,sta -- 
            ,srcinr -- 
            ,sndptyinr -- 
            ,ownusr -- 
            ,cur -- 
            ,smhinr -- 
            ,nam -- 
            ,selconfrm -- 
            ,errmsg -- 
            ,clsdat -- 
            ,inr -- 
            ,srctyp -- 
            ,selconref -- 
            ,bussec -- 
            ,ver -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_clr_op(
            credat -- 
            ,amt -- 
            ,ownref -- 
            ,trntyp -- 
            ,opndat -- 
            ,bchkeyinr -- 
            ,sta -- 
            ,srcinr -- 
            ,sndptyinr -- 
            ,ownusr -- 
            ,cur -- 
            ,smhinr -- 
            ,nam -- 
            ,selconfrm -- 
            ,errmsg -- 
            ,clsdat -- 
            ,inr -- 
            ,srctyp -- 
            ,selconref -- 
            ,bussec -- 
            ,ver -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.credat -- 
    ,o.amt -- 
    ,o.ownref -- 
    ,o.trntyp -- 
    ,o.opndat -- 
    ,o.bchkeyinr -- 
    ,o.sta -- 
    ,o.srcinr -- 
    ,o.sndptyinr -- 
    ,o.ownusr -- 
    ,o.cur -- 
    ,o.smhinr -- 
    ,o.nam -- 
    ,o.selconfrm -- 
    ,o.errmsg -- 
    ,o.clsdat -- 
    ,o.inr -- 
    ,o.srctyp -- 
    ,o.selconref -- 
    ,o.bussec -- 
    ,o.ver -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_clr_bk o
    left join ${iol_schema}.isbs_clr_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_clr_cl d
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
-- truncate table ${iol_schema}.isbs_clr;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_clr exchange partition p_19000101 with table ${iol_schema}.isbs_clr_cl;
alter table ${iol_schema}.isbs_clr exchange partition p_20991231 with table ${iol_schema}.isbs_clr_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_clr to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_clr_op purge;
drop table ${iol_schema}.isbs_clr_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_clr_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_clr',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
