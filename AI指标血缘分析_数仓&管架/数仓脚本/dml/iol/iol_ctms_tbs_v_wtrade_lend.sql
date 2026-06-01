/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_wtrade_lend
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
create table ${iol_schema}.ctms_tbs_v_wtrade_lend_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_wtrade_lend;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_wtrade_lend_op purge;
drop table ${iol_schema}.ctms_tbs_v_wtrade_lend_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_wtrade_lend_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_wtrade_lend where 0=1;

create table ${iol_schema}.ctms_tbs_v_wtrade_lend_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_wtrade_lend where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_wtrade_lend_cl(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,serial_number -- 交易序号
            ,user_number -- 操作员
            ,branch_number -- 分支机构号
            ,currency -- 币别
            ,buyorsell -- 交易方向
            ,amount -- 面额
            ,trade_rate -- 借贷费率
            ,market_rate -- 市值
            ,value_date -- 首期结算日
            ,maturity_date -- 到期结算日
            ,trade_date -- 交易录入日
            ,trade_time -- 交易时间
            ,ref_number -- 成交编号
            ,link_serial_number -- 删除或修改的原始交易
            ,status -- 状态
            ,dealer -- 交易员ID
            ,account -- 
            ,maturity_amount -- 到期结算金额
            ,lend_id -- 交易品种
            ,bondscode -- 质押券代码
            ,lendbondscode -- 标的券代码
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,note -- 备注
            ,day_count -- 日计息基准
            ,process_status -- 处理状态
            ,realized_pl -- 已实现损益
            ,unrealized_pl -- 未实现损益
            ,total_pl -- 总损益
            ,daily_pl -- 每日损益
            ,interest_pl -- 利息损益
            ,realized_days -- 实际天数
            ,ori_trade_date -- 原始交易日
            ,security_face_amount -- 抵押品每张券面总额
            ,collateral_type -- 抵押品种类
            ,lend_rate -- 抵押比例
            ,settle_type -- 首次结算方式
            ,settle_type2 -- 到期结算方式
            ,deal_time -- 交易时间
            ,modify_user -- 修改人
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手序号
            ,ref_deal_sn -- 参考编号
            ,valid_source_sn -- 连结的审批序号
            ,cancel_reason -- 审批单被撤销理由
            ,source -- 交易来源
            ,input_from -- 输入来源
            ,cstp_serial -- 原始交易序号
            ,cfets_from -- 是否是CFETS交易
            ,lend_days -- 借贷期限
            ,inv_type -- 库存方式
            ,inv_short -- 库存是否短仓
            ,auto_import -- 是否自动导入
            ,price_flag -- 金额标识
            ,match_flag -- 是否匹配
            ,is_trans_quote -- 审批单是否转成报价
            ,wtrade_lend_id_grand -- 原始交易ID
            ,datasymbol_id -- 数据源ID
            ,orig_serial_number -- 原始交易序号
            ,impstatus -- 导入状态
            ,prostatus -- 处理状态
            ,spotfwd -- 远期/即期
            ,lastmodified -- 最后修改时间
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_wtrade_lend_op(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,serial_number -- 交易序号
            ,user_number -- 操作员
            ,branch_number -- 分支机构号
            ,currency -- 币别
            ,buyorsell -- 交易方向
            ,amount -- 面额
            ,trade_rate -- 借贷费率
            ,market_rate -- 市值
            ,value_date -- 首期结算日
            ,maturity_date -- 到期结算日
            ,trade_date -- 交易录入日
            ,trade_time -- 交易时间
            ,ref_number -- 成交编号
            ,link_serial_number -- 删除或修改的原始交易
            ,status -- 状态
            ,dealer -- 交易员ID
            ,account -- 
            ,maturity_amount -- 到期结算金额
            ,lend_id -- 交易品种
            ,bondscode -- 质押券代码
            ,lendbondscode -- 标的券代码
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,note -- 备注
            ,day_count -- 日计息基准
            ,process_status -- 处理状态
            ,realized_pl -- 已实现损益
            ,unrealized_pl -- 未实现损益
            ,total_pl -- 总损益
            ,daily_pl -- 每日损益
            ,interest_pl -- 利息损益
            ,realized_days -- 实际天数
            ,ori_trade_date -- 原始交易日
            ,security_face_amount -- 抵押品每张券面总额
            ,collateral_type -- 抵押品种类
            ,lend_rate -- 抵押比例
            ,settle_type -- 首次结算方式
            ,settle_type2 -- 到期结算方式
            ,deal_time -- 交易时间
            ,modify_user -- 修改人
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手序号
            ,ref_deal_sn -- 参考编号
            ,valid_source_sn -- 连结的审批序号
            ,cancel_reason -- 审批单被撤销理由
            ,source -- 交易来源
            ,input_from -- 输入来源
            ,cstp_serial -- 原始交易序号
            ,cfets_from -- 是否是CFETS交易
            ,lend_days -- 借贷期限
            ,inv_type -- 库存方式
            ,inv_short -- 库存是否短仓
            ,auto_import -- 是否自动导入
            ,price_flag -- 金额标识
            ,match_flag -- 是否匹配
            ,is_trans_quote -- 审批单是否转成报价
            ,wtrade_lend_id_grand -- 原始交易ID
            ,datasymbol_id -- 数据源ID
            ,orig_serial_number -- 原始交易序号
            ,impstatus -- 导入状态
            ,prostatus -- 处理状态
            ,spotfwd -- 远期/即期
            ,lastmodified -- 最后修改时间
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表ID
    ,nvl(n.deal_tablename, o.deal_tablename) as deal_tablename -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 交易组别
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 交易组别名称
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易序号
    ,nvl(n.user_number, o.user_number) as user_number -- 操作员
    ,nvl(n.branch_number, o.branch_number) as branch_number -- 分支机构号
    ,nvl(n.currency, o.currency) as currency -- 币别
    ,nvl(n.buyorsell, o.buyorsell) as buyorsell -- 交易方向
    ,nvl(n.amount, o.amount) as amount -- 面额
    ,nvl(n.trade_rate, o.trade_rate) as trade_rate -- 借贷费率
    ,nvl(n.market_rate, o.market_rate) as market_rate -- 市值
    ,nvl(n.value_date, o.value_date) as value_date -- 首期结算日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期结算日
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 交易录入日
    ,nvl(n.trade_time, o.trade_time) as trade_time -- 交易时间
    ,nvl(n.ref_number, o.ref_number) as ref_number -- 成交编号
    ,nvl(n.link_serial_number, o.link_serial_number) as link_serial_number -- 删除或修改的原始交易
    ,nvl(n.status, o.status) as status -- 状态
    ,nvl(n.dealer, o.dealer) as dealer -- 交易员ID
    ,nvl(n.account, o.account) as account -- 
    ,nvl(n.maturity_amount, o.maturity_amount) as maturity_amount -- 到期结算金额
    ,nvl(n.lend_id, o.lend_id) as lend_id -- 交易品种
    ,nvl(n.bondscode, o.bondscode) as bondscode -- 质押券代码
    ,nvl(n.lendbondscode, o.lendbondscode) as lendbondscode -- 标的券代码
    ,nvl(n.fee, o.fee) as fee -- 首期费用
    ,nvl(n.tax_amt, o.tax_amt) as tax_amt -- 首期税金
    ,nvl(n.broker_amt, o.broker_amt) as broker_amt -- 首期佣金
    ,nvl(n.interest, o.interest) as interest -- 应计利息
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.day_count, o.day_count) as day_count -- 日计息基准
    ,nvl(n.process_status, o.process_status) as process_status -- 处理状态
    ,nvl(n.realized_pl, o.realized_pl) as realized_pl -- 已实现损益
    ,nvl(n.unrealized_pl, o.unrealized_pl) as unrealized_pl -- 未实现损益
    ,nvl(n.total_pl, o.total_pl) as total_pl -- 总损益
    ,nvl(n.daily_pl, o.daily_pl) as daily_pl -- 每日损益
    ,nvl(n.interest_pl, o.interest_pl) as interest_pl -- 利息损益
    ,nvl(n.realized_days, o.realized_days) as realized_days -- 实际天数
    ,nvl(n.ori_trade_date, o.ori_trade_date) as ori_trade_date -- 原始交易日
    ,nvl(n.security_face_amount, o.security_face_amount) as security_face_amount -- 抵押品每张券面总额
    ,nvl(n.collateral_type, o.collateral_type) as collateral_type -- 抵押品种类
    ,nvl(n.lend_rate, o.lend_rate) as lend_rate -- 抵押比例
    ,nvl(n.settle_type, o.settle_type) as settle_type -- 首次结算方式
    ,nvl(n.settle_type2, o.settle_type2) as settle_type2 -- 到期结算方式
    ,nvl(n.deal_time, o.deal_time) as deal_time -- 交易时间
    ,nvl(n.modify_user, o.modify_user) as modify_user -- 修改人
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户名称
    ,nvl(n.cptys_short_name, o.cptys_short_name) as cptys_short_name -- 交易对手名
    ,nvl(n.cptys_id, o.cptys_id) as cptys_id -- 交易对手序号
    ,nvl(n.ref_deal_sn, o.ref_deal_sn) as ref_deal_sn -- 参考编号
    ,nvl(n.valid_source_sn, o.valid_source_sn) as valid_source_sn -- 连结的审批序号
    ,nvl(n.cancel_reason, o.cancel_reason) as cancel_reason -- 审批单被撤销理由
    ,nvl(n.source, o.source) as source -- 交易来源
    ,nvl(n.input_from, o.input_from) as input_from -- 输入来源
    ,nvl(n.cstp_serial, o.cstp_serial) as cstp_serial -- 原始交易序号
    ,nvl(n.cfets_from, o.cfets_from) as cfets_from -- 是否是CFETS交易
    ,nvl(n.lend_days, o.lend_days) as lend_days -- 借贷期限
    ,nvl(n.inv_type, o.inv_type) as inv_type -- 库存方式
    ,nvl(n.inv_short, o.inv_short) as inv_short -- 库存是否短仓
    ,nvl(n.auto_import, o.auto_import) as auto_import -- 是否自动导入
    ,nvl(n.price_flag, o.price_flag) as price_flag -- 金额标识
    ,nvl(n.match_flag, o.match_flag) as match_flag -- 是否匹配
    ,nvl(n.is_trans_quote, o.is_trans_quote) as is_trans_quote -- 审批单是否转成报价
    ,nvl(n.wtrade_lend_id_grand, o.wtrade_lend_id_grand) as wtrade_lend_id_grand -- 原始交易ID
    ,nvl(n.datasymbol_id, o.datasymbol_id) as datasymbol_id -- 数据源ID
    ,nvl(n.orig_serial_number, o.orig_serial_number) as orig_serial_number -- 原始交易序号
    ,nvl(n.impstatus, o.impstatus) as impstatus -- 导入状态
    ,nvl(n.prostatus, o.prostatus) as prostatus -- 处理状态
    ,nvl(n.spotfwd, o.spotfwd) as spotfwd -- 远期/即期
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.dn_dealer, o.dn_dealer) as dn_dealer -- 本币交易员
    ,nvl(n.dealer_name, o.dealer_name) as dealer_name -- 交易员名称
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
from (select * from ${iol_schema}.ctms_tbs_v_wtrade_lend_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_wtrade_lend where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.serial_number <> n.serial_number
        or o.user_number <> n.user_number
        or o.branch_number <> n.branch_number
        or o.currency <> n.currency
        or o.buyorsell <> n.buyorsell
        or o.amount <> n.amount
        or o.trade_rate <> n.trade_rate
        or o.market_rate <> n.market_rate
        or o.value_date <> n.value_date
        or o.maturity_date <> n.maturity_date
        or o.trade_date <> n.trade_date
        or o.trade_time <> n.trade_time
        or o.ref_number <> n.ref_number
        or o.link_serial_number <> n.link_serial_number
        or o.status <> n.status
        or o.dealer <> n.dealer
        or o.account <> n.account
        or o.maturity_amount <> n.maturity_amount
        or o.lend_id <> n.lend_id
        or o.bondscode <> n.bondscode
        or o.lendbondscode <> n.lendbondscode
        or o.fee <> n.fee
        or o.tax_amt <> n.tax_amt
        or o.broker_amt <> n.broker_amt
        or o.interest <> n.interest
        or o.note <> n.note
        or o.day_count <> n.day_count
        or o.process_status <> n.process_status
        or o.realized_pl <> n.realized_pl
        or o.unrealized_pl <> n.unrealized_pl
        or o.total_pl <> n.total_pl
        or o.daily_pl <> n.daily_pl
        or o.interest_pl <> n.interest_pl
        or o.realized_days <> n.realized_days
        or o.ori_trade_date <> n.ori_trade_date
        or o.security_face_amount <> n.security_face_amount
        or o.collateral_type <> n.collateral_type
        or o.lend_rate <> n.lend_rate
        or o.settle_type <> n.settle_type
        or o.settle_type2 <> n.settle_type2
        or o.deal_time <> n.deal_time
        or o.modify_user <> n.modify_user
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.cptys_short_name <> n.cptys_short_name
        or o.cptys_id <> n.cptys_id
        or o.ref_deal_sn <> n.ref_deal_sn
        or o.valid_source_sn <> n.valid_source_sn
        or o.cancel_reason <> n.cancel_reason
        or o.source <> n.source
        or o.input_from <> n.input_from
        or o.cstp_serial <> n.cstp_serial
        or o.cfets_from <> n.cfets_from
        or o.lend_days <> n.lend_days
        or o.inv_type <> n.inv_type
        or o.inv_short <> n.inv_short
        or o.auto_import <> n.auto_import
        or o.price_flag <> n.price_flag
        or o.match_flag <> n.match_flag
        or o.is_trans_quote <> n.is_trans_quote
        or o.wtrade_lend_id_grand <> n.wtrade_lend_id_grand
        or o.datasymbol_id <> n.datasymbol_id
        or o.orig_serial_number <> n.orig_serial_number
        or o.impstatus <> n.impstatus
        or o.prostatus <> n.prostatus
        or o.spotfwd <> n.spotfwd
        or o.lastmodified <> n.lastmodified
        or o.dn_dealer <> n.dn_dealer
        or o.dealer_name <> n.dealer_name
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_wtrade_lend_cl(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,serial_number -- 交易序号
            ,user_number -- 操作员
            ,branch_number -- 分支机构号
            ,currency -- 币别
            ,buyorsell -- 交易方向
            ,amount -- 面额
            ,trade_rate -- 借贷费率
            ,market_rate -- 市值
            ,value_date -- 首期结算日
            ,maturity_date -- 到期结算日
            ,trade_date -- 交易录入日
            ,trade_time -- 交易时间
            ,ref_number -- 成交编号
            ,link_serial_number -- 删除或修改的原始交易
            ,status -- 状态
            ,dealer -- 交易员ID
            ,account -- 
            ,maturity_amount -- 到期结算金额
            ,lend_id -- 交易品种
            ,bondscode -- 质押券代码
            ,lendbondscode -- 标的券代码
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,note -- 备注
            ,day_count -- 日计息基准
            ,process_status -- 处理状态
            ,realized_pl -- 已实现损益
            ,unrealized_pl -- 未实现损益
            ,total_pl -- 总损益
            ,daily_pl -- 每日损益
            ,interest_pl -- 利息损益
            ,realized_days -- 实际天数
            ,ori_trade_date -- 原始交易日
            ,security_face_amount -- 抵押品每张券面总额
            ,collateral_type -- 抵押品种类
            ,lend_rate -- 抵押比例
            ,settle_type -- 首次结算方式
            ,settle_type2 -- 到期结算方式
            ,deal_time -- 交易时间
            ,modify_user -- 修改人
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手序号
            ,ref_deal_sn -- 参考编号
            ,valid_source_sn -- 连结的审批序号
            ,cancel_reason -- 审批单被撤销理由
            ,source -- 交易来源
            ,input_from -- 输入来源
            ,cstp_serial -- 原始交易序号
            ,cfets_from -- 是否是CFETS交易
            ,lend_days -- 借贷期限
            ,inv_type -- 库存方式
            ,inv_short -- 库存是否短仓
            ,auto_import -- 是否自动导入
            ,price_flag -- 金额标识
            ,match_flag -- 是否匹配
            ,is_trans_quote -- 审批单是否转成报价
            ,wtrade_lend_id_grand -- 原始交易ID
            ,datasymbol_id -- 数据源ID
            ,orig_serial_number -- 原始交易序号
            ,impstatus -- 导入状态
            ,prostatus -- 处理状态
            ,spotfwd -- 远期/即期
            ,lastmodified -- 最后修改时间
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_wtrade_lend_op(
            deal_id -- 引用表ID
            ,deal_tablename -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,serial_number -- 交易序号
            ,user_number -- 操作员
            ,branch_number -- 分支机构号
            ,currency -- 币别
            ,buyorsell -- 交易方向
            ,amount -- 面额
            ,trade_rate -- 借贷费率
            ,market_rate -- 市值
            ,value_date -- 首期结算日
            ,maturity_date -- 到期结算日
            ,trade_date -- 交易录入日
            ,trade_time -- 交易时间
            ,ref_number -- 成交编号
            ,link_serial_number -- 删除或修改的原始交易
            ,status -- 状态
            ,dealer -- 交易员ID
            ,account -- 
            ,maturity_amount -- 到期结算金额
            ,lend_id -- 交易品种
            ,bondscode -- 质押券代码
            ,lendbondscode -- 标的券代码
            ,fee -- 首期费用
            ,tax_amt -- 首期税金
            ,broker_amt -- 首期佣金
            ,interest -- 应计利息
            ,note -- 备注
            ,day_count -- 日计息基准
            ,process_status -- 处理状态
            ,realized_pl -- 已实现损益
            ,unrealized_pl -- 未实现损益
            ,total_pl -- 总损益
            ,daily_pl -- 每日损益
            ,interest_pl -- 利息损益
            ,realized_days -- 实际天数
            ,ori_trade_date -- 原始交易日
            ,security_face_amount -- 抵押品每张券面总额
            ,collateral_type -- 抵押品种类
            ,lend_rate -- 抵押比例
            ,settle_type -- 首次结算方式
            ,settle_type2 -- 到期结算方式
            ,deal_time -- 交易时间
            ,modify_user -- 修改人
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,cptys_short_name -- 交易对手名
            ,cptys_id -- 交易对手序号
            ,ref_deal_sn -- 参考编号
            ,valid_source_sn -- 连结的审批序号
            ,cancel_reason -- 审批单被撤销理由
            ,source -- 交易来源
            ,input_from -- 输入来源
            ,cstp_serial -- 原始交易序号
            ,cfets_from -- 是否是CFETS交易
            ,lend_days -- 借贷期限
            ,inv_type -- 库存方式
            ,inv_short -- 库存是否短仓
            ,auto_import -- 是否自动导入
            ,price_flag -- 金额标识
            ,match_flag -- 是否匹配
            ,is_trans_quote -- 审批单是否转成报价
            ,wtrade_lend_id_grand -- 原始交易ID
            ,datasymbol_id -- 数据源ID
            ,orig_serial_number -- 原始交易序号
            ,impstatus -- 导入状态
            ,prostatus -- 处理状态
            ,spotfwd -- 远期/即期
            ,lastmodified -- 最后修改时间
            ,dn_dealer -- 本币交易员
            ,dealer_name -- 交易员名称
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表ID
    ,o.deal_tablename -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.portfolio_id -- 交易组别
    ,o.portfolio_name -- 交易组别名称
    ,o.serial_number -- 交易序号
    ,o.user_number -- 操作员
    ,o.branch_number -- 分支机构号
    ,o.currency -- 币别
    ,o.buyorsell -- 交易方向
    ,o.amount -- 面额
    ,o.trade_rate -- 借贷费率
    ,o.market_rate -- 市值
    ,o.value_date -- 首期结算日
    ,o.maturity_date -- 到期结算日
    ,o.trade_date -- 交易录入日
    ,o.trade_time -- 交易时间
    ,o.ref_number -- 成交编号
    ,o.link_serial_number -- 删除或修改的原始交易
    ,o.status -- 状态
    ,o.dealer -- 交易员ID
    ,o.account -- 
    ,o.maturity_amount -- 到期结算金额
    ,o.lend_id -- 交易品种
    ,o.bondscode -- 质押券代码
    ,o.lendbondscode -- 标的券代码
    ,o.fee -- 首期费用
    ,o.tax_amt -- 首期税金
    ,o.broker_amt -- 首期佣金
    ,o.interest -- 应计利息
    ,o.note -- 备注
    ,o.day_count -- 日计息基准
    ,o.process_status -- 处理状态
    ,o.realized_pl -- 已实现损益
    ,o.unrealized_pl -- 未实现损益
    ,o.total_pl -- 总损益
    ,o.daily_pl -- 每日损益
    ,o.interest_pl -- 利息损益
    ,o.realized_days -- 实际天数
    ,o.ori_trade_date -- 原始交易日
    ,o.security_face_amount -- 抵押品每张券面总额
    ,o.collateral_type -- 抵押品种类
    ,o.lend_rate -- 抵押比例
    ,o.settle_type -- 首次结算方式
    ,o.settle_type2 -- 到期结算方式
    ,o.deal_time -- 交易时间
    ,o.modify_user -- 修改人
    ,o.keepfolder_id -- 账户ID
    ,o.keepfolder_shortname -- 账户名称
    ,o.cptys_short_name -- 交易对手名
    ,o.cptys_id -- 交易对手序号
    ,o.ref_deal_sn -- 参考编号
    ,o.valid_source_sn -- 连结的审批序号
    ,o.cancel_reason -- 审批单被撤销理由
    ,o.source -- 交易来源
    ,o.input_from -- 输入来源
    ,o.cstp_serial -- 原始交易序号
    ,o.cfets_from -- 是否是CFETS交易
    ,o.lend_days -- 借贷期限
    ,o.inv_type -- 库存方式
    ,o.inv_short -- 库存是否短仓
    ,o.auto_import -- 是否自动导入
    ,o.price_flag -- 金额标识
    ,o.match_flag -- 是否匹配
    ,o.is_trans_quote -- 审批单是否转成报价
    ,o.wtrade_lend_id_grand -- 原始交易ID
    ,o.datasymbol_id -- 数据源ID
    ,o.orig_serial_number -- 原始交易序号
    ,o.impstatus -- 导入状态
    ,o.prostatus -- 处理状态
    ,o.spotfwd -- 远期/即期
    ,o.lastmodified -- 最后修改时间
    ,o.dn_dealer -- 本币交易员
    ,o.dealer_name -- 交易员名称
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_wtrade_lend_bk o
    left join ${iol_schema}.ctms_tbs_v_wtrade_lend_op n
        on
            o.deal_id = n.deal_id
            and o.deal_tablename = n.deal_tablename
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_wtrade_lend_cl d
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
-- truncate table ${iol_schema}.ctms_tbs_v_wtrade_lend;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_wtrade_lend exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_wtrade_lend_cl;
alter table ${iol_schema}.ctms_tbs_v_wtrade_lend exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_wtrade_lend_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_wtrade_lend to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_wtrade_lend_op purge;
drop table ${iol_schema}.ctms_tbs_v_wtrade_lend_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_wtrade_lend_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_wtrade_lend',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
