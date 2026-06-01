/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_openrepodeals
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
create table ${iol_schema}.ctms_tbs_v_openrepodeals_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_openrepodeals;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_openrepodeals_op purge;
drop table ${iol_schema}.ctms_tbs_v_openrepodeals_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_openrepodeals_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_openrepodeals where 0=1;

create table ${iol_schema}.ctms_tbs_v_openrepodeals_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_openrepodeals where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_openrepodeals_cl(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易序号
            ,portfolio_id -- 投组编号
            ,portfolio_name -- 投组名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账号名称
            ,currency -- 币种
            ,buyorsell -- 交易方向
            ,amount -- 首期金额
            ,trade_rate -- 回购利率
            ,ref_number -- 成交编号
            ,trade_date -- 交易日期
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,face_amount -- 券面总额
            ,first_price -- 首期净价
            ,maturity_price -- 到期净价
            ,maturity_amount -- 到期金额
            ,interest -- 应计利息
            ,cpty_id -- 交易对手ID
            ,cpty_name -- 交易对手名称
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员名称
            ,fee1 -- 首期费用
            ,tax_amt1 -- 首期税金
            ,broker_amt1 -- 首期佣金
            ,fee2 -- 到期费用
            ,tax_amt2 -- 到期税金
            ,broker_amt2 -- 到期佣金
            ,tradingfee -- 交易费
            ,settle_type -- 首期交割方式
            ,settle_type2 -- 到期交割方式
            ,source -- 交易来源
            ,cfets_from -- 是否是CFETS交易
            ,spot_v -- 近端连结面额
            ,fwd_v -- 远端连结面额
            ,cstp_req -- 是否需要连结原始交易
            ,keep_type -- 核算方法
            ,note -- 备注
            ,datasymbol_id -- 数据源ID
            ,lastmodified -- 最后修改时间
            ,openrepodeals_id_grand -- 原始交易ID
            ,dn_dealer -- 本币交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_openrepodeals_op(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易序号
            ,portfolio_id -- 投组编号
            ,portfolio_name -- 投组名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账号名称
            ,currency -- 币种
            ,buyorsell -- 交易方向
            ,amount -- 首期金额
            ,trade_rate -- 回购利率
            ,ref_number -- 成交编号
            ,trade_date -- 交易日期
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,face_amount -- 券面总额
            ,first_price -- 首期净价
            ,maturity_price -- 到期净价
            ,maturity_amount -- 到期金额
            ,interest -- 应计利息
            ,cpty_id -- 交易对手ID
            ,cpty_name -- 交易对手名称
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员名称
            ,fee1 -- 首期费用
            ,tax_amt1 -- 首期税金
            ,broker_amt1 -- 首期佣金
            ,fee2 -- 到期费用
            ,tax_amt2 -- 到期税金
            ,broker_amt2 -- 到期佣金
            ,tradingfee -- 交易费
            ,settle_type -- 首期交割方式
            ,settle_type2 -- 到期交割方式
            ,source -- 交易来源
            ,cfets_from -- 是否是CFETS交易
            ,spot_v -- 近端连结面额
            ,fwd_v -- 远端连结面额
            ,cstp_req -- 是否需要连结原始交易
            ,keep_type -- 核算方法
            ,note -- 备注
            ,datasymbol_id -- 数据源ID
            ,lastmodified -- 最后修改时间
            ,openrepodeals_id_grand -- 原始交易ID
            ,dn_dealer -- 本币交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表ID
    ,nvl(n.deal_tablename, o.deal_tablename) as deal_tablename -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易序号
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 投组编号
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 投组名称
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账号名称
    ,nvl(n.currency, o.currency) as currency -- 币种
    ,nvl(n.buyorsell, o.buyorsell) as buyorsell -- 交易方向
    ,nvl(n.amount, o.amount) as amount -- 首期金额
    ,nvl(n.trade_rate, o.trade_rate) as trade_rate -- 回购利率
    ,nvl(n.ref_number, o.ref_number) as ref_number -- 成交编号
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 交易日期
    ,nvl(n.value_date, o.value_date) as value_date -- 首期交割日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期交割日
    ,nvl(n.bondscode, o.bondscode) as bondscode -- 债券代码
    ,nvl(n.bondsname, o.bondsname) as bondsname -- 债券名称
    ,nvl(n.face_amount, o.face_amount) as face_amount -- 券面总额
    ,nvl(n.first_price, o.first_price) as first_price -- 首期净价
    ,nvl(n.maturity_price, o.maturity_price) as maturity_price -- 到期净价
    ,nvl(n.maturity_amount, o.maturity_amount) as maturity_amount -- 到期金额
    ,nvl(n.interest, o.interest) as interest -- 应计利息
    ,nvl(n.cpty_id, o.cpty_id) as cpty_id -- 交易对手ID
    ,nvl(n.cpty_name, o.cpty_name) as cpty_name -- 交易对手名称
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员ID
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员名称
    ,nvl(n.fee1, o.fee1) as fee1 -- 首期费用
    ,nvl(n.tax_amt1, o.tax_amt1) as tax_amt1 -- 首期税金
    ,nvl(n.broker_amt1, o.broker_amt1) as broker_amt1 -- 首期佣金
    ,nvl(n.fee2, o.fee2) as fee2 -- 到期费用
    ,nvl(n.tax_amt2, o.tax_amt2) as tax_amt2 -- 到期税金
    ,nvl(n.broker_amt2, o.broker_amt2) as broker_amt2 -- 到期佣金
    ,nvl(n.tradingfee, o.tradingfee) as tradingfee -- 交易费
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 首期交割方式
    ,nvl(n.settle_type2, o.settle_type2) as settle_type2 -- 到期交割方式
    ,nvl(n.source, o.source) as source -- 交易来源
    ,nvl(n.cfets_from, o.cfets_from) as cfets_from -- 是否是CFETS交易
    ,nvl(n.spot_v, o.spot_v) as spot_v -- 近端连结面额
    ,nvl(n.fwd_v, o.fwd_v) as fwd_v -- 远端连结面额
    ,nvl(n.cstp_req, o.cstp_req) as cstp_req -- 是否需要连结原始交易
    ,nvl(n.keep_type, o.keep_type) as keep_type -- 核算方法
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 数据源ID
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.openrepodeals_id_grand, o.openrepodeals_id_grand) as openrepodeals_id_grand -- 原始交易ID
    ,nvl(n.dn_dealer, o.dn_dealer) as dn_dealer -- 本币交易员
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
from (select * from ${iol_schema}.ctms_tbs_v_openrepodeals_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_openrepodeals where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.serial_number <> n.serial_number
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.currency <> n.currency
        or o.buyorsell <> n.buyorsell
        or o.amount <> n.amount
        or o.trade_rate <> n.trade_rate
        or o.ref_number <> n.ref_number
        or o.trade_date <> n.trade_date
        or o.value_date <> n.value_date
        or o.maturity_date <> n.maturity_date
        or o.bondscode <> n.bondscode
        or o.bondsname <> n.bondsname
        or o.face_amount <> n.face_amount
        or o.first_price <> n.first_price
        or o.maturity_price <> n.maturity_price
        or o.maturity_amount <> n.maturity_amount
        or o.interest <> n.interest
        or o.cpty_id <> n.cpty_id
        or o.cpty_name <> n.cpty_name
        or o.dealer_id <> n.dealer_id
        or o.dealer_name <> n.dealer_name
        or o.fee1 <> n.fee1
        or o.tax_amt1 <> n.tax_amt1
        or o.broker_amt1 <> n.broker_amt1
        or o.fee2 <> n.fee2
        or o.tax_amt2 <> n.tax_amt2
        or o.broker_amt2 <> n.broker_amt2
        or o.tradingfee <> n.tradingfee
        or o.settle_type <> n.settle_type
        or o.settle_type2 <> n.settle_type2
        or o.source <> n.source
        or o.cfets_from <> n.cfets_from
        or o.spot_v <> n.spot_v
        or o.fwd_v <> n.fwd_v
        or o.cstp_req <> n.cstp_req
        or o.keep_type <> n.keep_type
        or o.note <> n.note
        or o.datasymbol_id <> n.datasymbol_id
        or o.lastmodified <> n.lastmodified
        or o.openrepodeals_id_grand <> n.openrepodeals_id_grand
        or o.dn_dealer <> n.dn_dealer
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_openrepodeals_cl(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易序号
            ,portfolio_id -- 投组编号
            ,portfolio_name -- 投组名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账号名称
            ,currency -- 币种
            ,buyorsell -- 交易方向
            ,amount -- 首期金额
            ,trade_rate -- 回购利率
            ,ref_number -- 成交编号
            ,trade_date -- 交易日期
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,face_amount -- 券面总额
            ,first_price -- 首期净价
            ,maturity_price -- 到期净价
            ,maturity_amount -- 到期金额
            ,interest -- 应计利息
            ,cpty_id -- 交易对手ID
            ,cpty_name -- 交易对手名称
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员名称
            ,fee1 -- 首期费用
            ,tax_amt1 -- 首期税金
            ,broker_amt1 -- 首期佣金
            ,fee2 -- 到期费用
            ,tax_amt2 -- 到期税金
            ,broker_amt2 -- 到期佣金
            ,tradingfee -- 交易费
            ,settle_type -- 首期交割方式
            ,settle_type2 -- 到期交割方式
            ,source -- 交易来源
            ,cfets_from -- 是否是CFETS交易
            ,spot_v -- 近端连结面额
            ,fwd_v -- 远端连结面额
            ,cstp_req -- 是否需要连结原始交易
            ,keep_type -- 核算方法
            ,note -- 备注
            ,datasymbol_id -- 数据源ID
            ,lastmodified -- 最后修改时间
            ,openrepodeals_id_grand -- 原始交易ID
            ,dn_dealer -- 本币交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_openrepodeals_op(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易序号
            ,portfolio_id -- 投组编号
            ,portfolio_name -- 投组名称
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账号名称
            ,currency -- 币种
            ,buyorsell -- 交易方向
            ,amount -- 首期金额
            ,trade_rate -- 回购利率
            ,ref_number -- 成交编号
            ,trade_date -- 交易日期
            ,value_date -- 首期交割日
            ,maturity_date -- 到期交割日
            ,bondscode -- 债券代码
            ,bondsname -- 债券名称
            ,face_amount -- 券面总额
            ,first_price -- 首期净价
            ,maturity_price -- 到期净价
            ,maturity_amount -- 到期金额
            ,interest -- 应计利息
            ,cpty_id -- 交易对手ID
            ,cpty_name -- 交易对手名称
            ,dealer_id -- 交易员ID
            ,dealer_name -- 交易员名称
            ,fee1 -- 首期费用
            ,tax_amt1 -- 首期税金
            ,broker_amt1 -- 首期佣金
            ,fee2 -- 到期费用
            ,tax_amt2 -- 到期税金
            ,broker_amt2 -- 到期佣金
            ,tradingfee -- 交易费
            ,settle_type -- 首期交割方式
            ,settle_type2 -- 到期交割方式
            ,source -- 交易来源
            ,cfets_from -- 是否是CFETS交易
            ,spot_v -- 近端连结面额
            ,fwd_v -- 远端连结面额
            ,cstp_req -- 是否需要连结原始交易
            ,keep_type -- 核算方法
            ,note -- 备注
            ,datasymbol_id -- 数据源ID
            ,lastmodified -- 最后修改时间
            ,openrepodeals_id_grand -- 原始交易ID
            ,dn_dealer -- 本币交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表ID
    ,o.deal_tablename -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.serial_number -- 交易序号
    ,o.portfolio_id -- 投组编号
    ,o.portfolio_name -- 投组名称
    ,o.keepfolder_id -- 账户ID
    ,o.keepfolder_shortname -- 账号名称
    ,o.currency -- 币种
    ,o.buyorsell -- 交易方向
    ,o.amount -- 首期金额
    ,o.trade_rate -- 回购利率
    ,o.ref_number -- 成交编号
    ,o.trade_date -- 交易日期
    ,o.value_date -- 首期交割日
    ,o.maturity_date -- 到期交割日
    ,o.bondscode -- 债券代码
    ,o.bondsname -- 债券名称
    ,o.face_amount -- 券面总额
    ,o.first_price -- 首期净价
    ,o.maturity_price -- 到期净价
    ,o.maturity_amount -- 到期金额
    ,o.interest -- 应计利息
    ,o.cpty_id -- 交易对手ID
    ,o.cpty_name -- 交易对手名称
    ,o.dealer_id -- 交易员ID
    ,o.dealer_name -- 交易员名称
    ,o.fee1 -- 首期费用
    ,o.tax_amt1 -- 首期税金
    ,o.broker_amt1 -- 首期佣金
    ,o.fee2 -- 到期费用
    ,o.tax_amt2 -- 到期税金
    ,o.broker_amt2 -- 到期佣金
    ,o.tradingfee -- 交易费
    ,o.settle_type -- 首期交割方式
    ,o.settle_type2 -- 到期交割方式
    ,o.source -- 交易来源
    ,o.cfets_from -- 是否是CFETS交易
    ,o.spot_v -- 近端连结面额
    ,o.fwd_v -- 远端连结面额
    ,o.cstp_req -- 是否需要连结原始交易
    ,o.keep_type -- 核算方法
    ,o.note -- 备注
    ,o.datasymbol_id -- 数据源ID
    ,o.lastmodified -- 最后修改时间
    ,o.openrepodeals_id_grand -- 原始交易ID
    ,o.dn_dealer -- 本币交易员
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_openrepodeals_bk o
    left join ${iol_schema}.ctms_tbs_v_openrepodeals_op n
        on
            o.deal_id = n.deal_id
            and o.deal_tablename = n.deal_tablename
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_openrepodeals_cl d
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
-- truncate table ${iol_schema}.ctms_tbs_v_openrepodeals;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_openrepodeals exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_openrepodeals_cl;
alter table ${iol_schema}.ctms_tbs_v_openrepodeals exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_openrepodeals_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_openrepodeals to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_openrepodeals_op purge;
drop table ${iol_schema}.ctms_tbs_v_openrepodeals_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_openrepodeals_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_openrepodeals',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
