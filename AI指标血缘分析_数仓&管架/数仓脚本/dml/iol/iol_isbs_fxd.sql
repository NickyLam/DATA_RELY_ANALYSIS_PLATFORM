/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_fxd
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
create table ${iol_schema}.isbs_fxd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_fxd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fxd_op purge;
drop table ${iol_schema}.isbs_fxd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fxd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fxd where 0=1;

create table ${iol_schema}.isbs_fxd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fxd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fxd_cl(
            posrtndat -- 
            ,ctycod -- 
            ,acc -- 
            ,apvnum -- 
            ,setdat -- 
            ,quoref -- 
            ,branchinr -- 
            ,bgnref -- 
            ,ver -- 
            ,midrat -- 
            ,ownref -- 
            ,dsp -- 
            ,zjtyp -- 
            ,inr -- 
            ,rat -- 
            ,clsdat -- 
            ,setdatfrm -- 
            ,txcod -- 
            ,bchkeyinr -- 
            ,nam -- 
            ,trnmod -- 
            ,usr -- 
            ,acc2 -- 
            ,trdout -- 
            ,setdatto -- 
            ,cnfdat -- 
            ,trnman -- 
            ,valdat -- 
            ,dsp2 -- 
            ,opndat -- 
            ,fudref -- 
            ,fxtyp -- 
            ,trdint -- 
            ,ownusr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fxd_op(
            posrtndat -- 
            ,ctycod -- 
            ,acc -- 
            ,apvnum -- 
            ,setdat -- 
            ,quoref -- 
            ,branchinr -- 
            ,bgnref -- 
            ,ver -- 
            ,midrat -- 
            ,ownref -- 
            ,dsp -- 
            ,zjtyp -- 
            ,inr -- 
            ,rat -- 
            ,clsdat -- 
            ,setdatfrm -- 
            ,txcod -- 
            ,bchkeyinr -- 
            ,nam -- 
            ,trnmod -- 
            ,usr -- 
            ,acc2 -- 
            ,trdout -- 
            ,setdatto -- 
            ,cnfdat -- 
            ,trnman -- 
            ,valdat -- 
            ,dsp2 -- 
            ,opndat -- 
            ,fudref -- 
            ,fxtyp -- 
            ,trdint -- 
            ,ownusr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.posrtndat, o.posrtndat) as posrtndat -- 
    ,nvl(n.ctycod, o.ctycod) as ctycod -- 
    ,nvl(n.acc, o.acc) as acc -- 
    ,nvl(n.apvnum, o.apvnum) as apvnum -- 
    ,nvl(n.setdat, o.setdat) as setdat -- 
    ,nvl(n.quoref, o.quoref) as quoref -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.bgnref, o.bgnref) as bgnref -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.midrat, o.midrat) as midrat -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.dsp, o.dsp) as dsp -- 
    ,nvl(n.zjtyp, o.zjtyp) as zjtyp -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.rat, o.rat) as rat -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.setdatfrm, o.setdatfrm) as setdatfrm -- 
    ,nvl(n.txcod, o.txcod) as txcod -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.trnmod, o.trnmod) as trnmod -- 
    ,nvl(n.usr, o.usr) as usr -- 
    ,nvl(n.acc2, o.acc2) as acc2 -- 
    ,nvl(n.trdout, o.trdout) as trdout -- 
    ,nvl(n.setdatto, o.setdatto) as setdatto -- 
    ,nvl(n.cnfdat, o.cnfdat) as cnfdat -- 
    ,nvl(n.trnman, o.trnman) as trnman -- 
    ,nvl(n.valdat, o.valdat) as valdat -- 
    ,nvl(n.dsp2, o.dsp2) as dsp2 -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.fudref, o.fudref) as fudref -- 
    ,nvl(n.fxtyp, o.fxtyp) as fxtyp -- 
    ,nvl(n.trdint, o.trdint) as trdint -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
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
from (select * from ${iol_schema}.isbs_fxd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_fxd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.posrtndat <> n.posrtndat
        or o.ctycod <> n.ctycod
        or o.acc <> n.acc
        or o.apvnum <> n.apvnum
        or o.setdat <> n.setdat
        or o.quoref <> n.quoref
        or o.branchinr <> n.branchinr
        or o.bgnref <> n.bgnref
        or o.ver <> n.ver
        or o.midrat <> n.midrat
        or o.ownref <> n.ownref
        or o.dsp <> n.dsp
        or o.zjtyp <> n.zjtyp
        or o.rat <> n.rat
        or o.clsdat <> n.clsdat
        or o.setdatfrm <> n.setdatfrm
        or o.txcod <> n.txcod
        or o.bchkeyinr <> n.bchkeyinr
        or o.nam <> n.nam
        or o.trnmod <> n.trnmod
        or o.usr <> n.usr
        or o.acc2 <> n.acc2
        or o.trdout <> n.trdout
        or o.setdatto <> n.setdatto
        or o.cnfdat <> n.cnfdat
        or o.trnman <> n.trnman
        or o.valdat <> n.valdat
        or o.dsp2 <> n.dsp2
        or o.opndat <> n.opndat
        or o.fudref <> n.fudref
        or o.fxtyp <> n.fxtyp
        or o.trdint <> n.trdint
        or o.ownusr <> n.ownusr
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fxd_cl(
            posrtndat -- 
            ,ctycod -- 
            ,acc -- 
            ,apvnum -- 
            ,setdat -- 
            ,quoref -- 
            ,branchinr -- 
            ,bgnref -- 
            ,ver -- 
            ,midrat -- 
            ,ownref -- 
            ,dsp -- 
            ,zjtyp -- 
            ,inr -- 
            ,rat -- 
            ,clsdat -- 
            ,setdatfrm -- 
            ,txcod -- 
            ,bchkeyinr -- 
            ,nam -- 
            ,trnmod -- 
            ,usr -- 
            ,acc2 -- 
            ,trdout -- 
            ,setdatto -- 
            ,cnfdat -- 
            ,trnman -- 
            ,valdat -- 
            ,dsp2 -- 
            ,opndat -- 
            ,fudref -- 
            ,fxtyp -- 
            ,trdint -- 
            ,ownusr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fxd_op(
            posrtndat -- 
            ,ctycod -- 
            ,acc -- 
            ,apvnum -- 
            ,setdat -- 
            ,quoref -- 
            ,branchinr -- 
            ,bgnref -- 
            ,ver -- 
            ,midrat -- 
            ,ownref -- 
            ,dsp -- 
            ,zjtyp -- 
            ,inr -- 
            ,rat -- 
            ,clsdat -- 
            ,setdatfrm -- 
            ,txcod -- 
            ,bchkeyinr -- 
            ,nam -- 
            ,trnmod -- 
            ,usr -- 
            ,acc2 -- 
            ,trdout -- 
            ,setdatto -- 
            ,cnfdat -- 
            ,trnman -- 
            ,valdat -- 
            ,dsp2 -- 
            ,opndat -- 
            ,fudref -- 
            ,fxtyp -- 
            ,trdint -- 
            ,ownusr -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.posrtndat -- 
    ,o.ctycod -- 
    ,o.acc -- 
    ,o.apvnum -- 
    ,o.setdat -- 
    ,o.quoref -- 
    ,o.branchinr -- 
    ,o.bgnref -- 
    ,o.ver -- 
    ,o.midrat -- 
    ,o.ownref -- 
    ,o.dsp -- 
    ,o.zjtyp -- 
    ,o.inr -- 
    ,o.rat -- 
    ,o.clsdat -- 
    ,o.setdatfrm -- 
    ,o.txcod -- 
    ,o.bchkeyinr -- 
    ,o.nam -- 
    ,o.trnmod -- 
    ,o.usr -- 
    ,o.acc2 -- 
    ,o.trdout -- 
    ,o.setdatto -- 
    ,o.cnfdat -- 
    ,o.trnman -- 
    ,o.valdat -- 
    ,o.dsp2 -- 
    ,o.opndat -- 
    ,o.fudref -- 
    ,o.fxtyp -- 
    ,o.trdint -- 
    ,o.ownusr -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_fxd_bk o
    left join ${iol_schema}.isbs_fxd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fxd_cl d
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
-- truncate table ${iol_schema}.isbs_fxd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_fxd exchange partition p_19000101 with table ${iol_schema}.isbs_fxd_cl;
alter table ${iol_schema}.isbs_fxd exchange partition p_20991231 with table ${iol_schema}.isbs_fxd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_fxd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fxd_op purge;
drop table ${iol_schema}.isbs_fxd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_fxd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_fxd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
