/*
Purpose:    偏源模型层-全量拉链脚本。此脚本由生成引擎自动生成。
Author:     Sunline
Usage:      python $ETL_HOME/script/main.py yyyymmdd iol_ctms_tbs_vs_payment_irsdeals
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
create table ${iol_schema}.ctms_tbs_vs_payment_irsdeals_bk nologging
compress ${option_switch} for query high
as
select *
from ${iol_schema}.ctms_tbs_vs_payment_irsdeals;

-- 2.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_irsdeals_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_irsdeals_cl purge;

-- 2.3 create temp table
whenever sqlerror exit sql.sqlcode;
create table ${iol_schema}.ctms_tbs_vs_payment_irsdeals_op nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_irsdeals where 0=1;

create table ${iol_schema}.ctms_tbs_vs_payment_irsdeals_cl nologging
compress ${option_switch} for query high
as
select * from ${iol_schema}.ctms_tbs_vs_payment_irsdeals where 0=1;

-- 3.1 get new, alter, delete data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt = to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_irsdeals_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,ref_number -- 合约编号
            ,trade_date -- 交易日期
            ,value_date -- 起息日
            ,contract_date -- 签约日
            ,maturity_date -- 到期日
            ,nominal -- 交易面额
            ,os_amount -- 剩余金额
            ,upfront_pr -- 前置金付款方式
            ,upfront_fee -- 前置金
            ,upfront_payment_date -- 前置金付款日
            ,amortization -- 名义本金是否重置
            ,reduce_start_date -- 首期名义本金重置日
            ,reduce_freq -- 名义本金重置频率
            ,reduce_type -- 名义本金重置形态
            ,reduce_rate -- 名义本金重置比率
            ,reduce_amt -- 名义本金重置金额
            ,tax_amt -- 税金
            ,fee -- 手续费
            ,broker_amt -- 佣金
            ,remark -- 备注
            ,receive_int_mode -- 本方收取_计息方式
            ,receive_dc -- 本方收取_计息基准
            ,receive_rate_type -- 本方收取_利率类型
            ,receive_fixed_rate -- 本方收取_固定利率
            ,receive_float_indicator -- 本方收取_基准利率浮动方式
            ,receive_benchmark -- 本方收取_浮动利率基准
            ,receive_spread -- 本方收取_利率加点 利差
            ,receive_upper_limit -- 本方收取_浮动利率上界
            ,receive_lower_limit -- 本方收取_浮动利率下界
            ,receive_fixing_freq -- 本方收取_重置频率
            ,receive_dbcp_days -- 本方收取_重置日调整天数
            ,receive_first_end_date -- 本方收取_首期付息日
            ,receive_period_adj -- 本方收取_计息调整
            ,receive_payment_freq -- 本方收取_支付频率
            ,receive_yield_curve -- 本方收取_远期曲线
            ,receive_payment_adj -- 本方收取_支付日调整
            ,receive_first_fix_date -- 本方收取_首次利率确定日
            ,receive_irr_period -- 本方收取_支付日程畸零天期
            ,pay_int_mode -- 本方支付_计息方式
            ,pay_dc -- 本方支付_计息基准
            ,pay_rate_type -- 本方支付_利率类型
            ,pay_fixed_rate -- 本方支付_固定利率
            ,pay_float_indicator -- 本方支付_基准利率浮动方式
            ,pay_benchmark -- 本方支付_浮动利率基准
            ,pay_spread -- 本方支付_利率加点 利差
            ,pay_upper_limit -- 本方支付_浮动利率上界
            ,pay_lower_limit -- 本方支付_浮动利率下界
            ,pay_fixing_freq -- 本方支付_重置频率
            ,pay_dbcp_days -- 本方支付_重置日调整天数
            ,pay_first_end_date -- 本方支付_首期付息日
            ,pay_period_adj -- 本方支付_计息调整
            ,pay_payment_freq -- 本方支付_支付频率
            ,pay_yield_curve -- 本方支付_远期曲线
            ,pay_payment_adj -- 本方支付_支付日调整
            ,pay_first_fix_date -- 本方支付_首次利率确定日
            ,pay_irr_period -- 本方支付_支付日程畸零天期
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,counterparty_seq -- 交易对手序号
            ,lastmodified -- 最后修改时间
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,settlement_type -- 清算方式
            ,irsdeals_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,dn_dealer -- 本币交易员
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_irsdeals_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,ref_number -- 合约编号
            ,trade_date -- 交易日期
            ,value_date -- 起息日
            ,contract_date -- 签约日
            ,maturity_date -- 到期日
            ,nominal -- 交易面额
            ,os_amount -- 剩余金额
            ,upfront_pr -- 前置金付款方式
            ,upfront_fee -- 前置金
            ,upfront_payment_date -- 前置金付款日
            ,amortization -- 名义本金是否重置
            ,reduce_start_date -- 首期名义本金重置日
            ,reduce_freq -- 名义本金重置频率
            ,reduce_type -- 名义本金重置形态
            ,reduce_rate -- 名义本金重置比率
            ,reduce_amt -- 名义本金重置金额
            ,tax_amt -- 税金
            ,fee -- 手续费
            ,broker_amt -- 佣金
            ,remark -- 备注
            ,receive_int_mode -- 本方收取_计息方式
            ,receive_dc -- 本方收取_计息基准
            ,receive_rate_type -- 本方收取_利率类型
            ,receive_fixed_rate -- 本方收取_固定利率
            ,receive_float_indicator -- 本方收取_基准利率浮动方式
            ,receive_benchmark -- 本方收取_浮动利率基准
            ,receive_spread -- 本方收取_利率加点 利差
            ,receive_upper_limit -- 本方收取_浮动利率上界
            ,receive_lower_limit -- 本方收取_浮动利率下界
            ,receive_fixing_freq -- 本方收取_重置频率
            ,receive_dbcp_days -- 本方收取_重置日调整天数
            ,receive_first_end_date -- 本方收取_首期付息日
            ,receive_period_adj -- 本方收取_计息调整
            ,receive_payment_freq -- 本方收取_支付频率
            ,receive_yield_curve -- 本方收取_远期曲线
            ,receive_payment_adj -- 本方收取_支付日调整
            ,receive_first_fix_date -- 本方收取_首次利率确定日
            ,receive_irr_period -- 本方收取_支付日程畸零天期
            ,pay_int_mode -- 本方支付_计息方式
            ,pay_dc -- 本方支付_计息基准
            ,pay_rate_type -- 本方支付_利率类型
            ,pay_fixed_rate -- 本方支付_固定利率
            ,pay_float_indicator -- 本方支付_基准利率浮动方式
            ,pay_benchmark -- 本方支付_浮动利率基准
            ,pay_spread -- 本方支付_利率加点 利差
            ,pay_upper_limit -- 本方支付_浮动利率上界
            ,pay_lower_limit -- 本方支付_浮动利率下界
            ,pay_fixing_freq -- 本方支付_重置频率
            ,pay_dbcp_days -- 本方支付_重置日调整天数
            ,pay_first_end_date -- 本方支付_首期付息日
            ,pay_period_adj -- 本方支付_计息调整
            ,pay_payment_freq -- 本方支付_支付频率
            ,pay_yield_curve -- 本方支付_远期曲线
            ,pay_payment_adj -- 本方支付_支付日调整
            ,pay_first_fix_date -- 本方支付_首次利率确定日
            ,pay_irr_period -- 本方支付_支付日程畸零天期
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,counterparty_seq -- 交易对手序号
            ,lastmodified -- 最后修改时间
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,settlement_type -- 清算方式
            ,irsdeals_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,dn_dealer -- 本币交易员
            ,status -- 状态
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
    ,nvl(n.ref_number, o.ref_number) as ref_number -- 合约编号
    ,nvl(n.trade_date, o.trade_date) as trade_date -- 交易日期
    ,nvl(n.value_date, o.value_date) as value_date -- 起息日
    ,nvl(n.contract_date, o.contract_date) as contract_date -- 签约日
    ,nvl(n.maturity_date, o.maturity_date) as maturity_date -- 到期日
    ,nvl(n.nominal, o.nominal) as nominal -- 交易面额
    ,nvl(n.os_amount, o.os_amount) as os_amount -- 剩余金额
    ,nvl(n.upfront_pr, o.upfront_pr) as upfront_pr -- 前置金付款方式
    ,nvl(n.upfront_fee, o.upfront_fee) as upfront_fee -- 前置金
    ,nvl(n.upfront_payment_date, o.upfront_payment_date) as upfront_payment_date -- 前置金付款日
    ,nvl(n.amortization, o.amortization) as amortization -- 名义本金是否重置
    ,nvl(n.reduce_start_date, o.reduce_start_date) as reduce_start_date -- 首期名义本金重置日
    ,nvl(n.reduce_freq, o.reduce_freq) as reduce_freq -- 名义本金重置频率
    ,nvl(n.reduce_type, o.reduce_type) as reduce_type -- 名义本金重置形态
    ,nvl(n.reduce_rate, o.reduce_rate) as reduce_rate -- 名义本金重置比率
    ,nvl(n.reduce_amt, o.reduce_amt) as reduce_amt -- 名义本金重置金额
    ,nvl(n.tax_amt, o.tax_amt) as tax_amt -- 税金
    ,nvl(n.fee, o.fee) as fee -- 手续费
    ,nvl(n.broker_amt, o.broker_amt) as broker_amt -- 佣金
    ,nvl(n.remark, o.remark) as remark -- 备注
    ,nvl(n.receive_int_mode, o.receive_int_mode) as receive_int_mode -- 本方收取_计息方式
    ,nvl(n.receive_dc, o.receive_dc) as receive_dc -- 本方收取_计息基准
    ,nvl(n.receive_rate_type, o.receive_rate_type) as receive_rate_type -- 本方收取_利率类型
    ,nvl(n.receive_fixed_rate, o.receive_fixed_rate) as receive_fixed_rate -- 本方收取_固定利率
    ,nvl(n.receive_float_indicator, o.receive_float_indicator) as receive_float_indicator -- 本方收取_基准利率浮动方式
    ,nvl(n.receive_benchmark, o.receive_benchmark) as receive_benchmark -- 本方收取_浮动利率基准
    ,nvl(n.receive_spread, o.receive_spread) as receive_spread -- 本方收取_利率加点 利差
    ,nvl(n.receive_upper_limit, o.receive_upper_limit) as receive_upper_limit -- 本方收取_浮动利率上界
    ,nvl(n.receive_lower_limit, o.receive_lower_limit) as receive_lower_limit -- 本方收取_浮动利率下界
    ,nvl(n.receive_fixing_freq, o.receive_fixing_freq) as receive_fixing_freq -- 本方收取_重置频率
    ,nvl(n.receive_dbcp_days, o.receive_dbcp_days) as receive_dbcp_days -- 本方收取_重置日调整天数
    ,nvl(n.receive_first_end_date, o.receive_first_end_date) as receive_first_end_date -- 本方收取_首期付息日
    ,nvl(n.receive_period_adj, o.receive_period_adj) as receive_period_adj -- 本方收取_计息调整
    ,nvl(n.receive_payment_freq, o.receive_payment_freq) as receive_payment_freq -- 本方收取_支付频率
    ,nvl(n.receive_yield_curve, o.receive_yield_curve) as receive_yield_curve -- 本方收取_远期曲线
    ,nvl(n.receive_payment_adj, o.receive_payment_adj) as receive_payment_adj -- 本方收取_支付日调整
    ,nvl(n.receive_first_fix_date, o.receive_first_fix_date) as receive_first_fix_date -- 本方收取_首次利率确定日
    ,nvl(n.receive_irr_period, o.receive_irr_period) as receive_irr_period -- 本方收取_支付日程畸零天期
    ,nvl(n.pay_int_mode, o.pay_int_mode) as pay_int_mode -- 本方支付_计息方式
    ,nvl(n.pay_dc, o.pay_dc) as pay_dc -- 本方支付_计息基准
    ,nvl(n.pay_rate_type, o.pay_rate_type) as pay_rate_type -- 本方支付_利率类型
    ,nvl(n.pay_fixed_rate, o.pay_fixed_rate) as pay_fixed_rate -- 本方支付_固定利率
    ,nvl(n.pay_float_indicator, o.pay_float_indicator) as pay_float_indicator -- 本方支付_基准利率浮动方式
    ,nvl(n.pay_benchmark, o.pay_benchmark) as pay_benchmark -- 本方支付_浮动利率基准
    ,nvl(n.pay_spread, o.pay_spread) as pay_spread -- 本方支付_利率加点 利差
    ,nvl(n.pay_upper_limit, o.pay_upper_limit) as pay_upper_limit -- 本方支付_浮动利率上界
    ,nvl(n.pay_lower_limit, o.pay_lower_limit) as pay_lower_limit -- 本方支付_浮动利率下界
    ,nvl(n.pay_fixing_freq, o.pay_fixing_freq) as pay_fixing_freq -- 本方支付_重置频率
    ,nvl(n.pay_dbcp_days, o.pay_dbcp_days) as pay_dbcp_days -- 本方支付_重置日调整天数
    ,nvl(n.pay_first_end_date, o.pay_first_end_date) as pay_first_end_date -- 本方支付_首期付息日
    ,nvl(n.pay_period_adj, o.pay_period_adj) as pay_period_adj -- 本方支付_计息调整
    ,nvl(n.pay_payment_freq, o.pay_payment_freq) as pay_payment_freq -- 本方支付_支付频率
    ,nvl(n.pay_yield_curve, o.pay_yield_curve) as pay_yield_curve -- 本方支付_远期曲线
    ,nvl(n.pay_payment_adj, o.pay_payment_adj) as pay_payment_adj -- 本方支付_支付日调整
    ,nvl(n.pay_first_fix_date, o.pay_first_fix_date) as pay_first_fix_date -- 本方支付_首次利率确定日
    ,nvl(n.pay_irr_period, o.pay_irr_period) as pay_irr_period -- 本方支付_支付日程畸零天期
    ,nvl(n.serial_number, o.serial_number) as serial_number -- 交易序号
    ,nvl(n.dealer_id, o.dealer_id) as dealer_id -- 交易员ID
    ,nvl(n.counterparty_seq, o.counterparty_seq) as counterparty_seq -- 交易对手序号
    ,nvl(n.lastmodified, o.lastmodified) as lastmodified -- 最后修改时间
    ,nvl(n.keepfolder_id, o.keepfolder_id) as keepfolder_id -- 账户ID
    ,nvl(n.keepfolder_shortname, o.keepfolder_shortname) as keepfolder_shortname -- 账户名称
    ,nvl(n.settlement_type, o.settlement_type) as settlement_type -- 清算方式
    ,nvl(n.irsdeals_id_grand, o.irsdeals_id_grand) as irsdeals_id_grand -- 原始交易ID
    ,nvl(n.lastmodified_pay, o.lastmodified_pay) as lastmodified_pay -- 实收付确认的修改时间
    ,nvl(n.dn_dealer, o.dn_dealer) as dn_dealer -- 本币交易员
    ,nvl(n.status, o.status) as status -- 状态
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
from (select * from ${iol_schema}.ctms_tbs_vs_payment_irsdeals_bk where start_dt < to_date('${batch_date}','yyyymmdd') and end_dt >= to_date('${batch_date}','yyyymmdd')) o
    full join (select * from ${itl_schema}.ctms_tbs_vs_payment_irsdeals where etl_dt = to_date('${batch_date}', 'yyyymmdd')) n
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
        or o.cpty_name <> n.cpty_name
        or o.ref_number <> n.ref_number
        or o.trade_date <> n.trade_date
        or o.value_date <> n.value_date
        or o.contract_date <> n.contract_date
        or o.maturity_date <> n.maturity_date
        or o.nominal <> n.nominal
        or o.os_amount <> n.os_amount
        or o.upfront_pr <> n.upfront_pr
        or o.upfront_fee <> n.upfront_fee
        or o.upfront_payment_date <> n.upfront_payment_date
        or o.amortization <> n.amortization
        or o.reduce_start_date <> n.reduce_start_date
        or o.reduce_freq <> n.reduce_freq
        or o.reduce_type <> n.reduce_type
        or o.reduce_rate <> n.reduce_rate
        or o.reduce_amt <> n.reduce_amt
        or o.tax_amt <> n.tax_amt
        or o.fee <> n.fee
        or o.broker_amt <> n.broker_amt
        or o.remark <> n.remark
        or o.receive_int_mode <> n.receive_int_mode
        or o.receive_dc <> n.receive_dc
        or o.receive_rate_type <> n.receive_rate_type
        or o.receive_fixed_rate <> n.receive_fixed_rate
        or o.receive_float_indicator <> n.receive_float_indicator
        or o.receive_benchmark <> n.receive_benchmark
        or o.receive_spread <> n.receive_spread
        or o.receive_upper_limit <> n.receive_upper_limit
        or o.receive_lower_limit <> n.receive_lower_limit
        or o.receive_fixing_freq <> n.receive_fixing_freq
        or o.receive_dbcp_days <> n.receive_dbcp_days
        or o.receive_first_end_date <> n.receive_first_end_date
        or o.receive_period_adj <> n.receive_period_adj
        or o.receive_payment_freq <> n.receive_payment_freq
        or o.receive_yield_curve <> n.receive_yield_curve
        or o.receive_payment_adj <> n.receive_payment_adj
        or o.receive_first_fix_date <> n.receive_first_fix_date
        or o.receive_irr_period <> n.receive_irr_period
        or o.pay_int_mode <> n.pay_int_mode
        or o.pay_dc <> n.pay_dc
        or o.pay_rate_type <> n.pay_rate_type
        or o.pay_fixed_rate <> n.pay_fixed_rate
        or o.pay_float_indicator <> n.pay_float_indicator
        or o.pay_benchmark <> n.pay_benchmark
        or o.pay_spread <> n.pay_spread
        or o.pay_upper_limit <> n.pay_upper_limit
        or o.pay_lower_limit <> n.pay_lower_limit
        or o.pay_fixing_freq <> n.pay_fixing_freq
        or o.pay_dbcp_days <> n.pay_dbcp_days
        or o.pay_first_end_date <> n.pay_first_end_date
        or o.pay_period_adj <> n.pay_period_adj
        or o.pay_payment_freq <> n.pay_payment_freq
        or o.pay_yield_curve <> n.pay_yield_curve
        or o.pay_payment_adj <> n.pay_payment_adj
        or o.pay_first_fix_date <> n.pay_first_fix_date
        or o.pay_irr_period <> n.pay_irr_period
        or o.serial_number <> n.serial_number
        or o.dealer_id <> n.dealer_id
        or o.counterparty_seq <> n.counterparty_seq
        or o.lastmodified <> n.lastmodified
        or o.keepfolder_id <> n.keepfolder_id
        or o.keepfolder_shortname <> n.keepfolder_shortname
        or o.settlement_type <> n.settlement_type
        or o.irsdeals_id_grand <> n.irsdeals_id_grand
        or o.lastmodified_pay <> n.lastmodified_pay
        or o.dn_dealer <> n.dn_dealer
        or o.status <> n.status
    )
;
commit;

-- 3.2 get unchange, alter(close) data and put into temp table
whenever sqlerror exit sql.sqlcode;
insert /*+ append */ all
    when end_dt <= to_date('${batch_date}', 'yyyymmdd') then
        into ${iol_schema}.ctms_tbs_vs_payment_irsdeals_cl(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,ref_number -- 合约编号
            ,trade_date -- 交易日期
            ,value_date -- 起息日
            ,contract_date -- 签约日
            ,maturity_date -- 到期日
            ,nominal -- 交易面额
            ,os_amount -- 剩余金额
            ,upfront_pr -- 前置金付款方式
            ,upfront_fee -- 前置金
            ,upfront_payment_date -- 前置金付款日
            ,amortization -- 名义本金是否重置
            ,reduce_start_date -- 首期名义本金重置日
            ,reduce_freq -- 名义本金重置频率
            ,reduce_type -- 名义本金重置形态
            ,reduce_rate -- 名义本金重置比率
            ,reduce_amt -- 名义本金重置金额
            ,tax_amt -- 税金
            ,fee -- 手续费
            ,broker_amt -- 佣金
            ,remark -- 备注
            ,receive_int_mode -- 本方收取_计息方式
            ,receive_dc -- 本方收取_计息基准
            ,receive_rate_type -- 本方收取_利率类型
            ,receive_fixed_rate -- 本方收取_固定利率
            ,receive_float_indicator -- 本方收取_基准利率浮动方式
            ,receive_benchmark -- 本方收取_浮动利率基准
            ,receive_spread -- 本方收取_利率加点 利差
            ,receive_upper_limit -- 本方收取_浮动利率上界
            ,receive_lower_limit -- 本方收取_浮动利率下界
            ,receive_fixing_freq -- 本方收取_重置频率
            ,receive_dbcp_days -- 本方收取_重置日调整天数
            ,receive_first_end_date -- 本方收取_首期付息日
            ,receive_period_adj -- 本方收取_计息调整
            ,receive_payment_freq -- 本方收取_支付频率
            ,receive_yield_curve -- 本方收取_远期曲线
            ,receive_payment_adj -- 本方收取_支付日调整
            ,receive_first_fix_date -- 本方收取_首次利率确定日
            ,receive_irr_period -- 本方收取_支付日程畸零天期
            ,pay_int_mode -- 本方支付_计息方式
            ,pay_dc -- 本方支付_计息基准
            ,pay_rate_type -- 本方支付_利率类型
            ,pay_fixed_rate -- 本方支付_固定利率
            ,pay_float_indicator -- 本方支付_基准利率浮动方式
            ,pay_benchmark -- 本方支付_浮动利率基准
            ,pay_spread -- 本方支付_利率加点 利差
            ,pay_upper_limit -- 本方支付_浮动利率上界
            ,pay_lower_limit -- 本方支付_浮动利率下界
            ,pay_fixing_freq -- 本方支付_重置频率
            ,pay_dbcp_days -- 本方支付_重置日调整天数
            ,pay_first_end_date -- 本方支付_首期付息日
            ,pay_period_adj -- 本方支付_计息调整
            ,pay_payment_freq -- 本方支付_支付频率
            ,pay_yield_curve -- 本方支付_远期曲线
            ,pay_payment_adj -- 本方支付_支付日调整
            ,pay_first_fix_date -- 本方支付_首次利率确定日
            ,pay_irr_period -- 本方支付_支付日程畸零天期
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,counterparty_seq -- 交易对手序号
            ,lastmodified -- 最后修改时间
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,settlement_type -- 清算方式
            ,irsdeals_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,dn_dealer -- 本币交易员
            ,status -- 状态
            ,start_dt -- 开始时间
            ,end_dt -- 结束时间
            ,id_mark -- 增删标志
            ,etl_timestamp -- ETL处理时间戳
        )
    else
        into ${iol_schema}.ctms_tbs_vs_payment_irsdeals_op(
            deal_id -- 引用表ID
            ,deal_name -- 引用表名
            ,aspclient_id -- 部门编号
            ,portfolio_id -- 交易组别
            ,portfolio_name -- 交易组别名称
            ,cpty_name -- 交易对手
            ,ref_number -- 合约编号
            ,trade_date -- 交易日期
            ,value_date -- 起息日
            ,contract_date -- 签约日
            ,maturity_date -- 到期日
            ,nominal -- 交易面额
            ,os_amount -- 剩余金额
            ,upfront_pr -- 前置金付款方式
            ,upfront_fee -- 前置金
            ,upfront_payment_date -- 前置金付款日
            ,amortization -- 名义本金是否重置
            ,reduce_start_date -- 首期名义本金重置日
            ,reduce_freq -- 名义本金重置频率
            ,reduce_type -- 名义本金重置形态
            ,reduce_rate -- 名义本金重置比率
            ,reduce_amt -- 名义本金重置金额
            ,tax_amt -- 税金
            ,fee -- 手续费
            ,broker_amt -- 佣金
            ,remark -- 备注
            ,receive_int_mode -- 本方收取_计息方式
            ,receive_dc -- 本方收取_计息基准
            ,receive_rate_type -- 本方收取_利率类型
            ,receive_fixed_rate -- 本方收取_固定利率
            ,receive_float_indicator -- 本方收取_基准利率浮动方式
            ,receive_benchmark -- 本方收取_浮动利率基准
            ,receive_spread -- 本方收取_利率加点 利差
            ,receive_upper_limit -- 本方收取_浮动利率上界
            ,receive_lower_limit -- 本方收取_浮动利率下界
            ,receive_fixing_freq -- 本方收取_重置频率
            ,receive_dbcp_days -- 本方收取_重置日调整天数
            ,receive_first_end_date -- 本方收取_首期付息日
            ,receive_period_adj -- 本方收取_计息调整
            ,receive_payment_freq -- 本方收取_支付频率
            ,receive_yield_curve -- 本方收取_远期曲线
            ,receive_payment_adj -- 本方收取_支付日调整
            ,receive_first_fix_date -- 本方收取_首次利率确定日
            ,receive_irr_period -- 本方收取_支付日程畸零天期
            ,pay_int_mode -- 本方支付_计息方式
            ,pay_dc -- 本方支付_计息基准
            ,pay_rate_type -- 本方支付_利率类型
            ,pay_fixed_rate -- 本方支付_固定利率
            ,pay_float_indicator -- 本方支付_基准利率浮动方式
            ,pay_benchmark -- 本方支付_浮动利率基准
            ,pay_spread -- 本方支付_利率加点 利差
            ,pay_upper_limit -- 本方支付_浮动利率上界
            ,pay_lower_limit -- 本方支付_浮动利率下界
            ,pay_fixing_freq -- 本方支付_重置频率
            ,pay_dbcp_days -- 本方支付_重置日调整天数
            ,pay_first_end_date -- 本方支付_首期付息日
            ,pay_period_adj -- 本方支付_计息调整
            ,pay_payment_freq -- 本方支付_支付频率
            ,pay_yield_curve -- 本方支付_远期曲线
            ,pay_payment_adj -- 本方支付_支付日调整
            ,pay_first_fix_date -- 本方支付_首次利率确定日
            ,pay_irr_period -- 本方支付_支付日程畸零天期
            ,serial_number -- 交易序号
            ,dealer_id -- 交易员ID
            ,counterparty_seq -- 交易对手序号
            ,lastmodified -- 最后修改时间
            ,keepfolder_id -- 账户ID
            ,keepfolder_shortname -- 账户名称
            ,settlement_type -- 清算方式
            ,irsdeals_id_grand -- 原始交易ID
            ,lastmodified_pay -- 实收付确认的修改时间
            ,dn_dealer -- 本币交易员
            ,status -- 状态
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
    ,o.ref_number -- 合约编号
    ,o.trade_date -- 交易日期
    ,o.value_date -- 起息日
    ,o.contract_date -- 签约日
    ,o.maturity_date -- 到期日
    ,o.nominal -- 交易面额
    ,o.os_amount -- 剩余金额
    ,o.upfront_pr -- 前置金付款方式
    ,o.upfront_fee -- 前置金
    ,o.upfront_payment_date -- 前置金付款日
    ,o.amortization -- 名义本金是否重置
    ,o.reduce_start_date -- 首期名义本金重置日
    ,o.reduce_freq -- 名义本金重置频率
    ,o.reduce_type -- 名义本金重置形态
    ,o.reduce_rate -- 名义本金重置比率
    ,o.reduce_amt -- 名义本金重置金额
    ,o.tax_amt -- 税金
    ,o.fee -- 手续费
    ,o.broker_amt -- 佣金
    ,o.remark -- 备注
    ,o.receive_int_mode -- 本方收取_计息方式
    ,o.receive_dc -- 本方收取_计息基准
    ,o.receive_rate_type -- 本方收取_利率类型
    ,o.receive_fixed_rate -- 本方收取_固定利率
    ,o.receive_float_indicator -- 本方收取_基准利率浮动方式
    ,o.receive_benchmark -- 本方收取_浮动利率基准
    ,o.receive_spread -- 本方收取_利率加点 利差
    ,o.receive_upper_limit -- 本方收取_浮动利率上界
    ,o.receive_lower_limit -- 本方收取_浮动利率下界
    ,o.receive_fixing_freq -- 本方收取_重置频率
    ,o.receive_dbcp_days -- 本方收取_重置日调整天数
    ,o.receive_first_end_date -- 本方收取_首期付息日
    ,o.receive_period_adj -- 本方收取_计息调整
    ,o.receive_payment_freq -- 本方收取_支付频率
    ,o.receive_yield_curve -- 本方收取_远期曲线
    ,o.receive_payment_adj -- 本方收取_支付日调整
    ,o.receive_first_fix_date -- 本方收取_首次利率确定日
    ,o.receive_irr_period -- 本方收取_支付日程畸零天期
    ,o.pay_int_mode -- 本方支付_计息方式
    ,o.pay_dc -- 本方支付_计息基准
    ,o.pay_rate_type -- 本方支付_利率类型
    ,o.pay_fixed_rate -- 本方支付_固定利率
    ,o.pay_float_indicator -- 本方支付_基准利率浮动方式
    ,o.pay_benchmark -- 本方支付_浮动利率基准
    ,o.pay_spread -- 本方支付_利率加点 利差
    ,o.pay_upper_limit -- 本方支付_浮动利率上界
    ,o.pay_lower_limit -- 本方支付_浮动利率下界
    ,o.pay_fixing_freq -- 本方支付_重置频率
    ,o.pay_dbcp_days -- 本方支付_重置日调整天数
    ,o.pay_first_end_date -- 本方支付_首期付息日
    ,o.pay_period_adj -- 本方支付_计息调整
    ,o.pay_payment_freq -- 本方支付_支付频率
    ,o.pay_yield_curve -- 本方支付_远期曲线
    ,o.pay_payment_adj -- 本方支付_支付日调整
    ,o.pay_first_fix_date -- 本方支付_首次利率确定日
    ,o.pay_irr_period -- 本方支付_支付日程畸零天期
    ,o.serial_number -- 交易序号
    ,o.dealer_id -- 交易员ID
    ,o.counterparty_seq -- 交易对手序号
    ,o.lastmodified -- 最后修改时间
    ,o.keepfolder_id -- 账户ID
    ,o.keepfolder_shortname -- 账户名称
    ,o.settlement_type -- 清算方式
    ,o.irsdeals_id_grand -- 原始交易ID
    ,o.lastmodified_pay -- 实收付确认的修改时间
    ,o.dn_dealer -- 本币交易员
    ,o.status -- 状态
    ,o.start_dt -- 开始时间
    ,case when n.start_dt is not null then to_date('${batch_date}', 'yyyymmdd')
          when o.end_dt >= to_date('${batch_date}','yyyymmdd') then to_date('20991231','yyyymmdd')
          else o.end_dt
     end as end_dt -- 结束时间
    ,o.id_mark -- 增删标志
    ,to_timestamp('${batch_timestamp}', 'yyyy-mm-dd hh24:mi:ss.ff6') as etl_timestamp -- ETL处理时间
from ${iol_schema}.ctms_tbs_vs_payment_irsdeals_bk o
    left join ${iol_schema}.ctms_tbs_vs_payment_irsdeals_op n
        on
            o.deal_id = n.deal_id
            and o.deal_name = n.deal_name
            and o.end_dt >= to_date('${batch_date}','yyyymmdd')
    left join ${iol_schema}.ctms_tbs_vs_payment_irsdeals_cl d
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
-- truncate table ${iol_schema}.ctms_tbs_vs_payment_irsdeals;

-- 4.2 exchange partition
alter table ${iol_schema}.ctms_tbs_vs_payment_irsdeals exchange partition p_19000101 with table ${iol_schema}.ctms_tbs_vs_payment_irsdeals_cl;
alter table ${iol_schema}.ctms_tbs_vs_payment_irsdeals exchange partition p_20991231 with table ${iol_schema}.ctms_tbs_vs_payment_irsdeals_op;

-- 5.1 table grant
whenever sqlerror exit sql.sqlcode;
-- grant select on ${iol_schema}.ctms_tbs_vs_payment_irsdeals to ${iml_schema};

-- 5.2 drop temp table
-- it is no need to check when this segment SQL was return faied
whenever sqlerror continue none ;
drop table ${iol_schema}.ctms_tbs_vs_payment_irsdeals_op purge;
drop table ${iol_schema}.ctms_tbs_vs_payment_irsdeals_cl purge;

whenever sqlerror exit sql.sqlcode;
drop table ${iol_schema}.ctms_tbs_vs_payment_irsdeals_bk purge;

-- 6 gater table status
whenever sqlerror exit sql.sqlcode;
exec dbms_stats.gather_table_stats(ownname => '${iol_schema}',tabname => 'ctms_tbs_vs_payment_irsdeals',partname => 'p_20991231', granularity => 'PARTITION', degree => 8, cascade => true);
