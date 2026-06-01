/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_wtrade_underwrite
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
create table ${iol_schema}.ctms_tbs_v_wtrade_underwrite_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_wtrade_underwrite;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_wtrade_underwrite_op purge;
drop table ${iol_schema}.ctms_tbs_v_wtrade_underwrite_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_wtrade_underwrite_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_wtrade_underwrite where 0=1;

create table ${iol_schema}.ctms_tbs_v_wtrade_underwrite_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_wtrade_underwrite where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_wtrade_underwrite_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,ref_number -- 成交编号
            ,currency -- 交易币别
            ,trade_date -- 交易日
            ,value_date -- 交割日
            ,security_code -- 债券代码
            ,bondsname -- 债券名称
            ,amount -- 交易面额
            ,settle_amt -- 成交金额
            ,price -- 承分销价
            ,uw_fee_rate -- 承销手续费率
            ,note -- 备注
            ,trade_type -- 交易类型
            ,sell_portfolio -- 转自营投组ID
            ,sell_portfolio_name -- 转自营投组名称
            ,security_trade_no -- 交易的现券表交易单号(SERIAL_NUMBER)
            ,fee -- 手续费
            ,tax_amt -- 税金
            ,broker_amt -- 佣金
            ,uw_buy_no -- 附属交易对应承销买入主交易的单号（SERIAL_NUMBER）
            ,uw_buy_id -- 附属交易对应承销买入主交易的单号（DEAL_ID）
            ,valid_source_sn -- 审批单号
            ,cancel_reason -- 撤销原因
            ,uw_price -- 分销卖出对应承销买入的价格
            ,cfets_from -- 是否场内交易
            ,review_status -- 复核状态(前台)
            ,review_user_id -- 复核人员ID
            ,review_user_name -- 复核人员名称
            ,review_time -- 复核日期
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,lastmodified -- 最近更新时间
            ,counterparty_seq -- comstar交易对手序号
            ,counterparty_short_cname -- 交易对手
            ,security_trade_id -- 交易的现券表ID号(DEAL_ID)
            ,trading_fee -- 交易费用
            ,fee_return -- 返还手续费
            ,fee_date -- 手续费划付日
            ,return_rate -- 手续费返还比例
            ,fx_price -- 分销价
            ,fee_type -- 手续费类型
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_wtrade_underwrite_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,ref_number -- 成交编号
            ,currency -- 交易币别
            ,trade_date -- 交易日
            ,value_date -- 交割日
            ,security_code -- 债券代码
            ,bondsname -- 债券名称
            ,amount -- 交易面额
            ,settle_amt -- 成交金额
            ,price -- 承分销价
            ,uw_fee_rate -- 承销手续费率
            ,note -- 备注
            ,trade_type -- 交易类型
            ,sell_portfolio -- 转自营投组ID
            ,sell_portfolio_name -- 转自营投组名称
            ,security_trade_no -- 交易的现券表交易单号(SERIAL_NUMBER)
            ,fee -- 手续费
            ,tax_amt -- 税金
            ,broker_amt -- 佣金
            ,uw_buy_no -- 附属交易对应承销买入主交易的单号（SERIAL_NUMBER）
            ,uw_buy_id -- 附属交易对应承销买入主交易的单号（DEAL_ID）
            ,valid_source_sn -- 审批单号
            ,cancel_reason -- 撤销原因
            ,uw_price -- 分销卖出对应承销买入的价格
            ,cfets_from -- 是否场内交易
            ,review_status -- 复核状态(前台)
            ,review_user_id -- 复核人员ID
            ,review_user_name -- 复核人员名称
            ,review_time -- 复核日期
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,lastmodified -- 最近更新时间
            ,counterparty_seq -- comstar交易对手序号
            ,counterparty_short_cname -- 交易对手
            ,security_trade_id -- 交易的现券表ID号(DEAL_ID)
            ,trading_fee -- 交易费用
            ,fee_return -- 返还手续费
            ,fee_date -- 手续费划付日
            ,return_rate -- 手续费返还比例
            ,fx_price -- 分销价
            ,fee_type -- 手续费类型
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表ID
    ,nvl(n.deal_name, o.deal_name) as deal_name -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 交易组别
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 交易组别名称
    ,nvl(n.cpty_name, o.cpty_name) as cpty_name -- 交易对手
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户名称
    ,nvl(n.ref_number, o.ref_number) as ref_number -- 成交编号
    ,nvl(n.currency, o.currency) as currency -- 交易币别
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 交易日
    ,nvl(n.value_date, o.value_date) as value_date -- 交割日
    ,nvl(n.security_code, o.security_code) as security_code -- 债券代码
    ,nvl(n.bondsname, o.bondsname) as bondsname -- 债券名称
    ,nvl(n.amount, o.amount) as amount -- 交易面额
    ,nvl(n.settle_amt, o.settle_amt) as settle_amt -- 成交金额
    ,nvl(n.price, o.price) as price -- 承分销价
    ,nvl(n.uw_fee_rate, o.uw_fee_rate) as uw_fee_rate -- 承销手续费率
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.trade_type, o.trade_type) as trade_type -- 交易类型
    ,nvl(n.sell_portfolio, o.sell_portfolio) as sell_portfolio -- 转自营投组ID
    ,nvl(n.sell_portfolio_name, o.sell_portfolio_name) as sell_portfolio_name -- 转自营投组名称
    ,nvl(n.security_trade_no, o.security_trade_no) as security_trade_no -- 交易的现券表交易单号(SERIAL_NUMBER)
    ,nvl(n.fee, o.fee) as fee -- 手续费
    ,nvl(n.tax_amt, o.tax_amt) as tax_amt -- 税金
    ,nvl(n.broker_amt, o.broker_amt) as broker_amt -- 佣金
    ,nvl(n.uw_buy_no, o.uw_buy_no) as uw_buy_no -- 附属交易对应承销买入主交易的单号（SERIAL_NUMBER）
    ,nvl(n.uw_buy_id, o.uw_buy_id) as uw_buy_id -- 附属交易对应承销买入主交易的单号（DEAL_ID）
    ,nvl(n.valid_source_sn, o.valid_source_sn) as valid_source_sn -- 审批单号
    ,nvl(n.cancel_reason, o.cancel_reason) as cancel_reason -- 撤销原因
    ,nvl(n.uw_price, o.uw_price) as uw_price -- 分销卖出对应承销买入的价格
    ,nvl(n.cfets_from, o.cfets_from) as cfets_from -- 是否场内交易
    ,nvl(n.review_status, o.review_status) as review_status -- 复核状态(前台)
    ,nvl(n.review_user_id, o.review_user_id) as review_user_id -- 复核人员ID
    ,nvl(n.review_user_name, o.review_user_name) as review_user_name -- 复核人员名称
    ,nvl(n.review_time, o.review_time) as review_time -- 复核日期
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易序号
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员ID
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最近更新时间
    ,nvl(n.counterparty_seq, o.counterparty_seq) as counterparty_seq -- comstar交易对手序号
    ,nvl(n.counterparty_short_cname, o.counterparty_short_cname) as counterparty_short_cname -- 交易对手
    ,nvl(n.security_trade_id, o.security_trade_id) as security_trade_id -- 交易的现券表ID号(DEAL_ID)
    ,nvl(n.trading_fee, o.trading_fee) as trading_fee -- 交易费用
    ,nvl(n.fee_return, o.fee_return) as fee_return -- 返还手续费
    ,nvl(n.fee_date, o.fee_date) as fee_date -- 手续费划付日
    ,nvl(n.return_rate, o.return_rate) as return_rate -- 手续费返还比例
    ,nvl(n.fx_price, o.fx_price) as fx_price -- 分销价
    ,nvl(n.fee_type, o.fee_type) as fee_type -- 手续费类型
    ,nvl(n.dn_dealer, o.dn_dealer) as dn_dealer -- 本币交易员
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员名称
    ,case when
            n.deal_id is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deal_id is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deal_id is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_wtrade_underwrite_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_wtrade_underwrite where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deal_id = n.deal_id
