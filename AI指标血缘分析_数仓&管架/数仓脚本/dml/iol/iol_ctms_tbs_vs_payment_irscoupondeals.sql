/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_payment_irscoupondeals
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
create table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals where 0=1;

create table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易组别
            ,seq -- 计息周期序号
            ,pay_rec -- 收付方向
            ,start_date -- 付息周期起始日
            ,end_date -- 付息周期结束日
            ,days -- 当期计息周期天数
            ,nominal_ccy -- 名义本金币种
            ,nominal -- 名义本金
            ,fixing_date -- 利率重置日
            ,fixing_rate -- 重置日利率
            ,amount -- 收付息金额
            ,payment_date -- 收付息日期
            ,note -- 备注
            ,spread -- 利差（BP）
            ,reduce -- 名义本金重置变化金额
            ,dailyaccrualdays -- 本计息周期天数
            ,os_amount -- 剩余名义本金
            ,ori_payment -- 本计息周期支付金额
            ,lastmodified -- 最后修改时间
            ,irsdeals_id -- 对应IRS交易ID
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,counterparty_seq -- 交易对手序号
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,lastmodified_pay -- 实收付确认的修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易组别
            ,seq -- 计息周期序号
            ,pay_rec -- 收付方向
            ,start_date -- 付息周期起始日
            ,end_date -- 付息周期结束日
            ,days -- 当期计息周期天数
            ,nominal_ccy -- 名义本金币种
            ,nominal -- 名义本金
            ,fixing_date -- 利率重置日
            ,fixing_rate -- 重置日利率
            ,amount -- 收付息金额
            ,payment_date -- 收付息日期
            ,note -- 备注
            ,spread -- 利差（BP）
            ,reduce -- 名义本金重置变化金额
            ,dailyaccrualdays -- 本计息周期天数
            ,os_amount -- 剩余名义本金
            ,ori_payment -- 本计息周期支付金额
            ,lastmodified -- 最后修改时间
            ,irsdeals_id -- 对应IRS交易ID
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,counterparty_seq -- 交易对手序号
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,lastmodified_pay -- 实收付确认的修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    nvl(n.deal_id, o.deal_id) as deal_id -- 引用表ID
    ,nvl(n.deal_name, o.deal_name) as deal_name -- 引用表名
    ,nvl(n.aspclient_id, o.aspclient_id) as aspclient_id -- 部门编号
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易组别
    ,nvl(n.seq, o.seq) as seq -- 计息周期序号
    ,nvl(n.pay_rec, o.pay_rec) as pay_rec -- 收付方向
    ,nvl(n.start_date, o.start_date) as start_date -- 付息周期起始日
    ,nvl(n.end_date, o.end_date) as end_date -- 付息周期结束日
    ,nvl(n.days, o.days) as days -- 当期计息周期天数
    ,nvl(n.nominal_ccy, o.nominal_ccy) as nominal_ccy -- 名义本金币种
    ,nvl(n.nominal, o.nominal) as nominal -- 名义本金
    ,nvl(n.fixing_date, o.fixing_date) as fixing_date -- 利率重置日
    ,nvl(n.fixing_rate, o.fixing_rate) as fixing_rate -- 重置日利率
    ,nvl(n.amount, o.amount) as amount -- 收付息金额
    ,nvl(n.payment_date, o.payment_date) as payment_date -- 收付息日期
    ,nvl(n.note, o.note) as note -- 备注
    ,nvl(n.spread, o.spread) as spread -- 利差（BP）
    ,nvl(n.reduce, o.reduce) as reduce -- 名义本金重置变化金额
    ,nvl(n.dailyaccrualdays, o.dailyaccrualdays) as dailyaccrualdays -- 本计息周期天数
    ,nvl(n.os_amount, o.os_amount) as os_amount -- 剩余名义本金
    ,nvl(n.ori_payment, o.ori_payment) as ori_payment -- 本计息周期支付金额
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.irsdeals_id, o.irsdeals_id) as irsdeals_id -- 对应IRS交易ID
    ,nvl(n.portfolio_id, o.portfolio_id) as portfolio_id -- 交易组别
    ,nvl(n.portfolio_name, o.portfolio_name) as portfolio_name -- 交易组别名称
    ,nvl(n.cpty_name, o.cpty_name) as cpty_name -- 交易对手
    ,nvl(n.counterparty_seq, o.counterparty_seq) as counterparty_seq -- 交易对手序号
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户名称
    ,nvl(n.lastmodified_pay, o.lastmodified_pay) as lastmodified_pay -- 实收付确认的修改时间
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
from (select * from ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_payment_irscoupondeals where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.serial_number <> n.serial_number
        or o.seq <> n.seq
        or o.pay_rec <> n.pay_rec
        or o.start_date <> n.start_date
        or o.end_date <> n.end_date
        or o.days <> n.days
        or o.nominal_ccy <> n.nominal_ccy
        or o.nominal <> n.nominal
        or o.fixing_date <> n.fixing_date
        or o.fixing_rate <> n.fixing_rate
        or o.amount <> n.amount
        or o.payment_date <> n.payment_date
        or o.note <> n.note
        or o.spread <> n.spread
        or o.reduce <> n.reduce
        or o.dailyaccrualdays <> n.dailyaccrualdays
        or o.os_amount <> n.os_amount
        or o.ori_payment <> n.ori_payment
        or o.lastmodified <> n.lastmodified
        or o.irsdeals_id <> n.irsdeals_id
        or o.portfolio_id <> n.portfolio_id
        or o.portfolio_name <> n.portfolio_name
        or o.cpty_name <> n.cpty_name
        or o.counterparty_seq <> n.counterparty_seq
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.lastmodified_pay <> n.lastmodified_pay
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易组别
            ,seq -- 计息周期序号
            ,pay_rec -- 收付方向
            ,start_date -- 付息周期起始日
            ,end_date -- 付息周期结束日
            ,days -- 当期计息周期天数
            ,nominal_ccy -- 名义本金币种
            ,nominal -- 名义本金
            ,fixing_date -- 利率重置日
            ,fixing_rate -- 重置日利率
            ,amount -- 收付息金额
            ,payment_date -- 收付息日期
            ,note -- 备注
            ,spread -- 利差（BP）
            ,reduce -- 名义本金重置变化金额
            ,dailyaccrualdays -- 本计息周期天数
            ,os_amount -- 剩余名义本金
            ,ori_payment -- 本计息周期支付金额
            ,lastmodified -- 最后修改时间
            ,irsdeals_id -- 对应IRS交易ID
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,counterparty_seq -- 交易对手序号
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,lastmodified_pay -- 实收付确认的修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,serial_number -- 交易组别
            ,seq -- 计息周期序号
            ,pay_rec -- 收付方向
            ,start_date -- 付息周期起始日
            ,end_date -- 付息周期结束日
            ,days -- 当期计息周期天数
            ,nominal_ccy -- 名义本金币种
            ,nominal -- 名义本金
            ,fixing_date -- 利率重置日
            ,fixing_rate -- 重置日利率
            ,amount -- 收付息金额
            ,payment_date -- 收付息日期
            ,note -- 备注
            ,spread -- 利差（BP）
            ,reduce -- 名义本金重置变化金额
            ,dailyaccrualdays -- 本计息周期天数
            ,os_amount -- 剩余名义本金
            ,ori_payment -- 本计息周期支付金额
            ,lastmodified -- 最后修改时间
            ,irsdeals_id -- 对应IRS交易ID
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,counterparty_seq -- 交易对手序号
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,lastmodified_pay -- 实收付确认的修改时间
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
select
    o.deal_id -- 引用表ID
    ,o.deal_name -- 引用表名
    ,o.aspclient_id -- 部门编号
    ,o.serial_number -- 交易组别
    ,o.seq -- 计息周期序号
    ,o.pay_rec -- 收付方向
    ,o.start_date -- 付息周期起始日
    ,o.end_date -- 付息周期结束日
    ,o.days -- 当期计息周期天数
    ,o.nominal_ccy -- 名义本金币种
    ,o.nominal -- 名义本金
    ,o.fixing_date -- 利率重置日
    ,o.fixing_rate -- 重置日利率
    ,o.amount -- 收付息金额
    ,o.payment_date -- 收付息日期
    ,o.note -- 备注
    ,o.spread -- 利差（BP）
    ,o.reduce -- 名义本金重置变化金额
    ,o.dailyaccrualdays -- 本计息周期天数
    ,o.os_amount -- 剩余名义本金
    ,o.ori_payment -- 本计息周期支付金额
    ,o.lastmodified -- 最后修改时间
    ,o.irsdeals_id -- 对应IRS交易ID
    ,o.portfolio_id -- 交易组别
    ,o.portfolio_name -- 交易组别名称
    ,o.cpty_name -- 交易对手
    ,o.counterparty_seq -- 交易对手序号
    ,o.keepfolder_id -- 账户ID
    ,o.keepfolder_shortname -- 账户名称
    ,o.lastmodified_pay -- 实收付确认的修改时间
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_bk o
    left join ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_op n
        on
            o.deal_id = n.deal_id
            and o.deal_name = n.deal_name
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_cl d
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
-- truncate table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_cl;
alter table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_payment_irscoupondeals_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_payment_irscoupondeals',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
