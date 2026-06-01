/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_cbb
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
create table ${iol_schema}.isbs_cbb_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_cbb;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cbb_op purge;
drop table ${iol_schema}.isbs_cbb_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cbb_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cbb where 0=1;

create table ${iol_schema}.isbs_cbb_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cbb where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cbb_cl(
            inr -- 唯一ID
            ,objtyp -- 对象表名称
            ,objinr -- 对象inr
            ,cbc -- 金额类型
            ,extid -- 外部金额类型
            ,begdat -- 起始日期
            ,enddat -- 结束日期
            ,cur -- 币种
            ,amt -- 金额
            ,cbeinr -- CBE的inr
            ,xrfcur -- 折算币种
            ,xrfamt -- 折算后金额
            ,comcur -- 用于统计的币种
            ,comamt -- 用于统计的折算后金额
            ,xcocur -- 用于统计的折算币种
            ,xcoamt -- 用于统计的金额折算成系统币种的金额
            ,frenum -- 冻结编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cbb_op(
            inr -- 唯一ID
            ,objtyp -- 对象表名称
            ,objinr -- 对象inr
            ,cbc -- 金额类型
            ,extid -- 外部金额类型
            ,begdat -- 起始日期
            ,enddat -- 结束日期
            ,cur -- 币种
            ,amt -- 金额
            ,cbeinr -- CBE的inr
            ,xrfcur -- 折算币种
            ,xrfamt -- 折算后金额
            ,comcur -- 用于统计的币种
            ,comamt -- 用于统计的折算后金额
            ,xcocur -- 用于统计的折算币种
            ,xcoamt -- 用于统计的金额折算成系统币种的金额
            ,frenum -- 冻结编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 唯一ID
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 对象表名称
    ,nvl(n.objinr, o.objinr) as objinr -- 对象inr
    ,nvl(n.cbc, o.cbc) as cbc -- 金额类型
    ,nvl(n.extid, o.extid) as extid -- 外部金额类型
    ,nvl(n.begdat, o.begdat) as begdat -- 起始日期
    ,nvl(n.enddat, o.enddat) as enddat -- 结束日期
    ,nvl(n.cur, o.cur) as cur -- 币种
    ,nvl(n.amt, o.amt) as amt -- 金额
    ,nvl(n.cbeinr, o.cbeinr) as cbeinr -- CBE的inr
    ,nvl(n.xrfcur, o.xrfcur) as xrfcur -- 折算币种
    ,nvl(n.xrfamt, o.xrfamt) as xrfamt -- 折算后金额
    ,nvl(n.comcur, o.comcur) as comcur -- 用于统计的币种
    ,nvl(n.comamt, o.comamt) as comamt -- 用于统计的折算后金额
    ,nvl(n.xcocur, o.xcocur) as xcocur -- 用于统计的折算币种
    ,nvl(n.xcoamt, o.xcoamt) as xcoamt -- 用于统计的金额折算成系统币种的金额
    ,nvl(n.frenum, o.frenum) as frenum -- 冻结编号
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
from (select * from ${iol_schema}.isbs_cbb_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_cbb where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.objtyp <> n.objtyp
        or o.objinr <> n.objinr
        or o.cbc <> n.cbc
        or o.extid <> n.extid
        or o.begdat <> n.begdat
        or o.enddat <> n.enddat
        or o.cur <> n.cur
        or o.amt <> n.amt
        or o.cbeinr <> n.cbeinr
        or o.xrfcur <> n.xrfcur
        or o.xrfamt <> n.xrfamt
        or o.comcur <> n.comcur
        or o.comamt <> n.comamt
        or o.xcocur <> n.xcocur
        or o.xcoamt <> n.xcoamt
        or o.frenum <> n.frenum
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cbb_cl(
            inr -- 唯一ID
            ,objtyp -- 对象表名称
            ,objinr -- 对象inr
            ,cbc -- 金额类型
            ,extid -- 外部金额类型
            ,begdat -- 起始日期
            ,enddat -- 结束日期
            ,cur -- 币种
            ,amt -- 金额
            ,cbeinr -- CBE的inr
            ,xrfcur -- 折算币种
            ,xrfamt -- 折算后金额
            ,comcur -- 用于统计的币种
            ,comamt -- 用于统计的折算后金额
            ,xcocur -- 用于统计的折算币种
            ,xcoamt -- 用于统计的金额折算成系统币种的金额
            ,frenum -- 冻结编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cbb_op(
            inr -- 唯一ID
            ,objtyp -- 对象表名称
            ,objinr -- 对象inr
            ,cbc -- 金额类型
            ,extid -- 外部金额类型
            ,begdat -- 起始日期
            ,enddat -- 结束日期
            ,cur -- 币种
            ,amt -- 金额
            ,cbeinr -- CBE的inr
            ,xrfcur -- 折算币种
            ,xrfamt -- 折算后金额
            ,comcur -- 用于统计的币种
            ,comamt -- 用于统计的折算后金额
            ,xcocur -- 用于统计的折算币种
            ,xcoamt -- 用于统计的金额折算成系统币种的金额
            ,frenum -- 冻结编号
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 唯一ID
    ,o.objtyp -- 对象表名称
    ,o.objinr -- 对象inr
    ,o.cbc -- 金额类型
    ,o.extid -- 外部金额类型
    ,o.begdat -- 起始日期
    ,o.enddat -- 结束日期
    ,o.cur -- 币种
    ,o.amt -- 金额
    ,o.cbeinr -- CBE的inr
    ,o.xrfcur -- 折算币种
    ,o.xrfamt -- 折算后金额
    ,o.comcur -- 用于统计的币种
    ,o.comamt -- 用于统计的折算后金额
    ,o.xcocur -- 用于统计的折算币种
    ,o.xcoamt -- 用于统计的金额折算成系统币种的金额
    ,o.frenum -- 冻结编号
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_cbb_bk o
    left join ${iol_schema}.isbs_cbb_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_cbb_cl d
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
-- truncate table ${iol_schema}.isbs_cbb;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_cbb exchange partition p_19000101 with table ${iol_schema}.isbs_cbb_cl;
alter table ${iol_schema}.isbs_cbb exchange partition p_20991231 with table ${iol_schema}.isbs_cbb_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_cbb to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cbb_op purge;
drop table ${iol_schema}.isbs_cbb_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_cbb_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_cbb',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
