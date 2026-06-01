/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_v_irsmopdeals
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
create table ${iol_schema}.ctms_tbs_v_irsmopdeals_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_v_irsmopdeals;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_irsmopdeals_op purge;
drop table ${iol_schema}.ctms_tbs_v_irsmopdeals_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_v_irsmopdeals_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_irsmopdeals where 0=1;

create table ${iol_schema}.ctms_tbs_v_irsmopdeals_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_v_irsmopdeals where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_irsmopdeals_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,seq -- 序号
            ,source_trade_number -- 源交易序号
            ,ref_number -- 合约编号
            ,cpty_name -- 交易对手名称
            ,trade_date -- 交易日期
            ,value_date -- 生效日
            ,payment_date -- 付款日
            ,amount -- 解约金额
            ,cost_type -- 违约金付款方式
            ,cost_ccy -- 支出货币
            ,cost_amt -- 违约金
            ,remark -- 备注
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,lastmodified -- 最后更新时间
            ,counterparty_seq -- 交易对手序号
            ,irsdeals_id -- 对应IRS交易ID
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,settlement_type -- 清算方式
            ,irsmopdeals_id_grand -- 原始交易ID
            ,dn_dealer -- 本币交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_irsmopdeals_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,seq -- 序号
            ,source_trade_number -- 源交易序号
            ,ref_number -- 合约编号
            ,cpty_name -- 交易对手名称
            ,trade_date -- 交易日期
            ,value_date -- 生效日
            ,payment_date -- 付款日
            ,amount -- 解约金额
            ,cost_type -- 违约金付款方式
            ,cost_ccy -- 支出货币
            ,cost_amt -- 违约金
            ,remark -- 备注
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,lastmodified -- 最后更新时间
            ,counterparty_seq -- 交易对手序号
            ,irsdeals_id -- 对应IRS交易ID
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,settlement_type -- 清算方式
            ,irsmopdeals_id_grand -- 原始交易ID
            ,dn_dealer -- 本币交易员
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
    ,nvl(n.seq, o.seq) as seq -- 序号
    ,nvl(n.source_trade_number, o.source_trade_number) as source_trade_number -- 源交易序号
    ,nvl(n.ref_number, o.ref_number) as ref_number -- 合约编号
    ,nvl(n.cpty_name, o.cpty_name) as cpty_name -- 交易对手名称
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 交易日期
    ,nvl(n.value_date, o.value_date) as value_date -- 生效日
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 付款日
    ,nvl(n.amount, o.amount) as amount -- 解约金额
    ,nvl(n.cost_type, o.cost_type) as cost_type -- 违约金付款方式
    ,nvl(n.cost_ccy, o.cost_ccy) as cost_ccy -- 支出货币
    ,nvl(n.cost_amt, o.cost_amt) as cost_amt -- 违约金
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易序号
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员ID
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后更新时间
    ,nvl(n.counterparty_seq, o.counterparty_seq) as counterparty_seq -- 交易对手序号
    ,nvl(n.irsdeals_id, o.irsdeals_id) as irsdeals_id -- 对应IRS交易ID
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户名称
    ,nvl(n.settlement_type, o.settlement_type) as settlement_type -- 清算方式
    ,nvl(n.irsmopdeals_id_grand, o.irsmopdeals_id_grand) as irsmopdeals_id_grand -- 原始交易ID
    ,nvl(n.dn_dealer, o.dn_dealer) as dn_dealer -- 本币交易员
    ,case when
            n.deal_id is null
            and n.deal_name is null
        then o.start_dt
        else to_date('${batch_date}', 'yyyymmdd')
    end as start_dt -- 开始时间
    ,case when
            n.deal_id is null
            and n.deal_name is null
        then to_date('${batch_date}', 'yyyymmdd')
        else to_date('20991231', 'yyyymmdd')
    end as end_dt -- 结束时间
    ,case when
            n.deal_id is null
            and n.deal_name is null
        then 'D'
        else 'I'
    end as id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from (select * from ${iol_schema}.ctms_tbs_v_irsmopdeals_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_v_irsmopdeals where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
        on
            o.deal_id = n.deal_id
            and o.deal_name = n.deal_name
where (
        o.deal_id is null
        and o.deal_name is null
    )
    or (
        n.deal_id is null
        and n.deal_name is null
    )
    or (
        o.aspclient_id <> n.aspclient_id
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.seq <> n.seq
        or o.source_trade_number <> n.source_trade_number
        or o.ref_number <> n.ref_number
        or o.cpty_name <> n.cpty_name
        or o.trade_date <> n.trade_date
        or o.value_date <> n.value_date
        or o.payment_date <> n.payment_date
        or o.amount <> n.amount
        or o.cost_type <> n.cost_type
        or o.cost_ccy <> n.cost_ccy
        or o.cost_amt <> n.cost_amt
        or o.remark <> n.remark
        or o.serial_number <> n.serial_number
        or o.dealer_id <> n.dealer_id
        or o.lastmodified <> n.lastmodified
        or o.counterparty_seq <> n.counterparty_seq
        or o.irsdeals_id <> n.irsdeals_id
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.settlement_type <> n.settlement_type
        or o.irsmopdeals_id_grand <> n.irsmopdeals_id_grand
        or o.dn_dealer <> n.dn_dealer
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_v_irsmopdeals_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,seq -- 序号
            ,source_trade_number -- 源交易序号
            ,ref_number -- 合约编号
            ,cpty_name -- 交易对手名称
            ,trade_date -- 交易日期
            ,value_date -- 生效日
            ,payment_date -- 付款日
            ,amount -- 解约金额
            ,cost_type -- 违约金付款方式
            ,cost_ccy -- 支出货币
            ,cost_amt -- 违约金
            ,remark -- 备注
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,lastmodified -- 最后更新时间
            ,counterparty_seq -- 交易对手序号
            ,irsdeals_id -- 对应IRS交易ID
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,settlement_type -- 清算方式
            ,irsmopdeals_id_grand -- 原始交易ID
            ,dn_dealer -- 本币交易员
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_v_irsmopdeals_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,seq -- 序号
            ,source_trade_number -- 源交易序号
            ,ref_number -- 合约编号
            ,cpty_name -- 交易对手名称
            ,trade_date -- 交易日期
            ,value_date -- 生效日
            ,payment_date -- 付款日
            ,amount -- 解约金额
            ,cost_type -- 违约金付款方式
            ,cost_ccy -- 支出货币
            ,cost_amt -- 违约金
            ,remark -- 备注
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,lastmodified -- 最后更新时间
            ,counterparty_seq -- 交易对手序号
            ,irsdeals_id -- 对应IRS交易ID
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,settlement_type -- 清算方式
            ,irsmopdeals_id_grand -- 原始交易ID
            ,dn_dealer -- 本币交易员
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
    ,o.seq -- 序号
    ,o.source_trade_number -- 源交易序号
    ,o.ref_number -- 合约编号
    ,o.cpty_name -- 交易对手名称
    ,o.trade_date -- 交易日期
    ,o.value_date -- 生效日
    ,o.payment_date -- 付款日
    ,o.amount -- 解约金额
    ,o.cost_type -- 违约金付款方式
    ,o.cost_ccy -- 支出货币
    ,o.cost_amt -- 违约金
    ,o.remark -- 备注
    ,o.serial_number -- 交易序号
    ,o.dealer_id -- 交易员ID
    ,o.lastmodified -- 最后更新时间
    ,o.counterparty_seq -- 交易对手序号
    ,o.irsdeals_id -- 对应IRS交易ID
    ,o.keepfolder_id -- 账户ID
    ,o.keepfolder_shortname -- 账户名称
    ,o.settlement_type -- 清算方式
    ,o.irsmopdeals_id_grand -- 原始交易ID
    ,o.dn_dealer -- 本币交易员
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_v_irsmopdeals_bk o
    left join ${iol_schema}.ctms_tbs_v_irsmopdeals_op n
        on
            o.deal_id = n.deal_id
            and o.deal_name = n.deal_name
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_v_irsmopdeals_cl d
        on
            o.deal_id = d.deal_id
            and o.deal_name = d.deal_name
where o.start_dt < to_date('${batch_date}','yyyymmdd')
    and (
        o.start_dt <> d.start_dt
        or d.start_dt is null
    )
;
commit;

-- 4.1 truncate target table
-- truncate table ${iol_schema}.ctms_tbs_v_irsmopdeals;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_v_irsmopdeals exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_v_irsmopdeals_cl;
alter table ${iol_schema}.ctms_tbs_v_irsmopdeals exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_v_irsmopdeals_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_v_irsmopdeals to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_v_irsmopdeals_op purge;
drop table ${iol_schema}.ctms_tbs_v_irsmopdeals_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_v_irsmopdeals_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_v_irsmopdeals',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
