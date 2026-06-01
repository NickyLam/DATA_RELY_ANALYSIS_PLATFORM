/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_bet
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
create table ${iol_schema}.isbs_bet_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_bet;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bet_op purge;
drop table ${iol_schema}.isbs_bet_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_bet_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bet where 0=1;

create table ${iol_schema}.isbs_bet_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_bet where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bet_cl(
            inr -- 出口单据INR
            ,docdis -- 不符点
            ,docins -- 拒付原因
            ,prsdoc -- 提交单据
            ,disdoc -- 处理单据
            ,benins -- 说明
            ,matper -- 效期
            ,intdis -- 内部差异
            ,comcon -- 注释与结论
            ,fldmodblk -- 修改域的列表
            ,chaadd -- 费用增加
            ,chaded -- 费用减少
            ,nartxt77a -- tag 77内容
            ,contag72 -- tag72内容
            ,contag79 -- tag79内容
            ,docdisflg -- 不符点修改标志
            ,docdisdef -- 不符点内容
            ,setinsbe -- 收费说明
            ,benref -- 发票号
            ,roggod -- 货物证明
            ,notpty -- 通知方
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bet_op(
            inr -- 出口单据INR
            ,docdis -- 不符点
            ,docins -- 拒付原因
            ,prsdoc -- 提交单据
            ,disdoc -- 处理单据
            ,benins -- 说明
            ,matper -- 效期
            ,intdis -- 内部差异
            ,comcon -- 注释与结论
            ,fldmodblk -- 修改域的列表
            ,chaadd -- 费用增加
            ,chaded -- 费用减少
            ,nartxt77a -- tag 77内容
            ,contag72 -- tag72内容
            ,contag79 -- tag79内容
            ,docdisflg -- 不符点修改标志
            ,docdisdef -- 不符点内容
            ,setinsbe -- 收费说明
            ,benref -- 发票号
            ,roggod -- 货物证明
            ,notpty -- 通知方
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 出口单据INR
    ,nvl(n.docdis, o.docdis) as docdis -- 不符点
    ,nvl(n.docins, o.docins) as docins -- 拒付原因
    ,nvl(n.prsdoc, o.prsdoc) as prsdoc -- 提交单据
    ,nvl(n.disdoc, o.disdoc) as disdoc -- 处理单据
    ,nvl(n.benins, o.benins) as benins -- 说明
    ,nvl(n.matper, o.matper) as matper -- 效期
    ,nvl(n.intdis, o.intdis) as intdis -- 内部差异
    ,nvl(n.comcon, o.comcon) as comcon -- 注释与结论
    ,nvl(n.fldmodblk, o.fldmodblk) as fldmodblk -- 修改域的列表
    ,nvl(n.chaadd, o.chaadd) as chaadd -- 费用增加
    ,nvl(n.chaded, o.chaded) as chaded -- 费用减少
    ,nvl(n.nartxt77a, o.nartxt77a) as nartxt77a -- tag 77内容
    ,nvl(n.contag72, o.contag72) as contag72 -- tag72内容
    ,nvl(n.contag79, o.contag79) as contag79 -- tag79内容
    ,nvl(n.docdisflg, o.docdisflg) as docdisflg -- 不符点修改标志
    ,nvl(n.docdisdef, o.docdisdef) as docdisdef -- 不符点内容
    ,nvl(n.setinsbe, o.setinsbe) as setinsbe -- 收费说明
    ,nvl(n.benref, o.benref) as benref -- 发票号
    ,nvl(n.roggod, o.roggod) as roggod -- 货物证明
    ,nvl(n.notpty, o.notpty) as notpty -- 通知方
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
from (select * from ${iol_schema}.isbs_bet_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_bet where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.docdis <> n.docdis
        or o.docins <> n.docins
        or o.prsdoc <> n.prsdoc
        or o.disdoc <> n.disdoc
        or o.benins <> n.benins
        or o.matper <> n.matper
        or o.intdis <> n.intdis
        or o.comcon <> n.comcon
        or o.fldmodblk <> n.fldmodblk
        or o.chaadd <> n.chaadd
        or o.chaded <> n.chaded
        or o.nartxt77a <> n.nartxt77a
        or o.contag72 <> n.contag72
        or o.contag79 <> n.contag79
        or o.docdisflg <> n.docdisflg
        or o.docdisdef <> n.docdisdef
        or o.setinsbe <> n.setinsbe
        or o.benref <> n.benref
        or o.roggod <> n.roggod
        or o.notpty <> n.notpty
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_bet_cl(
            inr -- 出口单据INR
            ,docdis -- 不符点
            ,docins -- 拒付原因
            ,prsdoc -- 提交单据
            ,disdoc -- 处理单据
            ,benins -- 说明
            ,matper -- 效期
            ,intdis -- 内部差异
            ,comcon -- 注释与结论
            ,fldmodblk -- 修改域的列表
            ,chaadd -- 费用增加
            ,chaded -- 费用减少
            ,nartxt77a -- tag 77内容
            ,contag72 -- tag72内容
            ,contag79 -- tag79内容
            ,docdisflg -- 不符点修改标志
            ,docdisdef -- 不符点内容
            ,setinsbe -- 收费说明
            ,benref -- 发票号
            ,roggod -- 货物证明
            ,notpty -- 通知方
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_bet_op(
            inr -- 出口单据INR
            ,docdis -- 不符点
            ,docins -- 拒付原因
            ,prsdoc -- 提交单据
            ,disdoc -- 处理单据
            ,benins -- 说明
            ,matper -- 效期
            ,intdis -- 内部差异
            ,comcon -- 注释与结论
            ,fldmodblk -- 修改域的列表
            ,chaadd -- 费用增加
            ,chaded -- 费用减少
            ,nartxt77a -- tag 77内容
            ,contag72 -- tag72内容
            ,contag79 -- tag79内容
            ,docdisflg -- 不符点修改标志
            ,docdisdef -- 不符点内容
            ,setinsbe -- 收费说明
            ,benref -- 发票号
            ,roggod -- 货物证明
            ,notpty -- 通知方
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 出口单据INR
    ,o.docdis -- 不符点
    ,o.docins -- 拒付原因
    ,o.prsdoc -- 提交单据
    ,o.disdoc -- 处理单据
    ,o.benins -- 说明
    ,o.matper -- 效期
    ,o.intdis -- 内部差异
    ,o.comcon -- 注释与结论
    ,o.fldmodblk -- 修改域的列表
    ,o.chaadd -- 费用增加
    ,o.chaded -- 费用减少
    ,o.nartxt77a -- tag 77内容
    ,o.contag72 -- tag72内容
    ,o.contag79 -- tag79内容
    ,o.docdisflg -- 不符点修改标志
    ,o.docdisdef -- 不符点内容
    ,o.setinsbe -- 收费说明
    ,o.benref -- 发票号
    ,o.roggod -- 货物证明
    ,o.notpty -- 通知方
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_bet_bk o
    left join ${iol_schema}.isbs_bet_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_bet_cl d
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
-- truncate table ${iol_schema}.isbs_bet;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_bet exchange partition p_19000101 with table ${iol_schema}.isbs_bet_cl;
alter table ${iol_schema}.isbs_bet exchange partition p_20991231 with table ${iol_schema}.isbs_bet_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_bet to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_bet_op purge;
drop table ${iol_schema}.isbs_bet_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_bet_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_bet',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
