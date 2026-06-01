/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_det
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
create table ${iol_schema}.isbs_det_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_det;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_det_op purge;
drop table ${iol_schema}.isbs_det_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_det_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_det where 0=1;

create table ${iol_schema}.isbs_det_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_det where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_det_cl(
            inr -- 
            ,contag72 -- 
            ,contag79 -- 
            ,adlcnd -- 
            ,defdet -- 
            ,dftat -- 
            ,feetxt -- 
            ,insbnk -- 
            ,lcrdoc -- 
            ,lcrgod -- 
            ,mixdet -- 
            ,preper -- 
            ,shpper -- 
            ,strinf -- 
            ,ver -- 
            ,adlcndame -- 
            ,lcrgodame -- 
            ,lcrdocame -- 
            ,nartxtame -- 
            ,addamtcov -- 
            ,fldmodblk -- 
            ,revnotes -- 
            ,revcls -- 
            ,avbwthtxt -- 
            ,insbnkame -- 
            ,forins -- 
            ,insdat -- 
            ,preperflg -- 
            ,othtyp -- 
            ,rejamersn  -- 修改理由
            ,rejrsnamehis  -- 修改理由（历史）
            ,canrsn  -- 闭卷原因
            ,canrsnhis -- 闭卷原因（历史）
            ,rejadvrsn  -- 拒绝通知理由
            ,rejadvrsnhis  -- 拒绝通知理由（历史）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_det_op(
            inr -- 
            ,contag72 -- 
            ,contag79 -- 
            ,adlcnd -- 
            ,defdet -- 
            ,dftat -- 
            ,feetxt -- 
            ,insbnk -- 
            ,lcrdoc -- 
            ,lcrgod -- 
            ,mixdet -- 
            ,preper -- 
            ,shpper -- 
            ,strinf -- 
            ,ver -- 
            ,adlcndame -- 
            ,lcrgodame -- 
            ,lcrdocame -- 
            ,nartxtame -- 
            ,addamtcov -- 
            ,fldmodblk -- 
            ,revnotes -- 
            ,revcls -- 
            ,avbwthtxt -- 
            ,insbnkame -- 
            ,forins -- 
            ,insdat -- 
            ,preperflg -- 
            ,othtyp -- 
            ,rejamersn  -- 修改理由
            ,rejrsnamehis  -- 修改理由（历史）
            ,canrsn  -- 闭卷原因
            ,canrsnhis -- 闭卷原因（历史）
            ,rejadvrsn  -- 拒绝通知理由
            ,rejadvrsnhis  -- 拒绝通知理由（历史）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 
    ,nvl(n.contag72, o.contag72) as contag72 -- 
    ,nvl(n.contag79, o.contag79) as contag79 -- 
    ,nvl(n.adlcnd, o.adlcnd) as adlcnd -- 
    ,nvl(n.defdet, o.defdet) as defdet -- 
    ,nvl(n.dftat, o.dftat) as dftat -- 
    ,nvl(n.feetxt, o.feetxt) as feetxt -- 
    ,nvl(n.insbnk, o.insbnk) as insbnk -- 
    ,nvl(n.lcrdoc, o.lcrdoc) as lcrdoc -- 
    ,nvl(n.lcrgod, o.lcrgod) as lcrgod -- 
    ,nvl(n.mixdet, o.mixdet) as mixdet -- 
    ,nvl(n.preper, o.preper) as preper -- 
    ,nvl(n.shpper, o.shpper) as shpper -- 
    ,nvl(n.strinf, o.strinf) as strinf -- 
    ,nvl(n.ver, o.ver) as ver -- 
    ,nvl(n.adlcndame, o.adlcndame) as adlcndame -- 
    ,nvl(n.lcrgodame, o.lcrgodame) as lcrgodame -- 
    ,nvl(n.lcrdocame, o.lcrdocame) as lcrdocame -- 
    ,nvl(n.nartxtame, o.nartxtame) as nartxtame -- 
    ,nvl(n.addamtcov, o.addamtcov) as addamtcov -- 
    ,nvl(n.fldmodblk, o.fldmodblk) as fldmodblk -- 
    ,nvl(n.revnotes, o.revnotes) as revnotes -- 
    ,nvl(n.revcls, o.revcls) as revcls -- 
    ,nvl(n.avbwthtxt, o.avbwthtxt) as avbwthtxt -- 
    ,nvl(n.insbnkame, o.insbnkame) as insbnkame -- 
    ,nvl(n.forins, o.forins) as forins -- 
    ,nvl(n.insdat, o.insdat) as insdat -- 
    ,nvl(n.preperflg, o.preperflg) as preperflg -- 
    ,nvl(n.othtyp, o.othtyp) as othtyp -- 
    ,nvl(n.rejamersn , o.rejamersn ) as rejamersn  -- 修改理由
    ,nvl(n.rejrsnamehis , o.rejrsnamehis ) as rejrsnamehis  -- 修改理由（历史）
    ,nvl(n.canrsn , o.canrsn ) as canrsn  -- 闭卷原因
    ,nvl(n.canrsnhis, o.canrsnhis) as canrsnhis -- 闭卷原因（历史）
    ,nvl(n.rejadvrsn , o.rejadvrsn ) as rejadvrsn  -- 拒绝通知理由
    ,nvl(n.rejadvrsnhis , o.rejadvrsnhis ) as rejadvrsnhis  -- 拒绝通知理由（历史）
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
from (select * from ${iol_schema}.isbs_det_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_det where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.contag72 <> n.contag72
        or o.contag79 <> n.contag79
        or o.adlcnd <> n.adlcnd
        or o.defdet <> n.defdet
        or o.dftat <> n.dftat
        or o.feetxt <> n.feetxt
        or o.insbnk <> n.insbnk
        or o.lcrdoc <> n.lcrdoc
        or o.lcrgod <> n.lcrgod
        or o.mixdet <> n.mixdet
        or o.preper <> n.preper
        or o.shpper <> n.shpper
        or o.strinf <> n.strinf
        or o.ver <> n.ver
        or o.adlcndame <> n.adlcndame
        or o.lcrgodame <> n.lcrgodame
        or o.lcrdocame <> n.lcrdocame
        or o.nartxtame <> n.nartxtame
        or o.addamtcov <> n.addamtcov
        or o.fldmodblk <> n.fldmodblk
        or o.revnotes <> n.revnotes
        or o.revcls <> n.revcls
        or o.avbwthtxt <> n.avbwthtxt
        or o.insbnkame <> n.insbnkame
        or o.forins <> n.forins
        or o.insdat <> n.insdat
        or o.preperflg <> n.preperflg
        or o.othtyp <> n.othtyp
        or o.rejamersn  <> n.rejamersn 
        or o.rejrsnamehis  <> n.rejrsnamehis 
        or o.canrsn  <> n.canrsn 
        or o.canrsnhis <> n.canrsnhis
        or o.rejadvrsn  <> n.rejadvrsn 
        or o.rejadvrsnhis  <> n.rejadvrsnhis 
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_det_cl(
            inr -- 
            ,contag72 -- 
            ,contag79 -- 
            ,adlcnd -- 
            ,defdet -- 
            ,dftat -- 
            ,feetxt -- 
            ,insbnk -- 
            ,lcrdoc -- 
            ,lcrgod -- 
            ,mixdet -- 
            ,preper -- 
            ,shpper -- 
            ,strinf -- 
            ,ver -- 
            ,adlcndame -- 
            ,lcrgodame -- 
            ,lcrdocame -- 
            ,nartxtame -- 
            ,addamtcov -- 
            ,fldmodblk -- 
            ,revnotes -- 
            ,revcls -- 
            ,avbwthtxt -- 
            ,insbnkame -- 
            ,forins -- 
            ,insdat -- 
            ,preperflg -- 
            ,othtyp -- 
            ,rejamersn  -- 修改理由
            ,rejrsnamehis  -- 修改理由（历史）
            ,canrsn  -- 闭卷原因
            ,canrsnhis -- 闭卷原因（历史）
            ,rejadvrsn  -- 拒绝通知理由
            ,rejadvrsnhis  -- 拒绝通知理由（历史）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_det_op(
            inr -- 
            ,contag72 -- 
            ,contag79 -- 
            ,adlcnd -- 
            ,defdet -- 
            ,dftat -- 
            ,feetxt -- 
            ,insbnk -- 
            ,lcrdoc -- 
            ,lcrgod -- 
            ,mixdet -- 
            ,preper -- 
            ,shpper -- 
            ,strinf -- 
            ,ver -- 
            ,adlcndame -- 
            ,lcrgodame -- 
            ,lcrdocame -- 
            ,nartxtame -- 
            ,addamtcov -- 
            ,fldmodblk -- 
            ,revnotes -- 
            ,revcls -- 
            ,avbwthtxt -- 
            ,insbnkame -- 
            ,forins -- 
            ,insdat -- 
            ,preperflg -- 
            ,othtyp -- 
            ,rejamersn  -- 修改理由
            ,rejrsnamehis  -- 修改理由（历史）
            ,canrsn  -- 闭卷原因
            ,canrsnhis -- 闭卷原因（历史）
            ,rejadvrsn  -- 拒绝通知理由
            ,rejadvrsnhis  -- 拒绝通知理由（历史）
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 
    ,o.contag72 -- 
    ,o.contag79 -- 
    ,o.adlcnd -- 
    ,o.defdet -- 
    ,o.dftat -- 
    ,o.feetxt -- 
    ,o.insbnk -- 
    ,o.lcrdoc -- 
    ,o.lcrgod -- 
    ,o.mixdet -- 
    ,o.preper -- 
    ,o.shpper -- 
    ,o.strinf -- 
    ,o.ver -- 
    ,o.adlcndame -- 
    ,o.lcrgodame -- 
    ,o.lcrdocame -- 
    ,o.nartxtame -- 
    ,o.addamtcov -- 
    ,o.fldmodblk -- 
    ,o.revnotes -- 
    ,o.revcls -- 
    ,o.avbwthtxt -- 
    ,o.insbnkame -- 
    ,o.forins -- 
    ,o.insdat -- 
    ,o.preperflg -- 
    ,o.othtyp -- 
    ,o.rejamersn  -- 修改理由
    ,o.rejrsnamehis  -- 修改理由（历史）
    ,o.canrsn  -- 闭卷原因
    ,o.canrsnhis -- 闭卷原因（历史）
    ,o.rejadvrsn  -- 拒绝通知理由
    ,o.rejadvrsnhis  -- 拒绝通知理由（历史）
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_det_bk o
    left join ${iol_schema}.isbs_det_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_det_cl d
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
-- truncate table ${iol_schema}.isbs_det;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_det exchange partition p_19000101 with table ${iol_schema}.isbs_det_cl;
alter table ${iol_schema}.isbs_det exchange partition p_20991231 with table ${iol_schema}.isbs_det_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_det to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_det_op purge;
drop table ${iol_schema}.isbs_det_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_det_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_det',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
