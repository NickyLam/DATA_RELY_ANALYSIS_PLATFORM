/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_ore
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
create table ${iol_schema}.isbs_ore_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_ore;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ore_op purge;
drop table ${iol_schema}.isbs_ore_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_ore_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ore where 0=1;

create table ${iol_schema}.isbs_ore_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_ore where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ore_cl(
            objtyp -- 
            ,ordinr -- 
            ,waidur -- 
            ,enddattim -- 
            ,begdattim -- 
            ,frm -- 
            ,typ -- 
            ,bchkeyinr -- 
            ,objinr -- 
            ,etyextkey -- 
            ,usr -- 
            ,prcdur -- 
            ,ssninr -- 
            ,routxt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ore_op(
            objtyp -- 
            ,ordinr -- 
            ,waidur -- 
            ,enddattim -- 
            ,begdattim -- 
            ,frm -- 
            ,typ -- 
            ,bchkeyinr -- 
            ,objinr -- 
            ,etyextkey -- 
            ,usr -- 
            ,prcdur -- 
            ,ssninr -- 
            ,routxt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.objtyp, o.objtyp) as objtyp -- 
    ,nvl(n.ordinr, o.ordinr) as ordinr -- 
    ,nvl(n.waidur, o.waidur) as waidur -- 
    ,nvl(n.enddattim, o.enddattim) as enddattim -- 
    ,nvl(n.begdattim, o.begdattim) as begdattim -- 
    ,nvl(n.frm, o.frm) as frm -- 
    ,nvl(n.typ, o.typ) as typ -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.objinr, o.objinr) as objinr -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.usr, o.usr) as usr -- 
    ,nvl(n.prcdur, o.prcdur) as prcdur -- 
    ,nvl(n.ssninr, o.ssninr) as ssninr -- 
    ,nvl(n.routxt, o.routxt) as routxt -- 
    ,case when
            n.ordinr is null
            and n.waidur is null
            and n.begdattim is null
            and n.prcdur is null
            and n.ssninr is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.ordinr is null
            and n.waidur is null
            and n.begdattim is null
            and n.prcdur is null
            and n.ssninr is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.ordinr is null
            and n.waidur is null
            and n.begdattim is null
            and n.prcdur is null
            and n.ssninr is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.isbs_ore_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_ore where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.ordinr = n.ordinr
            and o.waidur = n.waidur
            and o.begdattim = n.begdattim
            and o.prcdur = n.prcdur
            and o.ssninr = n.ssninr
where (
        o.ordinr is null
        and o.waidur is null
        and o.begdattim is null
        and o.prcdur is null
        and o.ssninr is null
    )
    or (
        n.ordinr is null
        and n.waidur is null
        and n.begdattim is null
        and n.prcdur is null
        and n.ssninr is null
    )
    or (
        o.objtyp <> n.objtyp
        or o.enddattim <> n.enddattim
        or o.frm <> n.frm
        or o.typ <> n.typ
        or o.bchkeyinr <> n.bchkeyinr
        or o.objinr <> n.objinr
        or o.etyextkey <> n.etyextkey
        or o.usr <> n.usr
        or o.routxt <> n.routxt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_ore_cl(
            objtyp -- 
            ,ordinr -- 
            ,waidur -- 
            ,enddattim -- 
            ,begdattim -- 
            ,frm -- 
            ,typ -- 
            ,bchkeyinr -- 
            ,objinr -- 
            ,etyextkey -- 
            ,usr -- 
            ,prcdur -- 
            ,ssninr -- 
            ,routxt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_ore_op(
            objtyp -- 
            ,ordinr -- 
            ,waidur -- 
            ,enddattim -- 
            ,begdattim -- 
            ,frm -- 
            ,typ -- 
            ,bchkeyinr -- 
            ,objinr -- 
            ,etyextkey -- 
            ,usr -- 
            ,prcdur -- 
            ,ssninr -- 
            ,routxt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.objtyp -- 
    ,o.ordinr -- 
    ,o.waidur -- 
    ,o.enddattim -- 
    ,o.begdattim -- 
    ,o.frm -- 
    ,o.typ -- 
    ,o.bchkeyinr -- 
    ,o.objinr -- 
    ,o.etyextkey -- 
    ,o.usr -- 
    ,o.prcdur -- 
    ,o.ssninr -- 
    ,o.routxt -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_ore_bk o
    left join ${iol_schema}.isbs_ore_op n
        on
            o.ordinr = n.ordinr
            and o.waidur = n.waidur
            and o.begdattim = n.begdattim
            and o.prcdur = n.prcdur
            and o.ssninr = n.ssninr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_ore_cl d
        on
            o.ordinr = d.ordinr
            and o.waidur = d.waidur
            and o.begdattim = d.begdattim
            and o.prcdur = d.prcdur
            and o.ssninr = d.ssninr
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.isbs_ore;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_ore exchange partition p_19000101 with table ${iol_schema}.isbs_ore_cl;
alter table ${iol_schema}.isbs_ore exchange partition p_20991231 with table ${iol_schema}.isbs_ore_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_ore to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_ore_op purge;
drop table ${iol_schema}.isbs_ore_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_ore_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_ore',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
