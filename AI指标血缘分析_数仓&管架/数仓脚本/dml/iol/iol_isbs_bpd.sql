/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bpd
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
create table ${iol_schema}.isbs_bpd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bpd;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bpd_op purge;
drop table ${iol_schema}.isbs_bpd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bpd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bpd where 0=1;

create table ${iol_schema}.isbs_bpd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bpd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bpd_cl(
            nam -- 
            ,sndflg -- 
            ,rskrat -- 
            ,fincod -- 
            ,intday -- 
            ,ownusr -- 
            ,pntnam -- 
            ,pctfin -- 
            ,actyld -- 
            ,fpdinr -- 
            ,fintyp -- 
            ,pntref1 -- 
            ,fianam -- 
            ,intrat -- 
            ,liaextid -- 
            ,syamt -- 
            ,punintrat -- 
            ,yjcur -- 
            ,intunt -- 
            ,finblk -- 
            ,pntinr -- 
            ,fidinr -- 
            ,pnttyp -- 
            ,credat -- 
            ,huanxiamt -- 
            ,fortyp -- 
            ,ovddat -- 
            ,feeamt -- 
            ,kuaday -- 
            ,ownref -- 
            ,opndat -- 
            ,othintamt -- 
            ,ywcur -- 
            ,sta -- 
            ,grarat -- 
            ,marrat -- 
            ,totamt -- 
            ,fogamt -- 
            ,telamt -- 
            ,tolrat -- 
            ,intirt -- 
            ,branchinr -- 
            ,benxiamt -- 
            ,lctyp -- 
            ,cheamt -- 
            ,bchkeyinr -- 
            ,feetyp -- 
            ,etyextkey -- 
            ,ver -- 
            ,finact -- 
            ,fhftyp -- 
            ,clsdat -- 
            ,pntref -- 
            ,inr -- 
            ,fiaref -- 
            ,rsktyp -- 
            ,ovdflg -- 
            ,matdat -- 
            ,intamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bpd_op(
            nam -- 
            ,sndflg -- 
            ,rskrat -- 
            ,fincod -- 
            ,intday -- 
            ,ownusr -- 
            ,pntnam -- 
            ,pctfin -- 
            ,actyld -- 
            ,fpdinr -- 
            ,fintyp -- 
            ,pntref1 -- 
            ,fianam -- 
            ,intrat -- 
            ,liaextid -- 
            ,syamt -- 
            ,punintrat -- 
            ,yjcur -- 
            ,intunt -- 
            ,finblk -- 
            ,pntinr -- 
            ,fidinr -- 
            ,pnttyp -- 
            ,credat -- 
            ,huanxiamt -- 
            ,fortyp -- 
            ,ovddat -- 
            ,feeamt -- 
            ,kuaday -- 
            ,ownref -- 
            ,opndat -- 
            ,othintamt -- 
            ,ywcur -- 
            ,sta -- 
            ,grarat -- 
            ,marrat -- 
            ,totamt -- 
            ,fogamt -- 
            ,telamt -- 
            ,tolrat -- 
            ,intirt -- 
            ,branchinr -- 
            ,benxiamt -- 
            ,lctyp -- 
            ,cheamt -- 
            ,bchkeyinr -- 
            ,feetyp -- 
            ,etyextkey -- 
            ,ver -- 
            ,finact -- 
            ,fhftyp -- 
            ,clsdat -- 
            ,pntref -- 
            ,inr -- 
            ,fiaref -- 
            ,rsktyp -- 
            ,ovdflg -- 
            ,matdat -- 
            ,intamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.sndflg, o.sndflg) as sndflg -- 
    ,nvl(n.rskrat, o.rskrat) as rskrat -- 
    ,nvl(n.fincod, o.fincod) as fincod -- 
    ,nvl(n.intday, o.intday) as intday -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.pntnam, o.pntnam) as pntnam -- 
    ,nvl(n.pctfin, o.pctfin) as pctfin -- 
    ,nvl(n.actyld, o.actyld) as actyld -- 
    ,nvl(n.fpdinr, o.fpdinr) as fpdinr -- 
    ,nvl(n.fintyp, o.fintyp) as fintyp -- 
    ,nvl(n.pntref1, o.pntref1) as pntref1 -- 
    ,nvl(n.fianam, o.fianam) as fianam -- 
    ,nvl(n.intrat, o.intrat) as intrat -- 
    ,nvl(n.liaextid, o.liaextid) as liaextid -- 
    ,nvl(n.syamt, o.syamt) as syamt -- 
    ,nvl(n.punintrat, o.punintrat) as punintrat -- 
    ,nvl(n.yjcur, o.yjcur) as yjcur -- 
    ,nvl(n.intunt, o.intunt) as intunt -- 
    ,nvl(n.finblk, o.finblk) as finblk -- 
    ,nvl(n.pntinr, o.pntinr) as pntinr -- 
    ,nvl(n.fidinr, o.fidinr) as fidinr -- 
    ,nvl(n.pnttyp, o.pnttyp) as pnttyp -- 
    ,nvl(n.credat, o.credat) as credat -- 
    ,nvl(n.huanxiamt, o.huanxiamt) as huanxiamt -- 
    ,nvl(n.fortyp, o.fortyp) as fortyp -- 
    ,nvl(n.ovddat, o.ovddat) as ovddat -- 
    ,nvl(n.feeamt, o.feeamt) as feeamt -- 
    ,nvl(n.kuaday, o.kuaday) as kuaday -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.othintamt, o.othintamt) as othintamt -- 
    ,nvl(n.ywcur, o.ywcur) as ywcur -- 
    ,nvl(n.sta, o.sta) as sta -- 
    ,nvl(n.grarat, o.grarat) as grarat -- 
    ,nvl(n.marrat, o.marrat) as marrat -- 
    ,nvl(n.totamt, o.totamt) as totamt -- 
    ,nvl(n.fogamt, o.fogamt) as fogamt -- 
    ,nvl(n.telamt, o.telamt) as telamt -- 
    ,nvl(n.tolrat, o.tolrat) as tolrat -- 
    ,nvl(n.intirt, o.intirt) as intirt -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.benxiamt, o.benxiamt) as benxiamt -- 
    ,nvl(n.lctyp, o.lctyp) as lctyp -- 
    ,nvl(n.cheamt, o.cheamt) as cheamt -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.feetyp, o.feetyp) as feetyp -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.finact, o.finact) as finact -- 
    ,nvl(n.fhftyp, o.fhftyp) as fhftyp -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.pntref, o.pntref) as pntref -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.fiaref, o.fiaref) as fiaref -- 
    ,nvl(n.rsktyp, o.rsktyp) as rsktyp -- 
    ,nvl(n.ovdflg, o.ovdflg) as ovdflg -- 
    ,nvl(n.matdat, o.matdat) as matdat -- 
    ,nvl(n.intamt, o.intamt) as intamt -- 
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
from (select * from ${iol_schema}.isbs_bpd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bpd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.nam <> n.nam
        or o.sndflg <> n.sndflg
        or o.rskrat <> n.rskrat
        or o.fincod <> n.fincod
        or o.intday <> n.intday
        or o.ownusr <> n.ownusr
        or o.pntnam <> n.pntnam
        or o.pctfin <> n.pctfin
        or o.actyld <> n.actyld
        or o.fpdinr <> n.fpdinr
        or o.fintyp <> n.fintyp
        or o.pntref1 <> n.pntref1
        or o.fianam <> n.fianam
        or o.intrat <> n.intrat
        or o.liaextid <> n.liaextid
        or o.syamt <> n.syamt
        or o.punintrat <> n.punintrat
        or o.yjcur <> n.yjcur
        or o.intunt <> n.intunt
        or o.finblk <> n.finblk
        or o.pntinr <> n.pntinr
        or o.fidinr <> n.fidinr
        or o.pnttyp <> n.pnttyp
        or o.credat <> n.credat
        or o.huanxiamt <> n.huanxiamt
        or o.fortyp <> n.fortyp
        or o.ovddat <> n.ovddat
        or o.feeamt <> n.feeamt
        or o.kuaday <> n.kuaday
        or o.ownref <> n.ownref
        or o.opndat <> n.opndat
        or o.othintamt <> n.othintamt
        or o.ywcur <> n.ywcur
        or o.sta <> n.sta
        or o.grarat <> n.grarat
        or o.marrat <> n.marrat
        or o.totamt <> n.totamt
        or o.fogamt <> n.fogamt
        or o.telamt <> n.telamt
        or o.tolrat <> n.tolrat
        or o.intirt <> n.intirt
        or o.branchinr <> n.branchinr
        or o.benxiamt <> n.benxiamt
        or o.lctyp <> n.lctyp
        or o.cheamt <> n.cheamt
        or o.bchkeyinr <> n.bchkeyinr
        or o.feetyp <> n.feetyp
        or o.etyextkey <> n.etyextkey
        or o.ver <> n.ver
        or o.finact <> n.finact
        or o.fhftyp <> n.fhftyp
        or o.clsdat <> n.clsdat
        or o.pntref <> n.pntref
        or o.fiaref <> n.fiaref
        or o.rsktyp <> n.rsktyp
        or o.ovdflg <> n.ovdflg
        or o.matdat <> n.matdat
        or o.intamt <> n.intamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bpd_cl(
            nam -- 
            ,sndflg -- 
            ,rskrat -- 
            ,fincod -- 
            ,intday -- 
            ,ownusr -- 
            ,pntnam -- 
            ,pctfin -- 
            ,actyld -- 
            ,fpdinr -- 
            ,fintyp -- 
            ,pntref1 -- 
            ,fianam -- 
            ,intrat -- 
            ,liaextid -- 
            ,syamt -- 
            ,punintrat -- 
            ,yjcur -- 
            ,intunt -- 
            ,finblk -- 
            ,pntinr -- 
            ,fidinr -- 
            ,pnttyp -- 
            ,credat -- 
            ,huanxiamt -- 
            ,fortyp -- 
            ,ovddat -- 
            ,feeamt -- 
            ,kuaday -- 
            ,ownref -- 
            ,opndat -- 
            ,othintamt -- 
            ,ywcur -- 
            ,sta -- 
            ,grarat -- 
            ,marrat -- 
            ,totamt -- 
            ,fogamt -- 
            ,telamt -- 
            ,tolrat -- 
            ,intirt -- 
            ,branchinr -- 
            ,benxiamt -- 
            ,lctyp -- 
            ,cheamt -- 
            ,bchkeyinr -- 
            ,feetyp -- 
            ,etyextkey -- 
            ,ver -- 
            ,finact -- 
            ,fhftyp -- 
            ,clsdat -- 
            ,pntref -- 
            ,inr -- 
            ,fiaref -- 
            ,rsktyp -- 
            ,ovdflg -- 
            ,matdat -- 
            ,intamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bpd_op(
            nam -- 
            ,sndflg -- 
            ,rskrat -- 
            ,fincod -- 
            ,intday -- 
            ,ownusr -- 
            ,pntnam -- 
            ,pctfin -- 
            ,actyld -- 
            ,fpdinr -- 
            ,fintyp -- 
            ,pntref1 -- 
            ,fianam -- 
            ,intrat -- 
            ,liaextid -- 
            ,syamt -- 
            ,punintrat -- 
            ,yjcur -- 
            ,intunt -- 
            ,finblk -- 
            ,pntinr -- 
            ,fidinr -- 
            ,pnttyp -- 
            ,credat -- 
            ,huanxiamt -- 
            ,fortyp -- 
            ,ovddat -- 
            ,feeamt -- 
            ,kuaday -- 
            ,ownref -- 
            ,opndat -- 
            ,othintamt -- 
            ,ywcur -- 
            ,sta -- 
            ,grarat -- 
            ,marrat -- 
            ,totamt -- 
            ,fogamt -- 
            ,telamt -- 
            ,tolrat -- 
            ,intirt -- 
            ,branchinr -- 
            ,benxiamt -- 
            ,lctyp -- 
            ,cheamt -- 
            ,bchkeyinr -- 
            ,feetyp -- 
            ,etyextkey -- 
            ,ver -- 
            ,finact -- 
            ,fhftyp -- 
            ,clsdat -- 
            ,pntref -- 
            ,inr -- 
            ,fiaref -- 
            ,rsktyp -- 
            ,ovdflg -- 
            ,matdat -- 
            ,intamt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.nam -- 
    ,o.sndflg -- 
    ,o.rskrat -- 
    ,o.fincod -- 
    ,o.intday -- 
    ,o.ownusr -- 
    ,o.pntnam -- 
    ,o.pctfin -- 
    ,o.actyld -- 
    ,o.fpdinr -- 
    ,o.fintyp -- 
    ,o.pntref1 -- 
    ,o.fianam -- 
    ,o.intrat -- 
    ,o.liaextid -- 
    ,o.syamt -- 
    ,o.punintrat -- 
    ,o.yjcur -- 
    ,o.intunt -- 
    ,o.finblk -- 
    ,o.pntinr -- 
    ,o.fidinr -- 
    ,o.pnttyp -- 
    ,o.credat -- 
    ,o.huanxiamt -- 
    ,o.fortyp -- 
    ,o.ovddat -- 
    ,o.feeamt -- 
    ,o.kuaday -- 
    ,o.ownref -- 
    ,o.opndat -- 
    ,o.othintamt -- 
    ,o.ywcur -- 
    ,o.sta -- 
    ,o.grarat -- 
    ,o.marrat -- 
    ,o.totamt -- 
    ,o.fogamt -- 
    ,o.telamt -- 
    ,o.tolrat -- 
    ,o.intirt -- 
    ,o.branchinr -- 
    ,o.benxiamt -- 
    ,o.lctyp -- 
    ,o.cheamt -- 
    ,o.bchkeyinr -- 
    ,o.feetyp -- 
    ,o.etyextkey -- 
    ,o.ver -- 
    ,o.finact -- 
    ,o.fhftyp -- 
    ,o.clsdat -- 
    ,o.pntref -- 
    ,o.inr -- 
    ,o.fiaref -- 
    ,o.rsktyp -- 
    ,o.ovdflg -- 
    ,o.matdat -- 
    ,o.intamt -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bpd_bk o
    left join ${iol_schema}.isbs_bpd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bpd_cl d
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
-- truncate table ${iol_schema}.isbs_bpd;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bpd exchange partition p_19000101 with table ${iol_schema}.isbs_bpd_cl;
alter table ${iol_schema}.isbs_bpd exchange partition p_20991231 with table ${iol_schema}.isbs_bpd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bpd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bpd_op purge;
drop table ${iol_schema}.isbs_bpd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bpd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bpd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
