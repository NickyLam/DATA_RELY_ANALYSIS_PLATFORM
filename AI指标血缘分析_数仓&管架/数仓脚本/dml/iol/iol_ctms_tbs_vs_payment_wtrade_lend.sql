/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_payment_wtrade_lend
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
create table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend where 0=1;

create table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_cl(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 质押券代码
            ,lendbondscode -- 标的券代码
            ,serial_number -- 交易号
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,face_amount -- 质押券面额
            ,trade_time -- 交易时间
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手ID
            ,settle_type -- 首期结算方式
            ,settle_type2 -- 到期结算方式
            ,dealer -- 交易员ID
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是CFETS交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,trade_rate -- 借贷费率
            ,lend_days -- 借贷天数
            ,wtrade_lend_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,day_count -- 日计息基准
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_op(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 质押券代码
            ,lendbondscode -- 标的券代码
            ,serial_number -- 交易号
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,face_amount -- 质押券面额
            ,trade_time -- 交易时间
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手ID
            ,settle_type -- 首期结算方式
            ,settle_type2 -- 到期结算方式
            ,dealer -- 交易员ID
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是CFETS交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,trade_rate -- 借贷费率
            ,lend_days -- 借贷天数
            ,wtrade_lend_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,day_count -- 日计息基准
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表ID
    ,nvl(n.deal_tablename, o.deal_tablename) as deal_tablename -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.bondscode, o.bondscode) as bondscode -- 质押券代码
    ,nvl(n.lendbondscode, o.lendbondscode) as lendbondscode -- 标的券代码
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易号
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 首期交易日
    ,nvl(n.value_date, o.value_date) as value_date -- 首期交割日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期交割日
    ,nvl(n.buyorsell, o.buyorsell) as buyorsell -- 交易方向
    ,nvl(n.face_amount, o.face_amount) as face_amount -- 质押券面额
    ,nvl(n.trade_time, o.trade_time) as trade_time -- 交易时间
    ,nvl(n.amount, o.amount) as amount -- 首期结算金额
    ,nvl(n.maturity_amount, o.maturity_amount) as maturity_amount -- 到期结算金额
    ,nvl(n.fee, o.fee) as fee -- 首期费用
    ,nvl(n.tax_amt, o.tax_amt) as tax_amt -- 首期税金
    ,nvl(n.broker_amt, o.broker_amt) as broker_amt -- 首期佣金
    ,nvl(n.interest, o.interest) as interest -- 应计利息
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 交易组别
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 交易组别名称
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户名称
    ,nvl(n.cptys_short_name, o.cptys_short_name) as cptys_short_name -- 交易对手名
    ,nvl(n.cptys_id, o.cptys_id) as cptys_id -- 交易对手ID
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 首期结算方式
    ,nvl(n.settle_type2, o.settle_type2) as settle_type2 -- 到期结算方式
    ,nvl(n.dealer, o.dealer) as dealer -- 交易员ID
    ,nvl(n.ref_number, o.ref_number) as ref_number -- 成交编号
    ,nvl(n.cfets_from, o.cfets_from) as cfets_from -- 是否是CFETS交易
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 数据源ID
    ,nvl(n.trade_rate, o.trade_rate) as trade_rate -- 借贷费率
    ,nvl(n.lend_days, o.lend_days) as lend_days -- 借贷天数
    ,nvl(n.wtrade_lend_id_grand, o.wtrade_lend_id_grand) as wtrade_lend_id_grand -- 原始交易ID
    ,nvl(n.lastmodified_pay, o.lastmodified_pay) as lastmodified_pay -- 实收付确认的修改时间
    ,nvl(n.day_count, o.day_count) as day_count -- 日计息基准
    ,nvl(n.dn_dealer, o.dn_dealer) as dn_dealer -- 本币交易员
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员名称
    ,nvl(n.status, o.status) as status -- 状态
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deal_id is null
            and n.deal_tablename is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_payment_wtrade_lend where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deal_id = n.deal_id
            and o.deal_tablename = n.deal_tablename
where (
        o.deal_id is null
        and o.deal_tablename is null
    )
    or (
        n.deal_id is null
        and n.deal_tablename is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.bondscode <> n.bondscode
        or o.lendbondscode <> n.lendbondscode
        or o.serial_number <> n.serial_number
        or o.trade_date <> n.trade_date
        or o.value_date <> n.value_date
        or o.maturity_date <> n.maturity_date
        or o.buyorsell <> n.buyorsell
        or o.face_amount <> n.face_amount
        or o.trade_time <> n.trade_time
        or o.amount <> n.amount
        or o.maturity_amount <> n.maturity_amount
        or o.fee <> n.fee
        or o.tax_amt <> n.tax_amt
        or o.broker_amt <> n.broker_amt
        or o.interest <> n.interest
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.cptys_short_name <> n.cptys_short_name
        or o.cptys_id <> n.cptys_id
        or o.settle_type <> n.settle_type
        or o.settle_type2 <> n.settle_type2
        or o.dealer <> n.dealer
        or o.ref_number <> n.ref_number
        or o.cfets_from <> n.cfets_from
        or o.lastmodified <> n.lastmodified
        or o.datasymbol_id <> n.datasymbol_id
        or o.trade_rate <> n.trade_rate
        or o.lend_days <> n.lend_days
        or o.wtrade_lend_id_grand <> n.wtrade_lend_id_grand
        or o.lastmodified_pay <> n.lastmodified_pay
        or o.day_count <> n.day_count
        or o.dn_dealer <> n.dn_dealer
        or o.dealer_name <> n.dealer_name
        or o.status <> n.status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_cl(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 质押券代码
            ,lendbondscode -- 标的券代码
            ,serial_number -- 交易号
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,face_amount -- 质押券面额
            ,trade_time -- 交易时间
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手ID
            ,settle_type -- 首期结算方式
            ,settle_type2 -- 到期结算方式
            ,dealer -- 交易员ID
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是CFETS交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,trade_rate -- 借贷费率
            ,lend_days -- 借贷天数
            ,wtrade_lend_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,day_count -- 日计息基准
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_op(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,bondscode -- 质押券代码
            ,lendbondscode -- 标的券代码
            ,serial_number -- 交易号
            ,trade_date -- 首期交易日
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,buyorsell -- 交易方向
            ,face_amount -- 质押券面额
            ,trade_time -- 交易时间
            ,amount -- 首期结算金额
            ,maturity_amount -- 到期结算金额
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手ID
            ,settle_type -- 首期结算方式
            ,settle_type2 -- 到期结算方式
            ,dealer -- 交易员ID
            ,ref_number -- 成交编号
            ,cfets_from -- 是否是CFETS交易
            ,lastmodified -- 最后修改时间
            ,datasymbol_id -- 数据源ID
            ,trade_rate -- 借贷费率
            ,lend_days -- 借贷天数
            ,wtrade_lend_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,day_count -- 日计息基准
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表ID
    ,o.deal_tablename -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.bondscode -- 质押券代码
    ,o.lendbondscode -- 标的券代码
    ,o.serial_number -- 交易号
    ,o.trade_date -- 首期交易日
    ,o.value_date -- 首期交割日
    ,o.maturity_date -- 到期交割日
    ,o.buyorsell -- 交易方向
    ,o.face_amount -- 质押券面额
    ,o.trade_time -- 交易时间
    ,o.amount -- 首期结算金额
    ,o.maturity_amount -- 到期结算金额
    ,o.fee -- 首期费用
    ,o.tax_amt -- 首期税金
    ,o.broker_amt -- 首期佣金
    ,o.interest -- 应计利息
    ,o.portfolio_id -- 交易组别
    ,o.portfolio_name -- 交易组别名称
    ,o.keepfolder_id -- 账户ID
    ,o.keepfolder_shortname -- 账户名称
    ,o.cptys_short_name -- 交易对手名
    ,o.cptys_id -- 交易对手ID
    ,o.settle_type -- 首期结算方式
    ,o.settle_type2 -- 到期结算方式
    ,o.dealer -- 交易员ID
    ,o.ref_number -- 成交编号
    ,o.cfets_from -- 是否是CFETS交易
    ,o.lastmodified -- 最后修改时间
    ,o.datasymbol_id -- 数据源ID
    ,o.trade_rate -- 借贷费率
    ,o.lend_days -- 借贷天数
    ,o.wtrade_lend_id_grand -- 原始交易ID
    ,o.lastmodified_pay -- 实收付确认的修改时间
    ,o.day_count -- 日计息基准
    ,o.dn_dealer -- 本币交易员
    ,o.dealer_name -- 交易员名称
    ,o.status -- 状态
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_bk o
    left join ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_op n
        on
            o.deal_id = n.deal_id
            and o.deal_tablename = n.deal_tablename
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_cl d
        on
            o.deal_id = d.deal_id
            and o.deal_tablename = d.deal_tablename
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_cl;
alter table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_payment_wtrade_lend_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_payment_wtrade_lend',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
