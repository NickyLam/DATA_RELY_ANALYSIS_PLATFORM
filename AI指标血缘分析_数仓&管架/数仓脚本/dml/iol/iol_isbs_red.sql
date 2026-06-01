/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_isbs_red
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
create table ${iol_schema}.isbs_red_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.isbs_red;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_red_op purge;
drop table ${iol_schema}.isbs_red_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.isbs_red_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_red where 0=1;

create table ${iol_schema}.isbs_red_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.isbs_red where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_red_cl(
            inr -- 内部唯一流水号，主键
            ,sptinr -- SPT表INR
            ,smhinr -- SMH表INR
            ,trninr -- TRN表INR
            ,pyeacc -- 收款人账号
            ,orcblk -- 汇款人信息
            ,pyeblk -- 收款人信息
            ,orcacc -- 汇款人账号
            ,flg -- 是否满足线上收汇确认条件标志
            ,inidattim -- 发起时间
            ,cur -- 汇入币种
            ,amt -- 汇入金额
            ,orcbanknam -- 汇款行名
            ,orcbic -- 汇款行BIC
            ,sndbic -- 发报行BIC
            ,dbusta -- 收款客户单位基本情况表报送标志
            ,goptyp -- 收款客户企业分类情况
            ,sigsta -- 收款客户交易门户签约标志
            ,pyeextkey -- 收款客户账号
            ,inftxt -- 摘要信息
            ,docoth103 -- 103报文路径
            ,docoth202 -- 202报文路径
            ,monnat -- 款项性质
            ,sta -- 交易状态
            ,imgnum -- 影像受理号
            ,boptxt -- 申报信息数据
            ,zjcflg -- 跨境资金池标识
            ,edtyp -- 资金池业务类型
            ,basamt -- 资金池业务本金
            ,intamt -- 资金池业务利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_red_op(
            inr -- 内部唯一流水号，主键
            ,sptinr -- SPT表INR
            ,smhinr -- SMH表INR
            ,trninr -- TRN表INR
            ,pyeacc -- 收款人账号
            ,orcblk -- 汇款人信息
            ,pyeblk -- 收款人信息
            ,orcacc -- 汇款人账号
            ,flg -- 是否满足线上收汇确认条件标志
            ,inidattim -- 发起时间
            ,cur -- 汇入币种
            ,amt -- 汇入金额
            ,orcbanknam -- 汇款行名
            ,orcbic -- 汇款行BIC
            ,sndbic -- 发报行BIC
            ,dbusta -- 收款客户单位基本情况表报送标志
            ,goptyp -- 收款客户企业分类情况
            ,sigsta -- 收款客户交易门户签约标志
            ,pyeextkey -- 收款客户账号
            ,inftxt -- 摘要信息
            ,docoth103 -- 103报文路径
            ,docoth202 -- 202报文路径
            ,monnat -- 款项性质
            ,sta -- 交易状态
            ,imgnum -- 影像受理号
            ,boptxt -- 申报信息数据
            ,zjcflg -- 跨境资金池标识
            ,edtyp -- 资金池业务类型
            ,basamt -- 资金池业务本金
            ,intamt -- 资金池业务利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.inr, o.inr) as inr -- 内部唯一流水号，主键
    ,nvl(n.sptinr, o.sptinr) as sptinr -- SPT表INR
    ,nvl(n.smhinr, o.smhinr) as smhinr -- SMH表INR
    ,nvl(n.trninr, o.trninr) as trninr -- TRN表INR
    ,nvl(n.pyeacc, o.pyeacc) as pyeacc -- 收款人账号
    ,nvl(n.orcblk, o.orcblk) as orcblk -- 汇款人信息
    ,nvl(n.pyeblk, o.pyeblk) as pyeblk -- 收款人信息
    ,nvl(n.orcacc, o.orcacc) as orcacc -- 汇款人账号
    ,nvl(n.flg, o.flg) as flg -- 是否满足线上收汇确认条件标志
    ,nvl(n.inidattim, o.inidattim) as inidattim -- 发起时间
    ,nvl(n.cur, o.cur) as cur -- 汇入币种
    ,nvl(n.amt, o.amt) as amt -- 汇入金额
    ,nvl(n.orcbanknam, o.orcbanknam) as orcbanknam -- 汇款行名
    ,nvl(n.orcbic, o.orcbic) as orcbic -- 汇款行BIC
    ,nvl(n.sndbic, o.sndbic) as sndbic -- 发报行BIC
    ,nvl(n.dbusta, o.dbusta) as dbusta -- 收款客户单位基本情况表报送标志
    ,nvl(n.goptyp, o.goptyp) as goptyp -- 收款客户企业分类情况
    ,nvl(n.sigsta, o.sigsta) as sigsta -- 收款客户交易门户签约标志
    ,nvl(n.pyeextkey, o.pyeextkey) as pyeextkey -- 收款客户账号
    ,nvl(n.inftxt, o.inftxt) as inftxt -- 摘要信息
    ,nvl(n.docoth103, o.docoth103) as docoth103 -- 103报文路径
    ,nvl(n.docoth202, o.docoth202) as docoth202 -- 202报文路径
    ,nvl(n.monnat, o.monnat) as monnat -- 款项性质
    ,nvl(n.sta, o.sta) as sta -- 交易状态
    ,nvl(n.imgnum, o.imgnum) as imgnum -- 影像受理号
    ,nvl(n.boptxt, o.boptxt) as boptxt -- 申报信息数据
    ,nvl(n.zjcflg, o.zjcflg) as zjcflg -- 跨境资金池标识
    ,nvl(n.edtyp, o.edtyp) as edtyp -- 资金池业务类型
    ,nvl(n.basamt, o.basamt) as basamt -- 资金池业务本金
    ,nvl(n.intamt, o.intamt) as intamt -- 资金池业务利息
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
from (select * from ${iol_schema}.isbs_red_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.isbs_red where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.inr = n.inr
where (
        o.inr is null
    )
    or (
        n.inr is null
    )
    or (
        o.sptinr <> n.sptinr
        or o.smhinr <> n.smhinr
        or o.trninr <> n.trninr
        or o.pyeacc <> n.pyeacc
        or o.orcblk <> n.orcblk
        or o.pyeblk <> n.pyeblk
        or o.orcacc <> n.orcacc
        or o.flg <> n.flg
        or o.inidattim <> n.inidattim
        or o.cur <> n.cur
        or o.amt <> n.amt
        or o.orcbanknam <> n.orcbanknam
        or o.orcbic <> n.orcbic
        or o.sndbic <> n.sndbic
        or o.dbusta <> n.dbusta
        or o.goptyp <> n.goptyp
        or o.sigsta <> n.sigsta
        or o.pyeextkey <> n.pyeextkey
        or o.inftxt <> n.inftxt
        or o.docoth103 <> n.docoth103
        or o.docoth202 <> n.docoth202
        or o.monnat <> n.monnat
        or o.sta <> n.sta
        or o.imgnum <> n.imgnum
        or o.boptxt <> n.boptxt
        or o.zjcflg <> n.zjcflg
        or o.edtyp <> n.edtyp
        or o.basamt <> n.basamt
        or o.intamt <> n.intamt
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.isbs_red_cl(
            inr -- 内部唯一流水号，主键
            ,sptinr -- SPT表INR
            ,smhinr -- SMH表INR
            ,trninr -- TRN表INR
            ,pyeacc -- 收款人账号
            ,orcblk -- 汇款人信息
            ,pyeblk -- 收款人信息
            ,orcacc -- 汇款人账号
            ,flg -- 是否满足线上收汇确认条件标志
            ,inidattim -- 发起时间
            ,cur -- 汇入币种
            ,amt -- 汇入金额
            ,orcbanknam -- 汇款行名
            ,orcbic -- 汇款行BIC
            ,sndbic -- 发报行BIC
            ,dbusta -- 收款客户单位基本情况表报送标志
            ,goptyp -- 收款客户企业分类情况
            ,sigsta -- 收款客户交易门户签约标志
            ,pyeextkey -- 收款客户账号
            ,inftxt -- 摘要信息
            ,docoth103 -- 103报文路径
            ,docoth202 -- 202报文路径
            ,monnat -- 款项性质
            ,sta -- 交易状态
            ,imgnum -- 影像受理号
            ,boptxt -- 申报信息数据
            ,zjcflg -- 跨境资金池标识
            ,edtyp -- 资金池业务类型
            ,basamt -- 资金池业务本金
            ,intamt -- 资金池业务利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.isbs_red_op(
            inr -- 内部唯一流水号，主键
            ,sptinr -- SPT表INR
            ,smhinr -- SMH表INR
            ,trninr -- TRN表INR
            ,pyeacc -- 收款人账号
            ,orcblk -- 汇款人信息
            ,pyeblk -- 收款人信息
            ,orcacc -- 汇款人账号
            ,flg -- 是否满足线上收汇确认条件标志
            ,inidattim -- 发起时间
            ,cur -- 汇入币种
            ,amt -- 汇入金额
            ,orcbanknam -- 汇款行名
            ,orcbic -- 汇款行BIC
            ,sndbic -- 发报行BIC
            ,dbusta -- 收款客户单位基本情况表报送标志
            ,goptyp -- 收款客户企业分类情况
            ,sigsta -- 收款客户交易门户签约标志
            ,pyeextkey -- 收款客户账号
            ,inftxt -- 摘要信息
            ,docoth103 -- 103报文路径
            ,docoth202 -- 202报文路径
            ,monnat -- 款项性质
            ,sta -- 交易状态
            ,imgnum -- 影像受理号
            ,boptxt -- 申报信息数据
            ,zjcflg -- 跨境资金池标识
            ,edtyp -- 资金池业务类型
            ,basamt -- 资金池业务本金
            ,intamt -- 资金池业务利息
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.inr -- 内部唯一流水号，主键
    ,o.sptinr -- SPT表INR
    ,o.smhinr -- SMH表INR
    ,o.trninr -- TRN表INR
    ,o.pyeacc -- 收款人账号
    ,o.orcblk -- 汇款人信息
    ,o.pyeblk -- 收款人信息
    ,o.orcacc -- 汇款人账号
    ,o.flg -- 是否满足线上收汇确认条件标志
    ,o.inidattim -- 发起时间
    ,o.cur -- 汇入币种
    ,o.amt -- 汇入金额
    ,o.orcbanknam -- 汇款行名
    ,o.orcbic -- 汇款行BIC
    ,o.sndbic -- 发报行BIC
    ,o.dbusta -- 收款客户单位基本情况表报送标志
    ,o.goptyp -- 收款客户企业分类情况
    ,o.sigsta -- 收款客户交易门户签约标志
    ,o.pyeextkey -- 收款客户账号
    ,o.inftxt -- 摘要信息
    ,o.docoth103 -- 103报文路径
    ,o.docoth202 -- 202报文路径
    ,o.monnat -- 款项性质
    ,o.sta -- 交易状态
    ,o.imgnum -- 影像受理号
    ,o.boptxt -- 申报信息数据
    ,o.zjcflg -- 跨境资金池标识
    ,o.edtyp -- 资金池业务类型
    ,o.basamt -- 资金池业务本金
    ,o.intamt -- 资金池业务利息
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.isbs_red_bk o
    left join ${iol_schema}.isbs_red_op n
        on
            o.inr = n.inr
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.isbs_red_cl d
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
-- truncate table ${iol_schema}.isbs_red;

-- 4.2 exchange partition
alter table ${iol_schema}.isbs_red exchange partition p_19000101 with table ${iol_schema}.isbs_red_cl;
alter table ${iol_schema}.isbs_red exchange partition p_20991231 with table ${iol_schema}.isbs_red_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.isbs_red to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.isbs_red_op purge;
drop table ${iol_schema}.isbs_red_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.isbs_red_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'isbs_red',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
