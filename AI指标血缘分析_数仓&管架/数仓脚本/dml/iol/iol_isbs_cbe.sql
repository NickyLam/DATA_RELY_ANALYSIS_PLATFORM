/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_cbe
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
create table ${iol_schema}.isbs_cbe_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_cbe;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cbe_op purge;
drop table ${iol_schema}.isbs_cbe_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_cbe_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cbe where 0=1;

create table ${iol_schema}.isbs_cbe_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_cbe where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cbe_cl(
            inr -- 唯一ID
            ,objtyp -- 对象类型
            ,objinr -- 对象INR
            ,extid -- 外部金额类型
            ,cbt -- 金额类型
            ,trntyp -- 交易表名
            ,trninr -- 交易表的INR
            ,dat -- 发生日期
            ,cur -- 币种
            ,amt -- 金额
            ,relflg -- 授权标志
            ,credat -- 创建日期
            ,xrfcur -- 折算币种
            ,xrfamt -- 折算后的金额
            ,nam -- 描述
            ,acc -- 账号1
            ,acc2 -- 账号2
            ,optdat -- 其他可选日期
            ,gledat -- 记账日期
            ,nompct -- 保证金应收比例
            ,chkflg -- 检查标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cbe_op(
            inr -- 唯一ID
            ,objtyp -- 对象类型
            ,objinr -- 对象INR
            ,extid -- 外部金额类型
            ,cbt -- 金额类型
            ,trntyp -- 交易表名
            ,trninr -- 交易表的INR
            ,dat -- 发生日期
            ,cur -- 币种
            ,amt -- 金额
            ,relflg -- 授权标志
            ,credat -- 创建日期
            ,xrfcur -- 折算币种
            ,xrfamt -- 折算后的金额
            ,nam -- 描述
            ,acc -- 账号1
            ,acc2 -- 账号2
            ,optdat -- 其他可选日期
            ,gledat -- 记账日期
            ,nompct -- 保证金应收比例
            ,chkflg -- 检查标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 唯一ID
    ,nvl(n.objtyp, o.objtyp) as objtyp -- 对象类型
    ,nvl(n.objinr, o.objinr) as objinr -- 对象INR
    ,nvl(n.extid, o.extid) as extid -- 外部金额类型
    ,nvl(n.cbt, o.cbt) as cbt -- 金额类型
    ,nvl(n.trntyp, o.trntyp) as trntyp -- 交易表名
    ,nvl(n.trninr, o.trninr) as trninr -- 交易表的INR
    ,nvl(n.dat, o.dat) as dat -- 发生日期
    ,nvl(n.cur, o.cur) as cur -- 币种
    ,nvl(n.amt, o.amt) as amt -- 金额
    ,nvl(n.relflg, o.relflg) as relflg -- 授权标志
    ,nvl(n.credat, o.credat) as credat -- 创建日期
    ,nvl(n.xrfcur, o.xrfcur) as xrfcur -- 折算币种
    ,nvl(n.xrfamt, o.xrfamt) as xrfamt -- 折算后的金额
    ,nvl(n.nam, o.nam) as nam -- 描述
    ,nvl(n.acc, o.acc) as acc -- 账号1
    ,nvl(n.acc2, o.acc2) as acc2 -- 账号2
    ,nvl(n.optdat, o.optdat) as optdat -- 其他可选日期
    ,nvl(n.gledat, o.gledat) as gledat -- 记账日期
    ,nvl(n.nompct, o.nompct) as nompct -- 保证金应收比例
    ,nvl(n.chkflg, o.chkflg) as chkflg -- 检查标志
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
from (select * from ${iol_schema}.isbs_cbe_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_cbe where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.extid <> n.extid
        or o.cbt <> n.cbt
        or o.trntyp <> n.trntyp
        or o.trninr <> n.trninr
        or o.dat <> n.dat
        or o.cur <> n.cur
        or o.amt <> n.amt
        or o.relflg <> n.relflg
        or o.credat <> n.credat
        or o.xrfcur <> n.xrfcur
        or o.xrfamt <> n.xrfamt
        or o.nam <> n.nam
        or o.acc <> n.acc
        or o.acc2 <> n.acc2
        or o.optdat <> n.optdat
        or o.gledat <> n.gledat
        or o.nompct <> n.nompct
        or o.chkflg <> n.chkflg
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_cbe_cl(
            inr -- 唯一ID
            ,objtyp -- 对象类型
            ,objinr -- 对象INR
            ,extid -- 外部金额类型
            ,cbt -- 金额类型
            ,trntyp -- 交易表名
            ,trninr -- 交易表的INR
            ,dat -- 发生日期
            ,cur -- 币种
            ,amt -- 金额
            ,relflg -- 授权标志
            ,credat -- 创建日期
            ,xrfcur -- 折算币种
            ,xrfamt -- 折算后的金额
            ,nam -- 描述
            ,acc -- 账号1
            ,acc2 -- 账号2
            ,optdat -- 其他可选日期
            ,gledat -- 记账日期
            ,nompct -- 保证金应收比例
            ,chkflg -- 检查标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_cbe_op(
            inr -- 唯一ID
            ,objtyp -- 对象类型
            ,objinr -- 对象INR
            ,extid -- 外部金额类型
            ,cbt -- 金额类型
            ,trntyp -- 交易表名
            ,trninr -- 交易表的INR
            ,dat -- 发生日期
            ,cur -- 币种
            ,amt -- 金额
            ,relflg -- 授权标志
            ,credat -- 创建日期
            ,xrfcur -- 折算币种
            ,xrfamt -- 折算后的金额
            ,nam -- 描述
            ,acc -- 账号1
            ,acc2 -- 账号2
            ,optdat -- 其他可选日期
            ,gledat -- 记账日期
            ,nompct -- 保证金应收比例
            ,chkflg -- 检查标志
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 唯一ID
    ,o.objtyp -- 对象类型
    ,o.objinr -- 对象INR
    ,o.extid -- 外部金额类型
    ,o.cbt -- 金额类型
    ,o.trntyp -- 交易表名
    ,o.trninr -- 交易表的INR
    ,o.dat -- 发生日期
    ,o.cur -- 币种
    ,o.amt -- 金额
    ,o.relflg -- 授权标志
    ,o.credat -- 创建日期
    ,o.xrfcur -- 折算币种
    ,o.xrfamt -- 折算后的金额
    ,o.nam -- 描述
    ,o.acc -- 账号1
    ,o.acc2 -- 账号2
    ,o.optdat -- 其他可选日期
    ,o.gledat -- 记账日期
    ,o.nompct -- 保证金应收比例
    ,o.chkflg -- 检查标志
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_cbe_bk o
    left join ${iol_schema}.isbs_cbe_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_cbe_cl d
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
-- truncate table ${iol_schema}.isbs_cbe;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_cbe exchange partition p_19000101 with table ${iol_schema}.isbs_cbe_cl;
alter table ${iol_schema}.isbs_cbe exchange partition p_20991231 with table ${iol_schema}.isbs_cbe_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_cbe to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_cbe_op purge;
drop table ${iol_schema}.isbs_cbe_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_cbe_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_cbe',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
