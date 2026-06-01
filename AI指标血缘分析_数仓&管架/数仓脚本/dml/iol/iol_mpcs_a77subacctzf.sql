/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_mpcs_a77subacctzf
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
create table ${iol_schema}.mpcs_a77subacctzf_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.mpcs_a77subacctzf;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a77subacctzf_op purge;
drop table ${iol_schema}.mpcs_a77subacctzf_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.mpcs_a77subacctzf_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a77subacctzf where 0=1;

create table ${iol_schema}.mpcs_a77subacctzf_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.mpcs_a77subacctzf where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a77subacctzf_cl(
            docno -- 协作编号
            ,caseno -- 案件编号
            ,uniqueid -- 止付唯一标志
            ,account -- 主账户
            ,subsac -- 子账户序号
            ,crcycd -- 币种
            ,csextg -- 汇钞标志
            ,suopbr -- 开子户网点
            ,dataid -- 核心唯一标识
            ,hostdate -- 核心日期
            ,hostnbr -- 核心流水
            ,hostcode -- 核心返回码
            ,erortx -- 错误信息
            ,status -- 0-初始登记 1-止付成功 2-止付失败
            ,stoppayment -- 止付类型 0-止付 1-止付解除
            ,oldseq -- 原止付流水
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a77subacctzf_op(
            docno -- 协作编号
            ,caseno -- 案件编号
            ,uniqueid -- 止付唯一标志
            ,account -- 主账户
            ,subsac -- 子账户序号
            ,crcycd -- 币种
            ,csextg -- 汇钞标志
            ,suopbr -- 开子户网点
            ,dataid -- 核心唯一标识
            ,hostdate -- 核心日期
            ,hostnbr -- 核心流水
            ,hostcode -- 核心返回码
            ,erortx -- 错误信息
            ,status -- 0-初始登记 1-止付成功 2-止付失败
            ,stoppayment -- 止付类型 0-止付 1-止付解除
            ,oldseq -- 原止付流水
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.docno, o.docno) as docno -- 协作编号
    ,nvl(n.caseno, o.caseno) as caseno -- 案件编号
    ,nvl(n.uniqueid, o.uniqueid) as uniqueid -- 止付唯一标志
    ,nvl(n.account, o.account) as account -- 主账户
    ,nvl(n.subsac, o.subsac) as subsac -- 子账户序号
    ,nvl(n.crcycd, o.crcycd) as crcycd -- 币种
    ,nvl(n.csextg, o.csextg) as csextg -- 汇钞标志
    ,nvl(n.suopbr, o.suopbr) as suopbr -- 开子户网点
    ,nvl(n.dataid, o.dataid) as dataid -- 核心唯一标识
    ,nvl(n.hostdate, o.hostdate) as hostdate -- 核心日期
    ,nvl(n.hostnbr, o.hostnbr) as hostnbr -- 核心流水
    ,nvl(n.hostcode, o.hostcode) as hostcode -- 核心返回码
    ,nvl(n.erortx, o.erortx) as erortx -- 错误信息
    ,nvl(n.status, o.status) as status -- 0-初始登记 1-止付成功 2-止付失败
    ,nvl(n.stoppayment, o.stoppayment) as stoppayment -- 止付类型 0-止付 1-止付解除
    ,nvl(n.oldseq, o.oldseq) as oldseq -- 原止付流水
    ,nvl(n.xtbz, o.xtbz) as xtbz -- 
    ,case when
            n.docno is null
            and n.caseno is null
            and n.account is null
            and n.subsac is null
            and n.xtbz is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.docno is null
            and n.caseno is null
            and n.account is null
            and n.subsac is null
            and n.xtbz is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.docno is null
            and n.caseno is null
            and n.account is null
            and n.subsac is null
            and n.xtbz is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.mpcs_a77subacctzf_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.mpcs_a77subacctzf where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.docno = n.docno
            and o.caseno = n.caseno
            and o.account = n.account
            and o.subsac = n.subsac
            and o.xtbz = n.xtbz
where (
        o.docno is null
        and o.caseno is null
        and o.account is null
        and o.subsac is null
        and o.xtbz is null
    )
    or (
        n.docno is null
        and n.caseno is null
        and n.account is null
        and n.subsac is null
        and n.xtbz is null
    )
    or (
        o.uniqueid <> n.uniqueid
        or o.crcycd <> n.crcycd
        or o.csextg <> n.csextg
        or o.suopbr <> n.suopbr
        or o.dataid <> n.dataid
        or o.hostdate <> n.hostdate
        or o.hostnbr <> n.hostnbr
        or o.hostcode <> n.hostcode
        or o.erortx <> n.erortx
        or o.status <> n.status
        or o.stoppayment <> n.stoppayment
        or o.oldseq <> n.oldseq
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.mpcs_a77subacctzf_cl(
            docno -- 协作编号
            ,caseno -- 案件编号
            ,uniqueid -- 止付唯一标志
            ,account -- 主账户
            ,subsac -- 子账户序号
            ,crcycd -- 币种
            ,csextg -- 汇钞标志
            ,suopbr -- 开子户网点
            ,dataid -- 核心唯一标识
            ,hostdate -- 核心日期
            ,hostnbr -- 核心流水
            ,hostcode -- 核心返回码
            ,erortx -- 错误信息
            ,status -- 0-初始登记 1-止付成功 2-止付失败
            ,stoppayment -- 止付类型 0-止付 1-止付解除
            ,oldseq -- 原止付流水
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.mpcs_a77subacctzf_op(
            docno -- 协作编号
            ,caseno -- 案件编号
            ,uniqueid -- 止付唯一标志
            ,account -- 主账户
            ,subsac -- 子账户序号
            ,crcycd -- 币种
            ,csextg -- 汇钞标志
            ,suopbr -- 开子户网点
            ,dataid -- 核心唯一标识
            ,hostdate -- 核心日期
            ,hostnbr -- 核心流水
            ,hostcode -- 核心返回码
            ,erortx -- 错误信息
            ,status -- 0-初始登记 1-止付成功 2-止付失败
            ,stoppayment -- 止付类型 0-止付 1-止付解除
            ,oldseq -- 原止付流水
            ,xtbz -- 
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.docno -- 协作编号
    ,o.caseno -- 案件编号
    ,o.uniqueid -- 止付唯一标志
    ,o.account -- 主账户
    ,o.subsac -- 子账户序号
    ,o.crcycd -- 币种
    ,o.csextg -- 汇钞标志
    ,o.suopbr -- 开子户网点
    ,o.dataid -- 核心唯一标识
    ,o.hostdate -- 核心日期
    ,o.hostnbr -- 核心流水
    ,o.hostcode -- 核心返回码
    ,o.erortx -- 错误信息
    ,o.status -- 0-初始登记 1-止付成功 2-止付失败
    ,o.stoppayment -- 止付类型 0-止付 1-止付解除
    ,o.oldseq -- 原止付流水
    ,o.xtbz -- 
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.mpcs_a77subacctzf_bk o
    left join ${iol_schema}.mpcs_a77subacctzf_op n
        on
            o.docno = n.docno
            and o.caseno = n.caseno
            and o.account = n.account
            and o.subsac = n.subsac
            and o.xtbz = n.xtbz
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.mpcs_a77subacctzf_cl d
        on
            o.docno = d.docno
            and o.caseno = d.caseno
            and o.account = d.account
            and o.subsac = d.subsac
            and o.xtbz = d.xtbz
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.mpcs_a77subacctzf;

-- 4.2 exchange partition
alter table ${iol_schema}.mpcs_a77subacctzf exchange partition p_19000101 with table ${iol_schema}.mpcs_a77subacctzf_cl;
alter table ${iol_schema}.mpcs_a77subacctzf exchange partition p_20991231 with table ${iol_schema}.mpcs_a77subacctzf_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.mpcs_a77subacctzf to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.mpcs_a77subacctzf_op purge;
drop table ${iol_schema}.mpcs_a77subacctzf_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.mpcs_a77subacctzf_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'mpcs_a77subacctzf',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
