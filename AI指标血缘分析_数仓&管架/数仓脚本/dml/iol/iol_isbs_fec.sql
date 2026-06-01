/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_fec
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
create table ${iol_schema}.isbs_fec_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_fec;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fec_op purge;
drop table ${iol_schema}.isbs_fec_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_fec_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fec where 0=1;

create table ${iol_schema}.isbs_fec_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_fec where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fec_cl(
            setflg -- 
            ,enddat -- 
            ,ratcur -- 
            ,tirtyp -- 
            ,objtyp -- 
            ,clcdifflg -- 
            ,settyp -- 
            ,pertypprv -- 
            ,permintr3 -- 
            ,ver -- 
            ,perrattr4 -- 
            ,mincur -- 
            ,perrattr6 -- 
            ,permin -- 
            ,permaxtr3 -- 
            ,perrattr7 -- 
            ,minfcc -- 
            ,amtsetall -- 
            ,amtbegtr2 -- 
            ,permaxtr6 -- 
            ,perrattr2 -- 
            ,amtrattr3 -- 
            ,permintr4 -- 
            ,setend -- 
            ,perbegtr5 -- 
            ,perbegtr4 -- 
            ,ratcal -- 
            ,minamttot -- 
            ,setperflg -- 
            ,perbegtr3 -- 
            ,begdat -- 
            ,untamt -- 
            ,permaxtr2 -- 
            ,amtrattr2 -- 
            ,ratfcc -- 
            ,higamt -- 
            ,perrattr5 -- 
            ,feepri -- 
            ,lowamt -- 
            ,permintr5 -- 
            ,maxfcc -- 
            ,maxpercnt -- 
            ,permintr2 -- 
            ,perbegtr2 -- 
            ,setmod -- 
            ,colltr -- 
            ,ratirs -- 
            ,calfcc -- 
            ,permaxtr4 -- 
            ,calcbs -- 
            ,setchgflg -- 
            ,inr -- 
            ,objinr -- 
            ,basamt -- 
            ,minamt -- 
            ,feeinr -- 
            ,amtbegtr3 -- 
            ,maxcur -- 
            ,amtbegtr4 -- 
            ,pertyp -- 
            ,permintr6 -- 
            ,permintr7 -- 
            ,perrattr3 -- 
            ,maxpercov -- 
            ,perbegtr7 -- 
            ,setbeg -- 
            ,ratirsinc -- 
            ,calrul -- 
            ,perbegtr6 -- 
            ,permaxtr5 -- 
            ,amtrattr4 -- 
            ,permaxtr7 -- 
            ,maxamt -- 
            ,etgextkey -- 
            ,minpercnt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fec_op(
            setflg -- 
            ,enddat -- 
            ,ratcur -- 
            ,tirtyp -- 
            ,objtyp -- 
            ,clcdifflg -- 
            ,settyp -- 
            ,pertypprv -- 
            ,permintr3 -- 
            ,ver -- 
            ,perrattr4 -- 
            ,mincur -- 
            ,perrattr6 -- 
            ,permin -- 
            ,permaxtr3 -- 
            ,perrattr7 -- 
            ,minfcc -- 
            ,amtsetall -- 
            ,amtbegtr2 -- 
            ,permaxtr6 -- 
            ,perrattr2 -- 
            ,amtrattr3 -- 
            ,permintr4 -- 
            ,setend -- 
            ,perbegtr5 -- 
            ,perbegtr4 -- 
            ,ratcal -- 
            ,minamttot -- 
            ,setperflg -- 
            ,perbegtr3 -- 
            ,begdat -- 
            ,untamt -- 
            ,permaxtr2 -- 
            ,amtrattr2 -- 
            ,ratfcc -- 
            ,higamt -- 
            ,perrattr5 -- 
            ,feepri -- 
            ,lowamt -- 
            ,permintr5 -- 
            ,maxfcc -- 
            ,maxpercnt -- 
            ,permintr2 -- 
            ,perbegtr2 -- 
            ,setmod -- 
            ,colltr -- 
            ,ratirs -- 
            ,calfcc -- 
            ,permaxtr4 -- 
            ,calcbs -- 
            ,setchgflg -- 
            ,inr -- 
            ,objinr -- 
            ,basamt -- 
            ,minamt -- 
            ,feeinr -- 
            ,amtbegtr3 -- 
            ,maxcur -- 
            ,amtbegtr4 -- 
            ,pertyp -- 
            ,permintr6 -- 
            ,permintr7 -- 
            ,perrattr3 -- 
            ,maxpercov -- 
            ,perbegtr7 -- 
            ,setbeg -- 
            ,ratirsinc -- 
            ,calrul -- 
            ,perbegtr6 -- 
            ,permaxtr5 -- 
            ,amtrattr4 -- 
            ,permaxtr7 -- 
            ,maxamt -- 
            ,etgextkey -- 
            ,minpercnt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.setflg, o.setflg) as setflg -- 
    ,nvl(n.enddat, o.enddat) as enddat -- 
    ,nvl(n.ratcur, o.ratcur) as ratcur -- 
    ,nvl(n.tirtyp, o.tirtyp) as tirtyp -- 
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 
    ,nvl(n.clcdifflg, o.clcdifflg) as clcdifflg -- 
    ,nvl(n.settyp, o.settyp) as settyp -- 
    ,nvl(n.pertypprv, o.pertypprv) as pertypprv -- 
    ,nvl(n.permintr3, o.permintr3) as permintr3 -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.perrattr4, o.perrattr4) as perrattr4 -- 
    ,nvl(n.mincur, o.mincur) as mincur -- 
    ,nvl(n.perrattr6, o.perrattr6) as perrattr6 -- 
    ,nvl(n.permin, o.permin) as permin -- 
    ,nvl(n.permaxtr3, o.permaxtr3) as permaxtr3 -- 
    ,nvl(n.perrattr7, o.perrattr7) as perrattr7 -- 
    ,nvl(n.minfcc, o.minfcc) as minfcc -- 
    ,nvl(n.amtsetall, o.amtsetall) as amtsetall -- 
    ,nvl(n.amtbegtr2, o.amtbegtr2) as amtbegtr2 -- 
    ,nvl(n.permaxtr6, o.permaxtr6) as permaxtr6 -- 
    ,nvl(n.perrattr2, o.perrattr2) as perrattr2 -- 
    ,nvl(n.amtrattr3, o.amtrattr3) as amtrattr3 -- 
    ,nvl(n.permintr4, o.permintr4) as permintr4 -- 
    ,nvl(n.setend, o.setend) as setend -- 
    ,nvl(n.perbegtr5, o.perbegtr5) as perbegtr5 -- 
    ,nvl(n.perbegtr4, o.perbegtr4) as perbegtr4 -- 
    ,nvl(n.ratcal, o.ratcal) as ratcal -- 
    ,nvl(n.minamttot, o.minamttot) as minamttot -- 
    ,nvl(n.setperflg, o.setperflg) as setperflg -- 
    ,nvl(n.perbegtr3, o.perbegtr3) as perbegtr3 -- 
    ,nvl(n.begdat, o.begdat) as begdat -- 
    ,nvl(n.untamt, o.untamt) as untamt -- 
    ,nvl(n.permaxtr2, o.permaxtr2) as permaxtr2 -- 
    ,nvl(n.amtrattr2, o.amtrattr2) as amtrattr2 -- 
    ,nvl(n.ratfcc, o.ratfcc) as ratfcc -- 
    ,nvl(n.higamt, o.higamt) as higamt -- 
    ,nvl(n.perrattr5, o.perrattr5) as perrattr5 -- 
    ,nvl(n.feepri, o.feepri) as feepri -- 
    ,nvl(n.lowamt, o.lowamt) as lowamt -- 
    ,nvl(n.permintr5, o.permintr5) as permintr5 -- 
    ,nvl(n.maxfcc, o.maxfcc) as maxfcc -- 
    ,nvl(n.maxpercnt, o.maxpercnt) as maxpercnt -- 
    ,nvl(n.permintr2, o.permintr2) as permintr2 -- 
    ,nvl(n.perbegtr2, o.perbegtr2) as perbegtr2 -- 
    ,nvl(n.setmod, o.setmod) as setmod -- 
    ,nvl(n.colltr, o.colltr) as colltr -- 
    ,nvl(n.ratirs, o.ratirs) as ratirs -- 
    ,nvl(n.calfcc, o.calfcc) as calfcc -- 
    ,nvl(n.permaxtr4, o.permaxtr4) as permaxtr4 -- 
    ,nvl(n.calcbs, o.calcbs) as calcbs -- 
    ,nvl(n.setchgflg, o.setchgflg) as setchgflg -- 
    ,nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.objinr, o.objinr) as objinr -- 
    ,nvl(n.basamt, o.basamt) as basamt -- 
    ,nvl(n.minamt, o.minamt) as minamt -- 
    ,nvl(n.feeinr, o.feeinr) as feeinr -- 
    ,nvl(n.amtbegtr3, o.amtbegtr3) as amtbegtr3 -- 
    ,nvl(n.maxcur, o.maxcur) as maxcur -- 
    ,nvl(n.amtbegtr4, o.amtbegtr4) as amtbegtr4 -- 
    ,nvl(n.pertyp, o.pertyp) as pertyp -- 
    ,nvl(n.permintr6, o.permintr6) as permintr6 -- 
    ,nvl(n.permintr7, o.permintr7) as permintr7 -- 
    ,nvl(n.perrattr3, o.perrattr3) as perrattr3 -- 
    ,nvl(n.maxpercov, o.maxpercov) as maxpercov -- 
    ,nvl(n.perbegtr7, o.perbegtr7) as perbegtr7 -- 
    ,nvl(n.setbeg, o.setbeg) as setbeg -- 
    ,nvl(n.ratirsinc, o.ratirsinc) as ratirsinc -- 
    ,nvl(n.calrul, o.calrul) as calrul -- 
    ,nvl(n.perbegtr6, o.perbegtr6) as perbegtr6 -- 
    ,nvl(n.permaxtr5, o.permaxtr5) as permaxtr5 -- 
    ,nvl(n.amtrattr4, o.amtrattr4) as amtrattr4 -- 
    ,nvl(n.permaxtr7, o.permaxtr7) as permaxtr7 -- 
    ,nvl(n.maxamt, o.maxamt) as maxamt -- 
    ,nvl(n.etgextkey, o.etgextkey) as etgextkey -- 
    ,nvl(n.minpercnt, o.minpercnt) as minpercnt -- 
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
from (select * from ${iol_schema}.isbs_fec_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_fec where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.setflg <> n.setflg
        or o.enddat <> n.enddat
        or o.ratcur <> n.ratcur
        or o.tirtyp <> n.tirtyp
        or o.objtyp <> n.objtyp
        or o.clcdifflg <> n.clcdifflg
        or o.settyp <> n.settyp
        or o.pertypprv <> n.pertypprv
        or o.permintr3 <> n.permintr3
        or o.ver <> n.ver
        or o.perrattr4 <> n.perrattr4
        or o.mincur <> n.mincur
        or o.perrattr6 <> n.perrattr6
        or o.permin <> n.permin
        or o.permaxtr3 <> n.permaxtr3
        or o.perrattr7 <> n.perrattr7
        or o.minfcc <> n.minfcc
        or o.amtsetall <> n.amtsetall
        or o.amtbegtr2 <> n.amtbegtr2
        or o.permaxtr6 <> n.permaxtr6
        or o.perrattr2 <> n.perrattr2
        or o.amtrattr3 <> n.amtrattr3
        or o.permintr4 <> n.permintr4
        or o.setend <> n.setend
        or o.perbegtr5 <> n.perbegtr5
        or o.perbegtr4 <> n.perbegtr4
        or o.ratcal <> n.ratcal
        or o.minamttot <> n.minamttot
        or o.setperflg <> n.setperflg
        or o.perbegtr3 <> n.perbegtr3
        or o.begdat <> n.begdat
        or o.untamt <> n.untamt
        or o.permaxtr2 <> n.permaxtr2
        or o.amtrattr2 <> n.amtrattr2
        or o.ratfcc <> n.ratfcc
        or o.higamt <> n.higamt
        or o.perrattr5 <> n.perrattr5
        or o.feepri <> n.feepri
        or o.lowamt <> n.lowamt
        or o.permintr5 <> n.permintr5
        or o.maxfcc <> n.maxfcc
        or o.maxpercnt <> n.maxpercnt
        or o.permintr2 <> n.permintr2
        or o.perbegtr2 <> n.perbegtr2
        or o.setmod <> n.setmod
        or o.colltr <> n.colltr
        or o.ratirs <> n.ratirs
        or o.calfcc <> n.calfcc
        or o.permaxtr4 <> n.permaxtr4
        or o.calcbs <> n.calcbs
        or o.setchgflg <> n.setchgflg
        or o.objinr <> n.objinr
        or o.basamt <> n.basamt
        or o.minamt <> n.minamt
        or o.feeinr <> n.feeinr
        or o.amtbegtr3 <> n.amtbegtr3
        or o.maxcur <> n.maxcur
        or o.amtbegtr4 <> n.amtbegtr4
        or o.pertyp <> n.pertyp
        or o.permintr6 <> n.permintr6
        or o.permintr7 <> n.permintr7
        or o.perrattr3 <> n.perrattr3
        or o.maxpercov <> n.maxpercov
        or o.perbegtr7 <> n.perbegtr7
        or o.setbeg <> n.setbeg
        or o.ratirsinc <> n.ratirsinc
        or o.calrul <> n.calrul
        or o.perbegtr6 <> n.perbegtr6
        or o.permaxtr5 <> n.permaxtr5
        or o.amtrattr4 <> n.amtrattr4
        or o.permaxtr7 <> n.permaxtr7
        or o.maxamt <> n.maxamt
        or o.etgextkey <> n.etgextkey
        or o.minpercnt <> n.minpercnt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_fec_cl(
            setflg -- 
            ,enddat -- 
            ,ratcur -- 
            ,tirtyp -- 
            ,objtyp -- 
            ,clcdifflg -- 
            ,settyp -- 
            ,pertypprv -- 
            ,permintr3 -- 
            ,ver -- 
            ,perrattr4 -- 
            ,mincur -- 
            ,perrattr6 -- 
            ,permin -- 
            ,permaxtr3 -- 
            ,perrattr7 -- 
            ,minfcc -- 
            ,amtsetall -- 
            ,amtbegtr2 -- 
            ,permaxtr6 -- 
            ,perrattr2 -- 
            ,amtrattr3 -- 
            ,permintr4 -- 
            ,setend -- 
            ,perbegtr5 -- 
            ,perbegtr4 -- 
            ,ratcal -- 
            ,minamttot -- 
            ,setperflg -- 
            ,perbegtr3 -- 
            ,begdat -- 
            ,untamt -- 
            ,permaxtr2 -- 
            ,amtrattr2 -- 
            ,ratfcc -- 
            ,higamt -- 
            ,perrattr5 -- 
            ,feepri -- 
            ,lowamt -- 
            ,permintr5 -- 
            ,maxfcc -- 
            ,maxpercnt -- 
            ,permintr2 -- 
            ,perbegtr2 -- 
            ,setmod -- 
            ,colltr -- 
            ,ratirs -- 
            ,calfcc -- 
            ,permaxtr4 -- 
            ,calcbs -- 
            ,setchgflg -- 
            ,inr -- 
            ,objinr -- 
            ,basamt -- 
            ,minamt -- 
            ,feeinr -- 
            ,amtbegtr3 -- 
            ,maxcur -- 
            ,amtbegtr4 -- 
            ,pertyp -- 
            ,permintr6 -- 
            ,permintr7 -- 
            ,perrattr3 -- 
            ,maxpercov -- 
            ,perbegtr7 -- 
            ,setbeg -- 
            ,ratirsinc -- 
            ,calrul -- 
            ,perbegtr6 -- 
            ,permaxtr5 -- 
            ,amtrattr4 -- 
            ,permaxtr7 -- 
            ,maxamt -- 
            ,etgextkey -- 
            ,minpercnt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_fec_op(
            setflg -- 
            ,enddat -- 
            ,ratcur -- 
            ,tirtyp -- 
            ,objtyp -- 
            ,clcdifflg -- 
            ,settyp -- 
            ,pertypprv -- 
            ,permintr3 -- 
            ,ver -- 
            ,perrattr4 -- 
            ,mincur -- 
            ,perrattr6 -- 
            ,permin -- 
            ,permaxtr3 -- 
            ,perrattr7 -- 
            ,minfcc -- 
            ,amtsetall -- 
            ,amtbegtr2 -- 
            ,permaxtr6 -- 
            ,perrattr2 -- 
            ,amtrattr3 -- 
            ,permintr4 -- 
            ,setend -- 
            ,perbegtr5 -- 
            ,perbegtr4 -- 
            ,ratcal -- 
            ,minamttot -- 
            ,setperflg -- 
            ,perbegtr3 -- 
            ,begdat -- 
            ,untamt -- 
            ,permaxtr2 -- 
            ,amtrattr2 -- 
            ,ratfcc -- 
            ,higamt -- 
            ,perrattr5 -- 
            ,feepri -- 
            ,lowamt -- 
            ,permintr5 -- 
            ,maxfcc -- 
            ,maxpercnt -- 
            ,permintr2 -- 
            ,perbegtr2 -- 
            ,setmod -- 
            ,colltr -- 
            ,ratirs -- 
            ,calfcc -- 
            ,permaxtr4 -- 
            ,calcbs -- 
            ,setchgflg -- 
            ,inr -- 
            ,objinr -- 
            ,basamt -- 
            ,minamt -- 
            ,feeinr -- 
            ,amtbegtr3 -- 
            ,maxcur -- 
            ,amtbegtr4 -- 
            ,pertyp -- 
            ,permintr6 -- 
            ,permintr7 -- 
            ,perrattr3 -- 
            ,maxpercov -- 
            ,perbegtr7 -- 
            ,setbeg -- 
            ,ratirsinc -- 
            ,calrul -- 
            ,perbegtr6 -- 
            ,permaxtr5 -- 
            ,amtrattr4 -- 
            ,permaxtr7 -- 
            ,maxamt -- 
            ,etgextkey -- 
            ,minpercnt -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.setflg -- 
    ,o.enddat -- 
    ,o.ratcur -- 
    ,o.tirtyp -- 
    ,o.objtyp -- 
    ,o.clcdifflg -- 
    ,o.settyp -- 
    ,o.pertypprv -- 
    ,o.permintr3 -- 
    ,o.ver -- 
    ,o.perrattr4 -- 
    ,o.mincur -- 
    ,o.perrattr6 -- 
    ,o.permin -- 
    ,o.permaxtr3 -- 
    ,o.perrattr7 -- 
    ,o.minfcc -- 
    ,o.amtsetall -- 
    ,o.amtbegtr2 -- 
    ,o.permaxtr6 -- 
    ,o.perrattr2 -- 
    ,o.amtrattr3 -- 
    ,o.permintr4 -- 
    ,o.setend -- 
    ,o.perbegtr5 -- 
    ,o.perbegtr4 -- 
    ,o.ratcal -- 
    ,o.minamttot -- 
    ,o.setperflg -- 
    ,o.perbegtr3 -- 
    ,o.begdat -- 
    ,o.untamt -- 
    ,o.permaxtr2 -- 
    ,o.amtrattr2 -- 
    ,o.ratfcc -- 
    ,o.higamt -- 
    ,o.perrattr5 -- 
    ,o.feepri -- 
    ,o.lowamt -- 
    ,o.permintr5 -- 
    ,o.maxfcc -- 
    ,o.maxpercnt -- 
    ,o.permintr2 -- 
    ,o.perbegtr2 -- 
    ,o.setmod -- 
    ,o.colltr -- 
    ,o.ratirs -- 
    ,o.calfcc -- 
    ,o.permaxtr4 -- 
    ,o.calcbs -- 
    ,o.setchgflg -- 
    ,o.inr -- 
    ,o.objinr -- 
    ,o.basamt -- 
    ,o.minamt -- 
    ,o.feeinr -- 
    ,o.amtbegtr3 -- 
    ,o.maxcur -- 
    ,o.amtbegtr4 -- 
    ,o.pertyp -- 
    ,o.permintr6 -- 
    ,o.permintr7 -- 
    ,o.perrattr3 -- 
    ,o.maxpercov -- 
    ,o.perbegtr7 -- 
    ,o.setbeg -- 
    ,o.ratirsinc -- 
    ,o.calrul -- 
    ,o.perbegtr6 -- 
    ,o.permaxtr5 -- 
    ,o.amtrattr4 -- 
    ,o.permaxtr7 -- 
    ,o.maxamt -- 
    ,o.etgextkey -- 
    ,o.minpercnt -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_fec_bk o
    left join ${iol_schema}.isbs_fec_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_fec_cl d
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
-- truncate table ${iol_schema}.isbs_fec;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_fec exchange partition p_19000101 with table ${iol_schema}.isbs_fec_cl;
alter table ${iol_schema}.isbs_fec exchange partition p_20991231 with table ${iol_schema}.isbs_fec_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_fec to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_fec_op purge;
drop table ${iol_schema}.isbs_fec_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_fec_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_fec',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
