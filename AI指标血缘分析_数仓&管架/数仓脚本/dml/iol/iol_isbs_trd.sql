/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_trd
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
create table ${iol_schema}.isbs_trd_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_trd
where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >=to_date('${batch_date}','yyyymmdd');

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_trd_op purge;
drop table ${iol_schema}.isbs_trd_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_trd_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_trd where 0=1;

create table ${iol_schema}.isbs_trd_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_trd where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_trd_cl(
            grarat -- 
            ,ovddat -- 
            ,pntref -- 
            ,spddat -- 
            ,pctfin -- 
            ,nam -- 
            ,ownref -- 
            ,pntnam -- 
            ,finact -- 
            ,intrat -- 
            ,inr -- 
            ,delflg -- 
            ,actyld -- 
            ,ownusr -- 
            ,fintyp -- 
            ,ver -- 
            ,pnttyp -- 
            ,stagod -- 
            ,lstintdat -- 
            ,stacty -- 
            ,clsdat -- 
            ,feetyp -- 
            ,issdat -- 
            ,restcur -- 
            ,actrat -- 
            ,credat -- 
            ,feeamt -- 
            ,itfblk -- 
            ,matdat -- 
            ,opndat -- 
            ,finblk -- 
            ,etyextkey -- 
            ,dftype -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,guaflg -- 
            ,dfrate -- 
            ,restamt -- 
            ,pntinr -- 
            ,tenday -- 
            ,stttendat -- 
            ,marrat -- 
            ,irtcod -- 
            ,extnmb -- 
            ,ovdflg -- 
            ,actfinday -- 
            ,fincod -- 
            ,subtyp -- 
            ,intsetway -- 
            ,ratadj -- 
            ,totalamt -- 
            ,acthkdat -- 
            ,dfint -- 
            ,dfdelrate -- 
            ,dffee -- 
            ,iflastcol -- 
            ,irtmic -- 
            ,hangno -- 
            ,fkqrref -- 
            ,conno -- 
            ,jjpph -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_trd_op(
            grarat -- 
            ,ovddat -- 
            ,pntref -- 
            ,spddat -- 
            ,pctfin -- 
            ,nam -- 
            ,ownref -- 
            ,pntnam -- 
            ,finact -- 
            ,intrat -- 
            ,inr -- 
            ,delflg -- 
            ,actyld -- 
            ,ownusr -- 
            ,fintyp -- 
            ,ver -- 
            ,pnttyp -- 
            ,stagod -- 
            ,lstintdat -- 
            ,stacty -- 
            ,clsdat -- 
            ,feetyp -- 
            ,issdat -- 
            ,restcur -- 
            ,actrat -- 
            ,credat -- 
            ,feeamt -- 
            ,itfblk -- 
            ,matdat -- 
            ,opndat -- 
            ,finblk -- 
            ,etyextkey -- 
            ,dftype -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,guaflg -- 
            ,dfrate -- 
            ,restamt -- 
            ,pntinr -- 
            ,tenday -- 
            ,stttendat -- 
            ,marrat -- 
            ,irtcod -- 
            ,extnmb -- 
            ,ovdflg -- 
            ,actfinday -- 
            ,fincod -- 
            ,subtyp -- 
            ,intsetway -- 
            ,ratadj -- 
            ,totalamt -- 
            ,acthkdat -- 
            ,dfint -- 
            ,dfdelrate -- 
            ,dffee -- 
            ,iflastcol -- 
            ,irtmic -- 
            ,hangno -- 
            ,fkqrref -- 
            ,conno -- 
            ,jjpph -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.grarat, o.grarat) as grarat -- 
    ,nvl(n.ovddat, o.ovddat) as ovddat -- 
    ,nvl(n.pntref, o.pntref) as pntref -- 
    ,nvl(n.spddat, o.spddat) as spddat -- 
    ,nvl(n.pctfin, o.pctfin) as pctfin -- 
    ,nvl(n.nam, o.nam) as nam -- 
    ,nvl(n.ownref, o.ownref) as ownref -- 
    ,nvl(n.pntnam, o.pntnam) as pntnam -- 
    ,nvl(n.finact, o.finact) as finact -- 
    ,nvl(n.intrat, o.intrat) as intrat -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.delflg, o.delflg) as delflg -- 
    ,nvl(n.actyld, o.actyld) as actyld -- 
    ,nvl(n.ownusr, o.ownusr) as ownusr -- 
    ,nvl(n.fintyp, o.fintyp) as fintyp -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.pnttyp, o.pnttyp) as pnttyp -- 
    ,nvl(n.stagod, o.stagod) as stagod -- 
    ,nvl(n.lstintdat, o.lstintdat) as lstintdat -- 
    ,nvl(n.stacty, o.stacty) as stacty -- 
    ,nvl(n.clsdat, o.clsdat) as clsdat -- 
    ,nvl(n.feetyp, o.feetyp) as feetyp -- 
    ,nvl(n.issdat, o.issdat) as issdat -- 
    ,nvl(n.restcur, o.restcur) as restcur -- 
    ,nvl(n.actrat, o.actrat) as actrat -- 
    ,nvl(n.credat, o.credat) as credat -- 
    ,nvl(n.feeamt, o.feeamt) as feeamt -- 
    ,nvl(n.itfblk, o.itfblk) as itfblk -- 
    ,nvl(n.matdat, o.matdat) as matdat -- 
    ,nvl(n.opndat, o.opndat) as opndat -- 
    ,nvl(n.finblk, o.finblk) as finblk -- 
    ,nvl(n.etyextkey, o.etyextkey) as etyextkey -- 
    ,nvl(n.dftype, o.dftype) as dftype -- 
    ,nvl(n.bchkeyinr, o.bchkeyinr) as bchkeyinr -- 
    ,nvl(n.branchinr, o.branchinr) as branchinr -- 
    ,nvl(n.guaflg, o.guaflg) as guaflg -- 
    ,nvl(n.dfrate, o.dfrate) as dfrate -- 
    ,nvl(n.restamt, o.restamt) as restamt -- 
    ,nvl(n.pntinr, o.pntinr) as pntinr -- 
    ,nvl(n.tenday, o.tenday) as tenday -- 
    ,nvl(n.stttendat, o.stttendat) as stttendat -- 
    ,nvl(n.marrat, o.marrat) as marrat -- 
    ,nvl(n.irtcod, o.irtcod) as irtcod -- 
    ,nvl(n.extnmb, o.extnmb) as extnmb -- 
    ,nvl(n.ovdflg, o.ovdflg) as ovdflg -- 
    ,nvl(n.actfinday, o.actfinday) as actfinday -- 
    ,nvl(n.fincod, o.fincod) as fincod -- 
    ,nvl(n.subtyp, o.subtyp) as subtyp -- 
    ,nvl(n.intsetway, o.intsetway) as intsetway -- 
    ,nvl(n.ratadj, o.ratadj) as ratadj -- 
    ,nvl(n.totalamt, o.totalamt) as totalamt -- 
    ,nvl(n.acthkdat, o.acthkdat) as acthkdat -- 
    ,nvl(n.dfint, o.dfint) as dfint -- 
    ,nvl(n.dfdelrate, o.dfdelrate) as dfdelrate -- 
    ,nvl(n.dffee, o.dffee) as dffee -- 
    ,nvl(n.iflastcol, o.iflastcol) as iflastcol -- 
    ,nvl(n.irtmic, o.irtmic) as irtmic -- 
    ,nvl(n.hangno, o.hangno) as hangno -- 
    ,nvl(n.fkqrref, o.fkqrref) as fkqrref -- 
    ,nvl(n.conno, o.conno) as conno -- 
    ,nvl(n.jjpph, o.jjpph) as jjpph -- 
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
from (select * from ${iol_schema}.isbs_trd_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_trd where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.grarat <> n.grarat
        or o.ovddat <> n.ovddat
        or o.pntref <> n.pntref
        or o.spddat <> n.spddat
        or o.pctfin <> n.pctfin
        or o.nam <> n.nam
        or o.ownref <> n.ownref
        or o.pntnam <> n.pntnam
        or o.finact <> n.finact
        or o.intrat <> n.intrat
        or o.delflg <> n.delflg
        or o.actyld <> n.actyld
        or o.ownusr <> n.ownusr
        or o.fintyp <> n.fintyp
        or o.ver <> n.ver
        or o.pnttyp <> n.pnttyp
        or o.stagod <> n.stagod
        or o.lstintdat <> n.lstintdat
        or o.stacty <> n.stacty
        or o.clsdat <> n.clsdat
        or o.feetyp <> n.feetyp
        or o.issdat <> n.issdat
        or o.restcur <> n.restcur
        or o.actrat <> n.actrat
        or o.credat <> n.credat
        or o.feeamt <> n.feeamt
        or o.itfblk <> n.itfblk
        or o.matdat <> n.matdat
        or o.opndat <> n.opndat
        or o.finblk <> n.finblk
        or o.etyextkey <> n.etyextkey
        or o.dftype <> n.dftype
        or o.bchkeyinr <> n.bchkeyinr
        or o.branchinr <> n.branchinr
        or o.guaflg <> n.guaflg
        or o.dfrate <> n.dfrate
        or o.restamt <> n.restamt
        or o.pntinr <> n.pntinr
        or o.tenday <> n.tenday
        or o.stttendat <> n.stttendat
        or o.marrat <> n.marrat
        or o.irtcod <> n.irtcod
        or o.extnmb <> n.extnmb
        or o.ovdflg <> n.ovdflg
        or o.actfinday <> n.actfinday
        or o.fincod <> n.fincod
        or o.subtyp <> n.subtyp
        or o.intsetway <> n.intsetway
        or o.ratadj <> n.ratadj
        or o.totalamt <> n.totalamt
        or o.acthkdat <> n.acthkdat
        or o.dfint <> n.dfint
        or o.dfdelrate <> n.dfdelrate
        or o.dffee <> n.dffee
        or o.iflastcol <> n.iflastcol
        or o.irtmic <> n.irtmic
        or o.hangno <> n.hangno
        or o.fkqrref <> n.fkqrref
        or o.conno <> n.conno
        or o.jjpph <> n.jjpph
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_trd_cl(
            grarat -- 
            ,ovddat -- 
            ,pntref -- 
            ,spddat -- 
            ,pctfin -- 
            ,nam -- 
            ,ownref -- 
            ,pntnam -- 
            ,finact -- 
            ,intrat -- 
            ,inr -- 
            ,delflg -- 
            ,actyld -- 
            ,ownusr -- 
            ,fintyp -- 
            ,ver -- 
            ,pnttyp -- 
            ,stagod -- 
            ,lstintdat -- 
            ,stacty -- 
            ,clsdat -- 
            ,feetyp -- 
            ,issdat -- 
            ,restcur -- 
            ,actrat -- 
            ,credat -- 
            ,feeamt -- 
            ,itfblk -- 
            ,matdat -- 
            ,opndat -- 
            ,finblk -- 
            ,etyextkey -- 
            ,dftype -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,guaflg -- 
            ,dfrate -- 
            ,restamt -- 
            ,pntinr -- 
            ,tenday -- 
            ,stttendat -- 
            ,marrat -- 
            ,irtcod -- 
            ,extnmb -- 
            ,ovdflg -- 
            ,actfinday -- 
            ,fincod -- 
            ,subtyp -- 
            ,intsetway -- 
            ,ratadj -- 
            ,totalamt -- 
            ,acthkdat -- 
            ,dfint -- 
            ,dfdelrate -- 
            ,dffee -- 
            ,iflastcol -- 
            ,irtmic -- 
            ,hangno -- 
            ,fkqrref -- 
            ,conno -- 
            ,jjpph -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_trd_op(
            grarat -- 
            ,ovddat -- 
            ,pntref -- 
            ,spddat -- 
            ,pctfin -- 
            ,nam -- 
            ,ownref -- 
            ,pntnam -- 
            ,finact -- 
            ,intrat -- 
            ,inr -- 
            ,delflg -- 
            ,actyld -- 
            ,ownusr -- 
            ,fintyp -- 
            ,ver -- 
            ,pnttyp -- 
            ,stagod -- 
            ,lstintdat -- 
            ,stacty -- 
            ,clsdat -- 
            ,feetyp -- 
            ,issdat -- 
            ,restcur -- 
            ,actrat -- 
            ,credat -- 
            ,feeamt -- 
            ,itfblk -- 
            ,matdat -- 
            ,opndat -- 
            ,finblk -- 
            ,etyextkey -- 
            ,dftype -- 
            ,bchkeyinr -- 
            ,branchinr -- 
            ,guaflg -- 
            ,dfrate -- 
            ,restamt -- 
            ,pntinr -- 
            ,tenday -- 
            ,stttendat -- 
            ,marrat -- 
            ,irtcod -- 
            ,extnmb -- 
            ,ovdflg -- 
            ,actfinday -- 
            ,fincod -- 
            ,subtyp -- 
            ,intsetway -- 
            ,ratadj -- 
            ,totalamt -- 
            ,acthkdat -- 
            ,dfint -- 
            ,dfdelrate -- 
            ,dffee -- 
            ,iflastcol -- 
            ,irtmic -- 
            ,hangno -- 
            ,fkqrref -- 
            ,conno -- 
            ,jjpph -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.grarat -- 
    ,o.ovddat -- 
    ,o.pntref -- 
    ,o.spddat -- 
    ,o.pctfin -- 
    ,o.nam -- 
    ,o.ownref -- 
    ,o.pntnam -- 
    ,o.finact -- 
    ,o.intrat -- 
    ,o.inr -- 
    ,o.delflg -- 
    ,o.actyld -- 
    ,o.ownusr -- 
    ,o.fintyp -- 
    ,o.ver -- 
    ,o.pnttyp -- 
    ,o.stagod -- 
    ,o.lstintdat -- 
    ,o.stacty -- 
    ,o.clsdat -- 
    ,o.feetyp -- 
    ,o.issdat -- 
    ,o.restcur -- 
    ,o.actrat -- 
    ,o.credat -- 
    ,o.feeamt -- 
    ,o.itfblk -- 
    ,o.matdat -- 
    ,o.opndat -- 
    ,o.finblk -- 
    ,o.etyextkey -- 
    ,o.dftype -- 
    ,o.bchkeyinr -- 
    ,o.branchinr -- 
    ,o.guaflg -- 
    ,o.dfrate -- 
    ,o.restamt -- 
    ,o.pntinr -- 
    ,o.tenday -- 
    ,o.stttendat -- 
    ,o.marrat -- 
    ,o.irtcod -- 
    ,o.extnmb -- 
    ,o.ovdflg -- 
    ,o.actfinday -- 
    ,o.fincod -- 
    ,o.subtyp -- 
    ,o.intsetway -- 
    ,o.ratadj -- 
    ,o.totalamt -- 
    ,o.acthkdat -- 
    ,o.dfint -- 
    ,o.dfdelrate -- 
    ,o.dffee -- 
    ,o.iflastcol -- 
    ,o.irtmic -- 
    ,o.hangno -- 
    ,o.fkqrref -- 
    ,o.conno -- 
    ,o.jjpph -- 
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
from ${iol_schema}.isbs_trd_bk o
    left join ${iol_schema}.isbs_trd_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_trd_cl d
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
--truncate table ${iol_schema}.isbs_trd;

-- 4.2 rebuild partition
declare
v_sql varchar2(100);
begin
for cur in (select partition_name from all_tab_partitions where table_owner=upper('${iol_schema}') and table_name=upper('isbs_trd') and substr(partition_name,3) >= '${batch_date}' and substr(partition_name,3) < '20991231') loop
    v_sql := 'alter table ${iol_schema}.isbs_trd drop partition ' || cur.partition_name;
    dbms_output.put_line(v_sql);
    execute immediate v_sql;
end loop;
end;
/
alter table ${iol_schema}.isbs_trd add partition p_${batch_date} values(to_date('${batch_date}','YYYYMMDD'));

-- 4.3 exchange partition
alter table ${iol_schema}.isbs_trd exchange partition p_${batch_date} with table ${iol_schema}.isbs_trd_cl;
alter table ${iol_schema}.isbs_trd exchange partition p_20991231 with table ${iol_schema}.isbs_trd_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_trd to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_trd_op purge;
drop table ${iol_schema}.isbs_trd_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_trd_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_trd',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