where (
        o.deal_id is null
    )
    or (
        n.deal_id is null
    )
    or (
        o.deal_name <> n.deal_name
        or o.aspclient_id <> n.aspclient_id
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.cpty_name <> n.cpty_name
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.ref_number <> n.ref_number
        or o.currency <> n.currency
        or o.trade_date <> n.trade_date
        or o.value_date <> n.value_date
        or o.security_code <> n.security_code
        or o.bondsname <> n.bondsname
        or o.amount <> n.amount
        or o.settle_amt <> n.settle_amt
        or o.price <> n.price
        or o.uw_fee_rate <> n.uw_fee_rate
        or o.note <> n.note
        or o.trade_type <> n.trade_type
        or o.sell_portfolio <> n.sell_portfolio
        or o.sell_portfolio_name <> n.sell_portfolio_name
        or o.security_trade_no <> n.security_trade_no
        or o.fee <> n.fee
        or o.tax_amt <> n.tax_amt
        or o.broker_amt <> n.broker_amt
        or o.uw_buy_no <> n.uw_buy_no
        or o.uw_buy_id <> n.uw_buy_id
        or o.valid_source_sn <> n.valid_source_sn
        or o.cancel_reason <> n.cancel_reason
        or o.uw_price <> n.uw_price
        or o.cfets_from <> n.cfets_from
        or o.review_status <> n.review_status
        or o.review_user_id <> n.review_user_id
        or o.review_user_name <> n.review_user_name
        or o.review_time <> n.review_time
        or o.serial_number <> n.serial_number
        or o.dealer_id <> n.dealer_id
        or o.lastmodified <> n.lastmodified
        or o.counterparty_seq <> n.counterparty_seq
        or o.counterparty_short_cname <> n.counterparty_short_cname
        or o.security_trade_id <> n.security_trade_id
        or o.trading_fee <> n.trading_fee
        or o.fee_return <> n.fee_return
        or o.fee_date <> n.fee_date
        or o.return_rate <> n.return_rate
        or o.fx_price <> n.fx_price
        or o.fee_type <> n.fee_type
        or o.dn_dealer <> n.dn_dealer
        or o.dealer_name <> n.dealer_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_wtrade_underwrite_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,ref_number -- 成交编号
            ,currency -- 交易币别
            ,trade_date -- 交易日
            ,value_date -- 交割日
            ,security_code -- 债券代码
            ,bondsname -- 债券名称
            ,amount -- 交易面额
            ,settle_amt -- 成交金额
            ,price -- 承分销价
            ,uw_fee_rate -- 承销手续费率
            ,note -- 备注
            ,trade_type -- 交易类型
            ,sell_portfolio -- 转自营投组ID
            ,sell_portfolio_name -- 转自营投组名称
            ,security_trade_no -- 交易的现券表交易单号(SERIAL_NUMBER)
            ,fee -- 手续费
            ,tax_amt -- 税金
            ,broker_amt -- 佣金
            ,uw_buy_no -- 附属交易对应承销买入主交易的单号（SERIAL_NUMBER）
            ,uw_buy_id -- 附属交易对应承销买入主交易的单号（DEAL_ID）
            ,valid_source_sn -- 审批单号
            ,cancel_reason -- 撤销原因
            ,uw_price -- 分销卖出对应承销买入的价格
            ,cfets_from -- 是否场内交易
            ,review_status -- 复核状态(前台)
            ,review_user_id -- 复核人员ID
            ,review_user_name -- 复核人员名称
            ,review_time -- 复核日期
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,lastmodified -- 最近更新时间
            ,counterparty_seq -- comstar交易对手序号
            ,counterparty_short_cname -- 交易对手
            ,security_trade_id -- 交易的现券表ID号(DEAL_ID)
            ,trading_fee -- 交易费用
            ,fee_return -- 返还手续费
            ,fee_date -- 手续费划付日
            ,return_rate -- 手续费返还比例
            ,fx_price -- 分销价
            ,fee_type -- 手续费类型
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_wtrade_underwrite_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,ref_number -- 成交编号
            ,currency -- 交易币别
            ,trade_date -- 交易日
            ,value_date -- 交割日
            ,security_code -- 债券代码
            ,bondsname -- 债券名称
            ,amount -- 交易面额
            ,settle_amt -- 成交金额
            ,price -- 承分销价
            ,uw_fee_rate -- 承销手续费率
            ,note -- 备注
            ,trade_type -- 交易类型
            ,sell_portfolio -- 转自营投组ID
            ,sell_portfolio_name -- 转自营投组名称
            ,security_trade_no -- 交易的现券表交易单号(SERIAL_NUMBER)
            ,fee -- 手续费
            ,tax_amt -- 税金
            ,broker_amt -- 佣金
            ,uw_buy_no -- 附属交易对应承销买入主交易的单号（SERIAL_NUMBER）
            ,uw_buy_id -- 附属交易对应承销买入主交易的单号（DEAL_ID）
            ,valid_source_sn -- 审批单号
            ,cancel_reason -- 撤销原因
            ,uw_price -- 分销卖出对应承销买入的价格
            ,cfets_from -- 是否场内交易
            ,review_status -- 复核状态(前台)
            ,review_user_id -- 复核人员ID
            ,review_user_name -- 复核人员名称
            ,review_time -- 复核日期
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,lastmodified -- 最近更新时间
            ,counterparty_seq -- comstar交易对手序号
            ,counterparty_short_cname -- 交易对手
            ,security_trade_id -- 交易的现券表ID号(DEAL_ID)
            ,trading_fee -- 交易费用
            ,fee_return -- 返还手续费
            ,fee_date -- 手续费划付日
            ,return_rate -- 手续费返还比例
            ,fx_price -- 分销价
            ,fee_type -- 手续费类型
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表ID
    ,o.deal_name -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.portfolio_id -- 交易组别
    ,o.portfolio_name -- 交易组别名称
    ,o.cpty_name -- 交易对手
    ,o.keepfolder_id -- 账户ID
    ,o.keepfolder_shortname -- 账户名称
    ,o.ref_number -- 成交编号
    ,o.currency -- 交易币别
    ,o.trade_date -- 交易日
    ,o.value_date -- 交割日
    ,o.security_code -- 债券代码
    ,o.bondsname -- 债券名称
    ,o.amount -- 交易面额
    ,o.settle_amt -- 成交金额
    ,o.price -- 承分销价
    ,o.uw_fee_rate -- 承销手续费率
    ,o.note -- 备注
    ,o.trade_type -- 交易类型
    ,o.sell_portfolio -- 转自营投组ID
    ,o.sell_portfolio_name -- 转自营投组名称
    ,o.security_trade_no -- 交易的现券表交易单号(SERIAL_NUMBER)
    ,o.fee -- 手续费
    ,o.tax_amt -- 税金
    ,o.broker_amt -- 佣金
    ,o.uw_buy_no -- 附属交易对应承销买入主交易的单号（SERIAL_NUMBER）
    ,o.uw_buy_id -- 附属交易对应承销买入主交易的单号（DEAL_ID）
    ,o.valid_source_sn -- 审批单号
    ,o.cancel_reason -- 撤销原因
    ,o.uw_price -- 分销卖出对应承销买入的价格
    ,o.cfets_from -- 是否场内交易
    ,o.review_status -- 复核状态(前台)
    ,o.review_user_id -- 复核人员ID
    ,o.review_user_name -- 复核人员名称
    ,o.review_time -- 复核日期
    ,o.serial_number -- 交易序号
    ,o.dealer_id -- 交易员ID
    ,o.lastmodified -- 最近更新时间
    ,o.counterparty_seq -- comstar交易对手序号
    ,o.counterparty_short_cname -- 交易对手
    ,o.security_trade_id -- 交易的现券表ID号(DEAL_ID)
    ,o.trading_fee -- 交易费用
    ,o.fee_return -- 返还手续费
    ,o.fee_date -- 手续费划付日
    ,o.return_rate -- 手续费返还比例
    ,o.fx_price -- 分销价
    ,o.fee_type -- 手续费类型
    ,o.dn_dealer -- 本币交易员
    ,o.dealer_name -- 交易员名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_wtrade_underwrite_bk o
    left join ${iol_schema}.ctms_tbs_v_wtrade_underwrite_op n
        on
            o.deal_id = n.deal_id
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_wtrade_underwrite_cl d
        on
            o.deal_id = d.deal_id
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_wtrade_underwrite;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_wtrade_underwrite exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_wtrade_underwrite_cl;
alter table ${iol_schema}.ctms_tbs_v_wtrade_underwrite exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_wtrade_underwrite_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_wtrade_underwrite to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_wtrade_underwrite_op purge;
drop table ${iol_schema}.ctms_tbs_v_wtrade_underwrite_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_wtrade_underwrite_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_wtrade_underwrite',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
